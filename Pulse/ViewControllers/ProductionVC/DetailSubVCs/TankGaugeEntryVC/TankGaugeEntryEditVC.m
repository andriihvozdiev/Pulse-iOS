#import "TankGaugeEntryEditVC.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetMultipleStringPicker.h"

#import "TankGaugeEditCell.h"
#import "TankGaugeCommentCell.h"
#import "HapticHelper.h"

@interface TankGaugeEntryEditVC ()
{
    NSInteger numberOfRows;
}
@end

@implementation TankGaugeEntryEditVC
@synthesize isNew;
@synthesize tankGaugeEntry;
@synthesize arrTanks;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 5.0f;
    
    self.btnCommentSave.layer.cornerRadius = 3.0f;
    self.btnCommentCancel.layer.cornerRadius = 3.0f;
    self.txtComment.layer.cornerRadius = 5.0f;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
    [self.viewComment setHidden:YES];
    
    arrTanks = [[DBManager sharedInstance] getTanksByLease:self.strLease];
    self.arrTankHeights = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrTanks.count; i++){
        Tanks *tank = arrTanks[i];
        NSArray *arrTankGaugeEntry = [[DBManager sharedInstance] getTankGaugeEntry:tank.lease tankID:tank.tankID];
        if (arrTankGaugeEntry.count > 0) {
            
            int gauge = 0;
            
            if (isNew) {
                TankGaugeEntry *tankGaugeEntryTmp = arrTankGaugeEntry[0];
                gauge = [self getGauge:tankGaugeEntryTmp withTankID:tank.tankID];
            } else {
                if (tankGaugeEntry)
                    gauge = [self getGauge:tankGaugeEntry withTankID:tank.tankID];
            }
           
            [self.arrTankHeights addObject:[NSString stringWithFormat:@"%d", gauge]];
            
        } else {
            [self.arrTankHeights addObject:@""];
        }
    }
    
    
    numberOfRows = arrTanks.count + 4;
    
    self.arrFeets = [[NSMutableArray alloc] init];
    self.arrInches = [[NSMutableArray alloc] init];
    self.arrQuarterInches = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i++) {
        NSString *str = [NSString stringWithFormat:@"%d'", i];
        [self.arrFeets addObject:str];
        
        [self.arrInches addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.arrQuarterInches addObject:@"0\""];
    [self.arrQuarterInches addObject:@"25\""];
    [self.arrQuarterInches addObject:@"50\""];
    [self.arrQuarterInches addObject:@"75\""];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    [AppData sharedInstance].changedStatusDelegate = self;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    
    if (isNew) {
        
        self.strDate = [dateFormatter stringFromDate:[NSDate date]];
        self.strTime = [timeFormatter stringFromDate:[NSDate date]];
        self.strComment = nil;
    } else {
        if (tankGaugeEntry) {
            self.strDate = [dateFormatter stringFromDate:tankGaugeEntry.gaugeTime];
            self.strTime = [timeFormatter stringFromDate:tankGaugeEntry.gaugeTime];
            self.strComment = tankGaugeEntry.comments;
        }
    }
    
    [self showSyncStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
   
    int totalcount = 0;
    for (NSString *strTankHeight in self.arrTankHeights) {
        if (![strTankHeight isEqual:@""]) {
            totalcount += 1;
        }
    }
    
    if (totalcount == 0) {
        [self showDefaultAlert:@"Add one or more tank numbers" withMessage:nil];
        return;
    }
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    [dicData setValue:self.strLease forKey:@"lease"];
    [dicData setValue:[NSString stringWithFormat:@"%@ %@", self.strDate, self.strTime] forKey:@"gaugeTime"];
    [dicData setValue:self.strComment forKey:@"comment"];
    NSMutableArray *arrTankGauges = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrTanks.count; i++) {
        NSString *strTankHeight = self.arrTankHeights[i];
        if (![strTankHeight isEqual:@""]) {
            
            Tanks *tank = arrTanks[i];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:[NSString stringWithFormat:@"%d", tank.tankID] forKey:@"tankID"];
            [dic setValue:strTankHeight forKey:@"oilFeet"];
            [arrTankGauges addObject:dic];
        }
    }
    [dicData setObject:arrTankGauges forKey:@"tankheights"];
    if (isNew) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *now = [NSDate date];
        NSString *strToday = [timeFormatter stringFromDate:now];
        NSDate *todayDate = [timeFormatter dateFromString:strToday];
        long timeStamp1 = (long)([todayDate timeIntervalSince1970]);
        long timeStamp2 = (long)([now timeIntervalSince1970]);
        int timeStamp = 0 - abs((int)(timeStamp2 - timeStamp1));
        
        [dicData setValue:[NSNumber numberWithInt:timeStamp] forKey:@"tankGaugeId"];
    } else {
        [dicData setValue:[NSNumber numberWithInt:tankGaugeEntry.tankGaugeID] forKey:@"tankGaugeId"];
    }
    if ([[DBManager sharedInstance] addTankGaugeEntry:dicData]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Added New TankGaugeEntry Successfully." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        [self showDefaultAlert:nil withMessage:@"Added a New TankGaugeEntry Failed."];
    }
    
}

