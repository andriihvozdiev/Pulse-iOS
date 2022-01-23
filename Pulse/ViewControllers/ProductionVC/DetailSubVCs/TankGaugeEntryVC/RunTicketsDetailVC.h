
#import <UIKit/UIKit.h>
#import "AppData.h"

@interface RunTicketsDetailVC : UIViewController <ChangedSyncStatusDelegate>

@property (nonatomic, strong) RunTickets *ticket;
@property (nonatomic, strong) Tanks *tank;
@property (nonatomic, strong) PulseProdHome *pulseProdHome;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

// top view
@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UILabel *lblTankNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoImageForTicket;

@property (weak, nonatomic) IBOutlet UIImageView *imgTicket;

@property (weak, nonatomic) IBOutlet UIButton *btnEditRunTicket;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteRunTicket;

// ticket image popup
@property (weak, nonatomic) IBOutlet UIView *viewTicketImagePopup;
@property (weak, nonatomic) IBOutlet UIImageView *imgFullTicket;

/**** Gauge View ***/
// Top(1) Gauge
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature1;
@property (weak, nonatomic) IBOutlet UILabel *lblOilFeet1;
@property (weak, nonatomic) IBOutlet UILabel *lblOilInches1;
@property (weak, nonatomic) IBOutlet UILabel *lblOil1;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomsFeet1;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomsInches1;

// Bottom(2) Gauge
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature2;
@property (weak, nonatomic) IBOutlet UILabel *lblOilFeet2;
@property (weak, nonatomic) IBOutlet UILabel *lblOilInches2;
@property (weak, nonatomic) IBOutlet UILabel *lblOil2;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomsFeet2;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomsInches2;

// Observed Fluid Characteristics
@property (weak, nonatomic) IBOutlet UILabel *lblObsGrav;
@property (weak, nonatomic) IBOutlet UILabel *lblObsTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblObsBSW;

// Run totals and Specs
@property (weak, nonatomic) IBOutlet UILabel *lblGrossVol;
@property (weak, nonatomic) IBOutlet UILabel *lblNetVol;
@property (weak, nonatomic) IBOutlet UILabel *lblCalcGrossVol;
@property (weak, nonatomic) IBOutlet UILabel *lblCalcNetVol;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeOn;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeOff;
@property (weak, nonatomic) IBOutlet UILabel *lblHauler;
@property (weak, nonatomic) IBOutlet UILabel *lblDriver;

// Comments
@property (weak, nonatomic) IBOutlet UILabel *lblCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onEdit:(id)sender;
- (IBAction)onDelete:(id)sender;

- (IBAction)onTicketImage:(id)sender;
- (IBAction)onFullTicketImage:(id)sender;

@end
