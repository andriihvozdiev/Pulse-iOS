#import <UIKit/UIKit.h>

#import "AppData.h"

typedef enum OperationType{
    None,
    InvoicesType,
    RigReportsType,
    RigScheduleType
} OperationType;


@interface OperationsVC : UIViewController <ChangedSyncStatusDelegate>
{
    OperationType m_operationType;
}

@property (nonatomic, strong) UIViewController  *m_childViewController;
@property (nonatomic, strong) UIView            *m_childView;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UIButton *btnInvoices;
@property (weak, nonatomic) IBOutlet UIButton *btnRigReports;
@property (weak, nonatomic) IBOutlet UIButton *btnSchedule;

@property (weak, nonatomic) IBOutlet UIView     *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterConstraint;


@property (weak, nonatomic) IBOutlet UIView *invoicesContainerView;
@property (weak, nonatomic) IBOutlet UIView *rigReportsContainerView;
@property (weak, nonatomic) IBOutlet UIView *rigScheduleContainerView;


- (IBAction)onStoplight:(id)sender;
- (IBAction)onInvoices:(id)sender;
- (IBAction)onRigReports:(id)sender;
- (IBAction)onSchedule:(id)sender;

- (void) createInvoice;
- (void) createSchedule;
- (void) createRigReports;

@end
