#import <UIKit/UIKit.h>

#import "AppData.h"
@import PeekPop;

typedef enum SortType{
    Date,
    All,
    Route,
    Operator,
    Owner
}SortType;

@interface ProductionMainVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate, ChangedSyncStatusDelegate>
{
    SortType m_sorttype;
}

@property (nonatomic, strong) NSMutableArray *arrSectionStatus;

@property (nonatomic, strong) NSArray *arrLeaseByAll;
@property (nonatomic, strong) NSArray *arrLeaseByDate;
@property (nonatomic, strong) NSArray *arrLeaseByRoute;
@property (nonatomic, strong) NSArray *arrLeaseByOperator;
@property (nonatomic, strong) NSArray *arrLeaseByOwner;
@property (nonatomic, strong) NSArray *arrLeaseByAllFilter;
@property (nonatomic, strong) NSArray *arrLeaseByDateFilter;
@property (nonatomic, strong) NSArray *arrLeaseByRouteFilter;
@property (nonatomic, strong) NSArray *arrLeaseByOperatorFilter;
@property (nonatomic, strong) NSArray *arrLeaseByOwnerFilter;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (nonatomic, strong) PeekPop *peekPop;
@property (nonatomic, strong) PreviewingContext *previewingContext;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//
//
//@property (nonatomic, strong) id previewingContext;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onStoplight:(id)sender;
- (IBAction)onDropDown:(id)sender;
- (IBAction)sectionHeaderTapped:(id)sender;

@end
