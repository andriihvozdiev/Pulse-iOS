#import "InvoiceDetailVC.h"

#import "InvoiceDetailFieldCell.h"
#import "InvoiceDetailOfficeCell.h"
#import "SelectAccountVC.h"
#import "NewInvoiceVC.h"
#import "BFRImageViewController.h"
#import "DetailInvoiceImageCollectionViewCell.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface InvoiceDetailVC ()
{
    NSMutableArray *arrSectionStatus;
    BOOL isEditable;
    BOOL isFullEdit;
    Personnel *user;
    BOOL isSuperVisior;
    NSMutableArray *aryImages;
}
@end

@implementation InvoiceDetailVC
@synthesize invoice;
@synthesize arrInvoicesDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int userid = [[[NSUserDefaults standardUserDefaults] valueForKey:S_UserID] intValue];
    user = [[DBManager sharedInstance] getPersonnel:userid];
    
    self.btnEdit.layer.cornerRadius = 3.0f;
    self.btnEditComment.layer.cornerRadius = 3.0f;
    
    isEditable = NO;
    isFullEdit = NO;
    [self.imgEditable setHidden:YES];
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.underlineCenterConstraint.constant = -screenSize.width / 4;
    
    self.btnApprove.layer.cornerRadius = 3.0f;
    self.btnEditAll.layer.cornerRadius = 3.0f;
    self.viewPrimary.layer.cornerRadius = 5.0f;
    self.viewSecondary.layer.cornerRadius = 5.0f;
    self.viewOutside.layer.cornerRadius = 5.0f;
    self.viewNobill.layer.cornerRadius = 5.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // add new invoices...
    if (![AppData sharedInstance].isEdit) {
        for (int i = 0; i < [AppData sharedInstance].arrSelectedAccounts.count; i++) {
            
            NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedAccounts[i] integerValue];
            InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[selectedIndex];
            
            NSString *acctTime = [AppData sharedInstance].arrSelectedAccountTimes[i];
            NSString *acctTimeUnit = [AppData sharedInstance].arrSelectedAccountTimeUnits[i];
            
            NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
            [dicParam setValue:[NSNumber numberWithInt:invoice.invoiceID] forKey:@"invoiceID"];
            [dicParam setValue:invoice.invoiceAppID forKey:@"invoiceAppID"];
            [dicParam setValue:[NSNumber numberWithInt:accountData.acctID] forKey:@"acctID"];
            [dicParam setValue:[NSNumber numberWithInt:accountData.subAcctID] forKey:@"subAcctID"];
            [dicParam setValue:acctTime forKey:@"acctTime"];
            [dicParam setValue:acctTimeUnit forKey:@"acctUnit"];
            
            [[DBManager sharedInstance] addInvoiceAccount:dicParam];
            
        }
    } else {
        [AppData sharedInstance].isEdit = NO;
    }
    
    isSuperVisior = NO;
    for (int i = 0; i < [AppData sharedInstance].arrSelectedAccounts.count; i++) {
        
        NSInteger selectedIndex = [[AppData sharedInstance].arrSelectedAccounts[i] integerValue];
        InvoiceAccounts *accountData = [AppData sharedInstance].arrAccounts[selectedIndex];
        if (accountData.acctID == 11 || accountData.acctID == 14) {
            isSuperVisior = YES;
        }
    }
    [self initView];    
}

#pragma mark -

