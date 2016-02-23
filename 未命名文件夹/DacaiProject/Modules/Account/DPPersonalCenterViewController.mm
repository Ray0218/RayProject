//
//  DPPersonalCenterViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"

#import "FrameWork.h"
#import "DPPersonalCenterViewController.h"
#import "DPBuyRecordCell.h"
#import "ModuleNotify.h"
#import "DPSecurityCenterViewController.h"
#import "DPAccountViewControllers.h"
#import "DPFundFlowViewController.h"
#import "DPProjectDetailVC.h"
#import "DPSettingVC.h"
#import "NotifyType.h"
#import "DPAcountPacketController.h"
#import "DPRechargeVC.h"
#import "DPDrawingsVC.h"
#import "DPExchangeViewController.h"
@interface DPPersonalCenterViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    ModuleNotify
> {
    CFrameWork *_frameWork;
    CAccount   *_account;
    UIImageView *_headerView;
    UIView *_tabBarView;
    UITableView *_tableView;
    
    UILabel *_nameLabel;
    UIImageView *_passwordIcon;
    UIImageView *_identityIcon;
    UIImageView *_mobileNoIcon;
    
    UILabel *_realAmtLabel;
    UILabel *_coinAmtLabel;
    UILabel *_packetAmtLabel;
    UIView  *_noDataView;
    
    NSInteger _infoCmdId;
    NSInteger _listCmdId;
}

@property (nonatomic, strong, readonly) UIImageView *headerView;
@property (nonatomic, strong, readonly) UIView *tabBarView;

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UIImageView *passwordIcon;
@property (nonatomic, strong, readonly) UIImageView *identityIcon;
@property (nonatomic, strong, readonly) UIImageView *mobileNoIcon;

@property (nonatomic, strong, readonly) UILabel *realAmtLabel;
@property (nonatomic, strong, readonly) UILabel *coinAmtLabel;
@property (nonatomic, strong, readonly) UILabel *packetAmtLabel;
@property (nonatomic, strong) UIView *bgLine;

@property (nonatomic, assign) NSInteger recordType;
@property (nonatomic, assign) BOOL panTrigger;

@property (nonatomic, strong, readonly) UIView *noDataView;
@property (nonatomic, strong, readonly) UIImageView *iconView;
@end

const NSString * const dp_redPointView_key = @"dp_redPointView_key";
@implementation DPPersonalCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _frameWork = CFrameWork::GetInstance();
        _account = CFrameWork::GetInstance()->GetAccount();
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.95 alpha:1]];
    [self buildLayout];
    __block CFrameWork *weakFrameWork = _frameWork;
    __weak DPPersonalCenterViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_listCmdId, weakFrameWork->GetAccount()->RefreshBuyRecord(weakSelf.recordType, true));
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_listCmdId, weakFrameWork->GetAccount()->RefreshBuyRecord(weakSelf.recordType));
    }];
    self.tableView.showsInfiniteScrolling = NO;
}

- (void)buildLayout {
    UIView *contentView = nil;
    contentView = self.view;
    
    // 分割竖线
    self.bgLine = ({
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:183.0/255 green:184.0/255 blue:177.0/255 alpha:0.8f];
        view;
    });
    [contentView addSubview:self.bgLine];
    [contentView addSubview:self.headerView];
    [contentView addSubview:self.tabBarView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.noDataView];
    self.noDataView.hidden = YES;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@158);
    }];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@35);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.tabBarView.mas_bottom);
        make.bottom.equalTo(contentView);
    }];

    [self.bgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView);
        make.bottom.equalTo(contentView);
        make.width.equalTo(@0.8);
        make.left.equalTo(self.tableView).offset(35.6);
    }];
    
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).offset(20);
        make.centerX.equalTo(self.tableView);
        make.width.equalTo(@100);
        make.height.equalTo(@180);
    }];
    self.bgLine.hidden=YES;
//    self.tableView.tableFooterView = ({
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//        view.backgroundColor = [UIColor clearColor];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"bottomball.png")];
//        [view addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(view);
//            make.left.equalTo(view).offset(19);
//        }];
//        view;
//    });
    UIView *bottomLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.82 green:0.81 blue:0.73 alpha:1];
        view;
    });
    [self.tabBarView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabBarView);
        make.right.equalTo(self.tabBarView);
        make.bottom.equalTo(self.tabBarView);
        make.height.equalTo(@0.5);
    }];

    NSInteger width = UIScreen.mainScreen.bounds.size.width / 5;
    
    UIButton *firstButon = nil;
    NSArray *tabBarNames = @[@"全部", @"待支付", @"待开奖", @"追号", @"中奖"];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
