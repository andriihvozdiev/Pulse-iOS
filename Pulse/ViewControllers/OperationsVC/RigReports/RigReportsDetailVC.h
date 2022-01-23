#import <UIKit/UIKit.h>
#import "AppData.h"

@interface RigReportsDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property NSInteger index;
@property (nonatomic, strong) RigReports *rigReports;

@property (nonatomic, strong) NSMutableArray *arrRigReportsRods;
@property (nonatomic, strong) NSMutableArray *arrRigReportsPump;
@property (nonatomic, strong) NSMutableArray *arrRigReportsTubing;

@property (nonatomic, strong) NSMutableArray *arrComments;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewRig;
@property (weak, nonatomic) IBOutlet UILabel *lblNoImage;

@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UILabel *lblWellNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UILabel *lblEditable;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIImageView *imgEditable;

@property (weak, nonatomic) IBOutlet UITableView *commentTableview;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnIn;
@property (weak, nonatomic) IBOutlet UIButton *btnOut;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblDailyCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;



- (IBAction)onIn:(id)sender;
- (IBAction)onOut:(id)sender;

- (IBAction)onEdit:(id)sender;

- (IBAction)AddReportsDetail:(id)sender;

@end
