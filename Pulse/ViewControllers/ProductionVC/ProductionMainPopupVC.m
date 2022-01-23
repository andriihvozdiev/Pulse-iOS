
#import "ProductionMainPopupVC.h"
#import "ProductionMainPopupContentCell.h"
#import "ProductionMainPopupCommentsCell.h"

@interface ProductionMainPopupVC ()

@end

@implementation ProductionMainPopupVC
@synthesize pulseProdHome;
@synthesize arrPulseProdField;
@synthesize arrComments;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrPulseProdField = [[NSArray alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    self.lblLease.text = pulseProdHome.leaseName;
    self.lblDate.text = [df stringFromDate:pulseProdHome.date];
    
    arrComments = [[NSMutableArray alloc] init];
    if (pulseProdHome.oilComments != nil && pulseProdHome.oilComments.length > 0) {
        NSDictionary *dic = @{@"title": @"Oil Comments", @"comment": pulseProdHome.oilComments};
        [arrComments addObject:dic];
    }
    if (pulseProdHome.gasComments != nil && pulseProdHome.gasComments.length > 0) {
        NSDictionary *dic = @{@"title": @"Gas Comments", @"comment": pulseProdHome.gasComments};
        [arrComments addObject:dic];
    }
    if (pulseProdHome.waterComments != nil && pulseProdHome.waterComments.length > 0) {
        NSDictionary *dic = @{@"title": @"Water Comments", @"comment": pulseProdHome.waterComments};
        [arrComments addObject:dic];
    }
    if (pulseProdHome.wellheadComments != nil && pulseProdHome.wellheadComments.length > 0) {
        NSDictionary *dic = @{@"title": @"Wellhead Comments", @"comment": pulseProdHome.wellheadComments};
        [arrComments addObject:dic];
    }
    if (pulseProdHome.wellheadData != nil && pulseProdHome.wellheadData.length > 0) {
        NSDictionary *dic = @{@"title": @"Wellhead Data", @"comment": pulseProdHome.wellheadData};
        [arrComments addObject:dic];
    }
    
    arrPulseProdField = [[DBManager sharedInstance] getPulseProdFields:pulseProdHome.lease];
    [self.tableView reloadData];
    [self.commentsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
}

#pragma mark - tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (tableView.tag == 0) {
        numberOfRows = arrPulseProdField.count + 1;
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
        
        if (row == 0) {
            cell.lblLease.text = pulseProdHome.leaseName;
            cell.lblOil.text = [self getStringValue:pulseProdHome.oilVol];
            cell.lblGas.text = [self getStringValue:pulseProdHome.gasVol];
            cell.lblWater.text = [self getStringValue:pulseProdHome.waterVol];
            
            UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
            [cell.lblLease setFont:font];
            [cell.lblOil setFont:font];
            [cell.lblGas setFont:font];
            [cell.lblWater setFont:font];
            
        } else {
            PulseProdField *pulseProdField = arrPulseProdField[row - 1];
            
            cell.lblLease.text = pulseProdField.fieldName;
            if (pulseProdField.oilCalcType == nil || [pulseProdField.oilCalcType isEqual:@"Gauge"]) {
                cell.lblOil.text = pulseProdField.oilVol;
            } else {
                cell.lblOil.text = [NSString stringWithFormat:@"%@*", pulseProdField.oilVol];
            }
            
            if (pulseProdField.gasCalcType == nil || [pulseProdField.gasCalcType isEqual:@"Gauge"]) {
                cell.lblGas.text = pulseProdField.gasVol;
            } else {
                cell.lblGas.text = [NSString stringWithFormat:@"%@*", pulseProdField.gasVol];
            }
            
            if (pulseProdField.waterCalcType == nil || [pulseProdField.waterCalcType isEqual:@"Gauge"]) {
                cell.lblWater.text = pulseProdField.waterVol;
            } else {
                cell.lblWater.text = [NSString stringWithFormat:@"%@*", pulseProdField.waterVol];
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


-(NSString*)getStringValue:(id)value {
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
