#import "ChangePasswordViewController.h"

#import "WebServiceManager.h"
#import "MBProgressHUD.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrCaptions = [[NSMutableArray alloc] init];
    
    [arrCaptions addObject:@"Old Password"];
    [arrCaptions addObject:@"New Password"];
    [arrCaptions addObject:@"Confirm Password"];
    
    cellArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[arrCaptions count];i++)
    {
        [cellArray addObject:[NSNull null]];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onCancel:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forgot Password" message:@"Are you sure to cancel forget password process? All entered data will be lost by pressing Yes." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onSubmit:(id)sender {
    
    NSIndexPath *aIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:aIndexPath];
    UITextField *txtOldPassword = (UITextField *)[cell.contentView viewWithTag:10000];
    
    aIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:aIndexPath];
    UITextField *txtNewPassword = (UITextField *)[cell.contentView viewWithTag:10000];
    
    aIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:aIndexPath];
    UITextField *txtConfirmPassword = (UITextField *)[cell.contentView viewWithTag:10000];
    
    if ([txtOldPassword.text length] == 0 || [txtNewPassword.text length] == 0 || [txtConfirmPassword.text length] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forget Password Error" message:@"All field are required to change password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    NSString *strPwd = [[NSUserDefaults standardUserDefaults] valueForKey:S_Password];
    if (![strPwd isEqualToString:txtOldPassword.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"Old Password is incorrect" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if (![txtNewPassword.text isEqualToString:txtConfirmPassword.text])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"Password and Confirm Password must be same" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSString *strNewPass = txtNewPassword.text;
    NSDictionary *parameter = @{@"userid":userid, @"password": strNewPass};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[WebServiceManager sharedInstance] sendPostRequest:ChangePassword param:parameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSString *strMessage = [dicResponse valueForKey:@"message"];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSUserDefaults standardUserDefaults] setValue:strNewPass forKey:S_Password];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Change password Failed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    
}



#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCaptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[cellArray objectAtIndex:indexPath.row];
    
    if(![[cellArray objectAtIndex:indexPath.row] isEqual:[NSNull null]])
    {
        cell=[cellArray objectAtIndex:indexPath.row];
    }
    
    if([[cellArray objectAtIndex:indexPath.row] isEqual:[NSNull null]])
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"anyCell"];
        
        UITextField *txtValue = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        txtValue.borderStyle = UITextBorderStyleNone;
        txtValue.layer.cornerRadius = 0.0;
        txtValue.layer.borderColor = [UIColor colorWithRed:80/255.0f green:84/255.0f blue:116/255.0f alpha:1.0f].CGColor;
        txtValue.layer.borderWidth = 1.0;
        txtValue.textColor = [UIColor whiteColor];
        txtValue.tag = 10000;
        txtValue.secureTextEntry = YES;
        txtValue.delegate  = self;
        txtValue.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        txtValue.backgroundColor = [UIColor clearColor];
        txtValue.font = [UIFont fontWithName:@"Avenir Book" size:16];
        
        if (indexPath.row == 3 || indexPath.row == 4)
        {
            txtValue.secureTextEntry = YES;
        }
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        aView.backgroundColor = [UIColor clearColor];
        
        [txtValue setLeftView:aView];
        [txtValue setLeftViewMode:UITextFieldViewModeAlways];
        
        if ([txtValue respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor lightGrayColor];
            txtValue.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[arrCaptions objectAtIndex:indexPath.row] attributes:@{NSForegroundColorAttributeName: color}];
        }
        [cell.contentView addSubview:txtValue];
        [cellArray  replaceObjectAtIndex:indexPath.row withObject:cell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
