#import <UIKit/UIKit.h>
#import "AppData.h"

@interface TankGaugeEntryVC : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangedSyncStatusDelegate>

@property (nonatomic, strong) PulseProdHome *pulseProdHome;
@property (nonatomic, strong) NSArray *arrTanks;
@property NSInteger selectedIndex;
@property (nonatomic, strong) Tanks *tank;
@property (nonatomic, strong) NSArray *arrTankGaugeEntry;
@property (nonatomic, strong) NSArray *arrRunTickets;
@property (nonatomic, strong) TankStrappings *tankStrappings;

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

/**************** Overview *****************/
@property (weak, nonatomic) IBOutlet UIView *viewOverview;
@property (weak, nonatomic) IBOutlet UILabel *lblTankInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

// Tank percent image
@property (weak, nonatomic) IBOutlet UIView *viewTankFillage;

@property (weak, nonatomic) IBOutlet UIImageView *tankFillageBottomImage;
@property (weak, nonatomic) IBOutlet UIImageView *tankFillageBodyImage;
@property (weak, nonatomic) IBOutlet UIImageView *tankFillageTopImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tankFillageHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblTankFillage;

// tank Feet image
@property (weak, nonatomic) IBOutlet UIView *viewTankFeet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tankFeetHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *tankFeetImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTankFeet;

// comment
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (weak, nonatomic) IBOutlet UIButton *btnAddTankGauge;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRunTicket;

// for runticket
@property (weak, nonatomic) IBOutlet UITableView *runTicketsTable;

@property (weak, nonatomic) IBOutlet UIView *viewTicketImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgTicketImage;

/************ Data view ****************/
@property (weak, nonatomic) IBOutlet UIView *viewData;
@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (weak, nonatomic) IBOutlet UIView *viewDateHeader;
@property (weak, nonatomic) IBOutlet UIView *viewContentHeader;

@property (weak, nonatomic) IBOutlet UIView *viewCategoryRunticket;

/************* landscape graph *************/
@property (weak, nonatomic) IBOutlet UIView *graphContainerView;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onOverview:(id)sender;
- (IBAction)onData:(id)sender;

- (IBAction)onTicketImage:(id)sender;
- (IBAction)onFullTicketImage:(id)sender;

@end
