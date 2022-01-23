#import <UIKit/UIKit.h>
#import "AppData.h"

@interface InvoicesPopupVC : UIViewController

@property (nonatomic, strong) Invoices *invoice;


@property (weak, nonatomic) IBOutlet UILabel *lblLease;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblWellNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblInvoiceComment;

@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblPeople;
@property (weak, nonatomic) IBOutlet UILabel *lblDailyCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCost;

@end
