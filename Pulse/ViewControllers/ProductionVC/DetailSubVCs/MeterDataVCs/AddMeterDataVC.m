#import "AddMeterDataVC.h"

#import "MeterDataEditCell.h"
#import "MeterDataCommentEditCell.h"
#import "HapticHelper.h"

#import "ActionSheetStringPicker.h"

@interface AddMeterDataVC ()
{
    NSArray *arrMeterProblems;
    NSMutableArray *arrReason;
}
@end

@implementation AddMeterDataVC
@synthesize isNew;
@synthesize m_gasMeterData;
@synthesize m_waterMeterData;

@synthesize pulseProdHome;
@synthesize meter;
@synthesize arrMeterData;

@synthesize arrGasMeterTitles;
@synthesize arrWaterMeterTitles;
@synthesize arrContents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strMeterType = meter.meterType;
    
    if ([[strMeterType lowercaseString] isEqual:@"gas"]) {
        if (isNew) {
            self.lblNavTitle.text = @"Add Gas Meter";
        } else {
            self.lblNavTitle.text = @"Edit Gas Meter";
        }
        
    } else if ([[strMeterType lowercaseString] isEqual:@"water"]) {
        if (isNew) {
            self.lblNavTitle.text = @"Add Water Meter";
        } else {
            self.lblNavTitle.text = @"Edit Water Meter";
        }
    } else if ([[strMeterType lowercaseString] isEqual:@"oil"]) {
        if (isNew) {
            self.lblNavTitle.text = @"Add Oil Meter";
        } else {
            self.lblNavTitle.text = @"Edit Oil Meter";
        }
    } else if ([[strMeterType lowercaseString] isEqual:@"total flui"]) {
        if (isNew) {
            self.lblNavTitle.text = @"Add Fluid Meter";
        } else {
            self.lblNavTitle.text = @"Edit Fluid Meter";
        }
    }
    
    arrMeterProblems = [[DBManager sharedInstance] getMeterProblems];
    arrReason = [[NSMutableArray alloc] init];
    
    [arrReason addObject:@"No Meter Problem"];
    for (ListMeterProblem *listMeterProblem in arrMeterProblems) {
        [arrReason addObject:listMeterProblem.reason];
    }
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 5.0f;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
    self.btnCommentSave.layer.cornerRadius = 3.0f;
    self.btnCommentCancel.layer.cornerRadius = 3.0f;
    self.txtComment.layer.cornerRadius = 5.0f;
    [self.viewComment setHidden:YES];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    [AppData sharedInstance].changedStatusDelegate = self;
    
    [self initData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showSyncStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) initData
{
    arrGasMeterTitles = @[@"Check Time", @"Lease", @"IDGasMeter", @"Meter Problem", @"Current Flow", @"24 Hr Flow", @"Total Volume", @"Line Pressure", @"Differential"];
    arrWaterMeterTitles = @[@"Check Time", @"Lease", @"MeterNum", @"Meter Problem", @"Current Flow", @"24 Hr Flow", @"Total Vol", @"Reset Vol"];
    
    arrContents = [[NSMutableArray alloc] init];
    
    if ([meter.meterType isEqual:@"Gas"]) {
        for (int i = 0; i < arrGasMeterTitles.count; i++) {
            [arrContents addObject:@""];
        }
    } else {
        for (int i = 0; i < arrWaterMeterTitles.count; i++) {
            [arrContents addObject:@""];
        }
    }
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    if (isNew) {
        NSString *currentTime = [defaultFormatter stringFromDate:[NSDate date]];
        [arrContents replaceObjectAtIndex:0 withObject:currentTime];
        
        NSString *strLease = pulseProdHome.leaseName;
        [arrContents replaceObjectAtIndex:1 withObject:strLease];
        
        
        NSString *strMeterID = meter.meterName;
        [arrContents replaceObjectAtIndex:2 withObject:strMeterID];
        
        self.strComment = @"";
    } else {
        if ([[meter.meterType lowercaseString] isEqual:@"gas"]) {
            NSString *checkTime = [defaultFormatter stringFromDate:m_gasMeterData.checkTime];
            [arrContents replaceObjectAtIndex:0 withObject:checkTime];
            
            [arrContents replaceObjectAtIndex:1 withObject:pulseProdHome.leaseName];
            [arrContents replaceObjectAtIndex:2 withObject:meter.meterName];
            
            if (m_gasMeterData.meterProblem) {
                NSString *meterProblem = [[DBManager sharedInstance] getMeterProblemReason:m_gasMeterData.meterProblem];
                [arrContents replaceObjectAtIndex:3 withObject:meterProblem];
            }
            if (m_gasMeterData.currentFlow) [arrContents replaceObjectAtIndex:4 withObject:m_gasMeterData.currentFlow];
            if (m_gasMeterData.yesterdayFlow) [arrContents replaceObjectAtIndex:5 withObject:m_gasMeterData.yesterdayFlow];
            if (m_gasMeterData.meterCumVol) [arrContents replaceObjectAtIndex:6 withObject:m_gasMeterData.meterCumVol];
            if (m_gasMeterData.linePressure) [arrContents replaceObjectAtIndex:7 withObject:m_gasMeterData.linePressure];
            if (m_gasMeterData.diffPressure) [arrContents replaceObjectAtIndex:8 withObject:m_gasMeterData.diffPressure];
            
            self.strComment = m_gasMeterData.comments;
        } else {
            NSString *checkTime = [defaultFormatter stringFromDate:m_waterMeterData.checkTime];
            [arrContents replaceObjectAtIndex:0 withObject:checkTime];
            
            [arrContents replaceObjectAtIndex:1 withObject:pulseProdHome.leaseName];
            [arrContents replaceObjectAtIndex:2 withObject:meter.meterName];
            
            if (m_waterMeterData.meterProblem) {
                NSString *meterProblem = [[DBManager sharedInstance] getMeterProblemReason:m_waterMeterData.meterProblem];
                [arrContents replaceObjectAtIndex:3 withObject:meterProblem];
            }
            
            if (m_waterMeterData.currentFlow) [arrContents replaceObjectAtIndex:4 withObject:m_waterMeterData.currentFlow];
            if (m_waterMeterData.yesterdayFlow) [arrContents replaceObjectAtIndex:5 withObject:m_waterMeterData.yesterdayFlow];
            if (m_waterMeterData.totalVolume) [arrContents replaceObjectAtIndex:6 withObject:m_waterMeterData.totalVolume];
            
            self.strComment = m_waterMeterData.comments;
        }
    }
    
    
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
    
    if ([meter.meterType isEqual:@"Gas"]) {
        if ([arrContents[5] isEqual:@""]){ // 24HrFlow(YesterdayFlow)
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing some fields" message:@"Input 24 Hr Flow" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
    } else {
//        if ([arrContents[6] isEqual:@""]){ // Total Vol
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing some fields" message:@"Input Total Vol" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//
//            return;
//        }
    }
    
    NSString *meterType = meter.meterType;
    NSString *lease = pulseProdHome.lease;
    NSString *meterID = [NSString stringWithFormat:@"%d", meter.meterID];
    NSString *checkTime = arrContents[0];
    NSString *meterProblem = [[DBManager sharedInstance] getMeterProblemReasonCode:arrContents[3]];
    
    NSString *currentFlow = [arrContents[4] isEqual:@""] ? nil : arrContents[4];
    NSString *yesterdayFlow = [arrContents[5] isEqual:@""] ? nil : arrContents[5];
    NSString *meterCumVol = [arrContents[6] isEqual:@""] ? nil : arrContents[6];
    NSString *totalVolume = [arrContents[6] isEqual:@""] ? nil : arrContents[6]; // if WaterMeterData
    NSString *resetVolume = [arrContents[7] isEqual:@""] ? nil : arrContents[7];
    NSString *linePressure = @"";
    NSString *diffPressure = @"";
    if ([meterType isEqual:@"Gas"]) {
        linePressure = [arrContents[7] isEqual:@""] ? nil : arrContents[7];
        diffPressure = [arrContents[8] isEqual:@""] ? nil : arrContents[8];
    }
    
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSString *deviceID = [NSString stringWithFormat:@"%05d", [userid intValue]];
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    
    if (isNew) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *now = [NSDate date];
        NSString *strToday = [timeFormatter stringFromDate:now];
        NSDate *todayDate = [timeFormatter dateFromString:strToday];
        long timeStamp1 = (long)([todayDate timeIntervalSince1970]);
        long timeStamp2 = (long)([now timeIntervalSince1970]);
        int timeStamp = 0 - abs((int)(timeStamp2 - timeStamp1));
        
        [dicParam setValue:[NSNumber numberWithInt:timeStamp] forKey:@"dataId"];
    } else {
        if ([[meter.meterType lowercaseString] isEqual:@"gas"]) {
            [dicParam setValue:[NSString stringWithFormat:@"%d", m_gasMeterData.dataID] forKey:@"dataId"];
        } else {
            [dicParam setValue:[NSString stringWithFormat:@"%d", m_waterMeterData.wmdID] forKey:@"dataId"];
        }
    }
    
    [dicParam setValue:userid forKey:@"userid"];
    [dicParam setValue:deviceID forKey:@"deviceID"];
    
    [dicParam setValue:meterType forKey:@"metertype"];
    [dicParam setValue:lease forKey:@"lease"];
    [dicParam setValue:meterID forKey:@"meterid"];
    
    [dicParam setValue:checkTime forKey:@"checkTime"];
    [dicParam setValue:meterProblem forKey:@"meterProblem"];
    [dicParam setValue:currentFlow forKey:@"currentFlow"];
    [dicParam setValue:yesterdayFlow forKey:@"yesterdayFlow"];
    
    if ([meterType isEqual:@"Gas"]) {
        [dicParam setValue:meterCumVol forKey:@"meterCumVol"];
        [dicParam setValue:linePressure forKey:@"linePressure"];
        [dicParam setValue:diffPressure forKey:@"diffPressure"];
    } else {
        [dicParam setValue:totalVolume forKey:@"totalVolume"];
        [dicParam setValue:resetVolume forKey:@"resetVolume"];
    }
    
    [dicParam setValue:self.strComment forKey:@"comments"];
    
    if ([[DBManager sharedInstance] addMeterData:dicParam]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Added New MeterData Successfully." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Added a New MeterData Failed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (IBAction)onAutoEdit:(id)sender {
    
    if (arrMeterData.count > 0) {
        UIButton *btnAutoEdit = (UIButton*)sender;
        NSInteger row = btnAutoEdit.tag;
        
        GasMeterData *gasMeterData = nil;
        WaterMeterData *waterMeterData = nil;
        
        if ([meter.meterType isEqual:@"Gas"]) {
            gasMeterData = arrMeterData[0];
        } else {
            waterMeterData = arrMeterData[0];
        }
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        switch (row) {
            case 0:
                if ([meter.meterType isEqual:@"Gas"]) {
                    NSString *strDateTime = [df stringFromDate:gasMeterData.checkTime];
                    [arrContents replaceObjectAtIndex:0 withObject:strDateTime];
                } else {
                    NSString *strDateTime = [df stringFromDate:waterMeterData.checkTime];
                    [arrContents replaceObjectAtIndex:0 withObject:strDateTime];
                }
                break;
            case 3:
                if ([meter.meterType isEqual:@"Gas"]) {
                    if (gasMeterData.meterProblem)
                        [arrContents replaceObjectAtIndex:3 withObject:gasMeterData.meterProblem];
                } else {
                    if (waterMeterData.meterProblem)
                        [arrContents replaceObjectAtIndex:3 withObject:waterMeterData.meterProblem];
                }
                break;
            case 4:
                if ([meter.meterType isEqual:@"Gas"]) {
                    if (gasMeterData.currentFlow)
                        [arrContents replaceObjectAtIndex:4 withObject:gasMeterData.currentFlow];
                } else {
                    if (waterMeterData.currentFlow)
                        [arrContents replaceObjectAtIndex:4 withObject:waterMeterData.currentFlow];
                }
                break;
            case 5:
                if ([meter.meterType isEqual:@"Gas"]) {
                    if (gasMeterData.yesterdayFlow)
                        [arrContents replaceObjectAtIndex:5 withObject:gasMeterData.yesterdayFlow];
                } else {
                    if (waterMeterData.yesterdayFlow)
                        [arrContents replaceObjectAtIndex:5 withObject:waterMeterData.yesterdayFlow];
                }
                break;
            case 6:
                if ([meter.meterType isEqual:@"Gas"]) {
                    if (gasMeterData.meterCumVol)
                        [arrContents replaceObjectAtIndex:6 withObject:gasMeterData.meterCumVol];
                } else {
                    if (waterMeterData.totalVolume)
                        [arrContents replaceObjectAtIndex:6 withObject:waterMeterData.totalVolume];
                }
                break;
            case 7:
                if ([meter.meterType isEqual:@"Gas"]) {
                    if (gasMeterData.linePressure)
                        [arrContents replaceObjectAtIndex:7 withObject:gasMeterData.linePressure];
                } else {
                    if (waterMeterData.resetVolume)
                        [arrContents replaceObjectAtIndex:7 withObject:waterMeterData.resetVolume];
                }
                break;
            case 8:
                if ([meter.meterType isEqual:@"Gas"]) {
                    if (gasMeterData.diffPressure)
                        [arrContents replaceObjectAtIndex:8 withObject:gasMeterData.diffPressure];
                }
                break;
            default:
                break;
        }
        
        [self.tableView reloadData];
    }
}

- (IBAction)onCommentSave:(id)sender
{
    self.strComment = self.txtComment.text;
    [self.txtComment resignFirstResponder];
    [self.viewComment setHidden:YES];
    
    [self.tableView reloadData];
}

- (IBAction)onCommentCancel:(id)sender
{
    [self.txtComment resignFirstResponder];
    [self.viewComment setHidden:YES];
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrContents.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MeterDataEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:@"MeterDataEditCell" forIndexPath:indexPath];
    
    
    NSInteger row = [indexPath row];
    
    [editCell.btnAutoEdit setTag:row];
    [editCell.btnAutoEdit setHidden:NO];
    if (row == 1 || row == 2) {
        [editCell.btnAutoEdit setHidden:YES];
    }
    
    if (!isNew) {
        if (row == 0 || row == 3) {
            [editCell.btnAutoEdit setHidden:YES];
        }
    }
    
    editCell.lblContent.text = @"()";
    
    if ([meter.meterType isEqual:@"Gas"]) {
        switch (row) {
            
            case 9: // comment cell
            {
                MeterDataCommentEditCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"MeterDataCommentEditCell" forIndexPath:indexPath];
                
                commentCell.lblComments.text = [self.strComment isEqual:@""] ? @"Add a comment" : self.strComment;
                return commentCell;
            }
                break;
            default:
                editCell.lblTitle.text = arrGasMeterTitles[row];
                editCell.lblContent.text = [NSString stringWithFormat:@"(%@)", arrContents[row]];
                return editCell;
                break;
        }
    } else {
        switch (row) {
            case 8: // comment cell
            {
                MeterDataCommentEditCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"MeterDataCommentEditCell" forIndexPath:indexPath];
                
                commentCell.lblComments.text = [self.strComment isEqual:@""] ? @"Add a comment" : self.strComment;
                return commentCell;
            }
                break;
            default:
                editCell.lblTitle.text = arrWaterMeterTitles[row];
                editCell.lblContent.text = [NSString stringWithFormat:@"(%@)", arrContents[row]];
                return editCell;
                break;
        }
    }
    
    return editCell;
}

