#import "SplashViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"


@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initViews
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    float buttonHeight = screenSize.height * 53 / 667.0;
    
    self.btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnLogin.layer.borderWidth = 1.0f;
    self.btnLogin.layer.cornerRadius = buttonHeight / 2.0f;
    
    self.btnSignUp.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSignUp.layer.borderWidth = 1.0f;
    self.btnSignUp.layer.cornerRadius = buttonHeight / 2.0f;
    
}


- (IBAction)onForgotPassword:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forgot Password?" message:@"Please enter your email address to recover password." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"example@email.com";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * emailField = textfields[0];
        [self forgotPasswordMethod:emailField.text];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)forgotPasswordMethod:(NSString*)email
{
    NSDictionary *dicParameter = @{@"email": email};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[WebServiceManager sharedInstance] sendPostRequest:ForgotPassword param:dicParameter completionHandler:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showDefaultAlert:nil withMessage:@"Please check your email to reset password"];
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showDefaultAlert:@"Error" withMessage:@"Invalid email."];
    }];
    
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
