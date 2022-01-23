#import "WellheadDataGraphVC.h"

@interface WellheadDataGraphVC ()
{
    float maxValue;
    float m_graphWidth;
    NSInteger m_totalCount;
}
@end

@implementation WellheadDataGraphVC
@synthesize arrWellheadData;
@synthesize pressureChartView;
@synthesize rodpumpChartView;
@synthesize espChartView;
@synthesize fluidcutChartView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_totalCount = 0;
    
    pressureChartView = [[JBLineChartView alloc] init];
    pressureChartView.dataSource = self;
    pressureChartView.delegate = self;
    [self.viewPressure addSubview:pressureChartView];
    
    rodpumpChartView = [[JBLineChartView alloc] init];
    rodpumpChartView.dataSource = self;
    rodpumpChartView.delegate = self;
    [self.viewRodPump addSubview:rodpumpChartView];
    
    espChartView = [[JBLineChartView alloc] init];
    espChartView.dataSource = self;
    espChartView.delegate = self;
    [self.viewESP addSubview:espChartView];
    
    fluidcutChartView = [[JBLineChartView alloc] init];
    fluidcutChartView.dataSource = self;
    fluidcutChartView.delegate = self;
    [self.viewFluidCuts addSubview:fluidcutChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    m_totalCount = self.arrWellheadData.count;
    
    if (m_totalCount > 30) {
        m_graphWidth = 50 + (screenSize.width - 50) * m_totalCount / 30.0f;
    } else {
        m_graphWidth = screenSize.width;
    }
    self.graphWidthConstraint.constant = m_graphWidth;
    
    self.landscapeUnderlineCenterConstraint.constant = -screenSize.width * 3 / 8.0f;
    [self.view layoutIfNeeded];
    
    [self.btnPressure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRodPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnESP setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnFluidCuts setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self getMaxValue];
    [self initPressureGraph];
}

-(void) getMaxValue
{
    maxValue = 0;
    for (WellheadData *wellheadData in arrWellheadData) {
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.tubingPressure]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.casingPressure]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.bradenheadPressure]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.choke]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.spm]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.strokeSize]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.pound]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.espHz]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.espAmp]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.oilCut]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.waterCut]];
        maxValue = [self getMax:maxValue second:[self getFloatValue:wellheadData.emulsionCut]];
    }
}

-(float) getMax:(float)first second:(float)second
{
    if (first >= second) return first;
    return second;
}

