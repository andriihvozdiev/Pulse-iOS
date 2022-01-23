#import "WBDMainVC.h"
#import "HapticHelper.h"
#import "CsgCmtVC.h"
#import "TbgRodsVC.h"
#import "PumpSubVC.h"
#import "CompletionVC.h"
#import "ChronVC.h"


@interface WBDMainVC ()
{
    CGSize screenSize;
}
@end

@implementation WBDMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    screenSize = [UIScreen mainScreen].bounds.size;
    self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    
    self.underlineCenterConstraint.constant = -screenSize.width * 4 / 10.0f;
    [self.btnCsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTbg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnCompletion setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnChron.activityIndicator setColor:[UIColor whiteColor]];
    [self.viewCsgCmt setHidden:YES];
    [self.viewTbgRods setHidden:YES];
    [self.viewPump setHidden:YES];
    [self.viewCompletion setHidden:YES];
    [self.viewChron setHidden:NO];
    
    /////////////////////////////////
    NSString *strLeaseName = [[DBManager sharedInstance] getLeaseNameFromLease:self.welllist.grandparentPropNum];
    self.lblTitle.text = [NSString stringWithFormat:@"%@ #%@ - WBD", strLeaseName, self.welllist.wellNumber];
    
    NSArray *arrChildVCs = [self childViewControllers];
    for (UIViewController *vc in arrChildVCs) {
        
        if ([vc isKindOfClass:CsgCmtVC.class]) {
            CsgCmtVC *csgCmtVC = (CsgCmtVC*)vc;
            csgCmtVC.welllist = self.welllist;
        }
        
        if ([vc isKindOfClass:TbgRodsVC.class]) {
            TbgRodsVC *tbgRodsVC = (TbgRodsVC*)vc;
            tbgRodsVC.welllist = self.welllist;
        }
        
        if ([vc isKindOfClass:PumpSubVC.class]) {
            PumpSubVC *pumpVC = (PumpSubVC*)vc;
            pumpVC.welllist = self.welllist;
        }
        
        if ([vc isKindOfClass:CompletionVC.class])
        {
            CompletionVC *completionVC = (CompletionVC*)vc;
            completionVC.welllist = self.welllist;
        }
        
        if ([vc isKindOfClass:ChronVC.class])
        {
            ChronVC *chronVC = (ChronVC*)vc;
            chronVC.welllist = self.welllist;
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.btnChron.initialTitle = @"Chron";
    self.btnChron.activityTitle = @"Chron";
    self.btnChron.buttonAnimationDuration = 0.5;
    self.btnChron.activityIndicatorColor  = [UIColor whiteColor];
    self.btnChron.activityIndicatorMargin = 6;
    self.btnChron.activityIndicatorScale  = 0.6;
//    [self.btnChron initializeButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
    
    
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

#pragma mark - portrait button events
- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onStoplight:(id)sender {
    [[AppData sharedInstance] mannualSync];
}

- (IBAction)onSyncForFailedData:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [HapticHelper generateFeedback:FeedbackType_Impact_Heavy];
        [[AppData sharedInstance] doSyncFailedData];
    }
}

- (IBAction)onLongTapForDownloadAllChron:(UILongPressGestureRecognizer*)sender {
    
    [self syncAllChrons];
    
}

- (void)syncAllChrons {
    if ([[AppData sharedInstance] getSyncStatus] == Syncing)
    {
    
        UIAlertController *syncingController = [UIAlertController alertControllerWithTitle:nil message:@"Syncing Now..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.pullAllChronDelegate didFinishDownload];
        }];
        [syncingController addAction:okAction];
        [self presentViewController:syncingController animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to sync all Well Chrons?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.btnChron.activityIndicator startAnimating];
        [[AppData sharedInstance] downloadRigReportsWithWellNum:self.welllist.wellNumber lease:self.welllist.grandparentPropNum completionHandler:^(BOOL isSuccess) {
            if (isSuccess) {
                [self reloadSubViews];
            } else {
                
            }
            [self.btnChron stopAnimating];
            [self.pullAllChronDelegate didFinishDownload];
        }];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.pullAllChronDelegate didFinishDownload];
    }];
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



- (IBAction)onCsg:(id)sender
{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = -screenSize.width * 2 / 10.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnCsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnTbg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnCompletion setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron.activityIndicator setColor:[UIColor grayColor]];
    [self.viewCsgCmt setHidden:NO];
    [self.viewTbgRods setHidden:YES];
    [self.viewPump setHidden:YES];
    [self.viewCompletion setHidden:YES];
    [self.viewChron setHidden:YES];
    
    [self reloadSubViews];
}

- (IBAction)onTbg:(id)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnCsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTbg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnCompletion setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron.activityIndicator setColor:[UIColor grayColor]];
    
    [self.viewCsgCmt setHidden:YES];
    [self.viewTbgRods setHidden:NO];
    [self.viewPump setHidden:YES];
    [self.viewCompletion setHidden:YES];
    [self.viewChron setHidden:YES];
    
    [self reloadSubViews];
}

- (IBAction)onPump:(id)sender
{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = screenSize.width * 2 / 10.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnCsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTbg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCompletion setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron.activityIndicator setColor:[UIColor grayColor]];
    [self.viewCsgCmt setHidden:YES];
    [self.viewTbgRods setHidden:YES];
    [self.viewPump setHidden:NO];
    [self.viewCompletion setHidden:YES];
    [self.viewChron setHidden:YES];
    
    [self reloadSubViews];
}

- (IBAction)onCompletion:(id)sender
{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = screenSize.width * 4 / 10.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnCsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTbg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnCompletion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnChron setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron.activityIndicator setColor:[UIColor grayColor]];
    
    [self.viewCsgCmt setHidden:YES];
    [self.viewTbgRods setHidden:YES];
    [self.viewPump setHidden:YES];
    [self.viewCompletion setHidden:NO];
    [self.viewChron setHidden:YES];
    
    [self reloadSubViews];
}

- (IBAction)onChron:(id)sender {
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = -screenSize.width * 4 / 10.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnCsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTbg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnCompletion setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnChron setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnChron.activityIndicator setColor:[UIColor whiteColor]];
    [self.viewCsgCmt setHidden:YES];
    [self.viewTbgRods setHidden:YES];
    [self.viewPump setHidden:YES];
    [self.viewCompletion setHidden:YES];
    [self.viewChron setHidden:NO];

    [self reloadSubViews];
}

-(void) reloadSubViews
{
    NSArray *arrSubVCs = [self childViewControllers];
    for (UIViewController *vc in arrSubVCs) {
        
        
        if ([vc isKindOfClass:TbgRodsVC.class]) {
            TbgRodsVC *tbgRodsVC = (TbgRodsVC*)vc;
            [tbgRodsVC reloadData];
        }
        
        if ([vc isKindOfClass:PumpSubVC.class]) {
            PumpSubVC *pumpVC = (PumpSubVC*)vc;
            [pumpVC reloadData];
        }
        
        if ([vc isKindOfClass:CompletionVC.class])
        {
            CompletionVC *completionVC = (CompletionVC*)vc;
            [completionVC reloadData];
        }
        
        if ([vc isKindOfClass:ChronVC.class])
        {
            ChronVC *chronVC = (ChronVC*)vc;
            [chronVC reloadData];
        }
    }
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"segueChron"]) {
        ChronVC * vc = [segue destinationViewController];
        vc.parentController = self;
    }
}


@end
