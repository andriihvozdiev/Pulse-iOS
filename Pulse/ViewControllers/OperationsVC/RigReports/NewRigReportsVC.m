#import "NewRigReportsVC.h"
#import "NewRigReportsCell.h"
#import "NewRigReportsCommentCell.h"
#import "NewRigReportsImageTableViewCell.h"
#import "ActionSheetStringPicker.h"
#import "HapticHelper.h"


@interface NewRigReportsVC ()
{
    UIDatePicker *datePicker;
    NSMutableArray *arrWellNumber;
    UIImage *imgRig;
    BOOL isShowingImageContentCell;
    NSMutableArray *arySelectedImages;
    NSMutableDictionary *dicLastComments;
    NSMutableArray *aryRigsForComments;
    NSString *strCommentsKey;
}
@end

@implementation NewRigReportsVC
@synthesize arrFields;
@synthesize arrValues;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    isShowingImageContentCell = NO;
    imgRig = nil;
    [[AppData sharedInstance] getLeases];
    arrWellNumber = [[NSMutableArray alloc] init];
    arySelectedImages = [[NSMutableArray alloc] init];
    aryRigsForComments = [[NSMutableArray alloc] init];
    arrFields = @[@"Lease", @"Well Number", @"Company", @"Daily Cost", @"Total Cost", @"Date", @"Time", @"Comment", @"Tubing Comment", @"Rods Comment"];
    arrValues = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrFields.count; i++) {
        [arrValues addObject:@""];
    }
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy"];
    [arrValues replaceObjectAtIndex:5 withObject:[defaultFormatter stringFromDate:[NSDate date]]];
    
    [defaultFormatter setDateFormat:@"HH:mm:ss"];
    [arrValues replaceObjectAtIndex:6 withObject:[defaultFormatter stringFromDate:[NSDate date]]];
    
    
    self.btnSave.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    self.btnSave.layer.cornerRadius = 5.0f;
    
    self.btnCommentSave.layer.cornerRadius = 3.0f;
    self.btnCommentCancel.layer.cornerRadius = 3.0f;
    self.txtComment.layer.cornerRadius = 5.0f;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
    [self.viewComment setHidden:YES];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    [AppData sharedInstance].changedStatusDelegate = self;
    self.viewContainerComments.layer.cornerRadius = 4;
}

-(void)viewWillAppear:(BOOL)animated
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

- (IBAction)onShowCommentsList:(UIButton *)sender {
    NSString *txtkey = @"comments";
    switch (sender.tag) {
        case 7:
            txtkey = @"comments";
            break;
        case 8:
            txtkey = @"tubing";
            break;
        case 9:
            txtkey = @"rods";
            break;
        default:
            break;
    }
    strCommentsKey = txtkey;
    aryRigsForComments = dicLastComments[txtkey];
    [self.tblComments reloadData];
    [self showCommentsListView:YES];
}

