
#import "ProdDetailSubVC.h"
#import "DetailContentTableCell.h"
#import "ProductionDetailSubPopupVC.h"
#import "HapticHelper.h"
@import PeekPop;

@interface ProdDetailSubVC ()<PeekPopPreviewingDelegate>

@end

@implementation ProdDetailSubVC
@synthesize pulseProdHome;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    UIViewController *parentVC = [self.navigationController topViewController];
    self.peekPop = [[PeekPop alloc] initWithViewController:parentVC];
    self.previewingContext = [self.peekPop registerForPreviewingWithDelegate:self sourceView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];
}

-(void)initData
{
    if (self.index == 0) {
        self.arrDetailData = [[DBManager sharedInstance] getProductionByLease:pulseProdHome.lease];
        
        ProductionAvg *prodAvg = [[DBManager sharedInstance] getProductionAvgByLease:pulseProdHome.lease];
        
        if (prodAvg) {
            self.lblOil7.text = [self getStringValue:prodAvg.oil7];
            self.lblOil30.text = [self getStringValue:prodAvg.oil30];
            self.lblOil365.text = [self getStringValue:prodAvg.oil365];
            self.lblOilP30.text = [self getStringValue:prodAvg.oilP30];
            
            self.lblGas7.text = [self getStringValue:prodAvg.gas7];
            self.lblGas30.text = [self getStringValue:prodAvg.gas30];
            self.lblGas365.text = [self getStringValue:prodAvg.gas365];
            self.lblGasP30.text = [self getStringValue:prodAvg.gasP30];
            
            self.lblWater7.text = [self getStringValue:prodAvg.water7];
            self.lblWater30.text = [self getStringValue:prodAvg.water30];
            self.lblWater365.text = [self getStringValue:prodAvg.water365];
            self.lblWaterP30.text = [self getStringValue:prodAvg.waterP30];
        }
    } else {
        self.arrDetailData = [[DBManager sharedInstance] getProductionFields:pulseProdHome.lease leaseField:self.leaseField];
        
        ProductionAvgField *prodAvgField = [[DBManager sharedInstance] getProductionAvgFieldByLease:pulseProdHome.lease leaseField:self.leaseField];
        
        if (prodAvgField) {
            self.lblOil7.text = [self getStringValue:prodAvgField.oil7];
            self.lblOil30.text = [self getStringValue:prodAvgField.oil30];
            self.lblOil365.text = [self getStringValue:prodAvgField.oil365];
            self.lblOilP30.text = [self getStringValue:prodAvgField.oilP30];
            
            self.lblGas7.text = [self getStringValue:prodAvgField.gas7];
            self.lblGas30.text = [self getStringValue:prodAvgField.gas30];
            self.lblGas365.text = [self getStringValue:prodAvgField.gas365];
            self.lblGasP30.text = [self getStringValue:prodAvgField.gasP30];
            
            self.lblWater7.text = [self getStringValue:prodAvgField.water7];
            self.lblWater30.text = [self getStringValue:prodAvgField.water30];
            self.lblWater365.text = [self getStringValue:prodAvgField.water365];
            self.lblWaterP30.text = [self getStringValue:prodAvgField.waterP30];
        }
    }
    
    [self.tableView reloadData];
}


-(NSString*)getStringValue:(id)value
{
    NSString *result = @"";
    if (value != nil) {
        float v = [value floatValue];
        
        if (v >= 100) {
            result = [NSString stringWithFormat:@"%.0f", [value floatValue]];
        } else if (v < 100)
        {
            result = [NSString stringWithFormat:@"%.1f", [value floatValue]];
        }
        
    }
    else
    {
        result = @"-";
    }
    
    return result;
}


