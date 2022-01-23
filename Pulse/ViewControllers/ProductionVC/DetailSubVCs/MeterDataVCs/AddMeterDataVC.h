
#import <UIKit/UIKit.h>
#import "AppData.h"

@interface AddMeterDataVC : UIViewController<UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>
{
    UIDatePicker *datePicker;
}

@property (nonatomic) BOOL isNew;
@property (nonatomic, strong) GasMeterData *m_gasMeterData;
@property (nonatomic, strong) WaterMeterData *m_waterMeterData;

@property (nonatomic, strong) PulseProdHome *pulseProdHome;
@property (nonatomic, strong) Meters *meter;
@property (nonatomic, strong) NSArray *arrMeterData;

@property (nonatomic, strong) NSArray *arrGasMeterTitles;
@property (nonatomic, strong) NSArray *arrWaterMeterTitles;
@property (nonatomic, strong) NSMutableArray *arrContents;

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

- (IBAction)onCommentSave:(id)sender;
- (IBAction)onCommentCancel:(id)sender;


@end
