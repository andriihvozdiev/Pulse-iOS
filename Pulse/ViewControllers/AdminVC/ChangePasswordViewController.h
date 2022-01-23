#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *arrCaptions;
    NSMutableArray *cellArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onCancel:(id)sender;
- (IBAction)onSubmit:(id)sender;
@end
