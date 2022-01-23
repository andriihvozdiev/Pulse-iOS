#import "ResetPasswordVC.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"

@interface ResetPasswordVC ()
{
    UITextField *selectedTextField;
}
@end

@implementation ResetPasswordVC
@synthesize openUrlID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    selectedTextField = self.txtPassword;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShown:) name:UIKeyboardDidShowNotification object:nil];
    
    if (openUrlID) {
        
        openUrlID = [openUrlID stringByReplacingOccurrencesOfString:@"pulsepassword://" withString:@""];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initView {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [self.lblTitle setFont:[UIFont fontWithName:[self.lblTitle.font fontName]  size:(24 * screenSize.height / 667.0f)]];
    
    // white placeholder
    NSDictionary * attributes = (NSMutableDictionary *)[ (NSAttributedString *)self.self.txtPassword.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
    
    NSMutableDictionary * newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    
    [newAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    // Set new text with extracted attributes
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtPassword.attributedPlaceholder string] attributes:newAttributes];
    self.txtConfirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtConfirmPassword.attributedPlaceholder string] attributes:newAttributes];
    
    self.viewPassword.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewPassword.layer.borderWidth = 1.0;
    self.viewPassword.layer.cornerRadius = 5.0f;
    
    self.viewConfirmPassword.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewConfirmPassword.layer.borderWidth = 1.0;
    self.viewConfirmPassword.layer.cornerRadius = 5.0f;
    
    self.btnSubmit.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSubmit.layer.borderWidth = 1.0;
    self.btnSubmit.layer.cornerRadius = 5.0f;
}


- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmit:(id)sender {
    if ([self.txtPassword.text length] == 0)
    {
        [self showDefaultAlert:@"Forgot Password Error" withMessage:@"You have to input new password to change password."];
        return;
    }
    
    if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text])
    {
        [self showDefaultAlert:@"Password Error" withMessage:@"Password and Confirm Password must be same"];
        return;
    }
    
    NSString *userid = openUrlID;
    NSString *strNewPass = self.txtPassword.text;
    NSDictionary *parameter = @{@"userid":userid, @"password": strNewPass};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[WebServiceManager sharedInstance] sendPostRequest:ChangePassword param:parameter completionHandler:^(id obj) {
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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

#pragma mark - textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    selectedTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtPassword) {
        [self.txtConfirmPassword becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    return YES;
}

-(void)keyShown:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float keyboardHeight = keyboardFrameBeginRect.size.height;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = [selectedTextField superview].frame;
    float offset = keyboardHeight - (height - rect.origin.y - rect.size.height) + 100;
    
    [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
}

#pragma mark - show default alert

-(void) showDefaultAlert:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
