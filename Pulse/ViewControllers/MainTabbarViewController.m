#import "MainTabbarViewController.h"

#import "AppData.h"

@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController
@synthesize tabBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidLayoutSubviews {
    float tabWidth = self.tabBar.frame.size.width/(float)self.tabBar.items.count;
    float tabHeight = self.tabBar.frame.size.height + 1;
    UIColor *indicatorImageColor = [UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:1];
    
    
    
    self.tabBar.selectionIndicatorImage = [[self imageWithColor:indicatorImageColor size:CGSizeMake(tabWidth, tabHeight)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    CGRect frame = self.tabBar.frame;
    frame.size.width = self.view.frame.size.width + 4;
    frame.origin.x = -2;
    self.tabBar.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
