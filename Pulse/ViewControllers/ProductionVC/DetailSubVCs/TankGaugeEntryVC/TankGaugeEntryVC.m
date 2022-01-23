#import "TankGaugeEntryVC.h"
#import "TankGraphVC.h"
#import "RunTicketTableCell.h"
#import "TankGaugeTimeCell.h"
#import "TankGaugeContentCell.h"
#import "HapticHelper.h"

#import "TankGaugeEntryEditVC.h"
#import "AddRunTicketsVC.h"
#import "RunTicketsDetailVC.h"
#import "MeterDataVC.h"
#import "WellheadDataVC.h"
#import "ProductionDetailMainVC.h"
#import "BFRImageViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define TankFillageHeight 46.0f
#define TankFeetHeight 80.0f

@interface TankGaugeEntryVC ()
{
    TankGraphVC *graphVC;
}
@end

@implementation TankGaugeEntryVC
@synthesize pulseProdHome;

@synthesize tank;
@synthesize arrTankGaugeEntry;
@synthesize arrRunTickets;
@synthesize tankStrappings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.graphContainerView setHidden:YES];
    
    tank = self.arrTanks[self.selectedIndex];
    
    [self setTankColor];
    
    self.lblTitle.text = pulseProdHome.leaseName;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
    [self.viewData setHidden:YES];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    self.btnAddTankGauge.layer.cornerRadius = 3.0f;
    self.btnEditRunTicket.layer.cornerRadius = 3.0f;
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    
    // data table section header shadow
    [self.viewDateHeader.layer setMasksToBounds:NO];
    self.viewDateHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewDateHeader.layer.shadowOffset = CGSizeMake(1, 2);
    self.viewDateHeader.layer.shadowRadius = 3.0f;
    self.viewDateHeader.layer.shadowOpacity = 0.3f;
    
    [self.viewContentHeader.layer setMasksToBounds:NO];
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.tag = 10;
    
    [self initData];
    
    [self.tankFillageBottomImage setHidden:NO];
    
    int fillage = 0;
    
    if (arrTankGaugeEntry.count > 0)
    {
        TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[0];
        
        int oilFeet = [self getGauge:tankGaugeEntry withTankID:tank.tankID];
        int feet = oilFeet / 4 / 12;
        int inches = floorf(oilFeet / 4.0f) - feet * 12;
        int quarter_inches = (oilFeet / 4.0f - feet * 12 - inches) / 0.25f;
        
        self.lblTankFeet.text = [NSString stringWithFormat:@"%d' %d %d/4\"", feet, inches, quarter_inches];
        
        int tankHeight = [self getTankMaxHeight];
        
        if (tankHeight == 0) {
            self.lblTankFillage.text = @"0%";
        } else {
            fillage = oilFeet * 100 / tankHeight;
            self.lblTankFillage.text = [NSString stringWithFormat:@"%d%%", fillage];
        }
    } else {
        self.lblTankFillage.text = @"0%";
        self.lblTankFeet.text = @"0";
        [self.tankFillageBottomImage setHidden:YES];
    }
    
    
    float height = TankFillageHeight * fillage / 100.0f - 6;
    if (height < 0) {
        height = 0;
        [self.tankFillageTopImage setHidden:YES];
        [self.tankFillageBodyImage setHidden:YES];
    }
    
    self.tankFillageHeightConstraint.constant = height;
    self.tankFeetHeightConstraint.constant = TankFeetHeight * fillage / 100.0f;
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
    
}

