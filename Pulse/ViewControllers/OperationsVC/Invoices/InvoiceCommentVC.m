#import "InvoiceCommentVC.h"
#import "HapticHelper.h"


@interface InvoiceCommentVC ()

@end

@implementation InvoiceCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 3.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShown:) name:UIKeyboardDidShowNotification object:nil];
 
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    [AppData sharedInstance].changedStatusDelegate = self;
    
    switch (self.commentType) {
        case NONE:
            self.textView.text = [AppData sharedInstance].strComment;
            break;
        case TUBING:
            self.textView.text = [AppData sharedInstance].strTubingComment;
            break;
        case ROD:
            self.textView.text = [AppData sharedInstance].strRodComment;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showSyncStatus];
    
    switch (self.commentType) {
        case NONE:
            self.lblTitle.text = @"Comment";
            break;
        case TUBING:
            self.lblTitle.text = @"Tubing Comment";
            break;
        case ROD:
            self.lblTitle.text = @"Rod Comment";
            break;
        default:
            self.lblTitle.text = @"Comment";
            break;
    }
    
    [self.textView becomeFirstResponder];
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

- (IBAction)onTap:(id)sender {
    [self.textView resignFirstResponder];
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
    switch (self.commentType) {
        case NONE:
            [AppData sharedInstance].strComment = self.textView.text;
            break;
        case TUBING:
            [AppData sharedInstance].strTubingComment = self.textView.text;
            break;
        case ROD:
            [AppData sharedInstance].strRodComment = self.textView.text;
            break;
        default:
            break;
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


@end