//        [button setBackgroundImage:dp_AccountImage(@"winclock.png") forState:UIControlStateSelected];
        [button setTitle:tabBarNames[i] forState:UIControlStateNormal];
        [button setTag:i];
        [button setSelected:i == 0];
        [button addTarget:self action:@selector(pvt_onTabBar:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];
        [self.tabBarView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tabBarView);
            make.bottom.equalTo(self.tabBarView);
            make.left.equalTo(@(i * width));
            make.width.equalTo(@(width));
        }];
        
        if (i == 0) {
            firstButon = button;
        }
    }
    
    // 选中箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:dp_AccountImage(@"已选中状态.png")];
    [self.tabBarView addSubview:arrow];
    
    if (firstButon != nil) {
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(firstButon);
            make.bottom.equalTo(self.tabBarView);
        }];
    }

    
    // 布局头部
    UIView *view1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *view2 = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *view3 = [UIView dp_viewWithColor:[UIColor clearColor]];

    [view3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onFund)]];

    
    contentView = self.headerView;
    [contentView addSubview:view1];
    [contentView addSubview:view2];
    [contentView addSubview:view3];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        if (IOS_VERSION_7_OR_ABOVE) {
            make.top.equalTo(contentView).offset(20);
        } else {
            make.top.equalTo(contentView);
        }
        make.bottom.equalTo(view2.mas_top);
    }];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@55);
        make.centerY.equalTo(contentView).offset(2);
    }];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(view2.mas_bottom);
        make.bottom.equalTo(contentView);
    }];
    
    // 顶部
    UIButton *homeButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:dp_NavigationImage(@"home.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onHome) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *settingButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:dp_AccountImage(@"setting.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onSetting) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    contentView = view1;
    [contentView addSubview:homeButton];
    [contentView addSubview:settingButton];
    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.left.equalTo(contentView).offset(5);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    
    // 中间
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"bigpeople.png")];
        imageView;
    });
    _iconView = imageView;
//    if (res) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_iconViewSingleTap)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:singleTap];
        UIView *redPointView = [[UIView alloc]init];
        redPointView.backgroundColor = [UIColor dp_flatRedColor];
        redPointView.layer.cornerRadius = 4;
        redPointView.tag = 0;
        redPointView.hidden = YES;
        [imageView addSubview:redPointView];
        [imageView dp_setStrongObject:redPointView forKey:dp_redPointView_key];
        [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(5);
            make.right.equalTo(imageView).offset(-5);
            make.width.equalTo(@8);
            make.height.equalTo(@8);
        }];
