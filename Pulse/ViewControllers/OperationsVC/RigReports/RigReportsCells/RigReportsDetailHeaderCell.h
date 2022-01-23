#import <UIKit/UIKit.h>

@interface RigReportsDetailHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnAddWidthConstraint;

@end
