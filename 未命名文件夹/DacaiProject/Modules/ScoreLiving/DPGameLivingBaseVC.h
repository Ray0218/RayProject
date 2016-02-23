//
//  DPGameLivingBaseVC.h
//  DacaiProject
//
//  Created by sxf on 14/12/5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPCollapseTableView.h"
#import "DPGameLiveJczqCell.h"
#import "DPGameLiveLcCell.h"
#import "../../Common/View/DPNavigationTitleButton.h"
#import "../../Common/View/DPNavigationMenu.h"
#import "DPSportFilterView.h"
#import "DPIssueSelectedView.h"
#import "FrameWork.h"
#import "ModuleProtocol.h"
#import "AFImageDiskCache.h"
#import "DPGameLiveEventView.h"
#import <MSWeakTimer/MSWeakTimer.h>
#define tabbuttonTag 10000
#define TitleMenuContentTag 9001
@interface DPGameLivingBaseVC : UIViewController
<
DPCollapseTableViewDelegate,
DPCollapseTableViewDataSource,
UIScrollViewDelegate,
 ModuleNotify,
DPGameLiveJcCellDelegate,
DPGameLiveLcCellDelegate,
DPSportFilterViewDelegate,
DPIssueSelectedDelegate,
UIGestureRecognizerDelegate
>
{
  NSInteger _tabSelectedIndex;//比赛选中的
    NSInteger _gameSelectedIndex;//彩种选中的
    NSInteger _issueSelectedIndex;//期号或者日期选中的
    CScoreLive *_scoreInstance;
    DPGameLiveEventView *_eventView;
    MSWeakTimer *_timer;//倒计时
//    UIImageView         *_noDataImgView;
   
}
//@property (nonatomic, strong, readonly) UIImageView *noDataImgView;//当前没数据
@property (nonatomic, strong, readonly) UIView *tabBarView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property(nonatomic,strong,readonly)DPCollapseTableView *livingTable;//比赛中
@property(nonatomic,strong,readonly)DPCollapseTableView *overTable;//已结束
@property(nonatomic,strong,readonly)DPCollapseTableView *nostartTable;//未开始
@property(nonatomic,strong,readonly)DPCollapseTableView *focusTable;//关注
@property(nonatomic,strong,readonly)UILabel *guanzhuLabel;
@property(nonatomic,assign)NSInteger guanzhuTotal;
@property (nonatomic, strong, readonly) DPNavigationMenu *titleMenu;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;//标题
@property(nonatomic,strong,readonly) UIButton *issueButton;//期号
@property(nonatomic,strong)UIButton *filterButton;//筛选

@property (nonatomic, strong, readonly) NSOperationQueue *imageQueue;
@property (nonatomic, strong, readonly) AFImageDiskCache *imageCache;

@property(nonatomic,strong,readonly)DPGameLiveEventView *eventView;//事件视图
@property (nonatomic, strong) MSWeakTimer *timer;

- (DPCollapseTableView *)selectedTableView:(NSInteger)index;
@end
