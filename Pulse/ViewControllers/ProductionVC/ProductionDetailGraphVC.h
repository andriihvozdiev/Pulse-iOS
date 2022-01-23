//
//  ProductionDetailGraphVC.h
//  Pulse
//
//  Created by Luca on 9/9/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBLineChartView.h"
#import "AppData.h"

@interface ProductionDetailGraphVC : UIViewController <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) NSArray *arrDetailData;

@property (weak, nonatomic) IBOutlet UIButton *btnLinear;
@property (weak, nonatomic) IBOutlet UIButton *btnSemiLog;

@property (weak, nonatomic) IBOutlet UIView *menuUnderline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuUnderlineCenterConstraint;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *graph_bg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *linearGraphView;
@property (weak, nonatomic) IBOutlet UIView *semiLogGraphView;
@property (weak, nonatomic) IBOutlet UILabel *lblOil;
@property (weak, nonatomic) IBOutlet UILabel *lblGas;
@property (weak, nonatomic) IBOutlet UILabel *lblWater;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) IBOutlet JBLineChartView *linearChartView;
@property (strong, nonatomic) IBOutlet JBLineChartView *semiLogChartView;

- (IBAction)onLinear:(id)sender;
- (IBAction)onSemiLog:(id)sender;

@end
