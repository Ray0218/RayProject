//
//  DPJcdgTableViewCell.h
//  DacaiProject
//
//  Created by jacknathan on 14-11-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPKeyboardCenter.h"
//// 顶部的广告
//@interface DPJcdgHeaderCell : UITableViewCell <NSCopying>
//@end

// 滚动的球队(sectionHeader)
@protocol DPJcdgTeamsViewDelegate;
@interface DPJcdgTeamsView : UIView
@property (nonatomic, strong, readonly)UIScrollView *scrollView; // 滚动视图
@property (nonatomic, weak) id <DPJcdgTeamsViewDelegate> delegate;
@property (nonatomic, assign) int gameCount; // 比赛场次
- (void)setSingleTeamWithIndex:(int)index homeName:(NSString *)homeName awayName:(NSString *)awayName
                      homeRank:(NSString *)homeRank awayRank:(NSString *)awayRank
                       homeImg:(NSString *)homeImg awayImg:(NSString *)awayImg
                 compitionName:(NSString *)compName endTime:(NSString *)endTime
                        sugest:(NSString *)sugest;
@end

@protocol DPJcdgTeamsViewDelegate <NSObject>
- (void)gamePageChangeFromPage:(int)oldPage toNewPage:(int)newPage;
@end

// 玩法cell基类
@protocol DPJcdgGameBasicCellDelegate;
@interface DPJcdgGameTypeBasicCell : UITableViewCell
@property (nonatomic, strong, readonly)UILabel *gameTypeLabel; // 玩法
@property (nonatomic, weak) id <DPJcdgGameBasicCellDelegate> delegate;
@end

@protocol DPJcdgGameBasicCellDelegate <NSObject>
//- (void)dpJcdgBasicCellPullDown:(DPJcdgGameTypeBasicCell *)cell;
//- (void)dpJcdgBasicCellPullUp:(DPJcdgGameTypeBasicCell *)cell;
- (void)clickButtonWithCell:(DPJcdgGameTypeBasicCell *)cell gameType:(int)gameType index:(int)index isSelected:(BOOL)isSelected closeExpand:(BOOL)closeExpand;
- (void)dpjcdgInfoButtonClick:(DPJcdgGameTypeBasicCell *)cell;
@end


// 让球胜平负
typedef enum {
    KSpfTypeRqspf = 0,
    KSpfTypeSpf,
} KSpfDetailType;

@interface DPjcdgTypeRqspfCell : DPJcdgGameTypeBasicCell
@property (nonatomic, strong) NSArray *percents; // 百分比
@property (nonatomic, strong) NSArray *teamNames; // 队伍名称
//@property (nonatomic, assign) int defaultIndex; // 默认选中按钮
@property (nonatomic, assign) KSpfDetailType detailType; // 让球胜平负和胜平负区分
@property (nonatomic, assign) NSArray *defaultOption;
@end

// 总进球
@interface DPjcdgAllgoalCell : DPJcdgGameTypeBasicCell
@property (nonatomic, strong) NSArray *sp_Numbers; // sp值
@property (nonatomic, strong) NSArray *defaultOption; // 选中状态
@end

// 猜赢球
@interface dpJcdgGuessWinCell : DPJcdgGameTypeBasicCell
@property (nonatomic, strong, readonly)UILabel *leftTeamNameLabel;
@property (nonatomic, strong, readonly)UILabel *rightTeamNameLabel;
@property (nonatomic, strong) NSArray *defaultOption; // 选中状态
@end

// 下拉购买cell
@protocol DPJcdgPullCellDelegate;
@interface DPJcdgPullCell : UITableViewCell
@property (nonatomic, weak) id <DPJcdgPullCellDelegate> delegate;
@property (nonatomic, assign) float miniBonus; // 最小奖金
@property (nonatomic, assign) float maxBonus; // 最大奖金
@property (nonatomic, assign) GameTypeId gameType; // 玩法类型
@property (nonatomic, assign) int zhuShu; // 注数
@property (nonatomic, strong, readonly) UITextField *textField; // 倍数
@property (nonatomic, strong, readonly) UIView *commitView;  // 提交视图
- (void)dp_reloadMoneyWithTimeTex:(NSString *)timesText gameIndex:(int)gameIndex;
@end

@protocol DPJcdgPullCellDelegate <NSObject>
- (void)pullCellCommit:(DPJcdgPullCell *)cell times:(int)times;
- (void)pullCellBonusBetterClick:(DPJcdgPullCell *)cell times:(NSString *)times;
- (void)pullCell:(DPJcdgPullCell *)cell endEditingWithText:(NSString *)text;
- (void)pullCell:(DPJcdgPullCell *)cell keyBoardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd;
@end
// 没有数据时的图片cell
@interface DPJcdgNoDateImgCell : UITableViewCell
@end

// 没有数据时的列表cell
@protocol DPJcdgNoDataCelldelegate;
@interface DPJcdgNoDataCell : UITableViewCell
@property (nonatomic, weak) id <DPJcdgNoDataCelldelegate> delegate;
@property (nonatomic, strong, readonly)UILabel *leftTitleLabel;
@property (nonatomic, strong, readonly)UILabel *rightTitleLabel;
@end

@protocol DPJcdgNoDataCelldelegate <NSObject>
- (void)noDataMoreGameIndex:(int)gameIndex;
@end

// 玩法说明
@interface DPJcdgWarnView : UIView
@property (nonatomic, strong, readonly)UILabel *gameTypeLabel;
@property (nonatomic, strong) NSString *titleText;
@end