-(void) initView
{
    [self.fieldView setHidden:YES];
    [self.officeView setHidden:YES];
    [self.viewFieldTitle setHidden:YES];
    [self.viewOfficeTitle setHidden:YES];
    
    switch ([AppData sharedInstance].invoiceApprovalType) {
        case Field:
            [self.fieldView setHidden:NO];
            [self.viewFieldTitle setHidden:NO];
            self.titleViewHeightContraint.constant = 44;
            [self.view layoutIfNeeded];
            [self switchTab];
            break;
        case Office:
            [self.officeView setHidden:NO];
            [self.viewOfficeTitle setHidden:NO];
            self.titleViewHeightContraint.constant = 48;
            [self.view layoutIfNeeded];
            [self switchTab];
            break;
        default:
            break;
    }
    
    if (invoice.invoiceID != 0) {
        invoice = [[DBManager sharedInstance] getInvoice:invoice.invoiceID withAppID:invoice.invoiceAppID];
    }
    
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M/d/yy h:mm a"];
    
    self.lblLease.text = [[DBManager sharedInstance] getLeaseNameFromPropNum:invoice.lease];
    self.lblWellNumber.text = invoice.wellNumber == nil ? @"-" : invoice.wellNumber;
    self.lblUser.text = [[DBManager sharedInstance] getUserName:invoice.userid];
    self.lblDate.text = [dateformatter stringFromDate:invoice.invoiceDate];
    self.lblWorkers.text = @"";
    self.imgViewInvoiceImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgViewInvoiceImage.layer.borderWidth = 1.0;
    self.imgViewInvoiceImage.layer.cornerRadius = 3.0f;
//    if (invoice.invoiceImage != nil) {
//        [self.lblNoImage setHidden:YES];
//        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:invoice.invoiceImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        [self.imgViewInvoiceImage setImage:[UIImage imageWithData:imageData]];
//
//    }
    NSArray *arrPeoples = [[DBManager sharedInstance] getInvoicePersonnel:invoice.invoiceID appID:invoice.invoiceAppID];
    if (arrPeoples.count > 0) {
        InvoicesPersonnel *invoicePersonnel = arrPeoples[0];
        NSString *strWorkers = [[DBManager sharedInstance] getUserName:invoicePersonnel.userID];
        
        for (int i = 1; i < arrPeoples.count; i++) {
            invoicePersonnel = arrPeoples[i];
            NSString *strPeople = [[DBManager sharedInstance] getUserName:invoicePersonnel.userID];
            strWorkers = [NSString stringWithFormat:@"%@\n%@", strWorkers, strPeople];
        }        
        self.lblWorkers.text = strWorkers;
    }
    
    NSString *comments = invoice.comments;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect commentRect = [comments boundingRectWithSize:CGSizeMake(screenWidth - 60, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.lblComment.font} context:nil];
    if (commentRect.size.height < 28) {
        self.commentHeightConstraint.constant = 28;
        [self.lblComment setScrollEnabled:NO];
    } else if (commentRect.size.height < 70){
        self.commentHeightConstraint.constant = commentRect.size.height + 20;
        [self.lblComment setScrollEnabled:NO];
    } else {
        self.commentHeightConstraint.constant = 80;
        [self.lblComment setScrollEnabled:YES];
    }
    
    if (comments && ![comments isEqual:@""]) {
        self.lblComment.text = comments;
        self.lblComment.textColor = [UIColor whiteColor];
    } else {
        self.lblComment.text = @"No Comment";
        self.lblComment.textColor = [UIColor lightGrayColor];
    }
//    [self.lblComment scrollRangeToVisible:NSMakeRange(0, 0)];
    
    [self.btnEdit setTitle:@"Edit Accounts" forState:UIControlStateNormal];
    [self.btnEdit setEnabled:YES];
    
//    switch ([AppData sharedInstance].invoiceApprovalType) {
//        case Field:
//            if (invoice.export) {
//                [self.btnEdit setTitle:@"Can't Edit" forState:UIControlStateNormal];
//                [self.btnEdit setEnabled:NO];
//                isEditable = NO;
//            }
//            break;
//        case Office:
//            if (invoice.export || (!(user.primaryApp) && !(user.secondaryApp))) {
//                [self.btnEdit setTitle:@"Can't Edit" forState:UIControlStateNormal];
//                [self.btnEdit setEnabled:NO];
//                isEditable = NO;
//            }
//            break;
//        default:
//            break;
//    }
    
    
    if (isEditable) {
        [self.imgEditable setHidden:NO];
        [self.btnAddField setHidden:NO];
        [self.btnAddOffice setHidden:NO];
    } else {
        [self.imgEditable setHidden:YES];
        [self.btnAddField setHidden:YES];
        [self.btnAddOffice setHidden:YES];
    }
    
    [self setApprovalButtonTitle];
    [self setPrimaryButtonTitle];
    [self setSecondaryButtonTitle];
    [self setOutsideBillButtonTitle];
    [self setNoBillButtonTitle];
    
    // get accounts array
    arrInvoicesDetail = [[DBManager sharedInstance] getInvoiceDetail:invoice.invoiceID appID:invoice.invoiceAppID];
    [self.tableView reloadData];
    
    // truncate the image area, if nothing
    if (invoice.invoiceImages == nil || invoice.invoiceImages.count == 0) {
        self.constCommentViewTop.constant = 40.0;
    }
    if (invoice.dailyCost == nil || [invoice.dailyCost isEqualToString:@""] || [invoice.dailyCost floatValue] == 0.0) {
        self.lblDailyCost.text = @"$ -";
    } else {
        self.lblDailyCost.text = [NSString stringWithFormat:@"$%.02f", [invoice.dailyCost floatValue]];
    }
    if (invoice.totalCost == nil || [invoice.totalCost isEqualToString:@""] || [invoice.totalCost floatValue] == 0.0) {
        self.lblTotalCost.text = @"$ -";
    } else {
        self.lblTotalCost.text = [NSString stringWithFormat:@"$%.02f", [invoice.totalCost floatValue]];
    }
}