-(void) setTankColor
{
    self.tankFillageTopImage.image = [self.tankFillageTopImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tankFillageBodyImage.image = [self.tankFillageBodyImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tankFillageBottomImage.image = [self.tankFillageBottomImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tankFeetImage.image = [self.tankFeetImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    NSString *strType = [tank.tankType lowercaseString];
    if ([strType isEqualToString:@"oil"]) {
        [self.tankFillageTopImage setTintColor:[UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1.0f]];
        [self.tankFillageBodyImage setTintColor:[UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1.0f]];
        [self.tankFillageBottomImage setTintColor:[UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1.0f]];
        [self.tankFeetImage setTintColor:[UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1.0f]];
    } else if ([strType isEqualToString:@"water"]){
        [self.tankFillageTopImage setTintColor:[UIColor colorWithRed:122/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f]];
        [self.tankFillageBodyImage setTintColor:[UIColor colorWithRed:122/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f]];
        [self.tankFillageBottomImage setTintColor:[UIColor colorWithRed:122/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f]];
        [self.tankFeetImage setTintColor:[UIColor colorWithRed:122/255.0f green:218/255.0f blue:255/255.0f alpha:1.0f]];
    } else if ([strType isEqualToString:@"chemical"]) {
        [self.tankFillageTopImage setTintColor:[UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1.0f]];
        [self.tankFillageBodyImage setTintColor:[UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1.0f]];
        [self.tankFillageBottomImage setTintColor:[UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1.0f]];
        [self.tankFeetImage setTintColor:[UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1.0f]];
    }
}

#pragma mark -

-(void) initData
{
    self.lblTankInfo.text = [NSString stringWithFormat:@"%@: %@", tank.tankType, tank.rrc];
    
    arrTankGaugeEntry = [[DBManager sharedInstance] getTankGaugeEntry:tank.lease tankID:tank.tankID];
    arrRunTickets = [[DBManager sharedInstance] getRunTickets:tank.lease tankID:tank.tankID];
    tankStrappings = [[DBManager sharedInstance] getTankStrappingsWithRRC:tank.rrc];
    
    self.lblDate.text = @"";
    self.lblTime.text = @"";
    self.lblUser.text = @"";
    
    if (arrTankGaugeEntry.count > 0) {
        TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSString *strGaugeTime = [df stringFromDate:tankGaugeEntry.gaugeTime];
        
        self.lblDate.text = [strGaugeTime substringToIndex:10];
        self.lblTime.text = [strGaugeTime substringFromIndex:11];
        
        self.lblUser.text = [[DBManager sharedInstance] getUserName:tankGaugeEntry.userid];
        if (tankGaugeEntry.comments && ![tankGaugeEntry.comments isEqual:@""]) {
            
            self.lblComment.text = tankGaugeEntry.comments;
            self.lblComment.textColor = [UIColor whiteColor];
            [self.view layoutIfNeeded];
        }
    }
    
    [self.runTicketsTable reloadData];
    [self.dateTableView reloadData];
    [self.contentTableView reloadData];
}

-(int) getTankMaxHeight
{
    if (tankStrappings == nil) {
        return 0;
    }
    
    int maxInc = 0;
    if (tankStrappings.inc1) {
        maxInc = [tankStrappings.inc1 intValue];
    }
    if (tankStrappings.inc2 && [tankStrappings.inc2 intValue] > maxInc) {
        maxInc = [tankStrappings.inc2 intValue];
    }
    if (tankStrappings.inc3 && [tankStrappings.inc3 intValue] > maxInc) {
        maxInc = [tankStrappings.inc3 intValue];
    }
    if (tankStrappings.inc4 && [tankStrappings.inc4 intValue] > maxInc) {
        maxInc = [tankStrappings.inc4 intValue];
    }
    if (tankStrappings.inc5 && [tankStrappings.inc5 intValue] > maxInc) {
        maxInc = [tankStrappings.inc5 intValue];
    }
    if (tankStrappings.inc6 && [tankStrappings.inc6 intValue] > maxInc) {
        maxInc = [tankStrappings.inc6 intValue];
    }
    if (tankStrappings.inc7 && [tankStrappings.inc7 intValue] > maxInc) {
        maxInc = [tankStrappings.inc7 intValue];
    }
    if (tankStrappings.inc8 && [tankStrappings.inc8 intValue] > maxInc) {
        maxInc = [tankStrappings.inc8 intValue];
    }
    if (tankStrappings.inc9 && [tankStrappings.inc9 intValue] > maxInc) {
        maxInc = [tankStrappings.inc9 intValue];
    }
    if (tankStrappings.inc10 && [tankStrappings.inc10 intValue] > maxInc) {
        maxInc = [tankStrappings.inc10 intValue];
    }
    
    return maxInc;
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

#pragma mark - swipe gestures

- (IBAction) handleLeftSwipe:(UISwipeGestureRecognizer*)recognizer
{
    NSLog(@"left");
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.width < screenSize.height) {
        if (self.arrTanks.count > self.selectedIndex + 1) {
            TankGaugeEntryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TankGaugeEntryVC"];
            vc.pulseProdHome = self.pulseProdHome;
            vc.arrTanks = self.arrTanks;
            vc.selectedIndex = self.selectedIndex + 1;
            vc.view.tag = 10;
            
            [self.navigationController pushViewController:vc animated:YES];
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
            
            graphVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TankGraphVC"];
            CGRect rect  = CGRectMake(0, 0, screenSize.width, screenSize.height);
            graphVC.view.frame = rect;
            graphVC.tank = self.tank;
            graphVC.arrTankGaugeEntry = self.arrTankGaugeEntry;
            graphVC.arrRunTickets = self.arrRunTickets;
            
            [self addChildViewController:graphVC];
            [self.graphContainerView addSubview:graphVC.view];
        }
            break;
        default:
            break;
    }
}


#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (tableView.tag) {
        case 0:
            count = arrRunTickets.count;
            break;
        case 1:
        case 2:
            count = arrTankGaugeEntry.count;
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    switch (tableView.tag) {
        case 0: // run ticket table
        {
            RunTicketTableCell *runTicketCell = [tableView dequeueReusableCellWithIdentifier:@"RunTicketTableCell" forIndexPath:indexPath];
            
            RunTickets *ticket = arrRunTickets[row];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yyyy"];
            NSString *strTicketTime = [df stringFromDate:ticket.ticketTime];
            
            switch (ticket.ticketOption) {
                case 0:
                    [runTicketCell.viewCategory setBackgroundColor:[UIColor greenColor]];
                    break;
                case 1:
                    [runTicketCell.viewCategory setBackgroundColor:[UIColor blueColor]];
                    break;
                case 2:
                    [runTicketCell.viewCategory setBackgroundColor:[UIColor redColor]];
                    break;
                default:
                    break;
            }
            runTicketCell.lblDate.text = strTicketTime;
            if (ticket.ticketNumber == nil || [ticket.ticketNumber isEqualToString:@""]) {
                runTicketCell.lblTicketNumber.text = @"-";
            } else {
                runTicketCell.lblTicketNumber.text = ticket.ticketNumber;
            }
            runTicketCell.lblGross.text = [self getFloatString:ticket.grossVol];
            runTicketCell.lblNet.text = [self getFloatString:ticket.netVol];
            
            if (ticket.ticketImage != nil) {
                
                if ([ticket.ticketImage rangeOfString:@"runticketimageurl"].location == NSNotFound) {
                    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:ticket.ticketImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    runTicketCell.ticketImage.image = [UIImage imageWithData:imageData];
                } else {
                    NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, ticket.ticketImage];
                    [runTicketCell.ticketImage setImageWithURL:[NSURL URLWithString:url_str] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                }
//                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:ticket.ticketImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
            }
            
            [runTicketCell.btnTicketImage setTag:row];
            
            return runTicketCell;
        }
            break;
        case 1:
        {
            TankGaugeTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"TankGaugeTimeCell" forIndexPath:indexPath];
            
            TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[row];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yy hh:mm a"];
            NSString *strGaugeTime = [df stringFromDate:tankGaugeEntry.gaugeTime];
            if (tankGaugeEntry.comments && ![tankGaugeEntry.comments isEqual:@""]) {
                strGaugeTime = [NSString stringWithFormat:@"%@*", strGaugeTime];
            }
            
            timeCell.lblDate.text = strGaugeTime;
            [timeCell setTag:row];
            
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [timeCell addGestureRecognizer:longPressGesture];
            
            return timeCell;
        }
            break;
        case 2:
        {
            TankGaugeContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"TankGaugeContentCell" forIndexPath:indexPath];
            
            TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[row];
            
            contentCell.lblTankID1.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID1];
            contentCell.lblTankID2.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID2];
            contentCell.lblTankID3.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID3];
            contentCell.lblTankID4.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID4];
            contentCell.lblTankID5.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID5];
            contentCell.lblTankID6.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID6];
            contentCell.lblTankID7.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID7];
            contentCell.lblTankID8.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID8];
            contentCell.lblTankID9.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID9];
            contentCell.lblTankID10.text = [[DBManager sharedInstance] getTankRRCById:tankGaugeEntry.tankID10];
            
            contentCell.lblOilFeet1.text = [self getFeetInches:tankGaugeEntry.oilFeet1];
            contentCell.lblOilFeet2.text = [self getFeetInches:tankGaugeEntry.oilFeet2];
            contentCell.lblOilFeet3.text = [self getFeetInches:tankGaugeEntry.oilFeet3];
            contentCell.lblOilFeet4.text = [self getFeetInches:tankGaugeEntry.oilFeet4];
            contentCell.lblOilFeet5.text = [self getFeetInches:tankGaugeEntry.oilFeet5];
            contentCell.lblOilFeet6.text = [self getFeetInches:tankGaugeEntry.oilFeet6];
            contentCell.lblOilFeet7.text = [self getFeetInches:tankGaugeEntry.oilFeet7];
            contentCell.lblOilFeet8.text = [self getFeetInches:tankGaugeEntry.oilFeet8];
            contentCell.lblOilFeet9.text = [self getFeetInches:tankGaugeEntry.oilFeet9];
            contentCell.lblOilFeet10.text = [self getFeetInches:tankGaugeEntry.oilFeet10];
            
            
            contentCell.lblComment.text = tankGaugeEntry.comments;
            
            [contentCell setTag:row];
            
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [contentCell addGestureRecognizer:longPressGesture];
            
            return contentCell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

