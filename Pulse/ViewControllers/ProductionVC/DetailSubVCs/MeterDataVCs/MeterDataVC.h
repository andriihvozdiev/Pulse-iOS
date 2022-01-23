
#import <UIKit/UIKit.h>
#import "AppData.h"

@interface MeterDataVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>

//@property (nonatomic, strong) id previewingContext;

@property (nonatomic, strong) PulseProdHome *pulseProdHome;
@property (nonatomic, strong) NSArray *arrMeters;
@property NSInteger selectedIndex;
@property (nonatomic, strong) Meters *meter;

@property (nonatomic, strong) NSArray *arrMeterData;
@property (nonatomic, strong) NSArray *arrMeterRates;

@property (nonatomic, strong) NSArray *arrOverviewSectionHeaderTitles;
@property (nonatomic, strong) NSArray *arrOverviewSectionContentTitles;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

// menu bar
@property (weak, nonatomic) IBOutlet UIButton *btnOverview;
@property (weak, nonatomic) IBOutlet UIButton *btnData;
@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterConstraint;


@property (weak, nonatomic) IBOutlet UIView *viewOverview;
@property (weak, nonatomic) IBOutlet UIView *viewData;

/***************** Overview Content ****************/
// detail content
@property (weak, nonatomic) IBOutlet UILabel *lblMeterTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblMeterProblem;

@property (weak, nonatomic) IBOutlet UIButton *btnAddMeterData;

// Comment
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (weak, nonatomic) IBOutlet UITableView *overviewTableView;


/***************** Data Content ****************/
@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

/***************** Landscape graph view *********/
@property (weak, nonatomic) IBOutlet UIView *graphContainerView;

// portrait button events
- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onOverview:(id)sender;
- (IBAction)onData:(id)sender;

- (IBAction)onSectionHeader:(id)sender;


@end