//    }
    UIButton *topUpButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"充值" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:11]];
        [button.layer setCornerRadius:11];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button addTarget:self action:@selector(pvt_chongzhi) forControlEvents:UIControlEventTouchUpInside];
        [button.layer setBorderWidth:1];
        button;
    });
    UIButton *drawButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"提款" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:11]];
        [button.layer setCornerRadius:11];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button addTarget:self action:@selector(pvt_drawing) forControlEvents:UIControlEventTouchUpInside];
        [button.layer setBorderWidth:1];
        button;
    });
    UIButton *exchangeButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"兑换码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:11]];
        [button.layer setCornerRadius:11];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(pvt_exchange) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
   
    UIImageView *arrowIcon = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"arrow_right_white.png")];
        imageView;
    });
    UIButton *aceNameButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor clearColor];
        [button addTarget:self action:@selector(pvt_aceName) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    contentView = view2;
    [contentView addSubview:imageView];
    [contentView addSubview:self.nameLabel];
    [contentView addSubview:topUpButton];
    [contentView addSubview:drawButton];
    [contentView addSubview:exchangeButton];
    [contentView addSubview:self.passwordIcon];
    [contentView addSubview:self.identityIcon];
    [contentView addSubview:self.mobileNoIcon];
    [contentView addSubview:arrowIcon];
    [contentView addSubview:aceNameButton];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(contentView).offset(5);
        make.centerY.equalTo(contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(5);
    }];
    [topUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY);
        make.height.equalTo(@22);
        make.width.equalTo(@40);
        make.left.equalTo(imageView.mas_right).offset(5);
    }];
    [drawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY);
        make.height.equalTo(@22);
        make.width.equalTo(@40);
        make.left.equalTo(topUpButton.mas_right).offset(8);
    }];
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY);
        make.height.equalTo(@22);
        make.width.equalTo(@50);
        make.left.equalTo(drawButton.mas_right).offset(8);
    }];
    [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-2);
    }];
    [self.mobileNoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(arrowIcon.mas_left).offset(-1);
    }];
    [self.identityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(self.mobileNoIcon.mas_left).offset(-2);
    }];
    [self.passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(self.identityIcon.mas_left).offset(-2);
    }];
    [aceNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordIcon);
        make.right.equalTo(contentView);
        make.centerY.equalTo(contentView);
        make.top.equalTo(contentView);
    }];
    // 底部
    UIButton *realIcon = ({
        UIButton *button = [[UIButton alloc] init];
        [button setUserInteractionEnabled:NO];
        [button setImage:dp_AccountImage(@"realAmt.png") forState:UIControlStateNormal];
        [button setTitle:@" 余额" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        button;
    });
    
    // 接收红包点击事件按钮
    UIButton *coverBtn = [[UIButton alloc]init];
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(packetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *packetIcon = ({
        UIButton *button = [[UIButton alloc] init];
        [button setUserInteractionEnabled:NO];
        [button setImage:dp_AccountImage(@"packet.png") forState:UIControlStateNormal];
        [button setTitle:@" 红包" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
//        [button addTarget:self action:@selector(packetIconClick) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    UIButton *coinIcon = ({
        UIButton *button = [[UIButton alloc] init];
        [button setUserInteractionEnabled:NO];
        [button setImage:dp_AccountImage(@"coinAmt.png") forState:UIControlStateNormal];
        [button setTitle:@" 大彩币" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        button;
    });
    UIView *line1 = [UIView dp_viewWithColor:[UIColor colorWithWhite:1 alpha:0.3]];
    UIView *line2 = [UIView dp_viewWithColor:[UIColor colorWithWhite:1 alpha:0.3]];
    
    [self.view addSubview:coverBtn];
    contentView = view3;
    [contentView addSubview:self.realAmtLabel];
    [contentView addSubview:self.coinAmtLabel];
    [contentView addSubview:self.packetAmtLabel];
    [contentView addSubview:realIcon];
    [contentView addSubview:coinIcon];
    [contentView addSubview:packetIcon];
    [contentView addSubview:line1];
    [contentView addSubview:line2];
    
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.centerX.equalTo(packetIcon);
        make.width.equalTo(packetIcon);
        make.height.equalTo(contentView);
    }];
    
    [self.realAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(10);
        make.centerX.equalTo(realIcon);
    }];
    
    [self.packetAmtLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(packetIcon);
        make.top.equalTo(contentView).offset(10);
    }];
    
    [self.coinAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(10);
        make.centerX.equalTo(coinIcon);
    }];
    [realIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(contentView.mas_centerY);
        make.bottom.equalTo(contentView);
        make.width.equalTo(coinIcon);
        make.width.equalTo(packetIcon);
    }];
    [packetIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(realIcon.mas_right);
        make.top.equalTo(contentView.mas_centerY);
        make.bottom.equalTo(contentView);
    }];
    
    [coinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(packetIcon.mas_right);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView.mas_centerY);
        make.bottom.equalTo(contentView);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(-5);
        make.right.equalTo(realIcon);
    }];
    [line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(-5);
        make.right.equalTo(packetIcon);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    [self.navigationController dp_applyGlobalTheme];
    if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
        [self.xt_sideMenuViewController setPanGestureEnabled:YES];
        [self pvt_updateUserInfo];
        [self.tableView reloadData];
        [self adjudgeInfiniteView];
    }
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
        [self.xt_sideMenuViewController setPanGestureEnabled:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    if (self.xt_sideMenuViewController.visibleType != XTSideMenuVisibleTypeLeft) {
        return;
    }
    _frameWork->GetAccount()->SetDelegate(self);
    
    if (self.panTrigger) {
        if (_frameWork->IsUserLogin()) {
            [self.tableView triggerPullToRefresh];
        }
        self.panTrigger = NO;
    } else {
        if (_frameWork->IsUserLogin()) {
            int moreData;
            int count = _frameWork->GetAccount()->GetBuyRecordCount(self.recordType, moreData);
            if (moreData && count == 0) {
                [self.tableView triggerPullToRefresh];
            } else {
                REQUEST_RELOAD(_infoCmdId, _frameWork->GetAccount()->RefreshUserInfo());
            }
            [self adjudgeInfiniteView];
        }
    }
}