- (IBAction)onPreviewImage:(UIButton *)sender {
    
    NSMutableArray *aryImages = [[NSMutableArray alloc] init];
    NSArray *aryImagesStr = invoice.invoiceImages;
    
    for (NSDictionary* imgDic in aryImagesStr) {
        NSString *imgStr = imgDic[@"Image"];
        if ([imgStr rangeOfString:@"invoiceimageurl"].location == NSNotFound) {
                    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *image = [UIImage imageWithData:imageData];
            [aryImages addObject:image];
        } else {
            NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, imgStr];
            [aryImages addObject:url_str];
        }
        
    }
    
    
    BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:[aryImages copy]];
    imageVC.startingIndex = sender.tag;
    [self presentViewController:imageVC animated:YES completion:nil];
}

-(void) switchTab
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    switch ([AppData sharedInstance].invoiceApprovalType) {
        case Field:
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.underlineView shakeWithWidth:2.5f];
            }];
            [self.btnField setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnOffice setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            break;
        }
        case Office:
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.underlineCenterConstraint.constant = screenSize.width / 4.0f;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.underlineView shakeWithWidth:2.5f];
            }];
            [self.btnField setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btnOffice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

-(void) setApprovalButtonTitle
{
    if (invoice.approval0) {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"M/d/YY h:mm a"];
        
        NSString *approvalDt0 = [dateformatter stringFromDate:invoice.approvalDt0];
        int app0Emp = invoice.app0Emp == nil ? 0 : [invoice.app0Emp intValue];
        NSString *username = [[DBManager sharedInstance] getUserName:app0Emp];
        NSString *btnTitle = [NSString stringWithFormat:@"APPROVED: %@, %@", [self getShortName:username], approvalDt0];
        
        [self.btnApprove setTitle:btnTitle forState:UIControlStateNormal];
    } else {
        [self.btnApprove setTitle:@"APPROVE" forState:UIControlStateNormal];
    }
}

-(void) setPrimaryButtonTitle
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd/yy"];
    
    UIColor *redColor = [UIColor colorWithRed:1 green:141/255.0f blue:138/255.0f alpha:1];
    UIColor *greenColor = [UIColor greenColor];
    
    if (invoice.approval1) {
        NSString *approvalDt1 = [dateformatter stringFromDate:invoice.approvalDt1];
        int app1Emp = invoice.app1Emp == nil ? 0 : [invoice.app1Emp intValue];
        NSString *username = [[DBManager sharedInstance] getUserName:app1Emp];
        
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : greenColor };
        
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"Primary" attributes:dicAttributes];
        
        font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:12.0];
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        NSMutableAttributedString *strDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", approvalDt1] attributes:dicAttributes];
        NSMutableAttributedString *strName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", [self getShortName:username]] attributes:dicAttributes];
        
        [strTitle appendAttributedString:strDate];
        [strTitle appendAttributedString:strName];
        
        self.lblPrimaryTitle.attributedText = strTitle;
        
    } else {
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : redColor };
        
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"Primary" attributes:dicAttributes];
        
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        NSMutableAttributedString *strApproval = [[NSMutableAttributedString alloc]initWithString:@"\nApproval" attributes:dicAttributes];
        [strTitle appendAttributedString:strApproval];
        
        self.lblPrimaryTitle.attributedText = strTitle;
    }
}

