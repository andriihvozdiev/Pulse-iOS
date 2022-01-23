#import "ProductionMainVC.h"
#import "ProductionMainTableCell.h"
#import "ProductionSortHeaderCell.h"

#import "ProductionDetailMainVC.h"
#import "ProductionMainPopupVC.h"

#import "ActionSheetStringPicker.h"
#import "HapticHelper.h"
#import "RangePickerViewController.h"
@import PeekPop;

@interface ProductionMainVC () <PeekPopPreviewingDelegate, UISearchResultsUpdating, UITextFieldDelegate, UISearchBarDelegate, UISearchControllerDelegate>
{
    RangePickerViewController *rangePickerVC;
    UITextField *searchTxtField;
    NSString *strSearchText;
    BOOL isSearchMode;
    UISearchController *searchController;
    NSMutableArray *arrFilteredProduct;
//    UISearchBar *searchBar;
}

@end

@implementation ProductionMainVC

@synthesize arrSectionStatus;
@synthesize searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.peekPop = [[PeekPop alloc] initWithViewController:self];
    self.previewingContext = [self.peekPop registerForPreviewingWithDelegate:self sourceView:self.view];
    m_sorttype = Date;
    arrSectionStatus = [[NSMutableArray alloc] init];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
//    self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    rangePickerVC = [[RangePickerViewController alloc] init];
    [self setupSearchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.tag = 0;
    
    [self initData];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
    
}

- (void)setupSearchBar {
    strSearchText = @"";
    isSearchMode = NO;
//    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    searchController.searchResultsUpdater = self;
//    searchController.obscuresBackgroundDuringPresentation = false;
//    searchController.searchBar.placeholder = @"Search for lease";
//    self.tableView.tableHeaderView = searchController.searchBar;
//    searchController.dimsBackgroundDuringPresentation = NO;
//    searchController.hidesNavigationBarDuringPresentation = NO;
    
//    searchBar = [[UISearchBar alloc] init];
//    self.tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
    searchBar.layer.borderColor = [UIColor clearColor].CGColor;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.tintColor = [UIColor colorWithWhite:1 alpha:1.0f];
    searchBar.placeholder = @"Search for Lease";
    [self.tableView setContentOffset:CGPointMake(0, searchBar.frame.size.height)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:36 / 255.0 blue:63 / 255.0 alpha:1.0f];
    self.shadowView.layer.masksToBounds = NO;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowRadius = 3.0f;
    self.shadowView.layer.shadowOpacity = 0.3f;
    UITextField *txfSearchField;
    if (@available(iOS 13.0, *)) {
        txfSearchField = searchBar.searchTextField;
    } else {
        txfSearchField = [searchBar valueForKey:@"_searchField"];
    }
    searchTxtField = txfSearchField;
    searchTxtField.textColor = [UIColor whiteColor];
    txfSearchField.tag = 111;
    txfSearchField.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:36 / 255.0 blue:63 / 255.0 alpha:1.0f];
}

-(void) initData
{
    self.arrLeaseByAll = [[DBManager sharedInstance] getLeaseDataByAll];
    self.arrLeaseByDate = [[DBManager sharedInstance] getLeaseDataByDate];
    self.arrLeaseByRoute = [[DBManager sharedInstance] getLeaseDataByRoute];
    self.arrLeaseByOperator = [[DBManager sharedInstance] getLeaseDataByOperator];
    self.arrLeaseByOwner = [[DBManager sharedInstance] getLeaseDataByOwner];
//
//    self.arrLeaseByAllFilter = [self.arrLeaseByAll copy];
//    self.arrLeaseByDateFilter = [self.arrLeaseByDate copy];
//    self.arrLeaseByRouteFilter = [self.arrLeaseByRoute copy];
//    self.arrLeaseByOperatorFilter = [self.arrLeaseByOperator copy];
//    self.arrLeaseByOwnerFilter = [self.arrLeaseByOwner copy];
    
    [self initSectionStatus];
    [self.tableView reloadData];
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
            [self initData];
            break;
        default:
            break;
    }
}

- (IBAction)onLongPressTitle:(id)sender {
//    [self setCustomDateRange];
}

