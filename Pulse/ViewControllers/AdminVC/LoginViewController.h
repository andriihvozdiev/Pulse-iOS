#import <UIKit/UIKit.h>
#import "AppData.h"
#import "TOPasscodeViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, DownloadedDelegate, TOPasscodeViewControllerDelegate>

@property BOOL fromSignup;

@property(nonatomic, strong) NSString *openUrlID;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIView *viewLoginWithTouchID;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginWithTouchID;

@property (weak, nonatomic) IBOutlet UIButton *btnGotoSignup;

- (IBAction)onBack:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onLoginWithTouchID:(id)sender;

@end
