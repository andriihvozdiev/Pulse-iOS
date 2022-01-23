#import "OperationsVC.h"

#import "InvoicesVC.h"
#import "ScheduleVC.h"
#import "RigReportsVC.h"

#import "NewInvoiceVC.h"
#import "NewTaskVC.h"
#import "NewRigReportsVC.h"
#import "HapticHelper.h"

@interface OperationsVC ()

@end

@implementation OperationsVC
@synthesize m_childViewController;
@synthesize m_childView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.tag = 0;
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
}

-(void) initViews
{
    m_operationType = InvoicesType;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.underlineCenterConstraint.constant = -screenWidth * 3 / 8.0f;
    [self.view layoutIfNeeded];
    
    [self changeSubViewController];
}


-(void) changeSubViewController
{
    [self.invoicesContainerView setHidden:YES];
    [self.rigReportsContainerView setHidden:YES];
    [self.rigScheduleContainerView setHidden:YES];
    
    switch (m_operationType) {
        case InvoicesType:
            {
                [self.invoicesContainerView setHidden:NO];
                [self.btnInvoices setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.btnRigReports setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.btnSchedule setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            break;
        case RigReportsType:
            {
                [self.rigReportsContainerView setHidden:NO];
                [self.btnInvoices setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.btnRigReports setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.btnSchedule setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            break;
        case RigScheduleType:
            {
                [self.rigScheduleContainerView setHidden:NO];
                [self.btnInvoices setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.btnRigReports setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.btnSchedule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
    
    NSArray *arrSubVCs = [self childViewControllers];
    for (UIViewController *vc in arrSubVCs) {
        switch (m_operationType) {
            case InvoicesType:
            {
                InvoicesVC *subVC = (InvoicesVC*)vc;
                [subVC reloadData];
                break;
            }
            case RigReportsType:
            {
                RigReportsVC *subVC = (RigReportsVC*)vc;
                [subVC reloadData];
                break;
            }
            case RigScheduleType:
            {
                ScheduleVC *subVC = (ScheduleVC*)vc;
                [subVC reloadData];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -
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

- (IBAction)onInvoices:(id)sender
{
    m_operationType = InvoicesType;
    
    [self changeSubViewController];
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.3f animations:^{
        self.underlineCenterConstraint.constant = -screenWidth / 3.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnInvoices setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRigReports setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnSchedule setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
}

- (IBAction)onRigReports:(id)sender {
    m_operationType = RigReportsType;
    
    [self changeSubViewController];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.underlineCenterConstraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnInvoices setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnRigReports setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSchedule setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (IBAction)onSchedule:(id)sender
{
    m_operationType = RigScheduleType;
    
    [self changeSubViewController];
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.3f animations:^{
        self.underlineCenterConstraint.constant = screenWidth / 3.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnInvoices setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnRigReports setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnSchedule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void) createInvoice
{
    NewInvoiceVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewInvoiceVC"];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) createSchedule
{
    NewTaskVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewTaskVC"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) createRigReports
{
    NewRigReportsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRigReportsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"invoiceSeg"]) {
        InvoicesVC * destVC = [segue destinationViewController];
        destVC.parentOperationVC = self;
        destVC.nPosY = self.invoicesContainerView.frame.origin.y;
//        Vc2 *detail=[navViewController viewControllers][0];
//        Vc2.parentController=self;
    } else if ([segueName isEqualToString:@"rigSeg"]) {
        RigReportsVC * destVC = [segue destinationViewController];
        destVC.parentOperationVC = self;
    } else if ([segueName isEqualToString:@"scheduleSeg"]) {
        ScheduleVC * destVC = [segue destinationViewController];
        destVC.parentOperationVC = self;
    }
}


@end
