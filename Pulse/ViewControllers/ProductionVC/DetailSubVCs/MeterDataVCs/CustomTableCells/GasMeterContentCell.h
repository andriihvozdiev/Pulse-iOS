
#import <UIKit/UIKit.h>

@interface GasMeterContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblMeterCumVol;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrent;
@property (weak, nonatomic) IBOutlet UILabel *lblYesterday;
@property (weak, nonatomic) IBOutlet UILabel *lblLinePressure;
@property (weak, nonatomic) IBOutlet UILabel *lblDiffPressure;
@property (weak, nonatomic) IBOutlet UILabel *lblMeterProblem;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;

@end
