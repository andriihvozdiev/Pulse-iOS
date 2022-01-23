
#import "MeterDataVC.h"
#import "MeterDataGraphVC.h"
#import "MeterOverviewHeaderCell.h"
#import "MeterOverviewContentCell.h"
#import "MeterDateCell.h"
#import "WaterMeterContentCell.h"
#import "GasMeterContentCell.h"
#import "HapticHelper.h"

#import "ProductionDetailMainVC.h"
#import "AddMeterDataVC.h"
#import "WellheadDataVC.h"

@interface MeterDataVC ()
{
    NSMutableArray *arrSectionStatus;
    MeterDataGraphVC *graphVC;
}
@end

@implementation MeterDataVC
@synthesize pulseProdHome;

@synthesize arrMeterData;
@synthesize arrMeterRates;
@synthesize meter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.graphContainerView setHidden:YES];
    
    meter = self.arrMeters[self.selectedIndex];
    
    self.lblTitle.text = pulseProdHome.leaseName;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
    
    [self.viewData setHidden:YES];
    [self.viewOverview setHidden:NO];
    
    self.btnAddMeterData.layer.cornerRadius = 3.0f;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    self.arrOverviewSectionHeaderTitles = @[@"Flow", @"Volume", @"Pressure"];
    self.arrOverviewSectionContentTitles = @[@[@"Current"], @[@"24Hour Vol", @"Total"], @[@"Line Pressure", @"Differential"]];
    arrSectionStatus = [@[@"open", @"open", @"open"] mutableCopy];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.tag = 10;
    
    [self initData];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
}

#pragma mark - swipe gestures

- (IBAction) handleLeftSwipe:(UISwipeGestureRecognizer*)recognizer
{
    NSLog(@"left");
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.width < screenSize.height) {
        if (self.arrMeters.count > self.selectedIndex + 1) {
            MeterDataVC *meterDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MeterDataVC"];
            meterDataVC.pulseProdHome = self.pulseProdHome;
            meterDataVC.arrMeters = self.arrMeters;
            meterDataVC.selectedIndex = self.selectedIndex + 1;
            meterDataVC.view.tag = 10;
            
            [self.navigationController pushViewController:meterDataVC animated:YES];
        }
    }    
}

