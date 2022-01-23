//
//  TankGraphVC.m
//  Pulse
//
//  Created by Luca on 9/15/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import "TankGraphVC.h"

@interface TankGraphVC ()
{
    float m_graphWidth;
}
@end

@implementation TankGraphVC
@synthesize tank;
@synthesize arrTankGaugeEntry;
@synthesize arrRunTickets;

@synthesize tankHeightChartView;
@synthesize runTicketsChartView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tankHeightChartView = [[JBLineChartView alloc] init];
    tankHeightChartView.dataSource = self;
    tankHeightChartView.delegate = self;
    [self.viewTankHeight addSubview:tankHeightChartView];
    
    runTicketsChartView = [[JBBarChartView alloc] init];
    runTicketsChartView.dataSource = self;
    runTicketsChartView.delegate = self;
    [self.viewRunTickets addSubview:runTicketsChartView];
    
    [self.lblTankHeight setHidden:YES];
    [self.lblTankHeightDate setHidden:YES];
    [self.lblRunTicketGrossVol setHidden:YES];
    [self.lblRunTicketNetVol setHidden:YES];
    [self.lblRunTicketDate setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.landscapeUnderlineCenterConstraint.constant = -screenSize.width / 4.0f;
    [self.view layoutIfNeeded];
    [self.btnTankHeight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRunTickets setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initTankHeightGraph];
}


-(void) initTankHeightGraph
{
    self.graph_bg.image = nil;
    [self.viewTankHeight setHidden:NO];
    [self.lblTankHeight setHidden:NO];
    [self.lblTankHeightDate setHidden:NO];
    [self.viewRunTickets setHidden:YES];
    [self.lblRunTicketGrossVol setHidden:YES];
    [self.lblRunTicketNetVol setHidden:YES];
    [self.lblRunTicketDate setHidden:YES];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSInteger totalcount = self.arrTankGaugeEntry.count;
    if (totalcount > 30) {
        m_graphWidth = 50 + (screenSize.width - 50) * totalcount / 30.0f;
    } else {
        m_graphWidth = screenSize.width;
    }
    
    self.graphWidthConstraint.constant = m_graphWidth;
    [self.view layoutIfNeeded];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    
    rect.origin.x = 50;
    if (totalcount == 0) {
        rect.size.width = 0;
    } else {
        rect.size.width = (rect.size.width-50) * (totalcount - 1) / (float)totalcount;
    }
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    
    tankHeightChartView.frame = rect;
    
    [tankHeightChartView setMaximumValue:200];
    [tankHeightChartView setMinimumValue:0];
    
    [tankHeightChartView reloadData];
    
    self.lblTankHeightDate.text = @"";
    
    [self drawGraphBackground:totalcount];
    
    if (self.arrTankGaugeEntry.count > 0) {
        TankGaugeEntry *tankGaugeEntry = self.arrTankGaugeEntry[0];
        
        int gauge = [self getGauge:tankGaugeEntry withTankID:self.tank.tankID];
        
        int feet = gauge / 4 / 12;
        float inches = gauge / 4.0f - feet * 12;
        NSString *strTankHeight = [NSString stringWithFormat:@"Tank Height: %d' %.2f\"", feet, inches];
        self.lblTankHeight.text = strTankHeight;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strGaugeTime = [df stringFromDate:tankGaugeEntry.gaugeTime];
        self.lblTankHeightDate.text = [NSString stringWithFormat:@"Date: %@", strGaugeTime];
    }
    
}

