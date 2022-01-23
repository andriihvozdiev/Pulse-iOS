#import "RigReportsDetailVC.h"
#import "RigReportsDetailHeaderCell.h"
#import "RigReportsDetailContentCell.h"

#import "NewRigReportsRodVC.h"
#import "NewRigReportsPumpVC.h"
#import "NewRigReportsTubingVC.h"
#import "BFRImageViewController.h"
#import "DetailRigImageCollectionViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ProductionMainPopupCommentsCell.h"

@interface RigReportsDetailVC ()
{
    BOOL isOut;
    BOOL isEditable;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCommentTblTop;
@property (weak, nonatomic) IBOutlet UIView *viewImageContainer;
@end

@implementation RigReportsDetailVC
@synthesize rigReports;

@synthesize arrRigReportsRods;
@synthesize arrRigReportsPump;
@synthesize arrRigReportsTubing;

@synthesize arrComments;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnEdit.layer.cornerRadius = 3.0f;
    
    arrComments = [[NSMutableArray alloc] init];
    
    isOut = NO;
    isEditable = NO;
    [self.imgEditable setHidden:YES];
    [self.lblEditable setHidden:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.commentTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.imgViewRig.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgViewRig.layer.borderWidth = 1.0;
    self.imgViewRig.layer.cornerRadius = 3.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.lblLease.text = [[DBManager sharedInstance] getLeaseNameFromLease:rigReports.lease];
    self.lblWellNumber.text = rigReports.wellNum;
    self.lblCompany.text = rigReports.company;
    
    self.lblUser.text = [[DBManager sharedInstance] getUserName:rigReports.entryUser];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"hh:mm a"];
    
    NSString *strGaugeDate = [df stringFromDate:rigReports.reportDate];
    NSString *strGaugeTime = [tf stringFromDate:rigReports.reportDate];
    if (rigReports.dailyCost == nil || [rigReports.dailyCost isEqualToString:@""] || [rigReports.dailyCost floatValue] == 0.0f) {
            self.lblDailyCost.text = @"$ -";
    } else {
        float cost = [rigReports.dailyCost floatValue];
        self.lblDailyCost.text = [NSString stringWithFormat:@"$%.02f", cost];
    }
    
    if (rigReports.totalCost == nil || [rigReports.totalCost isEqualToString:@""] || [rigReports.totalCost floatValue] == 0.0f) {
        self.lblTotalCost.text = @"$ -";
    } else {
        float cost = [rigReports.totalCost floatValue];
        self.lblTotalCost.text = [NSString stringWithFormat:@"$%.02f", cost];
    }
    self.lblDate.text = strGaugeDate;
    self.lblTime.text = strGaugeTime;
    
    [self initData];
    
    if (rigReports.rigImages == nil || rigReports.rigImages.count == 0) {
        
        self.constCommentTblTop.constant = 0;
        self.viewImageContainer.hidden = YES;
    }
}


#pragma mark -
-(void) initData
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    arrComments = [[NSMutableArray alloc] init];
    if (rigReports.comments && ![rigReports.comments isEqual:@""]) {
        NSDictionary *dic = @{@"title": @"Comments", @"comment": rigReports.comments};
        [arrComments addObject:dic];
    }
    if (rigReports.tubing && ![rigReports.tubing isEqual:@""]) {
        NSDictionary *dic = @{@"title": @"Tubing Comments", @"comment": rigReports.tubing};
        [arrComments addObject:dic];
    }
    if (rigReports.rods && ![rigReports.rods isEqual:@""]) {
        NSDictionary *dic = @{@"title": @"Rods Comments", @"comment": rigReports.rods};
        [arrComments addObject:dic];
    }
    [self.commentTableview reloadData];
    
    if (isOut) {
        self.underlineCenterConstraint.constant = screenSize.width / 4.0f;
        
        arrRigReportsRods = [[DBManager sharedInstance] getRigReportsRods:rigReports.reportID inOut:YES withAppID:rigReports.reportAppID];
        arrRigReportsTubing = [[DBManager sharedInstance] getRigReportsTubing:rigReports.reportID inOut:YES withAppID:rigReports.reportAppID];
        arrRigReportsPump = [[DBManager sharedInstance] getRigReportsPump:rigReports.reportID inOut:YES withAppID:rigReports.reportAppID];
    } else {
        self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
        
        arrRigReportsRods = [[DBManager sharedInstance] getRigReportsRods:rigReports.reportID inOut:NO withAppID:rigReports.reportAppID];
        arrRigReportsTubing = [[DBManager sharedInstance] getRigReportsTubing:rigReports.reportID inOut:NO withAppID:rigReports.reportAppID];
        arrRigReportsPump = [[DBManager sharedInstance] getRigReportsPump:rigReports.reportID inOut:NO withAppID:rigReports.reportAppID];
    }
    //TODO for multiple
//    if (rigReports.rigImage != nil) {
//        [self.lblNoImage setHidden:YES];
//        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:rigReports.rigImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        [self.imgViewRig setImage:[UIImage imageWithData:imageData]];
//    }
    [self.tableView reloadData];
}

