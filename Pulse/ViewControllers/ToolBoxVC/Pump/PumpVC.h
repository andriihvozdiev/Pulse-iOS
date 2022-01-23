#import <UIKit/UIKit.h>
#import "AppData.h"

@interface PumpVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *arrWaterPumpInfo;

@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)onBrand:(id)sender;
- (IBAction)onModel:(id)sender;

@end
