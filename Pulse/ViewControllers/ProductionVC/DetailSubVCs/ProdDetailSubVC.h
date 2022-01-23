#import <UIKit/UIKit.h>
#import "AppData.h"
@import PeekPop;

@interface ProdDetailSubVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property NSInteger index;
@property (nonatomic, strong) PulseProdHome *pulseProdHome;
@property (nonatomic, strong) NSString *leaseField;

@property (nonatomic, strong) NSArray *arrDetailData;

//@property (nonatomic, strong) id previewingContext;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PeekPop *peekPop;
@property (nonatomic, strong) PreviewingContext *previewingContext;

/*********** Production Average *********************/
@property (weak, nonatomic) IBOutlet UILabel *lblOil7;
@property (weak, nonatomic) IBOutlet UILabel *lblGas7;
@property (weak, nonatomic) IBOutlet UILabel *lblWater7;
@property (weak, nonatomic) IBOutlet UILabel *lblOil30;
@property (weak, nonatomic) IBOutlet UILabel *lblGas30;
@property (weak, nonatomic) IBOutlet UILabel *lblWater30;
@property (weak, nonatomic) IBOutlet UILabel *lblOilP30;
@property (weak, nonatomic) IBOutlet UILabel *lblGasP30;
@property (weak, nonatomic) IBOutlet UILabel *lblWaterP30;
@property (weak, nonatomic) IBOutlet UILabel *lblOil365;
@property (weak, nonatomic) IBOutlet UILabel *lblGas365;
@property (weak, nonatomic) IBOutlet UILabel *lblWater365;

@end
