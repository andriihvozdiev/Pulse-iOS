#import "SelectDatesVC.h"
#import "HapticHelper.h"
#import "DatesCell.h"

@interface SelectDatesVC ()

@end

@implementation SelectDatesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 3.0f;
    
    self.arrDateTitles = [NSMutableArray arrayWithArray:@[@"InitPlanStartDt", @"UpdatedPlanStartDt", @"ActualStartDt", @"ActualEndDt"]];
    self.arrSelectedStatus = [NSMutableArray arrayWithArray:@[@"unselected", @"unselected", @"unselected", @"unselected"]];
    
    [AppData sharedInstance].arrSelectedDates = [[NSMutableArray alloc] init];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    [AppData sharedInstance].changedStatusDelegate = self;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDateTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatesCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    cell.lblTitle.text = self.arrDateTitles[row];
    
    if ([self.arrSelectedStatus[row] isEqualToString:@"unselected"]) {
        cell.lblDate.text = @"";
        [cell.lblTitle setTextColor:[UIColor lightGrayColor]];
    } else {
        cell.lblDate.text = self.arrSelectedStatus[row];
        
        [cell.lblTitle setTextColor:[UIColor whiteColor]];
        [cell.lblDate setTextColor:[UIColor whiteColor]];
    }
    
    return cell;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    UIView *viewDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [viewDatePicker setBackgroundColor:[UIColor clearColor]];
    
    // Make a frame for the picker & then create the picker
    CGRect pickerFrame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.hidden = NO;
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    [viewDatePicker addSubview:datePicker];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController.view addSubview:viewDatePicker];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     //Detect particular click by tag and do some thing here
                                     
                                     [self setSelectedDateInField:row];
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

-(void)setSelectedDateInField:(NSInteger)row
{
    NSLog(@"date :: %@",datePicker.date.description);
    
    
    //set Date formatter
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *strSelectedDate = [defaultFormatter stringFromDate:datePicker.date];
    [self.arrSelectedStatus replaceObjectAtIndex:row withObject:strSelectedDate];
    
    [self.tableView reloadData];
    
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
    
    NSString *strInitPlanStartDt = self.arrSelectedStatus[0];
    
    if ([strInitPlanStartDt isEqual:@"unselected"]) {
        [self showDefaultAlert:@"Error" withMessage:@"Please select InitPlanStartDt"];
        return;
    }
    
    for (int i = 0; i < self.arrSelectedStatus.count; i++)
    {
        if (![self.arrSelectedStatus[i] isEqual:@"unselected"]) {
            
            NSString *strTitle = self.arrDateTitles[i];
            NSString *strDate = self.arrSelectedStatus[i];
            NSDictionary *dic = @{@"key":strTitle, @"date":strDate};
            
            [[AppData sharedInstance].arrSelectedDates addObject:dic];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
