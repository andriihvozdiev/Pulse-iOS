#import <UIKit/UIKit.h>

@interface ResetPasswordVC : UIViewController

@property(nonatomic, strong) NSString *openUrlID;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewConfirmPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;


- (IBAction)onBack:(id)sender;
- (IBAction)onSubmit:(id)sender;

@end
