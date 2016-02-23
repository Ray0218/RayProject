//
//  DPPoker3transferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPPoker3transferVC.h"
#import "DPPksBuyViewController.h"
#import"DPDigitalIssueControl.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "DPSmartFollowVC.h"
#import "DPWebViewController.h"
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAppParser.h"
#import <MSWeakTimer/MSWeakTimer.h>
#import "DPDigitalCommon.h"
#import "NotifyType.h"
#import "DPNotifyCapturer.h"
#import "DPSmartPlanSetView.h"
#import "DPVerifyUtilities.h"
// 豹子投注数据
static NSString *counterNumberBaozi[13] = {@"AAA", @"222", @"333", @"444", @"555", @"666", @"777", @"888", @"999", @"101010", @"JJJ", @"QQQ", @"KKK"};
//对子
static NSString *counterNumberDuizi[13] = {@"AA", @"22", @"33", @"44", @"55", @"66", @"77", @"88", @"99", @"1010", @"JJ", @"QQ",@"KK"};
//同花 /同花顺
static NSString *counterNumbertonghua[4] ={@"黑桃",@"红桃",@"梅花",@"方块"};
//顺子
static NSString *counterNumberShunzi[12] = {@"A23", @"234", @"345", @"456", @"567", @"678", @"789", @"8910", @"910J", @"10jQ", @"JQK", @"QKA"};
//任选
static NSString *counterNumberrenxuan[13] = {@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q",@"K"};
//包选
static NSString *counterNumberbaoxuan[5] = {@"对子包选", @"豹子包选", @"同花包选", @"顺子包选", @"同花顺包选"};

@interface DPPoker3transferVC () {
@private
    CPokerThree *_CPTInstance;
    BOOL _isSelectedPro; //是否选择协议
    UIView *_coverView;
    BOOL _dismissing;
    MSWeakTimer *_timer;
}
@property (nonatomic, strong, readonly) UIView *coverView;
@property (nonatomic, strong, readonly) MSWeakTimer *timer;
@property (nonatomic, assign) NSInteger timeSpace;

@end

@implementation DPPoker3transferVC
@synthesize issureTableView = _issureTableView;
@synthesize bottomView=_bottomView;
@synthesize bottomLabel=_bottomLabel;
@synthesize optionView=_optionView;
@synthesize addyizhuView=_addyizhuView;
@synthesize mulAndIssueView=_mulAndIssueView;
@dynamic timeSpace;

- (void)dealloc {
    DPLog(@"dealloc");
    _CPTInstance->ClearTarget();
    _CPTInstance->ClearGameInfo();
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ApplicationDidBecomeActive object:nil];

}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"快乐扑克3投注";
        _CPTInstance = CFrameWork::GetInstance()->GetPokerThree();
        _CPTInstance->SetDelegate(self);
        _isSelectedPro=YES;
        
        [[DPNotifyCapturer defaultCapturer] setDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pvt_needRefresh) name:dp_ApplicationDidBecomeActive object:nil];

        
        g_sdpksLastGameName = 0;
        [self setTimeSpace:0];
        [self.timer schedule];
        [self.timer fire];
    }
    return self;
}
-(void)pvt_needRefresh{
    _CPTInstance->Refresh();

}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_sdpksTimeSpace = timeSpace;
}

- (NSInteger)timeSpace {
    return g_sdpksTimeSpace;
}

- (MSWeakTimer *)timer {
    if (_timer == nil) {
        _timer = [[MSWeakTimer alloc] initWithTimeInterval:1 target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    }
    return _timer;
}


- (void)pvt_reloadTimer {
    DPLog(@"当前倒计时: %d", self.timeSpace);
    
    if (self.timeSpace > 0) {
        
        self.timeSpace--;
    } else if (self.timeSpace < 0) {
        
        self.timeSpace++;
    } else if (self.timeSpace == 0) {
        [self recvRefresh:NO];
        [self alertGameName];
        [[NSNotificationCenter defaultCenter] postNotificationName:dp_DigitalBetRefreshNofify object:nil];
        
        if (!_CPTInstance->TimeOutLived()) {
            _CPTInstance->Refresh();
        }
        
//        if (self.digitalType != GameTypeJxsyxw) {
//            [self sendRefresh];
//        } else {
//            DPLog(@"GameTypeJxsyxw");
//            
//            [self recvRefresh];
//            [self alertGameName];
//            [[NSNotificationCenter defaultCenter] postNotificationName:dp_DigitalBetRefreshNofify object:nil];
//        }
        
        if (self.timeSpace == 0) {
            self.timeSpace = -60;   // 无数据1分钟后刷新
        }
    }
    
    if (self.navigationController.viewControllers.lastObject != self) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *nextViewController = self.navigationController.viewControllers[index + 1];
        if ([nextViewController isKindOfClass:[DPPksBuyViewController class]]) {
            [nextViewController performSelector:@selector(pvt_reloadTimer) withObject:nil];
        } else if ([nextViewController isKindOfClass:[DPSmartFollowVC class]]) {
            [nextViewController performSelector:@selector(pvt_reloadTimer) withObject:nil];
        }
    }
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName; string endTime;
    if (_CPTInstance->GetInfo(gameName, endTime) >= 0) {
        gameName %= 100;
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        } else {
            self.timeSpace = -60;
        }
    }
}

