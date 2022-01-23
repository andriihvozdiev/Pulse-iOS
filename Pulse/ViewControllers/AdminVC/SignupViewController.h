#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>

@property BOOL fromLogin;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewConfirmPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnActivateTouchID;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;

@property (weak, nonatomic) IBOutlet UIButton *btnGotoLogin;

- (IBAction)onActivateTouchID:(id)sender;
- (IBAction)onSignup:(id)sender;
- (IBAction)onBack:(id)sender;
@end
