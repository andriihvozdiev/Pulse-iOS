#import "NewInvoiceVC.h"
#import "ActionSheetStringPicker.h"
#import "HapticHelper.h"

#import "NewInvoiceHeaderCell.h"
#import "NewInvoiceContentCell.h"
#import "NewInvoiceCommentCell.h"
#import "NewInvoiceImageCell.h"
#import "SelectAccountVC.h"
#import "SelectPeopleVC.h"
#import "InvoiceCommentVC.h"

@interface NewInvoiceVC ()
{
    BOOL isExistingWellNumber;
//    UIImage *imgInvoice;
//    UITapGestureRecognizer *actInvoiceImageTap;
    NSMutableArray *arySelectedImages;
    NSArray *aryTotalCostCategory;
    BOOL isSuperVisor;
    BOOL isSelectingAccount;
    NSMutableDictionary *dicInvoicesForLastComments;
    NSMutableArray *aryInvoiceForComments;
    NSString *strCommentsKey;
}
@end

@implementation NewInvoiceVC
@synthesize invoice;
@synthesize arrLeases;
@synthesize arrLeaseNames;

@synthesize arrSectionTitles;
@synthesize arrWells;
@synthesize arrWellNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    arySelectedImages = [[NSMutableArray alloc] init];
    dicInvoicesForLastComments = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
//    actInvoiceImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapInvoiceImage:)];
    if (self.isEdit) {
        [self.lblTitle setText:@"Edit Invoice"];
        [self.btnCreate setTitle:@"Save" forState:UIControlStateNormal];
    }
    [AppData sharedInstance].arrSelectedAccounts = [[NSMutableArray alloc] init];
    [AppData sharedInstance].arrSelectedAccountTimes = [[NSMutableArray alloc] init];
    [AppData sharedInstance].arrSelectedPeople = [[NSMutableArray alloc] init];
    [AppData sharedInstance].strComment = @"";
    [AppData sharedInstance].strTubingComment = @"";
    [AppData sharedInstance].strRodComment = @"";
    isSuperVisor = NO;
    
    NSLog(@"%@", [AppData sharedInstance].arrSelectedAccounts);
    self.btnCreate.layer.borderWidth = 1.0f;
    self.btnCreate.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnCreate.layer.cornerRadius = 3.0f;
    
    isExistingWellNumber = NO;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 35;
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    self.viewCommentsContainer.layer.cornerRadius = 4;
    [self initData];
    if (self.isEdit) {
        [self loadFromInvoiceData];
    } else {
        arrSectionTitles = [NSMutableArray arrayWithArray:@[@"Add Date", @"Add Lease", @"Add WellNumber", @"Add Account", @"Add People", @"Add Company", @"Add Daily Cost", @"Add Total Cost", @"Add Comment", @"Add Tubing Comment", @"Add Rod Comment"]];
    }
    aryTotalCostCategory = @[@"Current Daily", @"Current Daily + Previous Total", @"Manual"];
}

