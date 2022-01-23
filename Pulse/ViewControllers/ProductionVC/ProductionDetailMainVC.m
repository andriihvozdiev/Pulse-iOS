
#import "ProductionDetailMainVC.h"

#import "ProductionDetailGraphVC.h"
#import "ToolbarCollectionCell.h"
#import "ProdDetailSubVC.h"
#import "TankGaugeEntryVC.h"
#import "WellheadDataVC.h"
#import "MeterDataVC.h"
#import "HapticHelper.h"

@interface ProductionDetailMainVC ()
{
    ProductionDetailGraphVC *graphVC;
    
    NSString *leaseField;
    NSMutableArray *arrLeaseFields;
    
    NSInteger selectedIndex;
    NSInteger lastPendingViewControllerIndex;
    
}
@end

@implementation ProductionDetailMainVC
@synthesize pulseProdHome;

@synthesize arrTanks;
@synthesize arrMeters;
@synthesize arrWells;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.graphContainerView setHidden:YES];
    
    m_menuType = None;
    selectedIndex = 0;
    leaseField = @"";
    arrLeaseFields = [[NSMutableArray alloc] init];
    
    self.lblPrevField.text = @"";
    self.lblCurrentField.text = @"";
    self.lblNextField.text = @"";
    
    self.lblTitle.text = pulseProdHome.leaseName;
    [self.underlineView setHidden:YES];
    self.collectionHeight.constant = 0.0f;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    [self addChildViewController:self.pageController];
    [self.containerView addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.lblTitle.text = pulseProdHome.leaseName;
    selectedIndex = 0;
    
    arrLeaseFields = [[DBManager sharedInstance] getProductionLeaseFields:pulseProdHome.lease];
    [arrLeaseFields insertObject:@"" atIndex:0];
    
    // page controller
    [[self.pageController view] setFrame:CGRectMake(0, 0, [self.containerView bounds].size.width, [self.containerView bounds].size.height)];
    
    ProdDetailSubVC *detailSubVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProdDetailSubVC"];
    detailSubVC.index = selectedIndex;
    detailSubVC.leaseField = arrLeaseFields[selectedIndex];
    detailSubVC.pulseProdHome = pulseProdHome;
    
    [self showPrevNextFieldLabel:selectedIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:detailSubVC];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self initData];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
}

