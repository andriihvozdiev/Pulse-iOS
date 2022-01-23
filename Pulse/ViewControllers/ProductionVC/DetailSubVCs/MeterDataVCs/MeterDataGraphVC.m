//
//  MeterDataGraphVC.m
//  Pulse
//
//  Created by Luca on 9/17/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import "MeterDataGraphVC.h"

@interface MeterDataGraphVC ()
{
    float rateMin;
    float m_graphWidth;
}
@end

@implementation MeterDataGraphVC
@synthesize arrMeterData;
@synthesize arrMeterRates;
@synthesize meter;

@synthesize valueChartView;
@synthesize rateChartView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    valueChartView = [[JBLineChartView alloc] init];
    valueChartView.dataSource = self;
    valueChartView.delegate = self;
    [self.valueGraphView addSubview:valueChartView];
    
    rateChartView = [[JBLineChartView alloc] init];
    rateChartView.dataSource = self;
    rateChartView.delegate = self;
    [self.rateGraphView addSubview:rateChartView];
    
    rateMin = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *strMeterType = meter.meterType;
    
    if ([strMeterType isEqual:@"Gas"]) {
        [self.btnTotalValue setTitle:@"Cumulative Volume" forState:UIControlStateNormal];
        
    } else { //if ([strMeterType isEqual:@"Water"]) {
        [self.btnTotalValue setTitle:@"Total Value" forState:UIControlStateNormal];
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.landscapeUnderlineCenterConstraint.constant = -screenSize.width / 4.0f;
    [self.view layoutIfNeeded];
    
    [self.btnTotalValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnMeterRate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initValueGraph];
}


#pragma mark - button events
- (IBAction)onTotalValue:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = -screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderline shakeWithWidth:2.5f];
    }];
    [self.btnTotalValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnMeterRate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.lblSelectedValue.text = @"";
    self.lblSelectedDate.text = @"";
    [self.valueGraphView setHidden:NO];
    [self.rateGraphView setHidden:YES];
    
    [self initValueGraph];
}

- (IBAction)onMeterRate:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderline shakeWithWidth:2.5f];
    }];
    [self.btnTotalValue setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnMeterRate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.lblSelectedValue.text = @"";
    self.lblSelectedDate.text = @"";
    [self.valueGraphView setHidden:YES];
    [self.rateGraphView setHidden:NO];
    
    [self initMeterRateGraph];
}


