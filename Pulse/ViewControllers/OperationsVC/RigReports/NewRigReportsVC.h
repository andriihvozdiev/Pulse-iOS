#import <UIKit/UIKit.h>
#import "AppData.h"
#import "NewRigReportsImageTableViewCell.h"

typedef enum CommentType {
    NONE,
    Tubing,
    Rods
} CommentType;


@interface NewRigReportsVC : UIViewController <ChangedSyncStatusDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CollectionViewMgrDelegate>

@property (nonatomic, strong) NSArray *arrFields;
@property (strong, nonatomic) NSMutableArray *arrValues;

@property CommentType commentType;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentCancel;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UIView *viewCommentsList;
@property (weak, nonatomic) IBOutlet UIView *viewContainerComments;
@property (weak, nonatomic) IBOutlet UITableView *tblComments;


- (IBAction)onStoplight:(id)sender;

- (IBAction)onBack:(id)sender;
- (IBAction)onSave:(id)sender;

- (IBAction)onCommentSave:(id)sender;
- (IBAction)onCommentCancel:(id)sender;

@end
