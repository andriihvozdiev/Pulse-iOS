#import "SelectPeopleVC.h"
#import "PeopleCell.h"
#import "HapticHelper.h"

@interface SelectPeopleVC ()

@end

@implementation SelectPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 3.0f;
    
    [[AppData sharedInstance].arrSelectedPeople removeAllObjects];
    self.arrSelectedStatus = [[NSMutableArray alloc] init];
    
    [AppData sharedInstance].arrPeople = [[DBManager sharedInstance] getPersonnels];
    for (int i = 0; i < [AppData sharedInstance].arrPeople.count; i++) {
        [self.arrSelectedStatus addObject:@"unselected"];
    }
    
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
    return [AppData sharedInstance].arrPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    Personnel *personnel = [AppData sharedInstance].arrPeople[row];
    
    cell.lblTitle.text = personnel.employeeName;
    
    if ([self.arrSelectedStatus[row] isEqualToString:@"unselected"]) {
        [cell.lblTitle setTextColor:[UIColor lightGrayColor]];
    } else {
        [cell.lblTitle setTextColor:[UIColor whiteColor]];
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
    
    if ([self.arrSelectedStatus[row] isEqualToString:@"unselected"]) {
        [self.arrSelectedStatus replaceObjectAtIndex:row withObject:@"selected"];
    } else {
        [self.arrSelectedStatus replaceObjectAtIndex:row withObject:@"unselected"];
    }
    [tableView reloadData];
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
    for (int i = 0; i < self.arrSelectedStatus.count; i++) {
        if ([self.arrSelectedStatus[i] isEqualToString:@"selected"]) {
            [[AppData sharedInstance].arrSelectedPeople addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
