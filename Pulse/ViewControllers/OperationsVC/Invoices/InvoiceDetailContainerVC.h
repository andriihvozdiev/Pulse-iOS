#import <UIKit/UIKit.h>
#import "AppData.h"

@interface InvoiceDetailContainerVC : UIViewController <ChangedSyncStatusDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) NSArray *arrInvoicesData;
@property (strong, nonatomic) NSMutableArray *arrInvoices;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property NSInteger selectedIndex;

- (IBAction)onBack:(id)sender;
- (IBAction)onStoplight:(id)sender;

@end
