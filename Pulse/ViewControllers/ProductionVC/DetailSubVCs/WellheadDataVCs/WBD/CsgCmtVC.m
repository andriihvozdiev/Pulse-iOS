#import "CsgCmtVC.h"
#import "SurveyContentCell.h"
#import "CsgCmtContentCell.h"
#import "PlugSqueezeContentCell.h"

@interface CsgCmtVC ()
{
    float contentHeight;
    BOOL isOpenedSurvey;
    BOOL isOpenedCsgCmt;
    BOOL isOpenedPlugSqueeze;
}
@end

@implementation CsgCmtVC
@synthesize welllist;
@synthesize arrSurveys;
@synthesize arrCsgCmt;
@synthesize arrPlugs;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    contentHeight = screenHeight * (667-115) / 667.0f - 50 - 32;
    
    self.csgcmtTableView.rowHeight = UITableViewAutomaticDimension;
    self.csgcmtTableView.estimatedRowHeight = 210;
    
    self.plugSqueezeTableView.rowHeight = UITableViewAutomaticDimension;
    self.plugSqueezeTableView.estimatedRowHeight = 150;
    
    isOpenedSurvey = YES;
    isOpenedCsgCmt = YES;
    isOpenedPlugSqueeze = YES;
    
    float threeOpenedHeight = (contentHeight - 105) / 3.0f;
    self.surveyContentHeight.constant = threeOpenedHeight;
    self.csgCmtContentHeight.constant = threeOpenedHeight;
    [self.plugSqueezeTableView setHidden:NO];
    
    self.surveyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.csgcmtTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.plugSqueezeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.viewSurveyHeader.layer setMasksToBounds:NO];
    self.viewSurveyHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewSurveyHeader.layer.shadowOffset = CGSizeMake(1, 1);
    self.viewSurveyHeader.layer.shadowRadius = 3.0f;
    self.viewSurveyHeader.layer.shadowOpacity = 0.3f;
    
    [self.viewCsgCmtHeader.layer setMasksToBounds:NO];
    self.viewCsgCmtHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewCsgCmtHeader.layer.shadowOffset = CGSizeMake(1, 1);
    self.viewCsgCmtHeader.layer.shadowRadius = 3.0f;
    self.viewCsgCmtHeader.layer.shadowOpacity = 0.3f;
    
    [self.viewPlugSqueezeHeader.layer setMasksToBounds:NO];
    self.viewPlugSqueezeHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewPlugSqueezeHeader.layer.shadowOffset = CGSizeMake(1, 1);
    self.viewPlugSqueezeHeader.layer.shadowRadius = 3.0f;
    self.viewPlugSqueezeHeader.layer.shadowOpacity = 0.3f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    arrSurveys = [[DBManager sharedInstance] getWBDSurveys:welllist.grandparentPropNum wellNum:welllist.wellNumber];
    arrCsgCmt = [[DBManager sharedInstance] getCasing:welllist.grandparentPropNum wellNum:welllist.wellNumber];
    arrPlugs = [[DBManager sharedInstance] getWBDPlugs:welllist.grandparentPropNum wellNum:welllist.wellNumber];
    
    [self reloadData];
}

-(void) reloadData
{
    [self.surveyTableView reloadData];
    [self.csgcmtTableView reloadData];
    [self.plugSqueezeTableView reloadData];
}

- (IBAction)onHoleSurveyGroup:(id)sender {
    isOpenedSurvey = !isOpenedSurvey;
    [self switchGroups];
}

- (IBAction)onCsgCmtGroup:(id)sender {
    isOpenedCsgCmt = !isOpenedCsgCmt;
    [self switchGroups];
}

- (IBAction)onPlugSqueezeGroup:(id)sender {
    isOpenedPlugSqueeze = !isOpenedPlugSqueeze;
    [self switchGroups];
}

