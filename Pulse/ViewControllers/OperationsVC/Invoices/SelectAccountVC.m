#import "SelectAccountVC.h"
#import "AccountCell.h"
#import "HapticHelper.h"

@interface SelectAccountVC ()

@end

@implementation SelectAccountVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 3.0f;
    
    [[AppData sharedInstance].arrSelectedAccounts removeAllObjects];
    [[AppData sharedInstance].arrSelectedAccountTimes removeAllObjects];
    
    self.arrSelectedStatus = [[NSMutableArray alloc] init];
    self.arrSelectedUnits = [[NSMutableArray alloc] init];
    
    [AppData sharedInstance].arrSelectedAccounts = [[NSMutableArray alloc] init];
    [AppData sharedInstance].arrSelectedAccountTimes = [[NSMutableArray alloc] init];
    [AppData sharedInstance].arrSelectedAccountTimeUnits = [[NSMutableArray alloc] init];
    
    [AppData sharedInstance].arrAccounts = [[DBManager sharedInstance] getAllAccounts];
    for (int i = 0; i < [AppData sharedInstance].arrAccounts.count; i++) {
        [self.arrSelectedStatus addObject:@"unselected"];
        [self.arrSelectedUnits addObject:@"Hr(s)"];
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
    return [AppData sharedInstance].arrAccounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[row];
    
    NSString *strAccout = accountData.account;
    
    
    cell.lblTitle.text = accountData.subAccount == nil ? accountData.account : [NSString stringWithFormat:@"%@ - %@", strAccout, accountData.subAccount];
                                                                                
    NSString *strTimeUnits = accountData.subAcctTimeUnits;
    cell.lblDescription.text = strTimeUnits;
    
    if ([self.arrSelectedStatus[row] isEqualToString:@"unselected"]) {
        [cell.lblTitle setTextColor:[UIColor lightGrayColor]];
        [cell.lblDescription setTextColor:[UIColor lightGrayColor]];
    } else {
        [cell.lblTitle setTextColor:[UIColor whiteColor]];
        [cell.lblDescription setTextColor:[UIColor whiteColor]];
        
        NSString *strAccountTime = self.arrSelectedStatus[row];
        [cell.lblDescription setText:[NSString stringWithFormat:@"%@ %@", strAccountTime, strTimeUnits]];
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
    InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[row];
    
    if ([self.arrSelectedStatus[row] isEqualToString:@"unselected"]) {
                
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Select an Account"
                                              message:@"Please enter AccountTime"
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = NSLocalizedString(@"0.0", @"AccountTime");
             textField.keyboardType = UIKeyboardTypeDecimalPad;
         }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *txtAccountTime = alertController.textFields.firstObject;
            
            if ([self isNumeric:txtAccountTime.text]) {
                [self.arrSelectedStatus replaceObjectAtIndex:row withObject:txtAccountTime.text];
                [self.arrSelectedUnits replaceObjectAtIndex:row withObject:accountData.subAcctTimeUnits];
            } else {
                [self showDefaultAlert:@"Wrong Value" withMessage:@"Please input numerical value"];
            }
            
            [tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        [self.arrSelectedStatus replaceObjectAtIndex:row withObject:@"unselected"];
        [tableView reloadData];
    }
    
}


-(bool) isNumeric:(NSString*) checkText{
    NSScanner *sc = [NSScanner scannerWithString: checkText];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
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
        if (![self.arrSelectedStatus[i] isEqualToString:@"unselected"]) {
            [[AppData sharedInstance].arrSelectedAccounts addObject:[NSNumber numberWithInt:i]];
            [[AppData sharedInstance].arrSelectedAccountTimes addObject:self.arrSelectedStatus[i]];
            [[AppData sharedInstance].arrSelectedAccountTimeUnits addObject:self.arrSelectedUnits[i]];
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