- (void)alertGameName {
    int lastGameName = 0, currGameName = 0; string drawTime;
    int ret = CFrameWork::GetInstance()->GetPokerThree()->GetGameStatus(currGameName, drawTime);
    if (ret < 0) {
        return;
    }
    if (g_sdpksLastGameName == 0) {
        g_sdpksLastGameName = currGameName;
    }
    if (g_sdpksLastGameName != currGameName) {
        lastGameName = g_sdpksLastGameName;
        g_sdpksLastGameName = currGameName;
        UIViewController *currentController = self.navigationController.viewControllers.lastObject;
        if (!(currentController == self) && // 中转界面
            ![currentController isKindOfClass:[DPPksBuyViewController class]] && // 投注界面
            ![currentController isKindOfClass:[DPSmartFollowVC class]]) {   // 智能追号界面
            return;
        }
        
        DPLog(@"跨期弹框提示");
        NSString *time = [NSDate dp_coverDateString:[NSString stringWithUTF8String:drawTime.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm];
        NSString *msg = [NSString stringWithFormat:@"尊敬的用户, 扑克三第%d期已截止, %d期预售中, 预计开奖时间: %@", lastGameName, currGameName, time];
        //        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [av show];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [av dismissWithClickedButtonIndex:0 animated:YES];
        //        });
        
        
        UIView* smartView = ({
            DPSmartCountSureView * view = [[DPSmartCountSureView alloc]init];
            view.alertText = msg ;
            view ;
        }) ;
        [self.navigationController.view.window addSubview:smartView];
        [smartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (smartView) {
                [smartView removeFromSuperview];
            }
        });
        

//        [[DPToast makeText:msg] show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    if (!_dismissing) {
        [self.navigationController dp_applyGlobalTheme];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    UIColor *tintColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];
    if (IOS_VERSION_7_OR_ABOVE) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self.navigationController.navigationBar setBackgroundImage:dp_NavigationImage(@"pks_bg128.png") forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : tintColor,
                                                                          UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:dp_NavigationImage(@"pks_bg88.png") forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : tintColor,
                                                                          UITextAttributeTextShadowOffset : [NSValue valueWithCGPoint:CGPointZero],
                                                                          UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    }
    _CPTInstance->SetDelegate(self);
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:YES];
    //下拉选一注View隐藏
    self.addyizhuView.hidden = _CPTInstance->GetTargetNum() > 0 ? YES : NO;
    
    __weak DPPoker3transferVC *weakSelf = self;
    
    [self.issureTableView addPullToRefreshWithActionHandler:^{
        [weakSelf digitalRandomData];
        [weakSelf calculateAllZhushuWithZj:YES];
        [weakSelf.issureTableView.pullToRefreshView stopAnimating];
        [weakSelf.issureTableView reloadData];
    }];
    [self.issureTableView.pullToRefreshView setTextColor:UIColorFromRGB(0x80D9FF)];
    [self.issureTableView.pullToRefreshView setArrowColor:UIColorFromRGB(0x80D9FF)];
    [self.issureTableView.pullToRefreshView setActivityIndicatorViewColor:UIColorFromRGB(0x80D9FF)];


    [self.issureTableView.pullToRefreshView setTitle:@"下拉机选   " forState:SVPullToRefreshStateStopped];
    [self.issureTableView.pullToRefreshView setTitle:@"释放机选   " forState:SVPullToRefreshStateTriggered];
    [self.issureTableView.pullToRefreshView setTitle:@"正在机选..." forState:SVPullToRefreshStateLoading];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    [self alertGameName];
}



-(void)viewDidLoad{
    [super viewDidLoad];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    [self buildLayout];
    
}
- (void)buildLayout {
    self.view.backgroundColor=[UIColor clearColor];
    UIImageView *backView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backView.image=dp_PokerThreeImage(@"bg.png");
    [self.view addSubview:backView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"ks_home.png") title:nil tintColor:[UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1] target:self action:@selector(pvt_onBack)];
     self.navigationItem.rightBarButtonItem =[UIBarButtonItem dp_itemWithImage:dp_QuickThreeImage(@"q3transAdd.png") title:@"添加手动" tintColor:[UIColor colorWithRed:0.92 green:0.66 blue:0.23 alpha:1.0] target:self action:@selector(pvt_add)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:nil title:@"添加手动" tintColor:[UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1] target:self action:@selector(pvt_add)];