-(void) switchGroups
{
    float oneOpenedHeight = contentHeight - 105;
    float twoOpenedHeight = (contentHeight - 105) / 2.0f;
    float threeOpenedHeight = (contentHeight - 105) / 3.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        if (isOpenedSurvey) {
            if (isOpenedCsgCmt) {
                if (isOpenedPlugSqueeze) {
                    self.surveyContentHeight.constant = threeOpenedHeight;
                    self.csgCmtContentHeight.constant = threeOpenedHeight;
                    [self.plugSqueezeTableView setHidden:NO];
                } else {
                    self.surveyContentHeight.constant = twoOpenedHeight;
                    self.csgCmtContentHeight.constant = twoOpenedHeight;
                    [self.plugSqueezeTableView setHidden:YES];
                }
            } else {
                if (isOpenedPlugSqueeze) {
                    self.surveyContentHeight.constant = twoOpenedHeight;
                    self.csgCmtContentHeight.constant = 0;
                    [self.plugSqueezeTableView setHidden:NO];
                } else {
                    self.surveyContentHeight.constant = oneOpenedHeight;
                    self.csgCmtContentHeight.constant = 0;
                    [self.plugSqueezeTableView setHidden:YES];
                }
            }
        } else {
            if (isOpenedCsgCmt) {
                if (isOpenedPlugSqueeze) {
                    self.surveyContentHeight.constant = 0;
                    self.csgCmtContentHeight.constant = twoOpenedHeight;
                    [self.plugSqueezeTableView setHidden:NO];
                } else {
                    self.surveyContentHeight.constant = 0;
                    self.csgCmtContentHeight.constant = oneOpenedHeight;
                    [self.plugSqueezeTableView setHidden:YES];
                }
            } else {
                if (isOpenedPlugSqueeze) {
                    self.surveyContentHeight.constant = 0;
                    self.csgCmtContentHeight.constant = 0;
                    [self.plugSqueezeTableView setHidden:NO];
                } else {
                    self.surveyContentHeight.constant = 0;
                    self.csgCmtContentHeight.constant = 0;
                    [self.plugSqueezeTableView setHidden:YES];
                }
            }
        }
        
        [self.view layoutIfNeeded];
    }];
    
    if (isOpenedSurvey)

        self.imgSurveyDropdown.image = [UIImage imageNamed:@"dropup_icon"];
    else
        self.imgSurveyDropdown.image = [UIImage imageNamed:@"dropdown_icon"];
    
    if (isOpenedCsgCmt)
        self.imgCsgCmtDropdown.image = [UIImage imageNamed:@"dropup_icon"];
    else
        self.imgCsgCmtDropdown.image = [UIImage imageNamed:@"dropdown_icon"];
    
    if (isOpenedPlugSqueeze)
        self.imgPlugSqueezeDropdown.image = [UIImage imageNamed:@"dropup_icon"];
    else
        self.imgPlugSqueezeDropdown.image = [UIImage imageNamed:@"dropdown_icon"];
    
}