-(void) showPrevNextFieldLabel:(NSInteger)index
{
    self.lblPrevField.text = @"";
    self.lblNextField.text = @"";
    self.lblCurrentField.text = @"";
    
    if (arrLeaseFields.count == 1) {
        return;
    }
    
    if (index == 0) {
        self.lblNextField.text = [[DBManager sharedInstance] getProductionLeaseName:arrLeaseFields[index + 1]];
        self.lblCurrentField.text = @"All";
    } else if (index == arrLeaseFields.count - 1) {
        self.lblPrevField.text = [[DBManager sharedInstance] getProductionLeaseName:arrLeaseFields[index - 1]];
        self.lblCurrentField.text = [[DBManager sharedInstance] getProductionLeaseName:arrLeaseFields[index]];
    } else {
        self.lblPrevField.text = [[DBManager sharedInstance] getProductionLeaseName:arrLeaseFields[index - 1]];
        self.lblNextField.text = [[DBManager sharedInstance] getProductionLeaseName:arrLeaseFields[index + 1]];
        self.lblCurrentField.text = [[DBManager sharedInstance] getProductionLeaseName:arrLeaseFields[index]];
    }
    
    if (index == 1) {
        self.lblPrevField.text = @"All";
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark -
-(void)initData
{
    //m_menuType = None;
    arrTanks = [[DBManager sharedInstance] getTanksByLease:pulseProdHome.lease];
    arrMeters = [[DBManager sharedInstance] getMetersByLease:pulseProdHome.lease];
    arrWells = [[DBManager sharedInstance] getWellListByLease:pulseProdHome.lease];
    
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
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


#pragma mark -
-(void) orientationChanged: (NSNotification*)note
{
    UIDevice *device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
        {
            [self.tabBarController.tabBar setHidden:NO];
            
            if (graphVC) {
                [graphVC.view removeFromSuperview];
                [graphVC removeFromParentViewController];
                graphVC = nil;
            }

            [self.graphContainerView setHidden:YES];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            [self.graphContainerView setHidden:NO];
            if (self.navigationController.topViewController == self) {
                [self.tabBarController.tabBar setHidden:YES];
            }

            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            
            graphVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductionDetailGraphVC"];
            CGRect rect  = CGRectMake(0, 0, screenSize.width, screenSize.height);
            graphVC.view.frame = rect;
            
            if (selectedIndex == 0) {
                self.arrDetailData = [[DBManager sharedInstance] getProductionByLease:pulseProdHome.lease];
            } else {
                self.arrDetailData = [[DBManager sharedInstance] getProductionFields:pulseProdHome.lease leaseField:arrLeaseFields[selectedIndex]];
            }
            graphVC.arrDetailData = self.arrDetailData;
            
            
            [self addChildViewController:graphVC];
            [self.graphContainerView addSubview:graphVC.view];
            
        }
            break;
        default:
            break;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTanks:(id)sender {
    
    // If touching Tanks button again, Tanks toolbar will be hidden.
    if (m_menuType == TanksType) {
        m_menuType = None;
        [self.collectionView reloadData];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.collectionHeight.constant = 0.0f;
            [self.underlineView shakeWithWidth:2.5f];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.underlineView setHidden:YES];
            [self.btnTanks setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }];
        
        return;
    }
    
    m_menuType = TanksType;
    [self.underlineView setHidden:NO];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float screenWidth = screenSize.width;
    [UIView animateWithDuration:0.2f animations:^{
        self.collectionHeight.constant = 80.0f;
        self.underlineCenterContraint.constant = -screenWidth / 3.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
        [self.collectionView reloadData];
    }];
    
    [self.btnTanks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnMeters setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnWells setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
}

- (IBAction)onMeters:(id)sender {
    
    // If touching Meters button again, Meters Toolbar will be hidden.
    if (m_menuType == MetersType) {
        
        m_menuType = None;
        [self.collectionView reloadData];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.collectionHeight.constant = 0.0f;
            [self.underlineView shakeWithWidth:2.5f];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.underlineView setHidden:YES];
            [self.btnMeters setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }];
        
        return;
    }
    
    m_menuType = MetersType;
    [self.underlineView setHidden:NO];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.collectionHeight.constant = 80.0f;
        self.underlineCenterContraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
        [self.collectionView reloadData];
    }];
    
    [self.btnTanks setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnMeters setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnWells setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
}

- (IBAction)onWells:(id)sender {
    
    if (m_menuType == WellsType) {
        m_menuType = None;
        [self.collectionView reloadData];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.collectionHeight.constant = 0.0f;
            [self.underlineView shakeWithWidth:2.5f];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.underlineView setHidden:YES];
            [self.btnWells setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }];
        
        return;
    }

    m_menuType = WellsType;
    [self.underlineView setHidden:NO];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float screenWidth = screenSize.width;
    [UIView animateWithDuration:0.2f animations:^{
        self.collectionHeight.constant = 80.0f;
        self.underlineCenterContraint.constant = screenWidth / 3.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
        [self.collectionView reloadData];
    }];
    
    [self.btnTanks setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnMeters setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnWells setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

#pragma mark - UIPageView Delegate

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    if (pendingViewControllers.count > 0) {
        ProdDetailSubVC *vc = (ProdDetailSubVC*)pendingViewControllers[0];
        lastPendingViewControllerIndex = vc.index;
    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        selectedIndex = lastPendingViewControllerIndex;
        [self showPrevNextFieldLabel:selectedIndex];
    }
}

#pragma mark - UIPageView Datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ProdDetailSubVC *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    if (index > 0) {
        index -= 1;
    }
    
    ProdDetailSubVC *detailSubVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProdDetailSubVC"];
    detailSubVC.index = index;
    detailSubVC.leaseField = arrLeaseFields[index];
    detailSubVC.pulseProdHome = pulseProdHome;
    
    return detailSubVC;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ProdDetailSubVC *)viewController index];
    
    if (index < arrLeaseFields.count - 1) {
        index += 1;
    } else {
        return nil;
    }
    
    ProdDetailSubVC *detailSubVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProdDetailSubVC"];
    detailSubVC.index = index;
    detailSubVC.leaseField = arrLeaseFields[index];
    detailSubVC.pulseProdHome = pulseProdHome;
    
    return detailSubVC;
    
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    return arrLeaseFields.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    return 0;
}

