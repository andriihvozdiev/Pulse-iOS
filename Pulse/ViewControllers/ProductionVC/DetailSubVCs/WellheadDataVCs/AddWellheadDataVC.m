#import "AddWellheadDataVC.h"
#import "ActionSheetStringPicker.h"
#import "HapticHelper.h"

#import "WellheadDataEditCell.h"
#import "WellheadDataToggleEditCell.h"
#import "WellheadDataCommentEditCell.h"

@interface AddWellheadDataVC ()
{
    NSArray *arrWellProblems;
    NSMutableArray *arrReason;
}
@end

@implementation AddWellheadDataVC
@synthesize isNew;
@synthesize welllist;
@synthesize wellheadData;
@synthesize dicWellheadData;

@synthesize arrWellheadTitles;
@synthesize arrContents;
@synthesize arrContentsUpdatedTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 5.0f;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
    self.btnCommentSave.layer.cornerRadius = 3.0f;
    self.btnCommentCancel.layer.cornerRadius = 3.0f;
    self.txtComment.layer.cornerRadius = 5.0f;
    [self.viewComment setHidden:YES];
    
    arrWellProblems = [[DBManager sharedInstance] getWellProblems];
    arrReason = [[NSMutableArray alloc] init];
    
    [arrReason addObject:@"No Well Problem"];
    for (ListWellProblem *listWellProblem in arrWellProblems) {
        [arrReason addObject:listWellProblem.reason];
    }
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    [self initData];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    
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
    arrWellheadTitles = @[@"Check Time", @"Lease", @"Well Number", @"Arrival", @"Depart", @"Well Problem", @"Prod Type", @"Tubing", @"Casing", @"Surface", @"Choke", @"SPM", @"Stroke Size", @"Pound", @"Time On", @"Time Off", @"ESPHz", @"ESPAmp", @"Oil Cut", @"Water Cut", @"Emulsion Cut"];
    
    arrContents = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrWellheadTitles.count; i++) {
        [arrContents addObject:@""];
    }
    
    arrContentsUpdatedTime = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrWellheadTitles.count; i++) {
        [arrContentsUpdatedTime addObject:@""];
    }
    
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    if (isNew) {
        NSString *currentTime = [defaultFormatter stringFromDate:[NSDate date]];
        [arrContents replaceObjectAtIndex:0 withObject:currentTime];
    } else {
        NSString *currentTime = [defaultFormatter stringFromDate:wellheadData.checkTime];
        [arrContents replaceObjectAtIndex:0 withObject:currentTime];
    }
    
    NSString *strLease = [[DBManager sharedInstance] getLeaseNameFromLease:self.welllist.grandparentPropNum];
    [arrContents replaceObjectAtIndex:1 withObject:strLease];
    
    [arrContents replaceObjectAtIndex:2 withObject:welllist.wellNumber];
    
    if (isNew) {
        self.strComment = @"";
    } else {
        self.strComment = wellheadData.comments;
        if (wellheadData) [self fillOldValues];
    }
    
}

