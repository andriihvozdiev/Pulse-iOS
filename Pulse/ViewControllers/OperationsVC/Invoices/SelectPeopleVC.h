
#import <UIKit/UIKit.h>
#import "AppData.h"

@interface SelectPeopleVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>
@property (nonatomic, strong) NSMutableArray *arrSelectedStatus;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSave:(id)sender;

@end