- (void)setCustomDateRange {
    [self presentViewController:rangePickerVC animated:YES completion:nil];
//    NSInteger settedIndex = 0;
    
//    ActionSheetDatePicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Number of Days to Sync" rows:arrInterval initialSelection:settedIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
//                                             {
//                                                 [[NSUserDefaults standardUserDefaults] setValue:arrInterval[selectedIndex] forKey:S_DaysToSync];
//                                                 [[WebServiceManager sharedInstance] setDaysToSync];
//                                                 [self.tableView reloadData];
//                                             } cancelBlock:^(ActionSheetStringPicker *picker) {
//
//                                             } origin:self.tableView];
//
//    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
//    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
//
//    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
//    [stringPicker setTextColor:[UIColor whiteColor]];
//    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

#pragma mark - ChangedStatusDelegate
-(void)changedSyncStatus
{
    [self showSyncStatus];
}


#pragma mark -
-(void) initSectionStatus
{
    if (isSearchMode) {
        [arrSectionStatus removeAllObjects];
        for (int i = 0; i < arrFilteredProduct.count; i++) {
            [arrSectionStatus addObject:@"open"];
        }
    } else {
        switch (m_sorttype) {
            case All:
                [arrSectionStatus removeAllObjects];
                for (int i = 0; i < self.arrLeaseByAll.count; i++) {
                    [arrSectionStatus addObject:@"open"];
                }
                break;
            case Date:
                [arrSectionStatus removeAllObjects];
                for (int i = 0; i < self.arrLeaseByDate.count; i++) {
                    [arrSectionStatus addObject:@"open"];
                }
                break;
            case Route:
                [arrSectionStatus removeAllObjects];
                for (int i = 0; i < self.arrLeaseByRoute.count; i++) {
                    [arrSectionStatus addObject:@"open"];
                }
                break;
            case Operator:
                [arrSectionStatus removeAllObjects];
                for (int i = 0; i < self.arrLeaseByOperator.count; i++) {
                    [arrSectionStatus addObject:@"open"];
                }
                break;
            case Owner:
                [arrSectionStatus removeAllObjects];
                for (int i = 0; i < self.arrLeaseByOwner.count; i++) {
                    [arrSectionStatus addObject:@"open"];
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark - tableview database
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    if (isSearchMode) {
        count = arrFilteredProduct.count;
    } else {
        switch (m_sorttype) {
            case All:
                count = self.arrLeaseByAll.count;
                break;
            case Date:
                count = self.arrLeaseByDate.count;
                break;
            case Route:
                count = self.arrLeaseByRoute.count;
                break;
            case Operator:
                count = self.arrLeaseByOperator.count;
                break;
            case Owner:
                count = self.arrLeaseByOwner.count;
                break;
            default:
                break;
        }
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
    if (isSearchMode) {
        dic = arrFilteredProduct[section];
    } else {
        switch (m_sorttype) {
            case All:
                dic = self.arrLeaseByAll[section];
                break;
            case Date:
                dic = self.arrLeaseByDate[section];
                break;
            case Route:
                dic = self.arrLeaseByRoute[section];
                break;
            case Operator:
                dic = self.arrLeaseByOperator[section];
                break;
            case Owner:
                dic = self.arrLeaseByOwner[section];
                break;
            default:
                break;
        }
    }
    
    NSArray *arrData = [dic valueForKey:@"data"];
    count = arrData.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductionMainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionTableCellIdentifier" forIndexPath:indexPath];

    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    NSDictionary *dic = [[NSDictionary alloc]init];
    if (isSearchMode) {
        dic = arrFilteredProduct[section];
    } else {
        switch (m_sorttype) {
            case All:
                dic = self.arrLeaseByAll[section];
                break;
            case Date:
                dic = self.arrLeaseByDate[section];
                break;
            case Route:
                dic = self.arrLeaseByRoute[section];
                break;
            case Operator:
                dic = self.arrLeaseByOperator[section];
                break;
            case Owner:
                dic = self.arrLeaseByOwner[section];
                break;
            default:
                break;
        }
    }
    NSArray *arrData = [dic valueForKey:@"data"];
    
    PulseProdHome *pulseProdHome = arrData[row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    if (pulseProdHome.date) {
        NSString *strDate = @"";
        if ((pulseProdHome.gasComments && ![pulseProdHome.gasComments isEqual:@""]) ||
            (pulseProdHome.waterComments && ![pulseProdHome.waterComments isEqual:@""]) ||
            (pulseProdHome.oilComments && ![pulseProdHome.oilComments isEqual:@""]) ||
            (pulseProdHome.wellheadComments && ![pulseProdHome.wellheadComments isEqual:@""]))
        {
            strDate = [NSString stringWithFormat:@"%@*", [df stringFromDate:pulseProdHome.date]];
        } else {
            strDate = [df stringFromDate:pulseProdHome.date];
        }
        
        if (pulseProdHome.wellheadData && ![pulseProdHome.wellheadData isEqual:@""]) {
            strDate = [NSString stringWithFormat:@"%@†", strDate];
        }
        
        cell.lblDate.text = strDate;
    } else {
        cell.lblDate.text = @"-";
    }
    
    
    cell.lblLease.text = pulseProdHome.leaseName;
    cell.lblGas.text = [self getStringValue:pulseProdHome.gasVol];
    cell.lblOil	.text = [self getStringValue:pulseProdHome.oilVol];
    cell.lblWater.text = [self getStringValue:pulseProdHome.waterVol];
    
    return cell;
}

-(NSString*)getStringValue:(id)value
{
    NSString *result = @"";
    if (value != nil) {
        float v = [value floatValue];
        
        if (v >= 100) {
            result = [NSString stringWithFormat:@"%.0f", [value floatValue]];
        } else if (v < 100)
        {
            result = [NSString stringWithFormat:@"%.1f", [value floatValue]];
        }
    }
    else
    {
        result = @"-";
    }
    
    return result;
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
    ProductionSortHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionSortHeaderCell"];
    NSString *strTitle = @"";
    if (isSearchMode) {
        switch (m_sorttype) {
            case All:
            {
                NSString *strSortValue = @"All";
                strTitle = strSortValue;
            }
                break;
            case Date:
            {
                NSString *strSortValue = @"Date";
                strTitle = strSortValue;
            }
                break;
            case Route:
            {
                NSDictionary *dic = self.arrLeaseByRoute[section];
                NSString *strSortValue = [dic valueForKey:@"sortvalue"];
                strTitle = [NSString stringWithFormat:@"%@ Route", strSortValue];
            }
                break;
            default:
            {
                NSDictionary *dic = arrFilteredProduct[section];
                NSString *strSortValue = [dic valueForKey:@"sortvalue"];
                strTitle = strSortValue;
            }
                break;
        }
    } else {
        switch (m_sorttype) {
            case All:
            {
                NSString *strSortValue = @"All";
                strTitle = strSortValue;
            }
                break;
            case Date:
            {
                NSString *strSortValue = @"Date";
                strTitle = strSortValue;
            }
                break;
            case Route:
            {
                NSDictionary *dic = self.arrLeaseByRoute[section];
                NSString *strSortValue = [dic valueForKey:@"sortvalue"];
                strTitle = [NSString stringWithFormat:@"%@ Route", strSortValue];
            }
                break;
            case Operator:
            {
                NSDictionary *dic = self.arrLeaseByOperator[section];
                NSString *strSortValue = [dic valueForKey:@"sortvalue"];
                strTitle = strSortValue;
            }
                break;
            case Owner:
            {
                NSDictionary *dic = self.arrLeaseByOwner[section];
                NSString *strSortValue = [dic valueForKey:@"sortvalue"];
                strTitle = strSortValue;
            }
                break;
            default:
                break;
        }
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
    cell.imgBackground.layer.masksToBounds = NO;
    cell.imgBackground.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.imgBackground.layer.shadowOffset = CGSizeMake(1, 1);
    cell.imgBackground.layer.shadowRadius = 3.0f;
    cell.imgBackground.layer.shadowOpacity = 0.3f;
    
    UIView *view = [cell contentView];
    
//    [[UISearchBar appearance] setBackgroundColor:[UIColor redColor]];
    return view;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ProductionDetailMainVC *detailVC = [segue destinationViewController];
    detailVC.view.tag = 10;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (isSearchMode) {
        dic = arrFilteredProduct[section];
    } else {
        switch (m_sorttype) {
            case All:
                dic = self.arrLeaseByAll[section];
                break;
            case Date:
                dic = self.arrLeaseByDate[section];
                break;
            case Route:
                dic = self.arrLeaseByRoute[section];
                break;
            case Operator:
                dic = self.arrLeaseByOperator[section];
                break;
            case Owner:
                dic = self.arrLeaseByOwner[section];
                break;
            default:
                break;
        }
    }
    NSArray *arrData = [dic valueForKey:@"data"];
    
    PulseProdHome *pulseProdHome = arrData[row];
    
    detailVC.pulseProdHome = pulseProdHome;
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

- (IBAction)onDropDown:(id)sender {
    NSArray *arrSortTypes = @[@"Date", @"ALL", @"ROUTE", @"OPERATOR", @"OWNER"];
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Sort Types" rows:arrSortTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         self.lblNavTitle.text = arrSortTypes[selectedIndex];
         
         switch (selectedIndex) {
             case 0:
                 m_sorttype = Date;
                 break;
             case 1:
                 m_sorttype = All;
                 break;
             case 2:
                 m_sorttype = Route;
                 break;
             case 3:
                 m_sorttype = Operator;
                 break;
             case 4:
                 m_sorttype = Owner;
                 break;
             default:
                 break;
         }
         [self initSectionStatus];
         [self.tableView reloadData];
         
     } cancelBlock:^(ActionSheetStringPicker *picker) {
         
     } origin:self.lblNavTitle];
    
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

#pragma mark - search
- (void)updateSearch:(NSString *)searchKeyword {
    searchKeyword = [searchKeyword lowercaseString];
    if (isSearchMode) {
        NSMutableArray *arySearchContent = [[NSMutableArray alloc] init];
        NSMutableArray *arySearchResult = [[NSMutableArray alloc] init];
        switch (m_sorttype) {
            case All:
                arySearchContent = [self.arrLeaseByAll mutableCopy];
                break;
            case Date:
                arySearchContent = [self.arrLeaseByDate mutableCopy];
                break;
            case Route:
                arySearchContent = [self.arrLeaseByRoute mutableCopy];
                break;
            case Operator:
                arySearchContent = [self.arrLeaseByOperator mutableCopy];
                break;
            case Owner:
                arySearchContent = [self.arrLeaseByOwner mutableCopy];
                break;
            default:
                break;
        }
        if (![searchKeyword isEqualToString:@""]) {
            for (NSDictionary *dic in arySearchContent) {
                NSArray *aryData = dic[@"data"];
                NSMutableArray *aryTmpResult = [[NSMutableArray alloc] init];
                for (PulseProdHome *prod in aryData) {
                    NSString *leaseName = [prod.leaseName lowercaseString];
                    NSLog(@"Lease Name: %@", leaseName);
                    
                    if ([leaseName containsString:searchKeyword]) {
                        [aryTmpResult addObject:prod];
                    }
                }
                if (aryTmpResult.count > 0) {
                    NSDictionary * resultDic = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"sortvalue"], @"sortvalue", aryTmpResult, @"data", nil];
                    [arySearchResult addObject:resultDic];
                }
            }
        } else {
            arySearchResult = arySearchContent;
        }
        arrFilteredProduct = [arySearchResult copy];
        [self.tableView reloadData];
    }
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
    if ([self.presentedViewController isKindOfClass:[ProductionMainPopupVC class]]) {
        return nil;
    }
    NSLog(@"point for origin location: x = %f, y = %f", location.x, location.y);
    
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
//    if (![self isForceTouchAvailable]) {
//        cellPostion = location;
//    }
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (path) {
        NSLog(@"touch path: %@, touch row: %ld", path, (long)path.row);
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
        
        CGRect rect = tableCell.frame;
        CGPoint offset = self.tableView.contentOffset;
        if (![self isForceTouchAvailable]) {
//            rect.origin.y -= offset.y;
//            [HapticHelper generateFeedback:FeedbackType_Impact_Medium];

        } else {
            
        }
        rect.origin.y += self.tableView.frame.origin.y - offset.y;
        [previewingContext setSourceRect:rect];
        
        // set the view controller by initializing it form the storyboard
        ProductionMainPopupVC *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductionMainPopupVC"];
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        if (isSearchMode) {
            dic = arrFilteredProduct[path.section];
        } else {
            switch (m_sorttype) {
                case All:
                    dic = self.arrLeaseByAll[path.section];
                    break;
                case Date:
                    dic = self.arrLeaseByDate[path.section];
                    break;
                case Route:
                    dic = self.arrLeaseByRoute[path.section];
                    break;
                case Operator:
                    dic = self.arrLeaseByOperator[path.section];
                    break;
                case Owner:
                    dic = self.arrLeaseByOwner[path.section];
                    break;
                default:
                    break;
            }
        }
        NSArray *arrData = [dic valueForKey:@"data"];
        PulseProdHome *pulseProdHome = arrData[path.row];
        previewController.pulseProdHome = pulseProdHome;
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


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (!self.previewingContext) {
        self.previewingContext = [self.peekPop registerForPreviewingWithDelegate:self sourceView:self.view];
    }
//    if ([self isForceTouchAvailable]) {
//
//    } else {
//        if (self.previewingContext) {
////            [self unregisterForPreviewingWithContext:self.previewingContext];
//            self.previewingContext = nil;
//        }
//    }
}

#pragma mark - UISearchController & UISearchBar Delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString *searchString = searchTxtField.text;
 
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateSearch:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {
        isSearchMode = NO;
        [searchBar resignFirstResponder];
        [self.tableView reloadData];
    } else {
        [searchBar resignFirstResponder];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    isSearchMode = YES;
//    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    UITextField *textField;
    if (@available(iOS 13.0, *)) {
        textField = searchBar.searchTextField;
    } else {
        textField = [searchBar valueForKey:@"_searchField"];
    }
    [textField setText:@""];
    isSearchMode = NO;
    
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

-(void)willPresentSearchController:(UISearchController *)searchController{
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self.tableView
     setContentOffset:CGPointMake(0.0f, -self.tableView.contentInset.top) animated:YES];
}

-(void)willDismissSearchController:(UISearchController *)searchController{
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField.tag == 1111) {
//        return [textField resignFirstResponder];
//    }
    return NO;
}

@end
