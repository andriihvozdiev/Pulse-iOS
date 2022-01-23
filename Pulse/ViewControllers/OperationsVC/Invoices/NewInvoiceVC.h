
#import <UIKit/UIKit.h>
#import "AppData.h"
#import "NewInvoiceImageCell.h"

@interface NewInvoiceVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CollectionViewMgrDelegateForInvoice>
{
    UIDatePicker *datePicker;
}

@property (nonatomic, strong) Invoices *invoice;
@property (nonatomic, strong) NSMutableArray *arrLeases;
@property (nonatomic, strong) NSMutableArray *arrLeaseNames;

@property (nonatomic, strong) NSMutableArray *arrSectionTitles;

@property (nonatomic, strong) NSString *strSelectedLease;
@property (nonatomic, strong) NSMutableArray *arrPeople;
@property (nonatomic, strong) NSArray *arrWells;
@property (nonatomic, strong) NSMutableArray *arrWellNumber;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (assign, nonatomic) BOOL isEdit;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gesHeaderTapped;

@property (weak, nonatomic) IBOutlet UIView *viewCommentsList;
@property (weak, nonatomic) IBOutlet UIView *viewCommentsContainer;
@property (weak, nonatomic) IBOutlet UITableView *tblComments;

- (IBAction)onStoplight:(id)sender;

- (IBAction)onBack:(id)sender;

- (IBAction)onCreate:(id)sender;

- (IBAction)onHeaderTapped:(id)sender;

@end
