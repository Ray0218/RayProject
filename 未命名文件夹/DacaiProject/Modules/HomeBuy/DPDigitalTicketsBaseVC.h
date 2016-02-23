//
//  DPDigitalTicketsBaseVC.h
//  DacaiProject
//
//  Created by sxf on 14-7-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleProtocol.h"
#import "FrameWork.h"
#import "DPDigitalBallCell.h"
#import "DPNavigationMenu.h"
#import "DPNavigationTitleButton.h"
#import"DPHistoryTendencyCell.h"
#import <SevenSwitch/SevenSwitch.h>
#import<TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPToast.h"
#import <MSWeakTimer/MSWeakTimer.h>
#import <AudioToolbox/AudioToolbox.h>
#define ballSpace    15

#define SelectTypeButtonTag  1200
typedef enum _DigitalTicketsBuyType
{
    _DirectBuyType = 1,           //直选
    _GroupThreeBuyType  = 2,           //组选3
    _GroupSixBuyType  = 3,           //组选6
    
    _DoubleColorBallNormalType,// 16
    _DoubleColorBallDanType,// 17
    _BigHappyBetBuyNormalType,
    _BigHappyBetBuyDanType,
    _SevenHappyLotteryBuyNormalType,
    _SevenHappyLotteryBuyDanType,
    
    
    
}DigitalTicketsBuyType;

//  用户选择偏好
static BOOL preferSwitchOn = YES;

@interface DPDigitalTicketsBaseVC : UIViewController<UITableViewDataSource, UITableViewDelegate, ModuleNotify,digitalBallDelegate,UIScrollViewDelegate,DPNavigationMenuDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, assign) int buyType;           //玩法id
@property (nonatomic, strong) NSDictionary *ballDic; //UI表的布局
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) UILabel *zhushuLabel;  //注数
@property (nonatomic, assign) int lotteryType;       //彩种id
@property (nonatomic, strong) NSDictionary *cellDic; //保存单元格
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIView *selctTypeView;
@property (nonatomic, assign) int indexpathRow;
@property (nonatomic, strong, readonly) DPNavigationMenu *menu; //标题框
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, assign) NSInteger gameIndex;                            //小彩种tag
@property (nonatomic, strong) TTTAttributedLabel *deadlineTimeLab, *bonusLab; //截止时间，奖池
@property (nonatomic, strong) UIButton *digitaRandomBtn;                      //随机按钮
@property (nonatomic, assign) BOOL isOpenSwitch;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NSMutableArray *historyArray; //历史走势数据
@property (nonatomic, strong, readonly) NSLayoutConstraint *tableConstraint;
@property (nonatomic, assign) BOOL showHistory;           //历史记录
@property (nonatomic, strong) UIButton *digitalRandomBtn; //摇一摇按钮


//自选，修改
-(void)jumpToSelectPage:(int)row  gameType:(int)gameType;
- (float)cellHeightForIndex:(int)ballTotal  indexPath:(NSIndexPath *)indexPath;
//小彩种切换
- (void)reloadSelectTableView:(int)titleIndex;
//随机摇一摇
-(void)digitalDataRandom;
-(void)partRandom:(int)count    total:(int)total target2:(int *)target;

//判断当前选中几个球
-(int)ballSelectedTotal:(int[])num  danwei:(int)danwei total:(int)total;
//更新网络请求数据
-(void)updataForMiss;
//计算时间差
- (NSTimeInterval)getDateFrom:(NSString *)fromDate toDate:(NSString *)toDate;
- (void)startTimer;
//得到滚存钱数
-(NSString*)logogramForMoney:(int)money;
//清空数据
-(void)clearAllSelectedData;
//刷新数据
-(void)upDataRequest;


- (void)refreshNotify;
@property (nonatomic, assign) NSInteger timeSpace;          //当前投注期的截止时间（秒）

@end
