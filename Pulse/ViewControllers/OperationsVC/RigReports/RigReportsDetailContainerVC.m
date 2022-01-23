//
//  RigReportsDetailContainerVC.m
//  Pulse
//
//  Created by Luca on 8/31/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import "RigReportsDetailContainerVC.h"
#import "RigReportsDetailVC.h"
#import "HapticHelper.h"

@interface RigReportsDetailContainerVC ()
{
    NSInteger lastPendingViewControllerIndex;
}
@end

@implementation RigReportsDetailContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrRigReports = [[NSMutableArray alloc] init];
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
    
    self.arrRigReports = [[NSMutableArray alloc] init];
    self.selectedIndex = 0;
    
    for(int section = 0; section < self.arrRigReportsData.count; section++) {
        NSDictionary *dic = self.arrRigReportsData[section];
        NSArray *arr = [dic valueForKey:@"data"];
        for (int row = 0; row < arr.count; row++) {
            RigReports *rigReport = arr[row];
            [self.arrRigReports addObject:rigReport];
            if (self.selectedIndexPath.section == section && self.selectedIndexPath.row == row) {
                self.selectedIndex = self.arrRigReports.count - 1;
            }
        }
    }
    
    RigReports *rigReport = self.arrRigReports[self.selectedIndex];
    self.lblTitle.text = [NSString stringWithFormat:@"Rig Reports #%d", rigReport.reportID];
    
    RigReportsDetailVC *detailSubVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RigReportsDetailVC"];
    
    detailSubVC.rigReports = rigReport;
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
        RigReportsDetailVC *vc = (RigReportsDetailVC*)pendingViewControllers[0];
        lastPendingViewControllerIndex = vc.index;
    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        self.selectedIndex = lastPendingViewControllerIndex;
        RigReports *rigReports = self.arrRigReports[self.selectedIndex];
        self.lblTitle.text = [NSString stringWithFormat:@"Rig Reports #%d", rigReports.reportID];
    }
}

#pragma mark - UIPageView Datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    RigReportsDetailVC *currentVC = (RigReportsDetailVC *)viewController;
    NSUInteger index = [currentVC index];
    
    if (index == 0) {
        return nil;
    }
    
    if (index > 0) {
        index -= 1;
    }
    
    RigReportsDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RigReportsDetailVC"];
    detailVC.index = index;
    detailVC.rigReports = self.arrRigReports[index];
    return detailVC;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    RigReportsDetailVC *currentVC = (RigReportsDetailVC *)viewController;
    NSUInteger index = [currentVC index];
    
    if (index < self.arrRigReports.count - 1) {
        index += 1;
    } else {
        return nil;
    }
    
    RigReportsDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RigReportsDetailVC"];
    detailVC.index = index;
    detailVC.rigReports = self.arrRigReports[index];
    
    return detailVC;
    
}

@end