//    [self.navigationItem dp_setRightItemsWithImagesAndTitle:@[dp_QuickThreeImage(@"q3transAdd.png")] titles:@[@"添加手动"] titleColors:@[[UIColor colorWithRed:0.92 green:0.66 blue:0.23 alpha:1.0]] target:self action:@selector(pvt_add)];
    
    [self.view addSubview:self.issureTableView];
     [self.view addSubview:self.coverView];
    UIView *contentView = self.view;
    
    [contentView addSubview:self.addyizhuView];
    [self.addyizhuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_centerY);
        make.width.equalTo(@154);
        make.height.equalTo(@112);
    }];
    
    //底部view
    [contentView addSubview:self.bottomView];
    [contentView addSubview:self.optionView];
    //投注倍数和期号
    [contentView addSubview:self.mulAndIssueView];
    [self.issureTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.mulAndIssueView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@44);
    }];
    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.height.equalTo(@0);
    }];
    [self.mulAndIssueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.bottom.equalTo(self.optionView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    
   
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.coverView setHidden:YES];
    self.optionView.hidden=YES;
    UITapGestureRecognizer *tagesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate=self;
    [self.view addGestureRecognizer:tagesture];
    [self pvt_buildConfigLayout];
    [self pvt_buildBottomLayout];
    [self pvt_bulidOption];
    
}
- (void)pvt_hiddenCoverView:(BOOL)hidden {
    if (hidden) {
        if (!self.coverView.hidden) {
            self.coverView.alpha = 1;
            [UIView animateWithDuration:0.2 animations:^{
                self.coverView.alpha = 0;
            } completion:^(BOOL finished) {
                self.coverView.hidden = YES;
            }];
        }
    } else {
        if (self.coverView.hidden) {
            self.coverView.alpha = 0;
            self.coverView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.coverView.alpha = 1;
            }];
        }
    }
}
-(void)pvt_buildConfigLayout{
    UIImageView *backView=[[UIImageView alloc]init];
    backView.image=dp_QuickThreeImage(@"q3transferMul.png");
    backView.backgroundColor=[UIColor clearColor];
    [self.mulAndIssueView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *midLine = ({
        [UIView dp_viewWithColor:UIColorFromRGB(0x381509)];
    });
    
    [self.mulAndIssueView addSubview:midLine];
    
    UILabel *label1=[self labelWithText:@"投" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatWhiteColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label1];
    UILabel *label2=[self labelWithText:@"倍" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatWhiteColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label2];
    
    
    UILabel *label3=[self labelWithText:@"追" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatWhiteColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label3];
    UILabel *label4=[self labelWithText:@"期" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatWhiteColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label4];
    
    
    self.addTimesTextField=[[UITextField alloc] init];
    self.addTimesTextField.backgroundColor = [UIColor clearColor];
    self.addTimesTextField.background=dp_QuickThreeImage(@"q3transferMulText.png");
    self.addTimesTextField.textAlignment = NSTextAlignmentCenter;
    self.addTimesTextField.delegate=self;
    self.addTimesTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.addTimesTextField.font = [UIFont boldSystemFontOfSize:14];
    self.addTimesTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.addTimesTextField.textColor = UIColorFromRGB(0xfff659);
    self.addTimesTextField.text=@"1";
    [self.view addSubview:self.addTimesTextField];
    
    self.addIssueTextField=[[UITextField alloc] init];
    self.addIssueTextField.backgroundColor = [UIColor clearColor];
    self.addIssueTextField.background=dp_QuickThreeImage(@"q3transferMulText.png");
    self.addIssueTextField.textAlignment = NSTextAlignmentCenter;
    self.addIssueTextField.delegate=self;
    self.addIssueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.addIssueTextField.font = [UIFont boldSystemFontOfSize:14];
    self.addIssueTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.addIssueTextField.textColor = UIColorFromRGB(0xfff659);
    self.addIssueTextField.text=@"1";
    [self.view addSubview:self.addIssueTextField];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(self.mulAndIssueView).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];
    [self.addTimesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(label1.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.25);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(self.addTimesTextField.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];
    
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView);
        make.bottom.equalTo(self.mulAndIssueView);
        make.centerX.equalTo(self.mulAndIssueView);
        make.width.equalTo(@0.5);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(midLine.mas_right).offset(20);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];
    [self.addIssueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(label3.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.25);
    }];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(self.addIssueTextField.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];
}