#pragma mark - tableview delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    if ([meter.meterType isEqual:@"Gas"]) {
        switch (row) {
            case 0: // Check Time
//                if (isNew) {
                    [self onDateTime:0];
//                }
                break;
            case 3: // Meter Problem
                if (isNew) [self selectMeterProblem:3];
                break;
            case 4: // Current Flow
                [self showInputNumberAlert:4 withTitle:@"Current Flow"];
                break;
            case 5: // Yesterday Flow
                [self showInputNumberAlert:5 withTitle:@"24 Hr Flow"];
                break;
            case 6: // MeterCumVol
                [self showInputNumberAlert:6 withTitle:@"Total Vol"];
                break;
            case 7: // Line Pressure
                [self showInputNumberAlert:7 withTitle:@"Line Pressure"];
                break;
            case 8: // DiffPressure
                [self showInputNumberAlert:8 withTitle:@"Differential"];
                break;
            case 9:
                self.txtComment.text = self.strComment;
                [self.viewComment setHidden:NO];
                [self.txtComment becomeFirstResponder];
                break;
            default:
                break;
        }
    } else {
        switch (row) {
            case 0: // Check Time
//                if (isNew) {
                    [self onDateTime:0];
//                }
                break;
            case 3: // Meter Problem
                if (isNew) [self selectMeterProblem:3];
                break;
            case 4: // Current Flow
                [self showInputNumberAlert:4 withTitle:@"Current Flow"];
                break;
            case 5: // Yesterday Flow
                [self showInputNumberAlert:5 withTitle:@"24 Hr Flow"];
                break;
            case 6: // Total Volume
                [self showInputNumberAlert:6 withTitle:@"Total Volume"];
                break;
            case 7: // Total Volume
                [self showInputNumberAlert:7 withTitle:@"Reset Volume"];
                break;
            case 8:
                self.txtComment.text = self.strComment;
                [self.viewComment setHidden:NO];
                [self.txtComment becomeFirstResponder];
                break;
            default:
                break;
        }
    }
    
}

