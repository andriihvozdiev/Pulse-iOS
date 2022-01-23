
#import "RigReportsVC.h"
#import "RigReportsHeaderCell.h"
#import "RigReportsContentCell.h"
#import "RigReportsPopupVC.h"
#import "RigReportsDetailContainerVC.h"
#import "RigReportsDetailVC.h"
#import "OperationsVC.h"
#import "HapticHelper.h"

#import "ActionSheetStringPicker.h"

@interface RigReportsVC () <PeekPopPreviewingDelegate>

@end

@implementation RigReportsVC
@synthesize arrSectionStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnCreateRigReports.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnCreateRigReports.layer.borderWidth = 1.0f;
    self.btnCreateRigReports.layer.cornerRadius = 3.0f;
    
    m_sorttype = ReportsDate;
    arrSectionStatus = [[NSMutableArray alloc] init];
    
    [self initSectionStatus];
    
//    self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    
    self.peekPop = [[PeekPop alloc] initWithViewController:self.parentOperationVC];
    self.previewingContext = [self.peekPop registerForPreviewingWithDelegate:self sourceView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
    
}

-(void) reloadData
{
    self.arrRigReportsByDate = [[DBManager sharedInstance] getRigReportsByDate];
    self.arrRigReportsByLease = [[DBManager sharedInstance] getRigReportsByLease];
    
    [self initSectionStatus];
    [self.tableView reloadData];
}

#pragma mark - tableview datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    switch (m_sorttype) {
        case ReportsDate:
            count = self.arrRigReportsByDate.count;
            break;
        case ReportsLease:
            count = self.arrRigReportsByLease.count;
            break;
        default:
            break;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrSectionStatus[section] isEqual:@"close"]) {
        return 0;
    }
    
    NSInteger count = 0;
    NSDictionary *dic = [[NSDictionary alloc] init];
    switch (m_sorttype) {
        case ReportsDate:
            dic = self.arrRigReportsByDate[section];
            break;
        case ReportsLease:
            dic = self.arrRigReportsByLease[section];
            break;
    }
    NSArray *arrData = [dic valueForKey:@"data"];
    count = arrData.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RigReportsContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RigReportsContentCell" forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    switch (m_sorttype) {
        case ReportsDate:
            dic = self.arrRigReportsByDate[section];
            break;
        case ReportsLease:
            dic = self.arrRigReportsByLease[section];
            break;
        default:
            break;
    }
    
    NSArray *arrData = [dic valueForKey:@"data"];
    RigReports *rigReport = arrData[row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    NSString *wellNumber = rigReport.wellNum == nil ? @"-" : rigReport.wellNum;
    
    NSString *leaseName = [[DBManager sharedInstance] getLeaseNameFromLease:rigReport.lease];
    
    switch (m_sorttype) {
        case ReportsDate:
            cell.lblLease.text = leaseName;
            cell.lblWellNumber.text = wellNumber;
            cell.lblCompany.text = rigReport.company;
            break;
        case ReportsLease:
            cell.lblLease.text = [df stringFromDate:rigReport.reportDate];
            cell.lblWellNumber.text = wellNumber;
            cell.lblCompany.text = rigReport.company;
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RigReportsHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RigReportsHeaderCell"];
    NSString *strTitle = @"";
    
    switch (m_sorttype) {
        case ReportsDate:
        {
            NSDictionary *dic = self.arrRigReportsByDate[section];
            NSString *strSortValue = [dic valueForKey:@"sortvalue"];
            strTitle = strSortValue;
        }
            break;
        case ReportsLease:
        {
            NSDictionary *dic = self.arrRigReportsByLease[section];
            NSString *lease = [dic valueForKey:@"sortvalue"];
            NSString *leaseName = [[DBManager sharedInstance] getLeaseNameFromLease:lease];
            strTitle = leaseName;
        }
            break;
        default:
            break;
    }
    
    cell.lblTitle.text = strTitle;
    [cell.btnHeader setTag:section];
    if ([arrSectionStatus[section] isEqual:@"close"]) {
        cell.imgDropdown.image = [UIImage imageNamed:@"dropdown_icon"];
    } else {
        cell.imgDropdown.image = [UIImage imageNamed:@"dropup_icon"];
    }
    
    [cell.layer setMasksToBounds:NO];
    [cell.contentView.layer setMasksToBounds:NO];
    cell.viewBackground.layer.masksToBounds = NO;
    cell.viewBackground.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.viewBackground.layer.shadowOffset = CGSizeMake(1, 2);
    cell.viewBackground.layer.shadowRadius = 3.0f;
    cell.viewBackground.layer.shadowOpacity = 0.3f;
    
    UIView *view = [cell contentView];
    return view;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RigReportsDetailContainerVC *detailContainerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RigReportsDetailContainerVC"];
    
    switch (m_sorttype) {
        case ReportsDate:
            detailContainerVC.arrRigReportsData = self.arrRigReportsByDate;
            break;
        case ReportsLease:
            detailContainerVC.arrRigReportsData = self.arrRigReportsByLease;
            break;
        default:
            break;
    }
    
    detailContainerVC.selectedIndexPath = indexPath;
    
    [self.parentViewController.navigationController pushViewController:detailContainerVC animated:YES];
}

#pragma mark -

-(void) initSectionStatus
{
    switch (m_sorttype) {
        case ReportsDate:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrRigReportsByDate.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case ReportsLease:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrRigReportsByLease.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        default:
            break;
    }
    
    [self setTitles];
}

-(void) setTitles
{
    switch (m_sorttype) {
        case ReportsDate:
            self.lblLease.text = @"Lease";
            break;
        case ReportsLease:
            self.lblLease.text = @"Date";
            break;
        default:
            break;
    }
}

#pragma mark - buttton events

- (IBAction)onSortType:(id)sender {
    NSArray *arrSortTypes = @[@"DATE", @"LEASE"];
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Sort Types" rows:arrSortTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        self.lblSortType.text = arrSortTypes[selectedIndex];
                                                 
        switch (selectedIndex) {
            case 0:
                m_sorttype = ReportsDate;
                break;
            case 1:
                m_sorttype = ReportsLease;
                break;
            default:
                break;
        }
        [self initSectionStatus];
        [self.tableView reloadData];
                                                 
    } cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 
    } origin:self.lblSortType];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

