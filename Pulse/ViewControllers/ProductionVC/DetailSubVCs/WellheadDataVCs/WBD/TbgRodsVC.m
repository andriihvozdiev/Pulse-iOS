#import "TbgRodsVC.h"
#import "WBDTubingCell.h"
#import "WBDRodsCell.h"

@interface TbgRodsVC ()
{
    float contentHeight;
    BOOL isOpenedTubing;
    BOOL isOpenedRods;
}
@end

@implementation TbgRodsVC
@synthesize welllist;
@synthesize arrTbg;
@synthesize arrRods;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    contentHeight = screenHeight * (667-115) / 667.0f - 50 - 106;  // nav bar, tapbar, margin.
    
    isOpenedTubing = YES;
    isOpenedRods = YES;
    self.tubingContentHeight.constant = (contentHeight - 70) / 2.0f;
    
    
    self.tbgTableview.rowHeight = UITableViewAutomaticDimension;
    self.tbgTableview.estimatedRowHeight = 30;
    
    self.rodsTableview.rowHeight = UITableViewAutomaticDimension;
    self.rodsTableview.estimatedRowHeight = 30;
    
    arrTbg = [[NSArray alloc] init];
    arrRods = [[NSArray alloc] init];
    
    [self.viewTubingHeader.layer setMasksToBounds:NO];
    self.viewTubingHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewTubingHeader.layer.shadowOffset = CGSizeMake(1, 1);
    self.viewTubingHeader.layer.shadowRadius = 3.0f;
    self.viewTubingHeader.layer.shadowOpacity = 0.3f;
    
    [self.viewRodsHeader.layer setMasksToBounds:NO];
    self.viewRodsHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewRodsHeader.layer.shadowOffset = CGSizeMake(1, 1);
    self.viewRodsHeader.layer.shadowRadius = 3.0f;
    self.viewRodsHeader.layer.shadowOpacity = 0.3f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

-(void) reloadData
{
    arrTbg = [[DBManager sharedInstance] getWBDTubings:welllist.grandparentPropNum wellNum:welllist.wellNumber];
    arrRods = [[DBManager sharedInstance] getWBDRods:welllist.grandparentPropNum wellNum:welllist.wellNumber];
    
    [self.tbgTableview reloadData];
    [self.rodsTableview reloadData];
}

- (IBAction)onTubingGroup:(id)sender {
    
    isOpenedTubing = !isOpenedTubing;
    [self switchGroup];
    
}

- (IBAction)onRodsGroup:(id)sender {
    
    isOpenedRods = !isOpenedRods;
    [self switchGroup];
}

-(void) switchGroup
{
    [UIView animateWithDuration:0.3f animations:^{
        if (isOpenedTubing) {
            if (isOpenedRods) {
                self.tubingContentHeight.constant = (contentHeight - 70) / 2.0f;
                
                [self.rodsTableview setHidden:NO];
            } else {
                self.tubingContentHeight.constant = contentHeight - 70;
                [self.rodsTableview setHidden:YES];
            }
            
        } else {
            
            if (isOpenedRods) {
                self.tubingContentHeight.constant = 0;
                [self.rodsTableview setHidden:NO];
            } else {
                self.tubingContentHeight.constant = 0;
                [self.rodsTableview setHidden:YES];
            }
        }
        
        [self.view layoutIfNeeded];
    }];
    
    if (isOpenedTubing)
        self.imgTubingDropIcon.image = [UIImage imageNamed:@"dropup_icon"];
    else
        self.imgTubingDropIcon.image = [UIImage imageNamed:@"dropdown_icon"];
    
    if (isOpenedRods)
        self.imgRodsDropIcon.image = [UIImage imageNamed:@"dropup_icon"];
    else
        self.imgRodsDropIcon.image = [UIImage imageNamed:@"dropdown_icon"];
    
    
}

