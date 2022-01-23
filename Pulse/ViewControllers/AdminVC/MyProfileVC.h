#import <UIKit/UIKit.h>
#import "AppData.h"

@interface MyProfileVC : UIViewController <ChangedSyncStatusDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)onBack:(id)sender;
- (IBAction)onStoplight:(id)sender;

- (IBAction)onActivateTouchID:(id)sender;

@end