-(void)pvt_buildBottomLayout{
    
    UIView * contentView = self.bottomView;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor=UIColorFromRGB(0x4b1d0d);
    [contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIButton *zhinengButton = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    zhinengButton.backgroundColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
    [zhinengButton setTitle:@"智能追号" forState:UIControlStateNormal];
    [zhinengButton setBackgroundImage:dp_QuickThreeImage(@"q3transznzh.png") forState:UIControlStateNormal];
    [zhinengButton setTitleColor:UIColorFromRGB(0x491706) forState:UIControlStateNormal];
    [zhinengButton.titleLabel setFont:[UIFont dp_systemFontOfSize:14.0]];
    
    [confirmButton setBackgroundImage:dp_QuickThreeImage(@"q3transferSure.png") forState:UIControlStateNormal];
    [confirmButton setImage:dp_QuickThreeImage(@"q3transSumit.png") forState:UIControlStateNormal];
    confirmButton.backgroundColor=[UIColor clearColor];
    [zhinengButton addTarget:self action:@selector(pvt_togetherBuy) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(pvt_submitss) forControlEvents:UIControlEventTouchUpInside];
    
    // move to view
    [contentView addSubview:zhinengButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.bottomLabel];
    
    // layout
    [zhinengButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
        make.left.equalTo(contentView).offset(3);
        make.width.equalTo(@70);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zhinengButton);
        make.bottom.equalTo(zhinengButton);
        make.width.equalTo(@70);
        make.right.equalTo(contentView).offset(-3);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhinengButton.mas_right).offset(5);
        make.right.equalTo(confirmButton.mas_left).offset(-5);
        make.centerY.equalTo(confirmButton);
        
    }];
    
    UIView *lineView1 = [UIView dp_viewWithColor:UIColorFromRGB(0x381509)];
    UIView *lineView2 = [UIView dp_viewWithColor:UIColorFromRGB(0x381509)];
    [contentView addSubview:lineView1];
    [contentView addSubview:lineView2];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(zhinengButton.mas_right).offset(3);
        make.width.equalTo(@0.5);
        
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.right.equalTo(confirmButton.mas_left).offset(-3);
        make.width.equalTo(@0.5);
        
    }];
}
-(void)pvt_bulidOption{
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor=UIColorFromRGB(0x4b1d0d);
    [self.optionView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UIButton *button=[[UIButton alloc]init];
    button.backgroundColor=[UIColor clearColor];
    button.tag=1001;
    button.selected=YES;
    self.afterWinStop=button.selected;
    [button setImage:dp_QuickThreeImage(@"q3transferBonus.png") forState:UIControlStateNormal];
    [button setImage:dp_QuickThreeImage(@"q3transBonusSelected.png") forState:UIControlStateSelected];
    [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"中奖后停止" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.74 green:0.72 blue:0.67 alpha:1.0]  forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont dp_systemFontOfSize:12.0];

    [self.optionView addSubview:button];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DPLog(@"%@", button.superview);
    });
    
    UIImageView *issueBack=[[UIImageView alloc]init];
    [issueBack setBackgroundColor:[UIColor clearColor]];
    issueBack.image=dp_QuickThreeImage(@"q3transIssueBack.png");
    [self.optionView addSubview:issueBack];
    [issueBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.optionView);
        make.left.equalTo(self.optionView);
        make.right.equalTo(self.optionView);
        make.height.equalTo(@34.5);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.optionView);
        make.height.equalTo(@24);
        make.left.equalTo(self.optionView).offset(5);
        make.width.equalTo(@94.5);
    }];
    
    NSArray *option128 = @[[self createIssueButton], [self createIssueButton],[self createIssueButton]];
    [option128 enumerateObjectsUsingBlock:^(DPDigitalIssueControl *obj, NSUInteger idx, BOOL *stop) {
        [self.optionView addSubview:obj];
    }];
    NSArray *array=[NSArray arrayWithObjects:@" 10期", @" 50期",@" 100期",nil];
    for (int i = 0; i < option128.count; i++) {
        UIButton *obj = option128[i];
        obj.tag=1200+i;
        [obj setTitle: [array objectAtIndex:i] forState:UIControlStateNormal];
        [obj setTitle: [array objectAtIndex:i] forState:UIControlStateSelected];
        obj.selected=NO;
        [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(issueBack).multipliedBy(0.333);
            make.height.equalTo(@34.5);
            make.bottom.equalTo(issueBack);
            if (i == 1) {
                make.centerX.equalTo(self.optionView);
            }
        }];
        
        if (i >= option128.count - 1) {
            
            continue;
        }
        UIView *lineView1 = [UIView dp_viewWithColor:UIColorFromRGB(0x381509)];
        [issueBack addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj);
            make.bottom.equalTo(obj);
            make.left.equalTo(obj.mas_right).offset(0.5);
            make.width.equalTo(@1);
        }];
        DPDigitalIssueControl *obj1 = option128[i];
        DPDigitalIssueControl *obj2 = option128[i + 1];
        
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj1.mas_right).offset(-1);
        }];
        
        
    }
    
}
-(UIButton *)createIssueButton{
    UIButton *button=[[UIButton alloc]init];
    [button setTitleColor:UIColorFromRGB(0x4b1d0d) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xdeff00) forState:UIControlStateSelected];
    [button setImage:nil forState:UIControlStateNormal];
    [button setImage:dp_QuickThreeImage(@"q3transferIssueSel.png") forState:UIControlStateSelected];
    return button;
}
-(void)pvt_singleButtonClick:(id)sender{
    UIButton *bet=(UIButton *)sender;
    NSArray *array=[NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:50],[NSNumber numberWithInt:100], nil];
    bet.backgroundColor=[UIColor clearColor];
    int index=bet.tag-1200;
    if (index<array.count) {
        self.addIssueTextField.text=[NSString stringWithFormat:@"%d",[[array objectAtIndex:index]integerValue]];
    }
    for(int i=0; i<3;i++){
        UIButton *allBet=(UIButton*)[self.optionView viewWithTag:1200+i];
        allBet.selected=NO;
    }
    bet.selected=YES;
    
    [self calculateAllZhushuWithZj:YES];
    
}
-(UIView *)mulAndIssueView{
    if (_mulAndIssueView==nil) {
        _mulAndIssueView=[[UIView alloc]init];
        _mulAndIssueView.backgroundColor=[UIColor clearColor];
    }
    return _mulAndIssueView;
}
-(UIView *)optionView{
    if (_optionView==nil) {
        _optionView=[[UIView alloc]init];
        _optionView.backgroundColor=[UIColor dp_flatBackgroundColor];
        _optionView.userInteractionEnabled = YES;
    }
    return _optionView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}
