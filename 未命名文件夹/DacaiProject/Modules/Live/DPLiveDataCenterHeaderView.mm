//
//  DPLiveDataCenterHeaderView.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveDataCenterHeaderView.h"
#import "DPScoreLiveDefine.h"
#import "FrameWork.h"
#import <MDHTMLLabel/MDHTMLLabel.h>

#import <AFNetworking/UIKit+AFNetworking.h>
#import "DPLiveDataCenterViews.h"

#define kDataCenterHeaderAlphaHeight    80.0f
#define kDataCenterLogoImageLength      40.0f

@interface DPLiveDataCenterHeaderView () <AXStretchableHeaderViewDelegate> {
@private
    CFootballCenter *_dateCenter;
    CBasketballCenter *_dataCenterBasket ;
    GameTypeId _gameType ;
}

@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, strong, readonly) UIImageView *backgroundView;
@property (nonatomic, strong, readonly) UILabel *startTimeLabel;
@property (nonatomic, strong, readonly) UIImageView *homeLogoView;
@property (nonatomic, strong, readonly) UIImageView *awayLogoView;

@property (nonatomic, strong, readonly) MDHTMLLabel *homeNameLabel;
@property (nonatomic, strong, readonly) MDHTMLLabel *awayNameLabel;


@property (nonatomic, strong, readonly) UILabel *homeAddLabel;
@property (nonatomic, strong, readonly) UILabel *awayAddLabel;

@property (nonatomic, strong, readonly) UILabel *homeScoreLabel;
@property (nonatomic, strong, readonly) UILabel *awayScoreLabel;


@property (nonatomic, strong, readonly) UILabel *ongoingLabel;
@property (nonatomic, strong, readonly) UILabel *pointLabel;


@property (nonatomic, strong, readonly) UIView *thumbnailView;
@property (nonatomic, strong, readonly) UIImageView *thumbnailScoreView;
@property (nonatomic, strong, readonly) UILabel *thumbnailHomeScore;
@property (nonatomic, strong, readonly) UILabel *thumbnailAwayScore;
@property (nonatomic, strong, readonly) UILabel *thumbnailOngoingLabel;
@property (nonatomic, strong, readonly) UILabel *thumbnailPointLabel;

//@property (nonatomic, strong, readonly) UILabel *thumbnailHomeName;
@property (nonatomic, strong, readonly) MDHTMLLabel *thumbnailHomeName;
@property (nonatomic, strong, readonly) MDHTMLLabel *thumbnailAwayName;

//@property (nonatomic, strong, readonly) UILabel *thumbnailAwayName;
//@property (nonatomic, strong, readonly) UILabel *thumbnailHomeRank;
//@property (nonatomic, strong, readonly) UILabel *thumbnailAwayRank;

@end

@implementation DPLiveDataCenterHeaderView


-(instancetype)initWithGameType:(GameTypeId)gameType{
    self = [super init];
    if (self) {
        // Initialization code
        _gameType = gameType ;
        [self _initializeWithGameType:gameType];
        [self _buildLayoutWithGameType:gameType];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pvt_Notify:) name:kLiveDataNotifyName object:nil];
        
        
        if (gameType == GameTypeLcNone) {
            _dataCenterBasket = CFrameWork::GetInstance()->GetBasketballCenter();
        }else
            _dateCenter = CFrameWork::GetInstance()->GetFootballCenter();

    }
    return self;
}
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        [self _initialize];
//        [self _buildLayout];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pvt_Notify:) name:kLiveDataNotifyName object:nil];
//        
//        _dateCenter = CFrameWork::GetInstance()->GetFootballCenter();
//    }
//    return self;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLiveDataNotifyName object:nil];
    
    [self.homeLogoView cancelImageRequestOperation];
    [self.awayLogoView cancelImageRequestOperation];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.bounds) - kDataCenterHeaderTabHeight;
    CGFloat contentAlpha = (height / (kDataCenterHeaderMaxHeight - kDataCenterHeaderAlphaHeight)) - (kDataCenterHeaderAlphaHeight / (kDataCenterHeaderMaxHeight - kDataCenterHeaderAlphaHeight));
    CGFloat thumbnailAlpha = (height / (kDataCenterHeaderMinHeight - kDataCenterHeaderAlphaHeight)) - (kDataCenterHeaderAlphaHeight / (kDataCenterHeaderMinHeight - kDataCenterHeaderAlphaHeight));
    
    self.contentView.alpha = MIN(contentAlpha, 1);
    self.thumbnailView.alpha = MIN(thumbnailAlpha, 1);
    
    // 扩充了tabBar的高度
    self.contentView.frame = CGRectMake(0, MAX(0, CGRectGetHeight(self.bounds) - kDataCenterHeaderMaxHeight - kDataCenterHeaderTabHeight), CGRectGetWidth(self.bounds), kDataCenterHeaderMaxHeight);
    self.thumbnailView.frame = CGRectMake(0, 0 /*(height - kDataCenterHeaderMinHeight) / 2*/, CGRectGetWidth(self.bounds), kDataCenterHeaderMinHeight);
    
    CGFloat imageWidth = MAX(1, CGRectGetHeight(self.bounds) / (kDataCenterHeaderMaxHeight + kDataCenterHeaderTabHeight)) * CGRectGetWidth(self.bounds);
    CGFloat imageHeight = MAX(CGRectGetHeight(self.bounds), kDataCenterHeaderMaxHeight + kDataCenterHeaderTabHeight);
    self.backgroundView.frame = CGRectMake((CGRectGetWidth(self.bounds) - imageWidth) / 2, 0, imageWidth, imageHeight);
}