-(NSString*) getFloatString:(NSString*)value
{
    
    if (value == nil || [value isEqualToString:@""] || [value floatValue] == 0.0f) {
        return @"-";
    }
    NSString *result = @"";
    
    if (value) {
        float fValue = [value floatValue];
        if (fValue > 100)
            result = [NSString stringWithFormat:@"%.1f", fValue];
        else if (fValue > 10)
            result = [NSString stringWithFormat:@"%.1f", fValue];
        else
            result = [NSString stringWithFormat:@"%.2f", fValue];
    }
    
    return result;
}

-(NSString*) getFeetInches:(int)gauge
{
    if (gauge == 0) {
        return @"0";
    }
    
    int feet = gauge / 4 / 12;
    float inches = gauge / 4.0f - feet * 12;
    NSString *strTankHeight = [NSString stringWithFormat:@"%d' %.2f\"", feet, inches];
    return strTankHeight;
}

-(void) longPress:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan. %d", (int)recognizer.view.tag);
        
        NSInteger row = recognizer.view.tag;
        TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[row];
        
//        if (tankGaugeEntry.tankGaugeID < 0) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"You cannot edit this data before refreshing." preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:closeAction];
//            [self presentViewController:alert animated:YES completion:nil];
//            [self initData];
//            return;
//        }
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strGaugeTime = [df stringFromDate:tankGaugeEntry.gaugeTime];
        NSString *message = [NSString stringWithFormat:@"Would you like to edit from %@?", strGaugeTime];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TankGaugeEntryEditVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TankGaugeEntryEditVC"];
            vc.strLeaseName = pulseProdHome.leaseName;
            vc.strLease = pulseProdHome.lease;
            vc.isNew = NO;
            vc.tankGaugeEntry = tankGaugeEntry;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:yesAction];
        [alertController addAction:noAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.view.tag = 0;
    if ([segue.identifier isEqualToString:@"AddTankGaugeSegue"])
    {
        TankGaugeEntryEditVC *vc = segue.destinationViewController;
        vc.strLeaseName = pulseProdHome.leaseName;
        vc.strLease = pulseProdHome.lease;
        vc.isNew = YES;
        vc.tankGaugeEntry = nil;
    }
    else if ([segue.identifier isEqualToString:@"EditRunTicketSegue"])
    {
        AddRunTicketsVC *vc = segue.destinationViewController;
        vc.tank = tank;
        vc.runTickets = arrRunTickets.count > 0 ? arrRunTickets[0] : nil;
        vc.pulseProdHome = pulseProdHome;
        vc.isEdit = NO;
    } else if ([segue.identifier isEqualToString:@"RunTicketDetailSegue"]) {
        RunTicketsDetailVC *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.runTicketsTable indexPathForSelectedRow];
        NSInteger row = [indexPath row];
        RunTickets *ticket = arrRunTickets[row];
        
        vc.ticket = ticket;
        vc.pulseProdHome = pulseProdHome;
        vc.tank = tank;
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
    
    [self.dateTableView reloadData];
    [self.contentTableView reloadData];
    
    [self.btnOverview setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnData setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.viewOverview setHidden:YES];
    [self.viewData setHidden:NO];
}



