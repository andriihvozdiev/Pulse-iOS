#import "ScheduleVC.h"
#import "ScheduleTableCell.h"
#import "ScheduleSectionCell.h"
#import "SchedulePopupVC.h"
#import "HapticHelper.h"
#import "OperationsVC.h"
#import "ActionSheetStringPicker.h"


@interface ScheduleVC ()<PeekPopPreviewingDelegate>

@end

@implementation ScheduleVC
@synthesize arrSectionStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnCreateTask.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnCreateTask.layer.borderWidth = 1.0f;
    self.btnCreateTask.layer.cornerRadius = 3.0f;
    
    m_sorttype = ScheduleStatus;
    self.lblSortType.text = @"Status";
    
    arrSectionStatus = [[NSMutableArray alloc] init];
    
    self.arrSchedulesByStatus = [[NSArray alloc] init];
    self.arrSchedulesByLease = [[NSArray alloc] init];
    self.arrSchedulesByDate = [[NSArray alloc] init];
    self.arrSchedulesByType = [[NSArray alloc] init];

    self.peekPop = [[PeekPop alloc] initWithViewController:self.parentOperationVC];
    self.previewingContext = [self.peekPop registerForPreviewingWithDelegate:self sourceView:self.view];
    [self initSectionStatus];
    
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
    self.arrSchedulesByStatus = [[DBManager sharedInstance] getSchedulesByStatus];
    self.arrSchedulesByLease = [[DBManager sharedInstance] getSchedulesByLease];
    self.arrSchedulesByDate = [[DBManager sharedInstance] getSchedulesByDate];
    self.arrSchedulesByType = [[DBManager sharedInstance] getSchedulesByType];
    
    [self initSectionStatus];
    [self.tableView reloadData];
}