- (IBAction) handleRightSwipe:(UISwipeGestureRecognizer*)recognizer
{
    NSLog(@"right");
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.width < screenSize.height) {
        self.view.tag = 0;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -

-(void)initData
{
    arrMeterData = [[NSArray alloc] init];
    arrMeterRates = [[NSArray alloc] init];
    
    NSString *strLease = meter.meterLease;
    NSString *strMeterID = [NSString stringWithFormat:@"%d", meter.meterID];
    NSString *strMeterType = meter.meterType;
    
    arrMeterData = [[DBManager sharedInstance] getMeterDataByLease:strLease meterID:strMeterID meterType:strMeterType];
    arrMeterRates = [self getMeterRates];
    
    if ([strMeterType isEqual:@"Gas"]) {
        self.arrOverviewSectionHeaderTitles = @[@"Flow", @"Volume", @"Pressure"];
        self.arrOverviewSectionContentTitles = @[@[@"Current"], @[@"24Hour Vol", @"Total"], @[@"Line Pressure", @"Differential"]];
        
    } else { //if ([strMeterType isEqual:@"Water"]) {
        self.arrOverviewSectionHeaderTitles = @[@"Flow", @"Volume"];
        self.arrOverviewSectionContentTitles = @[@[@"Current, BFPD", @"Yesterday Flow"], @[@"24 Hr Rate, BFPD", @"Total, bbls", @"Reset Volume"]];
        
    }
        
    [self refreshUIComponents];
    
    [self.dateTableView reloadData];
    [self.contentTableView reloadData];
}

-(NSArray*) getMeterRates
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    if (arrMeterData.count == 0) {
        return arrResult;
    }
    
    if ([meter.meterType isEqual:@"Gas"]){
        GasMeterData *meterData = arrMeterData[0];
        for (int i = 1; i < arrMeterData.count-1; i++) {
            
            GasMeterData *pulledMeterData = arrMeterData[i];
            
            NSDate *date1 = meterData.checkTime;
            NSDate * date2 = pulledMeterData.checkTime;
            
            if ([self isSameDay:date1 date2:date2]) {
                continue;
            }            
            
            NSTimeInterval secondsBetween = [date1 timeIntervalSinceDate:date2];
            float numberOfDays = secondsBetween / 86400.0f;
            
            float rate = ([self getFloatValue:meterData.meterCumVol availableMin:NO] - [self getFloatValue:pulledMeterData.meterCumVol availableMin:NO]) / numberOfDays;
            NSString *strRate = [NSString stringWithFormat:@"%.2f", rate];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [dic setValue:meterData.checkTime forKey:@"date"];
            [dic setValue:strRate forKey:@"rate"];
            
            [arrResult addObject:dic];
            meterData = pulledMeterData;
        }
    } else { //if ([meter.meterType isEqual:@"Water"]) {
        
        WaterMeterData *meterData = arrMeterData[0];
        for (int i = 1; i < arrMeterData.count-1; i++) {
            
            WaterMeterData *pulledMeterData = arrMeterData[i];
            
            NSDate *date1 = meterData.checkTime;
            NSDate * date2 = pulledMeterData.checkTime;
            
            if ([self isSameDay:date1 date2:date2]) {
                continue;
            }
            
            
            NSTimeInterval secondsBetween = [date1 timeIntervalSinceDate:date2];
            float numberOfDays = secondsBetween / 86400.0f;
            
            float rate = ([self getFloatValue:meterData.totalVolume availableMin:NO] - [self getFloatValue:pulledMeterData.totalVolume availableMin:NO]) / numberOfDays;
            NSString *strRate = [NSString stringWithFormat:@"%.2f", rate];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [dic setValue:meterData.checkTime forKey:@"date"];
            [dic setValue:strRate forKey:@"rate"];
            
            [arrResult addObject:dic];
            meterData = pulledMeterData;
        }
    }
    
    return arrResult;
}

-(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *strFirst = [df stringFromDate:date1];
    NSString *strSecond = [df stringFromDate:date2];
    
    if ([strFirst isEqual:strSecond]) {
        return YES;
    }
    
    return NO;
}

