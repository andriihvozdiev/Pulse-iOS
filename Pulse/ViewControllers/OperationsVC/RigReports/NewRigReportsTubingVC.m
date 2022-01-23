#import "NewRigReportsTubingVC.h"
#import "NewRigReportsTubingCell.h"
#import "ActionSheetStringPicker.h"

@interface NewRigReportsTubingVC ()
{
    NSArray *arrFields;
    NSMutableArray *arrValues;
    NSArray *arrTubingSize;
    NSArray *arrTubingType;
    NSArray *arrTubingLength;
}
@end

@implementation NewRigReportsTubingVC
@synthesize isOut;
@synthesize rigReports;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (isOut) {
        self.lblNavTitle.text = @"New Tubing - Out";
    } else {
        self.lblNavTitle.text = @"New Tubing - In";
    }
    
    arrFields = @[@"Tubing Size", @"Tubing Type", @"Tubing Length", @"Tubing Count", @"Tubing Footage"];
    arrValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrFields.count; i++)
         [arrValues addObject:@""];
    
    arrTubingSize = [[DBManager sharedInstance] getTubingSize];
    arrTubingType = [[DBManager sharedInstance] getTubingType];
    arrTubingLength = [[DBManager sharedInstance] getTubingLength];
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 5.0f;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
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

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFields.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewRigReportsTubingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewRigReportsTubingCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    cell.lblTitle.text = arrFields[row];
    cell.lblValue.text = [NSString stringWithFormat:@"(%@)", arrValues[row]];
    
    return cell;
}

#pragma mark - tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    switch (row) {
        case 0: // Size
            [self onSize];
            break;
        case 1: // Type
            [self onType];
            break;
        case 2: // Length
            [self onLength];
            break;
        case 3: // Count
            [self showInputNumberAlert:3 withTitle:@"Tubing Count" isDecimal:NO];
            break;
        case 4: // Footage
            [self showInputNumberAlert:4 withTitle:@"Tubing Footage" isDecimal:YES];
            break;
        default:
            break;
    }
}

-(void) onSize
{
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Tubing Size" rows:arrTubingSize initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrValues replaceObjectAtIndex:0 withObject:arrTubingSize[selectedIndex]];
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) onType
{
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Tubing Size" rows:arrTubingType initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrValues replaceObjectAtIndex:1 withObject:arrTubingType[selectedIndex]];
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) onLength
{
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Tubing Size" rows:arrTubingLength initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrValues replaceObjectAtIndex:2 withObject:arrTubingLength[selectedIndex]];
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}


-(void) showInputNumberAlert:(NSInteger)selectedIndex withTitle:(NSString*)strTitle isDecimal:(BOOL)isDecimal
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:strTitle
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"0", @"Values");
         textField.keyboardType = UIKeyboardTypeNumberPad;
         
         if (isDecimal) {
             textField.placeholder = NSLocalizedString(@"0.0", @"Values");
             textField.keyboardType = UIKeyboardTypeDecimalPad;
         }
         
     }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = alertController.textFields.firstObject;
        
        if ([self isNumeric:textfield.text]) {
            [arrValues replaceObjectAtIndex:selectedIndex withObject:textfield.text];
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


#pragma mark - button events

- (IBAction)onStoplight:(id)sender {
    [[AppData sharedInstance] mannualSync];
}

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
    for (int i = 0; i < arrValues.count ; i++) {
        if ([arrValues[i] isEqual:@""]) {
            NSString *strMessage = [NSString stringWithFormat:@"Input %@", arrFields[i]];
            [self showDefaultAlert:@"Missing Data" withMessage:strMessage];
            return;
        }
    }
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    [dicData setValue:arrValues[0] forKey:@"tubingSize"];
    [dicData setValue:arrValues[1] forKey:@"tubingType"];
    [dicData setValue:arrValues[2] forKey:@"tubingLength"];
    [dicData setValue:arrValues[3] forKey:@"tubingCount"];
    [dicData setValue:arrValues[4] forKey:@"tubingFootage"];
    [dicData setValue:rigReports.reportAppID forKey:@"reportAppID"];
    
    if ([[DBManager sharedInstance] addRigReportsTubing:dicData inOut:isOut]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Added New RigReportsTubing" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self showDefaultAlert:nil withMessage:@"Failed Adding a new RigReportsTubing"];
    }
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
