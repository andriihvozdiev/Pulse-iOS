#import "WheelVC.h"
#import "RotateRecognizer.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180 / M_PI)

@interface WheelVC () <UIGestureRecognizerDelegate>
{
    
}

@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat stopAngle;

@end

@implementation WheelVC
@synthesize currentAngle = _currentAngle;
@synthesize startAngle = _startAngle;
@synthesize stopAngle = _stopAngle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RotateRecognizer *spin = [[RotateRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
    [self.rotatePan addGestureRecognizer:spin];
    [self.rotatePan  setUserInteractionEnabled:YES];
    
    // Allow rotation between the start and stop angles.
    [self setStartAngle:0];
    [self setStopAngle:360];
    
}

- (void)rotated:(RotateRecognizer *)recognizer
{
    CGFloat degrees = radiansToDegrees([recognizer rotation]);
    CGFloat currentAngle = [self currentAngle] + degrees;
    
    BOOL shouldRotate = YES;
    
    if (shouldRotate) {
        [self setCurrentAngle:currentAngle];
        UIView *view = [recognizer view];
        [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
    }
}

@end