#pragma mark -

- (void)onDateTime:(NSInteger)selectedIndex
{
    
    UIView *viewDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [viewDatePicker setBackgroundColor:[UIColor clearColor]];
    
    // Make a frame for the picker & then create the picker
    CGRect pickerFrame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    datePicker.hidden = NO;
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    if (!isNew) {
        [datePicker setDate:[defaultFormatter dateFromString:self.arrContents[selectedIndex]]];
    }
    
    [viewDatePicker addSubview:datePicker];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController.view addSubview:viewDatePicker];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     //Detect particular click by tag and do some thing here
                                     
                                     [self setSelectedDateInField:selectedIndex];
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

-(void)setSelectedDateInField:(NSInteger) selectedIndex
{
    NSLog(@"date :: %@",datePicker.date.description);
    
    //set Date formatter
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *strSelectedDate = [defaultFormatter stringFromDate:datePicker.date];
    
    [self.arrContents replaceObjectAtIndex:selectedIndex withObject:strSelectedDate];
    
    [self.tableView reloadData];
}

-(void) selectMeterProblem:(NSInteger)index
{
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Type" rows:arrReason initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [self.arrContents replaceObjectAtIndex:index withObject:arrReason[selectedIndex]];
        [self.tableView reloadData];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}


-(void) showInputStringAlert:(NSInteger)selectedIndex withTitle:(NSString*)strTitle
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:strTitle
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.keyboardType = UIKeyboardTypeDefault;
     }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alertController.textFields.firstObject;
        [arrContents replaceObjectAtIndex:selectedIndex withObject:textField.text];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void) showInputNumberAlert:(NSInteger)selectedIndex withTitle:(NSString*)strTitle
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:strTitle
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"0.0", @"Values");
         textField.keyboardType = UIKeyboardTypeDecimalPad;
     }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = alertController.textFields.firstObject;
        
        if ([self isNumeric:textfield.text]) {
            [arrContents replaceObjectAtIndex:selectedIndex withObject:textfield.text];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wrong value" message:@"Please input numerical value" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL) isNumeric:(NSString*) checkText{
    
    NSScanner *sc = [NSScanner scannerWithString: checkText];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}




@end