- (IBAction)onAutoFillComment:(UIButton *)sender {
    
    RigReports *rig;
    NSArray *aryRigs;
    switch (sender.tag) {
        case 7:
            aryRigs = [dicLastComments objectForKey:@"comments"];
            if (aryRigs.count > 0) {
                rig = aryRigs[0];
                arrValues[7] = rig.comments;
            }
            break;
            
        case 8:
            aryRigs = [dicLastComments objectForKey:@"tubing"];
            if (aryRigs.count > 0) {
                rig = aryRigs[0];
                arrValues[8] = rig.tubing;
            }
            break;
            
        case 9:
            aryRigs = [dicLastComments objectForKey:@"rods"];
            if (aryRigs.count > 0) {
                rig = aryRigs[0];
                arrValues[9] = rig.rods;
            }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - ChangedStatusDelegate
-(void)changedSyncStatus
{
    [self showSyncStatus];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return aryRigsForComments.count;
    } else {
        return arrFields.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsListCell"];
        UILabel *lblDate = [cell viewWithTag:111];
        UITextView *txtComments = [cell viewWithTag:222];
        txtComments.tintColor = [UIColor whiteColor];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy"];
        RigReports *rig = aryRigsForComments[indexPath.row];
        if ([strCommentsKey isEqualToString:@"comments"]) {
            [txtComments setText: rig.comments];
            [lblDate setText:[df stringFromDate:rig.reportDate]];
        } else if ([strCommentsKey isEqualToString:@"rods"]) {
            [txtComments setText: rig.rods];
            [lblDate setText:[df stringFromDate:rig.reportDate]];
        } else if ([strCommentsKey isEqualToString:@"tubing"]) {
            [txtComments setText: rig.tubing];
            [lblDate setText:[df stringFromDate:rig.reportDate]];
        }
        return cell;
    } else {
        NewRigReportsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewRigReportsCell" forIndexPath:indexPath];
        
        NSInteger row = [indexPath row];
        
        switch (row) {
            case 0: // Lease
            {
                cell.lblTitle.text = arrFields[row];
                NSString *strLeaseName = [arrValues[0] isEqual:@""] ? @"" : [[DBManager sharedInstance] getLeaseNameFromLease:arrValues[0]];
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", strLeaseName];
                return cell;
            }
                break;
            case 1: // Well Number
                cell.lblTitle.text = arrFields[row];
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", arrValues[1]];
                return cell;
                break;
            case 2: // Company
            {
                cell.lblTitle.text = arrFields[row];
                NSString *strCompany = [arrValues[2] isEqual:@""] ? @"" : arrValues[2];
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", strCompany];
                return cell;
            }
                break;
            case 3: // Daily Cost
            {
                cell.lblTitle.text = arrFields[row];
                NSString *strCompany = [arrValues[3] isEqual:@""] ? @"" : arrValues[3];
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", strCompany];
                return cell;
            }
                break;
            case 4: // Total Cost
            {
                cell.lblTitle.text = arrFields[row];
                NSString *strCompany = [arrValues[4] isEqual:@""] ? @"" : arrValues[4];
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", strCompany];
                return cell;
            }
                break;
            case 5: // Date
                cell.lblTitle.text = arrFields[row];
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", arrValues[5]];
                return cell;
                break;
            case 6: // Time
                cell.lblTitle.text = arrFields[row];
                cell.lblContent.text = [NSString stringWithFormat:@"(%@)", arrValues[6]];
                return cell;
                break;
            case 7: // Commment
            {
                NewRigReportsCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"NewRigReportsCommentCell" forIndexPath:indexPath];
                commentCell.btnAutoFill.tag = 7;
                commentCell.btnCommentsList.tag = 7;
                commentCell.lblTitle.text = @"Comment";
                NSString *strComment = arrValues[7];
                if (strComment && ![strComment isEqual:@""])
                {
                    commentCell.lblComments.text = strComment;
                } else {
                    commentCell.lblComments.text = @"Add Comments";
                }
                NSArray *aryRigs = (NSArray *)[dicLastComments objectForKey:@"comments"];
                if (aryRigs.count > 0 && ((RigReports *)aryRigs[0]).comments != nil && ![((RigReports *)aryRigs[0]).comments isEqualToString:@""]) {
                    
                    [commentCell.btnAutoFill setHidden:NO];
                    [commentCell.btnCommentsList setHidden:NO];
                } else {
                    [commentCell.btnAutoFill setHidden:YES];
                    [commentCell.btnCommentsList setHidden:YES];
                }
                return commentCell;
            }
                break;
            case 8: // Tubing Commment
            {
                NewRigReportsCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"NewRigReportsCommentCell" forIndexPath:indexPath];
                commentCell.btnAutoFill.tag = 8;
                commentCell.btnCommentsList.tag = 8;
                commentCell.lblTitle.text = @"Tubing Comment";
                NSString *strComment = arrValues[8];
                if (strComment && ![strComment isEqual:@""])
                {
                    commentCell.lblComments.text = strComment;
                } else {
                    commentCell.lblComments.text = @"Add Comments";
                }
                NSArray *aryRigs = (NSArray *)[dicLastComments objectForKey:@"tubing"];
                if (aryRigs.count > 0 && ((RigReports *)aryRigs[0]).tubing != nil && ![((RigReports *)aryRigs[0]).tubing isEqualToString:@""]) {
                    [commentCell.btnAutoFill setHidden:NO];
                    [commentCell.btnCommentsList setHidden:NO];
                } else {
                    [commentCell.btnAutoFill setHidden:YES];
                    [commentCell.btnCommentsList setHidden:YES];
                }
                
                return commentCell;
            }
                break;
            case 9: // Rod Commment
            {
                NewRigReportsCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"NewRigReportsCommentCell" forIndexPath:indexPath];
                commentCell.btnAutoFill.tag = 9;
                commentCell.btnCommentsList.tag = 9;
                commentCell.lblTitle.text = @"Rods Comment";
                NSString *strComment = arrValues[9];
                if (strComment && ![strComment isEqual:@""])
                {
                    commentCell.lblComments.text = strComment;
                } else {
                    commentCell.lblComments.text = @"Add Comments";
                }
                NSArray *aryRigs = (NSArray *)[dicLastComments objectForKey:@"rods"];
                if (aryRigs.count > 0 && ((RigReports *)aryRigs[0]).rods != nil && ![((RigReports *)aryRigs[0]).rods isEqualToString:@""]) {
                    [commentCell.btnAutoFill setHidden:NO];
                    [commentCell.btnCommentsList setHidden:NO];
                } else {
                    [commentCell.btnAutoFill setHidden:YES];
                    [commentCell.btnCommentsList setHidden:YES];
                }
                
                return commentCell;
            }
                break;
                
            case 10:
            {
                NewRigReportsImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewRigReportsImageTableViewCell" forIndexPath:indexPath];
                cell.delegate = self;
                cell.aryImages = arySelectedImages;
                [cell.collectionView reloadData];
                return cell;
            }
                break;
            default:
                break;
        }
    }
    
    
    return nil;
}

