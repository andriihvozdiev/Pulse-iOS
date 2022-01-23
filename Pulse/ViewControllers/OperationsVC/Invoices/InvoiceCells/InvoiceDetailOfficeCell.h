
#import <UIKit/UIKit.h>

@interface InvoiceDetailOfficeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblUnits;

@property (weak, nonatomic) IBOutlet UILabel *lblExpRef;
@property (weak, nonatomic) IBOutlet UILabel *lblExpJrnl;
@property (weak, nonatomic) IBOutlet UILabel *lblExpAcct;

@property (weak, nonatomic) IBOutlet UILabel *lblIncRef;
@property (weak, nonatomic) IBOutlet UILabel *lblIncJrnl;
@property (weak, nonatomic) IBOutlet UILabel *lblIncAcct;
@property (weak, nonatomic) IBOutlet UILabel *lblIncSubAcct;

@end
