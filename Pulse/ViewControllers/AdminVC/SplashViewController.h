#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblLogoTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;


- (IBAction)onForgotPassword:(id)sender;


@end
