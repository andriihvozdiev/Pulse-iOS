#import <UIKit/UIKit.h>
#import "AppData.h"

@interface CompletionVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WellList *welllist;

@property (nonatomic, strong) NSArray *arrPerforations;
@property (nonatomic, strong) NSArray *arrTreatments;

@property (weak, nonatomic) IBOutlet UIView *viewPerforationHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgPerforationDropdown;

@property (weak, nonatomic) IBOutlet UIView *viewTreatmentsHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgTreatmentsDropdown;

@property (weak, nonatomic) IBOutlet UITableView *perforationTableview;
@property (weak, nonatomic) IBOutlet UITableView *treatmentsTableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *perforationContentHeight;

- (IBAction)onPerforationHeader:(id)sender;
- (IBAction)onTreatmentsHeader:(id)sender;

-(void) reloadData;

@end
