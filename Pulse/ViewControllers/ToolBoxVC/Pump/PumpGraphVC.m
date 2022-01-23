#import "PumpGraphVC.h"

@interface PumpGraphVC ()
{
    NSInteger totalcount;
}
@end

@implementation PumpGraphVC
@synthesize chartView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    chartView = [[JBLineChartView alloc] init];
    chartView.dataSource = self;
    chartView.delegate = self;
    [self.view addSubview:chartView];
    
    self.lblBrandModel.text = @"";
    
    totalcount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.lblDiameter.text = @"";
    self.lblRPM.text = @"";
    self.lblDisplacement.text = @"";
    
    [self initGraph];
}


-(void) initGraph
{
    self.graph_bg.image = nil;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    WaterPumpInfo *waterPumpInfo = [AppData sharedInstance].selectedWaterMeterPumpInfo;
    
    totalcount = 0;
    
    if (waterPumpInfo) {
        self.lblBrandModel.text = [NSString stringWithFormat:@"%@ - %@", waterPumpInfo.brand, waterPumpInfo.oldName];
        if (waterPumpInfo.newName) self.lblBrandModel.text = [NSString stringWithFormat:@"%@/%@", self.lblBrandModel.text, waterPumpInfo.newName];
        
        totalcount = waterPumpInfo.rpMatBHP / 20 + 1;
        if ((totalcount-1) * 20 < waterPumpInfo.rpMatBHP)
            totalcount += 1;
    } else {
        self.lblBrandModel.text = @"Please select Brand and Model";
        return;
    }
    
    if (totalcount == 0) totalcount = 1;
    
    rect.origin.x = 50;
    rect.size.width = (rect.size.width-50) * (totalcount - 1) / (float)totalcount;
    rect.size.height = rect.size.height - 50;  // top: 35, bottom : 50
    chartView.frame = rect;
    
    [chartView setMaximumValue:[self maxDisplacement]];
    [chartView setMinimumValue:0];
    
    [chartView reloadDataAnimated:YES];
    
    [self drawGraphBackground];
}


-(float) maxDisplacement
{
    WaterPumpInfo *waterPumpInfo = [AppData sharedInstance].selectedWaterMeterPumpInfo;
    
    if (!waterPumpInfo) {
        return 0;
    }
    
    float diameter = [waterPumpInfo.maxPlungerD floatValue];
    
    int pumpTypeInt = 1;
    
    if ([waterPumpInfo.pumpType isEqual:@"Simplex"]) {
        pumpTypeInt = 1;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Duplex"]) {
        pumpTypeInt = 2;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Triplex"]) {
        pumpTypeInt = 3;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Quintuplex"]) {
        pumpTypeInt = 4;
    }
    int rpm = waterPumpInfo.rpMatBHP;
    
    float displacement = diameter * diameter * [waterPumpInfo.stroke floatValue] * rpm * pumpTypeInt / 8.579012f;
    
    return displacement;
}

#pragma mark -
-(void) drawGraphBackground
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    //draw the entire image in the specified rectangle frame
    [self.graph_bg.image drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.1f);
    CGContextSetRGBStrokeColor(context, 151/255.0f, 151/255.0f, 151/255.0f, 0.5f);
    CGContextBeginPath(context);
    
    //begin a new new subpath at this point
    float bottomY = screenSize.height - 50;
    float graphHeight = bottomY;
    float maxValue = [self maxDisplacement];
    float step = pow(10, (int)log10f(maxValue));
    float deltaHeight = graphHeight * step / maxValue;
    for (int i = 0; i < maxValue; i += step) {
        float y = bottomY - deltaHeight * i / step;
        CGContextMoveToPoint(context, 45, y);
        CGContextAddLineToPoint(context, screenSize.width, y);
        CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1);
        CGContextStrokePath(context);
        [self addText:[NSString stringWithFormat:@"%d", i] withPoint:CGPointMake(40, y - 8) fontSize:10 align:@"right"];
    }
    
    WaterPumpInfo *waterPumpInfo = [AppData sharedInstance].selectedWaterMeterPumpInfo;
    
    float spacing = (screenSize.width-50) / (float)totalcount;
    for (int i = 0; i < totalcount; i++) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 50 + spacing * i, 5);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 50 + spacing * i, bottomY);
        
        int xAxis = 20 * i;
        if (i == totalcount - 1) xAxis = waterPumpInfo.rpMatBHP;
        
        NSString *strX = [NSString stringWithFormat:@"%d", xAxis];
        [self addText:strX withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:12 align:@"center"];
    }
    
    [self addText:@"Pump RPM" withPoint:CGPointMake(screenSize.width / 2.0f, bottomY + 20) fontSize:14 align:@"center"];
    
    //paint a line along the current path
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    //set the image based on the contents of the current bitmap-based graphics context
    self.graph_bg.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
}

