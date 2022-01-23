#import <UIKit/UIKit.h>
#import "AppData.h"

typedef enum T{
    None,
    TanksType,
    MetersType,
    WellsType
}MenuType;

@interface ProductionDetailMainVC : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ChangedSyncStatusDelegate>
{
    MenuType m_menuType;
}
@property (nonatomic, strong) PulseProdHome *pulseProdHome;

@property (nonatomic, strong) NSArray *arrDetailData;
@property (nonatomic, strong) NSArray *arrTanks;
@property (nonatomic, strong) NSArray *arrMeters;
@property (nonatomic, strong) NSArray *arrWells;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;


@property (weak, nonatomic) IBOutlet UIButton *btnTanks;
@property (weak, nonatomic) IBOutlet UIButton *btnMeters;
@property (weak, nonatomic) IBOutlet UIButton *btnWells;
@property (weak, nonatomic) IBOutlet UIView *underlineView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenterContraint;


@property (weak, nonatomic) IBOutlet UILabel *lblPrevField;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentField;
@property (weak, nonatomic) IBOutlet UILabel *lblNextField;
@property (strong, nonatomic) UIPageViewController *pageController;


/************* Landscape graph view ********************/
@property (weak, nonatomic) IBOutlet UIView *graphContainerView;


- (IBAction)onStoplight:(id)sender;

- (IBAction)onBack:(id)sender;
- (IBAction)onTanks:(id)sender;
- (IBAction)onMeters:(id)sender;
- (IBAction)onWells:(id)sender;

@end
