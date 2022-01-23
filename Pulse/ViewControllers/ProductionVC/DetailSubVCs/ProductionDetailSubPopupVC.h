
#import <UIKit/UIKit.h>
#import "AppData.h"

@interface ProductionDetailSubPopupVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL isProductionField;

@property (nonatomic, strong) PulseProdHome *pulseProdHome;
@property (nonatomic, strong) Production *production;
@property (nonatomic, strong) ProductionField *productionField;

@property (nonatomic, strong) NSArray *arrProductionField;
@property (nonatomic, strong) NSMutableArray *arrComments;

@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@end
