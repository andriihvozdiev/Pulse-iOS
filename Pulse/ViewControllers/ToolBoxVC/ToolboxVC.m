#import "ToolboxVC.h"
#import "HapticHelper.h"

@interface ToolboxVC ()
{
    BOOL isSelectedPump;
}
@end

@implementation ToolboxVC
@synthesize graphVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    [AppData sharedInstance].changedStatusDelegate = self;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.underlineCenterContraint.constant = -screenWidth / 4.0f;
    [self.btnWheel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.wheelView setHidden:NO];
    [self.pumpView setHidden:YES];
    [self.pumpGraphView setHidden:YES];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    isSelectedPump = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.tag = 0;
    if (isSelectedPump) {
        self.view.tag = 10;
    }
    
    [self showSyncStatus];
}


-(void) showSyncStatus
{
    [self.redStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.yellowStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.blueStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.greenStatusView setBackgroundColor:[UIColor lightGrayColor]];
    
    switch ([AppData sharedInstance].syncStatus) {
        case SyncFailed:
            [self.redStatusView setBackgroundColor:[UIColor redColor]];
            break;
        case UploadFailed:
            [self.yellowStatusView setBackgroundColor:[UIColor yellowColor]];
            break;
        case Syncing:
            [self.blueStatusView setBackgroundColor:[UIColor blueColor]];
            break;
        case Synced:
            [self.greenStatusView setBackgroundColor:[UIColor greenColor]];
            break;
        default:
            break;
    }
}

#pragma mark - ChangedStatusDelegate
-(void)changedSyncStatus
{
    [self showSyncStatus];
}


#pragma mark - button events

- (IBAction)onStoplight:(id)sender {
    
    [[AppData sharedInstance] mannualSync];
}

- (IBAction)onSyncForFailedData:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [HapticHelper generateFeedback:FeedbackType_Impact_Heavy];
        [[AppData sharedInstance] doSyncFailedData];
    }
}

- (IBAction)onWheel:(id)sender {
    self.view.tag = 0;
    isSelectedPump = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float screenWidth = screenSize.width;
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterContraint.constant = -screenWidth / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
        
        [self.wheelView setHidden:NO];
        [self.pumpView setHidden:YES];
    }];

    
    [self.btnWheel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}


- (IBAction)onPump:(id)sender {
    
    isSelectedPump = YES;
    self.view.tag = 10;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float screenWidth = screenSize.width;
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterContraint.constant = screenWidth / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
        
        [self.wheelView setHidden:YES];
        [self.pumpView setHidden:NO];
    }];
    
    
    [self.btnWheel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


#pragma mark -
-(void) orientationChanged: (NSNotification*)note
{
    UIDevice *device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            [self.tabBarController.tabBar setHidden:NO];
            
            if (graphVC) {
                [graphVC.view removeFromSuperview];
                [graphVC removeFromParentViewController];
                graphVC = nil;
            }
            [self.pumpGraphView setHidden:YES];
            
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            if (isSelectedPump) {
                if (self.navigationController.topViewController == self) {
                    [self.tabBarController.tabBar setHidden:YES];
                }
                
                [self.pumpGraphView setHidden:NO];
                
                CGSize screenSize = [UIScreen mainScreen].bounds.size;
                CGRect rect  = CGRectMake(0, 0, screenSize.width, screenSize.height);
                
                graphVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PumpGraphVC"];
                graphVC.view.frame = rect;
                
                [self addChildViewController:graphVC];
                [self.pumpGraphView addSubview:graphVC.view];
            }
            break;
        default:
            break;
    }
    
}


@end