- (UITableView *)issureTableView {
    if (_issureTableView == nil) {
        _issureTableView = [[UITableView alloc] init];
        _issureTableView.backgroundColor = [UIColor clearColor];
        _issureTableView.delegate = self;
        _issureTableView.dataSource = self;
        _issureTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *contentView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        
        UIButton *agreementButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled=YES;
            [button setImage:dp_QuickThreeImage(@"q3transPro.png") forState:UIControlStateSelected];
            [button setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            button.tag=1002;
            button.selected=YES;
            [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
//        UIButton *proButton = ({
//            UIButton *button = [[UIButton alloc] init];
//            button.userInteractionEnabled=YES;
//            [button setTitle:@" 我同意《用户合买代购协议》其中条款" forState:UIControlStateNormal];
//            [button setTitleColor:UIColorFromRGB(0x80D9FF) forState:UIControlStateNormal];
//            [button setBackgroundColor:[UIColor clearColor]];
//            [button.titleLabel setFont:[UIFont dp_systemFontOfSize:11]];
//            [button.titleLabel setNumberOfLines:0];
//            button.tag=1003;
//            [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            
//            button;
//        });
        UILabel *proLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            NSString *words = @" 我同意《用户合买代购协议》其中条款";
            NSMutableAttributedString *stringM = [[NSMutableAttributedString alloc]initWithString:words];
            NSRange range1 = [words rangeOfString:@"我同意"];
            NSRange range2 = [words rangeOfString:@"《用户合买代购协议》"];
            NSRange range3 = [words rangeOfString:@"其中条款"];
            [stringM addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x80D9FF) range:range1];
            [stringM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1] range:range2];
            [stringM addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x80D9FF) range:range3];
            [stringM addAttribute:NSFontAttributeName value:[UIFont dp_systemFontOfSize:11] range:NSMakeRange(0, stringM.length)];
            label.attributedText = stringM;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prolabelClick)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            label;
        });


        [contentView addSubview:proLabel];
        [contentView addSubview:agreementButton];
        [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
//            make.top.equalTo(contentView).offset(5);
//            make.bottom.equalTo(contentView).offset(-5);
//            make.width.equalTo(@195);
            make.centerY.equalTo(contentView);
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(proButton.mas_left);
//            make.width.equalTo(@20);
//            make.top.equalTo(contentView).offset(5);
//            make.bottom.equalTo(contentView).offset(-5);
            make.right.equalTo(proLabel.mas_left);
            make.centerY.equalTo(proLabel);
        }];
        _issureTableView.tableFooterView = contentView;
        
    }
    return _issureTableView;
}
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UIImageView *) addyizhuView{
    if (_addyizhuView == nil) {
        _addyizhuView = [[UIImageView alloc] init];
        _addyizhuView.backgroundColor = [UIColor clearColor];
        _addyizhuView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"q3transRandom.png")];
    }
    return _addyizhuView;
}
- (TTTAttributedLabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[TTTAttributedLabel alloc] init];
        [_bottomLabel setNumberOfLines:2];
        [_bottomLabel setTextColor:[UIColor dp_flatWhiteColor]];
        [_bottomLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_bottomLabel setBackgroundColor:[UIColor clearColor]];
        [_bottomLabel setTextAlignment:NSTextAlignmentCenter];
        [_bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _bottomLabel.lineBreakMode = NSLineBreakByTruncatingTail ;
        _bottomLabel.userInteractionEnabled=NO;
        
    }
    
    return _bottomLabel;
}
-(UILabel *)labelWithText:(NSString *)title  font:(UIFont*)font  titleColor:(UIColor *)color  textAlignment:(NSTextAlignment )alignment{
    UILabel *label=[[UILabel alloc]init];
    label.backgroundColor=[UIColor clearColor];
    label.font=font;
    label.textColor=color;
    label.textAlignment=alignment;
    label.text=title;
    return label;
}
-(void)onBtnClick:(UIButton *)button{
    int index=button.tag-1000;
    switch (index) {
//        case 0:
//        {
//            button.selected=!button.selected;
//            self.addTouzhu=!self.addTouzhu;
//            [self calculateAllZhushu];
//        }
//            break;
        case 1:
        {
            button.selected=!button.selected;
            self.afterWinStop=!self.afterWinStop;
            
        }
            break;
        case 2:
        {
            button.selected=!button.selected;
            _isSelectedPro=button.selected;
            
            
        }
            break;
        default:
            break;
    }
    
    
}
- (void)prolabelClick
{
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.title = @"合买代购协议";
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];

}
#pragma mark UITableViewDelete
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int num[PKNUMMAX]={0};
    PKType subType;
    int note;
    _CPTInstance->GetTarget(indexPath.row, num, subType,note);
    NSString *touzhuInfo = @"";
    
    switch (subType) {
        case PKTypeBaoxuan: {
            for(int i=0 ;i<5;i++){
                if (num[i]==1) {
                    touzhuInfo=counterNumberbaoxuan[i];
                }
            }
            
        } break;
        case PKTypeBaozi: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberBaozi[i]];
                }
            }
            
        } break;
        case PKTypeDuizi: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberDuizi[i]];
                }
            }
            
        } break;
        case PKTypeTonghua: {
            for(int i=0 ;i<4;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumbertonghua[i]];
                }
            }
            
        } break;
        case PKTypeShunzi: {
            for(int i=0 ;i<12;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberShunzi[i]];
                }
            }
            
        } break;
        case PKTypeTonghuashun: {
            for(int i=0 ;i<4;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumbertonghua[i]];
                }
            }
            
        } break;
        case PKTypeRenxuan1: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan2: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan3: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan4: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan5: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan6: {
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        default:
            break;
    }
     CGFloat height=0.0;
    CGSize fitLabelSize = CGSizeMake(230, 2000);
    CGSize labelSize = [touzhuInfo sizeWithFont:[UIFont dp_regularArialOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    height=ceilf(labelSize.height)+45.0;
    return height;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CPTInstance->GetTargetNum();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", indexPath.row];
    DPQuick3DigitalBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[DPQuick3DigitalBuyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:CellIdentifier
                                                       ];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        //        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self touzhuInfotableCell:cell indexPath:indexPath];
    
    return cell;
}
- (int)buyTypeForOneRow:(int)row {
    int num[PKNUMMAX]={0};
    PKType subType;
    int note;
    _CPTInstance->GetTarget(row, num, subType,note);
    return subType;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    DPPksBuyViewController *viewControler=[[DPPksBuyViewController alloc] init];
    viewControler.targetIndex=indexPath.row;
    viewControler.isTransfer=1;
    [self.navigationController pushViewController:viewControler animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([NSStringFromClass([vc class]) isEqualToString:@"DPPksBuyViewController"]) {
//            DPPksBuyViewController *viewControler = (DPPksBuyViewController *)vc;
//            viewControler.targetIndex=indexPath.row;
//        }
//    }
}


//更新投注信息
- (void)touzhuInfotableCell:(DPQuick3DigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {
    int num[PKNUMMAX]={0};
    PKType subType;
    int note;
    _CPTInstance->GetTarget(indexPath.row, num, subType,note);
    int zhushu=_CPTInstance->NotesCalculate(num,subType);
    NSString *title = @"豹子";
    NSString *touzhuInfo = @"";
    
    switch (subType) {
        case PKTypeBaoxuan: {
            title = @"包选";
            for(int i=0 ;i<5;i++){
                if (num[i]==1) {
                    touzhuInfo=counterNumberbaoxuan[i];
                }
            }
            
        } break;
        case PKTypeBaozi: {
            title = @"豹子";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberBaozi[i]];
                }
            }
            
        } break;
        case PKTypeDuizi: {
            title = @"对子";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberDuizi[i]];
                }
            }
            
        } break;
        case PKTypeTonghua: {
            title = @"同花";
            for(int i=0 ;i<4;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumbertonghua[i]];
                }
            }
           
        } break;
        case PKTypeShunzi: {
            title = @"顺子";
            for(int i=0 ;i<12;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberShunzi[i]];
                }
            }
           
        } break;
        case PKTypeTonghuashun: {
            title = @"同花顺";
            for(int i=0 ;i<4;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumbertonghua[i]];
                }
            }
          
        } break;
        case PKTypeRenxuan1: {
          title=@"任选一";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan2: {
            title=@"任选二";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan3: {
            title=@"任选三";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan4: {
            title=@"任选四";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan5: {
            title=@"任选五";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
        case PKTypeRenxuan6: {
            title=@"任选一六";
            for(int i=0 ;i<13;i++){
                if (num[i]==1) {
                    touzhuInfo=[NSString stringWithFormat:@"%@ %@",touzhuInfo,counterNumberrenxuan[i]];
                }
            }
        } break;
               default:
            break;
    }
    [cell upDateBuyLabelContstrant:title];
    UIFont *font = [UIFont dp_regularArialOfSize:14.0];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:touzhuInfo];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
    if (fontRef) {
        [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
        CFRelease(fontRef);
    }
    [cell.infoLabel setText:hintString1];
    cell.buyTypelabel.text=title;
    cell.zhushuLabel.text= [NSString stringWithFormat:@"%@  %d注  %d元", zhushu>1?@"复式":@"单式",zhushu,zhushu*2];
   
    
}

- (void)pvt_add {
    DPPksBuyViewController *vc=[[DPPksBuyViewController alloc]init];
    vc.isTransfer=1;
    [self.navigationController pushViewController:vc animated:YES];
}

//返回
- (void)pvt_onBack {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
//
    
    if (_CPTInstance->GetTargetNum() <= 0) {
        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [DPAppParser backToCenterRootViewController:YES];

        } else {
            _dismissing = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [DPAppParser backToCenterRootViewController:YES];
            } else {
                _dismissing = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

/**
 *  智能追号跳转
 */
-(void)pvt_togetherBuy{
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    if (_isSelectedPro == NO) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    int minBonus, maxBonus; // 最大最小金额
    CPokerThree *poker3Center = CFrameWork :: GetInstance() -> GetPokerThree();
    int capResult = poker3Center -> CapacityBonusRange(minBonus, maxBonus);
    if (capResult < 0) {
        [[DPToast makeText:@"该方案不支持智能追号"]show];
        return;
    }
    int  _amount = 2 * poker3Center -> GetTotalNote();
//    int _gameIsuue ; string _endTime ;
//    poker3Center -> GetInfo(_gameIsuue, _endTime);
    
    int  _periods,_multiple; vector<int>  _szMultiple,_szMmount,_szMinProfit,_szRate;
    CCapacityFactor* _factorCenter= CFrameWork :: GetInstance() -> GetCapacityFactor();
    _factorCenter -> SetProjectInfo(_amount, minBonus, maxBonus, _periods, _multiple);
    _factorCenter -> SetProfitRate(30);
    vector<int> maxProfit;
   int ret =  _factorCenter -> Generate(_szMultiple, _szMmount, _szMinProfit, maxProfit, _szRate);
    
    if (ret == ERROR_CANNOT_PROFIX) {
        [[DPToast makeText:@"暂无盈利"]show];
        return ;
    }
    DPSmartFollowVC *smart = [[DPSmartFollowVC alloc] init];
    smart.gameType = smartZhGameTypePKS;
    [smart createDataObject];
    [self.navigationController pushViewController:smart animated:YES];

    
}
- (void)pvt_submitss {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    int index=_CPTInstance->GetTotalNote();
    if (index<1) {
        [[DPToast makeText:@"请至少选择一注"]show];
        return ;
    }
    if (_CPTInstance->GetTotalNote()<=0) {
        [[DPToast makeText:@"至少选择一注"]show];
        return;
    }
    if (!_isSelectedPro) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    [self.view endEditing:YES];
    
    __weak __typeof(self) weakSelf = self;
    __block __typeof(_CPTInstance) weakInstance = _CPTInstance;
    
    void (^block)(void) = ^() {
        int multiple = [weakSelf.addTimesTextField.text integerValue];
        int issue = [weakSelf.addIssueTextField.text integerValue];
        int money = index * 2 * multiple * issue;
        
        if (money > 2000000) {
            [[DPToast makeText:dp_moneyLimitWarning]show];
            return;
        }
        
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
        CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(GameTypeSdpks, 1, money, 0);
        weakInstance->SetOrderInfo(multiple, issue, self.afterWinStop );
        
        [weakSelf.view.window showDarkHUD];
    };
    
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        block();
    } else {
        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
        viewController.finishBlock = block;
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{
    int zhushu=_CPTInstance->GetTotalNote();
    if (zhushu<= 0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else{
        self.issureTableView.tableFooterView.hidden = NO ;
    }
    NSString* currentMoney=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]];
    
    NSString *money=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString *hintString1 ;
    if ([self.addIssueTextField.text integerValue]>1) {
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元(本期%@元)\n%d注 %@倍 %@期", money, currentMoney,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1+money.length+4,currentMoney.length)];
    }else{
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元\n%d注 %@倍 %@期", money,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];

        
    }
   
    [self.bottomLabel setText:hintString1];


}

#pragma DPDigitalBuyCellDelegate

- (void)DPDigitalBuyDelegate:(DPDigitalBuyCell *)cell {
    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CPTInstance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self calculateAllZhushuWithZj:YES];
   
    self.addyizhuView.hidden = _CPTInstance->GetTargetNum() > 0 ? YES : NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)digitalRandomData{
    int index=_CPTInstance->GetTargetNum();
    PKType gameType=PKTypeRenxuan1;
    
    if (index>0) {
        int num[PKNUMMAX]={0};
        int note;
        _CPTInstance->GetTarget(0, num, gameType,note);

    }
    int red[PKNUMMAX] = {0};
    switch (gameType) {
        case PKTypeBaoxuan:
        {
            [self partRandom:1 total:5 target2:red];
    
        }
            break;
        case PKTypeDuizi:
        {
            [self partRandom:1 total:13 target2:red];
        
        }
            
            break;
        case PKTypeBaozi:
        {
            [self partRandom:1 total:13 target2:red];
    
        }
            
            break;
        case PKTypeTonghua:
        {
            [self partRandom:1 total:4 target2:red];

        }
            
            break;
        case PKTypeShunzi:
        {
            [self partRandom:1 total:12 target2:red];
            }
            
            break;
        case PKTypeTonghuashun:
        {
            [self partRandom:1 total:4 target2:red];
        
        }
            
            break;
        case PKTypeRenxuan1:
        {
            [self partRandom:1 total:13 target2:red];
           
        }
            
            break;
        case PKTypeRenxuan2:
        {
            [self partRandom:2 total:13 target2:red];
            
        }
            
            break;
        case PKTypeRenxuan3:
        {
            [self partRandom:3 total:13 target2:red];
           
        }
            
            break;
        case PKTypeRenxuan4:
        {
            [self partRandom:4 total:13 target2:red];
            
        }
            
            break;
        case PKTypeRenxuan5:
        {
            [self partRandom:5 total:13 target2:red];
            
        }
            
            break;
        case PKTypeRenxuan6:
        {
            [self partRandom:6 total:13 target2:red];
           
        }
            
            break;
            
        default:
            break;
    }
    _CPTInstance->AddTarget(red, gameType);
    [self.issureTableView reloadData];
    self.addyizhuView.hidden=_CPTInstance->GetTargetNum()>0?YES:NO;


}
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random() % ((total - i) == 0?1:(total-i));
        target[[array[x] integerValue]] = 1;
        [array removeObjectAtIndex:x];
    }
}

#pragma mark-UITextDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    float height=0.0;
    self.optionView.hidden=YES;
    if (textField==self.addIssueTextField) {
        height=60;
        self.optionView.hidden=NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pvt_adaptPassModeHeight:height];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    });
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    int  aString = [newString intValue];
    
    if (newString.length == 0) {
        textField.text = @"";
        [self calculateAllZhushuWithZj:YES];
        return NO;
    }
    
    if (aString <= 0) {
        aString = 1;
    }
    if (textField==self.addTimesTextField) {
        if (aString>100000) {
            self.addTimesTextField.text=@"100000";
            [self calculateAllZhushuWithZj:YES];
            return NO;
        }
    }
    if (textField==self.addIssueTextField) {
        for(int i=0; i<3;i++){
            DPDigitalIssueControl *allBet=(DPDigitalIssueControl*)[self.optionView viewWithTag:1200+i];
            allBet.selected=NO;
        }
        if (aString==10) {
            DPDigitalIssueControl *obj=(DPDigitalIssueControl *)[self.view viewWithTag:1200];
            obj.selected=YES;
        }
        if (aString==50) {
            DPDigitalIssueControl *obj=(DPDigitalIssueControl *)[self.view viewWithTag:1201];
            obj.selected=YES;
        }
        if (aString==100) {
            DPDigitalIssueControl *obj=(DPDigitalIssueControl *)[self.view viewWithTag:1202];
            obj.selected=YES;
        }
        if (aString>100) {
            self.addIssueTextField.text=@"100";
            [self calculateAllZhushuWithZj:YES];
            return NO;
        }
        
    }
    newString = [NSString stringWithFormat:@"%d", aString];
    if ([textField.text isEqualToString:newString]) {
        textField.text = nil;   // fix iOS8
    }
    textField.text = newString;
    
    [self calculateAllZhushuWithZj:YES];
   
    return NO;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==self.addIssueTextField) {
        [self pvt_adaptPassModeHeight:0];
        self.optionView.hidden=YES;
    }
    if ([textField.text integerValue]<=0) {
        textField.text=@"1";
    }
    [self calculateAllZhushuWithZj:YES];
    
}
- (void)pvt_onTap {
    if (self.addIssueTextField.isEditing) {
        [self.addIssueTextField resignFirstResponder];
    }
    if (self.addTimesTextField.isEditing) {
        [self.addTimesTextField resignFirstResponder];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
     [self pvt_hiddenCoverView:YES];
}
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.bottomView && obj.firstAttribute == NSLayoutAttributeBottom) {
            
            obj.constant = keyboardY - screenHeight;
            
            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
            [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
            
            *stop = YES;
        }
    }];
    if (keyboardY != UIScreen.mainScreen.bounds.size.height) {
        [self pvt_hiddenCoverView:NO];
    }else{
    [self pvt_hiddenCoverView:YES];
    }
    

}
- (void)pvt_adaptPassModeHeight:(float)height {
    [self.optionView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.optionView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
            *stop = YES;
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewWrapperView"]) {
        return  YES;
    }
    if ([touch.view isDescendantOfView:self.issureTableView]) {
        return NO;
    }
    return  YES;
}