-(void) setSecondaryButtonTitle
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd/yy"];
    
    UIColor *redColor = [UIColor colorWithRed:1 green:141/255.0f blue:138/255.0f alpha:1];
    UIColor *greenColor = [UIColor greenColor];
    
    if (invoice.approval2) {
        NSString *approvalDt2 = [dateformatter stringFromDate:invoice.approvalDt2];
        int app2Emp = invoice.app2Emp == nil ? 0 : [invoice.app2Emp intValue];
        NSString *username = [[DBManager sharedInstance] getUserName:app2Emp];
        
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : greenColor };
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"Secondary" attributes:dicAttributes];
        
        font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:12.0];
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSMutableAttributedString *strDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", approvalDt2] attributes:dicAttributes];
        NSMutableAttributedString *strName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", [self getShortName:username]] attributes:dicAttributes];
        [strTitle appendAttributedString:strDate];
        [strTitle appendAttributedString:strName];
        
        self.lblSecondaryTitle.attributedText = strTitle;
        
    } else {
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : redColor };
        
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"Secondary" attributes:dicAttributes];
        
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        NSMutableAttributedString *strApproval = [[NSMutableAttributedString alloc]initWithString:@"\nApproval" attributes:dicAttributes];
        [strTitle appendAttributedString:strApproval];
        
        self.lblSecondaryTitle.attributedText = strTitle;
    }
}

-(void) setOutsideBillButtonTitle
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd/yy"];
    
    UIColor *redColor = [UIColor colorWithRed:1 green:141/255.0f blue:138/255.0f alpha:1];
    UIColor *greenColor = [UIColor greenColor];
    
    if (invoice.outsideBill) {
        NSString *outsideBillDt = [dateformatter stringFromDate:invoice.outsideBillDt];
        int outsideBillEmp = invoice.outsideBillEmp == nil ? 0 : [invoice.outsideBillEmp intValue];
        NSString *username = [[DBManager sharedInstance] getUserName:outsideBillEmp];
        
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : greenColor };
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"Outside Bill" attributes:dicAttributes];
        
        font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:12.0];
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSMutableAttributedString *strDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", outsideBillDt] attributes:dicAttributes];
        NSMutableAttributedString *strName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", [self getShortName:username]] attributes:dicAttributes];
        
        [strTitle appendAttributedString:strDate];
        [strTitle appendAttributedString:strName];
        
        self.lblOutsideTitle.attributedText = strTitle;
        
    } else {
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : redColor };
        
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"Outside Bill" attributes:dicAttributes];
        
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        NSMutableAttributedString *strApproval = [[NSMutableAttributedString alloc]initWithString:@"\nApproval" attributes:dicAttributes];
        [strTitle appendAttributedString:strApproval];
        
        self.lblOutsideTitle.attributedText = strTitle;
    }
}

-(void) setNoBillButtonTitle
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd/yy"];
    
    UIColor *redColor = [UIColor colorWithRed:1 green:141/255.0f blue:138/255.0f alpha:1];
    UIColor *greenColor = [UIColor greenColor];
    
    if (invoice.noBill) {
        NSString *noBillDt = [dateformatter stringFromDate:invoice.noBillDt];
        int noBillEmp = invoice.noBillEmp == nil ? 0 : [invoice.noBillEmp intValue];
        NSString *username = [[DBManager sharedInstance] getUserName:noBillEmp];
        
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : greenColor };
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"No Bill" attributes:dicAttributes];
        
        font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:12.0];
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSMutableAttributedString *strDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", noBillDt] attributes:dicAttributes];
        NSMutableAttributedString *strName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", [self getShortName:username]] attributes:dicAttributes];
        
        [strTitle appendAttributedString:strDate];
        [strTitle appendAttributedString:strName];
        
        self.lblNobillTitle.attributedText = strTitle;
    } else {
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        
        NSDictionary *dicAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName : redColor };
        
        NSMutableAttributedString *strTitle = [[NSMutableAttributedString alloc]initWithString:@"No Bill" attributes:dicAttributes];
        
        dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        NSMutableAttributedString *strApproval = [[NSMutableAttributedString alloc]initWithString:@"\nApproval" attributes:dicAttributes];
        [strTitle appendAttributedString:strApproval];
        
        self.lblNobillTitle.attributedText = strTitle;
    }
}

