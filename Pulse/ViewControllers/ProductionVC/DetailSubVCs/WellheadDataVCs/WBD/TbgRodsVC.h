#import <UIKit/UIKit.h>
#import "AppData.h"

@interface TbgRodsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WellList *welllist;

@property (nonatomic, strong) NSArray *arrTbg;
@property (nonatomic, strong) NSArray *arrRods;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tubingContentHeight;

@property (weak, nonatomic) IBOutlet UIView *viewTubingHeader;
@property (weak, nonatomic) IBOutlet UIView *viewRodsHeader;

@property (weak, nonatomic) IBOutlet UIImageView *imgTubingDropIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgRodsDropIcon;


@property (weak, nonatomic) IBOutlet UITableView *tbgTableview;
@property (weak, nonatomic) IBOutlet UITableView *rodsTableview;


-(void) reloadData;
- (IBAction)onTubingGroup:(id)sender;
- (IBAction)onRodsGroup:(id)sender;

@end