-(void) fillOldValues
{
    if (wellheadData.statusArrival) {
        [arrContents replaceObjectAtIndex:3 withObject:@"On"];
    } else {
        [arrContents replaceObjectAtIndex:3 withObject:@"Off"];
    }
    if (wellheadData.statusDepart) {
        [arrContents replaceObjectAtIndex:4 withObject:@"On"];
    } else {
        [arrContents replaceObjectAtIndex:4 withObject:@"Off"];
    }
    if (wellheadData.wellProblem) {
        [arrContents replaceObjectAtIndex:5 withObject:wellheadData.wellProblem];
    }
    if (wellheadData.prodType) {
        [arrContents replaceObjectAtIndex:6 withObject:wellheadData.prodType];
    }
    if (wellheadData.tubingPressure) {
        [arrContents replaceObjectAtIndex:7 withObject:wellheadData.tubingPressure];
    }
    if (wellheadData.casingPressure) {
        [arrContents replaceObjectAtIndex:8 withObject:wellheadData.casingPressure];
    }
    if (wellheadData.bradenheadPressure) {
        [arrContents replaceObjectAtIndex:9 withObject:wellheadData.bradenheadPressure];
    }
    if (wellheadData.choke) {
        [arrContents replaceObjectAtIndex:10 withObject:wellheadData.choke];
    }
    if (wellheadData.spm) {
        [arrContents replaceObjectAtIndex:11 withObject:wellheadData.spm];
    }
    if (wellheadData.strokeSize) {
        [arrContents replaceObjectAtIndex:12 withObject:wellheadData.strokeSize];
    }
    if (wellheadData.pound) {
        [arrContents replaceObjectAtIndex:13 withObject:wellheadData.pound];
    }
    if (wellheadData.timeOn) {
        [arrContents replaceObjectAtIndex:14 withObject:wellheadData.timeOn];
    }
    if (wellheadData.timeOff) {
        [arrContents replaceObjectAtIndex:15 withObject:wellheadData.timeOff];
    }
    if (wellheadData.espHz) {
        [arrContents replaceObjectAtIndex:16 withObject:wellheadData.espHz];
    }
    if (wellheadData.espAmp) {
        [arrContents replaceObjectAtIndex:17 withObject:wellheadData.espAmp];
    }
    if (wellheadData.oilCut) {
        [arrContents replaceObjectAtIndex:18 withObject:wellheadData.oilCut];
    }
    if (wellheadData.waterCut) {
        [arrContents replaceObjectAtIndex:19 withObject:wellheadData.waterCut];
    }
    if (wellheadData.emulsionCut) {
        [arrContents replaceObjectAtIndex:20 withObject:wellheadData.emulsionCut];
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
    
    if ([arrContents[6] isEqual:@""]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing some fields" message:@"Input Prod Type" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    
    NSString *checkTime = arrContents[0];
    NSString *lease = self.welllist.lease;
    NSString *wellNumber = arrContents[2];
    NSString *statusArrival = [arrContents[3] isEqual:@"On"] ? @"On" : @"Off";
    NSString *statusDepart = [arrContents[4] isEqual:@"On"] ? @"On" : @"Off";
    NSString *wellProblem = [arrContents[5] isEqual:@""] ? nil : [[DBManager sharedInstance] getWellproblemReasonCode:arrContents[5]];
    
    NSString *prodType = arrContents[6];
    NSString *tubingPressure = [arrContents[7] isEqual:@""] ? nil : arrContents[7];
    NSString *casingPressure = [arrContents[8] isEqual:@""] ? nil : arrContents[8];
    NSString *bradenheadPressure = [arrContents[9] isEqual:@""] ? nil : arrContents[9];
    NSString *choke = [arrContents[10] isEqual:@""] ? nil : arrContents[10];
    NSString *spm = [arrContents[11] isEqual:@""] ? nil : arrContents[11];
    NSString *strokeSize = [arrContents[12] isEqual:@""] ? nil : arrContents[12];
    NSString *pound = [arrContents[13] isEqual:@""] ? nil : arrContents[13];
    NSString *timeOn = [arrContents[14] isEqual:@""] ? nil : arrContents[14];
    NSString *timeOff = [arrContents[15] isEqual:@""] ? nil : arrContents[15];
    NSString *espHz = [arrContents[16] isEqual:@""] ? nil : arrContents[16];
    NSString *espAmp = [arrContents[17] isEqual:@""] ? nil : arrContents[17];
    NSString *oilCut = [arrContents[18] isEqual:@""] ? nil : arrContents[18];
    NSString *waterCut = [arrContents[19] isEqual:@""] ? nil : arrContents[19];
    NSString *emulsionCut = [arrContents[20] isEqual:@""] ? nil : arrContents[20];
    
    //NSString *pumpSize = [arrContents[6] isEqual:@""] ? nil : arrContents[6];
    
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
        
        [dicParam setValue:[NSNumber numberWithInt:timeStamp] forKey:@"dataID"];
    } else {
        [dicParam setValue:[NSString stringWithFormat:@"%d", wellheadData.dataID] forKey:@"dataID"];
    }
    
    
    [dicParam setValue:checkTime forKey:@"checkTime"];
    [dicParam setValue:deviceID forKey:@"deviceID"];
    [dicParam setValue:lease forKey:@"lease"];
    [dicParam setValue:wellNumber forKey:@"wellNumber"];
    
    [dicParam setValue:statusArrival forKey:@"statusArrival"];
    [dicParam setValue:statusDepart forKey:@"statusDepart"];
    
    [dicParam setValue:wellProblem forKey:@"wellProblem"];
    [dicParam setValue:prodType forKey:@"prodType"];
    [dicParam setValue:choke forKey:@"choke"];
    //[dicParam setValue:pumpSize forKey:@"pumpSize"];
    [dicParam setValue:spm forKey:@"spm"];
    [dicParam setValue:strokeSize forKey:@"strokeSize"];
    [dicParam setValue:timeOn forKey:@"timeOn"];
    [dicParam setValue:timeOff forKey:@"timeOff"];
    [dicParam setValue:casingPressure forKey:@"casingPressure"];
    [dicParam setValue:tubingPressure forKey:@"tubingPressure"];
    [dicParam setValue:bradenheadPressure forKey:@"bradenheadPressure"];
    
    [dicParam setValue:waterCut forKey:@"waterCut"];
    [dicParam setValue:emulsionCut forKey:@"emulsionCut"];
    [dicParam setValue:oilCut forKey:@"oilCut"];
    
    [dicParam setValue:pound forKey:@"pound"];
    [dicParam setValue:espHz forKey:@"espHz"];
    [dicParam setValue:espAmp forKey:@"espAmp"];
    
    [dicParam setValue:self.strComment forKey:@"comments"];
    [dicParam setValue:userid forKey:@"userid"];
    
    if ([[DBManager sharedInstance] addWellheadData:dicParam]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Added New WellheadData Successfully." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Added a New WellheadData Failed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (IBAction)onAutoEdit:(id)sender {
    
    if (!wellheadData) {
        return;
    }
    
    UIButton *btnAutoEdit = (UIButton*)sender;
    NSInteger row = btnAutoEdit.tag;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    switch (row) {
        case 0:
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
            [arrContents replaceObjectAtIndex:row withObject:strDateTime];
            break;
        }
        case 3:
            if (wellheadData.statusArrival) {
                [arrContents replaceObjectAtIndex:row withObject:@"On"];
            } else {
                [arrContents replaceObjectAtIndex:row withObject:@"Off"];
            }
            break;
        case 4:
            if (wellheadData.statusDepart) {
                [arrContents replaceObjectAtIndex:row withObject:@"On"];
            } else {
                [arrContents replaceObjectAtIndex:row withObject:@"Off"];
            }
            break;
        case 5:
            if (wellheadData.wellProblem) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.wellProblem];
            }
            break;
        case 6:
            if (wellheadData.prodType) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.prodType];
            }
            break;
        case 7:
            if (wellheadData.tubingPressure) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.tubingPressure];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                
            } else {
                if ([dicWellheadData objectForKey:@"tubingPressure"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"tubingPressure"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.tubingPressure];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 8:
            if (wellheadData.casingPressure) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.casingPressure];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"casingPressure"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"casingPressure"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.casingPressure];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                    
                }
            }
            break;
        case 9:
            if (wellheadData.bradenheadPressure) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.bradenheadPressure];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"bradenheadPressure"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"bradenheadPressure"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.bradenheadPressure];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 10:
            if (wellheadData.choke) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.choke];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"choke"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"choke"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.choke];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 11:
            if (wellheadData.spm) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.spm];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"spm"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"spm"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.spm];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 12:
            if (wellheadData.strokeSize) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.strokeSize];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"strokeSize"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"strokeSize"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.strokeSize];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 13:
            if (wellheadData.pound) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.pound];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"pound"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"pound"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.pound];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 14:
            if (wellheadData.timeOn) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.timeOn];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"timeOn"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"timeOn"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.timeOn];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 15:
            if (wellheadData.timeOff) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.timeOff];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"timeOff"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"timeOff"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.timeOff];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 16:
            if (wellheadData.espHz) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.espHz];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"espHz"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"espHz"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.espHz];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 17:
            if (wellheadData.espAmp) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.espAmp];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"espAmp"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"espAmp"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.espAmp];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 18:
            if (wellheadData.oilCut) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.oilCut];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"oilCut"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"oilCut"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.oilCut];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 19:
            if (wellheadData.waterCut) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.waterCut];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"waterCut"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"waterCut"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.waterCut];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        case 20:
            if (wellheadData.emulsionCut) {
                [arrContents replaceObjectAtIndex:row withObject:wellheadData.emulsionCut];
                NSDate *updatedDate = wellheadData.checkTime;
                NSString *dateStr = [df stringFromDate:updatedDate];
                [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
            } else {
                if ([dicWellheadData objectForKey:@"emulsionCut"] != nil) {
                    WellheadData *tmpData = [dicWellheadData objectForKey:@"emulsionCut"];
                    NSDate *updatedDate = tmpData.checkTime;
                    NSString *dateStr = [df stringFromDate:updatedDate];
                    NSString *valueToSet = [NSString stringWithFormat:@"%@", tmpData.emulsionCut];
                    [arrContentsUpdatedTime replaceObjectAtIndex:row withObject:dateStr];
                    
                    [arrContents replaceObjectAtIndex:row withObject:valueToSet];
                }
            }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (IBAction)toggleOnOff:(id)sender {
    
    UISegmentedControl *segOnOff = (UISegmentedControl*)sender;
    switch (segOnOff.tag) {
        case 3:
            if (segOnOff.selectedSegmentIndex == 0) {
                [arrContents replaceObjectAtIndex:3 withObject:@"On"];
            } else {
                [arrContents replaceObjectAtIndex:3 withObject:@"Off"];
            }
            break;
        case 4:
            if (segOnOff.selectedSegmentIndex == 0) {
                [arrContents replaceObjectAtIndex:4 withObject:@"On"];
            } else {
                [arrContents replaceObjectAtIndex:4 withObject:@"Off"];
            }
            break;
        default:
            break;
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
    
    WellheadDataEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:@"WellheadDataEditCell" forIndexPath:indexPath];
    
    
    NSInteger row = [indexPath row];
    
    [editCell.btnAutoEdit setTag:row];
    [editCell.btnAutoEdit setHidden:NO];
    if (row == 1 || row == 2) {
        [editCell.btnAutoEdit setHidden:YES];
    }
    
    if (!isNew) {
        if (row == 0 || row == 5) {
            [editCell.btnAutoEdit setHidden:YES];
        }
    }
    
    editCell.lblContent.text = @"()";
    
    
    switch (row) {
        case 3:
        case 4:
        {
            WellheadDataToggleEditCell *toggleCell = [tableView dequeueReusableCellWithIdentifier:@"WellheadDataToggleEditCell" forIndexPath:indexPath];
            toggleCell.lblTitle.text = arrWellheadTitles[row];
            [toggleCell.segOnOff setTag:row];
            
            if ([arrContents[row] isEqual:@"On"]) {
                [toggleCell.segOnOff setSelectedSegmentIndex:0];
            } else {
                [toggleCell.segOnOff setSelectedSegmentIndex:1];
            }
            return toggleCell;
            break;
        }
        case 21: // comment cell
        {
            WellheadDataCommentEditCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"WellheadDataCommentEditCell" forIndexPath:indexPath];
            
            commentCell.lblComments.text = [self.strComment isEqual:@""] ? @"Add a comment" : self.strComment;
            return commentCell;
        }
            break;
        default:
            editCell.lblTitle.text = arrWellheadTitles[row];
            editCell.lblContent.text = [NSString stringWithFormat:@"(%@)", arrContents[row]];
            
            editCell.lblLastUpdatedDate.layer.cornerRadius = 3.0f;
            editCell.lblLastUpdatedDate.layer.masksToBounds = YES;
            if ([arrContentsUpdatedTime[row] isEqualToString:@""]) {
                editCell.lblLastUpdatedDate.hidden = YES;
                editCell.btnAutoEdit.hidden = NO;
            } else {
                editCell.lblLastUpdatedDate.text = [NSString stringWithFormat:@" %@  ", arrContentsUpdatedTime[row]];
                editCell.lblLastUpdatedDate.hidden = NO;
                editCell.btnAutoEdit.hidden = YES;
            }
            return editCell;
            break;
    }
   
    return editCell;
}