- (IBAction)onPreviewImage:(id)sender {
    //TODO for multiple
//    if (rigReports.rigImage == nil)
//        return;
//    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:rigReports.rigImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *image = [UIImage imageWithData:imageData];
//    BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[image]];
//    [self presentViewController:imageVC animated:YES completion:nil];
}

#pragma mark - moving table view cells

-(IBAction)longPressGestureRecognized:(id)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer*)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView *snapshot = nil;  // A snapshot of the row user is moving.
    static NSIndexPath *sourceIndexPath = nil; // Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            {
                if (indexPath) {
                    sourceIndexPath = indexPath;
                    
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    
                    // Take a snapshot of the selected row using helper method.
                    snapshot = [self customSnapshotFromView:cell];
                    
                    // Add the snapshot as subview, centered at cell's center...
                    __block CGPoint center = cell.center;
                    snapshot.center = center;
                    snapshot.alpha = 0.0;
                    [self.tableView addSubview:snapshot];
                    [UIView animateWithDuration:0.25f animations:^{
                        
                        // Offset for gesture location.
                        center.y = location.y;
                        snapshot.center = center;
                        snapshot.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
                        snapshot.alpha = 0.98f;
                        
                        // Fade out.
                        cell.alpha = 0.0f;
                        
                    } completion:^(BOOL finished) {
                        cell.hidden = YES;
                    }];
                    
                }
                break;
            }
        case UIGestureRecognizerStateChanged:
            {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                
                // Is destination valid and is it different from source?
                if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.section == sourceIndexPath.section) {
                    
                    // ... update data source.
                    switch (sourceIndexPath.section) {
                        case 0:
                            [arrRigReportsRods exchangeObjectAtIndex:[indexPath row] withObjectAtIndex:[sourceIndexPath row]];
                            break;
                        case 1:
                            [arrRigReportsTubing exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                            break;
                        case 2:
                            [arrRigReportsPump exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                            break;
                        default:
                            break;
                    }
                    
                    // ... move the rows.
                    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    
                    // ... and update source so it is in sync with UI changes.
                    sourceIndexPath = indexPath;
                    
                }
                break;
            }
        case UIGestureRecognizerStateEnded:
        {
                // ... update data source.
            switch (sourceIndexPath.section) {
                case 0:
                    [[DBManager sharedInstance] changeRodOrders:arrRigReportsRods];
                    break;
                case 1:
                    [[DBManager sharedInstance] changeTubingOrders:arrRigReportsTubing];
                    break;
                case 2:
                    [[DBManager sharedInstance] changePumpOrders:arrRigReportsPump];
                    break;
                default:
                    break;
                }
            
            [snapshot removeFromSuperview];
            [self.tableView reloadData];
            break;
        }
        default:
        {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25f animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0f;
                
                // Undo fade out.
                cell.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            
            break;
        }
            
    }
    
}


