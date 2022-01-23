#import "LoginViewController.h"
#import "MainTabbarViewController.h"
#import "SignupViewController.h"

#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController ()
{
    UITextField *selectedTextField;
    NSDictionary *dicLoginData;
    NSString *passcodeForConfirm;
}
@end

@implementation LoginViewController
@synthesize openUrlID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[AppData sharedInstance] initialize];
    
    [self initView];
    [self.viewLoginWithTouchID setHidden:YES];
    
    selectedTextField = self.txtEmail;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShown:) name:UIKeyboardDidShowNotification object:nil];
    
    if (openUrlID) {
        
        openUrlID = [openUrlID stringByReplacingOccurrencesOfString:@"pulseverification://" withString:@""];
        [self loginWithUserID:openUrlID];
    }
    passcodeForConfirm = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.txtEmail.text = @"";
    self.txtPassword.text = @"";
    
    NSString *activateTouchID = [[NSUserDefaults standardUserDefaults] valueForKey:S_ActivateTouchID];
    
    if (activateTouchID && [activateTouchID isEqualToString:@"yes"])
    {
        [self.viewLoginWithTouchID setHidden:NO];
    }
    
    if (self.fromSignup) {
        [self.btnGotoSignup setHidden:YES];
    }
}

-(void) initView {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [self.lblTitle setFont:[UIFont systemFontOfSize:24 * screenSize.height / 667.0f weight:0.2f]];
    
    // white placeholder
    NSDictionary * attributes = (NSMutableDictionary *)[ (NSAttributedString *)self.txtEmail.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];

    NSMutableDictionary * newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    
    [newAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    // Set new text with extracted attributes
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtEmail.attributedPlaceholder string] attributes:newAttributes];
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtPassword.attributedPlaceholder string] attributes:newAttributes];
    
    self.viewEmail.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewEmail.layer.borderWidth = 1.0;
    self.viewEmail.layer.cornerRadius = 5.0f;
    
    self.viewPassword.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewPassword.layer.borderWidth = 1.0;
    self.viewPassword.layer.cornerRadius = 5.0f;
    
    self.btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnLogin.layer.borderWidth = 1.0;
    self.btnLogin.layer.cornerRadius = 5.0f;
    
    self.btnLoginWithTouchID.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnLoginWithTouchID.layer.borderWidth = 1.0f;
    self.btnLoginWithTouchID.layer.cornerRadius = 5.0f;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"LoginToSignUp"]) {
        SignupViewController *vc = [segue destinationViewController];
        vc.fromLogin = YES;
    }
}

#pragma mark - button events

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onLogin:(id)sender {

    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    [self login];
}

-(void)login {
    NSString *strEmail = self.txtEmail.text;
    NSString *strPassword = self.txtPassword.text;
    
    if ([strEmail isEqual:@""]) {
        [self showDefaultAlert:nil withMessage:@"Invalid Email"];
        return;
    }
    if ([strPassword isEqual:@""]) {
        [self showDefaultAlert:nil withMessage:@"Invalid Password"];
        return;
    }
    
    [self login:strEmail password:strPassword];
}

- (IBAction)onLoginWithTouchID:(id)sender {
    
    [self authenticateUser];
}

#pragma mark - login with email and password
-(void) login:(NSString*)email password:(NSString*)password
{
    if ([self validateEmail:email]) {
        NSDictionary *parameters = @{@"email": email, @"password": password};
        [self login:parameters];
    } else {
        [self showDefaultAlert:nil withMessage:@"Invalid email"];
    }
}


#pragma mark - Login with User ID

-(void) loginWithUserID:(NSString*)userid
{
    NSDictionary *parameters = @{@"userid": openUrlID};
    [self login:parameters];
}

#pragma mark - login with Touch ID
-(void)authenticateUser
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Place your finger on the Home button.";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:S_TouchIDEmail];
                    NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:S_TouchIDPassword];
                    [self login:email password:pass];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showDefaultAlert:@"Login Failed" withMessage:@"Undeclared Touch ID."];
                });
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showDefaultAlert:@"Cannot log in" withMessage:@"Please set your Touch ID & Passcode on Settings"];
        });
    }
}


