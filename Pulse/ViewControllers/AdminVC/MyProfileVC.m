#import "MyProfileVC.h"
#import "MyProfileCell.h"
#import "MyProfileTouchIDCell.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "HapticHelper.h"

@interface MyProfileVC ()
{
    Personnel *personnel;
}
@end

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    
    NSString *strUserID = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    int userid = [strUserID intValue];
    personnel = [[DBManager sharedInstance] getPersonnel:userid];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
}

#pragma mark -
-(void) showSyncStatus
{
    [self.redStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.yellowStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.blueStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.greenStatusView setBackgroundColor:[UIColor lightGrayColor]];
    
    switch ([AppData sharedInstance].syncStatus) {
        case SyncFailed:
            [self.redStatusView setBackgroundColor:[UIColor redColor]];
            break;
        case UploadFailed:
            [self.yellowStatusView setBackgroundColor:[UIColor yellowColor]];
            break;
        case Syncing:
            [self.blueStatusView setBackgroundColor:[UIColor blueColor]];
            break;
        case Synced:
            [self.greenStatusView setBackgroundColor:[UIColor greenColor]];
            break;
        default:
            break;
    }
}

#pragma mark - ChangedStatusDelegate
-(void)changedSyncStatus
{
    [self showSyncStatus];
}


#pragma mark - tableview datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    switch (row) {
        case 0:
        {
            MyProfileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyProfileCell" forIndexPath:indexPath];
            cell.lblTitle.text = @"User Name";
            cell.lblValue.text = personnel.employeeName;
            return cell;
            break;
        }
        case 1:
        {
            MyProfileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyProfileCell" forIndexPath:indexPath];
            cell.lblTitle.text = @"Email";
            cell.lblValue.text = personnel.email;
            return cell;
            break;
        }
        case 2:
        {
            MyProfileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyProfileCell" forIndexPath:indexPath];
            cell.lblTitle.text = @"Department";
            cell.lblValue.text = personnel.department;
            return cell;
            break;
        }
        case 3:
        {
            MyProfileTouchIDCell *touchIDCell = [self.tableView dequeueReusableCellWithIdentifier:@"MyProfileTouchIDCell" forIndexPath:indexPath];
            NSString *activateTouchID = [[NSUserDefaults standardUserDefaults] valueForKey:S_ActivateTouchID];
            
            if (activateTouchID && [activateTouchID isEqualToString:@"yes"]) {
                [touchIDCell.segTouchID setSelectedSegmentIndex:0];
            } else {
                [touchIDCell.segTouchID setSelectedSegmentIndex:1];
            }
            
            return touchIDCell;
            break;
        }
        default:
            break;
    }
    
    return nil;
}

#pragma mark - button events

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onStoplight:(id)sender {
    [[AppData sharedInstance] mannualSync];
}

- (IBAction)onSyncForFailedData:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [HapticHelper generateFeedback:FeedbackType_Impact_Heavy];
        [[AppData sharedInstance] doSyncFailedData];
    }
}

- (IBAction)onActivateTouchID:(id)sender {
    
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    NSInteger selectedIndex = [seg selectedSegmentIndex];
    
    if (selectedIndex == 0) {
        [self authenticateUser];
    } else {
        [self disableTouchID];
    }
}

-(void)authenticateUser
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Place your finger on the Home button.";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError *error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self enableTouchID];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showDefaultAlert:@"Touch ID cannot be active." withMessage:@"Undeclared Touch ID."];
                    [self disableTouchID];
                });
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showDefaultAlert:@"Touch ID cannot be active." withMessage:@"Please set your Touch ID & Passcode on Settings"];
            [self disableTouchID];
        });
    }
}

-(void) enableTouchID
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *email = [userdefaults valueForKey:S_Email];
    NSString *pass = [userdefaults valueForKey:S_Password];
    
    [userdefaults setValue:@"yes" forKey:S_ActivateTouchID];
    [userdefaults setValue:email forKey:S_TouchIDEmail];
    [userdefaults setValue:pass forKey:S_TouchIDPassword];
    
    [self showDefaultAlert:@"Touch ID is active." withMessage:@"You can log in with Touch ID."];
    [self.tableView reloadData];
}

-(void) disableTouchID
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    [userdefaults setValue:@"no" forKey:S_ActivateTouchID];
    [userdefaults setValue:nil forKey:S_TouchIDEmail];
    [userdefaults setValue:nil forKey:S_TouchIDPassword];
    
    [self.tableView reloadData];
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