-(void) initRunTicketsGraph
{
    self.graph_bg.image = nil;
    [self.viewTankHeight setHidden:YES];
    [self.lblTankHeight setHidden:YES];
    [self.lblTankHeightDate setHidden:YES];
    [self.viewRunTickets setHidden:NO];
    [self.lblRunTicketGrossVol setHidden:NO];
    [self.lblRunTicketNetVol setHidden:NO];
    [self.lblRunTicketDate setHidden:NO];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSInteger totalcount = self.arrRunTickets.count;
    if (totalcount > 20) {
        m_graphWidth = 50 + (screenSize.width - 100) * totalcount / 20.0f;
    } else {
        m_graphWidth = screenSize.width - 50;
    }
    self.graphWidthConstraint.constant = m_graphWidth;
    [self.view layoutIfNeeded];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    
    rect.origin.x = 50;
    rect.size.width = (rect.size.width - 50);
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    
    runTicketsChartView.frame = rect;
    
    [runTicketsChartView setMaximumValue:300];
    [runTicketsChartView setMinimumValue:0];
    
    [runTicketsChartView reloadData];
    [runTicketsChartView setState:JBChartViewStateExpanded animated:YES];
    
    [self drawBarGraphBackground:totalcount];
    
    if (arrRunTickets.count > 0) {
        RunTickets *runTicket = arrRunTickets[0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strTicketTime = [df stringFromDate:runTicket.ticketTime];
        
        self.lblRunTicketGrossVol.text = [NSString stringWithFormat:@"Gross Vol: %@", [self getFloatString:runTicket.grossVol]];
        self.lblRunTicketNetVol.text = [NSString stringWithFormat:@"Net Vol: %@", [self getFloatString:runTicket.netVol]];
        self.lblRunTicketDate.text = [NSString stringWithFormat:@"Date: %@", strTicketTime];
    }
}

-(void) drawBarGraphBackground:(NSInteger)totalcount
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
    
    //begin a new new subpath at this point
    float bottomY = rect.size.height - 50;
    CGContextMoveToPoint(context, 50, bottomY);
    CGContextAddLineToPoint(context, screenSize.width, bottomY);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSInteger maxIndex = self.arrRunTickets.count - 1;
    
    int lastIndex = -5;
    
    float spacing = (m_graphWidth - 50) / (float)totalcount;
    
    CGContextMoveToPoint(context, 50, 5);
    CGContextAddLineToPoint(context, 50, bottomY);
    
    for (int i = 0; i < totalcount; i++) {
        CGContextMoveToPoint(context, 50 + spacing * (i+1), 5);
        CGContextAddLineToPoint(context, 50 + spacing * (i+1), bottomY);
        
        if (lastIndex + 5 == i) {
            lastIndex = i;
            
            RunTickets *runTicket = arrRunTickets[maxIndex - i];
            NSString *strDate = [df stringFromDate:runTicket.ticketTime];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * (i+0.5f), bottomY + 8) fontSize:11];
        }
        
        if (totalcount < 5 && i == totalcount-1)
        {
            lastIndex = i;
            
            RunTickets *runTicket = arrRunTickets[maxIndex - i];
            
            NSString *strDate = [df stringFromDate:runTicket.ticketTime];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * (i+0.5f), bottomY + 8) fontSize:11];
        }
    }
    
    if (totalcount > 0 && lastIndex < totalcount - 3) {
        lastIndex = (int)totalcount - 1;
        RunTickets *runTicket = self.arrRunTickets[maxIndex - lastIndex];
        NSString *strDate = [df stringFromDate:runTicket.ticketTime];
        
        [self addText:strDate withPoint:CGPointMake(50 + spacing * (lastIndex+0.5f), bottomY + 8) fontSize:11];
    }
    
    //paint a line along the current path
    CGContextStrokePath(context);
    CGContextFlush(context);
    
    //set the image based on the contents of the current bitmap-based graphics context
    self.graph_bg.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
}