-(NSString *) getShortName:(NSString*)fullName
{
    NSArray *arrSeparatedName = [fullName componentsSeparatedByString:@" "];
    if (arrSeparatedName.count < 2) {
        return fullName;
    }
    NSString *firstName = [arrSeparatedName objectAtIndex:0];
    NSString *lastName = [fullName substringFromIndex:[fullName rangeOfString:firstName].length + 1];
    NSString *shortName = [[firstName substringToIndex:1] uppercaseString];
    shortName = [NSString stringWithFormat:@"%@. %@", shortName, lastName];
    
    return shortName;
}

#pragma mark - tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrInvoicesDetail.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    InvoicesDetail *invoiceDetail = arrInvoicesDetail[row];
    
    int acctID = invoiceDetail.account;
    int subAcctID = invoiceDetail.accountSub;
    float acctTime = invoiceDetail.accountTime != nil ? [invoiceDetail.accountTime floatValue] : 0.0f;
    NSString *acctTimeStr = [NSString stringWithFormat:@"%.2f", acctTime];
    NSString *acctUnit = invoiceDetail.accountUnit;
    
    InvoiceAccounts *account = [[DBManager sharedInstance] getAccount:acctID withSub:subAcctID];
    NSString *strAccount = [NSString stringWithFormat:@"%@ - %@", account.account, account.subAccount];
    if (!account.subAccount) {
        strAccount = account.account;
    }
    
    switch ([AppData sharedInstance].invoiceApprovalType) {
        case Field:
        {
            InvoiceDetailFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceDetailFieldCell" forIndexPath:indexPath];
            cell.lblAccount.text = strAccount;
            cell.lblUnits.text = [NSString stringWithFormat:@"%@ %@", acctTimeStr, acctUnit];
            
            return cell;
            break;
        }
        case Office:
        {
            InvoiceDetailOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceDetailOfficeCell" forIndexPath:indexPath];
            cell.lblAccount.text = strAccount;
            cell.lblUnits.text = [NSString stringWithFormat:@"%@ %@", acctTimeStr, acctUnit];
            
            cell.lblExpRef.text = account.wpExpReference;
            cell.lblExpJrnl.text = account.wpExpJournal;
            cell.lblExpAcct.text = account.wpExpAcct;
            
            cell.lblIncRef.text = account.wpIncReference;
            cell.lblIncJrnl.text = account.wpIncJournal;
            cell.lblIncAcct.text = account.wpIncAcct;
            cell.lblIncSubAcct.text = account.wpIncSubAcct;
            
            return cell;
            break;
        }
        default:
            break;
    }
    
    return nil;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44;
    switch ([AppData sharedInstance].invoiceApprovalType) {
        case Field:
            height = 44;
            break;
        case Office:
            height = 74;
            break;
        default:
            break;
    }
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return isEditable;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger row = [indexPath row];
        
        InvoicesDetail *invoiceDetail = arrInvoicesDetail[row];
        NSNumber *acctID = [NSNumber numberWithInt:invoiceDetail.account];
        NSNumber *subAcctID = [NSNumber numberWithInt:invoiceDetail.accountSub];
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setValue:[NSNumber numberWithInt:invoice.invoiceID] forKey:@"invoiceID"];
        [dicParam setValue:invoice.invoiceAppID forKey:@"invoiceAppID"];
        [dicParam setValue:invoice.lease forKey:@"lease"];
        [dicParam setValue:invoice.wellNumber forKey:@"wellNumber"];
        [dicParam setValue:[NSNumber numberWithInt:invoice.userid] forKey:@"userid"];
        [dicParam setValue:acctID forKey:@"acctID"];
        [dicParam setValue:subAcctID forKey:@"subAcctID"];
        
        NSLog(@"%@", dicParam);
        
        if (arrInvoicesDetail.count == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"If delete last account, this invoice will be deleted.\nAre you sure delete this invoice?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([[DBManager sharedInstance] removeAccountFromInvoice:dicParam]) {
                    
                    arrInvoicesDetail = [[DBManager sharedInstance] getInvoiceDetail:invoice.invoiceID appID:invoice.invoiceAppID];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [tableView reloadData];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    
                    [self showDefaultAlert:@"Failed remove Account" message:nil];
                }
            }];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:yesAction];
            [alertController addAction:noAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            if ([[DBManager sharedInstance] removeAccountFromInvoice:dicParam]) {
                
                arrInvoicesDetail = [[DBManager sharedInstance] getInvoiceDetail:invoice.invoiceID appID:invoice.invoiceAppID];
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                [tableView reloadData];
                
            } else {
                
                [self showDefaultAlert:@"Failed remove Account" message:nil];
            }
            
        }
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditable)
    {
        NSString *strAccount = @"";
        switch ([AppData sharedInstance].invoiceApprovalType) {
            case Field:
            {
                InvoiceDetailFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                strAccount = cell.lblAccount.text;
                break;
            }
            case Office:
            {
                InvoiceDetailOfficeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                strAccount = cell.lblAccount.text;
                break;
            }
            default:
                break;
        }
        
        
        NSInteger row = [indexPath row];
        
        InvoicesDetail *invoiceDetail = arrInvoicesDetail[row];
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setValue:[NSNumber numberWithInt:invoice.invoiceID] forKey:@"invoiceID"];
        [dicParam setValue:invoice.invoiceAppID forKey:@"invoiceAppID"];
        [dicParam setValue:[NSNumber numberWithInt:invoiceDetail.account] forKey:@"acctID"];
        [dicParam setValue:[NSNumber numberWithInt:invoiceDetail.accountSub] forKey:@"subAcctID"];
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:strAccount
                                              message:@"Please enter AccountTime"
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = NSLocalizedString(invoiceDetail.accountTime, @"AccountTime");
             textField.keyboardType = UIKeyboardTypeDecimalPad;
         }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *txtAccountTime = alertController.textFields.firstObject;
            NSString *strAcctTime = txtAccountTime.text;
            if ([self isNumeric:strAcctTime]) {
                
                [dicParam setValue:strAcctTime forKey:@"acctTime"];
                
                if ([[DBManager sharedInstance] changeAccountTime:dicParam]) {
                    
                    arrInvoicesDetail = [[DBManager sharedInstance] getInvoiceDetail:invoice.invoiceID appID:invoice.invoiceAppID];
                    
                    [tableView reloadData];
                }
                
            } else {
                [self showDefaultAlert:@"Wrong Value" message:@"Please input numerical value"];
            }
            
            [tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
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
- (IBAction)onField:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    [self.btnField setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnOffice setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [AppData sharedInstance].invoiceApprovalType = Field;
    [self initView];
}

- (IBAction)onOffice:(id)sender {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.underlineView shakeWithWidth:2.5f];
    }];
    [self.btnField setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnOffice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [AppData sharedInstance].invoiceApprovalType = Office;
    [self initView];
    
}

