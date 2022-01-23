
#import "InvoicesPopupVC.h"

@interface InvoicesPopupVC ()

@end

@implementation InvoicesPopupVC
@synthesize invoice;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *lease = invoice.lease;
    self.lblLease.text = [[DBManager sharedInstance] getLeaseNameFromPropNum:lease];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy"];
    
    self.lblDate.text = [defaultFormatter stringFromDate:invoice.invoiceDate];
    self.lblWellNumber.text = invoice.wellNumber == nil ? @"-" : invoice.wellNumber;
    
    NSArray *arrInvoiceDetails = [[DBManager sharedInstance] getInvoiceDetail:invoice.invoiceID appID:invoice.invoiceAppID];
    NSInteger accountCount = arrInvoiceDetails.count;
    
    InvoicesDetail *firstInvoiceDetail = arrInvoiceDetails[0];
    
    InvoiceAccounts *account = [[DBManager sharedInstance] getAccount:firstInvoiceDetail.account withSub:firstInvoiceDetail.accountSub];
    NSString *accounts = [NSString stringWithFormat:@"%@ - %@", account.account, account.subAccount];
    if (!account.subAccount) {
        accounts = account.account;
    }
    
    if (accountCount > 1) {
        accounts = [NSString stringWithFormat:@"%d Account", (int)accountCount];
        
        for (InvoicesDetail *invoiceDetail in arrInvoiceDetails) {
            account = [[DBManager sharedInstance] getAccount:invoiceDetail.account withSub:invoiceDetail.accountSub];
            NSString *strAccount = [NSString stringWithFormat:@"%@ - %@", account.account, account.subAccount];
            if (!account.subAccount) {
                strAccount = account.account;
            }
            accounts = [NSString stringWithFormat:@"%@\n%@", accounts, strAccount];
        }
        
    }
    self.lblAccount.text = accounts;
    
    NSArray *arrInvoicePeople = [[DBManager sharedInstance] getInvoicePersonnel:invoice.invoiceID appID:invoice.invoiceAppID];
    
    InvoicesPersonnel *firstPeople = arrInvoicePeople[0];
    NSString *people = [[DBManager sharedInstance] getUserName:firstPeople.userID];
    
    if (arrInvoicePeople.count > 1) {
        
        people = [NSString stringWithFormat:@"%d People", (int)arrInvoicePeople.count];
        
        for (InvoicesPersonnel *invoicePersonnel in arrInvoicePeople) {
            NSString *peopleName = [[DBManager sharedInstance] getUserName:invoicePersonnel.userID];
            people = [NSString stringWithFormat:@"%@\n%@", people, peopleName];
        }
    }
    self.lblPeople.text = people;
    
    self.lblInvoiceComment.text = invoice.comments;
    
    if (invoice.dailyCost == nil || [invoice.dailyCost isEqualToString:@""] || [invoice.dailyCost floatValue] == 0) {
        self.lblDailyCost.text = @"$ -";
    } else {
        self.lblDailyCost.text = [NSString stringWithFormat:@"$%.02f", [invoice.dailyCost floatValue]];
    }
    if (invoice.totalCost == nil || [invoice.totalCost isEqualToString:@""] || [invoice.totalCost floatValue] == 0) {
        self.lblTotalCost.text = @"$ -";
    } else {
        self.lblTotalCost.text = [NSString stringWithFormat:@"$%.02f", [invoice.totalCost floatValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


@end
