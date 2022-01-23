//
//  MeterDataGraphVC.h
//  Pulse
//
//  Created by Luca on 9/17/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "JBLineChartView.h"

@interface MeterDataGraphVC : UIViewController <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) Meters *meter;
@property (nonatomic, strong) NSArray *arrMeterData;
@property (nonatomic, strong) NSArray *arrMeterRates;

@property (weak, nonatomic) IBOutlet UIButton *btnTotalValue;
@property (weak, nonatomic) IBOutlet UIButton *btnMeterRate;
@property (weak, nonatomic) IBOutlet UIView *landscapeUnderline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscapeUnderlineCenterConstraint;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *valueGraphView;
@property (weak, nonatomic) IBOutlet UIImageView *graph_bg;
@property (weak, nonatomic) IBOutlet UIView *rateGraphView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidthConstraint;


@property (weak, nonatomic) IBOutlet UILabel *lblSelectedValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedDate;

@property (strong, nonatomic) IBOutlet JBLineChartView *valueChartView;
@property (strong, nonatomic) IBOutlet JBLineChartView *rateChartView;

// landscape button events
- (IBAction)onTotalValue:(id)sender;
- (IBAction)onMeterRate:(id)sender;

@end
