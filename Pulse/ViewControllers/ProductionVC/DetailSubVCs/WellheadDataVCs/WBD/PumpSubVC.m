#import "PumpSubVC.h"
#import "WBDPumpCell.h"

@interface PumpSubVC ()

@end

@implementation PumpSubVC
@synthesize arrPumps;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSString *lease = self.welllist.grandparentPropNum;
    NSString *wellNumber = self.welllist.wellNumber;
    
    arrPumps = [[DBManager sharedInstance] getWBDPumps:lease wellNum:wellNumber];
    
    [self.tableView reloadData];
}

#pragma mark - tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPumps.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBDPumpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WBDPumpCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    WBDPumps *pump = arrPumps[row];
    
    NSString *pumpType = pump.pumpTypeName;
    
    if (pumpType == nil || [pumpType isEqual:@""]) {
        pumpType = @"Pump Type:";
    }
    
    cell.lblPumpType.text = pumpType;
    cell.lblPumpDescription.text = pump.pumpDesc;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMMM d, yyyy";
    cell.lblDate.text = [df stringFromDate:pump.pumpDateIn];
    
    NSString *infoSource = [[DBManager sharedInstance] getWBDInfoSourceType:pump.infoSource];
    NSString *infoNotes = pump.infoNotes == nil ? @"" : pump.infoNotes;
    
    cell.lblSourceNotes.text = [NSString stringWithFormat:@"%@\n%@", infoSource, infoNotes];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

@end
