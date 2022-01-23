#import "WellheadDataVC.h"
#import "HapticHelper.h"
#import "WellheadDataGraphVC.h"
#import "WellheadDateCell.h"
#import "WellheadContentCell.h"

#import "WellOverviewHeaderCell.h"
#import "WellOverviewContentCell.h"

#import "WBDMainVC.h"
#import "AddWellheadDataVC.h"
#import "ProductionDetailMainVC.h"

@interface WellheadDataVC ()
{
    WellheadDataGraphVC *graphVC;
    NSMutableArray *arrSectionStatus;
    NSMutableDictionary *wellheadDataForOverview;
    NSString *strProdType;
}
@end

@implementation WellheadDataVC
@synthesize pulseProdHome;
@synthesize arrWellheadData;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wellheadDataForOverview = [[NSMutableDictionary alloc] init];
    self.welllist = self.arrWells[self.selectedIndex];
    
    NSString *leaseName = [[DBManager sharedInstance] getLeaseNameFromLease:self.welllist.grandparentPropNum];
    NSString *strWellNumber = self.welllist.wellNumber;
    self.lblTitle.text = [NSString stringWithFormat:@"%@ #%@", leaseName, strWellNumber];
        
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
    
    [self.viewData setHidden:YES];
    [self.viewOverview setHidden:NO];
    
    self.btnWBD.layer.cornerRadius = 3.0f;
    self.btnAddWellData.layer.cornerRadius = 3.0f;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    
    self.arrOverviewSectionHeaderTitles = @[@"Flowing", @"Rod Pump", @"ESP", @"Pressure", @"Fluid"];
    self.arrOverviewSectionContentTitles = @[@[@"Choke"], @[@"SPM", @"StrokeSize", @"Pound", @"TimeOn", @"TimeOff"], @[@"ESPHz", @"ESPAmp"], @[@"Casing Pressure", @"Tubing Pressure", @"Bradenhead Pressure"], @[@"Oil Cut", @"Emulsion Cut", @"Water Cut"]];
    arrSectionStatus = [@[@"open", @"open", @"open", @"open", @"open"] mutableCopy];
    
    
    self.viewDateHeader.layer.masksToBounds = NO;
    self.viewDateHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewDateHeader.layer.shadowOffset = CGSizeMake(1, 2);
    self.viewDateHeader.layer.shadowRadius = 3.0f;
    self.viewDateHeader.layer.shadowOpacity = 0.3f;
    
    self.viewContentHeader.layer.masksToBounds = NO;
    self.viewContentHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewContentHeader.layer.shadowOffset = CGSizeMake(1, 2);
    self.viewContentHeader.layer.shadowRadius = 3.0f;
    self.viewContentHeader.layer.shadowOpacity = 0.3f;
    
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
        if (self.arrWells.count > self.selectedIndex + 1) {
            WellheadDataVC *wellheadDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WellheadDataVC"];
            wellheadDataVC.pulseProdHome = pulseProdHome;
            wellheadDataVC.arrWells = self.arrWells;
            wellheadDataVC.selectedIndex = self.selectedIndex + 1;
            wellheadDataVC.view.tag = 10;
            
            [self.navigationController pushViewController:wellheadDataVC animated:YES];
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
-(void) initData
{
    arrWellheadData = [[NSArray alloc] init];
    
    NSString *strWellNumber = self.welllist.wellNumber;
    
    arrWellheadData = [[DBManager sharedInstance] getWellheadDataByLease:self.welllist.lease wellNum:strWellNumber];
    wellheadDataForOverview = [[DBManager sharedInstance] getWellheadDataByLeaseForOverview:self.welllist.lease wellNum:strWellNumber];
    [self refreshData];
    
    [self.overviewTableView reloadData];
    [self.dateTableView reloadData];
    [self.contentTableView reloadData];
}

-(void)refreshData
{
    if (arrWellheadData.count == 0) {
        
        self.lblWellheadTitle.text = [NSString stringWithFormat:@"Well #%@", self.welllist.wellNumber];
        
        self.lblDate.text = @"";
        self.lblUser.text = @"";
        self.lblStatus.text = @"";
        
        return;
    }
    
    if (arrWellheadData.count > 0) {
        WellheadData *wellheadData = arrWellheadData[0];
        
        strProdType = wellheadData.prodType;
        
        if ([strProdType isEqual:@"Flowing"]) {
            [arrSectionStatus replaceObjectAtIndex:1 withObject:@"close"];
            [arrSectionStatus replaceObjectAtIndex:2 withObject:@"close"];
        } else if ([strProdType isEqual:@"Pumping"]) {
            [arrSectionStatus replaceObjectAtIndex:0 withObject:@"close"];
            [arrSectionStatus replaceObjectAtIndex:2 withObject:@"close"];
        } else if ([strProdType isEqual:@"ESP"]) {
            [arrSectionStatus replaceObjectAtIndex:0 withObject:@"close"];
            [arrSectionStatus replaceObjectAtIndex:1 withObject:@"close"];
        } else if ([strProdType isEqual:@"Injection"]) {
            [arrSectionStatus replaceObjectAtIndex:0 withObject:@"close"];
            [arrSectionStatus replaceObjectAtIndex:1 withObject:@"close"];
            [arrSectionStatus replaceObjectAtIndex:2 withObject:@"close"];
        }
        
        self.lblWellheadTitle.text = [NSString stringWithFormat:@"Well #%@ - %@", wellheadData.wellNumber, strProdType];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
        
        self.lblDate.text = strDateTime;
        self.lblUser.text = [[DBManager sharedInstance] getUserName:wellheadData.userid];
        NSString *strArrivalStatus = @"Arrive: OFF";
        if (wellheadData.statusArrival) {
            strArrivalStatus = @"Arrive: ON";
        }
        NSString *strDepartStatus = @"Depart: OFF";
        if (wellheadData.statusDepart)
            strDepartStatus = @"Depart: ON";
        NSString *strStatus = [NSString stringWithFormat:@"%@ | %@", strArrivalStatus, strDepartStatus];
        self.lblStatus.text = strStatus;
        
        if (wellheadData.comments && ![wellheadData.comments isEqual:@""]) {
            self.lblComment.text = wellheadData.comments;
            [self.lblComment scrollRangeToVisible:NSMakeRange(0, 0)];
        }
        
    }
    
//    NSInteger dataCount = arrWellheadData.count;
//    for (int i = 0; i < dataCount; i++) {
//        WellheadData *tmp = arrWellheadData[i];
//        if (![tmp.choke isKindOfClass:[NSNull class]] || tmp.choke != nil) {
//
//        }
//        wellheadDataForOverview.choke = tmp.choke
//    }
    
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
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            if (self.navigationController.topViewController == self) {
                [self.tabBarController.tabBar setHidden:YES];
            }
            
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            
            graphVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WellheadDataGraphVC"];
            CGRect rect  = CGRectMake(0, 0, screenSize.width, screenSize.height);
            graphVC.view.frame = rect;
            graphVC.arrWellheadData = self.arrWellheadData;
            
            [self addChildViewController:graphVC];
            [self.graphContainerView addSubview:graphVC.view];
            
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - portrait button events
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

- (IBAction)onOverview:(id)sender {
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

- (IBAction)onData:(id)sender {
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
    
    [self.dateTableView reloadData];
    [self.contentTableView reloadData];
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

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual:@"AddWellDataSegue"]) {
        
        self.view.tag = 0;
        
        AddWellheadDataVC *vc = [segue destinationViewController];
        vc.welllist = self.welllist;
        vc.isNew = YES;
        if (arrWellheadData.count > 0) {
            WellheadData *wellheadData = arrWellheadData[0];
            vc.wellheadData = wellheadData;
            vc.dicWellheadData = wellheadDataForOverview;
        }
    } else if ([segue.identifier isEqual:@"WBDSegue"]) {
        WBDMainVC *vc = [segue destinationViewController];
        vc.welllist = self.welllist;
    }
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
        numberOfRows = arrWellheadData.count;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (tableView.tag == 0) {
        WellOverviewContentCell *overviewCell = [tableView dequeueReusableCellWithIdentifier:@"WellOverviewContentCell" forIndexPath:indexPath];
        
        overviewCell.lblTitle.text = self.arrOverviewSectionContentTitles[section][row];
        overviewCell.lblValue.text = @"";
        overviewCell.lblTime.text = @"";
        
        if (arrWellheadData.count > 0) {
            WellheadData *wellheadData = arrWellheadData[0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM/dd/yy";
            overviewCell.lblValue.text = @"-";
            overviewCell.lblTime.text = @"-";
            switch (section) {
                case 0: // Flowing / Choke
//                    overviewCell.lblValue.text = wellheadData.choke;
                    wellheadData = [wellheadDataForOverview objectForKey:@"choke"];
                    if (wellheadData != nil) {
                        overviewCell.lblValue.text = wellheadData.choke;
                        overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                    } else {
                        overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                    }
                    break;
                case 1: // Rod Pump
                    switch (row) {
                        case 0: // SPM
//                            overviewCell.lblValue.text = [self getString:wellheadData.spm];
                            wellheadData = [wellheadDataForOverview objectForKey:@"spm"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.spm;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 1: // StrokeSize
//                            overviewCell.lblValue.text = [self getString:wellheadData.strokeSize];
                            wellheadData = [wellheadDataForOverview objectForKey:@"strokeSize"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.strokeSize;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 2: // Pound
//                            overviewCell.lblValue.text = [self getString:wellheadData.pound];
                            wellheadData = [wellheadDataForOverview objectForKey:@"pound"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.pound;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 3: // TimeOn
//                            overviewCell.lblValue.text = [self getString:wellheadData.timeOn];
                            wellheadData = [wellheadDataForOverview objectForKey:@"timeOn"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.timeOn;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 4: // TimeOff
//                            overviewCell.lblValue.text = [self getString:wellheadData.timeOff];
                            wellheadData = [wellheadDataForOverview objectForKey:@"timeOff"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.timeOff;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        default:
                            break;
                    }
                    break;
                case 2: // ESP
                    switch (row) {
                        case 0: // ESP Hz
//                            overviewCell.lblValue.text = [self getString:wellheadData.espHz];
                            wellheadData = [wellheadDataForOverview objectForKey:@"espHz"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.espHz;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 1: // ESP Amp
//                            overviewCell.lblValue.text = [self getString:wellheadData.espAmp];
                            wellheadData = [wellheadDataForOverview objectForKey:@"espAmp"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.espAmp;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        default:
                            break;
                    }
                    break;
                case 3: // Pressure
                    switch (row) {
                        case 0: // Casing Pressure
//                            overviewCell.lblValue.text = [self getString:wellheadData.casingPressure];
                            wellheadData = [wellheadDataForOverview objectForKey:@"casingPressure"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.casingPressure;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 1: // Tubing Pressure
//                            overviewCell.lblValue.text = [self getString:wellheadData.tubingPressure];
                            wellheadData = [wellheadDataForOverview objectForKey:@"tubingPressure"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.tubingPressure;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 2: // Bradenhead Pressure
//                            overviewCell.lblValue.text = [self getString:wellheadData.bradenheadPressure];
                            wellheadData = [wellheadDataForOverview objectForKey:@"bradenheadPressure"];
                            if (wellheadData != nil) {
                                overviewCell.lblValue.text = wellheadData.bradenheadPressure;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        default:
                            break;
                    }
                    break;
                case 4: // Fluid
                    switch (row) {
                        case 0: // Oil
//                            overviewCell.lblValue.text = wellheadData.oilCut == nil ? @"-" : [NSString stringWithFormat:@"%@ %%", wellheadData.oilCut];
                            wellheadData = [wellheadDataForOverview objectForKey:@"oilCut"];
                            if (wellheadData != nil) {
                                if (wellheadData.oilCut != nil && [wellheadData.oilCut floatValue] != 0)
                                    overviewCell.lblValue.text = wellheadData.oilCut;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 1: // Emulsion
//                            overviewCell.lblValue.text = wellheadData.emulsionCut == nil ? @"-" : [NSString stringWithFormat:@"%@ %%", wellheadData.emulsionCut];
                            wellheadData = [wellheadDataForOverview objectForKey:@"emulsionCut"];
                            if (wellheadData != nil) {
                                if (wellheadData.emulsionCut != nil && [wellheadData.emulsionCut floatValue] != 0)
                                    overviewCell.lblValue.text = wellheadData.emulsionCut;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        case 2: // Water
//                            overviewCell.lblValue.text = wellheadData.waterCut == nil ? @"-" : [NSString stringWithFormat:@"%@ %%", wellheadData.waterCut];
                            wellheadData = [wellheadDataForOverview objectForKey:@"waterCut"];
                            if (wellheadData != nil) {
                                if (wellheadData.waterCut != nil && [wellheadData.waterCut floatValue] != 0)
                                    overviewCell.lblValue.text = wellheadData.waterCut;
                                overviewCell.lblTime.text = [dateFormatter stringFromDate:wellheadData.checkTime];
                                
                            } else {
                                overviewCell.lblTime.backgroundColor = [UIColor clearColor];
                            }
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
        }
        
        return overviewCell;
    }
    
    WellheadData *wellheadData = arrWellheadData[row];
    
    if (tableView.tag == 1) {
        WellheadDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"WellheadDateCell" forIndexPath:indexPath];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
        if (wellheadData.comments && ![wellheadData.comments isEqualToString:@""]) {
            strDateTime = [NSString stringWithFormat:@"%@*", strDateTime];
        }
        dateCell.lblDate.text = strDateTime;
        
        [dateCell setTag:row];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [dateCell addGestureRecognizer:longPressGesture];
        
        return dateCell;
    }
    
    if (tableView.tag == 2) {
        WellheadContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"WellheadContentCell" forIndexPath:indexPath];
    
        contentCell.lblStatusArrival.text = wellheadData.statusArrival == YES ? @"On" : @"Off";
        contentCell.lblStatusDepart.text = wellheadData.statusDepart == YES ? @"On" : @"Off";
        contentCell.lblWellProblem.text = [self getString:wellheadData.wellProblem];
        contentCell.lblProdType.text = [self getString:wellheadData.prodType];
        contentCell.lblTubing.text = [self getString:wellheadData.tubingPressure];
        contentCell.lblCasing.text = [self getString:wellheadData.casingPressure];
        contentCell.lblBradenhead.text = [self getString:wellheadData.bradenheadPressure];
        contentCell.lblChoke.text = [self getString:wellheadData.choke];
        contentCell.lblSPM.text = [self getString:wellheadData.spm];
        contentCell.lblStrokeSize.text = [self getString:wellheadData.strokeSize];
        contentCell.lblPound.text = [self getString:wellheadData.pound];
        contentCell.lblTimeOn.text = [self getString:wellheadData.timeOn];
        contentCell.lblTimeOff.text = [self getString:wellheadData.timeOff];
        contentCell.lblESPHz.text = [self getString:wellheadData.espHz];
        contentCell.lblESPAmp.text = [self getString:wellheadData.espAmp];
        contentCell.lblOilCut.text = [self getString:wellheadData.oilCut];
        contentCell.lblWaterCut.text = [self getString:wellheadData.waterCut];
        contentCell.lblEmulsionCut.text = [self getString:wellheadData.emulsionCut];        
        contentCell.lblComments.text = [self getString:wellheadData.comments];
        
        [contentCell setTag:row];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [contentCell addGestureRecognizer:longPressGesture];
        
        return contentCell;
    }
    
    return cell;
}

-(NSString*) getString:(NSString*)data
{
    NSString *result = @"";
    if (data == nil)
        result = @"-";
    else
        result = data;
    return result;
}

-(void) longPress:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan. %d", (int)recognizer.view.tag);
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        
        NSInteger row = recognizer.view.tag;
        WellheadData *wellheadData = arrWellheadData[row];
        
//        if (wellheadData.dataID < 0) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"You cannot edit this data before refreshing." preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:closeAction];
//            [self presentViewController:alert animated:YES completion:nil];
//            [self initData];
//            return;
//        }
        
        NSString *strGaugeTime = [df stringFromDate:wellheadData.checkTime];
        NSString *message = [NSString stringWithFormat:@"Would you like to edit from %@?", strGaugeTime];
        
        // set the view controller by initializing it form the storyboard
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AddWellheadDataVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddWellheadDataVC"];
            vc.welllist = self.welllist;
            vc.wellheadData = wellheadData;
            vc.isNew = NO;
            
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
    float heightForHeader = 30;
    
    if (tableView == self.overviewTableView) {
        if ([strProdType isEqual:@"Flowing"]) {
            if (section == 1 || section == 2) {
                heightForHeader = 0;
            }
        } else if ([strProdType isEqual:@"Pumping"]) {
            if (section == 0 || section == 2) {
                heightForHeader = 0;
            }
        } else if ([strProdType isEqual:@"ESP"]) {
            if (section == 0 || section == 1) {
                heightForHeader = 0;
            }
        } else if ([strProdType isEqual:@"Injection"]) {
            if (section == 0 || section == 1 || section == 2) {
                heightForHeader = 0;
            }
        }
    } else if (tableView == self.dateTableView || tableView == self.contentTableView){
        heightForHeader = 0.0f;
    }
    
    
    return heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (tableView.tag == 0) {
        WellOverviewHeaderCell *overviewHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"WellOverviewHeaderCell"];
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
    
    [self.dateTableView reloadData];
    [self.contentTableView reloadData];
}


@end
