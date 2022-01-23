#import "ChronVC.h"
#import "ChronCell.h"
#import "RigReportsDetailFromWBDViewController.h"

@interface ChronVC ()

@end

@implementation ChronVC
@synthesize welllist;
@synthesize arrRigReports;
@synthesize refreshController;;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrRigReports = [[NSArray alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [refreshController setTintColor:[UIColor whiteColor]];
    [self.tableView addSubview:refreshController];
    self.parentController.pullAllChronDelegate = self;
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

-(void)handleRefresh : (id)sender
{
    NSLog (@"Pull To Refresh Method Called");
    [self.parentController syncAllChrons];
}

-(void) reloadData
{
    arrRigReports = [[DBManager sharedInstance] getRigReportsByWellNum:welllist.wellNumber withLease:welllist.grandparentPropNum];
    [self.tableView reloadData];
}

#pragma mark - tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrRigReports.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChronCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChronCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    RigReports *rigReports = arrRigReports[row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    cell.btnDetail.tag = row;
    cell.lblReportDate.text = [df stringFromDate:rigReports.reportDate];
    cell.lblCompany.text = [self isEmpty:rigReports.company] ? @"-" : rigReports.company;
    cell.lblComments.text = [self isEmpty:rigReports.comments] ? @"-" : rigReports.comments;
    [cell.lblComments setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell.lblComments setTintColor:[UIColor whiteColor]];
    if ([self isEmpty:rigReports.tubing]) {
        cell.lblTubingTitle.text = @"";
        cell.lblTubing.text = @"";
        
        cell.rodsTitleTopMargin.constant = -8;
    } else {
        cell.lblTubingTitle.text = @"Tubing/Barrel:";
        cell.rodsTitleTopMargin.constant = 8;
        cell.lblTubing.text = rigReports.tubing;
        [cell.lblTubing setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell.lblTubing setTintColor:[UIColor whiteColor]];
    }
    
    if ([self isEmpty:rigReports.rods]) {
        cell.lblRodsTitle.text = @"";
        cell.lblRods.text = @"";
    } else {
        cell.lblRodsTitle.text = @"Rods/Pump:";
        cell.lblRods.text = rigReports.rods;
        [cell.lblRods setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell.lblRods setTintColor:[UIColor whiteColor]];
    }
    
    if (rigReports.engrApproval == true) {
        [cell.lineView setBackgroundColor:[UIColor greenColor]];
    } else {
        [cell.lineView setBackgroundColor:[UIColor redColor]];
    }
    return cell;
}

-(BOOL)isEmpty:(NSString*)str {
    if (str == nil || str.length == 0)
        return YES;
    return NO;
}

- (IBAction)onDetail:(UIButton*)sender {
    NSInteger index = sender.tag;
    RigReportsDetailFromWBDViewController *detailSubVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RigReportsDetailFromWBDViewController"];
    detailSubVC.rigReports = arrRigReports[index];
    detailSubVC.index = index;
    [self.navigationController pushViewController:detailSubVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    RigReports *rigReports = arrRigReports[row];
    
    float height = 240;
    float maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:11];
    height += [self heightForString:rigReports.comments font:font maxWidth:maxWidth];
    
    if ([self isEmpty:rigReports.tubing]) {
        height -= 48;
    } else {
        float tubingHeight = [self heightForString:rigReports.tubing font:font maxWidth:maxWidth];
        if (tubingHeight > 48) {
            height += tubingHeight - 20;
        }
    }
    if ([self isEmpty:rigReports.rods]) {
        height -= 48;
    } else {
        float rodsHeight = [self heightForString:rigReports.rods font:font maxWidth:maxWidth];
        if (rodsHeight > 48) {
            height += rodsHeight - 30;
        }
    }
    
    return height;
}

- (CGFloat)heightForString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    if (![text isKindOfClass:[NSString class]] || !text.length) {
        // no text means no height
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options attributes:attributes context:nil].size;
    CGFloat height = ceilf(size.height) + 1; // add 1 point as padding
    
    return height;
}

#pragma mark - PullAllChronDelegate
-(void) didFinishDownload {
    [self.refreshController endRefreshing];
}

@end