- (void)loadFromInvoiceData {
    NSString *comment = invoice.comments;
    if (comment && ![comment isEqual:@""]) {
        [AppData sharedInstance].strComment = comment;
    } else {
        [AppData sharedInstance].strComment = @"No Comment";
    }
    
    NSString *tubingComment = invoice.tubingComments;
    if (tubingComment && ![tubingComment isEqual:@""]) {
        [AppData sharedInstance].strTubingComment = tubingComment;
    } else {
        [AppData sharedInstance].strTubingComment = @"No Comment";
    }
    
    NSString *rodComment = invoice.rodComments;
    if (rodComment && ![rodComment isEqual:@""]) {
        [AppData sharedInstance].strRodComment = rodComment;
    } else {
        [AppData sharedInstance].strRodComment = @"No Comment";
    }
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *loadedDate = [defaultFormatter stringFromDate:invoice.invoiceDate];
    NSString *dateStr_ = [NSString stringWithFormat:@"Date: %@", loadedDate];
    NSMutableAttributedString * dateStr = [[NSMutableAttributedString alloc] initWithString:dateStr_];
    [dateStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 5)];
    
    NSString *loadedLease_ = @"Add Lease";
    if (invoice.lease && ![invoice.lease isEqualToString:@""]) {
        loadedLease_ = [NSString stringWithFormat:@"Lease: %@", [[DBManager sharedInstance] getLeaseNameFromPropNum:invoice.lease]];
    }
    self.strSelectedLease = invoice.lease;
    NSMutableAttributedString * loadedLease = [[NSMutableAttributedString alloc] initWithString:loadedLease_];
    [loadedLease addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 6)];
    
    NSString *loadedWellNumber_ = @"Add WellNumber";
    NSMutableAttributedString * loadedWellNumber = [[NSMutableAttributedString alloc] initWithString:loadedWellNumber_];
    if (invoice.wellNumber && ![invoice.wellNumber isEqualToString:@""]) {
        loadedWellNumber_ = [NSString stringWithFormat:@"Well: %@", invoice.wellNumber];
        loadedWellNumber = [[NSMutableAttributedString alloc] initWithString:loadedWellNumber_];
        [loadedWellNumber addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 5)];
    }
    NSString *loadedCompany_ = @"Add Company";
    NSMutableAttributedString * loadedCompany = [[NSMutableAttributedString alloc] initWithString:loadedCompany_];
    if (invoice.company && ![invoice.company isEqualToString:@""]) {
        loadedCompany_ = [NSString stringWithFormat:@"Company: %@", invoice.company];
        loadedCompany = [[NSMutableAttributedString alloc] initWithString:loadedCompany_];
        [loadedCompany addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 8)];
    }
    
    NSString *loadedDailyCost_ = @"Add Daily Cost";
    NSMutableAttributedString * loadedDailyCost = [[NSMutableAttributedString alloc] initWithString:loadedDailyCost_];
    if (invoice.dailyCost && !([invoice.dailyCost isEqualToString:@""] || [invoice.dailyCost floatValue] == 0.0)) {
        loadedDailyCost_ = [NSString stringWithFormat:@"Daily Cost: %.02f", [invoice.dailyCost floatValue]];
        loadedDailyCost = [[NSMutableAttributedString alloc] initWithString:loadedDailyCost_];
        [loadedDailyCost addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 11)];
    }
    
    NSString *loadedTotalCost_ = @"Add Total Cost";
    NSMutableAttributedString * loadedTotalCost = [[NSMutableAttributedString alloc] initWithString:loadedTotalCost_];
    if (invoice.totalCost && !([invoice.totalCost isEqualToString:@""] || [invoice.totalCost floatValue] == 0.0)) {
        loadedTotalCost_ = [NSString stringWithFormat:@"Total Cost: %.02f", [invoice.totalCost floatValue]];
        loadedTotalCost = [[NSMutableAttributedString alloc] initWithString:loadedTotalCost_];
        [loadedTotalCost addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 11)];
    }

    arrSectionTitles = [NSMutableArray arrayWithArray:@[dateStr, loadedLease, loadedWellNumber, @"Add Account", @"Add People", loadedCompany, loadedDailyCost, loadedTotalCost, @"Add Comment", @"Add Tubing Comment", @"Add Rod Comment"]];

    //set people info
    if ([AppData sharedInstance].arrSelectedPeople) {
        [[AppData sharedInstance].arrSelectedPeople removeAllObjects];
    }
    NSArray *arrSelectedPeoples = [[DBManager sharedInstance] getInvoicePersonnel:invoice.invoiceID appID:invoice.invoiceAppID];
    [AppData sharedInstance].arrPeople = [[DBManager sharedInstance] getPersonnels];
    for (int i = 0; i < arrSelectedPeoples.count; i++) {
        InvoicesPersonnel *invoicePersonnel = arrSelectedPeoples[i];
        for (int j = 0; j < [AppData sharedInstance].arrPeople.count; j++) {
            Personnel *personnel = [AppData sharedInstance].arrPeople[j];
            if (invoicePersonnel.userID == personnel.userid) {
                [[AppData sharedInstance].arrSelectedPeople addObject:[NSNumber numberWithInt:j]];
            }
        }
    }
    
    //set account info
    [AppData sharedInstance].arrSelectedAccounts = [[NSMutableArray alloc] init];
    [AppData sharedInstance].arrSelectedAccountTimes = [[NSMutableArray alloc] init];
    [AppData sharedInstance].arrSelectedAccountTimeUnits = [[NSMutableArray alloc] init];
    NSArray *arrSelectedAccounts = [[DBManager sharedInstance] getInvoiceDetail:invoice.invoiceID appID:invoice.invoiceAppID];
    [AppData sharedInstance].arrAccounts = [[DBManager sharedInstance] getAllAccounts];
    NSArray *arrAllAccounts = [AppData sharedInstance].arrAccounts;
    for (int i = 0; i < arrSelectedAccounts.count; i++) {
        InvoicesDetail *selectedAccount = [arrSelectedAccounts objectAtIndex:i];
        for (int j = 0; j < arrAllAccounts.count; j++) {
            InvoiceAccounts *account = [arrAllAccounts objectAtIndex:j];
            if (account.acctID == selectedAccount.account && account.subAcctID == selectedAccount.accountSub) {
                [[AppData sharedInstance].arrSelectedAccounts addObject:[NSNumber numberWithInt:j]];
                [[AppData sharedInstance].arrSelectedAccountTimes addObject:selectedAccount.accountTime];
                [[AppData sharedInstance].arrSelectedAccountTimeUnits addObject:selectedAccount.accountUnit];
            }
        }
    }
    if (self.isEdit) {
        if (invoice.invoiceImages != nil && invoice.invoiceImages.count > 0) {
            for (NSDictionary *imgStr in invoice.invoiceImages) {
                if ([imgStr[@"Image"] rangeOfString:@"invoiceimageurl"].location == NSNotFound) {
                    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:imgStr[@"Image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    [arySelectedImages addObject:[NSDictionary dictionaryWithObjectsAndKeys:imgStr[@"ImageID"], @"ImageID", [UIImage imageWithData:imageData], @"Image", nil]];
                } else {
                    NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, imgStr[@"Image"]];
                    [arySelectedImages addObject:[NSDictionary dictionaryWithObjectsAndKeys:imgStr[@"ImageID"], @"ImageID", imgStr[@"Image"], @"Image", nil]];
                    //        [imageView setImageWithURL:];
//                    [imageView setImageWithURL:[NSURL URLWithString:url_str] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    
                }
            }
        }
    }
    [self getWellList:invoice.lease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initData
{
    self.strSelectedLease = @"";
    
    arrWells = [[NSArray alloc] init];
    arrWellNumber = [[NSMutableArray alloc] init];
    
    // get Leases
    arrLeases = [[NSMutableArray alloc] init];
    arrLeaseNames = [[NSMutableArray alloc] init];
    
    NSArray *arrListAssetLocations = [[DBManager sharedInstance] getLeasesForInvoice];
    
    for (ListAssetLocations *listAssetLocations in arrListAssetLocations) {
        [arrLeases addObject:listAssetLocations];
        [arrLeaseNames addObject:listAssetLocations.codeProperty];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isSuperVisor = NO;
    
    for (int i = 0; i < [AppData sharedInstance].arrSelectedAccounts.count; i++)
    {
        NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedAccounts[i] integerValue];
        InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[selectedIndex];
        
        if (accountData.acctID == 11 || accountData.acctID == 14) {
            NSLog(@"Pulling Machine or Supervisor");
            isSuperVisor = YES;
            break;
        }
    }
    if (!isSuperVisor && isSelectingAccount) {
        arrSectionTitles[6] = @"Add Daily Cost";
        arrSectionTitles[7] = @"Add Total Cost";
        isSelectingAccount = NO;
    }
    [self.tableView reloadData];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
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


- (IBAction)onCreate:(id)sender {
    
    if ([arrSectionTitles[0] isKindOfClass:[NSAttributedString class]]) {
        arrSectionTitles[0] = [arrSectionTitles[0] string];
        NSRange replaceRange = [arrSectionTitles[0] rangeOfString:@"Date: "];
        if (replaceRange.location != NSNotFound){
            arrSectionTitles[0] = [arrSectionTitles[0] stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    }
    if ([arrSectionTitles[1] isKindOfClass:[NSAttributedString class]]) {
        arrSectionTitles[1] = [arrSectionTitles[1] string];
        NSRange replaceRange = [arrSectionTitles[1] rangeOfString:@"Lease: "];
        if (replaceRange.location != NSNotFound){
            arrSectionTitles[1] = [arrSectionTitles[1] stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    }
    if ([arrSectionTitles[5] isKindOfClass:[NSAttributedString class]]) {
        arrSectionTitles[5] = [arrSectionTitles[5] string];
        NSRange replaceRange = [arrSectionTitles[5] rangeOfString:@"Company: "];
        if (replaceRange.location != NSNotFound){
            arrSectionTitles[5] = [arrSectionTitles[5] stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    }
    if ([arrSectionTitles[2] isKindOfClass:[NSAttributedString class]]) {
        arrSectionTitles[2] = [arrSectionTitles[2] string];
        NSRange replaceRange = [arrSectionTitles[2] rangeOfString:@"Well: "];
        if (replaceRange.location != NSNotFound){
            arrSectionTitles[2] = [arrSectionTitles[2] stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    }
    
    if ([arrSectionTitles[6] isKindOfClass:[NSAttributedString class]]) {
        arrSectionTitles[6] = [arrSectionTitles[6] string];
        NSRange replaceRange = [arrSectionTitles[6] rangeOfString:@"Daily Cost: "];
        if (replaceRange.location != NSNotFound){
            arrSectionTitles[6] = [arrSectionTitles[6] stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    }
    
    if ([arrSectionTitles[7] isKindOfClass:[NSAttributedString class]]) {
        arrSectionTitles[7] = [arrSectionTitles[7] string];
        NSRange replaceRange = [arrSectionTitles[7] rangeOfString:@"Total Cost: "];
        if (replaceRange.location != NSNotFound){
            arrSectionTitles[7] = [arrSectionTitles[7] stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    }
    
    if ([arrSectionTitles[0] isEqualToString:@"Add Date"]) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Date"];
        return;
    }
    if ([arrSectionTitles[1] isEqualToString:@"Add Lease"]) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Lease"];
        return;
    }
    if ([AppData sharedInstance].arrSelectedAccounts.count == 0) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Account"];
        return;
    }
    if ([AppData sharedInstance].arrSelectedPeople.count == 0) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add People"];
        return;
    }
    if ([arrSectionTitles[5] isEqualToString:@"Add Company"]) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Company"];
        return;
    }
    if ([[AppData sharedInstance].strComment isEqual:@""]) {
        [self showDefaultAlert:@"Error" withMessage:@"Please add Comment"];
        return;
    }
    
    NSMutableArray *arrSelectedAccountData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [AppData sharedInstance].arrSelectedAccounts.count; i++) {
        NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedAccounts[i] integerValue];
        InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[selectedIndex];
        
        NSMutableDictionary *dicAccount = [[NSMutableDictionary alloc] init];
        [dicAccount setValue:[NSNumber numberWithInt:accountData.acctID] forKey:@"account"];
        [dicAccount setValue:[NSNumber numberWithInt:accountData.subAcctID] forKey:@"accountSub"];
        [dicAccount setValue:[AppData sharedInstance].arrSelectedAccountTimes[i] forKey:@"accountTime"];
        [dicAccount setValue:[AppData sharedInstance].arrSelectedAccountTimeUnits[i] forKey:@"accountUnit"];
        
        [arrSelectedAccountData addObject:dicAccount];
    }
    
    NSMutableArray *arrPeopleData = [[NSMutableArray alloc] init];
    for (int i = 0; i < [AppData sharedInstance].arrSelectedPeople.count; i++) {
        NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedPeople[i] integerValue];
        Personnel *personnel = [AppData sharedInstance].arrPeople[selectedIndex];
        
        [arrPeopleData addObject:personnel];
    }
    
    int userID = [[[NSUserDefaults standardUserDefaults] valueForKey:S_UserID] intValue];
    NSString *strUserID = [NSString stringWithFormat:@"%d", userID];
    NSString *strDeviceID = [NSString stringWithFormat:@"%05d", userID];
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:strUserID forKey:@"userid"];
    [dicParam setObject:strDeviceID forKey:@"deviceid"];
    [dicParam setObject:arrSectionTitles[0] forKey:@"date"];
    [dicParam setObject:self.strSelectedLease forKey:@"lease"];
    
    if (arySelectedImages != nil && arySelectedImages.count > 0) {
        
        NSMutableArray *tmpAryInvoiceImages = [[NSMutableArray alloc] init];
        if (self.isEdit) {
            for (int i = 0; i < arySelectedImages.count; i++) {
                
                NSObject *obj = arySelectedImages[i];
                if ([obj isKindOfClass:[UIImage class]]) {
                    NSData *imageData = UIImageJPEGRepresentation((UIImage*)obj, 0.9f);
                    NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
                    NSLog(@"%d", (int)[imageString length]);
                    [tmpAryInvoiceImages addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageString, @"Image", @"0", @"ImageID", nil]];
                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                    [tmpAryInvoiceImages addObject:(NSDictionary*)obj];
                }
            }
        } else {
            for (UIImage *img in arySelectedImages) {
                NSData *imageData = UIImageJPEGRepresentation(img, 0.9f);
                NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
                NSLog(@"%d", (int)[imageString length]);
                [tmpAryInvoiceImages addObject:imageString];
            }
        }
        [dicParam setObject:tmpAryInvoiceImages forKey:@"invoiceImages"];
    }
    
    if (![arrSectionTitles[2] isEqualToString:@"Add WellNumber"]) {
        [dicParam setObject:arrSectionTitles[2] forKey:@"wellNumber"];
    }
    
    [dicParam setObject:arrSelectedAccountData forKey:@"accountdata"];
    
    [dicParam setObject:arrPeopleData forKey:@"peopledata"];
    [dicParam setObject:arrSectionTitles[5] forKey:@"company"];
    [dicParam setObject:[AppData sharedInstance].strComment forKey:@"comments"];
    [dicParam setObject:[AppData sharedInstance].strTubingComment forKey:@"tubingComments"];
    [dicParam setObject:[AppData sharedInstance].strRodComment forKey:@"rodComments"];
    //set costs
    if ([arrSectionTitles[6] isEqualToString:@"Add Daily Cost"]) {
        [dicParam setObject:@"0" forKey:@"dailyCost"];
    } else {
        [dicParam setObject:arrSectionTitles[6] forKey:@"dailyCost"];
    }
    
    if ([arrSectionTitles[7] isEqualToString:@"Add Total Cost"]) {
        [dicParam setObject:@"0" forKey:@"totalCost"];
    } else {
        [dicParam setObject:arrSectionTitles[7] forKey:@"totalCost"];
    }
    
    NSLog(@"%@", dicParam);
    
    if (self.isEdit) {
        [dicParam setObject:[NSNumber numberWithInt:invoice.invoiceID] forKey:@"invoiceID"];
        [dicParam setObject:invoice.invoiceAppID forKey:@"invoiceAppID"];
        if ([[DBManager sharedInstance] editInvoices:dicParam]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Edited Invoice Successfully." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            [self showDefaultAlert:nil withMessage:@"Edit a Invoice Failed."];
        }
    } else {
        if ([[DBManager sharedInstance] createInvoices:dicParam]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Created New Invoice Successfully." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            [self showDefaultAlert:nil withMessage:@"Create a New Invoice Failed."];
        }
    }
}

- (IBAction)onHeaderTapped:(id)sender
{
    NSInteger section = [(UIButton*)sender tag];
    switch (section) {
        case 0:
            [self onDate];
            break;
        case 1:
            [self onLease];
            break;
        case 2:
            [self onWellNumber];
            break;
        case 3:
            {
                isSelectingAccount = YES;
                SelectAccountVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectAccountVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 4:
            {
                SelectPeopleVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPeopleVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 5:
            [self onCompany];
            break;
        case 6:
            if (isSuperVisor) {
                [self onDailyCost];
            } else {
                InvoiceCommentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceCommentVC"];
                vc.commentType = NONE;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 7:
            if (isSuperVisor) {
                [self onTotalCost];
            }
            break;
        case 8: // Comments
            {
                InvoiceCommentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceCommentVC"];
                vc.commentType = NONE;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 9: // Tubing Comments
            {
                InvoiceCommentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceCommentVC"];
                vc.commentType = TUBING;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 10: // Rod Comments
            {
                InvoiceCommentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InvoiceCommentVC"];
                vc.commentType = ROD;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        
        default:
            break;
    }
}


- (void)onDate
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
                                         [self setSelectedDateInField];
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

-(void)setSelectedDateInField
{
    NSLog(@"date :: %@",datePicker.date.description);
    
    
    //set Date formatter
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *strSelectedDate = [defaultFormatter stringFromDate:datePicker.date];
    [arrSectionTitles replaceObjectAtIndex:0 withObject:strSelectedDate];
    
    [self.tableView reloadData];
    
}

- (void)onLease
{
    if (arrLeases.count == 0) {
        return;
    }
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Leases" rows:arrLeaseNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrSectionTitles replaceObjectAtIndex:1 withObject:arrLeaseNames[selectedIndex]];
        [arrSectionTitles replaceObjectAtIndex:2 withObject:@"Add WellNumber"];
        
        [self.tableView reloadData];
        
        ListAssetLocations *listAssetLocations = arrLeases[selectedIndex];
        self.strSelectedLease = listAssetLocations.propNum;
        [self getWellList:listAssetLocations.grandparentPropNum];
        [dicInvoicesForLastComments removeAllObjects];
        [aryInvoiceForComments removeAllObjects];
        
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
   
    arrWells = [[NSArray alloc] init];
    [arrWellNumber removeAllObjects];
    isExistingWellNumber = NO;
    
    arrWells = [[DBManager sharedInstance] getWellListByLease:lease];
    
    if (arrWells == nil || arrWells.count == 0) {
        isExistingWellNumber = NO;
    }
    for (NSDictionary *dicData in arrWells) {
        NSString *strWellNumber = [dicData valueForKey:@"wellNumber"];
        [arrWellNumber addObject:strWellNumber];
        isExistingWellNumber = YES;
    }
    [self.tableView reloadData];
    
}

- (IBAction)onAutoFill:(UIButton *)sender {
    
    NSArray *aryLastComments = dicInvoicesForLastComments[@"comments"];
    NSArray *aryLastCommentsRod = dicInvoicesForLastComments[@"rods"];
    NSArray *aryLastCommentsTubing = dicInvoicesForLastComments[@"tubing"];
    switch (sender.tag) {
        case 6: //comments
            if (aryLastComments.count > 0) {
                RigReports *tmpInvo = aryLastComments[0];
                [AppData sharedInstance].strComment = tmpInvo.comments;
            }
            break;
        case 8: //comments
            if (aryLastComments.count > 0) {
                RigReports *tmpInvo = aryLastComments[0];
                [AppData sharedInstance].strComment = tmpInvo.comments;
            }
            break;
        case 9: //tubing comments
            if (aryLastCommentsTubing.count > 0) {
                RigReports *tmpInvo = aryLastCommentsTubing[0];
                [AppData sharedInstance].strTubingComment = tmpInvo.tubing;
            }
            break;
        case 10: //rod comments
            if (aryLastCommentsRod.count > 0) {
                RigReports *tmpInvo = aryLastCommentsRod[0];
                [AppData sharedInstance].strRodComment = tmpInvo.rods;
            }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

-(void)onWellNumber
{
    if (arrWellNumber.count == 0) {
        return;
    }
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Well Numbers" rows:arrWellNumber initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [arrSectionTitles replaceObjectAtIndex:2 withObject:arrWellNumber[selectedIndex]];
        dicInvoicesForLastComments = [[DBManager sharedInstance] getCommentsForRigReportsByWellNum:arrWellNumber[selectedIndex] withLease:self.strSelectedLease];
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
        
        [arrSectionTitles replaceObjectAtIndex:5 withObject:textfield.text];
        
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
            [arrSectionTitles replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%.02f", [textfield.text floatValue]]];
            [self.tableView reloadData];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) onTotalCost
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Total Cost" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    float curDailyCost = 0.0f;
    
    if ([arrSectionTitles[6] isKindOfClass:[NSAttributedString class]]) {
        NSString *tmpStr = [[arrSectionTitles[6] copy] string];
        NSRange replaceRange = [tmpStr rangeOfString:@"Daily Cost: "];
        if (replaceRange.location != NSNotFound) {
            tmpStr = [tmpStr stringByReplacingCharactersInRange:replaceRange withString:@""];
            curDailyCost = [tmpStr floatValue];
        }
    } else {
        if (![arrSectionTitles[6] isEqualToString:@"Add Daily Cost"]) {
            curDailyCost = [arrSectionTitles[6] floatValue];
        }
    }
    
    UIAlertAction *curDailyAct = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Current Daily: $%.02f", curDailyCost] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [arrSectionTitles replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%.02f", curDailyCost]];
        [self.tableView reloadData];
    }];
    [alert addAction:curDailyAct];
    
    if (![arrSectionTitles[6] isKindOfClass:[NSAttributedString class]] && [arrSectionTitles[6] isEqualToString:@"Add Daily Cost"]) {
        [curDailyAct setEnabled:NO];
    }
    
    float totalCost = 0.0f;
    NSString *strLease = @"";
    NSString *strWellNumber = @"";
    if ([arrSectionTitles[1] isKindOfClass:[NSAttributedString class]]) {
        strLease = [[arrSectionTitles[1] copy] string];
        NSRange replaceRange = [strLease rangeOfString:@"Lease: "];
        if (replaceRange.location != NSNotFound) {
            strLease = [strLease stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    } else {
        strLease = [arrSectionTitles[1] copy];
    }
    
    if ([arrSectionTitles[2] isKindOfClass:[NSAttributedString class]]) {
        strWellNumber = [[arrSectionTitles[2] copy] string];
        NSRange replaceRange = [strWellNumber rangeOfString:@"Well: "];
        if (replaceRange.location != NSNotFound) {
            strWellNumber = [strWellNumber stringByReplacingCharactersInRange:replaceRange withString:@""];
        }
    } else {
        strWellNumber = [arrSectionTitles[2] copy];
    }
    
    if (![strLease isEqualToString:@"Add Lease"] && ![strWellNumber isEqualToString:@"Add WellNumber"]) {
        NSString *locationCode = [self getLeaseCodeWithName:strLease];
        if (locationCode != nil)
            totalCost = [[DBManager sharedInstance] getTotalCostWithLease:locationCode wellNum:strWellNumber];
//        if (![arrSectionTitles[6] isEqualToString:@"Add Daily Cost"]) {
            totalCost += curDailyCost;
//        }
        
    }
    UIAlertAction *curDailyPrevTotal = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Current Daily + Previous Total: $%.02f", totalCost]  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        arrSectionTitles[7] = [NSString stringWithFormat:@"%.02f", totalCost];
        [self.tableView reloadData];
    }];
    [alert addAction:curDailyPrevTotal];
    
    if ((![arrSectionTitles[1] isKindOfClass:[NSAttributedString class]] && [arrSectionTitles[1] isEqualToString:@"Add Lease"]) || (![arrSectionTitles[2] isKindOfClass:[NSAttributedString class]] && [arrSectionTitles[2] isEqualToString:@"Add WellNumber"])) {
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
    
    for (int i = 0; i < arrLeases.count; i++) {
        ListAssetLocations *listAssetLocations = arrLeases[i];
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
        if ([self isNumeric:textfield.text] ) {
            [arrSectionTitles replaceObjectAtIndex:7 withObject:textfield.text];
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

//-(void)onTapInvoiceImage:(id)sender {
//    [self actForSelectPhot];
//}

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
    [arySelectedImages addObject:[self imageWithImage:chosenImage scaledToWidth:800]];
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

- (IBAction)onHeaderTappedGesture:(UIView*)sender {
    
}

#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 2) {
        return 1;
    } else {
        NSInteger numberOfSections = arrSectionTitles.count - 4;
        
        for (int i = 0; i < [AppData sharedInstance].arrSelectedAccounts.count; i++)
        {
            NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedAccounts[i] integerValue];
            InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[selectedIndex];
            
            if (accountData.acctID == 11 || accountData.acctID == 14) {
                NSLog(@"Pulling Machine or Supervisor");
                numberOfSections = arrSectionTitles.count;
                break;
            }
        }
        NSLog(@"Number of sections: %ld", numberOfSections);
        return numberOfSections + 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return aryInvoiceForComments.count;
    } else {
        NSInteger number = 0;
        switch (section) {
            case 0: //Date
            case 1: //Lease
            case 2: //Well Number
                number = 0;
                break;
            case 3: //Account
                number = [AppData sharedInstance].arrSelectedAccounts.count;
                break;
            case 4: //People
                number = [AppData sharedInstance].arrSelectedPeople.count;
                break;
            case 5: //Company
                number = 0;
                break;
            case 6: //Daily Cost(Supervisor) or Comment (not Supervisor)
                if (isSuperVisor) {
                    number = 0;
                } else {
                    if ([[AppData sharedInstance].strComment isEqualToString:@""]) {
                        number = 0;
                    } else {
                        number = 1;
                    }
                }
                break;
            case 7: //Total Cost or Invoice Image
                number = 0;
                break;
            case 8: //Comment
                if ([[AppData sharedInstance].strComment isEqualToString:@""]) {
                    number = 0;
                } else {
                    number = 1;
                }
                break;
            case 9: // TubingComments
                if ([[AppData sharedInstance].strTubingComment isEqualToString:@""]) {
                    number = 0;
                } else {
                    number = 1;
                }
                break;
            case 10: // RodComments
                if ([[AppData sharedInstance].strRodComment isEqualToString:@""]) {
                    number = 0;
                } else {
                    number = 1;
                }
                break;
            default:
                break;
        }
        NSInteger lastIndex = [tableView numberOfSections] - 1;
        if (lastIndex == section) {
            number = 0;
        }
        NSLog(@"===>>>Number of Row:%ld, section index: %ld", (long)number, (long)section);
        return number;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsListCell"];
        UILabel *lblDate = [cell viewWithTag:111];
        UITextView *txtComments = [cell viewWithTag:222];
        txtComments.tintColor = [UIColor whiteColor];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy"];
        RigReports *inv = aryInvoiceForComments[indexPath.row];
        if ([strCommentsKey isEqualToString:@"comments"]) {
            [txtComments setText: inv.comments];
            [lblDate setText:[df stringFromDate:inv.reportDate]];
        } else if ([strCommentsKey isEqualToString:@"rods"]) {
            [txtComments setText: inv.rods];
            [lblDate setText:[df stringFromDate:inv.reportDate]];
        } else if ([strCommentsKey isEqualToString:@"tubing"]) {
            [txtComments setText: inv.tubing];
            [lblDate setText:[df stringFromDate:inv.reportDate]];
        }
        return cell;
    } else {
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        NSInteger lastIndex = [tableView numberOfSections] - 1;
        if (lastIndex == section) {
            
            NewInvoiceImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceImageCell" forIndexPath:indexPath];
            cell.delegate = self;
            for (NSObject *obj in arySelectedImages) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [cell.aryImages addObject:((NSDictionary*)obj)[@"Image"]];
                } else if ([obj isKindOfClass:[UIImage class]]) {
                    [cell.aryImages addObject:(UIImage*)obj];
                }
                
            }
            [cell.collectionView reloadData];
            return cell;
        }
        switch (section) {
            case 3: // Account
            {
                NewInvoiceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceContentCell" forIndexPath:indexPath];
                NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedAccounts[row] integerValue];
                InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[selectedIndex];
                NSString *strAccout = accountData.account;
                
                cell.lblTitle.text = [accountData.subAccount isEqual:@"null"] || accountData.subAccount == nil ? accountData.account : [NSString stringWithFormat:@"%@ - %@", strAccout, accountData.subAccount];
                
                NSString *strAccountTime = [AppData sharedInstance].arrSelectedAccountTimes[row];
                NSString *strTimeUnits = [AppData sharedInstance].arrSelectedAccountTimeUnits[row];
                
                [cell.lblDescription setText:[NSString stringWithFormat:@"%@ %@", strAccountTime, strTimeUnits]];
                return cell;
            }
                break;
            case 4: // People
            {
                NewInvoiceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceContentCell" forIndexPath:indexPath];
                NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedPeople[row] integerValue];
                Personnel *personnel = [AppData sharedInstance].arrPeople[selectedIndex];
                cell.lblTitle.text = personnel.employeeName;
                cell.lblDescription.text = @"";
                return cell;
            }
                break;
            case 6:
            {
                if (!isSuperVisor) {
                    if (![[AppData sharedInstance].strComment isEqualToString:@""]) {
                        NewInvoiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceCommentCell" forIndexPath:indexPath];
                        
                        cell.lblComment.text = [AppData sharedInstance].strComment;
                        NSLog(@"comment test: %@", [AppData sharedInstance].strComment);
                        return cell;
                    }
                }
            }
                break;
            case 8: // Comment
            {
                if (![[AppData sharedInstance].strComment isEqualToString:@""]) {
                    NewInvoiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceCommentCell" forIndexPath:indexPath];
                    
                    cell.lblComment.text = [AppData sharedInstance].strComment;
                    NSLog(@"comment test: %@", [AppData sharedInstance].strComment);
                    return cell;
                }
            }
            case 9: // Tubing Comments
                if (![[AppData sharedInstance].strTubingComment isEqualToString:@""]) {
                    NewInvoiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceCommentCell" forIndexPath:indexPath];
                    
                    cell.lblComment.text = [AppData sharedInstance].strTubingComment;
                    return cell;
                }
                break;
            case 10: // Rod Comments
                if (![[AppData sharedInstance].strRodComment isEqualToString:@""]) {
                    NewInvoiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceCommentCell" forIndexPath:indexPath];
                    
                    cell.lblComment.text = [AppData sharedInstance].strRodComment;
                    return cell;
                }
                break;
            default:
                break;
        }
        return nil;
    }
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return 0;
    } else {
        NSInteger lastIndex = [tableView numberOfSections] - 1;
        if (lastIndex == section) {
            return 120;
        }
        return 55;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return nil;
    } else {
        NSInteger lastIndex = [tableView numberOfSections] - 1;
        if (lastIndex == section) {
            NewInvoiceImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceImageCell"];
            cell.delegate = self;
            for (NSObject *obj in arySelectedImages) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [cell.aryImages addObject:((NSDictionary*)obj)[@"Image"]];
                } else if ([obj isKindOfClass:[UIImage class]]) {
                    [cell.aryImages addObject:(UIImage*)obj];
                }
            }
//            cell.aryImages = arySelectedImages;
            [cell.collectionView reloadData];
            return cell;
        }
        NewInvoiceHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInvoiceHeaderCell"];
        [cell.btnAutoFillComment setHidden:YES];
        [cell.btnShowCommentsList setHidden:YES];
        if (isSuperVisor) {
            if (section == 6) { // daily cost
                if ([arrSectionTitles[section] isKindOfClass:[NSString class]]) {
                    if (![arrSectionTitles[section] isEqualToString:@"Add Daily Cost"]) {
                        cell.lblTitle.text = [NSString stringWithFormat:@"$%@", arrSectionTitles[section]];
                    } else {
                        cell.lblTitle.text = arrSectionTitles[section];
                    }
                } else if ([arrSectionTitles[section] isKindOfClass:[NSAttributedString class]]) {
                    if (![[arrSectionTitles[6] string] isEqualToString:@"Add Daily Cost"]) {
                        NSAttributedString *dollarPrefix = [[NSAttributedString alloc] initWithString:@"$"];
                        NSMutableAttributedString *dispStr = [arrSectionTitles[section] mutableCopy];
                        [dispStr insertAttributedString:dollarPrefix atIndex:12];
                        cell.lblTitle.attributedText = dispStr;
                    } else {
                        cell.lblTitle.attributedText = arrSectionTitles[section];
                    }
                }
            } else if (section == 7) { // total cost
                if ([arrSectionTitles[section] isKindOfClass:[NSString class]]) {
                    if (![arrSectionTitles[section] isEqualToString:@"Add Total Cost"]) {
                        cell.lblTitle.text = [NSString stringWithFormat:@"$%@", arrSectionTitles[section]];
                    } else {
                        cell.lblTitle.text = arrSectionTitles[section];
                    }
                } else if ([arrSectionTitles[section] isKindOfClass:[NSAttributedString class]]) {
                    if (![[arrSectionTitles[7] string] isEqualToString:@"Add Total Cost"]) {
                        NSAttributedString *dollarPrefix = [[NSAttributedString alloc] initWithString:@"$"];
                        NSMutableAttributedString *dispStr = [arrSectionTitles[section] mutableCopy];
                        [dispStr insertAttributedString:dollarPrefix atIndex:12];
                        cell.lblTitle.attributedText = dispStr;
                    } else {
                        cell.lblTitle.attributedText = arrSectionTitles[section];
                    }
                }
            } else {
                if ([arrSectionTitles[section] isKindOfClass:[NSString class]]) {
                    cell.lblTitle.text = arrSectionTitles[section];
                } else if ([arrSectionTitles[section] isKindOfClass:[NSAttributedString class]]) {
                    cell.lblTitle.attributedText = arrSectionTitles[section];
                }
            }
        } else {
            if (section == 6) { // comment
                cell.lblTitle.text = arrSectionTitles[section + 2];
            } else {
                if ([arrSectionTitles[section] isKindOfClass:[NSString class]]) {
                    cell.lblTitle.text = arrSectionTitles[section];
                } else if ([arrSectionTitles[section] isKindOfClass:[NSAttributedString class]]) {
                    cell.lblTitle.attributedText = arrSectionTitles[section];
                }
            }
        }
        
        [cell.btnAdd setTag:section];
        cell.btnAutoFillComment.tag = section;
        cell.btnShowCommentsList.tag = section;
        if ((!isSuperVisor && section == 6) || (isSuperVisor && (section ==8 || section == 9 || section == 10))) {
            NSArray *aryKeys = [dicInvoicesForLastComments allKeys];
            if ([aryKeys containsObject:@"comments"]) { // loaded last comments
                
                NSArray *aryInvoicesForComments = dicInvoicesForLastComments[@"comments"];
                NSArray *aryInvoicesForRod = dicInvoicesForLastComments[@"rods"];
                NSArray *aryInvoicesForTubing = dicInvoicesForLastComments[@"tubing"];
                
                switch (section) {
                    case 6:
                        if (aryInvoicesForComments.count > 0) {
                            [cell.btnAutoFillComment setHidden:NO];
                            [cell.btnShowCommentsList setHidden:NO];
                        } else {
                            [self setIconWithCell:cell];
                        }
                        break;
                    case 8:
                        if (aryInvoicesForComments.count > 0) {
                            [cell.btnAutoFillComment setHidden:NO];
                            [cell.btnShowCommentsList setHidden:NO];
                        } else {
                            [self setIconWithCell:cell];
                        }
                        break;
                    case 9:
                        if (aryInvoicesForTubing.count > 0) {
                            [cell.btnAutoFillComment setHidden:NO];
                            [cell.btnShowCommentsList setHidden:NO];
                        } else {
                            [self setIconWithCell:cell];
                        }
                        break;
                    case 10:
                        if (aryInvoicesForRod.count > 0) {
                            [cell.btnAutoFillComment setHidden:NO];
                            [cell.btnShowCommentsList setHidden:NO];
                        } else {
                            [self setIconWithCell:cell];
                        }
                        break;
                        
                    default:
                        break;
                }
            } else { // not loading last comments
                [self setIconWithCell:cell];
            }
        } else {
            [self setIconWithCell:cell];
        }
        if (section == 2 && !self.isEdit) {
            
            [cell.lblTitle setTextColor:[UIColor lightGrayColor]];
            if (isExistingWellNumber) {
                
                [cell.lblTitle setTextColor:[UIColor whiteColor]];
            }
        }
        return cell.contentView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2) {
        if ([strCommentsKey isEqualToString:@"comments"]) {
             [AppData sharedInstance].strComment = ((RigReports*)dicInvoicesForLastComments[@"comments"][indexPath.row]).comments;
        } else if ([strCommentsKey isEqualToString:@"rods"]) {
            [AppData sharedInstance].strRodComment = ((RigReports*)dicInvoicesForLastComments[@"rods"][indexPath.row]).rods;
        } else if ([strCommentsKey isEqualToString:@"tubing"]) {
            [AppData sharedInstance].strTubingComment = ((RigReports*)dicInvoicesForLastComments[@"tubing"][indexPath.row]).tubing;
        }
        [self.tableView reloadData];
        [self showCommentsListView:NO];
    }
}

- (void)setIconWithCell:(NewInvoiceHeaderCell*)cell {
    if (self.isEdit) {
        UIFont *fontt = [UIFont fontWithName:@"FontAwesome" size:20.0];
        [cell.btnAdd.titleLabel setFont:fontt];
        [cell.btnAdd setTitle:@"W" forState:UIControlStateNormal];
    } else {
        [cell.btnAdd.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:32.0]];
        [cell.btnAdd setTitle:@"+" forState:UIControlStateNormal];
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

#pragma mark - comments list
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

- (IBAction)onCloseCommentsList:(id)sender {
    [self showCommentsListView:NO];
    strCommentsKey = @"";
}

- (IBAction)onShowCommentsList:(UIButton *)sender {
    NSString *txtkey = @"comments";
    if (!isSuperVisor && sender.tag == 6) {
        txtkey = @"comments";
    } else if (isSuperVisor && sender.tag == 8) {
        txtkey = @"comments";
    } else if (isSuperVisor && sender.tag == 9) {
        txtkey = @"tubing";
    } else if (isSuperVisor && sender.tag == 10) {
        txtkey = @"rods";
    }
    strCommentsKey = txtkey;
    aryInvoiceForComments = dicInvoicesForLastComments[txtkey];
    [self.tblComments reloadData];
    [self showCommentsListView:YES];
}

@end
