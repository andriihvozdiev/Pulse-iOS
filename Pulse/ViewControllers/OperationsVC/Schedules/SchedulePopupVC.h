#import <UIKit/UIKit.h>
#import "AppData.h"

@interface SchedulePopupVC : UIViewController

@property (nonatomic, strong) Schedules *schedule;

@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UILabel *lblWellNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulType;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;

@property (weak, nonatomic) IBOutlet UILabel *lblEngrComments;
@property (weak, nonatomic) IBOutlet UILabel *lblAcctComments;
@property (weak, nonatomic) IBOutlet UILabel *lblFieldComments;

@end
