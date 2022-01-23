#import <UIKit/UIKit.h>
#import "AppData.h"

@interface NewTaskVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>
{
    UIDatePicker *datePicker;
}

@property (nonatomic, strong) NSArray *arrScheduleTypes;
@property (nonatomic, strong) NSMutableArray *arrSectionTitles;

@property (nonatomic, strong) NSString *strSelectedLease;
@property (nonatomic, strong) NSArray *arrWells;
@property (nonatomic, strong) NSMutableArray *arrWellNumber;


@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onCreate:(id)sender;
- (IBAction)onHeaderTapped:(id)sender;

@end
