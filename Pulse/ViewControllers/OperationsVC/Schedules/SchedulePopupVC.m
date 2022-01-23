#import "SchedulePopupVC.h"

@interface SchedulePopupVC ()

@end

@implementation SchedulePopupVC
@synthesize schedule;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblLease.text = [[DBManager sharedInstance] getLeaseNameFromLease:schedule.lease];
    self.lblWellNumber.text = schedule.wellNumber == nil ? @"-" : schedule.wellNumber;
    self.lblSchedulType.text = schedule.scheduleType;
    self.lblStatus.text = schedule.status;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *strDate = [df stringFromDate:schedule.date];
    self.lblDate.text = strDate;
    
    self.lblUser.text = [[DBManager sharedInstance] getUserName:schedule.entryUserID];
    
    self.lblEngrComments.text = schedule.engrComments == nil ? @"-" : schedule.engrComments;
    self.lblAcctComments.text = schedule.acctComments == nil ? @"-" : schedule.acctComments;
    self.lblFieldComments.text = schedule.fieldComments == nil ? @"-" : schedule.fieldComments;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

@end
