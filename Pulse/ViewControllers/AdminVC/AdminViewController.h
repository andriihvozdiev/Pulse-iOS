#import <UIKit/UIKit.h>
#import "AppData.h"

@interface AdminViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onStoplight:(id)sender;

@end