- (void)panDidAppear {
    self.panTrigger = YES;
}

- (void)panDidDisappear {
    REQUEST_CANCEL(_infoCmdId);
    REQUEST_CANCEL(_listCmdId);
}

- (void)recordTabReset {
    for (UIButton *button in self.tabBarView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && button.tag == 0) {
            if (button.isSelected) {
                return;
            }
            UIView *superView = [button superview];
            
            UIImageView *arrow = nil;
            for (id sub in self.tabBarView.subviews) {
                if ([sub isKindOfClass:[UIButton class]]) {
                    [sub setSelected:NO];
                }else if ([sub isKindOfClass:[UIImageView class]]){
                    arrow = sub;
                }
            }
            [button setSelected:YES];
            
            [arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.bottom.equalTo(superView);
            }];
            //
            self.recordType = button.tag;

            [self.tableView reloadData];            break;
        }
    }
}

- (void)recordTabResetForTag:(int)tabtag{
    for (UIButton *button in self.tabBarView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && button.tag == tabtag) {
            if (button.isSelected) {
                return;
            }
            UIView *superView = [button superview];
            
            UIImageView *arrow = nil;
            for (id sub in self.tabBarView.subviews) {
                if ([sub isKindOfClass:[UIButton class]]) {
                    [sub setSelected:NO];
                }else if ([sub isKindOfClass:[UIImageView class]]){
                    arrow = sub;
                }
            }
            [button setSelected:YES];
            
            [arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.bottom.equalTo(superView);
            }];
            //
            self.recordType = button.tag;
            break;
        }
    }
    if (self.panTrigger) {
        if (_frameWork->IsUserLogin()) {
            [self.tableView triggerPullToRefresh];
        }
        
        self.panTrigger = NO;
    } else {
        if (_frameWork->IsUserLogin()) {
            int moreData;
            int count = _frameWork->GetAccount()->GetBuyRecordCount(self.recordType, moreData);
            if (moreData && count == 0) {
                [self.tableView triggerPullToRefresh];
            }
            [self adjudgeInfiniteView];
        }
    }
}

- (void)reloadHeader {
    [self pvt_updateUserInfo];
}