-(UIView*) customSnapshotFromView:(UIView*)inputView
{
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0f;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (IBAction)onSelectImage:(UIButton*)sender {
    
    NSMutableArray *aryImages = [[NSMutableArray alloc] init];
    NSArray *aryImagesStr = rigReports.rigImages;
    
    for (NSDictionary* imgDic in aryImagesStr) {
        NSString *imgStr = imgDic[@"Image"];
        if ([imgStr rangeOfString:@"rigimageurl"].location == NSNotFound) {
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

#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfRows = 0;
    
    if (tableView.tag == 0) {
        numberOfRows = 3;
    } else if (tableView.tag == 1) { // comment table
        numberOfRows = 1;
    }
    return numberOfRows;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (tableView.tag == 0) {
        switch (section) {
            case 0:
                numberOfRows = arrRigReportsRods.count;
                break;
            case 1:
                numberOfRows = arrRigReportsTubing.count;
                break;
            case 2:
                numberOfRows = arrRigReportsPump.count;
                break;
            default:
                break;
        }
    } else if (tableView.tag == 1) { // Comments table
        numberOfRows = arrComments.count;
    }
    
    return numberOfRows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (tableView.tag == 0) {
        RigReportsDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RigReportsDetailContentCell" forIndexPath:indexPath];
        
        if (section == 2) {
            cell.lblCount.text = @"";
        }
        
        switch (section) {
            case 0: // Rod
            {
                RigReportsRods *rod = arrRigReportsRods[row];
                cell.lblSize.text = rod.rodSize;
                cell.lblType.text = rod.rodType;
                cell.lblLength.text = rod.rodLength;
                cell.lblCount.text = [NSString stringWithFormat:@"%d", rod.rodCount];
            }
                break;
            case 1: // Tubing
            {
                RigReportsTubing *tubing = arrRigReportsTubing[row];
                cell.lblSize.text = tubing.tubingSize;
                cell.lblType.text = tubing.tubingType;
                cell.lblLength.text = tubing.tubingLength;
                cell.lblCount.text = [NSString stringWithFormat:@"%d", tubing.tubingCount];
            }
                break;
            case 2: // Pump
            {
                RigReportsPump *pump = arrRigReportsPump[row];
                cell.lblSize.text = pump.pumpSize;
                cell.lblType.text = pump.pumpType;
                cell.lblLength.text = pump.pumpLength;
            }
                break;
            default:
                break;
        }
        
        return cell;
    } else if (tableView.tag == 1) {
        ProductionMainPopupCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionMainPopupCommentsCell" forIndexPath:indexPath];
        
        NSDictionary *dic = arrComments[row];
        cell.lblTitle.text = [dic valueForKey:@"title"];
        cell.lblComments.text = [dic valueForKey:@"comment"];
        cell.lblComments.tintColor = [UIColor whiteColor];
        return cell;
    }
    
    return nil;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 40;
    if (tableView.tag == 1) {
        height = 0;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 35;
    if (tableView.tag == 1) {
        if (tableView.tag == 1) { // comments tableview
            NSInteger row = [indexPath row];
            NSDictionary *dic = arrComments[row];
            NSString *str = [dic valueForKey:@"comment"];
            float width = [UIScreen mainScreen].bounds.size.width - 40;
            
            UIFont *myFont = [UIFont fontWithName:@"Open Sans" size:12];
            CGFloat commentHeight = [self heightForString:str font:myFont maxWidth:width];
            height = commentHeight + 45;
            
        }
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return nil;
    }
    
    RigReportsDetailHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"RigReportsDetailHeaderCell"];
    
    switch (section) {
        case 0:
            headerCell.lblTitle.text = @"Rod Size";
            break;
        case 1:
            headerCell.lblTitle.text = @"Tube Size";
            break;
        case 2:
            headerCell.lblTitle.text = @"Pump Size";
            break;
        default:
            break;
    }
    
    headerCell.btnAdd.tag = section;
    if (isEditable) {
        headerCell.btnAddWidthConstraint.constant = 40;
    } else {
        headerCell.btnAddWidthConstraint.constant = 0.0f;
    }
    
    [headerCell.layer setMasksToBounds:NO];
    [headerCell.contentView.layer setMasksToBounds:NO];
    headerCell.viewBackground.layer.masksToBounds = NO;
    headerCell.viewBackground.layer.shadowColor = [UIColor blackColor].CGColor;
    headerCell.viewBackground.layer.shadowOffset = CGSizeMake(1, 2);
    headerCell.viewBackground.layer.shadowRadius = 3.0f;
    headerCell.viewBackground.layer.shadowOpacity = 0.3f;
    
    
    return headerCell.contentView;
}

- (CGFloat)heightForString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    if (![text isKindOfClass:[NSString class]] || !text.length) {
        // no text means no height
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options attributes:attributes context:nil].size;
    CGFloat height = ceilf(size.height) + 10; // add 1 point as padding
    
    return height;
}

#pragma mark - button events
- (IBAction)onIn:(id)sender {
    isOut = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = -screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.btnIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnOut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.underlineView shakeWithWidth:2.5f];
    }];
    [self initData];
}

- (IBAction)onOut:(id)sender {
    isOut = YES;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

        [UIView animateWithDuration:0.2f animations:^{
        self.underlineCenterConstraint.constant = screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.btnIn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.underlineView shakeWithWidth:2.5f];
    }];
    
    [self initData];
}

- (IBAction)onEdit:(id)sender {
    
    int userid = [[[NSUserDefaults standardUserDefaults] valueForKey:S_UserID] intValue];
    if (userid == rigReports.entryUser) {
        [self.lblEditable setHidden:YES];
        isEditable = !isEditable;
        if (isEditable) {
            [self.imgEditable setHidden:NO];
        } else {
            [self.imgEditable setHidden:YES];
        }
        
    } else {
        [self.lblEditable setHidden:NO];
        isEditable = NO;
    }
    
    [self.tableView reloadData];
}

- (IBAction)AddReportsDetail:(id)sender {
    
    NSInteger section = [(UIButton*)sender tag];
    NSLog(@"Tap : %d", (int)section);
    
    switch (section) {
        case 0: // Add Rods
        {
            NewRigReportsRodVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRigReportsRodVC"];
            vc.isOut = isOut;
            vc.rigReports = rigReports;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: // Add Tubing
        {
            NewRigReportsTubingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRigReportsTubingVC"];
            vc.isOut = isOut;
            vc.rigReports = rigReports;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: // Add Pump
        {
            NewRigReportsPumpVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRigReportsPumpVC"];
            vc.isOut = isOut;
            vc.rigReports = rigReports;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark-UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailRigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailRigImageCollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1111];
    NSDictionary *imgDic = rigReports.rigImages[indexPath.row];
    NSString *imgStr = imgDic[@"Image"];
    
    if ([imgStr rangeOfString:@"rigimageurl"].location == NSNotFound) {
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
    if (rigReports.rigImages != nil) {
        return rigReports.rigImages.count;
    } else {
        return 0;
    }
}

@end
