//
//  DPGameLiveEventView.h
//  DacaiProject
//
//  Created by sxf on 14/12/17.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPGameLiveEventView : UIView
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *delayArray;

- (void)trigger;    // 触发

@end

@interface DPGameLiveEventCell : UITableViewCell {
    UILabel *_orderNumLabel;
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_scoreLabel;
    UILabel *_timeLabel;
}

@property (nonatomic, strong, readonly) UILabel *orderNumLabel;        //开赛编号
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;        //主队名称
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;        //客队名称
@property (nonatomic, strong, readonly) UILabel *scoreLabel;           //比分
@property (nonatomic, strong, readonly) UILabel *timeLabel;            //时间
@end