#import <UIKit/UIKit.h>

@interface RunTicketTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblGross;
@property (weak, nonatomic) IBOutlet UILabel *lblNet;
@property (weak, nonatomic) IBOutlet UIImageView *ticketImage;
@property (weak, nonatomic) IBOutlet UIButton *btnTicketImage;
@property (weak, nonatomic) IBOutlet UIView *viewCategory;

@end