- (IBAction)onCommentSave:(id)sender {
    self.strComment = self.txtComment.text;
    [self.txtComment resignFirstResponder];
    [self.viewComment setHidden:YES];
    
    [self.tableView reloadData];
}

- (IBAction)onCommentCancel:(id)sender {
    
    [self.txtComment resignFirstResponder];
    [self.viewComment setHidden:YES];
}


#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TankGaugeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TankGaugeEditCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    switch (row) {
        case 0:
            cell.lblTitle.text = self.strLeaseName;
            [cell.lblContent setHidden:YES];
            [cell.imgEdit setHidden:YES];
            return cell;
            break;
        case 1:
            cell.lblTitle.text = @"Date";
            if (self.strDate) {
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", self.strDate];
                if (!isNew) {
                    [cell.imgEdit setHidden:YES];
                }
            }
            return cell;
            break;
        case 2:
            cell.lblTitle.text = @"Time";
            if (self.strTime) {
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", self.strTime];
                if (!isNew) {
                    [cell.imgEdit setHidden:YES];
                }
            }
            return cell;
            break;
        default:
            if (numberOfRows == row + 1) {
                TankGaugeCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"TankGaugeCommentCell" forIndexPath:indexPath];
                if (self.strComment && ![self.strComment isEqual:@""]) {
                    commentCell.lblComments.text = self.strComment;
                }
                return commentCell;
            } else {
                Tanks *tank = arrTanks[row-3];
                
                cell.lblTitle.text = [NSString stringWithFormat:@"Tank Number(%@)", tank.rrc];
                cell.lblContent.text = @"";
                
                if (self.arrTankHeights.count > (row - 3)) {
                    NSString *strOilFeet = self.arrTankHeights[row - 3];
                    if (![strOilFeet isEqual:@""]) {
                        int oilFeet = [strOilFeet intValue];
                        int feet = oilFeet / 4 / 12;
                        float inches = oilFeet / 4.0f - feet * 12;
                        
                        NSString *str = [NSString stringWithFormat:@"%d' %.2f\"", feet, inches];
                        cell.lblContent.text = str;
                        
                    }
                }
                return cell;
            }
            break;
    }
    
    return nil;
}

#pragma mark - tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:
            break;
        case 1: // Date
//            if (isNew) {
                [self onDate];
//            }
            break;
        case 2: // Time
//            if (isNew) {
                [self onTime];
//            }
            break;
        default:
            if (numberOfRows == row + 1) {
                self.txtComment.text = self.strComment;
                [self.viewComment setHidden:NO];
                [self.txtComment becomeFirstResponder];
            } else {
                [self onTank:row - 3];
            }
            break;
    }
}


#pragma mark -
- (void)onDate
{
    
    UIView *viewDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [viewDatePicker setBackgroundColor:[UIColor clearColor]];
    
    // Make a frame for the picker & then create the picker
    CGRect pickerFrame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
   
    datePicker.hidden = NO;
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy"];
    if (!isNew) {
        [datePicker setDate:[defaultFormatter dateFromString:self.strDate]];
    }
    
    [viewDatePicker addSubview:datePicker];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController.view addSubview:viewDatePicker];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     //Detect particular click by tag and do some thing here
                                     
                                     [self setSelectedDateInField:YES];
                                     NSLog(@"OK action");
                                     
                                 }];
    [alertController addAction:doneAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    alertController.view.subviews[0].subviews[1].subviews[0].subviews[0].backgroundColor = [UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:1.0];
    
}