-(void) drawGraphBackground:(NSInteger)totalcount
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
    
    //begin a new new subpath at this point
    float bottomY = rect.size.height - 50;
    float axis_width = (m_graphWidth - 50) * (totalcount - 1) / (float)totalcount;
    
    CGContextMoveToPoint(context, 50, bottomY);
    CGContextAddLineToPoint(context, axis_width + 50, bottomY);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSInteger maxIndex = self.arrTankGaugeEntry.count - 1;
    
    int lastIndex = -5;
    float spacing = (m_graphWidth - 50) / (float)totalcount;
    for (int i = 0; i < totalcount; i++) {
        CGContextMoveToPoint(context, 50 + spacing * i, 5);
        CGContextAddLineToPoint(context, 50 + spacing * i, bottomY);
        
        if (lastIndex + 5 == i) {
            lastIndex = i;
            
            TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[maxIndex - i];
            NSString *strDate = [df stringFromDate:tankGaugeEntry.gaugeTime];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11];
        }
        
        if (totalcount < 5 && i == totalcount-1)
        {
            lastIndex = i;
            
            TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[maxIndex - i];
            
            NSString *strDate = [df stringFromDate:tankGaugeEntry.gaugeTime];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11];
        }
        
    }
    
    if (totalcount > 0 && lastIndex < totalcount - 3) {
        lastIndex = (int)totalcount - 1;
        TankGaugeEntry *tankGaugeEntry = arrTankGaugeEntry[maxIndex - lastIndex];
        
        NSString *strDate = [df stringFromDate:tankGaugeEntry.gaugeTime];
        
        [self addText:strDate withPoint:CGPointMake(40 + spacing * lastIndex, bottomY + 8) fontSize:11];
    }
    
    //paint a line along the current path
    CGContextStrokePath(context);
    CGContextFlush(context);
    
    //set the image based on the contents of the current bitmap-based graphics context
    self.graph_bg.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
}

- (void)addText:(NSString*)text withPoint:(CGPoint)point fontSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
    
    CGRect renderingRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
    
    renderingRect = CGRectMake(point.x - renderingRect.size.width / 2.0f, point.y, renderingRect.size.width, renderingRect.size.height);
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *textAttributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [text drawInRect:renderingRect withAttributes:textAttributes];
    
}


#pragma mark - button events
- (IBAction)onTankHeight:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = -screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderlineView shakeWithWidth:2.5f];
    }];
    [self.btnTankHeight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRunTickets setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initTankHeightGraph];
}

- (IBAction)onRunTickets:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = screenSize.width / 4.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderlineView shakeWithWidth:2.5f];
    }];
    
    [self.btnTankHeight setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnRunTickets setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self initRunTicketsGraph];
    
}


#pragma mark - JBBarChartView datasource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    NSInteger numberOfVertical = arrRunTickets.count;
    return numberOfVertical * 2;
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    UIColor *color = [UIColor whiteColor];
    
    int lineIndex = index % 2;
    
    switch (lineIndex) {
        case 0:
            color = [UIColor colorWithRed:255/255.0f green:141/255.0f blue:138/255.0f alpha:1];
            break;
        case 1:
            color = [UIColor colorWithRed:122/255.0f green:218/255.0f blue:1 alpha:1];
            break;
        default:
            break;
    }
    
    return color;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    float height = 0.0f;
    
    NSInteger maxIndex = self.arrRunTickets.count - 1;
    
    RunTickets *runTicket = arrRunTickets[maxIndex - index/2];
    
    int lineIndex = index % 2;
    
    switch (lineIndex) {
        case 0:
            height = runTicket.grossVol == nil ? 0 : [runTicket.grossVol floatValue];
            break;
        case 1:
            height = runTicket.netVol == nil ? 0 : [runTicket.netVol floatValue];
            break;
        default:
            break;
    }
    
    return height;
}

#pragma mark -
- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    NSInteger maxIndex = self.arrRunTickets.count-1;
    
    RunTickets *runTicket = arrRunTickets[maxIndex - index/2];
    self.lblRunTicketGrossVol.text = [NSString stringWithFormat:@"Gross Vol: %@", [self getFloatString:runTicket.grossVol]];
    self.lblRunTicketNetVol.text = [NSString stringWithFormat:@"Net Vol: %@", [self getFloatString:runTicket.netVol]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy hh:mm a"];
    NSString *strTicketTime = [df stringFromDate:runTicket.ticketTime];
    self.lblRunTicketDate.text = [NSString stringWithFormat:@"Date: %@", strTicketTime];
    
    int lineIndex = index % 2;
    switch (lineIndex) {
        case 0:
            [self.lblRunTicketGrossVol setFont:[UIFont fontWithName:self.lblRunTicketGrossVol.font.fontName size:14]];
            [self.lblRunTicketNetVol setFont:[UIFont fontWithName:self.lblRunTicketNetVol.font.fontName size:12]];
            break;
        case 1:
            [self.lblRunTicketGrossVol setFont:[UIFont fontWithName:self.lblRunTicketGrossVol.font.fontName size:12]];
            [self.lblRunTicketNetVol setFont:[UIFont fontWithName:self.lblRunTicketNetVol.font.fontName size:14]];
            break;
        default:
            break;
    }
    
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
    [self.lblRunTicketGrossVol setFont:[UIFont fontWithName:self.lblRunTicketGrossVol.font.fontName size:12]];
    [self.lblRunTicketNetVol setFont:[UIFont fontWithName:self.lblRunTicketNetVol.font.fontName size:12]];
    
}