#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tbgTableview) {
        return arrTbg.count;
    } else if (tableView == self.rodsTableview) {
        return arrRods.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (tableView == self.tbgTableview) {
        NSArray *arrSub = arrTbg[section];
        numberOfRows = arrSub.count;
    } else if (tableView == self.rodsTableview) {
        NSArray *arrSub = arrRods[section];
        numberOfRows = arrSub.count;
    }
    
    return numberOfRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    [view setBackgroundColor:[UIColor colorWithRed:80/255.0f green:84/255.0f blue:116/255.0f alpha:1]];
    
    return view;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (tableView == self.tbgTableview) {
        WBDTubingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WBDTubingCell" forIndexPath:indexPath];
        
        NSArray *arrSub = arrTbg[section];
        WBDCasingTubing *wbdCasingTubing = arrSub[row];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM/dd/yy";
        NSString *date = @"";
        if (wbdCasingTubing.wbDateIn) {
            date = [df stringFromDate:wbdCasingTubing.wbDateIn];
        }
        
        NSString *wbQty = @"";
        if (wbdCasingTubing.wbQty != 0)
            wbQty = [NSString stringWithFormat:@" %dx Jts", wbdCasingTubing.wbQty];
        int depth = wbdCasingTubing.endDepth - wbdCasingTubing.startDepth;
        NSString *extSize = wbdCasingTubing.extSize;
        NSString *tubularWeight = wbdCasingTubing.weight;
        NSString *tubularType = wbdCasingTubing.tubularType;
        NSString *threadType = wbdCasingTubing.threadType;
        NSArray *arrInfo = [[DBManager sharedInstance] getWBDInfos:@"WBDCasingTubing" recordID:wbdCasingTubing.wbCasingTubingID lease:wbdCasingTubing.lease wellNum:wbdCasingTubing.wellNum];
        
        
        // wb
        NSString *strContent = @"";
        
        // wbQty
        strContent = wbQty;
        
        // depth
        strContent = [NSString stringWithFormat:@"%@ (%d\')", strContent, depth];
        
        // extSize
        if (extSize != nil && extSize.length > 0) {
            strContent = [NSString stringWithFormat:@"%@ %@", strContent, extSize];
        }
        
        // tubularWeight
        if (tubularWeight != nil && tubularWeight.length > 0) {
            strContent = [NSString stringWithFormat:@"%@ %@", strContent, tubularWeight];
        }
        
        // tubularType
        if (tubularType != nil && tubularType.length > 0) {
            strContent = [NSString stringWithFormat:@"%@ %@", strContent, tubularType];
        }
        
        // threadType
        if (threadType != nil && threadType.length > 0) {
            strContent = [NSString stringWithFormat:@"%@ %@", strContent, threadType];
        }
        
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        NSDictionary *dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strContent attributes:dicAttributes];
        
        // infoSource
        if (arrInfo.count > 0) {
            
            WBDInfo *info = arrInfo[0];
            NSString *strInfos = info.infoSourceType;
            
            for (int i = 1; i < arrInfo.count; i++) {
                info = arrInfo[i];
                strInfos = [NSString stringWithFormat:@"%@, %@", strInfos, info.infoSourceType];
            }
            UIFont *italicFont = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:12.0];
            NSDictionary *dicItalicAttributes = [NSDictionary dictionaryWithObject:italicFont forKey:NSFontAttributeName];
            NSMutableAttributedString *strInfoSource = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" [%@]", strInfos] attributes:dicItalicAttributes];
            
            [attributedString appendAttributedString:strInfoSource];
        }
        
        // number and date
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d.", (int)row+1] attributes:dicAttributes];
        
        if ([date isEqual:@""]) {
            [result appendAttributedString:attributedString];
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n    (No Date)" attributes:dicAttributes]];
            
        } else {
            NSString *dateString = [NSString stringWithFormat:@" %@: ", date];
            NSMutableAttributedString *strDate = [[NSMutableAttributedString alloc] initWithString:dateString];
            [strDate addAttribute:NSUnderlineStyleAttributeName
                               value:[NSNumber numberWithInt:1]
                               range:(NSRange){1,[strDate length] - 2}];
            
            [result appendAttributedString:strDate];
            [result appendAttributedString:attributedString];
        }
        
        cell.lblContent.attributedText = result;
        
        return cell;
    }
    
    if (tableView == self.rodsTableview) {
        WBDRodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WBDRodsCell" forIndexPath:indexPath];
        
        NSArray *arrSub = arrRods[section];
        WBDRods *wbdRods = arrSub[row];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM/dd/yy";
        NSString *date = @"";
        if (wbdRods.wbRodsDtIn) {
            date = [df stringFromDate:wbdRods.wbRodsDtIn];
        }
        
        NSString *wbRodsQty = @"";
        if (wbdRods.wbRodsQty != 0)
            wbRodsQty = [NSString stringWithFormat:@" %dx", wbdRods.wbRodsQty];
        
        
        NSString *extSize = wbdRods.extSize;
        NSString *couplingCode = wbdRods.couplingCode;
        NSString *rodType = wbdRods.rodType;
        
        NSArray *arrInfo = [[DBManager sharedInstance] getWBDInfos:@"WBDRods" recordID:wbdRods.wbRodsID lease:wbdRods.lease wellNum:wbdRods.wellNum];
        
        NSString *strContent = @"";
        
        // wbQty
        strContent = wbRodsQty;
        
        // extSize
        if (extSize != nil && extSize.length > 0) {
            strContent = [NSString stringWithFormat:@"%@ %@", strContent, extSize];
        }
        
        // coupling
        if (couplingCode != nil && couplingCode.length > 0) {
            strContent = [NSString stringWithFormat:@"%@ %@ Cplg", strContent, couplingCode];
        }
        
        // rodType
        if (rodType != nil && rodType.length > 0) {
            strContent = [NSString stringWithFormat:@"%@ %@", strContent, rodType];
        }
        
        UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        NSDictionary *dicAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strContent attributes:dicAttributes];
        
        // infoSource
        if (arrInfo.count > 0) {
            
            WBDInfo *info = arrInfo[0];
            NSString *strInfos = info.infoSourceType;
            
            for (int i = 1; i < arrInfo.count; i++) {
                info = arrInfo[i];
                strInfos = [NSString stringWithFormat:@"%@, %@", strInfos, info.infoSourceType];
            }
            UIFont *italicFont = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:12.0];
            NSDictionary *dicItalicAttributes = [NSDictionary dictionaryWithObject:italicFont forKey:NSFontAttributeName];
            NSMutableAttributedString *strInfoSource = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" [%@]", strInfos] attributes:dicItalicAttributes];
            
            [attributedString appendAttributedString:strInfoSource];
        }
        
        // number and date
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d.", (int)row+1] attributes:dicAttributes];
        
        if ([date isEqual:@""]) {
            [result appendAttributedString:attributedString];
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n    (No Date)" attributes:dicAttributes]];
            
        } else {
            NSString *dateString = [NSString stringWithFormat:@" %@: ", date];
            NSMutableAttributedString *strDate = [[NSMutableAttributedString alloc] initWithString:dateString];
            [strDate addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){1,[strDate length] - 2}];
            
            [result appendAttributedString:strDate];
            [result appendAttributedString:attributedString];
            
        }
        
        cell.lblContent.attributedText = result;
        
        return cell;
    }
    
    return nil;
}



@end
