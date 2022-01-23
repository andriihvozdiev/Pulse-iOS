#import <UIKit/UIKit.h>
#import "AppData.h"

@interface WellheadDataVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>

//@property (nonatomic, strong) id previewingContext;

@property (nonatomic, strong) PulseProdHome*    pulseProdHome;
@property (nonatomic, strong) NSArray*          arrWells;
@property NSInteger                             selectedIndex;
@property (nonatomic, strong) WellList*         welllist;
@property (nonatomic, strong) NSArray*          arrWellheadData;

@property (nonatomic, strong) NSArray *arrOverviewSectionHeaderTitles;
@property (nonatomic, strong) NSArray *arrOverviewSectionContentTitles;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

// Meun bar
@property (weak, nonatomic) IBOutlet UIButton *btnOverview;
@property (weak, nonatomic) IBOutlet UIButton *btnData;
@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewOverview;
@property (weak, nonatomic) IBOutlet UIView *viewData;

/******** Overview contents ***************/
// detail content
@property (weak, nonatomic) IBOutlet UILabel *lblWellheadTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIButton *btnWBD;
@property (weak, nonatomic) IBOutlet UIButton *btnAddWellData;
@property (weak, nonatomic) IBOutlet UITextView *lblComment;
@property (weak, nonatomic) IBOutlet UITableView *overviewTableView;


/********** Data contents ******************/
@property (weak, nonatomic) IBOutlet UIView *viewDateHeader;
@property (weak, nonatomic) IBOutlet UIView *viewContentHeader;

@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;


///********** Landscape graph ****************/
@property (weak, nonatomic) IBOutlet UIView *graphContainerView;


// portrait button events
- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onOverview:(id)sender;
- (IBAction)onData:(id)sender;

- (IBAction)onSectionHeader:(id)sender;


@end