#pragma mark - button events

- (IBAction)onTicketImage:(id)sender {
    NSInteger row = [sender tag];
    
    RunTickets *ticket = arrRunTickets[row];
//    if (ticket.ticketImage) {
//
//        [self.viewTicketImage setHidden:NO];
//
//        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:ticket.ticketImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        self.imgTicketImage.image = [UIImage imageWithData:imageData];
//    }
    if (ticket.ticketImage) {
        NSMutableArray *aryImages = [[NSMutableArray alloc] init];
        if ([ticket.ticketImage rangeOfString:@"runticketimageurl"].location == NSNotFound) {
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:ticket.ticketImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [aryImages addObject:[UIImage imageWithData:imageData]];
            //        runTicketCell.ticketImage.image = ;
        } else {
            NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, ticket.ticketImage];
            [aryImages addObject:[NSURL URLWithString:url_str]];
            //        [runTicketCell.ticketImage sd_setImageWithURL:[NSURL URLWithString:url_str]];
        }
        
        BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:[aryImages copy]];
        imageVC.startingIndex = 0;
        [self presentViewController:imageVC animated:YES completion:nil];
    }
}

- (IBAction)onFullTicketImage:(id)sender {
    self.imgTicketImage.image = nil;
    [self.viewTicketImage setHidden:YES];
}