- (IBAction)onSelectImage:(id)sender {
    [self actForSelectPhot];
}

-(void)actForSelectPhot {
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

-(void) showCommentsListView:(BOOL)isShow {
    if (isShow) {
        [self.viewCommentsList setAlpha:0.0f];
        [self.viewCommentsList setHidden:NO];
        [UIView animateWithDuration:0.2f animations:^{
            [self.viewCommentsList setAlpha:1.0f];
        }];
        
    } else {
        [self.viewCommentsList setAlpha:1.0f];
        [UIView animateWithDuration:0.2f animations:^{
            [self.viewCommentsList setAlpha:0.0f];
//            [self.viewCommentsList setHidden:YES];
        }];
        
    }
}

#pragma mark - imagePicker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    imgRig = [self imageWithImage:chosenImage scaledToWidth:800];
    [arySelectedImages addObject:imgRig];
    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
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



#pragma mark - tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        if ([strCommentsKey isEqualToString:@"comments"]) {
            arrValues[7] = ((RigReports*)dicLastComments[@"comments"][indexPath.row]).comments;
        } else if ([strCommentsKey isEqualToString:@"rods"]) {
            arrValues[9] = ((RigReports*)dicLastComments[@"rods"][indexPath.row]).rods;
        } else if ([strCommentsKey isEqualToString:@"tubing"]) {
            arrValues[8] = ((RigReports*)dicLastComments[@"tubing"][indexPath.row]).tubing;
        }
        [self.tableView reloadData];
        [self showCommentsListView:NO];
    } else {
        NSInteger row = [indexPath row];
        switch (row) {
            case 0: // Lease
                [self onLease];
                break;
            case 1: // Well Number
                [self onWellNumber];
                break;
            case 2: // Company
                [self onCompany];
                break;
            case 3: // Daily Cost
                [self onDailyCost];
                break;
            case 4: // Total Cost
                [self onTotalCost];
                break;
            case 5: // Date
                [self onDate];
                break;
            case 6: // Time
                [self onTime];
                break;
            case 7: // Comment
                self.commentType = NONE;
                self.lblCommentTitle.text = @"Comment";
                if (arrValues[7] && ![arrValues[7] isEqualToString:@""]) {
                    [self.txtComment setText:arrValues[7]];
                } else {
                    [self.txtComment setText:@""];
                }
                [self.viewComment setHidden:NO];
                [self.txtComment becomeFirstResponder];
                break;
            case 8: // Tubing Comment
                self.commentType = Tubing;
                self.lblCommentTitle.text = @"Tubing Comment";
                if (arrValues[8] && ![arrValues[8] isEqualToString:@""]) {
                    [self.txtComment setText:arrValues[8]];
                } else {
                    [self.txtComment setText:@""];
                }
                [self.viewComment setHidden:NO];
                [self.txtComment becomeFirstResponder];
                break;
            case 9: // Rods Comment
                self.commentType = Rods;
                self.lblCommentTitle.text = @"Rods Comment";
                if (arrValues[9] && ![arrValues[9] isEqualToString:@""]) {
                    [self.txtComment setText:arrValues[9]];
                } else {
                    [self.txtComment setText:@""];
                }
                [self.viewComment setHidden:NO];
                [self.txtComment becomeFirstResponder];
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark -
- (void)onLease
{
    if ([AppData sharedInstance].arrLeases.count == 0) {
        return;
    }
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Leases" rows:[AppData sharedInstance].arrLeaseNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrValues replaceObjectAtIndex:0 withObject:[AppData sharedInstance].arrLeases[selectedIndex]];
        [arrValues replaceObjectAtIndex:1 withObject:@""];
        
        [self.tableView reloadData];
        
        [self getWellList:[AppData sharedInstance].arrLeases[selectedIndex]];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) getWellList:(NSString*)lease
{
    
    NSArray *arrWells = [[NSArray alloc] init];
    [arrWellNumber removeAllObjects];

    arrWells = [[DBManager sharedInstance] getWellListByLease:lease];
    
    for (NSDictionary *dicData in arrWells) {
        NSString *strWellNumber = [dicData valueForKey:@"wellNumber"];
        [arrWellNumber addObject:strWellNumber];
    }
    [self.tableView reloadData];
}

-(void)onWellNumber
{
    if (arrWellNumber.count == 0) {
        return;
    }
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Well Numbers" rows:arrWellNumber initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrValues replaceObjectAtIndex:1 withObject:arrWellNumber[selectedIndex]];
        dicLastComments = [[DBManager sharedInstance] getCommentsForRigReportsByWellNum:arrWellNumber[selectedIndex] withLease:arrValues[0]];
        arrValues[7] = @"";
        arrValues[8] = @"";
        arrValues[9] = @"";
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) onCompany
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Company Name"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Company Name", @"Values");
     }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = alertController.textFields.firstObject;
        
        [arrValues replaceObjectAtIndex:2 withObject:textfield.text];
        
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) onDailyCost
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Daily Cost"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Daily Cost";
         textField.keyboardType = UIKeyboardTypeDecimalPad;
     }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = alertController.textFields.firstObject;
        if ([self isNumeric:textfield.text]) {
            [arrValues replaceObjectAtIndex:3 withObject:textfield.text];
            
            [self.tableView reloadData];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL) isNumeric:(NSString*)string {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:string];
    return number!=nil;
}