#pragma mark - event
- (void)pvt_iconViewSingleTap
{
    DPModifyNameVC *modifyVC = [[DPModifyNameVC alloc]init];
    UIView *redPointView = [self.iconView dp_strongObjectForKey:dp_redPointView_key];
    if (redPointView) modifyVC.canModifyPassword = redPointView.tag == 1 ? YES : NO;
    [self.navigationController pushViewController:modifyVC animated:YES];
}
-(void)pvt_chongzhi{
    DPRechargeVC *vc=[[DPRechargeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pvt_drawing{
    DPDrawingsVC *vc=[[DPDrawingsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//安全中心
-(void)pvt_aceName{
    DPSecurityCenterViewController *vc=[[DPSecurityCenterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pvt_onTabBar:(UIButton *)button {
    if (button.isSelected) {
        return;
    }
    UIView *superView = [button superview];
    
    UIImageView *arrow = nil;
    for (id sub in self.tabBarView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            [sub setSelected:NO];
        }else if ([sub isKindOfClass:[UIImageView class]]){
            arrow = sub;
        }
    }
    [button setSelected:YES];

    [arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.bottom.equalTo(superView);
    }];
    
    self.recordType = button.tag;
    [self adjudgeInfiniteView];
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero];
    
    int moreData = 0;
    int count = _frameWork->GetAccount()->GetBuyRecordCount(button.tag, moreData);
    if (count == 0) {
        if (moreData) {
            self.noDataView.hidden = YES;
            [self.tableView triggerPullToRefresh];
        } else {
            self.noDataView.hidden = NO;
        }
    }
}

- (void)pvt_onHome {
    [self.xt_sideMenuViewController hideMenuViewController];
}

- (void)pvt_onSetting {
    [self.navigationController pushViewController:[[DPSettingVC alloc] init] animated:YES];
}

- (void)pvt_onFund {
    [self.navigationController pushViewController:[[DPFundFlowViewController alloc] init] animated:YES];
}

- (void)pvt_exchange {
    [self.navigationController pushViewController:[[DPExchangeViewController alloc] init] animated:YES];
}

- (void)packetButtonClick {
    [self.navigationController pushViewController:[[DPAcountPacketController alloc] init] animated:YES];
}

#pragma mark - table view's data soucre and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      //隐藏线
        self.bgLine.hidden=!_frameWork->GetAccount()->GetBuyRecordCount(self.recordType, section);
    int rows = _frameWork->GetAccount()->GetBuyRecordCount(self.recordType, section);
    if (rows > 0) {
        self.noDataView.hidden = YES;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DPBuyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPBuyRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell buildLayout];
    }
    
    cell.backgroundColor = indexPath.row % 2 ? [UIColor colorWithRed:0.98 green:0.98 blue:0.95 alpha:1] : [UIColor colorWithRed:0.96 green:0.95 blue:0.91 alpha:1];
    
//    static NSInteger COLOR_HEX[] = {0x16A085, 0x27AE60, 0x2980B9, 0x8E44AD, 0x2C3E50, 0xF39C12, 0xD35400, 0xC0392B, 0xBDC3C7, 0x7F8C8D};
    static NSInteger COLOR_HEX[] = {0x16A085, 0xF39C12, 0x2980B9, 0xC0392B, 0x8E44AD, 0x2C3E50, 0x7F8C8D};
    
    string time, winAmt;
    int dayIndex, dayBegin, dayEnd;
    int gameType, buyType, projectStatus, isWined;
    
    _frameWork->GetAccount()->GetRecordDayInfo(self.recordType, indexPath.row, dayIndex, dayBegin, dayEnd);
    _frameWork->GetAccount()->GetBuyRecord(self.recordType, indexPath.row, gameType, time, buyType, projectStatus, isWined, winAmt);
    
    NSDate *date = [NSDate dp_dateFromString:[NSString stringWithUTF8String:time.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    NSString *titleText = dp_GameTypeFullName((GameTypeId)gameType);
    
    cell.colorLine.backgroundColor = UIColorFromRGB(COLOR_HEX[dayIndex % ((sizeof(COLOR_HEX) / sizeof(NSInteger)))]);
    
    if (dayBegin) {
        cell.monthLabel.text = [NSString stringWithFormat:@"%02d月", date.dp_month];
        cell.dayLabel.text = [NSString stringWithFormat:@"%02d", date.dp_day];
    } else {
        cell.monthLabel.text = nil;
        cell.dayLabel.text = nil;
    }
    cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", date.dp_hour, date.dp_minute];
    
    switch (buyType) {  // 1:代购, 2:合买, 3:保存, 4:追号(不显示文字), 6:追号进行中, 7:追号已结束
        case 1:
            cell.buyTypeLabel.text = @"代购";
            break;
        case 2:
            cell.buyTypeLabel.text = @"合买";
            break;
        case 3:
            cell.buyTypeLabel.text = @"保存";
            break;
        case 4:
            cell.buyTypeLabel.text = nil;
            break;
        case 6:
            cell.buyTypeLabel.text = @"追号进行中..";
            break;
        case 7:
            cell.buyTypeLabel.text = @"追号已结束";
            break;
        default:
//            DPAssert(NO);
            break;
    }
    
    cell.attrStatusLabel.hidden = NO;
    cell.attrScheduleLabel.hidden = YES;
    cell.guaranteedLabel.hidden = YES;
    cell.attrStatusLabel.font = [UIFont dp_systemFontOfSize:13];
    switch (projectStatus) {    // 方案状态(1:未满, 3:撤单, 4:流标, 5:未付款, 6:暂未中奖, 7:未中奖, 8:等待开奖,9:出票失败, 10:真实中奖(显示金额), 11:等待付款, 12:已过期, 13:已撤销)
        case 1: {
            int schedule, hasGuaranteed, guaranteed;
            _frameWork->GetAccount()->GetRecordSchedule(self.recordType, indexPath.row, schedule, hasGuaranteed, guaranteed);
            
            NSString *scheduleText = [NSString stringWithFormat:@"%d" "%c", schedule, '%'];
            if (hasGuaranteed) {
                cell.attrStatusLabel.hidden = YES;
                cell.attrScheduleLabel.hidden = NO;
                cell.guaranteedLabel.hidden = NO;
                
                cell.guaranteedLabel.text = [NSString stringWithFormat:@"（保%d%c）", guaranteed, '%'];
                [cell.attrScheduleLabel setText:scheduleText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    UIFont *font = [UIFont dp_regularArialOfSize:10];
                    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
                    if (fontRef) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(scheduleText.length - 1, 1)];
                        CFRelease(fontRef);
                    }
                    return mutableAttributedString;
                }];
            } else {
                cell.attrStatusLabel.font = [UIFont dp_systemFontOfSize:25];
                [cell.attrStatusLabel setText:scheduleText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    UIFont *font = [UIFont dp_regularArialOfSize:10];
                    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
                    if (fontRef) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(scheduleText.length - 1, 1)];
                        CFRelease(fontRef);
                    }
                    
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, mutableAttributedString.string.length)];
                    return mutableAttributedString;
                }];
            }
        }
            break;
        case 3:
            cell.attrStatusLabel.text = @"撤单";
            break;
        case 4:
            cell.attrStatusLabel.text = @"流标";
            break;
        case 5:
            cell.attrStatusLabel.text = @"未付款";
            break;
        case 6:
            cell.attrStatusLabel.text = @"暂未中奖";
            break;
        case 7:
            cell.attrStatusLabel.text = @"未中奖";
            break;
        case 8:
            cell.attrStatusLabel.text = @"等待开奖..";
            break;
        case 9:
            cell.attrStatusLabel.text = @"出票失败";
            break;
        case 10:
            cell.attrStatusLabel.font = [UIFont dp_systemFontOfSize:15];
            [cell.attrStatusLabel setText:[[NSString stringWithUTF8String:winAmt.c_str()] stringByAppendingString:@"元"] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                UIFont *font = [UIFont dp_regularArialOfSize:12];
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
                if (fontRef) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(mutableAttributedString.string.length - 1, 1)];
                    CFRelease(fontRef);
                }
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, mutableAttributedString.string.length - 1)];
                return mutableAttributedString;
            }];
            break;
        case 11:
            cell.attrStatusLabel.text = @"等待付款";
            break;
        case 12:
            cell.attrStatusLabel.text = @"已过期";
            break;
        case 13:
            cell.attrStatusLabel.text = @"已撤销";
            break;
        default:
//            DPAssert(NO);
            break;
    }
    if (buyType >= 4) { // 追号方案
        int currPeriod, totalPeriod, currAmt, totalAmt;
        _frameWork->GetAccount()->GetRecordFollow(self.recordType, indexPath.row, currPeriod, totalPeriod, currAmt, totalAmt);
        
        NSString *appendText = [NSString stringWithFormat:@"(%d/%d期)", currPeriod, totalPeriod];
        [cell.attrTitleLabel setText:[titleText stringByAppendingString:appendText] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            NSRange appendRange = [mutableAttributedString.string rangeOfString:appendText];
            NSRange range = [mutableAttributedString.string rangeOfString:@"/"];
            UIFont *font = [UIFont dp_systemFontOfSize:11];
            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
            if (fontRef) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:appendRange];
                CFRelease(fontRef);
            }
            font = [UIFont dp_regularArialOfSize:13];
            fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
            if (fontRef) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(appendRange.location + 1, range.location - appendRange.location)];
                CFRelease(fontRef);
            }
            font = [UIFont dp_regularArialOfSize:9];
            fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
            if (fontRef) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(range.location + 1, appendRange.location + appendRange.length - range.location - 3)];
                CFRelease(fontRef);
            }
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] CGColor] range:appendRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(appendRange.location + 1, appendRange.length - 3)];
            return mutableAttributedString;
        }];
        
        
        [cell.attrAmtLabel setText:[NSString stringWithFormat:@"%d/%d", currAmt, totalAmt] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            NSRange range = [mutableAttributedString.string rangeOfString:@"/"];
            UIFont *font = [UIFont dp_regularArialOfSize:9];
            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
            if (fontRef) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(range.location + 1, mutableAttributedString.string.length - range.location - 1)];
                CFRelease(fontRef);
            }
            return mutableAttributedString;
        }];
    } else {
        int gameName, amount;
        _frameWork->GetAccount()->GetRecordUnfollow(self.recordType, indexPath.row, gameName, amount);
        
        if (gameType >= 120 && gameType < 200) {
            // 竞技彩
            cell.attrTitleLabel.text = titleText;
        } else {
            // 数字彩
//            if (gameName && (gameType == GameTypeJxsyxw || gameType == GameTypeSdpks || gameType == GameTypeNmgks)) {
//                gameName %= 100;
//            }
            
            NSString *appendText = gameName == 0 ? @"(不定期)" : [NSString stringWithFormat:@"(%d期)", gameName];
            
            [cell.attrTitleLabel setText:[titleText stringByAppendingString:appendText] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
                NSRange range = [mutableAttributedString.string rangeOfString:appendText];
                UIFont *littleFont = [UIFont dp_systemFontOfSize:11];
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)littleFont.fontName, littleFont.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    CFRelease(font);
                }
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] CGColor] range:range];
                return mutableAttributedString;
            }];
        }
        
        cell.attrAmtLabel.text = [NSString stringWithFormat:@"%d", amount];
    }
    
    cell.sealView.hidden = !isWined;
    cell.sealView.highlighted = projectStatus == 10;
    cell.clockView.highlighted = isWined;
    
    int projectId = 0, purchaseOrderId = 0;
    _frameWork->GetAccount()->GetRecordProjectId(self.recordType, indexPath.row, projectId, gameType, purchaseOrderId);
    
    cell.gameType = (GameTypeId)gameType;
    cell.projectId = projectId;
    cell.buyType = buyType;
    cell.purchaseOrderId = purchaseOrderId;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPBuyRecordCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    DPProjectDetailVC *viewController = [[DPProjectDetailVC alloc] init];
    [viewController setPurchaseOrderId:cell.purchaseOrderId];
    [viewController projectDetailPriojectId:cell.projectId gameType:cell.gameType pdBuyId:cell.buyType gameName:0];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - ModuleNotify

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    if (cmdId == NOTIFY_LOGIN_ACCOUNT) {
        string content;
        if (_frameWork->GetSessionContent(content) >= 0) {
            [SSKeychain setPassword:[NSString stringWithUTF8String:content.c_str()] forService:(NSString *)dp_KeychainServiceName account:(NSString *)dp_KeychainSessionAccount];
        }
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (cmdtype) {
            case ACCOUNT_REF_BUY: {
                if (ret < 0) {
                    if (ret != ERROR_CANCEL) {
                        [self.tableView.pullToRefreshView stopAnimating];
                        [self.tableView.infiniteScrollingView stopAnimating];
                        [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                    }
                } else {
                    [self.tableView.pullToRefreshView stopAnimating];
                    [self.tableView.infiniteScrollingView stopAnimating];
                    [self pvt_updateUserInfo];
                    [self.tableView reloadData];
                    [self adjudgeInfiniteView];
                    
                    self.noDataView.hidden = [self.tableView numberOfRowsInSection:0];
                }
            }
                break;
            case ACCOUNT_REF_INFO: {
                if (ret >= 0) {
                    [self pvt_updateUserInfo];
                }
            }
                break;
            default:
                break;
        }
    });
}

