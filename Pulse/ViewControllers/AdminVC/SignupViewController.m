#import "SignupViewController.h"
#import "LoginViewController.h"
#import "SplashViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>


@interface SignupViewController ()
{
    UITextField *selectedTextField;
    BOOL activateTouchID;
}
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    selectedTextField = self.txtEmail;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    activateTouchID = NO;
    
    if (self.fromLogin) {
        [self.btnGotoLogin setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) initView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [self.lblTitle setFont:[UIFont systemFontOfSize:24 * screenSize.height / 667.0f weight:0.2f]];
    
    // textfield placeholder
    NSDictionary * attributes = (NSMutableDictionary *)[ (NSAttributedString *)self.self.txtEmail.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
    NSMutableDictionary * newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    [newAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    // Set new text with extracted attributes
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtEmail.attributedPlaceholder string] attributes:newAttributes];
    self.txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtName.attributedPlaceholder string] attributes:newAttributes];
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtPassword.attributedPlaceholder string] attributes:newAttributes];
    self.txtConfirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtConfirmPassword.attributedPlaceholder string] attributes:newAttributes];
    
    self.viewEmail.layer.borderWidth = 1.0f;
    self.viewEmail.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewEmail.layer.cornerRadius = 5.0f;
    
    self.viewName.layer.borderWidth = 1.0f;
    self.viewName.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewName.layer.cornerRadius = 5.0f;
    
    self.viewPassword.layer.borderWidth = 1.0f;
    self.viewPassword.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewPassword.layer.cornerRadius = 5.0f;
    
    self.viewConfirmPassword.layer.borderWidth = 1.0f;
    self.viewConfirmPassword.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewConfirmPassword.layer.cornerRadius = 5.0f;
    
    self.btnActivateTouchID.layer.borderWidth = 1.0f;
    self.btnActivateTouchID.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnActivateTouchID.layer.cornerRadius = 5.0f;
    
    self.btnSignup.layer.borderWidth = 1.0f;
    self.btnSignup.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSignup.layer.cornerRadius = 5.0f;
    
}

#pragma mark -
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"SignupToLogin"]) {
        LoginViewController *vc = [segue destinationViewController];
        vc.fromSignup = YES;
    }
}


#pragma mark - button events

- (IBAction)onActivateTouchID:(id)sender {
    NSString *strEmail = self.txtEmail.text;
    NSString *strName = self.txtName.text;
    NSString *strPassword = self.txtPassword.text;
    NSString *strConfirmPassword = self.txtConfirmPassword.text;
    
    if ([strEmail isEqual:@""] || [strName isEqual:@""] || [strPassword isEqual:@""]) {
        [self showDefaultAlert:@"" withMessage:@"Please input all fields."];
        return;
    }
    
    if (![strPassword isEqualToString:strConfirmPassword]) {
        [self showDefaultAlert:@"" withMessage:@"Confirm Password failed."];
        return;
    }
    
    [self authenticateUser];
}

- (IBAction)onSignup:(id)sender {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    [self.txtName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    
    [self signUp];
}


- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
                
                    activateTouchID = YES;
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Touch ID is activated." message:@"Please select \"OK\" to Sign Up." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self signUp];
                    }];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];

                });
                                    
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showDefaultAlert:@"Cannot use Touch ID" withMessage:@"Undeclared Touch ID. Please retry."];
                    activateTouchID = NO;
                });
            }
        }];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showDefaultAlert:@"Cannot use Touch ID" withMessage:@"Please set your Touch ID & Passcode on Settings"];
            activateTouchID = NO;
        });
    }
}

#pragma mark - Sign Up
-(void)signUp
{
    NSString *strEmail = self.txtEmail.text;
    NSString *strName = self.txtName.text;
    NSString *strPassword = self.txtPassword.text;
    NSString *strConfirmPassword = self.txtConfirmPassword.text;
    
    if ([strEmail isEqual:@""] || [strName isEqual:@""] || [strPassword isEqual:@""]) {
        [self showDefaultAlert:@"" withMessage:@"Please input all fields."];
        return;
    }
    
    if (![strPassword isEqualToString:strConfirmPassword]) {
        [self showDefaultAlert:@"" withMessage:@"Confirm Password failed."];
        return;
    }
    
    NSDictionary *parameters = @{@"email": strEmail, @"name": strName, @"password": strPassword};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[WebServiceManager sharedInstance] sendPostRequest:SignUp param:parameters completionHandler:^(id obj) {
        
        // success...
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSString *strMessage = [dicResponse valueForKey:@"message"];
        strMessage = @"Profile added successfully. Please check your Inbox to verify your email";
        
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:S_ActivateTouchID];
        if (activateTouchID) {
            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:S_ActivateTouchID];
            [[NSUserDefaults standardUserDefaults] setValue:strEmail forKey:S_TouchIDEmail];
            [[NSUserDefaults standardUserDefaults] setValue:strPassword forKey:S_TouchIDPassword];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Signup" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:NO completion:nil];

    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error : %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showDefaultAlert:@"SignUp Failed" withMessage:@""];
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
    if (textField == self.txtEmail) {
        [self.txtName becomeFirstResponder];
    } else if (textField == self.txtName) {
        [self.txtPassword becomeFirstResponder];
    } else if (textField == self.txtPassword) {
        [self.txtConfirmPassword becomeFirstResponder];
    } else {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        [textField resignFirstResponder];
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
    float offset = keyboardHeight - (height - rect.origin.y - rect.size.height) + 50;
    
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
