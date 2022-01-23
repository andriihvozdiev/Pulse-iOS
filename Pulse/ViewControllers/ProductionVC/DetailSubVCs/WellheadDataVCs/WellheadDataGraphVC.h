#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "JBLineChartView.h"

@interface WellheadDataGraphVC : UIViewController <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) NSArray *arrWellheadData;

@property (weak, nonatomic) IBOutlet UIButton *btnPressure;
@property (weak, nonatomic) IBOutlet UIButton *btnRodPump;
@property (weak, nonatomic) IBOutlet UIButton *btnESP;
@property (weak, nonatomic) IBOutlet UIButton *btnFluidCuts;

@property (weak, nonatomic) IBOutlet UIView *landscapeUnderline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscapeUnderlineCenterConstraint;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *graph_bg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewPressure;
@property (weak, nonatomic) IBOutlet UIView *viewRodPump;
@property (weak, nonatomic) IBOutlet UIView *viewESP;
@property (weak, nonatomic) IBOutlet UIView *viewFluidCuts;

// Pressure
@property (weak, nonatomic) IBOutlet UIView *viewPressureInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTubingPressure;
@property (weak, nonatomic) IBOutlet UILabel *lblCasingPressure;
@property (weak, nonatomic) IBOutlet UILabel *lblBradenheadPressure;
@property (weak, nonatomic) IBOutlet UILabel *lblChokeSize;
@property (weak, nonatomic) IBOutlet UILabel *lblPressureCheckTime;

// Rod Pump
@property (weak, nonatomic) IBOutlet UIView *viewRodPumpInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblSPM;
@property (weak, nonatomic) IBOutlet UILabel *lblStrokeSize;
@property (weak, nonatomic) IBOutlet UILabel *lblPound;
@property (weak, nonatomic) IBOutlet UILabel *lblRodpumpCheckTime;

// ESP
@property (weak, nonatomic) IBOutlet UIView *viewESPInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblESPHz;
@property (weak, nonatomic) IBOutlet UILabel *lblESPAmp;
@property (weak, nonatomic) IBOutlet UILabel *lblESPCheckTime;

// FluidCuts
@property (weak, nonatomic) IBOutlet UIView *viewFluidCutsInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblOilCut;
@property (weak, nonatomic) IBOutlet UILabel *lblWaterCut;
@property (weak, nonatomic) IBOutlet UILabel *lblEmulsionCut;
@property (weak, nonatomic) IBOutlet UILabel *lblFluidCutsCheckTime;


@property (strong, nonatomic) IBOutlet JBLineChartView *pressureChartView;
@property (strong, nonatomic) IBOutlet JBLineChartView *rodpumpChartView;
@property (strong, nonatomic) IBOutlet JBLineChartView *espChartView;
@property (strong, nonatomic) IBOutlet JBLineChartView *fluidcutChartView;


// button events
- (IBAction)onPressure:(id)sender;
- (IBAction)onRodPump:(id)sender;
- (IBAction)onESP:(id)sender;
- (IBAction)onFluidCuts:(id)sender;

@end
