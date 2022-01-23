#import <UIKit/UIKit.h>
#import "AppData.h"
#import "JBLineChartView.h"

@interface PumpGraphVC : UIViewController <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *graph_bg;

@property (weak, nonatomic) IBOutlet UILabel *lblBrandModel;
@property (weak, nonatomic) IBOutlet UILabel *lblDiameter;
@property (weak, nonatomic) IBOutlet UILabel *lblRPM;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplacement;

@property (strong, nonatomic) IBOutlet JBLineChartView *chartView;


@end
