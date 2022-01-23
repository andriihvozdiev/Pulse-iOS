#import "NewTaskVC.h"
#import "HapticHelper.h"
#import "ActionSheetStringPicker.h"

#import "NewScheduleHeaderCell.h"
#import "NewScheduleContentCell.h"
#import "NewScheduleCommentCell.h"

#import "SelectDatesVC.h"
#import "ScheduleCommentVC.h"

@interface NewTaskVC ()
{
    BOOL isExistingWellNumber;
}
@end

@implementation NewTaskVC

@synthesize arrSectionTitles;
@synthesize arrWells;
@synthesize arrWellNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.btnCreate.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnCreate.layer.borderWidth = 1.0;
    self.btnCreate.layer.cornerRadius = 3.0f;
    
    
    arrSectionTitles = [NSMutableArray arrayWithArray:@[@"Add Lease", @"Add WellNumber", @"Add Date", @"Add Schedule Type", @"Add Comment"]];
    isExistingWellNumber = NO;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 35;
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initData
{
    self.strSelectedLease = @"";
    
    arrWells = [[NSArray alloc] init];
    arrWellNumber = [[NSMutableArray alloc] init];
    
    [[AppData sharedInstance].arrSelectedDates removeAllObjects];
    [[AppData sharedInstance].arrScheduleComments removeAllObjects];
    
    
    // get Leases
    [[AppData sharedInstance] getLeases];
    self.arrScheduleTypes = [[DBManager sharedInstance] getScheduleTypesByCategory:@"Operations"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
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


#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSInteger number = 0;
    switch (section) {
        case 0:
        case 1:
        case 3:
            number = 0;
            break;
        case 2:
            number = [AppData sharedInstance].arrSelectedDates.count;
            break;
        case 4:
            number = [AppData sharedInstance].arrScheduleComments.count;
            break;
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    switch (section) {
        case 2:
        {
            NewScheduleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewScheduleContentCell" forIndexPath:indexPath];
            NSDictionary *dic = [AppData sharedInstance].arrSelectedDates[row];
            cell.lblTitle.text = [dic valueForKey:@"key"];
            cell.lblContent.text = [dic valueForKey:@"date"];
            return cell;
        }
            break;
        case 4:
        {
            NSDictionary *dic = [AppData sharedInstance].arrScheduleComments[row];
            NewScheduleCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"NewScheduleCommentCell" forIndexPath:indexPath];
            commentCell.lblKey.text = [dic valueForKey:@"key"];
            commentCell.lblComment.text = [dic valueForKey:@"comment"];
            return commentCell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NewScheduleHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewScheduleHeaderCell"];
    cell.lblTitle.text = arrSectionTitles[section];
    [cell.btnAdd setTag:section];
    
    if (section == 1) {
        [cell.lblTitle setTextColor:[UIColor lightGrayColor]];
        
        if (isExistingWellNumber) {
            [cell.lblTitle setTextColor:[UIColor whiteColor]];
        }
    }
    
    return cell.contentView;
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

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCreate:(id)sender
{
    
    if ([arrSectionTitles[0] isEqualToString:@"Add Lease"]) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Lease"];
        return;
    }
    
    if ([AppData sharedInstance].arrSelectedDates.count == 0) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Dates"];
        return;
    }
    
    if ([arrSectionTitles[3] isEqualToString:@"Add Schedule Type"]) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Schedule Type"];
        return;
    }
    
    NSString *strUserID = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:strUserID forKey:@"userid"];
    [dicParam setObject:self.strSelectedLease forKey:@"lease"];
    
    if (![arrSectionTitles[1] isEqualToString:@"Add WellNumber"]) {
        [dicParam setObject:arrSectionTitles[1] forKey:@"wellnumber"];    
    }
    
    [dicParam setObject:arrSectionTitles[3] forKey:@"scheduletype"];
    [dicParam setObject:[AppData sharedInstance].arrSelectedDates forKey:@"dates"];
    [dicParam setObject:[AppData sharedInstance].arrScheduleComments forKey:@"comments"];
    
    NSLog(@"%@", dicParam);
    
    if ([[DBManager sharedInstance] createSchedule:dicParam]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Created New Task Successfully." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        [self showDefaultAlert:nil withMessage:@"Create a New Task Failed."];
    }
    
}

- (IBAction)onHeaderTapped:(id)sender
{
    NSInteger section = [(UIButton*)sender tag];
    switch (section) {
        case 0:
            [self onLease];
            break;
        case 1:
            [self onWellNumber];
            break;
        case 2:
        {
            SelectDatesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectDatesVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
            [self onScheduleType];
            break;
        case 4:
        {
            ScheduleCommentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleCommentVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark -
- (void)onLease
{
    if ([AppData sharedInstance].arrLeases.count == 0) {
        return;
    }
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Leases" rows:[AppData sharedInstance].arrLeaseNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrSectionTitles replaceObjectAtIndex:0 withObject:[AppData sharedInstance].arrLeaseNames[selectedIndex]];
        [arrSectionTitles replaceObjectAtIndex:1 withObject:@"Add WellNumber"];
        
        [self.tableView reloadData];
        
        self.strSelectedLease = [AppData sharedInstance].arrLeases[selectedIndex];
        [self getWellList:[AppData sharedInstance].arrLeases[selectedIndex]];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) getWellList:(NSString*)lease
{
   
    arrWells = [[NSArray alloc] init];
    [arrWellNumber removeAllObjects];
    isExistingWellNumber = NO;
    
    arrWells = [[DBManager sharedInstance] getWellListByLease:lease];
    if (arrWells == nil || arrWells.count == 0) {
        isExistingWellNumber = NO;
    }
    
    for (WellList *wellList in arrWells) {
        NSString *strWellNumber = wellList.wellNumber;
        [arrWellNumber addObject:strWellNumber];
        isExistingWellNumber = YES;
    }
    [self.tableView reloadData];
    
}

-(void)onWellNumber
{
    if (arrWellNumber.count == 0) {
        return;
    }
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Well Numbers" rows:arrWellNumber initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrSectionTitles replaceObjectAtIndex:1 withObject:arrWellNumber[selectedIndex]];
        
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}


-(void)onScheduleType
{
    if (self.arrScheduleTypes.count == 0) {
        return;
    }
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Schedule Type" rows:self.arrScheduleTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrSectionTitles replaceObjectAtIndex:3 withObject:self.arrScheduleTypes[selectedIndex]];
        
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) showDefaultAlert:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
