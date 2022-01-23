#import "ProductionDetailSubPopupVC.h"
#import "ProductionMainPopupContentCell.h"
#import "ProductionMainPopupCommentsCell.h"

@interface ProductionDetailSubPopupVC ()

@end

@implementation ProductionDetailSubPopupVC
@synthesize pulseProdHome;
@synthesize production;
@synthesize productionField;
@synthesize arrProductionField;
@synthesize arrComments;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrProductionField = [[NSArray alloc] init];
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.commentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    self.lblLease.text = pulseProdHome.leaseName;
    
    if (!self.isProductionField) {
        self.lblDate.text = [df stringFromDate:production.productionDate];
        
        arrComments = [[NSMutableArray alloc] init];
        if (production.oilComments != nil && production.oilComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Oil Comments", @"comment": production.oilComments};
            [arrComments addObject:dic];
        }
        if (production.gasComments != nil && production.gasComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Gas Comments", @"comment": production.gasComments};
            [arrComments addObject:dic];
        }
        if (production.waterComments != nil && production.waterComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Water Comments", @"comment": production.waterComments};
            [arrComments addObject:dic];
        }
        if (production.wellheadComments != nil && production.wellheadComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Wellhead Comments", @"comment": production.wellheadComments};
            [arrComments addObject:dic];
        }
        if (production.wellheadData != nil && production.wellheadData.length > 0) {
            NSDictionary *dic = @{@"title": @"Wellhead Data", @"comment": production.wellheadData};
            [arrComments addObject:dic];
        }
        
        arrProductionField = [[DBManager sharedInstance] getProductionFields:production.lease productionDate:production.productionDate];
    } else {
        self.lblDate.text = [df stringFromDate:productionField.productionDate];
        
        arrComments = [[NSMutableArray alloc] init];
        if (productionField.oilComments != nil && productionField.oilComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Oil Comments", @"comment": productionField.oilComments};
            [arrComments addObject:dic];
        }
        if (productionField.gasComments != nil && productionField.gasComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Gas Comments", @"comment": productionField.gasComments};
            [arrComments addObject:dic];
        }
        if (productionField.waterComments != nil && productionField.waterComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Water Comments", @"comment": productionField.waterComments};
            [arrComments addObject:dic];
        }
        if (productionField.wellheadComments != nil && productionField.wellheadComments.length > 0) {
            NSDictionary *dic = @{@"title": @"Wellhead Comments", @"comment": productionField.wellheadComments};
            [arrComments addObject:dic];
        }
        if (productionField.wellheadData != nil && productionField.wellheadData.length > 0) {
            NSDictionary *dic = @{@"title": @"Wellhead Data", @"comment": productionField.wellheadData};
            [arrComments addObject:dic];
        }
    }
    
    
    [self.tableview reloadData];
    [self.commentTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
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

#pragma mark - tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (tableView.tag == 0) {
        if (self.isProductionField) {
            numberOfRows = 1;
        } else {
            numberOfRows = arrProductionField.count + 1;
        }
        
    } else {
        numberOfRows = arrComments.count;
    }
    return numberOfRows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    if (tableView.tag == 0) {
        ProductionMainPopupContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionMainPopupContentCell" forIndexPath:indexPath];
        
        if (self.isProductionField) {
            cell.lblLease.text = productionField.leaseName;
            cell.lblOil.text = [self getStringValue:productionField.oilVol];
            cell.lblGas.text = [self getStringValue:productionField.gasVol];
            cell.lblWater.text = [self getStringValue:productionField.waterVol];
        } else {
            if (row == 0) {
                cell.lblLease.text = pulseProdHome.leaseName;
                cell.lblOil.text = [self getStringValue:production.oilVol];
                cell.lblGas.text = [self getStringValue:production.gasVol];
                cell.lblWater.text = [self getStringValue:production.waterVol];
                
                UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
                [cell.lblLease setFont:font];
                [cell.lblOil setFont:font];
                [cell.lblGas setFont:font];
                [cell.lblWater setFont:font];
            } else {
                
                ProductionField *prodField = arrProductionField[row - 1];
                
                cell.lblLease.text = prodField.leaseName;
                cell.lblOil.text = [self getStringValue:prodField.oilVol];
                cell.lblGas.text = [self getStringValue:prodField.gasVol];
                cell.lblWater.text = [self getStringValue:prodField.waterVol];
            }
        }
        
        return cell;
    } else { // comments tableview
        ProductionMainPopupCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionMainPopupCommentsCell" forIndexPath:indexPath];
        
        NSDictionary *dic = arrComments[row];
        cell.lblTitle.text = [dic valueForKey:@"title"];
        cell.lblComments.text = [dic valueForKey:@"comment"];
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 35;
    if (tableView.tag == 1) { // comments tableview
        NSInteger row = [indexPath row];
        NSDictionary *dic = arrComments[row];
        NSString *str = [dic valueForKey:@"comment"];
        float width = [UIScreen mainScreen].bounds.size.width - 40;
        
        UIFont *myFont = [UIFont fontWithName:@"Open Sans" size:12];
        CGFloat commentHeight = [self heightForString:str font:myFont maxWidth:width];
        height = commentHeight + 45;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 35;
    if (tableView.tag == 1) { // comments tableview
        height = 0;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionMainPopupHeaderCell"];
    return cell.contentView;
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

@end
