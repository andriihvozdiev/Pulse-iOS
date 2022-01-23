
#import <UIKit/UIKit.h>

@interface WaterMeterContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl24HrVol;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrent;
@property (weak, nonatomic) IBOutlet UILabel *lblYesterday;
@property (weak, nonatomic) IBOutlet UILabel *lblMeterProblem;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UILabel *lblResetVol;

@end