#pragma mark - tableview database
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.arrDetailData.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailContentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailContentTableCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    if (self.index == 0) {
        Production *production = self.arrDetailData[row];
        
        NSString *strDate = [df stringFromDate:production.productionDate];
        if ((production.comments && ![production.comments isEqualToString:@""]) ||
            (production.gasComments && ![production.gasComments isEqual:@""]) ||
            (production.waterComments && ![production.waterComments isEqual:@""]) ||
            (production.oilComments && ![production.oilComments isEqual:@""]) ||
            (production.wellheadComments && ![production.wellheadComments isEqual:@""]))
        {
            strDate = [NSString stringWithFormat:@"%@*", strDate];
        }
        
        if (production.wellheadData && ![production.wellheadData isEqual:@""]) {
            strDate = [NSString stringWithFormat:@"%@†", strDate];
        }
        
        cell.lblDate.text = strDate;
        cell.lblOil.text = [self getStringValue:production.oilVol];
        cell.lblGas.text = [self getStringValue:production.gasVol];
        cell.lblWater.text = [self getStringValue:production.waterVol];
    } else {
        ProductionField *productionField = self.arrDetailData[row];
        
        NSString *strDate = [df stringFromDate:productionField.productionDate];
        
        if ((productionField.comments && ![productionField.comments isEqualToString:@""]) ||
            (productionField.gasComments && ![productionField.gasComments isEqual:@""]) ||
            (productionField.waterComments && ![productionField.waterComments isEqual:@""]) ||
            (productionField.oilComments && ![productionField.oilComments isEqual:@""]) ||
            (productionField.wellheadComments && ![productionField.wellheadComments isEqual:@""]))
        {
            strDate = [NSString stringWithFormat:@"%@*", strDate];
        }
        
        if (productionField.wellheadData && ![productionField.wellheadData isEqual:@""]) {
            strDate = [NSString stringWithFormat:@"%@†", strDate];
        }
        
        cell.lblDate.text = strDate;
        cell.lblOil.text = [self getStringValue:productionField.oilVol];
        cell.lblGas.text = [self getStringValue:productionField.gasVol];
        cell.lblWater.text = [self getStringValue:productionField.waterVol];
    }
    
    
    return cell;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailHeaderTableCell"];
    
    UIView *view = [cell contentView];
    
    [cell.layer setMasksToBounds:NO];
    [view.layer setMasksToBounds:NO];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(1, 2);
    view.layer.shadowRadius = 3.0f;
    view.layer.shadowOpacity = 0.3f;
    
    return view;
}


#pragma mark - 3D Touch
- (BOOL)isForceTouchAvailable {
    
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}


- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location
{
    if ([self.presentedViewController isKindOfClass:[ProductionDetailSubPopupVC class]]) {
        return nil;
    }
    
    if ((self.tableView.frame.size.height + self.tableView.frame.origin.y) <= location.y)
        return nil;
    
//    CGPoint cellPostion = location; //
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (path) {
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
        
        CGRect rect = tableCell.frame;
        CGPoint yOffset = self.tableView.contentOffset;
        rect.origin.y += self.tableView.frame.origin.y - yOffset.y;
//        rect.origin.y -= yOffset.y;
        [previewingContext setSourceRect:rect];
        
        // set the view controller by initializing it form the storyboard
        ProductionDetailSubPopupVC *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductionDetailSubPopupVC"];
        previewController.pulseProdHome = pulseProdHome;
        
        if (self.index == 0) {
            Production *production = self.arrDetailData[path.row];
            previewController.isProductionField = NO;
            previewController.production = production;
        } else {
            ProductionField *productionField = self.arrDetailData[path.row];
            previewController.isProductionField = YES;
            previewController.productionField = productionField;
        }
        
        
        previewController.preferredContentSize = CGSizeMake(0.0f, 450);
        
        return previewController;
    }
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    
    if (![self isForceTouchAvailable]) {
        [HapticHelper generateFeedback:FeedbackType_Impact_Heavy];
    }
    [self showViewController:viewControllerToCommit sender:self];
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
//    if ([self isForceTouchAvailable]) {
//        if (!self.previewingContext) {
//            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
//        }
//    } else {
//        if (self.previewingContext) {
//            [self unregisterForPreviewingWithContext:self.previewingContext];
//            self.previewingContext = nil;
//        }
//    }
}


@end