#pragma mark - tableview delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    switch (row) {
        case 0: // Check Time
            [self onDateTime:0];
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            break;
        case 5: // Well Problem
            if (isNew) [self selectWellProblem:5];
            break;
        case 6: // Prod Type
            [self selectProdType:6];
            break;
        case 21: // Comment
            self.txtComment.text = self.strComment;
            [self.viewComment setHidden:NO];
            [self.txtComment becomeFirstResponder];
            break;
        default:
            [self showInputNumberAlert:row withTitle:arrWellheadTitles[row]];
            break;
        
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
    [datePicker setDate:[defaultFormatter dateFromString:self.arrContents[selectedIndex]]];
    
    
    [viewDatePicker addSubview:datePicker];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController.view addSubview:viewDatePicker];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
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
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
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
            [arrContentsUpdatedTime replaceObjectAtIndex:selectedIndex withObject:@""];
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

-(void) selectWellProblem:(NSInteger)index
{
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Well Problem" rows:arrReason initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
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

-(void) selectProdType:(NSInteger)index
{
    NSArray *arrProdType = @[@"Flowing", @"Pumping", @"ESP", @"Injection"];
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Prod Type" rows:arrProdType initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [self.arrContents replaceObjectAtIndex:index withObject:arrProdType[selectedIndex]];
        [self.tableView reloadData];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];

}


@end
