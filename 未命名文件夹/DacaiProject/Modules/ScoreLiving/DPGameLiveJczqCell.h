//
//  DPGameLiveJczqCell.h
//  DacaiProject
//
//  Created by sxf on 14/12/5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPImageLabel.h"
#define gameLiveBgTag 100000
#define gameLiveImageTag  200000
#define gameLiveLabelTag  300000
#define gameLiveTimeTag  400000
@protocol DPGameLiveJcCellDelegate;
@interface DPGameLiveJczqCell : UITableViewCell
{
    UILabel *_timeLabel;
    UIImageView *_homeTeamImage;
    UIImageView *_awayTeamImage;
    UILabel *_homeTeamName;
    UILabel *_awayTeamName;
    UILabel *_homeTeamRank;
    UILabel *_awayTeamRank;
    UILabel *_beginTimeStatusLabel;
    UILabel *_scoreLabel;
    UIImageView *_analysisView;
    UILabel *_halfscoreLabel;
    UILabel *_timedianLabel;
}
@property(nonatomic,assign)id<DPGameLiveJcCellDelegate>delegate;
@property(nonatomic,strong,readonly)UILabel *timeLabel;//比赛时间
@property(nonatomic,strong,readonly)UIImageView *homeTeamImage;//主队队标
@property(nonatomic,strong,readonly)UIImageView *awayTeamImage;//客队对标
@property(nonatomic,strong,readonly)UILabel *homeTeamName;//主队名称
@property(nonatomic,strong,readonly)UILabel *awayTeamName;//客队名称
@property(nonatomic,strong,readonly)UILabel *homeTeamRank;//主队排名
@property(nonatomic,strong,readonly)UILabel *awayTeamRank;//客队排名
@property(nonatomic,strong,readonly)UILabel *beginTimeStatusLabel;//开始后状态
@property(nonatomic,strong,readonly)UILabel *timedianLabel;//时间后边的点
@property(nonatomic,strong,readonly)UILabel *scoreLabel;//比分
@property (nonatomic, strong, readonly) UIImageView *analysisView;//
@property(nonatomic,strong,readonly)UILabel  *halfscoreLabel;//半场比分
@property(nonatomic,assign)NSInteger matchId;
-(void)analysisViewIsExpand:(BOOL)isExpand;
//开赛状态
-(NSString *)matchScoreStatus:(NSInteger)status;
@end


@interface DPgameLiveJCInfoCell : UITableViewCell
{
    UIImageView *_noDataIamgeLabel;
    UILabel     *_noDataLabel;
    
}
@property(nonatomic,strong,readonly)UIImageView *noDataIamgeLabel;
@property(nonatomic,strong,readonly)UILabel *noDataLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  eventTotal:(NSInteger)eventTotal;
//红黄牌事件
-(NSString *)gameliveEventForIndex:(NSInteger)index;
//主客队
-(void)changeBackViewLayOut:(NSInteger)index  ishome:(BOOL)ishome;
@end

@protocol DPGameLiveJcCellDelegate <NSObject>

@optional
-(void)openGameLiveInfoForCell:(DPGameLiveJczqCell *)cell;
-(void)openGameLiveEVentForCell:(DPGameLiveJczqCell *)cell;//赛事页面
-(void)guanzhuGameLiveInfoForCell:(DPGameLiveJczqCell *)cell button:(UIButton*)button  matchId:(NSInteger)matchId;
@end