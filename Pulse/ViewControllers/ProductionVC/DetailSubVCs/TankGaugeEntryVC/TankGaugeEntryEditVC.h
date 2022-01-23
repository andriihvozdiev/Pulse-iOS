#import <UIKit/UIKit.h>
#import "AppData.h"


@interface TankGaugeEntryEditVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>
{
    UIDatePicker *datePicker;
}

@property (nonatomic) BOOL isNew;
@property (nonatomic, strong) TankGaugeEntry *tankGaugeEntry;

@property (nonatomic, strong) NSArray *arrTanks;

@property (strong, nonatomic) NSString *strLease;
@property (strong, nonatomic) NSString *strLeaseName;
@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strTime;
@property (strong, nonatomic) NSMutableArray *arrTankHeights;
@property (strong, nonatomic) NSString *strComment;

@property (strong, nonatomic) NSMutableArray *arrFeets;
@property (strong, nonatomic) NSMutableArray *arrInches;
@property (strong, nonatomic) NSMutableArray *arrQuarterInches;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentCancel;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSave:(id)sender;

- (IBAction)onCommentSave:(id)sender;
- (IBAction)onCommentCancel:(id)sender;


@end
