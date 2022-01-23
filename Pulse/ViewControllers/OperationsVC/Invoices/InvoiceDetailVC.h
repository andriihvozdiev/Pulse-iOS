#import <UIKit/UIKit.h>
#import "AppData.h"

@interface InvoiceDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property NSInteger index;

@property (nonatomic, strong) Invoices *invoice;
@property (nonatomic, strong) NSArray *arrInvoicesDetail;

@property (weak, nonatomic) IBOutlet UIButton *btnField;
@property (weak, nonatomic) IBOutlet UIButton *btnOffice;
@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblNoImage;

@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property (weak, nonatomic) IBOutlet UIView *officeView;
@property (weak, nonatomic) IBOutlet UIButton *btnEditComment;
@property (weak, nonatomic) IBOutlet UILabel *lblDailyCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;

/*********** Field Approval *********************/
@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UIButton *btnEditAll;
@property (weak, nonatomic) IBOutlet UILabel *lblWellNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkers;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIImageView *imgEditable;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewInvoiceImage;

@property (weak, nonatomic) IBOutlet UITextView *lblComment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollComment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeightConstraint;

// table title views
@property (weak, nonatomic) IBOutlet UIView *viewFieldTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAddField;

@property (weak, nonatomic) IBOutlet UIView *viewOfficeTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAddOffice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeightContraint;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnApprove;


/*********** Office Approval ****************/
@property (weak, nonatomic) IBOutlet UIView *viewPrimary;
@property (weak, nonatomic) IBOutlet UIView *viewSecondary;
@property (weak, nonatomic) IBOutlet UIView *viewOutside;
@property (weak, nonatomic) IBOutlet UIView *viewNobill;

@property (weak, nonatomic) IBOutlet UILabel *lblPrimaryTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondaryTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblOutsideTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNobillTitle;



- (IBAction)onField:(id)sender;
- (IBAction)onOffice:(id)sender;

/********* field Approval button events ***********/
- (IBAction)onEdit:(id)sender;
- (IBAction)onApprove:(id)sender;
- (IBAction)onAddField:(id)sender;

/********** Office Approval button events **********/
- (IBAction)onAddOffice:(id)sender;

- (IBAction)onPrimary:(id)sender;
- (IBAction)onSecondary:(id)sender;
- (IBAction)onOutside:(id)sender;
- (IBAction)onNobill:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewImageContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCommentViewTop;

@end
