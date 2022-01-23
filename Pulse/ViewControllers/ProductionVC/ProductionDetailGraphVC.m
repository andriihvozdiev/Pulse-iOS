//
//  ProductionDetailGraphVC.m
//  Pulse
//
//  Created by Luca on 9/9/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import "ProductionDetailGraphVC.h"

@interface ProductionDetailGraphVC ()
{
    float max_Y;
    NSInteger m_totalCount;
    float m_graphWidth;
}
@end

@implementation ProductionDetailGraphVC
@synthesize linearChartView;
@synthesize semiLogChartView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    max_Y = 0;
    
    linearChartView = [[JBLineChartView alloc] init];
    linearChartView.dataSource = self;
    linearChartView.delegate = self;
    [self.linearGraphView addSubview:linearChartView];
    
    semiLogChartView = [[JBLineChartView alloc] init];
    semiLogChartView.dataSource = self;
    semiLogChartView.delegate = self;
    [self.semiLogGraphView addSubview:semiLogChartView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    m_totalCount = self.arrDetailData.count;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.menuUnderlineCenterConstraint.constant = -screenSize.width / 4.0f;
    if (m_totalCount > 30) {
        m_graphWidth = 50 + (screenSize.width - 50) * m_totalCount / 30.0f;
    } else {
        m_graphWidth = screenSize.width;
    }
    
    self.graphWidthConstraint.constant = m_graphWidth;
    [self.view layoutIfNeeded];
    
    [self.btnLinear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSemiLog setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initLinearGraph];
}

- (IBAction)onLinear:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.menuUnderlineCenterConstraint.constant = -screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.menuUnderline shakeWithWidth:2.5f];
    }];
    [self.btnLinear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSemiLog setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initLinearGraph];
}

- (IBAction)onSemiLog:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.menuUnderlineCenterConstraint.constant = screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.menuUnderline shakeWithWidth:2.5f];
    }];
    [self.btnLinear setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnSemiLog setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self initSemiLogGraph];
}

-(void) initLinearGraph
{
    if (m_totalCount == 0)
        return;
    
    self.graph_bg.image = nil;
    
    [self.linearGraphView setHidden:NO];
    [self.semiLogGraphView setHidden:YES];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    rect.origin.x = 50;
    rect.size.width = (m_graphWidth - 50) * (m_totalCount - 1) / (float)m_totalCount;
    rect.size.height = screenSize.height * 340 / 375.0f - 50;
    [linearChartView setBackgroundColor:[UIColor clearColor]];
    linearChartView.frame = rect;
    
    [self setMaxValues:NO];
    
    [linearChartView setMaximumValue:max_Y + 5];
    [linearChartView setMinimumValue:0];
    
    [linearChartView reloadData];
    
    self.lblDate.text = @"";
    [self drawGraphBackground:NO];
    [self showLastData];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void) initSemiLogGraph
{
    if (m_totalCount == 0)
        return;
    
    self.graph_bg.image = nil;
    
    [self.linearGraphView setHidden:YES];
    [self.semiLogGraphView setHidden:NO];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    rect.origin.x = 50;
    rect.size.width = (m_graphWidth - 50) * (m_totalCount - 1) / (float)m_totalCount;
    rect.size.height = screenSize.height * 340 / 375.0f - 50;
    [semiLogChartView setBackgroundColor:[UIColor clearColor]];
    semiLogChartView.frame = rect;
    
    [self setMaxValues:YES];
    
    [semiLogChartView setMaximumValue:max_Y];
    [semiLogChartView setMinimumValue:0];
    
    [semiLogChartView reloadData];
    
    self.lblDate.text = @"";
    [self drawGraphBackground:YES];
    [self showLastData];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void) setMaxValues:(BOOL)semiLog
{
    for (int i = 0; i < m_totalCount; i++) {
        
        Production *production = self.arrDetailData[i];
        
        float oilVol = [self getFloatValue:production.oilVol];
        float gasVol = [self getFloatValue:production.gasVol];
        float waterVol = [self getFloatValue:production.waterVol];
        
        if (oilVol > max_Y) {
            max_Y = oilVol;
        }
        
        if (gasVol > max_Y) {
            max_Y = gasVol;
        }
        
        if (waterVol > max_Y) {
            max_Y = waterVol;
        }
    }
    
    if (!semiLog) {
        max_Y += 100;
    } else if (semiLog && max_Y > 0) {
        max_Y = log10f(max_Y) + 1;
    }
}

