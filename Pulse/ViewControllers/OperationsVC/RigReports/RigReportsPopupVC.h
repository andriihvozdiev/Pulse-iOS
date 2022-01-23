#import <UIKit/UIKit.h>
#import "AppData.h"

@interface RigReportsPopupVC : UIViewController

@property (nonatomic, strong) RigReports *rigReport;

@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblWellNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UILabel *lblDailyCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;


@end