- (void)adjudgeInfiniteView {
    int moreData = 0;
    int count = _frameWork->GetAccount()->GetBuyRecordCount(self.recordType, moreData);
    
    self.tableView.showsInfiniteScrolling = count > 0;
    self.tableView.infiniteScrollingView.enabled = moreData;
}

- (void)pvt_updateUserInfo {
    string userName, realAmt;
    int draw, mobile, identity, coinAmt, redElpCount;
    _frameWork->GetAccount()->GetUserInfo(userName, realAmt, coinAmt, redElpCount);
    _frameWork->GetAccount()->IsUserBound(draw, mobile, identity);
    self.nameLabel.text = [NSString stringWithUTF8String:userName.c_str()];
    self.passwordIcon.highlighted = draw;
    self.mobileNoIcon.highlighted = mobile;
    self.identityIcon.highlighted = identity;
    
    self.realAmtLabel.text = realAmt.length() == 0 ? @"0" : [NSString stringWithUTF8String:realAmt.c_str()];
    self.coinAmtLabel.text = [NSString stringWithFormat:@"%d", coinAmt];
    
    self.packetAmtLabel.text = [NSString stringWithFormat:@"%d", redElpCount];
    
    int res = _account -> CanEditUserName();
    UIView *redPointView = [self.iconView dp_strongObjectForKey:dp_redPointView_key];
    if (!redPointView){
        self.iconView.userInteractionEnabled = NO;
        return;
    }else{
        self.iconView.userInteractionEnabled = res;
        redPointView.hidden = !res;
        redPointView.tag = res;
    }

}

