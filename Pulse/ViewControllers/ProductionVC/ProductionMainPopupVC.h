#import <UIKit/UIKit.h>
#import "AppData.h"

@interface ProductionMainPopupVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PulseProdHome *pulseProdHome;

@property (nonatomic, strong) NSArray *arrPulseProdField;
@property (nonatomic, strong) NSMutableArray *arrComments;

@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

@end
