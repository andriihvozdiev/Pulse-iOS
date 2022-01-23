#import <UIKit/UIKit.h>

@interface WellheadDataEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdatedDate;
@property (weak, nonatomic) IBOutlet UIButton *btnAutoEdit;

@end
