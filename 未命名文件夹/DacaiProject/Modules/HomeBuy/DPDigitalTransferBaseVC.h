//
//  DPDigitalTransferBaseVC.h
//  DacaiProject
//
//  Created by sxf on 14-7-7.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPDigitalTicketsBaseVC.h"
#import "DPDigitalBuyCell.h"
#import "DPToast.h"
#import "DPRedPacketViewController.h"
#import "DPAccountViewControllers.h"

#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAppParser.h"
#import <MSWeakTimer/MSWeakTimer.h>

@interface DPDigitalTransferBaseVC : UIViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    digitalBuyDelegate,
    UIGestureRecognizerDelegate,
    DPRedPacketViewControllerDelegate,
    ModuleNotify
> {
    NSMutableSet *_collapseSections;
}

@property (nonatomic, strong, readonly) UITableView *issureTableView;
@property (nonatomic, strong) TTTAttributedLabel *bottomLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextField *addTimesTextField, *addIssueTextField; // 倍数，期数
@property (nonatomic, strong) UIView *mulAndIssueView;                            // 倍数和期数View
@property (nonatomic, strong) UIView *optionView;
@property (nonatomic, strong) UIView *protocolView;      // 协议view
@property (nonatomic, assign) BOOL afterWinStop;         // 是否中奖后停止
@property (nonatomic, assign) BOOL addTouzhu;            // 是否增加一注
@property (nonatomic, strong) UIImageView *addyizhuView; // 增加一注View;
@property (nonatomic, assign) int digitalType;           // 大彩种类型

@property (nonatomic, strong) UIButton *introduceButton; // 说明按钮
@property (nonatomic, strong) UIButton *addButton;       // 追加按钮

@property (nonatomic, assign) NSInteger timeSpace;  // 倒计时剩余时间
@property (nonatomic, strong, readonly) MSWeakTimer *timer;
- (void)alertGameName;
- (void)touzhuInfotableCell:(DPDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath;
//删除某一行数据
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell;
//自选一注
- (void)addOneZhu;
//付款
- (int)toGoPayMoney;
//产生随机一注
- (void)digitalRandomData;
- (void)partRandom:(int)count total:(int)total target2:(int *)target;
//得到当前单元格的高度
- (float)gainOneRowHight:(NSIndexPath *)indexPath;
//得到一期一倍的钱数
- (int)getPayTotalMoney;
//得到下单地址
- (NSString *)orderInfoUrl;
//合买代购
- (void)togetherType;
//设置倍数
- (void)OrderInfoMultiple;

- (void)onSmartPlan;

- (void)loadInstance;
- (void)sendRefresh;
- (void)recvRefresh:(BOOL)fromAppdelegate;
- (BOOL)isBuyController:(UIViewController *)viewController;

@end