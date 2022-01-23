#import <UIKit/UIKit.h>

@interface MainTabbarViewController : UITabBarController <UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

-(void)popToRootViewController;

@end