- (IBAction)onEditField:(id)sender {
    NewInvoiceVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewInvoiceVC"];
    vc.isEdit = YES;
    vc.invoice = self.invoice;
    NSLog(@"%@", [AppData sharedInstance].arrSelectedAccounts);
    [AppData sharedInstance].isEdit = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onEdit:(id)sender {
    
//    if (invoice.export) {
//        isEditable = NO;
//        return;
//    }
    
    isEditable = !isEditable;
    if (isEditable) {
        [self.imgEditable setHidden:NO];
        [self.btnAddField setHidden:NO];
        [self.btnAddOffice setHidden:NO];
    } else {
        [self.imgEditable setHidden:YES];
        [self.btnAddField setHidden:YES];
        [self.btnAddOffice setHidden:YES];
    }
    
    [self.tableView reloadData];
}


- (IBAction)onApprove:(id)sender {
    
    if (invoice.export) {
        [self showDefaultAlert:nil message:@"You cannot approve."];
        return;
    }
    
    if (invoice.approval0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you unapprove?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self unApprove:0];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self approve:0];
    }
    
}

- (IBAction)onAddField:(id)sender {
    
    SelectAccountVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectAccountVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -
-(IBAction)onAddOffice:(id)sender {
    SelectAccountVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectAccountVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPrimary:(id)sender {
    
    if (invoice.export || !(user.primaryApp)) {
        [self showDefaultAlert:nil message:@"You cannot approve."];
        return;
    }
    
    
    if (invoice.approval1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you unapprove?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self unApprove:1];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self approve:1];
    }
}

