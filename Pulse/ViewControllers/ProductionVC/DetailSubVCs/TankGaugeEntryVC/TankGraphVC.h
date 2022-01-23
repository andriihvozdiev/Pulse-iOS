//
//  TankGraphVC.h
//  Pulse
//
//  Created by Luca on 9/15/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "JBLineChartView.h"
#import "JBBarChartView.h"

@interface TankGraphVC : UIViewController <JBLineChartViewDelegate, JBLineChartViewDataSource, JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) Tanks *tank;
@property (nonatomic, strong) NSArray *arrTankGaugeEntry;
@property (nonatomic, strong) NSArray *arrRunTickets;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscapeUnderlineCenterConstraint;
@property (weak, nonatomic) IBOutlet UIView *landscapeUnderlineView;

@property (weak, nonatomic) IBOutlet UIButton *btnTankHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnRunTickets;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *graph_bg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewTankHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTankHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTankHeightDate;

@property (weak, nonatomic) IBOutlet UIView *viewRunTickets;
@property (weak, nonatomic) IBOutlet UILabel *lblRunTicketGrossVol;
@property (weak, nonatomic) IBOutlet UILabel *lblRunTicketNetVol;
@property (weak, nonatomic) IBOutlet UILabel *lblRunTicketDate;

@property (strong, nonatomic) IBOutlet JBLineChartView *tankHeightChartView;
@property (strong, nonatomic) IBOutlet JBBarChartView *runTicketsChartView;


- (IBAction)onTankHeight:(id)sender;
- (IBAction)onRunTickets:(id)sender;

@end
