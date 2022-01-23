#import <UIKit/UIKit.h>

@interface RotateRecognizer : UIGestureRecognizer
{
    
}

/**
 The rotation of the gesture in radians since its last change.
 */
@property (nonatomic, assign) CGFloat rotation;

@end