#pragma mark - getter
- (UIView *)tabBarView {
    if (_tabBarView == nil) {
        _tabBarView = [[UIView alloc] init];
        _tabBarView.backgroundColor = [UIColor whiteColor];
    }
    return _tabBarView;
}

- (UIImageView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 158)];
        _headerView.image = dp_AccountImage(@"headerbg.png");
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 55;
    }
    return _tableView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont dp_systemFontOfSize:15];
        _nameLabel.textColor = [UIColor dp_flatWhiteColor];
    }
    return _nameLabel;
}

- (UIImageView *)passwordIcon {
    if (_passwordIcon == nil) {
        _passwordIcon = [[UIImageView alloc] initWithImage:dp_AccountImage(@"pwdnormal.png") highlightedImage:dp_AccountImage(@"pwdselect.png")];
    }
    return _passwordIcon;
}

- (UIImageView *)identityIcon {
    if (_identityIcon == nil) {
        _identityIcon = [[UIImageView alloc] initWithImage:dp_AccountImage(@"idnormal.png") highlightedImage:dp_AccountImage(@"idselect.png")];
    }
    return _identityIcon;
}

- (UIImageView *)mobileNoIcon {
    if (_mobileNoIcon == nil) {
        _mobileNoIcon = [[UIImageView alloc] initWithImage:dp_AccountImage(@"mbnormal.png") highlightedImage:dp_AccountImage(@"mbselect.png")];
    }
    return _mobileNoIcon;
}

- (UILabel *)realAmtLabel {
    if (_realAmtLabel == nil) {
        _realAmtLabel = [[UILabel alloc] init];
        _realAmtLabel.backgroundColor = [UIColor clearColor];
        _realAmtLabel.textColor = [UIColor dp_flatWhiteColor];
        _realAmtLabel.font = [UIFont dp_boldSystemFontOfSize:13];
        _realAmtLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _realAmtLabel;
}

- (UILabel *)packetAmtLabel
{
    if (_packetAmtLabel == nil) {
        _packetAmtLabel = [[UILabel alloc] init];
        _packetAmtLabel.backgroundColor = [UIColor clearColor];
        _packetAmtLabel.textColor = [UIColor dp_flatWhiteColor];
        _packetAmtLabel.font = [UIFont dp_boldSystemFontOfSize:13];
        _packetAmtLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _packetAmtLabel;
}

- (UILabel *)coinAmtLabel {
    if (_coinAmtLabel == nil) {
        _coinAmtLabel = [[UILabel alloc] init];
        _coinAmtLabel.backgroundColor = [UIColor clearColor];
        _coinAmtLabel.textColor = [UIColor dp_flatWhiteColor];
        _coinAmtLabel.font = [UIFont dp_boldSystemFontOfSize:13];
        _coinAmtLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinAmtLabel;
}
- (UIView *)noDataView
{
    if (_noDataView == nil) {
        _noDataView = [[UIView alloc]init];
        _noDataView.backgroundColor = [UIColor clearColor];
        _noDataView.userInteractionEnabled = NO;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:dp_CommonImage(@"noDataFace.png")];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:11];
        label.textColor = [UIColor dp_colorFromHexString:@"#a19e7d"];
        label.text = @"暂无数据";
        label.numberOfLines = 1;
        [_noDataView addSubview:label];
        [_noDataView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView);
            make.centerY.equalTo(_noDataView);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(_noDataView);
        }];
        
    }
    return _noDataView;
}

@end
