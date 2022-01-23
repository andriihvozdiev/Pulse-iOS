#import <UIKit/UIKit.h>
#import "AppData.h"

@interface CsgCmtVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WellList          *welllist;

@property (nonatomic, strong) NSArray           *arrSurveys;
@property (nonatomic, strong) NSArray           *arrCsgCmt;
@property (nonatomic, strong) NSArray           *arrPlugs;


@property (weak, nonatomic) IBOutlet UITableView *surveyTableView;
@property (weak, nonatomic) IBOutlet UITableView *csgcmtTableView;
@property (weak, nonatomic) IBOutlet UITableView *plugSqueezeTableView;

@property (weak, nonatomic) IBOutlet UIView *viewSurveyHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgSurveyDropdown;

@property (weak, nonatomic) IBOutlet UIView *viewCsgCmtHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgCsgCmtDropdown;

@property (weak, nonatomic) IBOutlet UIView *viewPlugSqueezeHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlugSqueezeDropdown;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *surveyContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csgCmtContentHeight;


- (void) reloadData;

- (IBAction)onHoleSurveyGroup:(id)sender;
- (IBAction)onCsgCmtGroup:(id)sender;
- (IBAction)onPlugSqueezeGroup:(id)sender;


@end
