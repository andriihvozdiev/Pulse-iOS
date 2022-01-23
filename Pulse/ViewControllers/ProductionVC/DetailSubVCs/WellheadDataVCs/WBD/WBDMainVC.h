#import <UIKit/UIKit.h>
#import "AppData.h"
//#import "UIActivityIndicator.h"
#import <MCActivityButton/MCActivityButton.h>

@protocol PullAllChronDelegate <NSObject>
@optional
- (void)didFinishDownload;
@end

@interface WBDMainVC : UIViewController <ChangedSyncStatusDelegate>

@property (nonatomic, strong) WellList *welllist;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

// Meun bar
@property (weak, nonatomic) IBOutlet UIButton *btnCsg;
@property (weak, nonatomic) IBOutlet UIButton *btnTbg;
@property (weak, nonatomic) IBOutlet UIButton *btnPump;
@property (weak, nonatomic) IBOutlet UIButton *btnCompletion;
@property (weak, nonatomic) IBOutlet MCActivityButton *btnChron;

@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewCsgCmt;
@property (weak, nonatomic) IBOutlet UIView *viewTbgRods;
@property (weak, nonatomic) IBOutlet UIView *viewPump;
@property (weak, nonatomic) IBOutlet UIView *viewCompletion;
@property (weak, nonatomic) IBOutlet UIView *viewChron;

@property (nonatomic, weak) id  pullAllChronDelegate;


- (IBAction)onBack:(id)sender;
- (IBAction)onStoplight:(id)sender;

- (IBAction)onCsg:(id)sender;
- (IBAction)onTbg:(id)sender;
- (IBAction)onPump:(id)sender;
- (IBAction)onCompletion:(id)sender;
- (IBAction)onChron:(id)sender;


- (void)syncAllChrons;
@end