- (void)_initializeWithGameType:(GameTypeId)gameType {
    self.minimumOfHeight = kDataCenterHeaderMinHeight;
    self.maximumOfHeight = kDataCenterHeaderMaxHeight;
    self.delegate = self;
    
    _backgroundView = [[UIImageView alloc] init];
    
    // _thumbnailView
    _thumbnailView = [[UIView alloc] init];
    _thumbnailView.backgroundColor = [UIColor clearColor];

    
    _thumbnailHomeScore = [[UILabel alloc] init];
    _thumbnailHomeScore.backgroundColor = [UIColor clearColor];
    _thumbnailHomeScore.textColor = [UIColor dp_flatWhiteColor];
    _thumbnailHomeScore.font = [UIFont dp_systemFontOfSize:15];
    _thumbnailHomeScore.textAlignment = NSTextAlignmentCenter;
    _thumbnailHomeScore.text = @"-" ;
    
    _thumbnailAwayScore = [[UILabel alloc] init];
    _thumbnailAwayScore.backgroundColor = [UIColor clearColor];
    _thumbnailAwayScore.textColor = [UIColor dp_flatWhiteColor];
    _thumbnailAwayScore.font = [UIFont dp_systemFontOfSize:15];
    _thumbnailAwayScore.textAlignment = NSTextAlignmentCenter;
    _thumbnailAwayScore.text = @"-" ;
    
    _thumbnailHomeName = [[MDHTMLLabel alloc] init];

    _thumbnailHomeName.backgroundColor = [UIColor clearColor];
    _thumbnailHomeName.textColor = [UIColor dp_flatWhiteColor];
    _thumbnailHomeName.font = [UIFont dp_boldSystemFontOfSize:15];
    _thumbnailHomeName.textAlignment = NSTextAlignmentCenter;
    _thumbnailHomeName.verticalAlignment = MDHTMLLabelVerticalAlignmentBottom ;
    
    _thumbnailAwayName = [[MDHTMLLabel alloc] init];
    _thumbnailAwayName.backgroundColor = [UIColor clearColor];
    _thumbnailAwayName.textColor = [UIColor dp_flatWhiteColor];
    _thumbnailAwayName.font = [UIFont dp_boldSystemFontOfSize:15];
    _thumbnailAwayName.textAlignment = NSTextAlignmentCenter;
    _thumbnailAwayName.verticalAlignment = MDHTMLLabelVerticalAlignmentBottom ;
    
    _thumbnailOngoingLabel = [[UILabel alloc] init];
    if (gameType == GameTypeLcNone ) {
        _thumbnailPointLabel = [[UILabel alloc]init];
        _thumbnailPointLabel.backgroundColor = [UIColor clearColor];
        _thumbnailPointLabel.textColor = UIColorFromRGB(0x555555) ;
        _thumbnailPointLabel.font = [UIFont dp_boldArialOfSize:14];
        _thumbnailPointLabel.textAlignment = NSTextAlignmentCenter;
        
        
        _thumbnailOngoingLabel.backgroundColor = UIColorFromRGB(0x34200E);
    }else{
        _thumbnailOngoingLabel.backgroundColor =[UIColor colorWithRed:0.11 green:0.2 blue:0.38 alpha:1];
    }
    _thumbnailOngoingLabel.textColor = [UIColor dp_flatWhiteColor];
    _thumbnailOngoingLabel.font = [UIFont dp_systemFontOfSize:9];
    _thumbnailOngoingLabel.textAlignment = NSTextAlignmentCenter;
    _thumbnailOngoingLabel.clipsToBounds = YES;
    _thumbnailOngoingLabel.layer.cornerRadius = 2;
    
    // contentView
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    
    _homeLogoView = [[UIImageView alloc] init];
    _awayLogoView = [[UIImageView alloc] init];
    
    _startTimeLabel = [[UILabel alloc] init];
    _startTimeLabel.backgroundColor = [UIColor clearColor];
    _startTimeLabel.textColor = [UIColor dp_flatWhiteColor];
    _startTimeLabel.font = [UIFont dp_systemFontOfSize:10];
    _startTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    _homeNameLabel = [[MDHTMLLabel alloc] init];
    _homeNameLabel.backgroundColor = [UIColor clearColor];
    _homeNameLabel.textColor = [UIColor dp_flatWhiteColor];
    _homeNameLabel.font = [UIFont dp_systemFontOfSize:14];
    _homeNameLabel.textAlignment = NSTextAlignmentCenter;
    _homeNameLabel.verticalAlignment = MDHTMLLabelVerticalAlignmentBottom ;
    
    _awayNameLabel = [[MDHTMLLabel alloc] init];
    _awayNameLabel.backgroundColor = [UIColor clearColor];
    _awayNameLabel.textColor = [UIColor dp_flatWhiteColor];
    _awayNameLabel.font = [UIFont dp_systemFontOfSize:14];
    _awayNameLabel.textAlignment = NSTextAlignmentCenter;
    _awayNameLabel.verticalAlignment = MDHTMLLabelVerticalAlignmentBottom ;
    
    _homeAddLabel = [[UILabel alloc] init];
    _homeAddLabel.backgroundColor = [UIColor clearColor];
    _homeAddLabel.textColor = [UIColor dp_flatWhiteColor];
    _homeAddLabel.font = [UIFont dp_systemFontOfSize:8];
    _homeAddLabel.textAlignment = NSTextAlignmentCenter;
    
    _awayAddLabel = [[UILabel alloc] init];
    _awayAddLabel.backgroundColor = [UIColor clearColor];
    _awayAddLabel.textColor = [UIColor dp_flatWhiteColor];
    _awayAddLabel.font = [UIFont dp_systemFontOfSize:8];
    _awayAddLabel.textAlignment = NSTextAlignmentCenter;

    
    
    _homeScoreLabel = [[UILabel alloc] init];
//    _homeScoreLabel.backgroundColor = [UIColor colorWithRed:0.06 green:0.2 blue:0.42 alpha:1];
    _homeScoreLabel.textColor = [UIColor dp_flatWhiteColor];
    _homeScoreLabel.font = [UIFont dp_systemFontOfSize:30];
    _homeScoreLabel.textAlignment = NSTextAlignmentCenter;
    _homeScoreLabel.clipsToBounds = YES;
    _homeScoreLabel.layer.cornerRadius = 2;
    _homeAddLabel.text = @"--" ;
    
    _awayScoreLabel = [[UILabel alloc] init];
//    _awayScoreLabel.backgroundColor = [UIColor colorWithRed:0.06 green:0.2 blue:0.42 alpha:1];
    _awayScoreLabel.textColor = [UIColor dp_flatWhiteColor];
    _awayScoreLabel.font = [UIFont dp_systemFontOfSize:30];
    _awayScoreLabel.textAlignment = NSTextAlignmentCenter;
    _awayScoreLabel.clipsToBounds = YES;
    _awayScoreLabel.layer.cornerRadius = 2;
    _awayAddLabel.text = @"--" ;
    
    
    _ongoingLabel = [[UILabel alloc] init];
    _ongoingLabel.backgroundColor = [UIColor clearColor];
    _ongoingLabel.textColor = [UIColor dp_flatWhiteColor];
    _ongoingLabel.font = [UIFont dp_systemFontOfSize:12];
    _ongoingLabel.textAlignment = NSTextAlignmentCenter;
    _ongoingLabel.text = @"" ;
    
    if (gameType == GameTypeLcNone) {
        
        _pointLabel = [[UILabel alloc] init];
        _pointLabel.backgroundColor = [UIColor clearColor];
        _pointLabel.textColor = UIColorFromRGB(0x555555) ;
        _pointLabel.font = [UIFont dp_boldArialOfSize:16];
        _pointLabel.textAlignment = NSTextAlignmentCenter;
    
        _backgroundView.image = dp_SportLiveImage(@"databgLC.jpg");
        _thumbnailScoreView = [[UIImageView alloc] initWithImage:dp_SportLiveImage(@"scoreLCbg.png")];
        _homeScoreLabel.backgroundColor = UIColorFromRGB(0x530D0E) ;
        _awayScoreLabel.backgroundColor = UIColorFromRGB(0x530D0E) ;
    }else{
    
        _backgroundView.image = dp_SportLiveImage(@"databg.png");
        _thumbnailScoreView = [[UIImageView alloc] initWithImage:dp_SportLiveImage(@"scorebg.png")];
        _homeScoreLabel.backgroundColor = [UIColor colorWithRed:0.06 green:0.2 blue:0.42 alpha:1];
        _awayScoreLabel.backgroundColor = [UIColor colorWithRed:0.06 green:0.2 blue:0.42 alpha:1];
    }

}

