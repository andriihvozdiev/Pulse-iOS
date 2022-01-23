
#import <UIKit/UIKit.h>
#import "AppData.h"

@interface AddWellheadDataVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>
{
    UIDatePicker *datePicker;
}

@property (nonatomic) BOOL isNew;
@property (nonatomic, strong) WellList *welllist;
@property (nonatomic, strong) WellheadData *wellheadData;
@property (nonatomic, strong) NSMutableDictionary *dicWellheadData;


@property (nonatomic, strong) NSArray *arrWellheadTitles;
@property (nonatomic, strong) NSMutableArray *arrContents;
@property (nonatomic, strong) NSMutableArray *arrContentsUpdatedTime;

@property (nonatomic, strong) NSString *strComment;


@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentCancel;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSave:(id)sender;

- (IBAction)onAutoEdit:(id)sender;
- (IBAction)toggleOnOff:(id)sender;

- (IBAction)onCommentSave:(id)sender;
- (IBAction)onCommentCancel:(id)sender;

@end
