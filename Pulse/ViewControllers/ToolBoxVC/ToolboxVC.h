
#import <UIKit/UIKit.h>
#import "AppData.h"
#import "PumpGraphVC.h"

@interface ToolboxVC : UIViewController <ChangedSyncStatusDelegate>

@property (nonatomic, strong) PumpGraphVC *graphVC;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;


@property (weak, nonatomic) IBOutlet UIButton *btnWheel;
@property (weak, nonatomic) IBOutlet UIButton *btnPump;
@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterContraint;

@property (weak, nonatomic) IBOutlet UIView *wheelView;
@property (weak, nonatomic) IBOutlet UIView *pumpView;
@property (weak, nonatomic) IBOutlet UIView *pumpGraphView;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onWheel:(id)sender;
- (IBAction)onPump:(id)sender;




@end