- (IBAction)onSecondary:(id)sender {
    if (invoice.export || !(user.secondaryApp)) {
        [self showDefaultAlert:nil message:@"You cannot approve."];
        return;
    }
    
    if (invoice.approval2) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you unapprove?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self unApprove:2];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self approve:2];
    }
}

- (IBAction)onOutside:(id)sender {
    if (invoice.export || !(user.outsideBillApp)) {
        [self showDefaultAlert:nil message:@"You cannot approve."];
        return;
    }
    
    if (invoice.outsideBill) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you unapprove?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self unApprove:3];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self approve:3];
    }
}

- (IBAction)onNobill:(id)sender {
    if (invoice.export || !(user.noBillApp)) {
        [self showDefaultAlert:nil message:@"You cannot approve."];
        return;
    }
    
    
    if (invoice.noBill) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you unapprove?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self unApprove:4];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self approve:4];
    }
}


#pragma mark -
-(void) unApprove:(int)index
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/YY hh:mm a"];
    
    NSMutableDictionary *dicData = [self approvalDictionary];
    
    switch (index) {
        case 0: // approval0
            [dicData setValue:[NSNumber numberWithBool:NO] forKey:@"approval0"];
            [dicData setValue:nil forKey:@"approvalDt0"];
            [dicData setValue:nil forKey:@"app0Emp"];
            break;
        case 1: // approval1
            [dicData setValue:[NSNumber numberWithBool:NO] forKey:@"approval1"];
            [dicData setValue:nil forKey:@"approvalDt1"];
            [dicData setValue:nil forKey:@"app1Emp"];
            break;
        case 2: // approval2
            [dicData setValue:[NSNumber numberWithBool:NO] forKey:@"approval2"];
            [dicData setValue:nil forKey:@"approvalDt2"];
            [dicData setValue:nil forKey:@"app2Emp"];
            break;
        case 3: // Outside
            [dicData setValue:[NSNumber numberWithBool:NO] forKey:@"outsideBill"];
            [dicData setValue:nil forKey:@"outsideBillDt"];
            [dicData setValue:nil forKey:@"outsideBillEmp"];
            break;
        case 4: // No Bill
            [dicData setValue:[NSNumber numberWithBool:NO] forKey:@"noBill"];
            [dicData setValue:nil forKey:@"noBillDt"];
            [dicData setValue:nil forKey:@"noBillEmp"];
            break;
        default:
            break;
    }
    
    if ([[DBManager sharedInstance] changeInvoice:dicData]) {
        [self initView];
    }
}