#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        switch (cmdId) {
            case NOTIFY_TIMEOUT_LOTTERY:
                if (self.timeSpace > 0) {
                    break;
                }
            case NOTIFY_FINISH_LOTTERY: {
                [self recvRefresh:NO];
                [self alertGameName];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:dp_DigitalBetRefreshNofify object:nil];
            }
                return;
            default:
                break;
        }
        
        switch (cmdType) {
            case ACCOUNT_RED_PACKET: {
                [self dismissDarkHUD];
                if (ret < 0) {
                    
                    [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                    break;
                }
                [self dismissDarkHUD];
                int index = _CPTInstance->GetTotalNote();
                int money = index * 2 * [self.addTimesTextField.text integerValue] * [self.addIssueTextField.text integerValue];
                BOOL isRedpacket=NO;
                if (moduleInstance->GetPayRedPacketCount()) {
                    
                   isRedpacket=YES;
                }
                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                viewController.gameTypeText = dp_GameTypeFullName(GameTypeSdpks);
                viewController.projectAmount = money;
                viewController.delegate = self;
                viewController.gameType = GameTypeSdpks;
                viewController.isredPacket=isRedpacket;
                if (self.addIssueTextField.text.intValue > 1) {
                    viewController.entryType = kEntryTypeFollow;
                }
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case GOPLAY: {
                [self dismissDarkHUD];
                if (ret < 0) {
                    if (ret==ERROR_NO_DATA) {
                        [[DPToast makeText:@"未取到期号"] show];
                    }else if(ret==ERROR_PARAMETER){
                        [[DPToast makeText:@"数据错误"] show];
                    }else{
                    [[DPToast makeText:DPPaymentErrorMsg(ret)] show];
                    }
                } else {
                    [self goPayCallback];
                }
            } break;
            case REFRESH: {
                if (ret >= 0) {
                    [self recvRefresh:NO];
                    [self alertGameName];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:dp_DigitalBetRefreshNofify object:nil];
                } else {
                    self.timeSpace = -60;
                }
            }
                break;
            default:
                break;
        }
        
    });
}

#pragma mark - DPRedPacketViewControllerDelegate
- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType{
    if (ret >= 0) {
        [self goPayCallback];
    }
}

- (void)goPayCallback {
    int buyType; string token;
    _CPTInstance->GetWebPayment(buyType, token);
    NSString *urlString=kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    kAppDelegate.gotoHomeBuy = YES;
}


@end