-(void) initPressureGraph
{
    self.graph_bg.image = nil;
    
    [self.viewPressure setHidden:NO];
    [self.viewRodPump setHidden:YES];
    [self.viewESP setHidden:YES];
    [self.viewFluidCuts setHidden:YES];
    
    [self.viewPressureInfo setHidden:NO];
    [self.viewRodPumpInfo setHidden:YES];
    [self.viewESPInfo setHidden:YES];
    [self.viewFluidCutsInfo setHidden:YES];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    rect.origin.x = 50;
    if (m_totalCount == 0) {
        rect.size.width = 0;
    } else {
        rect.size.width = (rect.size.width-50) * (m_totalCount - 1) / (float)m_totalCount;
    }
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    
    pressureChartView.frame = rect;
    
    [pressureChartView setMaximumValue:maxValue];
    [pressureChartView setMinimumValue:0];
    
    [pressureChartView reloadData];
    
    if (arrWellheadData.count > 0) {
        WellheadData *wellheadData = self.arrWellheadData[0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
        
        self.lblTubingPressure.text = [NSString stringWithFormat:@"Tubing Pressure: %@", [self getString:wellheadData.tubingPressure]];
        self.lblCasingPressure.text = [NSString stringWithFormat:@"Casing Pressure: %@", [self getString:wellheadData.casingPressure]];
        self.lblBradenheadPressure.text = [NSString stringWithFormat:@"Bradenhead Pressure: %@", [self getString:wellheadData.bradenheadPressure]];
        self.lblChokeSize.text = [NSString stringWithFormat:@"Choke Size: %@", [self getString:wellheadData.choke]];
        self.lblPressureCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
    }
    
    [self drawGraphBackground:m_totalCount];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void) initRodPumpGraph
{
    self.graph_bg.image = nil;
    
    [self.viewPressure setHidden:YES];
    [self.viewRodPump setHidden:NO];
    [self.viewESP setHidden:YES];
    [self.viewFluidCuts setHidden:YES];
    
    [self.viewPressureInfo setHidden:YES];
    [self.viewRodPumpInfo setHidden:NO];
    [self.viewESPInfo setHidden:YES];
    [self.viewFluidCutsInfo setHidden:YES];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    
    rect.origin.x = 50;
    if (m_totalCount == 0) {
        rect.size.width = 0;
    } else {
        rect.size.width = (rect.size.width-50) * (m_totalCount - 1) / (float)m_totalCount;
    }
    
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    rodpumpChartView.frame = rect;
    
    [rodpumpChartView setMaximumValue:maxValue];
    [rodpumpChartView setMinimumValue:0];
    
    [rodpumpChartView reloadData];
    
    if (arrWellheadData.count > 0) {
        WellheadData *wellheadData = self.arrWellheadData[0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
        
        self.lblSPM.text = [NSString stringWithFormat:@"SPM: %@", [self getString:wellheadData.spm]];
        self.lblStrokeSize.text = [NSString stringWithFormat:@"Stroke Size: %@", [self getString:wellheadData.strokeSize]];
        self.lblPound.text = [NSString stringWithFormat:@"Pound: %@", [self getString:wellheadData.pound]];
        self.lblRodpumpCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
    }
    
    [self drawGraphBackground:m_totalCount];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void) initESPGraph
{
    self.graph_bg.image = nil;
    
    [self.viewPressure setHidden:YES];
    [self.viewRodPump setHidden:YES];
    [self.viewESP setHidden:NO];
    [self.viewFluidCuts setHidden:YES];
    
    [self.viewPressureInfo setHidden:YES];
    [self.viewRodPumpInfo setHidden:YES];
    [self.viewESPInfo setHidden:NO];
    [self.viewFluidCutsInfo setHidden:YES];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    
    rect.origin.x = 50;
    if (m_totalCount == 0) {
        rect.size.width = 0;
    } else {
        rect.size.width = (rect.size.width-50) * (m_totalCount - 1) / (float)m_totalCount;
    }
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    espChartView.frame = rect;
    
    [espChartView setMaximumValue:maxValue];
    [espChartView setMinimumValue:0];
    
    [espChartView reloadData];
    
    if (arrWellheadData.count > 0) {
        WellheadData *wellheadData = self.arrWellheadData[0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
        
        self.lblESPHz.text = [NSString stringWithFormat:@"ESP Hz: %@", [self getString:wellheadData.espHz]];
        self.lblESPAmp.text = [NSString stringWithFormat:@"ESP Amp: %@", [self getString:wellheadData.espAmp]];
        self.lblESPCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
    }
    
    [self drawGraphBackground:m_totalCount];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void) initFluidCutGraph
{
    self.graph_bg.image = nil;
    
    [self.viewPressure setHidden:YES];
    [self.viewRodPump setHidden:YES];
    [self.viewESP setHidden:YES];
    [self.viewFluidCuts setHidden:NO];
    
    [self.viewPressureInfo setHidden:YES];
    [self.viewRodPumpInfo setHidden:YES];
    [self.viewESPInfo setHidden:YES];
    [self.viewFluidCutsInfo setHidden:NO];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(0, 0, m_graphWidth, screenSize.height);
    
    rect.origin.x = 50;
    if (m_totalCount == 0) {
        rect.size.width = 0;
    } else {
        rect.size.width = (rect.size.width-50) * (m_totalCount - 1) / (float)m_totalCount;
    }
    rect.size.height = rect.size.height * 340 / 375.0f - 50;  // top: 35, bottom : 50
    fluidcutChartView.frame = rect;
    
    [fluidcutChartView setMaximumValue:maxValue];
    [fluidcutChartView setMinimumValue:0];
    
    [fluidcutChartView reloadData];
    
    if (arrWellheadData.count > 0) {
        WellheadData *wellheadData = self.arrWellheadData[0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy hh:mm a"];
        NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
        
        self.lblOilCut.text = [NSString stringWithFormat:@"Oil Cut: %@", [self getString:wellheadData.oilCut]];
        self.lblWaterCut.text = [NSString stringWithFormat:@"Water Cut: %@", [self getString:wellheadData.waterCut]];
        self.lblEmulsionCut.text = [NSString stringWithFormat:@"Emulsion Cut: %@", [self getString:wellheadData.emulsionCut]];
        self.lblFluidCutsCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
    }
    
    [self drawGraphBackground:m_totalCount];
    
    float offsetX = self.scrollView.contentSize.width - screenSize.width;
    if (offsetX < 0) offsetX = 0;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark -
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
    float graphHeight = rect.size.height - 50;
    float axis_width = (m_graphWidth - 50) * (totalcount - 1) / (float)totalcount;
    int step = pow(10, (int)log10f(maxValue));
    float deltaHeight = graphHeight * step / maxValue;
    for (int i = 0; i < maxValue; i += step) {
        float y = bottomY - deltaHeight * i / step;
        CGContextMoveToPoint(context, 45, y);
        CGContextAddLineToPoint(context, axis_width + 50, y);
        CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1);
        CGContextStrokePath(context);
        [self addText:[NSString stringWithFormat:@"%d", i] withPoint:CGPointMake(40, y - 8) fontSize:10 align:@"right"];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSInteger maxIndex = self.arrWellheadData.count - 1;
    
    int lastIndex = -5;
    
    float spacing = (m_graphWidth - 50) / (float)totalcount;
    for (int i = 0; i < totalcount; i++) {
        CGContextMoveToPoint(context, 50 + spacing * i, 5);
        CGContextAddLineToPoint(context, 50 + spacing * i, bottomY);
        
        if (lastIndex + 5 == i) {
            lastIndex = i;
            
            WellheadData *wellheadData = arrWellheadData[maxIndex - i];
            NSString *strDate = [df stringFromDate:wellheadData.checkTime];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
        
        if (totalcount < 5 && i == totalcount-1)
        {
            lastIndex = i;
            
            WellheadData *wellheadData = arrWellheadData[maxIndex - i];
            NSString *strDate = [df stringFromDate:wellheadData.checkTime];
            
            [self addText:strDate withPoint:CGPointMake(50 + spacing * i, bottomY + 8) fontSize:11 align:@"center"];
        }
    }
    
    if (totalcount > 0 && lastIndex < totalcount - 3) {
        lastIndex = (int)totalcount - 1;
        WellheadData *wellheadData = arrWellheadData[maxIndex - lastIndex];
        NSString *strDate = [df stringFromDate:wellheadData.checkTime];
        
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


#pragma mark - landscape button events

- (IBAction)onPressure:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = -screenSize.width * 3 / 8.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderline shakeWithWidth:2.5f];
    }];
    [self.btnPressure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRodPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnESP setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnFluidCuts setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initPressureGraph];
}

- (IBAction)onRodPump:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = -screenSize.width / 8.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderline shakeWithWidth:2.5f];
    }];
    [self.btnPressure setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnRodPump setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnESP setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnFluidCuts setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initRodPumpGraph];
}

