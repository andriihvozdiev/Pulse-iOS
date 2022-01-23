#import <UIKit/UIKit.h>
#import "AppData.h"

@interface PumpSubVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WellList *welllist;

@property (nonatomic, strong) NSArray *arrPumps;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void) reloadData;

@end
