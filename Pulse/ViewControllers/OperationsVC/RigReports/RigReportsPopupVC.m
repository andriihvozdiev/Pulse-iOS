#import "RigReportsPopupVC.h"

@interface RigReportsPopupVC ()

@end

@implementation RigReportsPopupVC
@synthesize rigReport;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    self.lblLease.text = [[DBManager sharedInstance] getLeaseNameFromLease:rigReport.lease];
    self.lblDate.text = [df stringFromDate:rigReport.reportDate];
    self.lblWellNumber.text = rigReport.wellNum == nil ? @"-" : rigReport.wellNum;
    self.lblCompany.text = rigReport.company;
    self.lblUser.text = [[DBManager sharedInstance] getUserName:rigReport.entryUser];
    self.lblComments.text = rigReport.comments;
    if (rigReport.dailyCost == nil || [rigReport.dailyCost isEqualToString:@""] || [rigReport.dailyCost floatValue] == 0) {
        self.lblDailyCost.text = @"$ -";
    } else {
        self.lblDailyCost.text = [NSString stringWithFormat:@"$%.02f", [rigReport.dailyCost floatValue]];
    }
    
    if (rigReport.totalCost == nil || [rigReport.totalCost isEqualToString:@""] || [rigReport.totalCost floatValue] == 0) {
        self.lblTotalCost.text = @"$ -";
    } else {
        self.lblTotalCost.text = [NSString stringWithFormat:@"$%.02f", [rigReport.totalCost floatValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

@end