#pragma mark - tableview datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    float height = 0;
    
    switch (tableView.tag) {
        case 1:
            height = 25;
            break;
        default:
            break;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (tableView.tag) {
        case 1:
            numberOfRows = arrSurveys.count;
            break;
        case 2:
            numberOfRows = arrCsgCmt.count;
            break;
        case 3:
            numberOfRows = arrPlugs.count;
            break;
        default:
            break;
    }
    return numberOfRows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    switch (tableView.tag) {
        case 1:
        {
            SurveyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyContentCell" forIndexPath:indexPath];
            
            WBDSurveys *survey = arrSurveys[row];
            
            cell.lblMD.text = [NSString stringWithFormat:@"%@'", [NSNumber numberWithFloat:survey.md]];
            cell.lblTVD.text = [NSString stringWithFormat:@"%@'", [NSNumber numberWithFloat:survey.tvd]];
            cell.lblHole.text = [NSString stringWithFormat:@"%@\"", [NSNumber numberWithFloat:survey.minHoleSize]];
            cell.lblInc.text = [NSString stringWithFormat:@"%@\u00b0", [NSNumber numberWithFloat:survey.inclination]];
            cell.lblAzi.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:survey.trueAzimuth]];
            cell.lblDL.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:survey.dogLegSeverity]];
            cell.lblDate.text = survey.surveyPointDate == nil ? @"" : [df stringFromDate:survey.surveyPointDate];
            cell.lblComments.text = survey.comments == nil ? @"" : survey.comments;
            
            return cell;
        }
        case 2:
        {
            CsgCmtContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CsgCmtContentCell" forIndexPath:indexPath];
            
            WBDCasingTubing *casing = arrCsgCmt[row];
            NSArray *arrInfo = [[DBManager sharedInstance] getWBDInfos:@"WBDCasingTubing" recordID:casing.wbCasingTubingID lease:casing.lease wellNum:casing.wellNum];
            
            cell.lblCsgTD.text = [NSString stringWithFormat:@"TD: %d' MD", casing.endDepth];
            cell.lblCmtQty.text = [NSString stringWithFormat:@"%d sx (%d bbls Slurry)", casing.cmtSxQty, casing.cmtVolSlurry];
            cell.lblCmtDescription.text = casing.cmtDesc;
            cell.lblCmtCalcToC.text = [NSString stringWithFormat:@"Calculated Top of Cement: %d'", casing.cmtCalcToC];
            
            NSString *strVerifiedCmtToC = [NSString stringWithFormat:@"Verified Top of Cement: %d'", casing.cmtVerifiedToC];
            NSString *strVerificationType = casing.cmtVerificationType == nil ? @"" : [NSString stringWithFormat:@" (%@)", casing.cmtVerificationType];
            
            UIFont *font = [UIFont fontWithName:@"OpenSans" size:11.0];
            NSDictionary *dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strVerifiedCmtToC attributes:dicAttributes];
            
            UIFont *italicFont = [UIFont fontWithName:@"OpenSans-Italic" size:11.0];
            NSDictionary *dicItalicAttributes = [NSDictionary dictionaryWithObject:italicFont forKey:NSFontAttributeName];
            NSMutableAttributedString *verficationTypeItalic = [[NSMutableAttributedString alloc]initWithString:strVerificationType attributes:dicItalicAttributes];
            
            [attributedString appendAttributedString:verficationTypeItalic];
            cell.lblVerifiedCmtToC.attributedText = attributedString;
            
            NSString *strInfoList = @"";
            if ([arrInfo count] > 0) {
                WBDInfo *firstInfo = arrInfo[0];
                NSString *infoSource = firstInfo.infoSourceType;
                NSString *infoDate = [df stringFromDate:firstInfo.infoDate];
                
                NSString *infoString = [NSString stringWithFormat:@"%@, %@", infoSource, infoDate];
                if (!infoDate) {
                    infoString = [NSString stringWithFormat:@"%@", infoSource];
                }
                strInfoList = infoString;
                
                for (int i = 1; i < arrInfo.count; i++) {
                    firstInfo = arrInfo[i];
                    
                    infoSource = firstInfo.infoSourceType;
                    infoDate = [df stringFromDate:firstInfo.infoDate];
                    
                    infoString = [NSString stringWithFormat:@"%@, %@", infoSource, infoDate];
                    if (!infoDate) {
                        infoString = [NSString stringWithFormat:@"%@", infoSource];
                    }
                    
                    strInfoList = [NSString stringWithFormat:@"%@\n%@", strInfoList, infoString];
                }
            }
            cell.lblInfoSource.text = strInfoList;
            
            [cell.contentView layoutIfNeeded];
            return cell;
        }
        case 3:
        {
            PlugSqueezeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlugSqueezeContentCell" forIndexPath:indexPath];
            
            WBDPlugs *plug = arrPlugs[row];
            
            cell.lblPlugType.text = plug.plugType;
            cell.lblPlugDepth.text = [NSString stringWithFormat:@"Depth: %d", plug.plugDepth];
            
            NSString *strDate = plug.plugDateIn == nil ? @"" : [df stringFromDate:plug.plugDateIn];
            cell.lblPlugDate.text = [NSString stringWithFormat:@"Date: %@", strDate];
            
            NSString *strComment = plug.comments == nil ? @"" : plug.comments;
            cell.lblComments.text = [NSString stringWithFormat:@"Comments: %@", strComment];
            
            NSString *infoSource = [[DBManager sharedInstance] getWBDInfoSourceType:plug.infoSource];
            NSString *infoDate = [df stringFromDate:plug.infoDate];
            
            if (infoDate) {
                cell.lblInfoSource.text = [NSString stringWithFormat:@"%@, %@", infoSource, infoDate];
            } else {
                cell.lblInfoSource.text = [NSString stringWithFormat:@"%@", infoSource];
            }
            
            
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

@end
