#import "InvoicesVC.h"
#import "OperationsVC.h"
#import "InvoiceSectionCell.h"
#import "InvoiceTableCell.h"
#import "InvoicesPopupVC.h"
#import "InvoiceDetailContainerVC.h"

#import "ActionSheetStringPicker.h"
#import "AppData.h"
#import "HapticHelper.h"
@import PeekPop;

@interface InvoicesVC () <PeekPopPreviewingDelegate>

@end

@implementation InvoicesVC
@synthesize arrSectionStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnCreateInvoice.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnCreateInvoice.layer.borderWidth = 1.0f;
    self.btnCreateInvoice.layer.cornerRadius = 3.0f;
    
    m_sorttype = DATE;
    self.lblSortType.text = @"DATE";
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
    [[AppData sharedInstance].arrSelectedAccounts removeAllObjects];
    [[AppData sharedInstance].arrSelectedAccountTimes removeAllObjects];
    [[AppData sharedInstance].arrSelectedAccountTimeUnits removeAllObjects];

    self.arrInvoicesPrimary = [[DBManager sharedInstance] getInvoices:@"primary"];
    self.arrInvoicesSecondary = [[DBManager sharedInstance] getInvoices:@"secondary"];
    self.arrInvoicesExport = [[DBManager sharedInstance] getInvoices:@"export"];
    
    self.arrInvoicesByDate = [[DBManager sharedInstance] getInvoicesByDate];
    self.arrInvoicesByLease = [[DBManager sharedInstance] getInvoicesByLease];
    self.arrInvoicesByAccount = [[DBManager sharedInstance] getInvoicesByAcccount];
    self.arrInvoicesByPeople = [[DBManager sharedInstance] getInvoicesByPeople];
    
    [self initSectionStatus];
    [self.tableView reloadData];
}