#pragma mark -
-(void) login:(NSDictionary*)parameters
{
    dicLoginData = [[NSDictionary alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([WebServiceManager connectedToNetwork]) {
        [[WebServiceManager sharedInstance] loginWithData:parameters completionHandler:^(id obj) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // get data....
            NSDictionary *dicResponse = (NSDictionary*)obj;
            NSLog(@"%@", dicResponse);
            NSString *message = [dicResponse objectForKey:@"message"];
            if ([message isEqualToString:@"Unverified Email"])
            {
                [self showDefaultAlert:@"Unverified Email" withMessage:@"Please check your inbox to verify your email."];
                return;
            }
            
            NSDictionary *dicData = [dicResponse objectForKey:@"data"];
            
            NSLog(@"%@", dicData);
            dicLoginData = dicData;
            
            [self registerSyncPassword];
            
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showDefaultAlert:@"Login Failed" withMessage:@"Please try again."];
            
        }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self showDefaultAlert:nil withMessage:@"Internet Connection Failed"];
    }
}

-(void) registerSyncPassword
{
    passcodeForConfirm = @"";
    TOPasscodeViewController *passcodeViewController = [[TOPasscodeViewController alloc] initWithStyle:TOPasscodeViewStyleTranslucentDark passcodeType:TOPasscodeTypeFourDigits];
    [passcodeViewController.cancelButton setHidden:NO];
    passcodeViewController.delegate = self;
    
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

- (void)confirmSyncPassword {
    
    TOPasscodeViewController *passcodeViewController = [[TOPasscodeViewController alloc] initWithStyle:TOPasscodeViewStyleTranslucentDark passcodeType:TOPasscodeTypeFourDigits];
    
    [passcodeViewController.passcodeView.titleLabel setText:@"Re-enter Passcode"];
    [passcodeViewController.cancelButton setHidden:NO];
    passcodeViewController.delegate = self;
    
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

#pragma mark - TOPasscodeViewControllerDelegate

-(void)didTapCancelInPasscodeViewController:(TOPasscodeViewController *)passcodeViewController {
    [passcodeViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)passcodeViewController:(TOPasscodeViewController *)passcodeViewController isCorrectCode:(NSString *)code
{
    if (passcodeForConfirm == nil || [passcodeForConfirm isEqualToString:@""]) {
        passcodeForConfirm = code;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self confirmSyncPassword];
        });
        return YES;
    } else {
        if (![passcodeForConfirm isEqualToString:code]) {
            passcodeForConfirm = @"";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self registerSyncPassword];
            });
            return YES;
        }
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    if (code && ![code isEqualToString:@""]) {
        [userdefaults setValue:code forKey:S_SyncPassword];
        [passcodeViewController dismissViewControllerAnimated:YES completion:nil];
        
        // save login data
        NSString *userid = [dicLoginData valueForKey:@"userid"];
        NSString *email = [dicLoginData valueForKey:@"email"];
        NSString *password = [dicLoginData valueForKey:@"password"];
        
        NSArray *arrRoutes = [dicLoginData valueForKey:@"routes"];
        NSArray *arrOperatings = [dicLoginData valueForKey:@"operatings"];
        NSArray *arrOwns = [dicLoginData valueForKey:@"owns"];
        NSString *isEmptyPermission = [dicLoginData valueForKey:@"emptypermission"];
        NSString *strDepartment = [dicLoginData valueForKey:@"department"];
        
        [userdefaults setValue:userid forKey:S_UserID];
        [userdefaults setValue:email forKey:S_Email];
        [userdefaults setValue:password forKey:S_Password];
        
        [userdefaults setValue:arrRoutes forKey:S_Routes];
        [userdefaults setValue:arrOperatings forKey:S_Operatings];
        [userdefaults setValue:arrOwns forKey:S_Owns];
        [userdefaults setValue:isEmptyPermission forKey:S_EmptyPermission];
        [userdefaults setValue:strDepartment forKey:S_Downloaded];
        [userdefaults synchronize];
        
        // download all data
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Downloading Data";
        [AppData sharedInstance].downloadedDelegate = self;
        [[AppData sharedInstance] downloadData:YES];
    } else {
        [userdefaults setValue:nil forKey:S_SyncPassword];
        return NO;
    }
    return YES;
}

#pragma mark - DownloadedDelegate
-(void) downloadedCommonData
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.window.rootViewController isKindOfClass:[MainTabbarViewController class]]) {
        return;
    }
    
    [userdefaults setValue:@"60" forKey:S_SyncInterval];
    [[AppData sharedInstance] startAutoSyncing];
    
    MainTabbarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabbarViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    selectedTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
    } else {
        [self login];
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

#pragma mark - validate email
- (BOOL) validateEmail: (NSString *) candidate {
    
    if([[candidate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ] length] == 0)
        return YES;
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
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
