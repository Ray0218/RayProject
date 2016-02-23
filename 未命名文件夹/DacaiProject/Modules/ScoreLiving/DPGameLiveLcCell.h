//
//  DPGameLiveLcCell.h
//  DacaiProject
//
//  Created by sxf on 14/12/15.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DPGameLiveLcCellDelegate;
#define dianImageTag 1100
#define homeScoreLabelTag 1200
#define awayScoreLabelTag 1300
@interface DPGameLiveLcCell : UITableViewCell
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
    UILabel *_dianView;
    UILabel *_timedianLabel;
}
@property(nonatomic,assign)id<DPGameLiveLcCellDelegate>delegate;
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
@property(nonatomic,strong,readonly)UILabel *dianView;
@property(nonatomic,assign)NSInteger matchId;
-(void)analysisViewIsExpand:(BOOL)isExpand;
//更新赛事（红绿点）
-(void)dianlabelTextForMatchState:(NSInteger)matchState;
////更新赛事（红绿点）
//-(void)upDateDianViewAlllayOut:(NSInteger)overTotal  jiasai:(NSInteger)jiasaiTotal  totalSaishi:(NSInteger)totalSaishi;
@end


@interface DPgameLiveLCInfoCell : UITableViewCell
{
    UILabel *_fenshuLabel;//分差，总分
    UILabel *_homeLabel;//主队名称
    UILabel *_drawLabel;//客队名称
    
}
@property(nonatomic,strong,readonly) UILabel *fenshuLabel;
@property(nonatomic,strong,readonly) UILabel *homeLabel;
@property(nonatomic,strong,readonly) UILabel *drawLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  eventTotal:(NSInteger)eventTotal;

@end


 @protocol DPGameLiveLcCellDelegate <NSObject>

@optional
-(void)openGameLiveInfoForCell:(DPGameLiveLcCell *)cell;
-(void)openGameLiveEVentForCell:(DPGameLiveLcCell *)cell;//赛事页面
-(void)guanzhuGameLiveInfoForCell:(DPGameLiveLcCell *)cell button:(UIButton*)button matchId:(NSInteger )matchId;
@end