#pragma mark - UICollectionView Datasource
-(NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (m_menuType) {
        case TanksType:
            count = arrTanks.count;
            break;
        case MetersType:
            count = arrMeters.count;
            break;
        case WellsType:
            count = arrWells.count;
            break;
        default:
            break;
    }
    return count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolbarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToolbarCollectionCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    NSString *strID = @"";
    NSString *strDate = @"-";
    NSString *strDescription = @"-";
    NSString *strType = @"";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    switch (m_menuType) {
        case TanksType:
        {
            Tanks *tank = arrTanks[row];
            strType = [tank.tankType lowercaseString];
            strID = tank.rrc;
            
            NSArray *arrTankGaugeEntry = [[DBManager sharedInstance] getTankGaugeEntry:tank.lease tankID:tank.tankID];
            
            if (arrTankGaugeEntry.count > 0) {
                TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[0];
                strDate = [df stringFromDate:tankGaugeEntry.gaugeTime];
                
                strDescription = [self getFeetString:tankGaugeEntry withTankID:tank.tankID];
            }
            
            if ([strType isEqualToString:@"oil"]) {
                [cell.containerView setBackgroundColor:[UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1.0f]];
            } else if ([strType isEqualToString:@"water"]){
                [cell.containerView setBackgroundColor:[UIColor colorWithRed:122/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f]];
            } else if ([strType isEqualToString:@"chemical"]) {
                [cell.containerView setBackgroundColor:[UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1.0f]];
            }
        }
            break;
        case MetersType:
            {
                Meters *meters = arrMeters[row];
                strType = [meters.meterType lowercaseString];
                strID = meters.appName;
                NSArray *arrMeterData = [[DBManager sharedInstance] getMeterDataByLease:meters.meterLease meterID:[NSString stringWithFormat:@"%d", meters.meterID] meterType:strType];
                
                if ([strType isEqualToString:@"gas"]) {
                    
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:141/255.0f blue:138/255.0f alpha:1.0f]];
                    if (arrMeterData.count > 0) {
                        GasMeterData *gasMeterData = arrMeterData[0];
                        strDate = [df stringFromDate:gasMeterData.checkTime];
                        strDescription = [self getFloatString:gasMeterData.yesterdayFlow];
                    }
                    
                } else if ([strType isEqual:@"oil"]) {
                    
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1.0f]];
                    
                    if (arrMeterData.count > 0) {
                        WaterMeterData *waterMeterData = arrMeterData[0];
                        strDate = [df stringFromDate:waterMeterData.checkTime];
                        strDescription = [self getFloatString:waterMeterData.vol24Hr];
                    }
                    
                } else if ([strType isEqualToString:@"water"]) {
                    
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:122/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f]];
                    if (arrMeterData.count > 0) {
                        WaterMeterData *waterMeterData = arrMeterData[0];
                        strDate = [df stringFromDate:waterMeterData.checkTime];
                        strDescription = [self getFloatString:waterMeterData.vol24Hr];
                    }
                    
                } else if ([strType isEqualToString:@"total flui"]) {
                    
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1.0f]];
                    if (arrMeterData.count > 0) {
                        WaterMeterData *waterMeterData = arrMeterData[0];
                        strDate = [df stringFromDate:waterMeterData.checkTime];
                        strDescription = [self getFloatString:waterMeterData.vol24Hr];
                    }
                    
                }
            }
            break;
        case WellsType:
            {
                WellList *wellList = arrWells[row];
                strType = [wellList.prodCat lowercaseString];
                strID = wellList.wellNumber;
                
                NSArray *arrWellheadData = [[DBManager sharedInstance] getWellheadDataByLease:wellList.lease wellNum:wellList.wellNumber];
                if (arrWellheadData.count > 0) {
                    WellheadData *wellheadData = arrWellheadData[0];
                    strDate = [df stringFromDate:wellheadData.checkTime];
                    strDescription = wellheadData.statusDepart ? @"ON" : @"OFF";
                }
                
                if ([strType isEqual:@"oil"]) {
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1.0f]];
                    
                } else if ([strType isEqualToString:@"water"]){
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:122/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f]];
                } else if ([strType isEqualToString:@"gas"]){
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:141/255.0f blue:138/255.0f alpha:1.0f]];
                } else { //if ([strType isEqualToString:@"chemical"]) {
                    [cell.containerView setBackgroundColor:[UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1.0f]];
                }
            }
            break;
        default:
            break;
    }
    
    cell.lblID.text = strID;
    cell.lblDate.text = strDate;
    cell.lblDetail.text = strDescription;
    
    cell.containerView.layer.cornerRadius = 5.0f;
    
    return cell;
}

