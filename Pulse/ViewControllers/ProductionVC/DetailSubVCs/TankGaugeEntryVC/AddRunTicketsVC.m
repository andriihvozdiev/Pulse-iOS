#import "AddRunTicketsVC.h"

#import "RunTicketsEditCell.h"
#import "RunTicketsCommentCell.h"
#import "RunTicketsImageCell.h"
#import "HapticHelper.h"

#import "ActionSheetStringPicker.h"
#import "ActionSheetMultipleStringPicker.h"

@interface AddRunTicketsVC ()
{
    BOOL isShownSubMenu;
    NSArray *arrTypes;
}
@end

@implementation AddRunTicketsVC
@synthesize arrTitles;
@synthesize arrContents;
@synthesize runTickets;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShownSubMenu = NO;
    nTicketOption = 0;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 5.0f;
    
    self.btnCommentSave.layer.cornerRadius = 3.0f;
    self.btnCommentCancel.layer.cornerRadius = 3.0f;
    self.txtComment.layer.cornerRadius = 5.0f;
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    [AppData sharedInstance].changedStatusDelegate = self;
    
    [self.viewComment setHidden:YES];
    
    [self initData];
    [self showSyncStatus];
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

-(void) initData
{
    arrTypes = @[@"Run Ticket", @"BSW Pull", @"Turn Down"];
    arrTitles = @[@"Ticket Time", @"Ticket Number", @"Lease", @"Tank Number", @"1st Gauge", @"1st Bottom", @"1st Temp", @"2nd Gauge", @"2nd Bottoms", @"2nd Temp", @"Obs Gravity", @"Obs Tempurature", @"S & W", @"Gross Volume, bbls", @"Net Volume, bbls", @"Time On", @"Time Off", @"Carrier", @"Driver", @"Ticket Image"];
    arrContents = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrTitles.count; i++) {
        [arrContents addObject:@""];
    }
    
    self.strComment = @"";
    self.ticketImage = nil;
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *currentTime = [defaultFormatter stringFromDate:[NSDate date]];
    [arrContents replaceObjectAtIndex:0 withObject:currentTime];
    
    [arrContents replaceObjectAtIndex:2 withObject:self.pulseProdHome.leaseName];
    
    NSString *strTankNumber = self.tank.rrc;
    [arrContents replaceObjectAtIndex:3 withObject:strTankNumber];
    
    
    // init data for feet/inches/quater-inches roller.
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
    
    if (self.isEdit) {
        [self setData];
    }
}

