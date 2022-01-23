#import "ScheduleCommentVC.h"
#import "ScheduleCommentCell.h"
#import "HapticHelper.h"

@interface ScheduleCommentVC ()
{
    NSString *strDepartment;
}
@end

@implementation ScheduleCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 3.0f;
    
    strDepartment = [[NSUserDefaults standardUserDefaults] valueForKey:S_Department];
    [[AppData sharedInstance].arrScheduleComments removeAllObjects];
    
    if ([strDepartment isEqual:@"Production"])
    {
        NSDictionary *dic = @{@"key": @"FieldComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dic];
    }
    else if ([strDepartment isEqual:@"Accounting"])
    {
        NSDictionary *dic = @{@"key": @"AcctComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dic];
    }
    else if ([strDepartment isEqual:@"Engineering"])
    {
        NSDictionary *dic = @{@"key": @"EngrComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dic];
    }
    else if ([strDepartment isEqual:@"Operations"])
    {
        NSDictionary *dicfield = @{@"key": @"FieldComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dicfield];
        
        NSDictionary *dicEngr = @{@"key": @"EngrComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dicEngr];
    }
    else if ([strDepartment isEqual:@"Executive"])
    {
        NSDictionary *dicField = @{@"key": @"FieldComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dicField];
        
        NSDictionary *dicAcct = @{@"key": @"AcctComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dicAcct];
        
        NSDictionary *dicEngr = @{@"key": @"EngrComments", @"comment": @""};
        [[AppData sharedInstance].arrScheduleComments addObject:dicEngr];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShown:) name:UIKeyboardDidShowNotification object:nil];
    
    
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


#pragma mark -button events
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
    [[AppData sharedInstance].arrScheduleComments removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
    
    self.bottomConstraint.constant = 20.0f;
    [self.view layoutIfNeeded];
    
    NSInteger count = [AppData sharedInstance].arrScheduleComments.count;
    [[AppData sharedInstance].arrScheduleComments removeAllObjects];
    for (NSInteger i = 0; i < count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ScheduleCommentCell *cell = (ScheduleCommentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *strKey = cell.lblCommentTitle.text;
        NSString *strComment = cell.txtComment.text;
        if (![strComment isEqual:@""]) {
            NSDictionary *dic = @{@"key":strKey, @"comment":strComment};
            [[AppData sharedInstance].arrScheduleComments addObject:dic];
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)keyShown:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float keyboardHeight = keyboardFrameBeginRect.size.height;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.bottomConstraint.constant = keyboardHeight;
        [self.view layoutIfNeeded];
    }];
    
}


#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [AppData sharedInstance].arrScheduleComments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCommentCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    NSDictionary *dic = [AppData sharedInstance].arrScheduleComments[row];
    
    cell.lblCommentTitle.text = [dic valueForKey:@"key"];
    
    return cell;
}



@end