- (void)_buildLayoutWithGameType:(GameTypeId)type {
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
    [self addSubview:self.thumbnailView];
    // contentView
    
    UILabel *scoreDivLabel = ({
        UILabel *label = [[UILabel alloc] init];
        if (type == GameTypeLcNone) {
            label.textColor = UIColorFromRGB(0x530D0E) ;
        }else{
            label.textColor = [UIColor colorWithRed:0.06 green:0.2 blue:0.42 alpha:1];
        }
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:30];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @":";
        label;
    });
    
    UIView *homeLogoBackView = [[UIView alloc] init];
    homeLogoBackView.backgroundColor  = [UIColor greenColor] ;
    UIView *awayLogoBackView = [[UIView alloc] init];
    UIImageView *homeLogoHoverView = [[UIImageView alloc] initWithImage:dp_SportLiveImage(@"logo_hover.png")];
    UIImageView *awayLogoHoverView = [[UIImageView alloc] initWithImage:dp_SportLiveImage(@"logo_hover.png")];
    
    homeLogoBackView.layer.cornerRadius = awayLogoBackView.layer.cornerRadius = 20;
    homeLogoBackView.backgroundColor = awayLogoBackView.backgroundColor = [UIColor whiteColor];
    homeLogoBackView.clipsToBounds = awayLogoBackView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.startTimeLabel];
    [self.contentView addSubview:homeLogoBackView];
    [self.contentView addSubview:homeLogoHoverView];
    [self.contentView addSubview:awayLogoBackView];
    [self.contentView addSubview:awayLogoHoverView];
    [homeLogoBackView addSubview:self.homeLogoView];
    [awayLogoBackView addSubview:self.awayLogoView];
    [self.contentView addSubview:self.homeNameLabel];
    [self.contentView addSubview:self.awayNameLabel];

    [self.contentView addSubview:self.homeScoreLabel];
    [self.contentView addSubview:scoreDivLabel];
    [self.contentView addSubview:self.awayScoreLabel];
    [self.contentView addSubview:self.ongoingLabel];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-30);
    }];
    [self.homeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@40);
        make.right.equalTo(self.contentView.mas_centerX).offset(-8);
        make.centerY.equalTo(self.contentView);
    }];
    [scoreDivLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-1);
    }];
    [self.awayScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@40);
        make.left.equalTo(self.contentView.mas_centerX).offset(8);
        make.centerY.equalTo(self.contentView);
    }];
    
    
    // logo image
    [homeLogoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-15);
        make.right.equalTo(self.homeScoreLabel.mas_left).offset(-25);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [awayLogoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.awayScoreLabel.mas_right).offset(25);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [homeLogoHoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(homeLogoBackView);
    }];
    [awayLogoHoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(awayLogoBackView);
    }];
    [self.homeLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(homeLogoBackView);
    }];
    [self.awayLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(awayLogoBackView);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(homeLogoHoverView.mas_bottom).offset(10);
        make.centerX.equalTo(self.homeLogoView);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(awayLogoHoverView.mas_bottom).offset(10);
        make.centerX.equalTo(self.awayLogoView);
    }];

    
 ////////
    if (type == GameTypeLcNone) {
        [self.contentView addSubview:self.homeAddLabel];
        [self.contentView addSubview:self.awayAddLabel];
        [self.contentView addSubview:self.pointLabel];
        
        [self.homeAddLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.homeNameLabel.mas_bottom).offset(2);
            make.centerX.equalTo(self.homeLogoView);
        }];
        [self.awayAddLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.awayNameLabel.mas_bottom).offset(2);
            make.centerX.equalTo(self.awayLogoView);
        }];
        
        [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_centerY).offset(25);
        }];
        
        [self.ongoingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.pointLabel.mas_bottom);
        }];
    }else{
        [self.ongoingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_centerY).offset(30);
        }];
    }
    

    
    
    
    // thumbnailView
    
    UILabel *thumbnailScoreDivLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor dp_flatWhiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @":";
        label;
    });
    
    [self.thumbnailView addSubview:self.thumbnailScoreView];
    [self.thumbnailView addSubview:self.thumbnailHomeName];
    [self.thumbnailView addSubview:self.thumbnailHomeScore];
    [self.thumbnailView addSubview:self.thumbnailAwayName];
    [self.thumbnailView addSubview:self.thumbnailAwayScore];
    [self.thumbnailView addSubview:thumbnailScoreDivLabel];
    [self.thumbnailView addSubview:self.thumbnailOngoingLabel];
    
    [self.thumbnailScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.thumbnailView);
        make.top.equalTo(self.thumbnailView);
        make.height.equalTo(@42);
    }];
    [self.thumbnailHomeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.thumbnailScoreView.mas_left).offset(-15);
        make.centerY.equalTo(self.thumbnailView);
    }];
    [self.thumbnailAwayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbnailScoreView.mas_right).offset(15);
        make.centerY.equalTo(self.thumbnailView);
    }];
    
    if (type == GameTypeLcNone) {
        
        [thumbnailScoreDivLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.thumbnailScoreView);
            make.top.equalTo(self.thumbnailScoreView) ;
            make.height.equalTo(@15) ;
        }];
        [self.thumbnailHomeScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumbnailScoreView) ;
            make.height.equalTo(@15) ;
            make.right.equalTo(self.thumbnailScoreView.mas_centerX).offset(-5);
        }];
        [self.thumbnailAwayScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumbnailScoreView) ;
            make.height.equalTo(@15) ;
            make.left.equalTo(self.thumbnailScoreView.mas_centerX).offset(5);
        }];

        
        [self.thumbnailView addSubview:self.thumbnailPointLabel];
        [self.thumbnailPointLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(thumbnailScoreDivLabel.mas_bottom).offset(-2);
            make.centerX.equalTo(self.thumbnailScoreView);
            make.height.equalTo(@10);
//            make.width.equalTo(@50);
        }];
        [self.thumbnailOngoingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.self.thumbnailPointLabel.mas_bottom).offset(2);
            make.centerX.equalTo(self.thumbnailScoreView);
            make.height.equalTo(@13);
            make.width.equalTo(@50);
        }];
    }else{
        
        [thumbnailScoreDivLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.thumbnailScoreView);
            make.bottom.equalTo(self.thumbnailScoreView.mas_centerY).offset(-1);
        }];
        [self.thumbnailHomeScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.thumbnailScoreView.mas_centerY);
            make.right.equalTo(self.thumbnailScoreView.mas_centerX).offset(-5);
        }];
        [self.thumbnailAwayScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.thumbnailScoreView.mas_centerY);
            make.left.equalTo(self.thumbnailScoreView.mas_centerX).offset(5);
        }];

        
        [self.thumbnailOngoingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumbnailScoreView.mas_centerY);
            make.centerX.equalTo(self.thumbnailScoreView);
            make.height.equalTo(@13);
            make.width.equalTo(@50);
        }];
    }
    
}

