#import <UIKit/UIKit.h>

#import "AppData.h"
#import "WBDMainVC.h"

@interface ChronVC : UIViewController <UITableViewDelegate, UITableViewDataSource, PullAllChronDelegate>

@property (nonatomic, strong) WellList *welllist;
@property (nonatomic, strong) NSArray *arrRigReports;
@property (nonatomic, strong) UIRefreshControl *refreshController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) WBDMainVC *parentController;

//@property (nonatomic, retain) PullAllChronDelegate *delegate;
-(void) reloadData;

@end
