//
//  DPJczqBuyCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPJczqBuyCellEvent) {
    DPJczqBuyCellEventMore,
    DPJCZQBUyCellEventOption,
};

@protocol DPJczqBuyCellDelegate;

@interface DPJczqBuyCell : UITableViewCell

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, weak) id<DPJczqBuyCellDelegate> delegate;

@property (nonatomic, strong, readonly) UILabel *competitionLabel;   //赛事号 003
@property (nonatomic, strong, readonly) UILabel *orderNameLabel;     //赛事名字
@property (nonatomic, strong, readonly) UILabel *matchDateLabel;    // start time or end time 截止时间
@property (nonatomic, strong, readonly) UIImageView *analysisView;//分析

@property(nonatomic,strong,readonly)UIImageView *htSpfDGView;//混投胜平负单关
@property(nonatomic,strong,readonly)UIImageView *htRqDGView;//混投让球单关
@property(nonatomic,strong,readonly)UIImageView *otherDGView;//其他单玩法单关
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;//主队名字
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;//客队名字
@property (nonatomic, strong, readonly) UILabel *homeRankLabel;//主队排名
@property (nonatomic, strong, readonly) UILabel *awayRankLabel;//客队排名
@property (nonatomic, strong, readonly) UILabel *middleLabel;//中间   VS  让球数

@property (nonatomic, strong, readonly) UILabel *stopCellLabel; //停售
@property (nonatomic, strong, readonly) UILabel *stopCellspf; //停售



@property (nonatomic, strong, readonly) UIButton *moreButton;//更多玩法
@property (nonatomic, strong, readonly) UILabel *spfLabel;//胜平负让球数
@property (nonatomic, strong, readonly) UILabel *rqspfLabel;//让球胜平负让球数

@property (nonatomic, strong, readonly) NSArray *optionButtonsRqspf;//让球胜平负
@property (nonatomic, strong, readonly) NSArray *optionButtonsBf;//比分
@property (nonatomic, strong, readonly) NSArray *optionButtonsZjq;//总进球
@property (nonatomic, strong, readonly) NSArray *optionButtonsBqc;//半全场
@property (nonatomic, strong, readonly) NSArray *optionButtonsSpf;//胜平负
@property (nonatomic, strong, readonly) UIImageView *hotView;//热门赛事

- (void)buildLayout;
-(void)analysisViewIsExpand:(BOOL)isExpand;//箭头变化
@end

@protocol DPJczqBuyCellDelegate <NSObject>
@optional
- (void)jczqBuyCell:(DPJczqBuyCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected;
- (void)moreJczqBuyCell:(DPJczqBuyCell *)cell;
- (void)jczqBuyCellInfo:(DPJczqBuyCell *)cell;
@end
