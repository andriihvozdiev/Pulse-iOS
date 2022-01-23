//
//  RigReportsDetailContainerVC.h
//  Pulse
//
//  Created by Luca on 8/31/18.
//  Copyright © 2018 Luca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"

@interface RigReportsDetailContainerVC : UIViewController <ChangedSyncStatusDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property(nonatomic, strong) NSArray *arrRigReportsData;
@property(nonatomic, strong) NSMutableArray *arrRigReports;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *redStatusView;
@property (weak, nonatomic) IBOutlet UIView *yellowStatusView;
@property (weak, nonatomic) IBOutlet UIView *blueStatusView;
@property (weak, nonatomic) IBOutlet UIView *greenStatusView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property NSInteger selectedIndex;

- (IBAction)onBack:(id)sender;
- (IBAction)onStoplight:(id)sender;

@end
