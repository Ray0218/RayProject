//
//  DPButtonCollectionCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

// 快三 玩法
typedef enum
{
    Quick3GameTypeTotal = 0,        // 和值
    Quick3GameTypeSame2,            // 二同号 (二同号单选)      eg: 112         --对子单选
    Quick3GameTypeSame2All,         // 二同号 (二同号通选)      eg: 11* - 66*   --对子复选
    Quick3GameTypeSame3,            // 三同号 (三同号单选)      eg: 222         --豹子单选
    Quick3GameTypeSame3All,         // 三同号 (三同号通选)      eg: 111 - 666   --豹子通选
    Quick3GameTypeDifferent3,       // 三不同 (三不同号单选)     eg: 135
    Quick3GameTypeDifferent3Flow,   // 三不同 (三连号单选)      eg: 234 包含在 Quick3GameTypeDifferent3中，接口同
    Quick3GameTypeDifferent3All,    // 三不同 (三连号通选)      eg: 123 - 456   --顺子通选
    Quick3GameTypeDifferent2,       // 二不同                  eg: 26
} Quick3GameType;

// 筹码类型
typedef enum
{
    CounterNumberType2 = 0,         // 2元
    CounterNumberType10,            // 10元
    CounterNumberType50,            // 50元
    CounterNumberType100,           // 100元
    CounterNumberTypeNone,          // 未选择
} CounterNumberType;

// 快乐扑克3 玩法
typedef enum
{
    Poker3GameTypeLeopard = 1000,       // 豹子单选 eg: JJJ
    Poker3GameTypeLeopardAll,           // 豹子包选 eg: AAA - KKK
    Poker3GameTypeFlow,                 // 顺子单选
    Poker3GameTypeFlowAll,              // 顺子包选
    Poker3GameTypeStraightFlush,        // 同花顺单选
    Poker3GameTypeStraightFlushAll,     // 同花顺包选
    Poker3GameTypeDouble,               // 对子单选
    Poker3GameTypeDoubleAll,            // 对子包选
    Poker3GameTypeSame,                 // 同花单选
    Poker3GameTypeSameAll,              // 同花包选
    Poker3GameTypeSelect1,              // 任选一
    Poker3GameTypeSelect2,              // 任选二
    Poker3GameTypeSelect3,              // 任选三
    Poker3GameTypeSelect4,              // 任选四
    Poker3GameTypeSelect5,              // 任选五
    Poker3GameTypeSelect6,              // 任选六
} Poker3GameType;
@protocol DPPk3ButtonDelegate;
@class DPPk3Note;

@interface DPButtonCollectionCell : UICollectionViewCell
@property (nonatomic, assign) id<DPPk3ButtonDelegate> delegate;
@property (nonatomic, strong) DPPk3Note *curQuick3Note;
@property(nonatomic,strong)UILabel *qk3TopLable;
@property(nonatomic,strong)UILabel *qk3MidLable;
@property(nonatomic,strong)UILabel *qk3BottomLable;
@property (nonatomic, strong) UILabel *missLabel;


-(void)creatViewWithNumber:(NSString *)number amount:(int)amount showAmount:(BOOL)showAmount hasMissString:(BOOL)hasMissString quick3GameDetailType:(int)pQuick3GameDetailType withNaxMiss:(int)maxMis;
//- (void)addCounter:(UIButton *)pBtn counterNumberType:(CounterNumberType)pCounterNumberType centerPoint:(CGPoint)pPoint;
- (void)clearCounter;
- (int)countMoney;
- (int)countBreakeven:(int)pTotalMoney;
- (void)setMissText:(NSString *)pText;
-(void)borderBGColorSelected:(BOOL)isSelected;
-(void)bulidLayOut;
@end
@protocol DPPk3ButtonDelegate <NSObject>

- (void)quick3Button:(DPButtonCollectionCell *)quick3Button touchPoint:(CGPoint)point;
@end

@interface DPPk3Note : NSObject
<
NSCopying
>

@property (nonatomic, assign) int quick3GameDetailType;
@property (nonatomic, assign) int buttonTag;
@property (nonatomic, strong) NSString *betNumber;
@property (nonatomic, assign) int amount;
@property (nonatomic, assign) BOOL showAmount;
@property (nonatomic, assign) int miss;
@property (nonatomic, assign) BOOL hasMissString;
@property (nonatomic, strong) NSMutableArray *jetonArray;  // 筹码数字 存储5个int值， 分别代表 筹码2， 筹码10，筹码20，筹码50，筹码100的个数，默认全是0
@property (nonatomic, strong) NSString *gameName;       // 记录选中时候 期数， 如果为空， 默认最新一期

- (int)getTotalMoney;

@end