- (IBAction)onCreateRigReports:(id)sender
{
    OperationsVC *vc = (OperationsVC*)self.parentViewController;
    [vc createRigReports];
}

- (IBAction)sectionHeaderTapped:(id)sender {
    NSInteger section = [(UIButton*)sender tag];
    NSLog(@"Tap : %d", (int)section);
    
    if ([arrSectionStatus[section] isEqual:@"open"]) {
        [arrSectionStatus replaceObjectAtIndex:section withObject:@"close"];
    } else {
        [arrSectionStatus replaceObjectAtIndex:section withObject:@"open"];
    }
    [self.tableView reloadData];
}


#pragma mark - 3D Touch
- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}


- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location
{
    if ([self.presentedViewController isKindOfClass:[RigReportsPopupVC class]]) {
        return nil;
    }
    
    
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (path) {
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
        
        CGRect rect = tableCell.frame;
        CGPoint yOffset = self.tableView.contentOffset;
        rect.origin.y += self.tableView.frame.origin.y - yOffset.y;
        [previewingContext setSourceRect:rect];
        
        // set the view controller by initializing it form the storyboard
        RigReportsPopupVC *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RigReportsPopupVC"];
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        switch (m_sorttype) {
            case ReportsDate:
                dic = self.arrRigReportsByDate[path.section];
                break;
            case ReportsLease:
                dic = self.arrRigReportsByLease[path.section];
                break;
            default:
                break;
        }
        
        NSArray *arrData = [dic valueForKey:@"data"];
        RigReports *rigReport = arrData[path.row];
        
        previewController.rigReport = rigReport;
        
        previewController.preferredContentSize = CGSizeMake(0.0f, 450);
        
        return previewController;
    }
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    
    if (![self isForceTouchAvailable]) {
        [HapticHelper generateFeedback:FeedbackType_Impact_Heavy];
    }
    [self showViewController:viewControllerToCommit sender:self];
}


//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    if ([self isForceTouchAvailable]) {
//        if (!self.previewingContext) {
//            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
//        }
//    } else {
//        if (self.previewingContext) {
//            [self unregisterForPreviewingWithContext:self.previewingContext];
//            self.previewingContext = nil;
//        }
//    }
//}

@end
