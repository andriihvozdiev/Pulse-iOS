#import <UIKit/UIKit.h>

@interface ChronCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblReportDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UITextView *lblComments;

@property (weak, nonatomic) IBOutlet UILabel *lblTubingTitle;
@property (weak, nonatomic) IBOutlet UITextView *lblTubing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodsTitleTopMargin;
@property (weak, nonatomic) IBOutlet UILabel *lblRodsTitle;
@property (weak, nonatomic) IBOutlet UITextView *lblRods;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