-(void) showLastData
{
    if (self.arrDetailData.count > 0) {
        Production *production = self.arrDetailData[0];
        
        float gasValue = [self getFloatValue:production.gasVol];
        float oilValue = [self getFloatValue:production.oilVol];
        float waterValue = [self getFloatValue:production.waterVol];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM/dd/yyyy";
        
        self.lblGas.text = [NSString stringWithFormat:@"Gas: %.2f", gasValue];
        self.lblOil.text = [NSString stringWithFormat:@"Oil: %.2f", oilValue];
        self.lblWater.text = [NSString stringWithFormat:@"Water: %.2f", waterValue];
        self.lblDate.text = [NSString stringWithFormat:@"Date: %@", [df stringFromDate:production.productionDate]];
    }
}

-(void) drawGraphBackground:(BOOL)semiLog
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height * 340 / 375.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    //draw the entire image in the specified rectangle frame
    [self.graph_bg.image drawInRect:rect];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    //set line cap, width, stroke color and begin path
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.1f);
    CGContextSetRGBStrokeColor(context, 151/255.0f, 151/255.0f, 151/255.0f, 0.5f);
    CGContextBeginPath(context);
    
    //begin a new new subpath at this point
    float bottomY = rect.size.height - 50;
    float axis_width = (m_graphWidth - 50) * (m_totalCount - 1) / (float)m_totalCount;
    
    float graphHeight = rect.size.height - 50;
    if (semiLog) {
        float deltaHeight = graphHeight / max_Y;
        for (int i = 0; i < max_Y; i++) {
            float y = bottomY - deltaHeight * i;
            CGContextMoveToPoint(context, 45, y);
            CGContextAddLineToPoint(context, axis_width + 50, y);
            CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1);
            CGContextStrokePath(context);
            [self addText:[NSString stringWithFormat:@"%d", (int)pow(10, i)] withPoint:CGPointMake(30, y - 8) fontSize:10 align:@"right"];
            
            for (int j = 2; j < 10; j++) {
                y = bottomY - deltaHeight * i - deltaHeight * log10f(j);
                CGContextMoveToPoint(context, 50, y);
                CGContextAddLineToPoint(context, axis_width + 50, y);
                CGContextSetRGBStrokeColor(context, 151/255.0f, 151/255.0f, 151/255.0f, 0.5f);
                CGContextStrokePath(context);
            }
            
        }
    } else {
        int step = 100;
        if (max_Y < step) step = 10;
        float deltaHeight = graphHeight * step / max_Y;
        for (int i = 0; i < max_Y; i += step) {
            float y = bottomY - deltaHeight * i / step;
            CGContextMoveToPoint(context, 45, y);
            CGContextAddLineToPoint(context, axis_width + 50, y);
            CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1);
            CGContextStrokePath(context);
            [self addText:[NSString stringWithFormat:@"%d", i] withPoint:CGPointMake(30, y - 8) fontSize:10 align:@"right"];
            
            for (int j = 1; j < 10; j++) {
                y = bottomY - deltaHeight * i / step - deltaHeight * j / 10.0f;
                CGContextMoveToPoint(context, 50, y);
                CGContextAddLineToPoint(context, axis_width + 50, y);
                CGContextSetRGBStrokeColor(context, 151/255.0f, 151/255.0f, 151/255.0f, 0.5f);
                CGContextStrokePath(context);
            }
        }
    }
    
    NSInteger maxIndex = self.arrDetailData.count - 1;
    
    int lastIndex = -5;
    float spacing = (m_graphWidth - 50) / (float)m_totalCount;
    for (int i = 0; i < m_totalCount; i++) {
        
        CGContextMoveToPoint(context, 50 + spacing * i, 5);
        CGContextAddLineToPoint(context, 50 + spacing * i, bottomY);
        
        NSString *strDay = [NSString stringWithFormat:@"%d", i+1];
        
        if (lastIndex + 5 == i) {
            lastIndex = i;
            
            Production *production = self.arrDetailData[maxIndex - i];
            strDay = [df stringFromDate:production.productionDate];
            
            [self addText:strDay withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
        
        if (m_totalCount < 5 && i == m_totalCount - 1)
        {
            lastIndex = i;
            Production *production = self.arrDetailData[maxIndex - i];
            strDay = [df stringFromDate:production.productionDate];
            
            [self addText:strDay withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
        
    }
    
    if (m_totalCount > 0 && lastIndex < m_totalCount - 3) {
        lastIndex = (int)m_totalCount - 1;
        Production *production = self.arrDetailData[maxIndex - lastIndex];
        NSString *strDate = [df stringFromDate:production.productionDate];
        
        [self addText:strDate withPoint:CGPointMake(40 + spacing * lastIndex, bottomY + 8) fontSize:10 align:@"center"];
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
    return 3;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return self.arrDetailData.count;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    NSInteger maxIndex = self.arrDetailData.count - 1;
    
    Production *production = self.arrDetailData[maxIndex - horizontalIndex];
    
    float yValue = 0;
    
    switch (lineIndex) {
        case 0:
            yValue = [self getFloatValue:production.gasVol];
            break;
        case 1:
            yValue = [self getFloatValue:production.oilVol];
            break;
        case 2:
            yValue = [self getFloatValue:production.waterVol];
            break;
        default:
            break;
    }
    
    if (lineChartView == linearChartView) {
        
    } else if (lineChartView == semiLogChartView) {
        
        if (yValue != 0.0f) {
            yValue = log10f(yValue);
        }
        
        if (yValue < 0) yValue = 0;
    }
    
    return yValue;
}

-(CGFloat)getFloatValue:(NSString*)value
{
    float result = 0;
    if (value != nil) {
        result = [value floatValue] < 0 ? 0 : [value floatValue];
    }
    
    return result;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    UIColor *gasLineColor = [UIColor colorWithRed:1 green:141/255.0f blue:138/255.0f alpha:1];
    UIColor *oilLineColor = [UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1];
    UIColor *waterLineColor = [UIColor colorWithRed:122/255.0f green:218/255.0f blue:1 alpha:1];
    UIColor *resultColor = [[UIColor alloc] init];
    switch (lineIndex) {
        case 0:
            resultColor = gasLineColor;
            break;
        case 1:
            resultColor = oilLineColor;
            break;
        case 2:
            resultColor = waterLineColor;
            break;
        default:
            break;
    }
    
    return resultColor;
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
    
    NSInteger maxIndex = self.arrDetailData.count-1;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    Production *production = self.arrDetailData[maxIndex - horizontalIndex];
    
    float gasValue = [self getFloatValue:production.gasVol];
    float oilValue = [self getFloatValue:production.oilVol];
    float waterValue = [self getFloatValue:production.waterVol];
    
    self.lblGas.text = [NSString stringWithFormat:@"Gas: %.2f", gasValue];
    self.lblOil.text = [NSString stringWithFormat:@"Oil: %.2f", oilValue];
    self.lblWater.text = [NSString stringWithFormat:@"Water: %.2f", waterValue];
    self.lblDate.text = [NSString stringWithFormat:@"Date: %@", [df stringFromDate:production.productionDate]];
    
    switch (lineIndex) {
        case 0:
            self.lblGas.font = [UIFont fontWithName:self.lblGas.font.fontName size:15];
            self.lblOil.font = [UIFont fontWithName:self.lblOil.font.fontName size:12];
            self.lblWater.font = [UIFont fontWithName:self.lblWater.font.fontName size:12];
            break;
        case 1:
            self.lblGas.font = [UIFont fontWithName:self.lblGas.font.fontName size:12];
            self.lblOil.font = [UIFont fontWithName:self.lblOil.font.fontName size:15];
            self.lblWater.font = [UIFont fontWithName:self.lblWater.font.fontName size:12];
            break;
        case 2:
            self.lblGas.font = [UIFont fontWithName:self.lblGas.font.fontName size:12];
            self.lblOil.font = [UIFont fontWithName:self.lblOil.font.fontName size:12];
            self.lblWater.font = [UIFont fontWithName:self.lblWater.font.fontName size:15];
            break;
        default:
            break;
    }
    
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    self.lblGas.font = [UIFont fontWithName:self.lblGas.font.fontName size:12];
    self.lblOil.font = [UIFont fontWithName:self.lblOil.font.fontName size:12];
    self.lblWater.font = [UIFont fontWithName:self.lblWater.font.fontName size:12];
    [self.scrollView setScrollEnabled:YES];
}
@end
