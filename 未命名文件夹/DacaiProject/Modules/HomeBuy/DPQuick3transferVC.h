//
//  DPQuick3transferVC.h
//  DacaiProject
//
//  Created by sxf on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalTransferBaseVC.h"
#import "DPDigitalTicketsBaseVC.h"
#import "DPDigitalBuyCell.h"
#import "DPRedPacketViewController.h"
#import <MSWeakTimer/MSWeakTimer.h>
@interface DPQuick3transferVC : UIViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    digitalBuyDelegate,
    UIGestureRecognizerDelegate,
    DPRedPacketViewControllerDelegate
>


@property (nonatomic, strong, readonly) UITableView *issureTableView;
@property (nonatomic, strong) TTTAttributedLabel *bottomLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextField *addTimesTextField, *addIssueTextField; //倍数，期数
@property (nonatomic, strong) UIView *mulAndIssueView;                            //倍数和期数View
@property (nonatomic, strong) UIView *optionView;
@property (nonatomic, strong) UIView *protocolView;      //协议view
@property (nonatomic, assign) BOOL afterWinStop;         //是否中奖后停止
@property (nonatomic, strong) UIImageView *addyizhuView; //增加一注View;

@property (nonatomic, assign) NSInteger timeSpace;  // 倒计时剩余时间
@property (nonatomic, strong, readonly) MSWeakTimer *timer;
@property (nonatomic, assign) int digitalType;           // 大彩种类型


- (void)loadInstance;
- (void)sendRefresh;
- (void)recvRefresh:(BOOL)fromAppdelegate;
- (BOOL)isBuyController:(UIViewController *)viewController;

@end
