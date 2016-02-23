//
//  DPLiveCompetitionSubViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLiveDataCenterViews.h"
@interface DPLiveCompetitionSubViewController : UITableViewController

@end

// 赛事实况
@interface DPLiveCompetitionLiveContentView : UIView

@property (nonatomic, strong, readonly) DPImageLabel *homeLabel;
@property (nonatomic, strong, readonly) DPImageLabel *awayLabel;
@property (nonatomic, strong, readonly) DPImageLabel *timeLabel;
- (void)buildLayout:(NSInteger)rowCount;
@end


// 收发阵容/替补阵容
@class DPImageLabel;
@interface DPLiveCompetitionPlayerCell : UITableViewCell
@property (nonatomic, strong, readonly) DPImageLabel *homeImageLabel;
@property (nonatomic, strong, readonly) UILabel *homePlayerLabel;
@property (nonatomic, strong, readonly) DPImageLabel *awayImageLabel;
@property (nonatomic, strong, readonly) UILabel *awayPlayerLabel;

- (void)buildTitle;
- (void)buildLayout;
@end

// 赛事实况
@interface DPLiveCompetitionLiveContentCell : UITableViewCell
@property (nonatomic, strong, readonly) DPLiveCompetitionLiveContentView *liveView;
@property (nonatomic, strong, readonly)UIView* bottomView ;


@end