- (NSArray *)interactiveSubviewsInStretchableHeaderView:(AXStretchableHeaderView *)stretchableHeaderView {
    return nil;
}

- (void)pvt_Notify:(NSNotification *)notify {
        string competition, homeImage, awayImage, homeName, awayName, homeRank, awayRank, startTime,halfStartTime;
    int matchStatusId=0, homeScore=0, awayScore=0, homeHalfScore=0, awayHalfScore=0,onTime=0;
  /*  *  对阵基本信息
    *
    *  @param homeImage     [out]主队队标  e.g. "http://cdn.dacai.cn/footballimages/TeamImg/551/Team.gif"
    *  @param awayImage     [out]客队队标  e.g. "http://cdn.dacai.cn/footballimages/TeamImg/444/Team.gif"
    *  @param homeName      [out]主队对名  e.g. "埃弗顿"
    *  @param awayName      [out]客队队名  e.g. "切尔西"
    *  @param homeRank      [out]主队排名  e.g. "13"
    *  @param awayRank      [out]客队排名  e.g. "3"
    *  @param startTime     [out]比赛开始时间    e.g. "2014-08-31 00:30:00"
    *  @param matchStatusId [out]比赛状态. 0:未开始, 无比分, 11:上半场进行中, 21:上半场结束, 31:下半场进行中, 41:下半场结束, 95:中断, 96:待定, 无比分, 97:夭折, 98:推迟, 无比分, 99:已取消, 无比分
    *  @param homeScore     [out]主队全场得分
    *  @param awayScore     [out]客队全场得分
    *  @param homeHalfScore [out]主队半场得分
    *  @param awayHalfScore [out]客队半场得分
    *
    *  @return <0表示失败, >=0表示成功
    */
    
    NSString* homeImageStr,*awayImageStr ;
    int errorCode = 0 ;
    if (_gameType == GameTypeLcNone) {
       errorCode = _dataCenterBasket->GetMatchInfo(competition, startTime, matchStatusId, onTime, homeName,awayName,homeScore,awayScore, homeRank, awayRank, homeImage, awayImage) ;
        homeImageStr = [NSString stringWithUTF8String:awayImage.c_str()] ;
        awayImageStr = [NSString stringWithUTF8String:homeImage.c_str()] ;
     
    }else{
       errorCode = _dateCenter->GetMatchInfo(homeImage, awayImage, homeName, awayName, homeRank, awayRank, startTime,halfStartTime, matchStatusId, homeScore, awayScore, homeHalfScore, awayHalfScore);
        homeImageStr = [NSString stringWithUTF8String:homeImage.c_str()] ;
        awayImageStr = [NSString stringWithUTF8String:awayImage.c_str()] ;
    }
    
    ///得分
    NSString *homeScoreStr , *awayScoreStr;
  
    if (errorCode <0) {
       homeScoreStr =@"--" ;
        awayScoreStr = @"--" ;
    }else{
        homeScoreStr =[NSString stringWithFormat:@"%d",homeScore] ;
        awayScoreStr = [NSString stringWithFormat:@"%d",awayScore] ;

    }
    
   
    NSDate *startDate = [NSDate dp_dateFromString:[NSString stringWithUTF8String:startTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    NSDate *halfStatDate = [NSDate dp_dateFromString:[NSString stringWithUTF8String:halfStartTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    
    ///队名
    NSString*homeNameStr = [NSString stringWithUTF8String:homeName.c_str()];
    NSString* awayNameStr = [NSString stringWithUTF8String:awayName.c_str()];
    if ([g_homeName isEqualToString:@""]||[g_awayName isEqualToString:@""]) {
        g_homeName = homeNameStr ;
        g_awayName = awayNameStr ;
    }
    
    ///排名
    NSString* homeRankStr = homeRank.length() == 0 ? @"" : [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeRank.c_str()]];
    NSString* awayRankStr = homeRank.length() == 0 ? @"" : [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayRank.c_str()]];
    
    
    
    self.startTimeLabel.text = [[startDate dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm] stringByAppendingString:@"开赛"];
    
    if(_gameType == GameTypeLcNone){
        
        self.homeAddLabel.text=awayRankStr ;// @"[东17]" ;
        self.awayAddLabel.text =homeRankStr ;// @"[西11]" ;
                
        
        NSString* pointNumStr =  @" " ;
        NSString* matchStatueStr= [NSString stringWithFormat:@"%d:%d",onTime/60,onTime%60];///开赛状态
        NSRange range,range2 =NSMakeRange(0, 0);
        switch (matchStatusId) {
            case 0:{
                matchStatueStr = @"未开始";
                homeScoreStr = @"--" ;
                awayScoreStr = @"--" ;
                pointNumStr = @" " ;
                range =NSMakeRange(0, 0) ;
            }
                break;
            case 1:{
//                matchStatueStr = @"第一节" ;
                pointNumStr =  @"●●●●" ;
                range = NSMakeRange(0, 1) ;
            }
                break ;
            case 2:{
//                matchStatueStr = @"第二节" ;
                pointNumStr =  @"●●●●" ;
                range = NSMakeRange(0, 2) ;
            }
                break ;
            case 3:{
//                matchStatueStr = @"第三节" ;
                pointNumStr =  @"●●●●" ;
                range = NSMakeRange(0, 3) ;
            }
                break ;
            case 4:{
//                matchStatueStr = @"第四节" ;
                pointNumStr =  @"●●●●" ;
                range = NSMakeRange(0, 4) ;
            }
                break ;
            case 5:{
                matchStatueStr = @"加时赛" ;
                range = NSMakeRange(0, 4) ;
                range2= NSMakeRange(4, 1) ;
                pointNumStr = @"●●●●●" ;

            }
                break ;
            case 9:{
                matchStatueStr = @"已结束" ;//@"比赛结束(完场)" ;
                pointNumStr =  @" " ;
                range = NSMakeRange(0, 0) ;
            }
                break ;
            case 11:{
                matchStatueStr =@"已结束" ;// @"包含加时的完场比赛" ;
                pointNumStr =  @" " ;
                range = NSMakeRange(0, 0) ;
            }
                break ;
            case -1:{
                matchStatueStr = @"第一节休息" ;
                pointNumStr =  @"●●●●" ;
                range = NSMakeRange(0, 1) ;
            }
                break ;
            case -2:{
                matchStatueStr = @"中场休息" ;
                pointNumStr =  @"●●●●" ;
                range = NSMakeRange(0, 2) ;
            }
                break ;
            case -3:{
                matchStatueStr = @"第三节休息" ;
                pointNumStr =  @"●●●●" ;
                range = NSMakeRange(0, 3) ;
            }
                break ;
            case -4:{
                matchStatueStr = @"第四节休息" ;
                pointNumStr =  @"●●●●●" ;
                range = NSMakeRange(0, 4) ;
                range2= NSMakeRange(4, 1) ;

            }
                break ;
                
            default:{
                range = NSMakeRange(0, 0) ;
                range2= NSMakeRange(0, 0) ;
            }
                break;
        }
        self.ongoingLabel.text = matchStatueStr ;
        
        NSMutableAttributedString* atributeStr = [[NSMutableAttributedString alloc]initWithString:pointNumStr];
        [atributeStr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0x3DAE25) range:range2];
        [atributeStr addAttribute:NSForegroundColorAttributeName value:(id)[UIColor dp_flatRedColor] range:range];
     
        self.pointLabel.attributedText = atributeStr ;
        self.thumbnailPointLabel.attributedText = self.pointLabel.attributedText ;

        self.homeScoreLabel.text = awayScoreStr ;
        self.awayScoreLabel.text = homeScoreStr ;
        
        
        self.homeNameLabel.htmlText =[NSString stringWithFormat:@"<font size = 9 color=\"#F9F5F5\">(客)</font><font size =14 color=\"#F9F5F5\">%@</font>",awayNameStr] ;
        self.awayNameLabel.htmlText = [NSString stringWithFormat:@"<font size =14 color=\"#F9F5F5\">%@</font><font size = 9 color=\"#F9F5F5\">(主)</font>",homeNameStr] ;

        self.thumbnailHomeName.htmlText = [NSString stringWithFormat:@"<font size = 11 color=\"#F9F5F5\">(客)</font><font size =17 color=\"#F9F5F5\">%@</font><font size = 11 color=\"#F9F5F5\">%@</font>",awayNameStr,awayRankStr] ;
        self.thumbnailAwayName.htmlText =[NSString stringWithFormat:@"<font size = 11 color=\"#F9F5F5\">%@</font><font size =17 color=\"#F9F5F5\">%@</font><font size = 11 color=\"#F9F5F5\">(主)</font>",homeRankStr,homeNameStr] ;

    }else{
        
        // 0:未开始, 无比分, 11:上半场进行中, 21:上半场结束, 31:下半场进行中, 41:下半场结束, 95:中断, 96:待定, 无比分, 97:腰斩, 98:推迟, 无比分, 99:已取消, 无比分

        switch (matchStatusId) {
            case 11: {
                self.homeScoreLabel.text = homeScoreStr ;//[NSString stringWithFormat:@"%d", homeScore];
                self.awayScoreLabel.text =awayScoreStr ;// [NSString stringWithFormat:@"%d", awayScore];
                NSInteger minitue = [[NSDate dp_date] timeIntervalSinceDate:startDate] / 60;
                self.ongoingLabel.text = minitue > 45 ? @"45+'" : [NSString stringWithFormat:@"%d'", minitue];
            }
                break;
            case 31: {
                self.homeScoreLabel.text =homeScoreStr ;// [NSString stringWithFormat:@"%d", homeScore];
                self.awayScoreLabel.text = awayScoreStr ;// [NSString stringWithFormat:@"%d", awayScore];
                NSInteger minitue = [[NSDate dp_date] timeIntervalSinceDate:halfStatDate] / 60+45;
                self.ongoingLabel.text = minitue > 90 ? @"90+'" : [NSString stringWithFormat:@"%d'", minitue];
            }
                break;
            case 0: case 96: case 98: case 99: {
                self.homeScoreLabel.text = @"--";
                self.awayScoreLabel.text = @"--";
                const NSDictionary *statusMapping = @{ @0:@"未开始", @96:@"待定", @98:@"推迟", @99:@"已取消" };
                self.ongoingLabel.text = statusMapping[@(matchStatusId)];
            }
                break;
            case 21: case 41: case 95: case 97: {
                self.homeScoreLabel.text =  homeScoreStr ;//[NSString stringWithFormat:@"%d", homeScore];
                self.awayScoreLabel.text = awayScoreStr ;// [NSString stringWithFormat:@"%d", awayScore];
                const NSDictionary *statusMapping = @{ @21:@"中场", @41:@"已结束", @95:@"中断", @97:@"腰斩" };
                self.ongoingLabel.text = statusMapping[@(matchStatusId)];
            }
                break;
            default: {
                self.homeScoreLabel.text = @"--";
                self.awayScoreLabel.text = @"--";
                self.ongoingLabel.text = nil;
            }
                break;
        }

        
        self.homeNameLabel.htmlText = [NSString stringWithFormat:@"<font size = 9 color=\"#F9F5F5\">%@</font><font size =14 color=\"#F9F5F5\">%@</font>",homeRankStr,homeNameStr] ;
        self.thumbnailHomeName.htmlText = [NSString stringWithFormat:@"<font size = 11 color=\"#F9F5F5\">%@</font><font size =17 color=\"#F9F5F5\">%@</font>",homeRankStr,homeNameStr] ;
        self.awayNameLabel.htmlText = [NSString stringWithFormat:@"<font size =14 color=\"#F9F5F5\">%@</font><font size = 9 color=\"#F9F5F5\">%@</font>",awayNameStr,awayRankStr ] ;
        self.thumbnailAwayName.htmlText =[NSString stringWithFormat:@"<font size =17 color=\"#F9F5F5\">%@</font><font size = 11 color=\"#F9F5F5\">%@</font>",awayNameStr,awayRankStr ] ;

    }
    self.thumbnailHomeScore.text = self.homeScoreLabel.text;
    self.thumbnailAwayScore.text = self.awayScoreLabel.text;
    self.thumbnailOngoingLabel.text = self.ongoingLabel.text;
    
    __weak UIImageView *homeLogoView = self.homeLogoView;
    __weak UIImageView *awayLogoView = self.awayLogoView;
    
    void(^setImageBlock)(UIImageView *imageView, UIImage *image)  = ^(UIImageView *imageView, UIImage *image) {
        if (image.dp_width > kDataCenterLogoImageLength || image.dp_height > kDataCenterLogoImageLength) {
            if (image.dp_width > image.dp_height) {
                image = [image dp_resizedImageToSize:CGSizeMake(kDataCenterLogoImageLength, image.dp_height / image.dp_width * kDataCenterLogoImageLength)];
            } else {
                image = [image dp_resizedImageToSize:CGSizeMake(image.dp_width / image.dp_height * kDataCenterLogoImageLength, kDataCenterLogoImageLength)];
            }
        }
        
        imageView.image = image;
    };
    
    
    [self.homeLogoView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:homeImageStr]] placeholderImage:dp_SportLotteryImage(@"default.png") success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        setImageBlock(homeLogoView, image);
    } failure:nil] ;
    
    [self.awayLogoView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:awayImageStr]] placeholderImage:dp_SportLotteryImage(@"default.png") success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        setImageBlock(awayLogoView, image);
    } failure:nil];
    
//    [UIImageView setSharedImageCache:<#(id<AFImageCache>)#>]
}

@end