-(void) approve:(int)index
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    // hh:mm a
    
    NSMutableDictionary *dicData = [self approvalDictionary];
    
    switch (index) {
        case 0: // approval0
            [dicData setValue:[NSNumber numberWithBool:YES] forKey:@"approval0"];
            [dicData setValue:[NSDate date] forKey:@"approvalDt0"];
            [dicData setValue:[NSString stringWithFormat:@"%d", user.userid] forKey:@"app0Emp"];
            break;
        case 1: // approval1
            [dicData setValue:[NSNumber numberWithBool:YES] forKey:@"approval1"];
            [dicData setValue:[NSDate date] forKey:@"approvalDt1"];
            [dicData setValue:[NSString stringWithFormat:@"%d", user.userid] forKey:@"app1Emp"];
            break;
        case 2: // approval2
            [dicData setValue:[NSNumber numberWithBool:YES] forKey:@"approval2"];
            [dicData setValue:[NSDate date] forKey:@"approvalDt2"];
            [dicData setValue:[NSString stringWithFormat:@"%d", user.userid] forKey:@"app2Emp"];
            break;
        case 3: // Outside
            [dicData setValue:[NSNumber numberWithBool:YES] forKey:@"outsideBill"];
            [dicData setValue:[NSDate date] forKey:@"outsideBillDt"];
            [dicData setValue:[NSString stringWithFormat:@"%d", user.userid] forKey:@"outsideBillEmp"];
            break;
        case 4: // No Bill
            [dicData setValue:[NSNumber numberWithBool:YES] forKey:@"noBill"];
            [dicData setValue:[NSDate date] forKey:@"noBillDt"];
            [dicData setValue:[NSString stringWithFormat:@"%d", user.userid] forKey:@"noBillEmp"];
            break;
        default:
            break;
    }
    
    if ([[DBManager sharedInstance] changeInvoice:dicData]) {
        [self initView];
    }
    
}

-(NSMutableDictionary*) approvalDictionary
{
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    
    [dicData setValue:[NSNumber numberWithInt:invoice.invoiceID] forKey:@"invoiceID"];
    [dicData setValue:invoice.invoiceAppID forKey:@"invoiceAppID"];
    
    [dicData setValue:[NSNumber numberWithBool:invoice.approval0] forKey:@"approval0"];
    [dicData setValue:invoice.approvalDt0 forKey:@"approvalDt0"];
    [dicData setValue:invoice.app0Emp forKey:@"app0Emp"];
    
    [dicData setValue:[NSNumber numberWithBool:invoice.approval1] forKey:@"approval1"];
    [dicData setValue:invoice.approvalDt1 forKey:@"approvalDt1"];
    [dicData setValue:invoice.app1Emp forKey:@"app1Emp"];
    
    [dicData setValue:[NSNumber numberWithBool:invoice.approval2] forKey:@"approval2"];
    [dicData setValue:invoice.approvalDt2 forKey:@"approvalDt2"];
    [dicData setValue:invoice.app2Emp forKey:@"app2Emp"];
    
    [dicData setValue:[NSNumber numberWithBool:invoice.outsideBill] forKey:@"outsideBill"];
    [dicData setValue:invoice.outsideBillDt forKey:@"outsideBillDt"];
    [dicData setValue:invoice.outsideBillEmp forKey:@"outsideBillEmp"];
    
    [dicData setValue:[NSNumber numberWithBool:invoice.noBill] forKey:@"noBill"];
    [dicData setValue:invoice.noBillDt forKey:@"noBillDt"];
    [dicData setValue:invoice.noBillEmp forKey:@"noBillEmp"];
    
    return dicData;
}


#pragma mark - show default alert
-(void) showDefaultAlert:(NSString*)title message:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark-UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailInvoiceImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailInvoiceImageCollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1111];
    NSString *imgStr = ((NSDictionary*)invoice.invoiceImages[indexPath.row])[@"Image"];
    
    if ([imgStr rangeOfString:@"invoiceimageurl"].location == NSNotFound) {
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        [imageView setImage:[UIImage imageWithData:imageData]];
    } else {
        NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, imgStr];
//        [imageView setImageWithURL:[NSURL URLWithString:url_str]];
        [imageView setImageWithURL:[NSURL URLWithString:url_str] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    imageView.layer.borderColor =[UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 1.0;
    imageView.layer.cornerRadius = 3.0;
    
    cell.btnSelectImage.tag = indexPath.row;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (invoice.invoiceImages != nil) {
        return invoice.invoiceImages.count;
    } else {
        return 0;
    }
}

@end