-(void) setData
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    [arrContents replaceObjectAtIndex:0 withObject:[df stringFromDate:runTickets.ticketTime]];
    [arrContents replaceObjectAtIndex:1 withObject:runTickets.ticketNumber == nil ? @"-" : runTickets.ticketNumber];
    
    float inches1 = runTickets.oilInch1 + runTickets.oilFraction1 * 0.25f;
    int gauge1 = (inches1 + runTickets.oilFeet1 * 12) * 4;
    [arrContents replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d", gauge1]];
    
    int bottom1 = (runTickets.bottomsInch1 + runTickets.bottomsFeet1 * 12) * 4;
    [arrContents replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%d", bottom1]];
    
    [arrContents replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%d", runTickets.temp1]];
    
    float inches2 = runTickets.oilInch2 + runTickets.oilFraction2 * 0.25f;
    int gauge2 = (inches2 + runTickets.oilFeet2 * 12) * 4;
    [arrContents replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%d", gauge2]];
   
    int bottom2 = (runTickets.bottomsInch2 + runTickets.bottomsFeet2 * 12) * 4;
    [arrContents replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%d", bottom2]];
    
    [arrContents replaceObjectAtIndex:9 withObject:[NSString stringWithFormat:@"%d", runTickets.temp2]];
    
    [arrContents replaceObjectAtIndex:10 withObject:runTickets.obsGrav == nil ? @"" : runTickets.obsGrav];
    [arrContents replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%d", runTickets.obsTemp]];
    [arrContents replaceObjectAtIndex:12 withObject:runTickets.bsw == nil ? @"" : runTickets.bsw];
    [arrContents replaceObjectAtIndex:13 withObject:runTickets.grossVol == nil ? @"" : runTickets.grossVol];
    [arrContents replaceObjectAtIndex:14 withObject:runTickets.netVol == nil ? @"" : runTickets.netVol];
    
    [arrContents replaceObjectAtIndex:15 withObject:runTickets.timeOn == nil ? @"" : [df stringFromDate:runTickets.timeOn]];
    		[arrContents replaceObjectAtIndex:16 withObject:runTickets.timeOff == nil ? @"" : [df stringFromDate:runTickets.timeOff]];
    
    [arrContents replaceObjectAtIndex:17 withObject:runTickets.carrier == nil ? @"" : runTickets.carrier];
    [arrContents replaceObjectAtIndex:18 withObject:runTickets.driver == nil ? @"" : runTickets.driver];
    
    nTicketOption = runTickets.ticketOption;
    [self.lblNavTitle setText:arrTypes[nTicketOption]];
    [self.tableView reloadData];
    self.strComment = runTickets.comments;
    
    if (runTickets.ticketImage) {
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:runTickets.ticketImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.ticketImage = [UIImage imageWithData:imageData];
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

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTitles.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RunTicketsEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:@"RunTicketsEditCell" forIndexPath:indexPath];
    
    
    NSInteger row = [indexPath row];
    
    [editCell.btnAutoEdit setTag:row];
    [editCell.btnAutoEdit setHidden:NO];
    if ((row == 1 && self.isEdit) || row == 2 || row == 3) {
        [editCell.btnAutoEdit setHidden:YES];
    }
    
    switch (row) {
        case 4: // 1st Gauge
        case 7: // 2nd Gauge
        {
            editCell.lblTitle.text = arrTitles[row];
            editCell.lblContent.text = @"";
            
            NSString *content = arrContents[row];
            if (![content isEqual:@""]) {
                int oilFeet = [content intValue];
                int feet = oilFeet / 4 / 12;
                int inches = floorf(oilFeet / 4.0f) - feet * 12;
                int quarter_inches = (oilFeet / 4.0f - feet * 12 - inches) / 0.25f;
                
                NSString *str = [NSString stringWithFormat:@"(%d' %d %d/4\")", feet, inches, quarter_inches];
                editCell.lblContent.text = str;

            }
        }
            break;
        case 5: // 1st Bottom
        case 8: // 2nd Bottom
        {
            editCell.lblTitle.text = arrTitles[row];
            editCell.lblContent.text = @"";
            
            NSString *content = arrContents[row];
            if (![content isEqual:@""]) {
                int oilFeet = [content intValue];
                int feet = oilFeet / 4 / 12;
                int inches = oilFeet / 4 - feet * 12;
                
                NSString *str = [NSString stringWithFormat:@"(%d' %d\")", feet, inches];
                editCell.lblContent.text = str;
            }
        }
            break;
        case 19: // comment cell
        {
            RunTicketsCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"RunTicketsCommentCell" forIndexPath:indexPath];
            
            commentCell.lblComments.text = [self.strComment isEqual:@""] ? @"Add a comment" : self.strComment;
            return commentCell;
        }
            break;
        case 20:
        {
            RunTicketsImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"RunTicketsImageCell" forIndexPath:indexPath];
            [imageCell.ticketImage.layer setCornerRadius:3.0f];
            imageCell.ticketImage.layer.borderWidth = 1.0f;
            imageCell.ticketImage.layer.borderColor = [UIColor whiteColor].CGColor;
            if (self.ticketImage) {
                imageCell.ticketImage.image = self.ticketImage;
                [imageCell.lblNoImage setHidden:YES];
            } else {
                [imageCell.lblNoImage setHidden:NO];
            }
            
            return imageCell;
        }
            break;
        default:
            editCell.lblTitle.text = arrTitles[row];
            editCell.lblContent.text = [NSString stringWithFormat:@"(%@)", arrContents[row]];
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
        case 0: // Ticket Time
            [self onDateTime:0];
            break;
        case 1: // Ticket Number
            if (!self.isEdit) {
                [self showInputStringAlert:1 withTitle:@"Ticket Number"];
            }
            break;
        case 2: // Lease
        case 3: // Tank Number
            break;
        case 4: // 1st Gauge
            [self showFeetInchesQuater:4];
            break;
        case 5: // 1st Bottom
            [self showFeetInches:5];
            break;
        case 6: // 1st Temp
            [self showInputNumberAlert:6 withTitle:@"1st Temp"];
            break;
        case 7: // 2nd Gauge
            [self showFeetInchesQuater:7];
            break;
        case 8: // 2nd Bottoms
            [self showFeetInches:8];
            break;
        case 9: // 2nd Temp
            [self showInputNumberAlert:9 withTitle:@"1st Temp"];
            break;
        case 10: // Obs Gravity
            [self showInputNumberAlert:10 withTitle:@"Obs Gravity"];
            break;
        case 11: // Obs Tempurature
            [self showInputNumberAlert:11 withTitle:@"Obs Tempurature"];
            break;
        case 12: // S & W
            [self showInputNumberAlert:12 withTitle:@"S & W"];
            break;
        case 13: // Gross Volume
            [self showInputNumberAlert:13 withTitle:@"Gross Volume, bbls"];
            break;
        case 14: // Net Volume
            [self showInputNumberAlert:14 withTitle:@"Net Volume, bbls"];
            break;
        case 15: // Time On
        case 16: // Time Off
            [self onDateTime:row];
            break;
        case 17: // Carrier
            [self showInputStringAlert:17 withTitle:@"Carrier"];
            break;
        case 18: // Driver
            [self showInputStringAlert:18 withTitle:@"Driver"];
            break;
        case 19: // Comments
            self.txtComment.text = self.strComment;
            [self.viewComment setHidden:NO];
            [self.txtComment becomeFirstResponder];
            break;
        case 20:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select a Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Take a Photo");
                [self takePhoto];
                
            }];
            [alert addAction:cameraAction];
            
            UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Get From Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Get from a photo library");
                [self selectPhoto];
            }];
            [alert addAction:galleryAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                           }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"No Camera Abailable." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
//    picker.allowsEditing  = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - imagePicker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.ticketImage = [self imageWithImage:chosenImage scaledToWidth:800];
    
    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

-(bool) isNumeric:(NSString*) checkText{
    NSScanner *sc = [NSScanner scannerWithString: checkText];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}

-(void) showFeetInches:(NSInteger)selectedIndex
{
    ActionSheetMultipleStringPicker *stringPicker = [ActionSheetMultipleStringPicker showPickerWithTitle:@"Feet & Inches" rows:@[self.arrFeets, self.arrInches] initialSelection:@[@5, @5] doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
        
        int feet = [selectedIndexes[0] intValue];
        int inches = [selectedIndexes[1] intValue];
        
        int oilFeet = (inches + feet * 12) * 4;
        NSString *strOilFeet = [NSString stringWithFormat:@"%d", oilFeet];
        
        [arrContents replaceObjectAtIndex:selectedIndex withObject:strOilFeet];
        
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        
    } origin:self.view];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) showFeetInchesQuater:(NSInteger)selectedIndex
{
    ActionSheetMultipleStringPicker *stringPicker = [ActionSheetMultipleStringPicker showPickerWithTitle:@"Feet, Inches & Quater-Inch" rows:@[self.arrFeets, self.arrInches, self.arrQuarterInches] initialSelection:@[@5, @5, @2] doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
        
        int feet = [selectedIndexes[0] intValue];
        float inches = [selectedIndexes[1] intValue] + [selectedIndexes[2] intValue] * 0.25f;
        
        int oilFeet = (inches + feet * 12) * 4;
        NSString *strOilFeet = [NSString stringWithFormat:@"%d", oilFeet];
        
        [arrContents replaceObjectAtIndex:selectedIndex withObject:strOilFeet];
        
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        
    } origin:self.view];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
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