-(void)refreshUIComponents
{
    NSString *strFluidType = [meter.meterType lowercaseString];
    self.lblMeterTitle.text = [NSString stringWithFormat:@"%@ - %@", meter.meterName, meter.meterType];
    
    if ([strFluidType isEqual:@"gas"]) {
        [self.btnAddMeterData setTitle:@"Add Gas Data" forState:UIControlStateNormal];
    } else if ([strFluidType isEqual:@"water"]) {
        [self.btnAddMeterData setTitle:@"Add Water Data" forState:UIControlStateNormal];
    } else if ([strFluidType isEqual:@"oil"]) {
        [self.btnAddMeterData setTitle:@"Add Oil Data" forState:UIControlStateNormal];
    } else if ([strFluidType isEqual:@"total flui"]) {
        [self.btnAddMeterData setTitle:@"Add Meter Data" forState:UIControlStateNormal];
    }
    
    if (arrMeterData.count == 0) {
        
        self.lblDate.text = @"-";
        self.lblUser.text = @"-";
        self.lblMeterProblem.text = @"";
        
        self.lblComment.text = @"No Comment";
        
        return;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy hh:mm a"];
    
    if ([strFluidType isEqual:@"gas"]) {
        GasMeterData *gasMeterData = arrMeterData[0];
        
        NSString *strDateTime = [df stringFromDate:gasMeterData.checkTime];
        self.lblDate.text = strDateTime;
        self.lblUser.text = [[DBManager sharedInstance] getUserName:gasMeterData.userid];
        self.lblMeterProblem.text = [[DBManager sharedInstance] getMeterProblemReason:gasMeterData.meterProblem];
        
        if (gasMeterData.comments == nil || [gasMeterData.comments isEqual:@""]) {
            self.lblComment.text = @"No Comment";
            [self.lblComment setTextColor:[UIColor lightGrayColor]];
        } else {
            self.lblComment.text = gasMeterData.comments;
            [self.lblComment setTextColor:[UIColor whiteColor]];
        }
        
    } else {
        WaterMeterData *waterMeterData = arrMeterData[0];
        
        NSString *strDateTime = [df stringFromDate:waterMeterData.checkTime];
        self.lblDate.text = strDateTime;
        self.lblUser.text = [[DBManager sharedInstance] getUserName:waterMeterData.userid];
        self.lblMeterProblem.text = [[DBManager sharedInstance] getMeterProblemReason:waterMeterData.meterProblem];
        
        if (waterMeterData.comments == nil || [waterMeterData.comments isEqual:@""]) {
            self.lblComment.text = @"No Comment";
            [self.lblComment setTextColor:[UIColor lightGrayColor]];
        } else {
            self.lblComment.text = waterMeterData.comments;
            [self.lblComment setTextColor:[UIColor whiteColor]];
        }
    }
    
    [self.overviewTableView reloadData];
}

-(NSString*)getStringFromFloat:(id)value
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
        if (v < 10)
        {
            result = [NSString stringWithFormat:@"%.2f", [value floatValue]];
        }
    }
    else
    {
        result = @"-";
    }
    return result;
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
            [self initData];
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
            [self.graphContainerView setHidden:YES];
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            [self.graphContainerView setHidden:NO];
            if (self.navigationController.topViewController == self) {
                [self.tabBarController.tabBar setHidden:YES];
            }
            
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            
            graphVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MeterDataGraphVC"];
            CGRect rect  = CGRectMake(0, 0, screenSize.width, screenSize.height);
            graphVC.view.frame = rect;
            graphVC.meter = self.meter;
            graphVC.arrMeterData = self.arrMeterData;
            graphVC.arrMeterRates = self.arrMeterRates;
            
            [self addChildViewController:graphVC];
            [self.graphContainerView addSubview:graphVC.view];
            
        }
            break;
        default:
            break;
    }
    
}


 #pragma mark - Navigation
 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([segue.identifier isEqual:@"AddMeterDataSegue"]) {
        
        self.view.tag = 0;
        
        AddMeterDataVC *vc = [segue destinationViewController];
        vc.pulseProdHome = pulseProdHome;
        vc.meter = self.meter;
        vc.arrMeterData = arrMeterData;
        vc.isNew = YES;
    }
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

- (IBAction)onBack:(id)sender {
    self.view.tag = 0;
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[ProductionDetailMainVC class]]) {
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
}

- (IBAction)onOverview:(id)sender{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    [self.btnOverview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnData setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.viewData setHidden:YES];
    [self.viewOverview setHidden:NO];
}

- (IBAction)onData:(id)sender{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnOverview setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnData setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.viewOverview setHidden:YES];
    [self.viewData setHidden:NO];
    
}

- (IBAction)onSectionHeader:(id)sender {
    
    NSInteger tag = [sender tag];
    
    NSString *status = arrSectionStatus[tag];
    if ([status isEqual:@"open"]) {
        [arrSectionStatus replaceObjectAtIndex:tag withObject:@"close"];
    } else {
        [arrSectionStatus replaceObjectAtIndex:tag withObject:@"open"];
    }
    [self.overviewTableView reloadData];
}