-(NSString*) getFloatString:(NSString*)strValue
{
    NSString *result = @"-";
    if (strValue) {
        float value = [strValue floatValue];
        if (value > 100) {
            result = [NSString stringWithFormat:@"%.1f", value];
        } else if (value > 10) {
            result = [NSString stringWithFormat:@"%.2f", value];
        } else {
            result = [NSString stringWithFormat:@"%.3f", value];
        }
    }
    return result;
}

-(NSString*) getFeetString:(TankGaugeEntry*)tankGaugeEntry withTankID:(int)tankID
{
    int oilFeet = 0;
    
    if (tankGaugeEntry.tankID1 == tankID)
        oilFeet = tankGaugeEntry.oilFeet1;
    if (tankGaugeEntry.tankID2 == tankID)
        oilFeet = tankGaugeEntry.oilFeet2;
    if (tankGaugeEntry.tankID3 == tankID)
        oilFeet = tankGaugeEntry.oilFeet3;
    if (tankGaugeEntry.tankID4 == tankID)
        oilFeet = tankGaugeEntry.oilFeet4;
    if (tankGaugeEntry.tankID5 == tankID)
        oilFeet = tankGaugeEntry.oilFeet5;
    if (tankGaugeEntry.tankID6 == tankID)
        oilFeet = tankGaugeEntry.oilFeet6;
    if (tankGaugeEntry.tankID7 == tankID)
        oilFeet = tankGaugeEntry.oilFeet7;
    if (tankGaugeEntry.tankID8 == tankID)
        oilFeet = tankGaugeEntry.oilFeet8;
    if (tankGaugeEntry.tankID9 == tankID)
        oilFeet = tankGaugeEntry.oilFeet9;
    if (tankGaugeEntry.tankID10 == tankID)
        oilFeet = tankGaugeEntry.oilFeet10;
    
    
    int feet = oilFeet / 4 / 12;
    float inches = oilFeet / 4.0f - feet * 12;
    
    NSString *result = [NSString stringWithFormat:@"%d' %.2f\"", feet, inches];
    
    return result;
}


#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    switch (m_menuType) {
        case TanksType:
            {
                NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
                
                for (int i = 0; i < (row + 1); i++) {
                    TankGaugeEntryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TankGaugeEntryVC"];
                    vc.pulseProdHome = pulseProdHome;
                    vc.arrTanks = arrTanks;
                    vc.selectedIndex = i;
                    
                    vc.view.tag = 10;
                    [controllers addObject:vc];
                }
                
                [self.navigationController setViewControllers:controllers animated:YES];
            }
            break;
        case MetersType:
            {
                NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
                
                for (int i = 0; i < (row + 1); i++) {
                    MeterDataVC *meterDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MeterDataVC"];
                    meterDataVC.pulseProdHome = pulseProdHome;
                    meterDataVC.arrMeters = arrMeters;
                    meterDataVC.selectedIndex = i;
                    meterDataVC.view.tag = 10;
                    
                    [controllers addObject:meterDataVC];
                }
                
                [self.navigationController setViewControllers:controllers animated:YES];
            }
            break;
        case WellsType:
            {
                NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
                
                for (int i = 0; i < (row + 1); i++) {
                    WellheadDataVC *wellheadDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WellheadDataVC"];
                    wellheadDataVC.pulseProdHome = pulseProdHome;
                    wellheadDataVC.arrWells = arrWells;
                    wellheadDataVC.selectedIndex = i;
                    wellheadDataVC.view.tag = 10;
                    
                    [controllers addObject:wellheadDataVC];
                }
                
                [self.navigationController setViewControllers:controllers animated:YES];
            }
            break;
        default:
            break;
    }
}

@end
