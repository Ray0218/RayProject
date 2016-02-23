//
//  DPJcLqBuyCelll.h
//  DacaiProject
//
//  Created by sxf on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DPJcLqBuyCellEvent) {
    DPJcLqBuyCellEventMore,
    DPJCLqBuyCellEventOption,
};
@protocol DPJcLqBuyCellDelegate;
@interface DPJcLqBuyCelll : UITableViewCell
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) id<DPJcLqBuyCellDelegate> delegate;

@property (nonatomic, strong, readonly) UILabel *competitionLabel;
@property (nonatomic, strong, readonly) UILabel *orderNameLabel;
@property (nonatomic, strong, readonly) UILabel *matchDateLabel;    // start time or end time

@property (nonatomic, strong, readonly) UILabel *homeNameLabel;
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;
@property (nonatomic, strong, readonly) UILabel *homeRankLabel;
@property (nonatomic, strong, readonly) UILabel *awayRankLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;

@property (nonatomic, strong, readonly) UIButton *moreButton;
@property (nonatomic, strong, readonly) UILabel *rangfenLabel;
@property (nonatomic, strong, readonly) UILabel *dxfLabel;

@property(nonatomic,strong,readonly) UILabel *rfTitleLabel ;//让分
@property(nonatomic,strong,readonly) UILabel *dxfTitleLabel ;//比分


- (void)buildLayout;

// 135: 混投
// 131: 胜负
// 132: 让分胜负
// 134: 大小分
// 133: 胜分差

@property (nonatomic, strong, readonly) NSArray *options131;
@property (nonatomic, strong, readonly) NSArray *options132;
@property (nonatomic, strong, readonly) NSArray *options133;
@property (nonatomic, strong, readonly) NSArray *options134;
@end

@protocol DPJcLqBuyCellDelegate <NSObject>
@optional
- (void)jcLqBuyCell:(DPJcLqBuyCelll *)cell event:(DPJcLqBuyCellEvent)event info:(NSDictionary *)info;
@end