#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 1;
    if (tableView == self.overviewTableView) {
        numberOfSections = self.arrOverviewSectionHeaderTitles.count;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (tableView == self.overviewTableView) {
        
        if ([arrSectionStatus[section] isEqual:@"open"]) {
            numberOfRows = ((NSArray*)self.arrOverviewSectionContentTitles[section]).count;
        } else {
            numberOfRows = 0;
        }
        
    } else {
        numberOfRows = arrMeterData.count;
    }
    
    return numberOfRows;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    GasMeterData *gasMeterData;
    WaterMeterData *waterMeterData;
    
    if (tableView.tag == 0) {
        MeterOverviewContentCell *overviewCell = [tableView dequeueReusableCellWithIdentifier:@"MeterOverviewContentCell" forIndexPath:indexPath];
        overviewCell.lblTitle.text = self.arrOverviewSectionContentTitles[section][row];
        overviewCell.lblValue.text = @"";
        
        if ([meter.meterType isEqual:@"Gas"]) {
            
            if (arrMeterData.count > 0) {
                gasMeterData = arrMeterData[0];
                switch (section) {
                    case 0: // Flow/Current
                        overviewCell.lblValue.text = [self getStringFromFloat:gasMeterData.currentFlow];
                        break;
                    case 1: // Volume
                        switch (row) {
                            case 0: // 24 hours(yesterday)
                                overviewCell.lblValue.text = [self getStringFromFloat:gasMeterData.yesterdayFlow];
                                break;
                            case 1: // Total
                                overviewCell.lblValue.text = [self getStringFromFloat:gasMeterData.meterCumVol];
                                break;
                            default:
                                break;
                        }
                        break;
                    case 2: // Pressure
                        switch (row) {
                            case 0: // Line Pressure
                                overviewCell.lblValue.text = [self getStringFromFloat:gasMeterData.linePressure];
                                break;
                            case 1: // Differential
                                overviewCell.lblValue.text = [self getStringFromFloat:gasMeterData.diffPressure];
                                break;
                            default:
                                break;
                        }
                        break;
                    default:
                        break;
                }
            }
            
        } else {
            
            if (arrMeterData.count > 0) {
                waterMeterData = arrMeterData[0];
                
                switch (section) {
                    case 0: // Flow
                        switch (row) {
                            case 0: // Current
                                overviewCell.lblValue.text = [self getStringFromFloat:waterMeterData.currentFlow];
                                break;
                            case 1: // Yesterday Flow
                                overviewCell.lblValue.text = [self getStringFromFloat:waterMeterData.yesterdayFlow];
                                break;
                            default:
                                break;
                        }
                        break;
                    case 1: // Volume
                        switch (row) {
                            case 0: // 24 Hr Rate, BFPD
                                overviewCell.lblValue.text = [self getStringFromFloat:waterMeterData.vol24Hr];
                                break;
                            case 1: // Total, bbls
                                overviewCell.lblValue.text = [self getStringFromFloat:waterMeterData.totalVolume];
                                break;
                            case 2: // Total, bbls
                                overviewCell.lblValue.text = [self getStringFromFloat:waterMeterData.resetVolume];
                                break;
                            default:
                                break;
                        }
                        break;
                    default:
                        break;
                }
            }
        }
        
        return overviewCell;
    }
    
    if ([meter.meterType isEqual:@"Gas"]) {
        gasMeterData = arrMeterData[row];
    } else {
        waterMeterData = arrMeterData[row];
    }
    
    if (tableView.tag == 1) {
        MeterDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"MeterDateCell" forIndexPath:indexPath];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strGasCheckTime = [df stringFromDate:gasMeterData.checkTime];
        if (gasMeterData.comments && ![gasMeterData.comments isEqual:@""]) {
            strGasCheckTime = [NSString stringWithFormat:@"%@*", strGasCheckTime];
        }
        
        NSString *strWaterCheckTime = [df stringFromDate:waterMeterData.checkTime];
        if (waterMeterData.comments && ![waterMeterData.comments isEqual:@""]) {
            strWaterCheckTime = [NSString stringWithFormat:@"%@*", strWaterCheckTime];
        }
        
        dateCell.lblDate.text = [meter.meterType isEqual:@"Gas"] ? strGasCheckTime : strWaterCheckTime;
        
        [dateCell setTag:row];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [dateCell addGestureRecognizer:longPressGesture];
        
        return dateCell;
    }
    
    if (tableView.tag == 2) {
        NSString *strMeterType = meter.meterType;
        if ([strMeterType isEqual:@"Gas"]) {
            
            GasMeterContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"GasMeterContentCell" forIndexPath:indexPath];
            
            contentCell.lblMeterCumVol.text = [self getStringFromFloat:gasMeterData.meterCumVol];
            contentCell.lblCurrent.text = [self getStringFromFloat:gasMeterData.currentFlow];
            contentCell.lblYesterday.text = [self getStringFromFloat:gasMeterData.yesterdayFlow];
            contentCell.lblLinePressure.text = [self getStringFromFloat:gasMeterData.linePressure];
            contentCell.lblDiffPressure.text = [self getStringFromFloat:gasMeterData.diffPressure];
            contentCell.lblMeterProblem.text = gasMeterData.meterProblem == nil ? @"-" : gasMeterData.meterProblem;
            contentCell.lblComments.text = gasMeterData.comments == nil ? @"-" : gasMeterData.comments;
            
            [contentCell setTag:row];
            
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [contentCell addGestureRecognizer:longPressGesture];
            
            return contentCell;
            
        } else {
            
            WaterMeterContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"WaterMeterContentCell" forIndexPath:indexPath];
            
            contentCell.lbl24HrVol.text = [self getStringFromFloat:waterMeterData.vol24Hr];
            contentCell.lblTotal.text = [self getStringFromFloat:waterMeterData.totalVolume];
            contentCell.lblCurrent.text = [self getStringFromFloat:waterMeterData.currentFlow];
            contentCell.lblYesterday.text = [self getStringFromFloat:waterMeterData.yesterdayFlow];
            contentCell.lblMeterProblem.text = waterMeterData.meterProblem == nil ? @"-" : waterMeterData.meterProblem;
            contentCell.lblComments.text = waterMeterData.comments == nil ? @"-" : waterMeterData.comments;
            contentCell.lblResetVol.text = waterMeterData.resetVolume == nil ? @"-" : waterMeterData.resetVolume;
            
            [contentCell setTag:row];
            
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [contentCell addGestureRecognizer:longPressGesture];
            
            return contentCell;
        }
    }
    
    return nil;
}