-(void) initValueGraph
{
    self.graph_bg.image = nil;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSInteger totalcount = self.arrMeterData.count;
    if (totalcount == 0) {
        return;
    }
    
    
    if (totalcount > 30) {
        m_graphWidth = 50 + (screenSize.width - 50) * totalcount / 30.0f;
    } else {
        m_graphWidth = screenSize.width;
    }
    
    self.graphWidthConstraint.constant = m_graphWidth;
    [self.view layoutIfNeeded];
    
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    
    rect.origin.x = 50;
    if (totalcount == 0) {
        rect.size.width = 0;
    } else {
        rect.size.width = (rect.size.width-50) * (totalcount - 1) / (float)totalcount;
    }
    
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    [valueChartView setBackgroundColor:[UIColor clearColor]];
    valueChartView.frame = rect;
    
    float maxValue = [self getMaxVol];
    [valueChartView setMaximumValue:maxValue];
    [valueChartView setMinimumValue:0];
    
    [valueChartView reloadData];
    
    self.lblSelectedDate.text = @"";
    [self.valueGraphView setHidden:NO];
    [self.rateGraphView setHidden:YES];
    
    [self drawVolumeGraphBackground:totalcount maxValue: maxValue];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy hh:mm a"];
    
    if ([meter.meterType isEqual:@"Gas"] && self.arrMeterData.count > 0) {
        GasMeterData *gasMeterData = self.arrMeterData[0];
        
        float value = [self getFloatValue:gasMeterData.meterCumVol availableMin:NO];
        
        self.lblSelectedValue.text = [NSString stringWithFormat:@"Cumulative Volume: %.0f", value];
        
        NSString *strGasCheckTime = [df stringFromDate:gasMeterData.checkTime];
        self.lblSelectedDate.text = [NSString stringWithFormat:@"Date: %@", strGasCheckTime];
    }
    
    if ([meter.meterType isEqual:@"Water"] && self.arrMeterData.count > 0) {
        WaterMeterData *waterMeterData = self.arrMeterData[0];
        
        float value = [self getFloatValue:waterMeterData.totalVolume availableMin:NO];
        
        self.lblSelectedValue.text = [NSString stringWithFormat:@"Total Volume: %.0f", value];
        
        NSString *strWaterCheckTime = [df stringFromDate:waterMeterData.checkTime];
        self.lblSelectedDate.text = [NSString stringWithFormat:@"Date: %@", strWaterCheckTime];
    }
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(CGFloat)getMaxVol
{
    if (arrMeterData.count == 0) {
        return 0;
    }
    
    float total = 0;
    
    if ([meter.meterType isEqual:@"Gas"]) {
        for (GasMeterData *gasMeterData in arrMeterData) {
            float cumVolume = [self getFloatValue:gasMeterData.meterCumVol availableMin:NO];
            total += cumVolume;
        }
    } else if ([meter.meterType isEqual:@"Water"]) {
        for (WaterMeterData *waterMeterData in arrMeterData) {
            float cumVolume = [self getFloatValue:waterMeterData.totalVolume availableMin:NO];
            total += cumVolume;
        }
    }
    
    return (total * 2 / (float)arrMeterData.count);
}


-(void) initMeterRateGraph
{
    self.graph_bg.image = nil;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSInteger totalcount = self.arrMeterRates.count;
    if (totalcount == 0) {
        return;
    }
    
    if (totalcount > 30) {
        m_graphWidth = 50 + (screenSize.width - 50) * totalcount / 30.0f;
    } else {
        m_graphWidth = screenSize.width;
    }
    self.graphWidthConstraint.constant = m_graphWidth;
    [self.view layoutIfNeeded];
    
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    
    rect.origin.x = 50;
    if (totalcount == 0) {
        rect.size.width = 0;
    } else {
        rect.size.width = (rect.size.width-50) * (totalcount - 1) / (float)totalcount;
    }
    
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    [rateChartView setBackgroundColor:[UIColor clearColor]];
    rateChartView.frame = rect;
    
    [rateChartView setMaximumValue:[self getRateRange]];
    [rateChartView setMinimumValue:0];
    
    [rateChartView reloadData];
    
    [self.valueGraphView setHidden:YES];
    [self.rateGraphView setHidden:NO];
    
    [self drawRateGraphBackground:totalcount];
    
    if (self.arrMeterRates.count > 0) {
        NSDictionary *dicRate = self.arrMeterRates[0];
        self.lblSelectedValue.text = [NSString stringWithFormat:@"Rate: %@", [dicRate valueForKey:@"rate"]];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strDate = [df stringFromDate:[dicRate valueForKey:@"date"]];
        self.lblSelectedDate.text = [NSString stringWithFormat:@"Date: %@", strDate];
    }
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(CGFloat)getRateRange
{
    float min = 0;
    float max = 0;
    
    for (NSDictionary *dic in arrMeterRates) {
        float rate = [[dic valueForKey:@"rate"] floatValue];
        
        if (max < rate) max = rate;
        if (min > rate) min = rate;
        
    }
    
    if (min < 0) {
        rateMin = -min;
        return max - min;
    }
    rateMin = 0;
    
    if (max < 10) max = 10;
    return max;
}


-(void) drawVolumeGraphBackground:(NSInteger)totalcount maxValue:(float)maxValue
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height * 340 / 375.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    //draw the entire image in the specified rectangle frame
    [self.graph_bg.image drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.1f);
    CGContextSetRGBStrokeColor(context, 151/255.0f, 151/255.0f, 151/255.0f, 0.5f);
    CGContextBeginPath(context);
    
    float bottomY = rect.size.height - 50;
    float graphHeight = rect.size.height - 50;
    float axis_width = (m_graphWidth - 50) * (totalcount - 1) / (float)totalcount;
    CGContextMoveToPoint(context, 50, bottomY);
    CGContextAddLineToPoint(context, axis_width + 50, bottomY);
    
    int maxLog = (int)log10f(maxValue);
    int step = (int) pow(10, maxLog);
    float deltaHeight = graphHeight * step / maxValue;
    for (int i = 0; i < maxValue; i += step) {
        float y = bottomY - deltaHeight * i / step;
        CGContextMoveToPoint(context, 45, y);
        CGContextAddLineToPoint(context, axis_width + 50, y);
        CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1);
        CGContextStrokePath(context);
        [self addText:[NSString stringWithFormat:@"%d", i] withPoint:CGPointMake(40, y - 8) fontSize:10 align:@"right"];
        
        for (int j = 1; j < 10; j++) {
            y = bottomY - deltaHeight * i / step - deltaHeight * j / 10.0f;
            CGContextMoveToPoint(context, 50, y);
            CGContextAddLineToPoint(context, axis_width + 50, y);
            CGContextSetRGBStrokeColor(context, 151/255.0f, 151/255.0f, 151/255.0f, 0.5f);
            CGContextStrokePath(context);
        }
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSInteger maxIndex = self.arrMeterData.count - 1;
    
    int lastIndex = -5;
    
    float spacing = (m_graphWidth - 50) / (float)totalcount;
    
    for (int i = 0; i < totalcount; i++)
    {
        CGContextMoveToPoint(context, 50 + spacing * i, 5);
        CGContextAddLineToPoint(context, 50 + spacing * i, bottomY);
        
        if (lastIndex + 5 == i) {
            lastIndex = i;
            
            NSString *strDate = @"";
            
            if ([meter.meterType isEqual:@"Gas"]) {
                GasMeterData *gasMeterData = arrMeterData[maxIndex - i];
                strDate = [df stringFromDate:gasMeterData.checkTime];
            } else {
                WaterMeterData *waterMeterData = arrMeterData[maxIndex - i];
                strDate = [df stringFromDate:waterMeterData.checkTime];
            }
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
        
        if (totalcount < 5 && i == totalcount-1)
        {
            lastIndex = i;
            
            NSString *strDate = @"";
            
            if ([meter.meterType isEqual:@"Gas"]) {
                GasMeterData *gasMeterData = arrMeterData[maxIndex - i];
                strDate = [df stringFromDate:gasMeterData.checkTime];
            } else {
                WaterMeterData *waterMeterData = arrMeterData[maxIndex - i];
                strDate = [df stringFromDate:waterMeterData.checkTime];
            }
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
    }
    
    if (totalcount > 0 && lastIndex < totalcount - 3) {
        lastIndex = (int)totalcount - 1;
        
        NSString *strDate = @"";
        
        if ([meter.meterType isEqual:@"Gas"]) {
            GasMeterData *gasMeterData = arrMeterData[maxIndex - lastIndex];
            strDate = [df stringFromDate:gasMeterData.checkTime];
        } else {
            WaterMeterData *waterMeterData = arrMeterData[maxIndex - lastIndex];
            strDate = [df stringFromDate:waterMeterData.checkTime];
        }
        
        [self addText:strDate withPoint:CGPointMake(50 + spacing * lastIndex, bottomY + 8) fontSize:11 align:@"center"];
    }
    
    
    //paint a line along the current path
    CGContextStrokePath(context);
    CGContextFlush(context);
    
    //set the image based on the contents of the current bitmap-based graphics context
    self.graph_bg.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
}

-(void)drawRateGraphBackground:(NSInteger)totalcount
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height * 340 / 375.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    //draw the entire image in the specified rectangle frame
    [self.graph_bg.image drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.1f);
    CGContextSetRGBStrokeColor(context, 151/255.0f, 151/255.0f, 151/255.0f, 0.5f);
    CGContextBeginPath(context);
    
    float bottomY = rect.size.height - 50;
    float graphHeight = rect.size.height - 50;
    float axis_width = (m_graphWidth - 50) * (totalcount - 1) / (float)totalcount;
    //begin a new new subpath at this point
    CGContextMoveToPoint(context, 50, bottomY);
    CGContextAddLineToPoint(context, axis_width + 50, bottomY);
    
    float totalValue = [self getRateRange];
    float rateMax = (totalValue - rateMin) > rateMin ? (totalValue - rateMin) : rateMin;
    int maxLog = (int)log10f(rateMax);
    int step = (int) pow(10, maxLog);
    float deltaHeight = graphHeight * step / totalValue;
    for (int i = 0; i < rateMax; i += step) {
        
        if (i < (totalValue - rateMin)) {
            float y = bottomY - graphHeight * rateMin / totalValue - deltaHeight * i / step;
            CGContextMoveToPoint(context, 45, y);
            CGContextAddLineToPoint(context, axis_width + 50, y);
            [self addText:[NSString stringWithFormat:@"%d", i] withPoint:CGPointMake(40, y - 8) fontSize:10 align:@"right"];
        }
        
        if (i > 0 && i < rateMin) {
            float y = bottomY - graphHeight * rateMin / totalValue + deltaHeight * i / step;
            CGContextMoveToPoint(context, 45, y);
            CGContextAddLineToPoint(context, axis_width + 50, y);
            [self addText:[NSString stringWithFormat:@"-%d", i] withPoint:CGPointMake(40, y - 8) fontSize:10 align:@"right"];
        }
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSInteger maxIndex = self.arrMeterRates.count - 1;
    
    int lastIndex = -5;
    
    float spacing = (m_graphWidth - 50) / (float)totalcount;
    for (int i = 0; i < totalcount; i++) {
        CGContextMoveToPoint(context, 50 + spacing * i, 5);
        CGContextAddLineToPoint(context, 50 + spacing * i, bottomY);
        
        if (lastIndex + 5 == i) {
            lastIndex = i;
            
            NSDictionary *dicRate = arrMeterRates[maxIndex - i];
            NSString *strDate = [df stringFromDate:[dicRate valueForKey:@"date"]];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
        
        if (totalcount < 5 && i == totalcount-1)
        {
            lastIndex = i;
            
            NSDictionary *dicRate = arrMeterRates[maxIndex - i];
            NSString *strDate = [df stringFromDate:[dicRate valueForKey:@"date"]];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
    }
    
    if (totalcount > 0 && lastIndex < totalcount - 3) {
        lastIndex = (int)totalcount - 1;
        NSDictionary *dicRate = arrMeterRates[maxIndex - lastIndex];
        NSString *strDate = [df stringFromDate:[dicRate valueForKey:@"date"]];
        
        [self addText:strDate withPoint:CGPointMake(50 + spacing * lastIndex, bottomY + 8) fontSize:11 align:@"center"];
    }
    
    //paint a line along the current path
    CGContextStrokePath(context);
    CGContextFlush(context);
    
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


#pragma mark - JBLineChartView datasource
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    NSInteger numberOfVertical = 0;
    if (lineChartView == valueChartView) {
        numberOfVertical = arrMeterData.count;
    } else if (lineChartView == rateChartView) {
        numberOfVertical = arrMeterRates.count;
    }
    
    return numberOfVertical;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    float yValue = 0;
    
    NSInteger maxIndex = 0;
    
    if ([meter.meterType isEqual:@"Gas"]) {
        
        if (lineChartView == valueChartView) {
            
            maxIndex = self.arrMeterData.count - 1;
            
            GasMeterData *gasMeterData = self.arrMeterData[maxIndex - horizontalIndex];
            yValue = [self getFloatValue:gasMeterData.meterCumVol availableMin:NO];
            
        } else if (lineChartView == rateChartView) {
            
            maxIndex = self.arrMeterRates.count - 1;
            
            NSDictionary *dic = arrMeterRates[maxIndex - horizontalIndex];
            yValue = [self getFloatValue:[dic valueForKey:@"rate"] availableMin:YES] + rateMin;
            
        }
        
    } else if ([meter.meterType isEqual:@"Water"]) {
        
        if (lineChartView == valueChartView) {
            
            maxIndex = self.arrMeterData.count - 1;
            
            WaterMeterData *waterMeterData = self.arrMeterData[maxIndex - horizontalIndex];
            yValue = [self getFloatValue:waterMeterData.totalVolume availableMin:NO];
        } else if (lineChartView == rateChartView) {
            
            maxIndex = self.arrMeterRates.count - 1;
            
            NSDictionary *dic = arrMeterRates[maxIndex - horizontalIndex];
            yValue = [self getFloatValue:[dic valueForKey:@"rate"] availableMin:YES] + rateMin;
            
        }
        
    }
    
    return yValue;
}

-(CGFloat)getFloatValue:(NSString*)value availableMin:(BOOL)availableMin
{
    float result = 0;
    if (value) {
        result = [value floatValue];
        if (!availableMin) {
            result = result < 0 ? 0 : result;
        }
    }
    
    if (result > 100) result = result * 100 / 100;
    else if (result > 10) result = result * 10 / 10.0f;
    else result = result / 1.00f;
    
    return result;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    UIColor *lineColor = [UIColor colorWithRed:122/255.0f green:218/255.0f blue:1 alpha:1];
    
    return lineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor clearColor]; // color of area under line in chart
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 2; // width of line in chart
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
    return 3;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    [self.scrollView setScrollEnabled:NO];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy hh:mm a"];
    
    if (lineChartView == valueChartView) {
        NSInteger maxIndex = self.arrMeterData.count-1;
        
        if ([meter.meterType isEqual:@"Gas"]) {
            GasMeterData *gasMeterData = self.arrMeterData[maxIndex - horizontalIndex];
            
            float value = [self getFloatValue:gasMeterData.meterCumVol availableMin:NO];
            
            self.lblSelectedValue.text = [NSString stringWithFormat:@"Cumulative Volume: %.0f", value];
            
            NSString *strGasCheckTime = [df stringFromDate:gasMeterData.checkTime];
            self.lblSelectedDate.text = [NSString stringWithFormat:@"Date: %@", strGasCheckTime];
        }
        
        if ([meter.meterType isEqual:@"Water"]) {
            WaterMeterData *waterMeterData = self.arrMeterData[maxIndex - horizontalIndex];
            
            float value = [self getFloatValue:waterMeterData.totalVolume availableMin:NO];
            
            self.lblSelectedValue.text = [NSString stringWithFormat:@"Total Volume: %.0f", value];
            
            NSString *strWaterCheckTime = [df stringFromDate:waterMeterData.checkTime];
            self.lblSelectedDate.text = [NSString stringWithFormat:@"Date: %@", strWaterCheckTime];
        }
    } else if (lineChartView == rateChartView) {
        NSInteger maxIndex = self.arrMeterRates.count-1;
        
        NSDictionary *dicRate = self.arrMeterRates[maxIndex - horizontalIndex];
        
        self.lblSelectedValue.text = [NSString stringWithFormat:@"Rate: %@", [dicRate valueForKey:@"rate"]];
        
        NSString *strDate = [df stringFromDate:[dicRate valueForKey:@"date"]];
        self.lblSelectedDate.text = [NSString stringWithFormat:@"Date: %@", strDate];
        
    }
}

-(void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.scrollView setScrollEnabled:YES];
}


@end