-(void) onTotalCost
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Total Cost" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    float curDailyCost = 0.0f;
    if (arrValues[3] != nil && ![arrValues[3] isEqualToString:@""]) {
        curDailyCost = [arrValues[3] floatValue];
    }
    UIAlertAction *curDailyAct = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Current Daily: $%.02f", curDailyCost] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [arrValues replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%.02f", curDailyCost]];
        [self.tableView reloadData];
    }];
    [alert addAction:curDailyAct];
    
    if (arrValues[3] == nil || [arrValues[3] isEqualToString:@""]) {
        [curDailyAct setEnabled:NO];
    }
    
    float totalCost = 0.0f;
    
    if (![arrValues[0] isEqualToString:@""] && ![arrValues[1] isEqualToString:@""]) {
        totalCost = [[DBManager sharedInstance] getTotalCostFromRigReportsWithLease:arrValues[0] wellNum:arrValues[1]];
        //        if (![arrSectionTitles[6] isEqualToString:@"Add Daily Cost"]) {
        totalCost += curDailyCost;
    }
    UIAlertAction *curDailyPrevTotal = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Current Daily + Previous Total: $%.02f", totalCost]  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        arrValues[4] = [NSString stringWithFormat:@"%.02f", totalCost];
        [self.tableView reloadData];
    }];
    [alert addAction:curDailyPrevTotal];
    
    if ([arrValues[0] isEqualToString:@""] || [arrValues[1] isEqualToString:@""]) {
        [curDailyPrevTotal setEnabled:NO];
    }
    
    UIAlertAction *manualAct = [UIAlertAction actionWithTitle:@"Manual" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self manualTotalCost];
    }];
    [alert addAction:manualAct];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)getLeaseCodeWithName:(NSString *)leaseName {
    
    for (int i = 0; i < [AppData sharedInstance].arrLeases.count; i++) {
        ListAssetLocations *listAssetLocations = [AppData sharedInstance].arrLeases[i];
        if ([leaseName isEqualToString:listAssetLocations.codeProperty]) {
            return listAssetLocations.grandparentPropNum;
        }
    }
    return nil;
}

