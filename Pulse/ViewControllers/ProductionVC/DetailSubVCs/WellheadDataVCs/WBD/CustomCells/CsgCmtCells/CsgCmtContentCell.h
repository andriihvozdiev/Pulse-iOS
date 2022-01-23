#import <UIKit/UIKit.h>

@interface CsgCmtContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCsgTD;
@property (weak, nonatomic) IBOutlet UILabel *lblCmtQty;
@property (weak, nonatomic) IBOutlet UILabel *lblCmtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblCmtCalcToC;
@property (weak, nonatomic) IBOutlet UILabel *lblVerifiedCmtToC;
@property (weak, nonatomic) IBOutlet UILabel *lblInfoSource;

@end