#pragma mark - tableview datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    switch (m_sorttype) {
        case PRIMARY:
            count = self.arrInvoicesPrimary.count;
            break;
        case SECONDARY:
            count = self.arrInvoicesSecondary.count;
            break;
        case EXPORT:
            count = self.arrInvoicesExport.count;
            break;
        case DATE:
            count = self.arrInvoicesByDate.count;
            break;
        case LEASE:
            count = self.arrInvoicesByLease.count;
            break;
        case ACCOUNT:
            count = self.arrInvoicesByAccount.count;
            break;
        case PEOPLE:
            count = self.arrInvoicesByPeople.count;
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
        case PRIMARY:
            dic = self.arrInvoicesPrimary[section];
            break;
        case SECONDARY:
            dic = self.arrInvoicesSecondary[section];
            break;
        case EXPORT:
            dic = self.arrInvoicesExport[section];
            break;
        case DATE:
            dic = self.arrInvoicesByDate[section];
            break;
        case LEASE:
            dic = self.arrInvoicesByLease[section];
            break;
        case ACCOUNT:
            dic = self.arrInvoicesByAccount[section];
            break;
        case PEOPLE:
            dic = self.arrInvoicesByPeople[section];
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
    InvoiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceTableCell" forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    switch (m_sorttype) {
        case PRIMARY:
            dic = self.arrInvoicesPrimary[section];
            break;
        case SECONDARY:
            dic = self.arrInvoicesSecondary[section];
            break;
        case EXPORT:
            dic = self.arrInvoicesExport[section];
            break;
        case DATE:
            dic = self.arrInvoicesByDate[section];
            break;
        case LEASE:
            dic = self.arrInvoicesByLease[section];
            break;
        case ACCOUNT:
            dic = self.arrInvoicesByAccount[section];
            break;
        case PEOPLE:
            dic = self.arrInvoicesByPeople[section];
            break;
        default:
            break;
    }

    NSArray *arrInvoices = [dic valueForKey:@"data"];
    Invoices *invoice = arrInvoices[row];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSString *lease = invoice.lease;
    NSString *leaseName = [[DBManager sharedInstance] getLeaseNameFromPropNum:lease];
    NSDate *invoiceDate = invoice.invoiceDate;
    NSString *wellNumber = invoice.wellNumber;
    
    NSArray *arrAccounts = [[DBManager sharedInstance] getInvoiceDetail:invoice.invoiceID appID:invoice.invoiceAppID];
    NSInteger accountCount = arrAccounts.count;
    
    NSString *strAccount = @"-";
    if (accountCount > 0) {
        InvoicesDetail *accountDetail = arrAccounts[0];
        
        strAccount = [[DBManager sharedInstance] getAccountDescription:accountDetail.account withSubAccount:accountDetail.accountSub];
        
        if (accountCount > 1) {
            strAccount = [NSString stringWithFormat:@"%d Account", (int)accountCount];
        }
    }
    
    NSArray *arrPeople = [[DBManager sharedInstance] getInvoicePersonnel:invoice.invoiceID appID:invoice.invoiceAppID];
    NSInteger peopleCount = arrPeople.count;
    NSString *people = @"-";
    if (peopleCount > 0) {
        InvoicesPersonnel *invoicePersonnel = arrPeople[0];
        people = [[DBManager sharedInstance] getUserName:invoicePersonnel.userID];
        if (peopleCount > 1) {
            people = [NSString stringWithFormat:@"%d People", (int)peopleCount];
        }
    }
    
    cell.value4Width.constant = 0.0f;
    [cell.contentView layoutIfNeeded];
    
    
    
    switch (m_sorttype) {
        case PRIMARY:
        case SECONDARY:
        case EXPORT:
        {
            cell.value4Width.constant = 80.0f;
            [cell.contentView layoutIfNeeded];
            
            cell.lblValue1.text = [df stringFromDate:invoiceDate];
            cell.lblValue2.text = wellNumber == nil ? leaseName: [NSString stringWithFormat:@"%@ - %@", leaseName, wellNumber];
            cell.lblValue3.text = strAccount;
            cell.lblValue4.text = people;
            break;
        }
        case DATE:
        {
            cell.lblValue1.text = wellNumber == nil ? leaseName: [NSString stringWithFormat:@"%@ - %@", leaseName, wellNumber];
            cell.lblValue2.text = strAccount;
            cell.lblValue3.text = people;
            break;
        }
        case LEASE:
        {
            cell.value4Width.constant = 60.0f;
            [cell.contentView layoutIfNeeded];

            cell.lblValue1.text = [df stringFromDate:invoiceDate];
            cell.lblValue2.text = strAccount;
            cell.lblValue3.text = people;
            cell.lblValue4.text = wellNumber == nil ? @"-": wellNumber;
            break;
        }
        case ACCOUNT:
        {
            cell.lblValue1.text = [df stringFromDate:invoiceDate];
            cell.lblValue2.text = wellNumber == nil? leaseName: [NSString stringWithFormat:@"%@ - %@", leaseName, wellNumber];
            cell.lblValue3.text = people;
            break;
        }
        case PEOPLE:
        {
            cell.lblValue1.text = [df stringFromDate:invoiceDate];
            cell.lblValue2.text = wellNumber == nil? leaseName: [NSString stringWithFormat:@"%@ - %@", leaseName, wellNumber];
            cell.lblValue3.text = strAccount;
            break;
        }
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
    float height = 0;
    switch (m_sorttype) {
        case PRIMARY:
        case SECONDARY:
        case EXPORT:
            height = 0;
            break;
        default:
            height = 35;
            break;
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    InvoiceSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceSectionCell"];
    NSString *strTitle = @"";

    switch (m_sorttype) {
        case DATE:
        {
            NSDictionary *dic = self.arrInvoicesByDate[section];
            strTitle = [dic valueForKey:@"sortvalue"];
            break;
        }
        case LEASE:
        {
            NSDictionary *dic = self.arrInvoicesByLease[section];
            NSString *lease = [dic valueForKey:@"sortvalue"];
            NSString *leaseName = [[DBManager sharedInstance] getLeaseNameFromPropNum:lease];
            strTitle = leaseName;
            break;
        }
        case ACCOUNT:
        {
            NSDictionary *dic = self.arrInvoicesByAccount[section];
            strTitle = [dic valueForKey:@"sortvalue"];
            break;
        }
        case PEOPLE:
        {
            NSDictionary *dic = self.arrInvoicesByPeople[section];
            strTitle = [dic valueForKey:@"sortvalue"];
            break;
        }
        default:
            break;
    }

    cell.lblDate.text = strTitle;
    [cell.btnHeader setTag:section];

    if ([arrSectionStatus[section] isEqual:@"close"]) {
        cell.imgDropdown.image = [UIImage imageNamed:@"dropdown_icon"];
    } else {
        cell.imgDropdown.image = [UIImage imageNamed:@"dropup_icon"];
    }


    [cell.contentView.layer setMasksToBounds:NO];
    cell.viewBackground.layer.masksToBounds = NO;
    cell.viewBackground.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.viewBackground.layer.shadowOffset = CGSizeMake(1, 2);
    cell.viewBackground.layer.shadowRadius = 3.0f;
    cell.viewBackground.layer.shadowOpacity = 0.3f;

    UIView *view = [cell contentView];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceDetailContainerVC *detailContainerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceDetailContainerVC"];
    switch (m_sorttype) {
        case PRIMARY:
            detailContainerVC.arrInvoicesData = self.arrInvoicesPrimary;
            break;
        case SECONDARY:
            detailContainerVC.arrInvoicesData = self.arrInvoicesSecondary;
            break;
        case EXPORT:
            detailContainerVC.arrInvoicesData = self.arrInvoicesExport;
            break;
        case DATE:
            detailContainerVC.arrInvoicesData = self.arrInvoicesByDate;
            break;
        case LEASE:
            detailContainerVC.arrInvoicesData = self.arrInvoicesByLease;
            break;
        case ACCOUNT:
            detailContainerVC.arrInvoicesData = self.arrInvoicesByAccount;
            break;
        case PEOPLE:
            detailContainerVC.arrInvoicesData = self.arrInvoicesByPeople;
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
        case PRIMARY:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrInvoicesPrimary.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case SECONDARY:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrInvoicesSecondary.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case EXPORT:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrInvoicesExport.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case DATE:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrInvoicesByDate.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case LEASE:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrInvoicesByLease.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case ACCOUNT:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrInvoicesByAccount.count; i++) {
                [arrSectionStatus addObject:@"open"];
            }
            break;
        case PEOPLE:
            [arrSectionStatus removeAllObjects];
            for (int i = 0; i < self.arrInvoicesByPeople.count; i++) {
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
    self.title4WidthConstraint.constant = 0.0f;
    [self.view layoutIfNeeded];
    
    switch (m_sorttype) {
        case DATE:
            self.lblTitle1.text = @"PROPERTY";
            self.lblTitle2.text = @"ACCT";
            self.lblTitle3.text = @"PEOPLE";
            break;
        case LEASE:
            self.lblTitle1.text = @"DATE";
            self.lblTitle2.text = @"ACCT";
            self.lblTitle3.text = @"PEOPLE";
            self.lblTitle4.text = @"Well #";
            self.title4WidthConstraint.constant = 60.0f;
            [self.view layoutIfNeeded];
            break;
        case ACCOUNT:
            self.lblTitle1.text = @"DATE";
            self.lblTitle2.text = @"PROPERTY";
            self.lblTitle3.text = @"PEOPLE";
            break;
        case PEOPLE:
            self.lblTitle1.text = @"DATE";
            self.lblTitle2.text = @"PROPERTY";
            self.lblTitle3.text = @"ACCT";
            break;
        default:
            self.lblTitle1.text = @"DATE";
            self.lblTitle2.text = @"PROPERTY";
            self.lblTitle3.text = @"ACCT";
            self.lblTitle4.text = @"PEOPLE";
            self.title4WidthConstraint.constant = 80.0f;
            [self.view layoutIfNeeded];
            break;
    }
}

#pragma mark - buttton events

- (IBAction)onSortType:(id)sender {
    
    NSArray *arrSortTypes = @[@"DATE", @"LEASE", @"ACCOUNT", @"PEOPLE", @"PRIMARY APPROVAL", @"SECONDARY APPROVAL", @"AWAITING EXPORT"];
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Sort Types" rows:arrSortTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
        {
            self.lblSortType.text = arrSortTypes[selectedIndex];
                                                 
            switch (selectedIndex) {
                case 0:
                    m_sorttype = DATE;
                    break;
                case 1:
                    m_sorttype = LEASE;
                    break;
                case 2:
                    m_sorttype = ACCOUNT;
                    break;
                case 3:
                    m_sorttype = PEOPLE;
                    break;
                case 4:
                    m_sorttype = PRIMARY;
                    break;
                case 5:
                    m_sorttype = SECONDARY;
                    break;
                case 6:
                    m_sorttype = EXPORT;
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

- (IBAction)onCreateInvoice:(id)sender {
    OperationsVC *vc = (OperationsVC*)self.parentViewController;
    [vc createInvoice];
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
    if ([self.presentedViewController isKindOfClass:[InvoicesPopupVC class]]) {
        return nil;
    }
    NSLog(@"point for origin location: x = %f, y = %f", location.x, location.y);
    
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    
    NSLog(@"point for tableview location: x = %f, y = %f", cellPostion.x, cellPostion.y);
    NSLog(@"tableview location: x = %f, y = %f", self.tableView.frame.origin.x, self.tableView.frame.origin.y);
    NSLog(@"super location: x = %f, y = %f", self.view.frame.origin.x, self.view.frame.origin.y);
//    if (![self isForceTouchAvailable]) {
//        cellPostion = location;
//
//    }
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (path) {
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
        
        CGRect rect = tableCell.frame;
        NSLog(@"got cell rect: x = %f, y = %f", rect.origin.x, rect.origin.y);
        CGPoint yOffset = self.tableView.contentOffset;
        rect.origin.y += self.tableView.frame.origin.y - yOffset.y;
        NSLog(@"real rect: x = %f, y = %f", rect.origin.x, rect.origin.y);
//        rect.origin.y += ((OperationsVC* )self.parentOperationVC).invoicesContainerView.frame.origin.y;
        [previewingContext setSourceRect:rect];
        
        // set the view controller by initializing it form the storyboard
        InvoicesPopupVC *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoicesPopupVC"];
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        switch (m_sorttype) {
            case PRIMARY:
                dic = self.arrInvoicesPrimary[path.section];
                break;
            case SECONDARY:
                dic = self.arrInvoicesSecondary[path.section];
                break;
            case EXPORT:
                dic = self.arrInvoicesExport[path.section];
                break;
            case DATE:
                dic = self.arrInvoicesByDate[path.section];
                break;
            case LEASE:
                dic = self.arrInvoicesByLease[path.section];
                break;
            case ACCOUNT:
                dic = self.arrInvoicesByAccount[path.section];
                break;
            case PEOPLE:
                dic = self.arrInvoicesByPeople[path.section];
                break;
            default:
                break;
        }

        NSArray *arrData = [dic valueForKey:@"data"];
        Invoices *invoice = arrData[path.row];
        
        previewController.invoice = invoice;
        
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