#pragma mark -
-(int) getGauge:(TankGaugeEntry*)tankGaugeEntry withTankID:(int)tankID
{
    int result = 0;

    if (tankGaugeEntry.tankID1 == tankID)
        result = tankGaugeEntry.oilFeet1;
    if (tankGaugeEntry.tankID2 == tankID)
        result = tankGaugeEntry.oilFeet2;
    if (tankGaugeEntry.tankID3 == tankID)
        result = tankGaugeEntry.oilFeet3;
    if (tankGaugeEntry.tankID4 == tankID)
        result = tankGaugeEntry.oilFeet4;
    if (tankGaugeEntry.tankID5 == tankID)
        result = tankGaugeEntry.oilFeet5;
    if (tankGaugeEntry.tankID6 == tankID)
        result = tankGaugeEntry.oilFeet6;
    if (tankGaugeEntry.tankID7 == tankID)
        result = tankGaugeEntry.oilFeet7;
    if (tankGaugeEntry.tankID8 == tankID)
        result = tankGaugeEntry.oilFeet8;
    if (tankGaugeEntry.tankID9 == tankID)
        result = tankGaugeEntry.oilFeet9;
    if (tankGaugeEntry.tankID10 == tankID)
        result = tankGaugeEntry.oilFeet10;

    return result;
}


@end