#pragma mark - tableview datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    switch (m_sorttype) {
        case ScheduleLease:
            count = self.arrSchedulesByLease.count;
            break;
        case ScheduleTypes:
            count = self.arrSchedulesByType.count;
            break;
        case ScheduleDate:
            count = self.arrSchedulesByDate.count;
            break;
        case ScheduleStatus:
            count = self.arrSchedulesByStatus.count;
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
        case ScheduleLease:
            dic = self.arrSchedulesByLease[section];
            break;
        case ScheduleTypes:
            dic = self.arrSchedulesByType[section];
            break;
        case ScheduleDate:
            dic = self.arrSchedulesByDate[section];
            break;
        case ScheduleStatus:
            dic = self.arrSchedulesByStatus[section];
            break;
        default:
            break;
    }
    NSArray *arrData = [dic valueForKey:@"data"];
    count = arrData.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleTableCell" forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    switch (m_sorttype) {
        case ScheduleLease:
            dic = self.arrSchedulesByLease[section];
            break;
        case ScheduleTypes:
            dic = self.arrSchedulesByType[section];
            break;
        case ScheduleDate:
            dic = self.arrSchedulesByDate[section];
            break;
        case ScheduleStatus:
            dic = self.arrSchedulesByStatus[section];
            break;
        default:
            break;
    }
    
    cell.value4WidthConstraint.constant = 0;
    [cell.contentView layoutIfNeeded];
    
    NSArray *arrData = [dic valueForKey:@"data"];
    Schedules *schedule = arrData[row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    NSString *strDate = [df stringFromDate:schedule.date];
    NSString *leaseName = [[DBManager sharedInstance] getLeaseNameFromLease:schedule.lease];
    
    NSString *wellNumber = schedule.wellNumber == nil ? @"-" : schedule.wellNumber;
    
    switch (m_sorttype) {
        case ScheduleLease:
            cell.value4WidthConstraint.constant = 70;
            [cell.contentView layoutIfNeeded];
            cell.lblValue1.text = schedule.scheduleType;
            cell.lblValue2.text = strDate;
            cell.lblValue3.text = schedule.status;
            cell.lblValue4.text = wellNumber;
            break;
        case ScheduleTypes:
            cell.lblValue1.text = [NSString stringWithFormat:@"%@ - %@", leaseName, wellNumber];
            cell.lblValue2.text = strDate;
            cell.lblValue3.text = schedule.status;
            break;
        case ScheduleDate:
            cell.lblValue1.text = [NSString stringWithFormat:@"%@ - %@", leaseName, wellNumber];
            cell.lblValue2.text = schedule.scheduleType;
            cell.lblValue3.text = schedule.status;
            break;
        case ScheduleStatus:
            cell.lblValue1.text = [NSString stringWithFormat:@"%@ - %@", leaseName, wellNumber];
            cell.lblValue2.text = schedule.scheduleType;
            cell.lblValue3.text = strDate;
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
    ScheduleSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleSectionCell"];
    NSString *strTitle = @"";
    
    switch (m_sorttype) {
        case ScheduleLease:
        {
            NSDictionary *dic = self.arrSchedulesByLease[section];
            NSString *lease = [dic valueForKey:@"sortvalue"];
            NSString *leaseName = [[DBManager sharedInstance] getLeaseNameFromLease:lease];
            strTitle = leaseName;
            break;
        }
        case ScheduleTypes:
        {
            NSDictionary *dic = self.arrSchedulesByType[section];
            NSString *strSortValue = [dic valueForKey:@"sortvalue"];
            strTitle = strSortValue;
            break;
        }
        case ScheduleDate:
        {
            NSDictionary *dic = self.arrSchedulesByDate[section];
            NSString *strSortValue = [dic valueForKey:@"sortvalue"];
            strTitle = strSortValue;
            break;
        }
        case ScheduleStatus:
        {
            NSDictionary *dic = self.arrSchedulesByStatus[section];
            NSString *strSortValue = [dic valueForKey:@"sortvalue"];
            strTitle = strSortValue;
            break;
        }
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



-(void) initSectionStatus
{
    switch (m_sorttype) {
        case ScheduleLease:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrSchedulesByLease.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case ScheduleTypes:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrSchedulesByType.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case ScheduleDate:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrSchedulesByDate.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case ScheduleStatus:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrSchedulesByStatus.count; i++) {
                if (i == 0) {
                    [arrSectionStatus addObject:@"open"];
                }
                [arrSectionStatus addObject:@"close"];
            }
            break;
        default:
            break;
    }
    
    [self setTitles];
}

-(void) setTitles
{
    self.title4WidthConstraint.constant = 0.0f;
    [self.view layoutIfNeeded];
    
    switch (m_sorttype) {
        case ScheduleLease:
            self.title4WidthConstraint.constant = 70;
            [self.view layoutIfNeeded];
            
            self.lblTitle1.text = @"Type";
            self.lblTitle2.text = @"Date";
            self.lblTitle3.text = @"Status";
            self.lblTitle4.text = @"Well #";
            break;
        case ScheduleTypes:
            self.lblTitle1.text = @"Property";
            self.lblTitle2.text = @"Date";
            self.lblTitle3.text = @"Status";
            break;
        case ScheduleDate:
            self.lblTitle1.text = @"Property";
            self.lblTitle2.text = @"Type";
            self.lblTitle3.text = @"Status";
            break;
        case ScheduleStatus:
            self.lblTitle1.text = @"Property";
            self.lblTitle2.text = @"Type";
            self.lblTitle3.text = @"Date";
            break;
        default:
            break;
    }
}

#pragma mark - button events

- (IBAction)onSortType:(id)sender {
    NSArray *arrSortTypes = @[@"LEASE", @"Schedule Type", @"Date", @"Status"];
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Sort Types" rows:arrSortTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
        {
            self.lblSortType.text = arrSortTypes[selectedIndex];
                                                 
            switch (selectedIndex) {
                case 0:
                    m_sorttype = ScheduleLease;
                    break;
                case 1:
                    m_sorttype = ScheduleTypes;
                    break;
                case 2:
                    m_sorttype = ScheduleDate;
                    break;
                case 3:
                    m_sorttype = ScheduleStatus;
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

- (IBAction)onCreateTask:(id)sender {
    OperationsVC *vc = (OperationsVC*)self.parentViewController;
    [vc createSchedule];
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
    if ([self.presentedViewController isKindOfClass:[SchedulePopupVC class]]) {
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
        SchedulePopupVC *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SchedulePopupVC"];
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        switch (m_sorttype) {
            case ScheduleLease:
                dic = self.arrSchedulesByLease[path.section];
                break;
            case ScheduleTypes:
                dic = self.arrSchedulesByType[path.section];
                break;
            case ScheduleDate:
                dic = self.arrSchedulesByDate[path.section];
                break;
            case ScheduleStatus:
                dic = self.arrSchedulesByStatus[path.section];
                break;
            default:
                break;
        }
        
        NSArray *arrData = [dic valueForKey:@"data"];
        Schedules *schedule = arrData[path.row];
        
        previewController.schedule = schedule;
        
        previewController.preferredContentSize = CGSizeMake(0.0f, 500);
        
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
