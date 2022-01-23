#import <UIKit/UIKit.h>

#import "AppData.h"
@import PeekPop;

typedef enum ScheduleSortType{
    ScheduleLease,
    ScheduleTypes,
    ScheduleDate,
    ScheduleStatus,
} ScheduleSortType;



@interface ScheduleVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>
{
    ScheduleSortType m_sorttype;
}

@property (nonatomic, strong) UIViewController *parentOperationVC;
@property (nonatomic, strong) NSMutableArray *arrSectionStatus;
@property (nonatomic, strong) PeekPop *peekPop;
@property (nonatomic, strong) PreviewingContext *previewingContext;
@property (nonatomic, strong) NSArray *arrSchedulesByLease;
@property (nonatomic, strong) NSArray *arrSchedulesByType;
@property (nonatomic, strong) NSArray *arrSchedulesByDate;
@property (nonatomic, strong) NSArray *arrSchedulesByStatus;

//@property (nonatomic, strong) id previewingContext;

@property (weak, nonatomic) IBOutlet UILabel *lblSortType;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle4;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title4WidthConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCreateTask;

- (void) reloadData;

- (IBAction)onSortType:(id)sender;
- (IBAction)sectionHeaderTapped:(id)sender;
- (IBAction)onCreateTask:(id)sender;


@end
