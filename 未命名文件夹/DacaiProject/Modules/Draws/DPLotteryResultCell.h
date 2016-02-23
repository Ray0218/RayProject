//
//  DPLotteryResultCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPLotteryResultCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *gameTypeLabel;
@property (nonatomic, strong, readonly) UILabel *gameNameLabel;
@property (nonatomic, strong, readonly) UILabel *drawTimeLabel;

@property (nonatomic, strong, readonly) NSArray *nmgks;         // 快3
@property (nonatomic, strong, readonly) NSArray *sdpks;         // 扑克3
@property (nonatomic, strong, readonly) NSArray *labels;        // 数字彩, 足彩
@property (nonatomic, strong, readonly) UILabel *matchLabel;    // 竞彩, 北单, 篮彩
@property (nonatomic, strong, readonly) UILabel *preResultLabel;    // 试机号

- (void)buildLayout;

@end

@interface DPLotteryResultCell (GameType)

@property (nonatomic, assign, readonly) GameTypeId gameType;

- (void)layoutWithGameType:(GameTypeId)gameType;

@end