-(void) longPress:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan. %d", (int)recognizer.view.tag);
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        
        GasMeterData *gasMeterData = nil;
        WaterMeterData *waterMeterData = nil;
        
        NSInteger row = recognizer.view.tag;
        
        NSString *strGaugeTime = @"";
        if ([meter.meterType isEqual:@"Gas"]) {
            gasMeterData = arrMeterData[row];
            strGaugeTime = [df stringFromDate:gasMeterData.checkTime];
//            if (gasMeterData.dataID < 0) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"You cannot edit this data before refreshing." preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
//                [alert addAction:closeAction];
//                [self presentViewController:alert animated:YES completion:nil];
//                [self initData];
//                return;
//            }
        } else {
            waterMeterData = arrMeterData[row];
            strGaugeTime = [df stringFromDate:waterMeterData.checkTime];
//            if (waterMeterData.wmdID < 0) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"You cannot edit this data before refreshing." preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
//                [alert addAction:closeAction];
//                [self presentViewController:alert animated:YES completion:nil];
//                [self initData];
//                return;
//            }
        }
        
        NSString *message = [NSString stringWithFormat:@"Would you like to edit from %@?", strGaugeTime];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AddMeterDataVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMeterDataVC"];
            vc.pulseProdHome = pulseProdHome;
            vc.meter = self.meter;
            vc.arrMeterData = arrMeterData;
            vc.isNew = NO;
            vc.m_gasMeterData = gasMeterData;
            vc.m_waterMeterData = waterMeterData;
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:yesAction];
        [alertController addAction:noAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    
    if (tableView.tag == 0) {
        MeterOverviewHeaderCell *overviewHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"MeterOverviewHeaderCell"];
        
        overviewHeaderCell.lblTitle.text = self.arrOverviewSectionHeaderTitles[section];
        [overviewHeaderCell.btnSectionHeader setTag:section];
        
        [overviewHeaderCell.layer setMasksToBounds:NO];
        [overviewHeaderCell.contentView.layer setMasksToBounds:NO];
        overviewHeaderCell.viewBackground.layer.masksToBounds = NO;
        overviewHeaderCell.viewBackground.layer.shadowColor = [UIColor blackColor].CGColor;
        overviewHeaderCell.viewBackground.layer.shadowOffset = CGSizeMake(1, 2);
        overviewHeaderCell.viewBackground.layer.shadowRadius = 3.0f;
        overviewHeaderCell.viewBackground.layer.shadowOpacity = 0.3f;
        
        view = overviewHeaderCell.contentView;
    }
    
    if (tableView.tag == 1) {
        MeterDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"MeterDateCell"];
        
        [dateCell.contentView setBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:1.0f]];
        
        [dateCell.layer setMasksToBounds:NO];
        [dateCell.contentView.layer setMasksToBounds:NO];
        dateCell.contentView.layer.masksToBounds = NO;
        dateCell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        dateCell.contentView.layer.shadowOffset = CGSizeMake(1, 2);
        dateCell.contentView.layer.shadowRadius = 3.0f;
        dateCell.contentView.layer.shadowOpacity = 0.3f;
        
        view = dateCell.contentView;
    }
    
    if (tableView.tag == 2) {
        
        NSString *strMeterType = meter.meterType;
        
        if ([strMeterType isEqual:@"Gas"]) {
            GasMeterContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"GasMeterContentCell"];
            [contentCell.contentView setBackgroundColor:[UIColor colorWithRed:32/255.0 green:36/255.0 blue:63/255.0 alpha:1.0]];
            
            [contentCell.layer setMasksToBounds:NO];
            [contentCell.contentView.layer setMasksToBounds:NO];
            contentCell.contentView.layer.masksToBounds = NO;
            contentCell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
            contentCell.contentView.layer.shadowOffset = CGSizeMake(1, 2);
            contentCell.contentView.layer.shadowRadius = 3.0f;
            contentCell.contentView.layer.shadowOpacity = 0.3f;
            
            view = contentCell.contentView;
        } else {
            WaterMeterContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"WaterMeterContentCell"];
            [contentCell.contentView setBackgroundColor:[UIColor colorWithRed:32/255.0 green:36/255.0 blue:63/255.0 alpha:1.0]];
            
            [contentCell.layer setMasksToBounds:NO];
            [contentCell.contentView.layer setMasksToBounds:NO];
            contentCell.contentView.layer.masksToBounds = NO;
            contentCell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
            contentCell.contentView.layer.shadowOffset = CGSizeMake(1, 2);
            contentCell.contentView.layer.shadowRadius = 3.0f;
            contentCell.contentView.layer.shadowOpacity = 0.3f;
            view = contentCell.contentView;
        }
    }
    
    return view;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    self.dateTableView.contentOffset = point;
    self.contentTableView.contentOffset = point;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    self.dateTableView.contentOffset = point;
    self.contentTableView.contentOffset = point;
}

-(CGFloat)getFloatValue:(NSString*)value availableMin:(BOOL)availableMin
{
    float result = 0;
    if (value) {
        result = [value floatValue];
        if (!availableMin) {
            result = result < 0 ? 0 : result;
        }
    }
    
    if (result > 100) result = result * 100 / 100;
    else if (result > 10) result = result * 10 / 10.0f;
    else result = result / 1.00f;
    
    return result;
}

@end
