#import "InvoiceDetailContainerVC.h"
#import "InvoiceDetailVC.h"
#import "HapticHelper.h"

@interface InvoiceDetailContainerVC ()
{
    NSInteger lastPendingViewControllerIndex;
}
@end

@implementation InvoiceDetailContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AppData sharedInstance].invoiceApprovalType = Field;
    
    self.arrInvoices = [[NSMutableArray alloc] init];
    self.selectedIndex = 0;
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = (id<UIPageViewControllerDataSource>)self;
    self.pageController.delegate = (id<UIPageViewControllerDelegate>)self;
    
    [self addChildViewController:self.pageController];
    [self.containerView addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    [AppData sharedInstance].changedStatusDelegate = (id<ChangedSyncStatusDelegate>)self;
    [self showSyncStatus];
    
    //
    self.arrInvoices = [[NSMutableArray alloc] init];
    self.selectedIndex = 0;
    
    for(int section = 0; section < self.arrInvoicesData.count; section++) {
        NSDictionary *dic = self.arrInvoicesData[section];
        NSArray *arr = [dic valueForKey:@"data"];
        for (int row = 0; row < arr.count; row++) {
            Invoices *invoice = arr[row];
            [self.arrInvoices addObject:invoice];
            if (self.selectedIndexPath.section == section && self.selectedIndexPath.row == row) {
                self.selectedIndex = self.arrInvoices.count - 1;
            }
        }
    }
    Invoices *invoice = self.arrInvoices[self.selectedIndex];
    self.lblTitle.text = [NSString stringWithFormat:@"Invoice #%d", invoice.invoiceID];
    
    InvoiceDetailVC *detailSubVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceDetailVC"];
    
    detailSubVC.invoice = invoice;
    detailSubVC.index = self.selectedIndex;
    
    NSArray *viewControllers = [NSArray arrayWithObject:detailSubVC];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pageController.view setFrame:self.containerView.bounds];
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


#pragma mark -
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

#pragma mark - ChangedStatusDelegate
-(void)changedSyncStatus
{
    [self showSyncStatus];
}

#pragma mark - UIPageView Delegate

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    if (pendingViewControllers.count > 0) {
        InvoiceDetailVC *vc = (InvoiceDetailVC*)pendingViewControllers[0];
        lastPendingViewControllerIndex = vc.index;
    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        self.selectedIndex = lastPendingViewControllerIndex;
        Invoices *invoice = self.arrInvoices[self.selectedIndex];
        self.lblTitle.text = [NSString stringWithFormat:@"Invoice #%d", invoice.invoiceID];
    }
}

#pragma mark - UIPageView Datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    InvoiceDetailVC *currentVC = (InvoiceDetailVC *)viewController;
    NSUInteger index = [currentVC index];
    
    if (index == 0) {
        return nil;
    }
    
    if (index > 0) {
        index -= 1;
    }
    
    InvoiceDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceDetailVC"];
    detailVC.index = index;
    detailVC.invoice = self.arrInvoices[index];
    return detailVC;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    InvoiceDetailVC *currentVC = (InvoiceDetailVC *)viewController;
    NSUInteger index = [currentVC index];
    
    if (index < self.arrInvoices.count - 1) {
        index += 1;
    } else {
        return nil;
    }
    
    InvoiceDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceDetailVC"];
    detailVC.index = index;
    detailVC.invoice = self.arrInvoices[index];
    
    return detailVC;
    
}

@end