#pragma mark - JBLineChartView datasource
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    NSInteger numberOfLines = 1;
    
    return numberOfLines;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return arrTankGaugeEntry.count;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    float yValue = 0;
    NSInteger maxIndex = self.arrTankGaugeEntry.count - 1;
    
    TankGaugeEntry *tankGaugeEntry = self.arrTankGaugeEntry[maxIndex - horizontalIndex];
    int gauge = [self getGauge:tankGaugeEntry withTankID:self.tank.tankID];
    yValue = gauge;
    
    return yValue;
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
    
    if (lineChartView == tankHeightChartView) {
        NSInteger maxIndex = self.arrTankGaugeEntry.count-1;
        
        TankGaugeEntry *tankGaugeEntry = self.arrTankGaugeEntry[maxIndex - horizontalIndex];
        
        int gauge = [self getGauge:tankGaugeEntry withTankID:self.tank.tankID];
        
        int feet = gauge / 4 / 12;
        float inches = gauge / 4.0f - feet * 12;
        NSString *strTankHeight = [NSString stringWithFormat:@"Tank Height: %d' %.2f\"", feet, inches];
        self.lblTankHeight.text = strTankHeight;
        
        NSString *strGaugeTime = [df stringFromDate:tankGaugeEntry.gaugeTime];
        self.lblTankHeightDate.text = [NSString stringWithFormat:@"Date: %@", strGaugeTime];
        
    }
}

-(void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.scrollView setScrollEnabled:YES];
}

#pragma mark -
-(int) getGauge:(TankGaugeEntry*)tankGaugeEntry withTankID:(int)tankID
{
    int result = 0;
    
    if (tankGaugeEntry.tankID1 == tankID)
        result = tankGaugeEntry.oilFeet1;
    if (tankGaugeEntry.tankID2 == tankID)
        result = tankGaugeEntry.oilFeet2;
    if (tankGaugeEntry.tankID3 == tankID)
        result = tankGaugeEntry.oilFeet3;
    if (tankGaugeEntry.tankID4 == tankID)
        result = tankGaugeEntry.oilFeet4;
    if (tankGaugeEntry.tankID5 == tankID)
        result = tankGaugeEntry.oilFeet5;
    if (tankGaugeEntry.tankID6 == tankID)
        result = tankGaugeEntry.oilFeet6;
    if (tankGaugeEntry.tankID7 == tankID)
        result = tankGaugeEntry.oilFeet7;
    if (tankGaugeEntry.tankID8 == tankID)
        result = tankGaugeEntry.oilFeet8;
    if (tankGaugeEntry.tankID9 == tankID)
        result = tankGaugeEntry.oilFeet9;
    if (tankGaugeEntry.tankID10 == tankID)
        result = tankGaugeEntry.oilFeet10;
    
    return result;
}

-(NSString*) getFloatString:(NSString*)value
{
    NSString *result = @"";
    
    if (value) {
        float fValue = [value floatValue];
        if (fValue > 100)
            result = [NSString stringWithFormat:@"%.1f", fValue];
        else if (fValue > 10)
            result = [NSString stringWithFormat:@"%.1f", fValue];
        else
            result = [NSString stringWithFormat:@"%.2f", fValue];
    }
    
    return result;
}
@end
