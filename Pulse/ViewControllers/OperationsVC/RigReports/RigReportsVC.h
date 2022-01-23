#import <UIKit/UIKit.h>
#import "AppData.h"
@import PeekPop;

typedef enum RigReportsSortType{
    ReportsDate,
    ReportsLease,
}RigReportsSortType;

@interface RigReportsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>
{
    RigReportsSortType m_sorttype;
}

@property (nonatomic, strong) PeekPop *peekPop;
@property (nonatomic, strong) PreviewingContext *previewingContext;
@property (nonatomic, strong) UIViewController *parentOperationVC;
@property (nonatomic, strong) NSMutableArray *arrSectionStatus;

@property (nonatomic, strong) NSArray *arrRigReportsByDate;
@property (nonatomic, strong) NSArray *arrRigReportsByLease;

//@property (nonatomic, strong) id previewingContext;


@property (weak, nonatomic) IBOutlet UILabel *lblSortType;
@property (weak, nonatomic) IBOutlet UILabel *lblLease;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateRigReports;


- (void) reloadData;

- (IBAction)onSortType:(id)sender;
- (IBAction)onCreateRigReports:(id)sender;

- (IBAction)sectionHeaderTapped:(id)sender;

@end