- (IBAction)onESP:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = screenSize.width / 8.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderline shakeWithWidth:2.5f];
    }];
    [self.btnPressure setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnRodPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnESP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnFluidCuts setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self initESPGraph];
}

- (IBAction)onFluidCuts:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.landscapeUnderlineCenterConstraint.constant = screenSize.width * 3 / 8.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.landscapeUnderline shakeWithWidth:2.5f];
    }];
    [self.btnPressure setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnRodPump setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnESP setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnFluidCuts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self initFluidCutGraph];
}


#pragma mark - JBLineChartView datasource
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    NSInteger numberOfLines = 0;
    
    if (lineChartView == pressureChartView) {
        numberOfLines = 4;
    }
    if (lineChartView == rodpumpChartView) {
        numberOfLines = 3;
    }
    if (lineChartView == espChartView) {
        numberOfLines = 2;
    }
    if (lineChartView == fluidcutChartView) {
        numberOfLines = 3;
    }
    
    return numberOfLines;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return arrWellheadData.count;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    float yValue = 0;
    
    NSInteger maxIndex = self.arrWellheadData.count - 1;
    
    WellheadData *wellheadData = self.arrWellheadData[maxIndex - horizontalIndex];
    
    if (lineChartView == pressureChartView) {
        switch (lineIndex) {
            case 0:
                yValue = [self getFloatValue:wellheadData.tubingPressure];
                break;
            case 1:
                yValue = [self getFloatValue:wellheadData.casingPressure];
                break;
            case 2:
                yValue = [self getFloatValue:wellheadData.bradenheadPressure];
                break;
            case 3:
                yValue = [self getFloatValue:wellheadData.choke];
                break;
            default:
                break;
        }
    }
    
    if (lineChartView == rodpumpChartView) {
        switch (lineIndex) {
            case 0:
                yValue = [self getFloatValue:wellheadData.spm];
                break;
            case 1:
                yValue = [self getFloatValue:wellheadData.strokeSize];
                break;
            case 2:
                yValue = [self getFloatValue:wellheadData.pound];
                break;
            default:
                break;
        }
    }
    
    if (lineChartView == espChartView) {
        switch (lineIndex) {
            case 0:
                yValue = [self getFloatValue:wellheadData.espHz];
                break;
            case 1:
                yValue = [self getFloatValue:wellheadData.espAmp];
                break;
            default:
                break;
        }
    }
    
    if (lineChartView == fluidcutChartView) {
        switch (lineIndex) {
            case 0:
                yValue = [self getFloatValue:wellheadData.oilCut];
                break;
            case 1:
                yValue = [self getFloatValue:wellheadData.waterCut];
                break;
            case 2:
                yValue = [self getFloatValue:wellheadData.emulsionCut];
                break;
            default:
                break;
        }
    }
    
    return yValue;
}


- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    UIColor *lineColor  = [UIColor whiteColor];
    switch (lineIndex) {
        case 0:
            lineColor = [UIColor colorWithRed:184/255.0f green:233/255.0f blue:134/255.0f alpha:1];
            break;
        case 1:
            lineColor = [UIColor colorWithRed:1 green:141/255.0f blue:138/255.0f alpha:1];
            break;
        case 2:
            lineColor = [UIColor colorWithRed:122/255.0f green:218/255.0f blue:1.0f alpha:1];
            break;
        case 3:
            lineColor = [UIColor colorWithRed:138/255.0f green:138/255.0f blue:138/255.0f alpha:1];
            break;
        default:
            break;
    }
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
    UIColor *color  = [UIColor whiteColor];
    
    return color;
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    [self.scrollView setScrollEnabled:NO];
    
    NSInteger maxIndex = self.arrWellheadData.count-1;
    
    WellheadData *wellheadData = self.arrWellheadData[maxIndex - horizontalIndex];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy hh:mm a"];
    NSString *strDateTime = [df stringFromDate:wellheadData.checkTime];
    
    if (lineChartView == pressureChartView) {
        self.lblTubingPressure.text = [NSString stringWithFormat:@"Tubing Pressure: %@", [self getString:wellheadData.tubingPressure]];
        self.lblCasingPressure.text = [NSString stringWithFormat:@"Casing Pressure: %@", [self getString:wellheadData.casingPressure]];
        self.lblBradenheadPressure.text = [NSString stringWithFormat:@"Bradenhead Pressure: %@", [self getString:wellheadData.bradenheadPressure]];
        self.lblChokeSize.text = [NSString stringWithFormat:@"Choke Size: %@", [self getString:wellheadData.choke]];
        self.lblPressureCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
        
        switch (lineIndex) {
            case 0:
                [self.lblTubingPressure setFont:[UIFont fontWithName:self.lblTubingPressure.font.fontName size:13]];
                break;
            case 1:
                [self.lblCasingPressure setFont:[UIFont fontWithName:self.lblTubingPressure.font.fontName size:13]];
                break;
            case 2:
                [self.lblBradenheadPressure setFont:[UIFont fontWithName:self.lblTubingPressure.font.fontName size:13]];
                break;
            case 3:
                [self.lblChokeSize setFont:[UIFont fontWithName:self.lblTubingPressure.font.fontName size:13]];
                break;
            default:
                break;
        }
    }
    
    if (lineChartView == rodpumpChartView) {
        self.lblSPM.text = [NSString stringWithFormat:@"SPM: %@", [self getString:wellheadData.spm]];
        self.lblStrokeSize.text = [NSString stringWithFormat:@"Stroke Size: %@", [self getString:wellheadData.strokeSize]];
        self.lblPound.text = [NSString stringWithFormat:@"Pound: %@", [self getString:wellheadData.pound]];
        self.lblRodpumpCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
        
        switch (lineIndex) {
            case 0:
                [self.lblSPM setFont:[UIFont fontWithName:self.lblSPM.font.fontName size:13]];
                break;
            case 1:
                [self.lblStrokeSize setFont:[UIFont fontWithName:self.lblStrokeSize.font.fontName size:13]];
                break;
            case 2:
                [self.lblPound setFont:[UIFont fontWithName:self.lblPound.font.fontName size:13]];
                break;
            default:
                break;
        }
    }
    
    if (lineChartView == espChartView) {
        self.lblESPHz.text = [NSString stringWithFormat:@"ESP Hz: %@", [self getString:wellheadData.espHz]];
        self.lblESPAmp.text = [NSString stringWithFormat:@"ESP Amp: %@", [self getString:wellheadData.espAmp]];
        self.lblESPCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
        
        switch (lineIndex) {
            case 0:
                [self.lblESPHz setFont:[UIFont fontWithName:self.lblESPHz.font.fontName size:13]];
                break;
            case 1:
                [self.lblESPAmp setFont:[UIFont fontWithName:self.lblESPAmp.font.fontName size:13]];
                break;
            default:
                break;
        }
    }
    
    if (lineChartView == fluidcutChartView) {
        self.lblOilCut.text = [NSString stringWithFormat:@"Oil Cut: %@", [self getString:wellheadData.oilCut]];
        self.lblWaterCut.text = [NSString stringWithFormat:@"Water Cut: %@", [self getString:wellheadData.waterCut]];
        self.lblEmulsionCut.text = [NSString stringWithFormat:@"Emulsion Cut: %@", [self getString:wellheadData.emulsionCut]];
        self.lblFluidCutsCheckTime.text = [NSString stringWithFormat:@"CheckTime: %@", strDateTime];
        
        switch (lineIndex) {
            case 0:
                [self.lblOilCut setFont:[UIFont fontWithName:self.lblOilCut.font.fontName size:13]];
                break;
            case 1:
                [self.lblWaterCut setFont:[UIFont fontWithName:self.lblWaterCut.font.fontName size:13]];
                break;
            case 2:
                [self.lblEmulsionCut setFont:[UIFont fontWithName:self.lblEmulsionCut.font.fontName size:13]];
                break;
            default:
                break;
        }
    }
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.scrollView setScrollEnabled:YES];
    
    if (lineChartView == pressureChartView) {
        [self.lblTubingPressure setFont:[UIFont fontWithName:self.lblTubingPressure.font.fontName size:12]];
        [self.lblCasingPressure setFont:[UIFont fontWithName:self.lblCasingPressure.font.fontName size:12]];
        [self.lblBradenheadPressure setFont:[UIFont fontWithName:self.lblBradenheadPressure.font.fontName size:12]];
        [self.lblChokeSize setFont:[UIFont fontWithName:self.lblChokeSize.font.fontName size:12]];
    }
    if (lineChartView == rodpumpChartView) {
        [self.lblSPM setFont:[UIFont fontWithName:self.lblSPM.font.fontName size:12]];
        [self.lblStrokeSize setFont:[UIFont fontWithName:self.lblStrokeSize.font.fontName size:12]];
        [self.lblPound setFont:[UIFont fontWithName:self.lblPound.font.fontName size:12]];
    }
    if (lineChartView == espChartView) {
        [self.lblESPHz setFont:[UIFont fontWithName:self.lblESPHz.font.fontName size:12]];
        [self.lblESPAmp setFont:[UIFont fontWithName:self.lblESPAmp.font.fontName size:12]];
    }
    if (lineChartView == fluidcutChartView) {
        [self.lblOilCut setFont:[UIFont fontWithName:self.lblOilCut.font.fontName size:12]];
        [self.lblWaterCut setFont:[UIFont fontWithName:self.lblWaterCut.font.fontName size:12]];
        [self.lblEmulsionCut setFont:[UIFont fontWithName:self.lblEmulsionCut.font.fontName size:12]];
    }
    
}

#pragma mark -
-(NSString*) getString:(NSString*)data
{
    NSString *result = @"";
    if (data == nil)
        result = @"-";
    else
        result = data;
    return result;
}

-(CGFloat)getFloatValue:(NSString*)value
{
    float result = 0;
    if (value) {
        result = [value floatValue] < 0 ? 0 : [value floatValue];
    }
    
    if (result > 100) result = result * 100 / 100;
    else if (result > 10) result = result * 10 / 10.0f;
    else result = result / 1.00f;
    
    return result;
}
@end