- (IBAction)onTitle:(id)sender {
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Type" rows:arrTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        self.lblNavTitle.text = arrTypes[selectedIndex];
        nTicketOption = (int)selectedIndex;
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];    
}

- (IBAction)onSave:(id)sender {
    
    if (nTicketOption == 2) {
        if ([arrContents[0] isEqualToString:@""]) {
            NSString *strMessage = [NSString stringWithFormat:@"Input %@", arrTitles[0]];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing some fields" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        } else if ([self.strComment isEqualToString:@""]) {
            NSString *strMessage = @"Input Comments";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing some fields" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        } else if ([arrContents[1] isEqualToString:@""]) {
            NSString *strMessage = [NSString stringWithFormat:@"Input %@", arrTitles[1]];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing some fields" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
    } else {
        for (int i = 0; i < arrContents.count; i++) {
            if (i == 13 || i == 14 || i >= 17) {
                continue;
            }
            if ([arrContents[i] isEqual:@""]) {
                NSString *strMessage = [NSString stringWithFormat:@"Input %@", arrTitles[i]];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing some fields" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
            }
        }
    }
    NSString *lease = self.tank.lease;
    NSString *tankID = [NSString stringWithFormat:@"%d", self.tank.tankID];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSString *deviceID = [NSString stringWithFormat:@"%05d", [userid intValue]];
    
    NSString *ticketTime = arrContents[0];
    NSString *ticketNumber = arrContents[1];
    NSString *gauge1 = arrContents[4];
    NSString *bottom1 = arrContents[5];
    NSString *temp1 = arrContents[6];
    NSString *gauge2 = arrContents[7];
    NSString *bottom2 = arrContents[8];
    NSString *temp2 = arrContents[9];
    NSString *obsGravity = arrContents[10];
    NSString *obsTemp = arrContents[11];
    NSString *bsw = arrContents[12];
    NSString *grossVol = [arrContents[13] isEqual:@""] ? nil : arrContents[13];
    NSString *netVol = [arrContents[14] isEqual:@""] ? nil : arrContents[14];
    NSString *timeOn = arrContents[15];
    NSString *timeOff = arrContents[16];
    NSString *carrier = [arrContents[17] isEqual:@""] ? nil : arrContents[17];
    NSString *driver = [arrContents[18] isEqual:@""] ? nil : arrContents[18];
    NSString *strTicketOption = [NSString stringWithFormat:@"%d", nTicketOption];
    
    NSString *imageString = nil;
    if (self.ticketImage) {
        NSData *imageData = UIImageJPEGRepresentation(self.ticketImage, 0.9f);
        imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSLog(@"%d", (int)[imageString length]);
    }
    

    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    
    
    [dicParam setValue:[NSNumber numberWithInt:runTickets.internalTicketID] forKey:@"internalTicketID"];
    
    [dicParam setValue:userid forKey:@"userid"];
    [dicParam setValue:deviceID forKey:@"deviceID"];
    [dicParam setValue:lease forKey:@"lease"];
    [dicParam setValue:tankID forKey:@"tankID"];
    [dicParam setValue:self.strComment forKey:@"comments"];
    
    [dicParam setValue:ticketTime forKey:@"ticketTime"];
    [dicParam setValue:ticketNumber forKey:@"ticketNumber"];
    [dicParam setValue:gauge1 forKey:@"gauge1"];
    [dicParam setValue:bottom1 forKey:@"bottom1"];
    [dicParam setValue:temp1 forKey:@"temp1"];
    [dicParam setValue:gauge2 forKey:@"gauge2"];
    [dicParam setValue:bottom2 forKey:@"bottom2"];
    [dicParam setValue:temp2 forKey:@"temp2"];
    [dicParam setValue:obsGravity forKey:@"obsGrav"];
    [dicParam setValue:obsTemp forKey:@"obsTemp"];
    [dicParam setValue:bsw forKey:@"bsw"];
    [dicParam setValue:grossVol forKey:@"grossVol"] ;
    [dicParam setValue:netVol forKey:@"netVol"];
    [dicParam setValue:timeOn forKey:@"timeOn"];
    [dicParam setValue:timeOff forKey:@"timeOff"];
    [dicParam setValue:carrier forKey:@"carrier"];
    [dicParam setValue:driver forKey:@"driver"];
    [dicParam setValue:strTicketOption forKey:@"ticketOption"];
    [dicParam setValue:imageString forKey:@"ticketImage"];
    
    if ([[DBManager sharedInstance] addRunTicket:dicParam])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Added New Run Ticket Successfully." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Added a New RunTicket Failed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (IBAction)onAutoEdit:(id)sender {
    
    if (!runTickets || self.isEdit) {
        return;
    }
    
    UIButton *btnAutoEdit = (UIButton*)sender;
    NSInteger row = btnAutoEdit.tag;
    
    switch (row) {
        case 0:
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            NSString *strDateTime = [df stringFromDate:runTickets.ticketTime];
            [arrContents replaceObjectAtIndex:row withObject:strDateTime];
            break;
        }
        case 1:
            if (runTickets.ticketNumber) {
                [arrContents replaceObjectAtIndex:row withObject:runTickets.ticketNumber];
            }
            break;
        case 4:
        {
            int feet = runTickets.oilFeet1;
            int inches = runTickets.oilInch1;
            int fraction = runTickets.oilFraction1;
            int gauge1 = feet * 48 + inches * 4 + fraction;
            [arrContents replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d", gauge1]];
            
            break;
        }
        case 5:
        {
            int feet = runTickets.bottomsFeet1;
            int inches = runTickets.bottomsInch1;
            int bottom1 = inches * 4 + feet * 48;
            
            [arrContents replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d", bottom1]];
            break;
        }
        case 6:
            if (runTickets.temp1) {
                [arrContents replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d", runTickets.temp1]];
            }
            break;
        case 7:
        {
            int feet = runTickets.oilFeet1;
            int inches = runTickets.oilInch1;
            int fraction = runTickets.oilFraction1;
            int gauge2 = feet * 48 + inches * 4 + fraction;
            [arrContents replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d", gauge2]];
            
            break;
        }
        case 8:
        {
            int feet = runTickets.bottomsFeet1;
            int inches = runTickets.bottomsInch1;
            int bottom2 = inches * 4 + feet * 48;
            
            [arrContents replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d", bottom2]];
            break;
        }
            break;
        case 9:
            if (runTickets.temp2) {
                [arrContents replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d", runTickets.temp2]];
            }
            break;
        case 10:
            if (runTickets.obsGrav) {
                [arrContents replaceObjectAtIndex:row withObject:runTickets.obsGrav];
            }
            break;
        case 11:
            if (runTickets.obsTemp) {
                [arrContents replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d", runTickets.obsTemp]];
            }
            break;
        case 12:
            if (runTickets.bsw) {
                [arrContents replaceObjectAtIndex:row withObject:runTickets.bsw];
            }
            break;
        case 13:
            if (runTickets.grossVol) {
                [arrContents replaceObjectAtIndex:row withObject:runTickets.grossVol];
            }
            break;
        case 14:
            if (runTickets.netVol) {
                [arrContents replaceObjectAtIndex:row withObject:runTickets.netVol];
            }
            break;
        case 15:
            if (runTickets.timeOn) {
                NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
                [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
                
                [arrContents replaceObjectAtIndex:row withObject:[defaultFormatter stringFromDate:runTickets.timeOn]];
            }
            break;
        case 16:
            if (runTickets.timeOff) {
                NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
                [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
                [arrContents replaceObjectAtIndex:row withObject:[defaultFormatter stringFromDate:runTickets.timeOff]];
            }
            break;
        case 17:
            if (runTickets.carrier) {
                [arrContents replaceObjectAtIndex:row withObject:runTickets.carrier];
            }
            break;
        case 18:
            if (runTickets.driver) {
                [arrContents replaceObjectAtIndex:row withObject:runTickets.driver];
            }
        default:
            break;
    }
    
    [self.tableView reloadData];
    
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

#pragma mark -
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
