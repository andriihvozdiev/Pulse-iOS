#import <UIKit/UIKit.h>
#import "AppData.h"

typedef enum CommentType {
    NONE,
    TUBING,
    ROD
}CommentType;

@interface InvoiceCommentVC : UIViewController <UITextViewDelegate, ChangedSyncStatusDelegate>

@property CommentType commentType;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSave:(id)sender;

@end