- (void)addText:(NSString*)text withPoint:(CGPoint)point fontSize:(CGFloat)fontSize align:(NSString*)align
{
    UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
    
    CGRect renderingRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
    
    float x = point.x - renderingRect.size.width / 2.0f;
    if ([align isEqual:@"center"]) {
        x = point.x - renderingRect.size.width / 2.0f;
    } else if ([align isEqual:@"left"]) {
        x = point.x;
    } else if ([align isEqual:@"right"]) {
        x = point.x - renderingRect.size.width;
    }
    
    renderingRect = CGRectMake(x, point.y, renderingRect.size.width, renderingRect.size.height);
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *textAttributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [text drawInRect:renderingRect withAttributes:textAttributes];
    
}

-(void)addHorizontalText:(NSString*)text withPoint:(CGPoint)point fontSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
    
    CGRect renderingRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
    
    renderingRect = CGRectMake(point.x - renderingRect.size.width / 2.0f, point.y, renderingRect.size.width, renderingRect.size.height);
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *textAttributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [text drawInRect:renderingRect withAttributes:textAttributes];
}


#pragma mark - JBLineChartView datasource
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    WaterPumpInfo *waterPumpInfo = [AppData sharedInstance].selectedWaterMeterPumpInfo;
    int numberOfLines = ([waterPumpInfo.maxPlungerD floatValue] - [waterPumpInfo.minPlungerD floatValue]) / 0.125f;
    return numberOfLines;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return totalcount;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    float displacement = 0;
    
    WaterPumpInfo *waterPumpInfo = [AppData sharedInstance].selectedWaterMeterPumpInfo;
    
    float minPlungerD = [waterPumpInfo.minPlungerD floatValue];
    
    float diameter = minPlungerD + 1 / 8.0f * lineIndex;
    
    int pumpTypeInt = 1;
    
    if ([waterPumpInfo.pumpType isEqual:@"Simplex"]) {
        pumpTypeInt = 1;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Duplex"]) {
        pumpTypeInt = 2;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Triplex"]) {
        pumpTypeInt = 3;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Quintuplex"]) {
        pumpTypeInt = 4;
    }
    
    int rpm = (int)horizontalIndex * 20;
    if (horizontalIndex == totalcount - 1) {
        rpm = waterPumpInfo.rpMatBHP;
    }
    
    displacement = diameter * diameter * [waterPumpInfo.stroke floatValue] * rpm * pumpTypeInt / 8.579012f;
    
    return displacement;
}


- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    UIColor *lineColor = [UIColor colorWithRed:122/255.0f green:218/255.0f blue:1.0f alpha:1];
    return lineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor clearColor]; // color of area under line in chart
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 1; // width of line in chart
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid; // style of line in chart (solid or dashed)
}


- (JBLineChartViewColorStyle)lineChartView:(JBLineChartView *)lineChartView colorStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewColorStyleSolid; // color line style of a line in the chart
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

#pragma mark - JBLineChartView Delegate
- (JBLineChartViewColorStyle)lineChartView:(JBLineChartView *)lineChartView fillColorStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewColorStyleSolid; // color style for the area under a line in the chart
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return 1;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    UIColor *color  = [UIColor whiteColor];
    
    return color;
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    WaterPumpInfo *waterPumpInfo = [AppData sharedInstance].selectedWaterMeterPumpInfo;
    
    float minPlungerD = [waterPumpInfo.minPlungerD floatValue];
    float diameter = minPlungerD + 1 / 8.0f * lineIndex;
    int pumpTypeInt = 1;
    
    if ([waterPumpInfo.pumpType isEqual:@"Simplex"]) {
        pumpTypeInt = 1;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Duplex"]) {
        pumpTypeInt = 2;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Triplex"]) {
        pumpTypeInt = 3;
    }
    if ([waterPumpInfo.pumpType isEqual:@"Quintuplex"]) {
        pumpTypeInt = 4;
    }
    
    int rpm = (int)horizontalIndex * 20;
    if (horizontalIndex == totalcount - 1) {
        rpm = waterPumpInfo.rpMatBHP;
    }
    
    float displacement = diameter * diameter * [waterPumpInfo.stroke floatValue] * rpm * pumpTypeInt / 8.579012f;
    
    self.lblDiameter.text = [NSString stringWithFormat:@"Diameter: %.3f", diameter];
    self.lblRPM.text = [NSString stringWithFormat:@"RPM: %d", rpm];
    self.lblDisplacement.text = [NSString stringWithFormat:@"Displacement: %.0f", displacement];
    
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    
}

@end
