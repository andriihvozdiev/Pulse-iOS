
#import <UIKit/UIKit.h>

@interface NewInvoiceHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTrailingForBtnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnAutoFillComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShowCommentsList;


@end
