
#import <UIKit/UIKit.h>

@interface InvoiceTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblValue1;
@property (weak, nonatomic) IBOutlet UILabel *lblValue2;
@property (weak, nonatomic) IBOutlet UILabel *lblValue3;
@property (weak, nonatomic) IBOutlet UILabel *lblValue4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *value4Width;

@end