-(void)setSelectedDateInField:(BOOL)isDate
{
    NSLog(@"date :: %@",datePicker.date.description);
    
    //set Date formatter
    
    if (isDate) {
        NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
        [defaultFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *strSelectedDate = [defaultFormatter stringFromDate:datePicker.date];
        
        self.strDate = strSelectedDate;
    } else {
        NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
        [defaultFormatter setDateFormat:@"HH:mm:ss"];
        
        NSString *strSelectedDate = [defaultFormatter stringFromDate:datePicker.date];
        
        self.strTime = strSelectedDate;
    }
    
    [self.tableView reloadData];    
}

- (void)onTime
{
    
    UIView *viewDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [viewDatePicker setBackgroundColor:[UIColor clearColor]];
    
    // Make a frame for the picker & then create the picker
    CGRect pickerFrame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.hidden = NO;
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"HH:mm:ss"];
    if (!isNew) {
        [datePicker setDate:[defaultFormatter dateFromString:self.strTime]];
    }
    
    [viewDatePicker addSubview:datePicker];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController.view addSubview:viewDatePicker];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     //Detect particular click by tag and do some thing here
                                     
                                     [self setSelectedDateInField:NO];
                                     NSLog(@"OK action");
                                     
                                 }];
    [alertController addAction:doneAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    
    [alertController addAction:cancelAction];
    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    alertController.view.subviews[0].subviews[1].subviews[0].subviews[0].backgroundColor = [UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:1.0];
    
}


-(void) onTank:(NSInteger)number
{

    float feet = 0.0f;
    int mInch = 0;
    int sInch = 0;
    if (self.arrTankHeights.count > number) {
        int height = (int)[self.arrTankHeights[number] integerValue];
        feet = height / 4.0f / 12.0f;
        float fInches = height / 4.0f - (int)feet * 12;
        mInch = (int)fInches;
        sInch = (fInches - mInch) / 0.25f;
        
        
    }
    ActionSheetMultipleStringPicker *stringPicker = [ActionSheetMultipleStringPicker showPickerWithTitle:@"Inch & Feet" rows:@[self.arrFeets, self.arrInches, self.arrQuarterInches] initialSelection:@[[NSNumber numberWithInt:(int)feet], [NSNumber numberWithInt:mInch], [NSNumber numberWithInt:sInch]] doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
        
        int feet = [selectedIndexes[0] intValue];
        float inches = [selectedIndexes[1] intValue] + [selectedIndexes[2] intValue] * 0.25f;
        
        int oilFeet = (inches + feet * 12) * 4;
        NSString *strOilFeet = [NSString stringWithFormat:@"%d", oilFeet];
        
        [self.arrTankHeights replaceObjectAtIndex:number withObject:strOilFeet];
        
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        
    } origin:self.view];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

#pragma mark -
-(int) getGauge:(TankGaugeEntry*)tankGaugeEntryTmp withTankID:(int)tankID
{
    int result = 0;
    
    if (tankGaugeEntryTmp.tankID1 == tankID)
        result = tankGaugeEntryTmp.oilFeet1;
    if (tankGaugeEntryTmp.tankID2 == tankID)
        result = tankGaugeEntryTmp.oilFeet2;
    if (tankGaugeEntryTmp.tankID3 == tankID)
        result = tankGaugeEntryTmp.oilFeet3;
    if (tankGaugeEntryTmp.tankID4 == tankID)
        result = tankGaugeEntryTmp.oilFeet4;
    if (tankGaugeEntryTmp.tankID5 == tankID)
        result = tankGaugeEntryTmp.oilFeet5;
    if (tankGaugeEntryTmp.tankID6 == tankID)
        result = tankGaugeEntryTmp.oilFeet6;
    if (tankGaugeEntryTmp.tankID7 == tankID)
        result = tankGaugeEntryTmp.oilFeet7;
    if (tankGaugeEntryTmp.tankID8 == tankID)
        result = tankGaugeEntryTmp.oilFeet8;
    if (tankGaugeEntryTmp.tankID9 == tankID)
        result = tankGaugeEntryTmp.oilFeet9;
    if (tankGaugeEntryTmp.tankID10 == tankID)
        result = tankGaugeEntryTmp.oilFeet10;
    
    return result;
}


#pragma mark - show default alert

-(void) showDefaultAlert:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