- (void)manualTotalCost {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Total Cost"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Total Cost";
         textField.keyboardType = UIKeyboardTypeDecimalPad;
     }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = alertController.textFields.firstObject;
        if ([self isNumeric:textfield.text]) {
            [arrValues replaceObjectAtIndex:4 withObject:textfield.text];
            [self.tableView reloadData];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

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
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    
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
        [arrValues replaceObjectAtIndex:5 withObject:strSelectedDate];
    } else {
        NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
        [defaultFormatter setDateFormat:@"HH:mm:ss"];
        
        NSString *strSelectedTime = [defaultFormatter stringFromDate:datePicker.date];
        [arrValues replaceObjectAtIndex:6 withObject:strSelectedTime];
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
    for (int i = 0; i < arrValues.count - 3; i++) {
        if ([arrValues[i] isEqual:@""]) {
            if (i == 3 || i == 4)
                continue;
            NSString *strMessage = [NSString stringWithFormat:@"Input %@", arrFields[i]];
            [self showDefaultAlert:@"Missing Data" withMessage:strMessage];
            return;
        }
    }
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    [dicData setValue:arrValues[0] forKey:@"lease"];
    [dicData setValue:arrValues[1] forKey:@"wellNum"];
    [dicData setValue:arrValues[2] forKey:@"company"];
    [dicData setValue:arrValues[3] forKey:@"dailyCost"];
    [dicData setValue:arrValues[4] forKey:@"totalCost"];
    NSString *reportDate = [NSString stringWithFormat:@"%@ %@", arrValues[5], arrValues[6]];
    [dicData setValue:reportDate forKey:@"date"];
    [dicData setValue:arrValues[7] forKey:@"comment"];
    [dicData setValue:arrValues[8] forKey:@"tubing"];
    [dicData setValue:arrValues[9] forKey:@"rods"];
    
    [dicData setValue:[[NSUserDefaults standardUserDefaults] valueForKey:S_UserID] forKey:@"userid"];
    
    if (arySelectedImages != nil && arySelectedImages.count > 0) {
        NSMutableArray *aryImageDatas = [[NSMutableArray alloc] init];
        
        for (UIImage *img in arySelectedImages) {
            NSData *imageData = UIImageJPEGRepresentation(img, 0.9f);
            NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
            
            NSLog(@"%d", (int)[imageString length]);
            [aryImageDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageString, @"Image", @"0", @"ImageID", nil ]];
        }
        [dicData setValue:aryImageDatas forKey:@"rigImage"];
    }
    
    if ([[DBManager sharedInstance] addRigReports:dicData]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Added New RigReports" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self showDefaultAlert:nil withMessage:@"Failed Adding a new RigReports"];
    }
}

- (IBAction)onCommentSave:(id)sender {
    NSString *strComment = self.txtComment.text;
    
    switch (self.commentType) {
        case NONE:
            [arrValues replaceObjectAtIndex:7 withObject:strComment];
            break;
        case Tubing:
            [arrValues replaceObjectAtIndex:8 withObject:strComment];
            break;
        case Rods:
            [arrValues replaceObjectAtIndex:9 withObject:strComment];
            break;
        default:
            break;
    }
    self.txtComment.text = @"";
    [self.txtComment resignFirstResponder];
    [self.viewComment setHidden:YES];
    
    [self.tableView reloadData];
}

- (IBAction)onCommentCancel:(id)sender {
    
    [self.txtComment resignFirstResponder];
    [self.viewComment setHidden:YES];
}


#pragma mark - show default alert

-(void) showDefaultAlert:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CollectionViewCellMgrDelegate
-(void)onAddImage {
    [self actForSelectPhot];
}

-(void)onDeleteImage:(NSInteger)index {
    [self actRemoveImage:index];
}

#pragma mark - remove image proc
-(void)actRemoveImage:(NSInteger)index {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [arySelectedImages removeObjectAtIndex:index];
        [self.tableView reloadData];
        
    }];
    [alert addAction:removeAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Tap Gesture

- (IBAction)onTapCommentsList:(id)sender {
//    [self.viewCommentsList setHidden:YES];
//    strCommentsKey = @"";
}

- (IBAction)onCloseCommentsList:(id)sender {
    [self showCommentsListView:NO];
    strCommentsKey = @"";
}
@end
