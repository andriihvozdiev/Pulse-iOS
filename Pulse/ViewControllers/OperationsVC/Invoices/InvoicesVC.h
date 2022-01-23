#import <UIKit/UIKit.h>
@import PeekPop;

typedef enum InvoiceSortType{
    PRIMARY,
    SECONDARY,
    EXPORT,
    DATE,
    LEASE,
    ACCOUNT,
    PEOPLE
}InvoiceSortType;

@interface InvoicesVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>
{
    InvoiceSortType m_sorttype;
}

@property (nonatomic, strong) UIViewController *parentOperationVC;
@property (nonatomic, assign) CGFloat nPosY;
@property (nonatomic, strong) PeekPop *peekPop;
@property (nonatomic, strong) PreviewingContext *previewingContext;
@property (nonatomic, strong) NSMutableArray *arrSectionStatus;

@property (nonatomic, strong) NSArray *arrInvoicesPrimary;
@property (nonatomic, strong) NSArray *arrInvoicesSecondary;
@property (nonatomic, strong) NSArray *arrInvoicesExport;

@property (nonatomic, strong) NSArray *arrInvoicesByDate;
@property (nonatomic, strong) NSArray *arrInvoicesByLease;
@property (nonatomic, strong) NSArray *arrInvoicesByAccount;
@property (nonatomic, strong) NSArray *arrInvoicesByPeople;

//@property (nonatomic, strong) id previewingContext;

@property (weak, nonatomic) IBOutlet UILabel *lblSortType;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title4WidthConstraint;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCreateInvoice;

- (void) reloadData;

- (IBAction)onSortType:(id)sender;
- (IBAction)onCreateInvoice:(id)sender;

- (IBAction)sectionHeaderTapped:(id)sender;

@end
