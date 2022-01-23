#import <UIKit/UIKit.h>
#import "AppData.h"

@interface AddRunTicketsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIDatePicker *datePicker;
    int nTicketOption;
}

@property BOOL isEdit;

@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, strong) NSMutableArray *arrContents;
@property (nonatomic, strong) NSString *strComment;
@property (nonatomic, strong) UIImage *ticketImage;

@property (nonatomic, strong) RunTickets *runTickets;
@property (nonatomic, strong) Tanks *tank;
@property (nonatomic, strong) PulseProdHome *pulseProdHome;

@property (strong, nonatomic) NSMutableArray *arrFeets;
@property (strong, nonatomic) NSMutableArray *arrInches;
@property (strong, nonatomic) NSMutableArray *arrQuarterInches;

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
- (IBAction)onTitle:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSave:(id)sender;

- (IBAction)onAutoEdit:(id)sender;

- (IBAction)onCommentSave:(id)sender;
- (IBAction)onCommentCancel:(id)sender;

@end
