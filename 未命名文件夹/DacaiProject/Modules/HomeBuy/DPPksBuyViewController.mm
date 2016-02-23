//
//  DPPksBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "../../Common/View/DPNavigationTitleButton.h"
#import "../../Common/View/DPNavigationMenu.h"
#import "NotifyType.h"
#import "DPPksBuyViewController.h"
#import "FrameWork.h"
#import "DPPksBuyCell.h"
#import "DPPksHistoryTrendCell.h"
#import "DPPoker3transferVC.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPHelpWebViewController.h"
#import "DPWebViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BaseMath.h"
#import "DPDigitalCommon.h"
#import <AFNetworking.h>
#import "DPNoNetworkView.h"

#define TrendDragHeight         250
#define CellIdentifier          @"BuyCell"
#define ReusableViewIdentifier  @"BuyHeader"

#define TitleMenuContentTag     9001

static NSArray *pks_gameNames = @[ @"包选", @"对子", @"豹子", @"同花", @"顺子", @"同花顺",
                                   @"任选一", @"任选二", @"任选三", @"任选四", @"任选五", @"任选六", ];
static NSArray *pks_gameBonus = @[ @"奖金：7-535元", @"奖金：88元", @"奖金：6400元", @"奖金：90元", @"奖金：400元", @"奖金：2150元",
                                   @"奖金：5元", @"奖金：33元", @"奖金：116元", @"奖金：46元", @"奖金：22元", @"奖金：12元", ];

@interface DPPksBuyViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UITableViewDelegate,
UITableViewDataSource,UIGestureRecognizerDelegate,DPDropDownListDelegate
> {
@private
    DPNavigationTitleButton *_titleButton;
    UIView *_titleMenu;
    
    UIImageView *_headerView;
    UICollectionView *_collectionView;
    UITableView *_trendView;
    UIImageView *_bottomView;
    DPNoNetworkView *_noNetView;
    
    // header subview
    UILabel *_lastDrawLabel;
    DPPksBuyDrawView *_drawNumberView1;
    DPPksBuyDrawView *_drawNumberView2;
    DPPksBuyDrawView *_drawNumberView3;
    UIImageView *_expandImageView;
    
    UILabel *_gameNameLabel;
    UILabel *_countDownLabel;
    
    // bottom subview
    UILabel *_amountLabel;
    
    // constraint
    NSLayoutConstraint *_collectionConstraint;
    NSLayoutConstraint *_countDownConstraint;
    
    // option
    int _optionBaoxuan[PKNUMMAX];
    int _optionDuizi[PKNUMMAX];
    int _optionBaozi[PKNUMMAX];
    int _optionTonghua[PKNUMMAX];
    int _optionShunzi[PKNUMMAX];
    int _optionTonghuashun[PKNUMMAX];
    int _optionRenxuan1[PKNUMMAX];
    int _optionRenxuan2[PKNUMMAX];
    int _optionRenxuan3[PKNUMMAX];
    int _optionRenxuan4[PKNUMMAX];
    int _optionRenxuan5[PKNUMMAX];
    int _optionRenxuan6[PKNUMMAX];
    
    CPokerThree *_pksInstance;
    
    BOOL _dismissing;
}

@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong, readonly) UIView *titleMenu;

@property (nonatomic, strong, readonly) UIImageView *headerView;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) UITableView *trendView;
@property (nonatomic, strong, readonly) UIImageView *bottomView;

// header subviews
@property (nonatomic, strong, readonly) UILabel *lastDrawLabel;
@property (nonatomic, strong, readonly) DPPksBuyDrawView *drawNumberView1;
@property (nonatomic, strong, readonly) DPPksBuyDrawView *drawNumberView2;
@property (nonatomic, strong, readonly) DPPksBuyDrawView *drawNumberView3;
@property (nonatomic, strong, readonly) UIImageView *expandImageView;
@property (nonatomic, strong, readonly) UILabel *gameNameLabel;
@property (nonatomic, strong, readonly) UILabel *countDownLabel;
@property (nonatomic, strong, readonly) UILabel *amountLabel;

// constraint
@property (nonatomic, strong, readonly) NSLayoutConstraint *collectionConstraint;
@property (nonatomic, strong, readonly) NSLayoutConstraint *countDownConstraint;

//
@property (nonatomic, assign) BOOL showHistory;
@property (nonatomic, assign, readonly) int *option;

@property (nonatomic, assign, readonly) NSInteger timeInterval;
@property (nonatomic, assign) NSInteger gameName;
@property (nonatomic, strong, readonly) DPNoNetworkView *noNetView; // 无网络提示

@end

@implementation DPPksBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gameIndex = PksGameIndexRenxuan3;
        self.targetIndex = -1;
        
        _pksInstance = CFrameWork::GetInstance()->GetPokerThree();
        
        memset(_optionBaoxuan, 0, sizeof(_optionBaoxuan));
        memset(_optionDuizi, 0, sizeof(_optionDuizi));
        memset(_optionBaozi, 0, sizeof(_optionBaozi));
        memset(_optionTonghua, 0, sizeof(_optionTonghua));
        memset(_optionShunzi, 0, sizeof(_optionShunzi));
        memset(_optionTonghuashun, 0, sizeof(_optionTonghuashun));
        memset(_optionRenxuan1, 0, sizeof(_optionRenxuan1));
        memset(_optionRenxuan2, 0, sizeof(_optionRenxuan2));
        memset(_optionRenxuan3, 0, sizeof(_optionRenxuan3));
        memset(_optionRenxuan4, 0, sizeof(_optionRenxuan4));
        memset(_optionRenxuan5, 0, sizeof(_optionRenxuan5));
        memset(_optionRenxuan6, 0, sizeof(_optionRenxuan6));
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotify) name:dp_DigitalBetRefreshNofify object:nil];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (NSInteger)timeInterval {
    return g_sdpksTimeSpace;
}

- (void)refreshNotify {
    [self.collectionView reloadData];
    [self.trendView reloadData];
    [self pvt_updateDrawInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *contentView = self.view;
    
    [contentView addSubview:self.headerView];
    [contentView addSubview:self.trendView];
    [contentView addSubview:self.collectionView];
    [contentView addSubview:self.bottomView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@71);
    }];
    [self.trendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@(253));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@(UIScreen.mainScreen.bounds.size.height - 64 - 71));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.collectionView);
        make.height.equalTo(@87.5);
    }];
    
    [self pvt_navigationDidLoad];
    [self pvt_headerBuildLayout];
    [self pvt_bottomBuildLayout];
    
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHandleTap:)]];
    [self refreshNotify];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_checkNetworkStatus) name:dp_NetworkStatusCheckKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    if (!_dismissing) {
        [self.navigationController dp_applyGlobalTheme];
    }
    
    [self resignFirstResponder];
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
    
    #pragma mark - 
    int note = 0;
    if (self.targetIndex >= 0) {
        int num[PKNUMMAX];
        PKType subType;
        
        _pksInstance->GetTarget(self.targetIndex, num, subType, note);
        
        self.gameIndex = (PksGameIndex)subType;
        self.titleButton.titleText = pks_gameNames[self.gameIndex];
        
        int *option = self.option;
        for (int i = 0; i < PKNUMMAX; i++) {
            option[i] = num[i];
        }
    }
    
    [self pvt_loadAmtAndBonus:note];
    [self.collectionView reloadData];
    [self canBecomeFirstResponder];
    [self dp_checkNetworkStatus];
}
// 检查网络连接
- (void)dp_checkNetworkStatus
{
    BOOL hasNetwork = [[AFNetworkReachabilityManager sharedManager] isReachable];
    DPLog(@"net status = %d", hasNetwork);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!hasNetwork) {
            if (!self.noNetView.superview){
                [self.headerView addSubview:self.noNetView];
                [self.noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headerView).offset(- 15);
                    make.centerX.equalTo(self.headerView);
                    make.width.equalTo(@290);
                    make.height.equalTo(@60);
                }];
            }
        }else{
            [self.noNetView removeFromSuperview];
        }
    });
}
- (void)pvt_headerBuildLayout {
    UIView *contentView = self.headerView;
    
    UIView *verticalLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        view.userInteractionEnabled = NO;
        view;
    });
    UIView *horizontalLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        view.userInteractionEnabled = NO;
        view;
    });
    UIView *countDownLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.67 green:1 blue:0.41 alpha:1];
        view.userInteractionEnabled = NO;
        view;
    });
    
    [contentView addSubview:verticalLine];
    [contentView addSubview:horizontalLine];
    [contentView addSubview:countDownLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.centerX.equalTo(contentView).offset(10);
        make.width.equalTo(@1);
    }];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@4);
    }];
    [countDownLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(horizontalLine);
        make.bottom.equalTo(horizontalLine);
        make.top.equalTo(horizontalLine);
        make.width.equalTo(@0);
    }];
    
    [contentView addSubview:self.lastDrawLabel];
    [contentView addSubview:self.drawNumberView1];
    [contentView addSubview:self.drawNumberView2];
    [contentView addSubview:self.drawNumberView3];
    [contentView addSubview:self.expandImageView];
    [contentView addSubview:self.gameNameLabel];
    [contentView addSubview:self.countDownLabel];
    
    [self.lastDrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.top.equalTo(contentView).offset(7);
    }];
    [self.drawNumberView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.top.equalTo(contentView).offset(27);
    }];
    [self.drawNumberView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drawNumberView1.mas_right).offset(10);
        make.top.equalTo(contentView).offset(27);
    }];
    [self.drawNumberView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drawNumberView2.mas_right).offset(10);
        make.top.equalTo(contentView).offset(27);
    }];
    [self.expandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(verticalLine.mas_left).offset(-10);
        make.top.equalTo(contentView).offset(35);
    }];
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine).offset(35);
        make.top.equalTo(contentView).offset(7);
    }];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(22);
    }];
    
    [countDownLine.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == countDownLine && obj.firstAttribute == NSLayoutAttributeWidth) {
            _countDownConstraint = obj;
        }
    }];
}

- (void)pvt_bottomBuildLayout {
    UIView *contentView = self.bottomView;
    
    UIButton *deleteButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:dp_PokerThreeImage(@"delete.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onCleanup) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *submitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:dp_PokerThreeImage(@"bet.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIImageView *amountView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"amtbg.png")];
        imageView;
    });
    
    [contentView addSubview:deleteButton];
    [contentView addSubview:submitButton];
    [contentView addSubview:amountView];
    [contentView addSubview:self.amountLabel];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(3);
        make.centerY.equalTo(submitButton);
    }];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-3);
        make.bottom.equalTo(contentView).offset(-1);
    }];
    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@124);
        make.height.equalTo(@21);
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(amountView);
    }];
}

- (void)pvt_navigationDidLoad {
    UIColor *tintColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];

    if (self.isTransfer || self.targetIndex >= 0 || self.navigationController.viewControllers.count > 2) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_QuickThreeImage(@"q3transBack.png") title:nil tintColor:tintColor target:self action:@selector(pvt_onHome)];
    } else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"ks_home.png") title:nil tintColor:tintColor target:self action:@selector(pvt_onHome)];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"ks_more.png") title:nil tintColor:tintColor target:self action:@selector(pvt_onMore)];
    self.navigationItem.titleView = self.titleButton;
    
    [self.titleButton setTitleText:pks_gameNames[self.gameIndex]];
    [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];
}

#pragma mark - event

-(BOOL)pvt_hasSelected{
    
    BOOL hasSelected = NO ;
    
    
    if (CMathHelper::IsZero(_optionBaoxuan, sizeof(_optionBaoxuan)) && CMathHelper::IsZero(_optionDuizi, sizeof(_optionDuizi)) &&CMathHelper::IsZero(_optionBaozi, sizeof(_optionBaozi))&&CMathHelper::IsZero(_optionTonghua, sizeof(_optionTonghua))&& CMathHelper::IsZero(_optionShunzi, sizeof(_optionShunzi)) && CMathHelper::IsZero(_optionTonghuashun, sizeof(_optionTonghuashun)) && CMathHelper::IsZero(_optionRenxuan1, sizeof(_optionRenxuan1)) && CMathHelper::IsZero(_optionRenxuan2, sizeof(_optionRenxuan2)) && CMathHelper::IsZero(_optionRenxuan3, sizeof(_optionRenxuan3)) && CMathHelper::IsZero(_optionRenxuan4, sizeof(_optionRenxuan4)) && CMathHelper::IsZero(_optionRenxuan5, sizeof(_optionRenxuan5)) && CMathHelper::IsZero(_optionRenxuan6, sizeof(_optionRenxuan6))) {
        hasSelected = NO ;
    }else
        hasSelected = YES ;

    
    return hasSelected ;
}

- (void)pvt_onHome {
    if (self.isTransfer) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.navigationController.viewControllers.count == 2) {
//        int note = _pksInstance->NotesCalculate(self.option, (PKType)self.gameIndex);
        if (![self pvt_hasSelected]) {
            _dismissing = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                _dismissing = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
        _dismissing = NO;
        [self.navigationController popToViewController:viewController animated:YES];
    }
}

- (void)pvt_onMore {
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [coverView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTapMore:)];
        tap.delegate = self;
        tap;
    })];
    [self.view.window addSubview:coverView];
    
    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:@[@"开奖公告", @"玩法介绍", @"帮助"]];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view);
    }];
    
}

- (void)pvt_onTapMore:(UITapGestureRecognizer *)tapGestureRecognizer {
    [tapGestureRecognizer.view removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    DPDropDownList *dropDownList = (id)[gestureRecognizer.view.subviews firstObject];
    if ([touch.view isDescendantOfView:dropDownList]) {
        return NO;
    }
    return YES;
}

#pragma mark - DPDropDownListDelegate
- (void)dropDownList:(DPDropDownList *)dropDownList selectedAtIndex:(NSInteger)index {
    [dropDownList.superview removeFromSuperview];
    
    UIViewController *viewController;
    
    switch (index) {
        case 0: {   // 开奖公告
            viewController = ({
                DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
                viewController.gameType = GameTypeSdpks;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        }
            break;
        case 1: {   // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeSdpks)]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO ;

                viewController;
            });
        }
            break;
        case 2: {   // 帮助
            viewController = [[DPHelpWebViewController alloc] init];
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pvt_onNavTitle {
    [self pvt_titleMenuAt:self.gameIndex];
    [self.titleButton turnArrow];
    [self.navigationController.view addSubview:self.titleMenu];
    [UIView animateWithDuration:0.2 animations:^{
        self.titleMenu.alpha = 1;
    }];
}

- (void)pvt_titleMenuAt:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)[self.titleMenu viewWithTag:TitleMenuContentTag];
    
    for (UIImageView *view in imageView.subviews) {
        view.highlighted = view.tag == index;
        
        for (UILabel *label in view.subviews) {
            label.highlighted = view.tag == index;
        }
    }
}

- (void)pvt_onNavDropDown:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.view.tag >= 0) {
        [self pvt_titleMenuAt:tapGestureRecognizer.view.tag];
        
        [self setGameIndex:(PksGameIndex)tapGestureRecognizer.view.tag];
        [self.titleButton setTitleText:pks_gameNames[tapGestureRecognizer.view.tag]];
        [self.collectionView reloadData];
        [self.collectionView dp_scrollToTop];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.titleMenu.alpha = 0;
    } completion:^(BOOL finished) {
        [self.titleMenu removeFromSuperview];
    }];
    
    [self.titleButton restoreArrow];
}

#pragma mark- 摇一摇

//摇一摇功能
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event

{
    if(motion == UIEventSubtypeMotionShake)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self pvt_onShake];
    }
}


- (void)pvt_onShake {
    int red[PKNUMMAX] = {0};
    switch (self.gameIndex) {
        case PksGameIndexBaoxuan:
        {
            [self partRandom:1 total:5 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionBaoxuan[i]=red[i];
            }
        }
            break;
        case PksGameIndexDuizi:
        {
            [self partRandom:1 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionDuizi[i]=red[i];
            }
        }

            break;
        case PksGameIndexBaozi:
        {
            [self partRandom:1 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionBaozi[i]=red[i];
            }
        }

            break;
        case PksGameIndexTonghua:
        {
            [self partRandom:1 total:4 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionTonghua[i]=red[i];
            }
        }

           break;
        case PksGameIndexShunzi:
        {
            [self partRandom:1 total:12 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionShunzi[i]=red[i];
            }
        }

            break;
        case PksGameIndexTonghuashun:
        {
            [self partRandom:1 total:4 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionTonghuashun[i]=red[i];
            }
        }

            break;
        case PksGameIndexRenxuan1:
        {
            [self partRandom:1 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionRenxuan1[i]=red[i];
            }
        }

            break;
        case PksGameIndexRenxuan2:
        {
            [self partRandom:2 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionRenxuan2[i]=red[i];
            }
        }

            break;
        case PksGameIndexRenxuan3:
        {
            [self partRandom:3 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionRenxuan3[i]=red[i];
            }
        }

            break;
        case PksGameIndexRenxuan4:
        {
            [self partRandom:4 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionRenxuan4[i]=red[i];
            }
        }

            break;
        case PksGameIndexRenxuan5:
        {
            [self partRandom:5 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionRenxuan5[i]=red[i];
            }
        }

            break;
        case PksGameIndexRenxuan6:
        {
            [self partRandom:6 total:13 target2:red];
            for (int i=0; i<PKNUMMAX; i++) {
                _optionRenxuan6[i]=red[i];
            }
        }

            break;
            
            default:
            break;
    }
    [self.collectionView reloadData];
    int note = 0;
    note = _pksInstance->NotesCalculate(red, (PKType)self.gameIndex);
    [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
    
}
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random()% ((total - i)== 0?1:(total-i));
        target[[array[x] integerValue]] = 1;
        [array removeObjectAtIndex:x];
    }
}
- (void)pvt_onCleanup {
    memset(self.option, 0, sizeof(int) * PKNUMMAX);
    [self.collectionView reloadData];
    [self pvt_loadAmtAndBonus:0];
}

- (void)pvt_onSubmit {
    
    int note = _pksInstance->NotesCalculate(self.option, (PKType)self.gameIndex);
    if (note<1) {
        [[DPToast makeText:@"请至少选择一注"] show];
        return;
    }
    
    int ret = -1;
    
    if (self.targetIndex >= 0) {
        ret = _pksInstance->ModifyTarget(self.targetIndex, self.option, (PKType)self.gameIndex);
    } else {
        ret = _pksInstance->AddTarget(self.option, (PKType)self.gameIndex);
    }
    
    if (ret >= 0) {
        [self.navigationController popViewControllerAnimated:YES];
        
        self.targetIndex = -1;
        memset(_optionBaoxuan, 0, sizeof(_optionBaoxuan));
        memset(_optionDuizi, 0, sizeof(_optionDuizi));
        memset(_optionBaozi, 0, sizeof(_optionBaozi));
        memset(_optionTonghua, 0, sizeof(_optionTonghua));
        memset(_optionShunzi, 0, sizeof(_optionShunzi));
        memset(_optionTonghuashun, 0, sizeof(_optionTonghuashun));
        memset(_optionRenxuan1, 0, sizeof(_optionRenxuan1));
        memset(_optionRenxuan2, 0, sizeof(_optionRenxuan2));
        memset(_optionRenxuan3, 0, sizeof(_optionRenxuan3));
        memset(_optionRenxuan4, 0, sizeof(_optionRenxuan4));
        memset(_optionRenxuan5, 0, sizeof(_optionRenxuan5));
        memset(_optionRenxuan6, 0, sizeof(_optionRenxuan6));
    }else{
        [[DPToast makeText:@"提交失败"] show];
    }
}

- (void)pvt_onHandleTap:(UITapGestureRecognizer *)tapRecognizer {
    if ([tapRecognizer locationInView:self.headerView].x < (CGRectGetWidth(self.headerView.frame) / 2 + 10)) {
        if (self.showHistory) {
            self.collectionConstraint.constant = 0;
        } else {
            self.collectionConstraint.constant = TrendDragHeight;
        }
        
        [self.view setNeedsLayout];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.showHistory = self.collectionConstraint.constant == TrendDragHeight;
            [self pvt_turnArrow];
        }];
    }
}

- (void)pvt_turnArrow {
    if (self.showHistory) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.expandImageView.transform = CGAffineTransformMakeRotation(180 * (M_PI / 180.0f));
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.expandImageView.transform = CGAffineTransformMakeRotation(0);
        [UIView commitAnimations];
    }
}

- (void)pvt_loadAmtAndBonus:(NSInteger)note {
    self.amountLabel.text = [NSString stringWithFormat:@"共%d注，%d元", note, note * 2];
}

#pragma mark - collection view's delegate and data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.gameIndex) {
        case PksGameIndexBaoxuan:
            return section == 0 ? 3 : 2;
        case PksGameIndexDuizi:
        case PksGameIndexBaozi:
            return 13;
        case PksGameIndexTonghua:
            return 4;
        case PksGameIndexShunzi:
            return 12;
        case PksGameIndexTonghuashun:
            return 4;
        case PksGameIndexRenxuan1:
        case PksGameIndexRenxuan2:
        case PksGameIndexRenxuan3:
        case PksGameIndexRenxuan4:
        case PksGameIndexRenxuan5:
        case PksGameIndexRenxuan6:
            return 13;
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPPksBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell.superview == nil) {
        [cell buildLayout];
    }
    
    NSInteger idx = indexPath.row + (indexPath.section == 0 ? 0 : 3);
    NSString *imageName = nil;
    NSString *selectedImageName = nil;
    int *option = self.option;
    int miss[PKNUMMAX] = { 0 };
    
    if (self.gameIndex == PksGameIndexBaoxuan) {
        [cell.contentView sendSubviewToBack:cell.pokerView];
    } else {
        [cell.contentView sendSubviewToBack:cell.circleView];
    }
    
    switch (self.gameIndex) {
        case PksGameIndexBaoxuan:
            imageName = [NSString stringWithFormat:@"Baoxuan/%d.png", idx + 1];
            selectedImageName = @"select_big_1.png";
            break;
        case PksGameIndexDuizi:
            imageName = [NSString stringWithFormat:@"Duizi/%d.png", idx + 1];
            selectedImageName = @"select_little_2.png";
            break;
        case PksGameIndexBaozi:
            imageName = [NSString stringWithFormat:@"Baozi/%d.png", idx + 1];
            selectedImageName = @"select_little_3.png";
            break;
        case PksGameIndexTonghua:
            imageName = [NSString stringWithFormat:@"Tonghua/%d.png", idx + 1];
            selectedImageName = @"select_big_3.png";
            break;
        case PksGameIndexShunzi:
            imageName = [NSString stringWithFormat:@"Shunzi/%d.png", idx + 1];
            selectedImageName = @"select_little_3.png";
            break;
        case PksGameIndexTonghuashun:
            imageName = [NSString stringWithFormat:@"Tonghua/%d.png", idx + 1];
            selectedImageName = @"select_big_3.png";
            break;
        case PksGameIndexRenxuan1:
        case PksGameIndexRenxuan2:
        case PksGameIndexRenxuan3:
        case PksGameIndexRenxuan4:
        case PksGameIndexRenxuan5:
        case PksGameIndexRenxuan6:
            imageName = [NSString stringWithFormat:@"Renxuan/%d.png", idx + 1];
            selectedImageName = @"select_little_1.png";
            break;
        default:
            break;
    }
    _pksInstance->GetMiss((PKType)self.gameIndex, miss);
    int _maxMiss = 0 ;
    for (int i= 0; i<PKNUMMAX; i++) {
        if (miss[i] >= _maxMiss) {
            _maxMiss = miss[i] ;
        }
    }
    
    cell.pokerView.image = dp_PokerThreeImage(imageName);
    cell.circleView.image = dp_PokerThreeImage(selectedImageName);
    cell.circleView.hidden = cell.chipView.hidden = option[idx] == 0;
    if(CMathHelper::IsZero(miss, sizeof(miss))){
        cell.missLabel.text =@"-" ;
        cell.missLabel.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:1 alpha:1];

    }else{
        cell.missLabel.text = [NSString stringWithFormat:@"%d", miss[idx]];
        if (miss[idx] == _maxMiss) {
            cell.missLabel.textColor =[UIColor dp_colorFromRGB:0xFEE939 ] ;
        }else
            cell.missLabel.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:1 alpha:1];

    }
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.gameIndex == PksGameIndexBaoxuan ? 2 : 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = indexPath.row + (indexPath.section == 0 ? 0 : 3);
    int *option = self.option;
    option[idx] = !option[idx];
    
    DPPksBuyCell *cell = (DPPksBuyCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.circleView.hidden = cell.chipView.hidden = option[idx] == 0;
    
    int note = 0;
    note = _pksInstance->NotesCalculate(option, (PKType)self.gameIndex);
    [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
}


// UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameIndex) {
        case PksGameIndexBaoxuan:
            return CGSizeMake(100, 125);
        case PksGameIndexDuizi:
        case PksGameIndexBaozi:
            return CGSizeMake(75, 80);
        case PksGameIndexTonghua:
            return CGSizeMake(150, 140);
        case PksGameIndexShunzi:
            return CGSizeMake(75, 80);
        case PksGameIndexTonghuashun:
            return CGSizeMake(150, 140);
        case PksGameIndexRenxuan1:
        case PksGameIndexRenxuan2:
        case PksGameIndexRenxuan3:
        case PksGameIndexRenxuan4:
        case PksGameIndexRenxuan5:
        case PksGameIndexRenxuan6:
            return CGSizeMake(75, 80);
        default:
            return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return (self.gameIndex == PksGameIndexBaoxuan && section == 1) ? UIEdgeInsetsMake(0, 60, 0, 60) : UIEdgeInsetsMake(0, 10, 0, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    DPPksBuyHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ReusableViewIdentifier forIndexPath:indexPath];
    if (headerView.superview == nil) {
        [headerView buildLayout];
        [headerView.shakeButton addTarget:self action:@selector(pvt_onShake) forControlEvents:UIControlEventTouchUpInside];
    }
    
    headerView.shakeButton.hidden = indexPath.section != 0;
    
    switch (self.gameIndex) {
        case PksGameIndexBaoxuan:
            headerView.bonusLabel.text = @"包选-奖金7~535元";
            break;
        case PksGameIndexDuizi:
            headerView.bonusLabel.text = @"对子单选-奖金88元";
            break;
        case PksGameIndexBaozi:
            headerView.bonusLabel.text = @"豹子单选-奖金6400元";
            break;
        case PksGameIndexTonghua:
            headerView.bonusLabel.text = @"同花单选-奖金90元";
            break;
        case PksGameIndexShunzi:
            headerView.bonusLabel.text = @"顺子单选-奖金400元";
            break;
        case PksGameIndexTonghuashun:
            headerView.bonusLabel.text = @"同花顺单选-奖金2150元";
            break;
        case PksGameIndexRenxuan1:
            headerView.bonusLabel.text = @"任选一-奖金5元";
            break;
        case PksGameIndexRenxuan2:
            headerView.bonusLabel.text = @"任选二-奖金33元";
            break;
        case PksGameIndexRenxuan3:
            headerView.bonusLabel.text = @"任选三-奖金116元";
            break;
        case PksGameIndexRenxuan4:
            headerView.bonusLabel.text = @"任选四-奖金46元";
            break;
        case PksGameIndexRenxuan5:
            headerView.bonusLabel.text = @"任选五-奖金22元";
            break;
        case PksGameIndexRenxuan6:
            headerView.bonusLabel.text = @"任选六-奖金12元";
            break;
        default:
            break;
    }
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return (section == 0) ? CGSizeMake(320, 40) : CGSizeZero;
}

// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isTracking) {
        return;
    }
    
    if (self.collectionConstraint.constant - scrollView.contentOffset.y < 0) {
        self.collectionConstraint.constant = 0;
    } else if (self.collectionConstraint.constant - scrollView.contentOffset.y > TrendDragHeight) {
        self.collectionConstraint.constant = TrendDragHeight;
        scrollView.contentOffset = CGPointZero;
    } else {
        self.collectionConstraint.constant = self.collectionConstraint.constant - scrollView.contentOffset.y;
        scrollView.contentOffset = CGPointZero;
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.showHistory) {
        self.collectionConstraint.constant = (self.collectionConstraint.constant < TrendDragHeight - 20) ? 0 : TrendDragHeight;
    } else {
        self.collectionConstraint.constant = (self.collectionConstraint.constant > 20) ? TrendDragHeight : 0;
    }
    
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.showHistory = self.collectionConstraint.constant == TrendDragHeight;
        [self pvt_turnArrow];
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.showHistory) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }
}

#pragma mark - table view's data source and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPPksHistoryTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPPksHistoryTrendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell buildLayout];
    }
    int name = 0, type[3] = { 0 }, result[3] = { 0 };
    static NSString *pks_Types[] = {@"", @"♦", @"♥", @"♣", @"♠"};
    static NSString *pks_Names[] = {@"", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"};
    int ret = _pksInstance->GetHistory(indexPath.row, name, type, result);
    name %= 100;
    if (ret >= 0) {
        cell.nameLabel.text = [NSString stringWithFormat:@"%02d期：", name];
        if (ret == 0) {
            cell.waitLabel.hidden = YES ;
            cell.pokerLabel1.hidden = NO ;
            cell.pokerLabel2.hidden = NO ;
            cell.pokerLabel3.hidden = NO ;
        
            cell.pokerLabel1.text = [NSString stringWithFormat:@" %@ %@", pks_Types[type[0]], pks_Names[result[0]]];
            cell.pokerLabel2.text = [NSString stringWithFormat:@" %@ %@", pks_Types[type[1]], pks_Names[result[1]]];
            cell.pokerLabel3.text = [NSString stringWithFormat:@" %@ %@", pks_Types[type[2]], pks_Names[result[2]]];
            cell.pokerLabel1.textColor = (type[0] <= 2) ? [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1] : [UIColor dp_flatBlackColor];
            cell.pokerLabel2.textColor = (type[1] <= 2) ? [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1] : [UIColor dp_flatBlackColor];
            cell.pokerLabel3.textColor = (type[2] <= 2) ? [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1] : [UIColor dp_flatBlackColor];
        } else {
            cell.waitLabel.hidden = NO ;
            cell.pokerLabel1.hidden = YES ;
            cell.pokerLabel2.hidden = YES ;
            cell.pokerLabel3.hidden = YES ;
        }
    }
    
    return cell;
}

#pragma mark - Notify

- (void)pvt_updateDrawInfo {
    static NSString *pks_Names[] = {@"", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"};
    int gameName = 0, type[3], result[3];
    string endTime;
    
    int ret = _pksInstance->GetHistory(0, gameName, type, result);
    gameName %= 100;
    if(gameName == 0){ //无数据时
        self.drawNumberView1.type = 5;
        self.drawNumberView2.type = 5;
        self.drawNumberView3.type = 5;

        return ;
    }
    
    if (ret == 0) {
        self.lastDrawLabel.text = [NSString stringWithFormat:@"%02d期开奖: %@ %@ %@", gameName, pks_Names[result[0]], pks_Names[result[1]], pks_Names[result[2]]];
        self.drawNumberView1.text = pks_Names[result[0]];
        self.drawNumberView2.text = pks_Names[result[1]];
        self.drawNumberView3.text = pks_Names[result[2]];
        self.drawNumberView1.type = type[0];
        self.drawNumberView2.type = type[1];
        self.drawNumberView3.type = type[2];
    } else {
        self.lastDrawLabel.text = [NSString stringWithFormat:@"%02d期开奖中..", gameName];
        self.drawNumberView1.type = 5;
        self.drawNumberView2.type = 5;
        self.drawNumberView3.type = 5;
    }
    
    ret = _pksInstance->GetInfo(gameName, endTime);
    gameName %= 100;
    if (ret >= 0) {
//        NSDate *endDate = [NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
//        self.timeInterval = [endDate timeIntervalSinceDate:[NSDate dp_date]];
        self.gameName = gameName;
        if (self.timeInterval > 0) {
            self.gameNameLabel.text = [NSString stringWithFormat:@"距%02d期截止：", gameName];
            int hours = ((int)self.timeInterval) / 3600;
            int mins = (((int)self.timeInterval) - 3600 * hours) / 60;
            int seconds = ((int)self.timeInterval) - 3600 * hours - 60 * mins;
            if(hours < 1){
                self.countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d",mins,seconds];
            }else{
                self.countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins,seconds];//@"05:29";
            }

            
        } else {
            self.gameNameLabel.text = [NSString stringWithFormat:@"%02d期已截止..", gameName];
            self.countDownLabel.text = nil;
        }
    }
}

- (void)pvt_reloadTimer {
    
    if (self.timeInterval == 8) {
        _pksInstance->TimeOut();
    }
    
    if (self.gameName == 0) {//无数据时
        return ;
    }
    
    if (self.timeInterval > 0) {
        self.gameNameLabel.text = [NSString stringWithFormat:@"距%02d期截止：", self.gameName];
        int hours = ((int)self.timeInterval) / 3600;
        int mins = (((int)self.timeInterval) - 3600 * hours) / 60;
        int seconds = ((int)self.timeInterval) - 3600 * hours - 60 * mins;
        if(hours < 1){
            self.countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d",mins,seconds];
        }else{
            self.countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins,seconds];//@"05:29";
        }
        self.countDownConstraint.constant = MIN(1, self.timeInterval / 600.0) * (kScreenWidth / 2 - 10);
    } else {
        self.gameNameLabel.text = [NSString stringWithFormat:@"%02d期已截止..", self.gameName];
        self.countDownLabel.text = nil;
        self.countDownConstraint.constant = 0;
    }
    
    [self.countDownConstraint.firstItem setNeedsLayout];
    [self.countDownConstraint.firstItem setNeedsUpdateConstraints];
    [self.countDownConstraint.firstItem updateConstraintsIfNeeded];
    [self.countDownConstraint.firstItem layoutIfNeeded];
}

#pragma mark - getter
- (DPNoNetworkView *)noNetView
{
    if (_noNetView == nil) {
        _noNetView = [[DPNoNetworkView alloc]initWithTapBlock:^{
            DPWebViewController *webView = [[DPWebViewController alloc]init];
            webView.title = @"网络设置";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
            NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSURL *url = [[NSBundle mainBundle] bundleURL];
            [webView.webView loadHTMLString:str baseURL:url];
            UINavigationController *navCtrl = [UINavigationController dp_controllerWithRootViewController:webView];
            [self presentViewController:navCtrl animated:YES completion:nil];
        }];
    }
    return _noNetView;
}
- (UIImageView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"topbg.png")];
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"bg.png")];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
        
        [_collectionView registerClass:[DPPksBuyCell class] forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerClass:[DPPksBuyHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewIdentifier];
    }
    return _collectionView;
}

- (UITableView *)trendView {
    if (_trendView == nil) {
        _trendView = [[UITableView alloc] init];
        _trendView.delegate = self;
        _trendView.dataSource = self;
        _trendView.backgroundColor = [UIColor clearColor];
        _trendView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _trendView.allowsSelection = NO;
        _trendView.rowHeight = 25;
        _trendView.backgroundView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"trendbg.png")];
    }
    return _trendView;
}

- (UIImageView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"bottombg.png")];
        _bottomView.userInteractionEnabled = YES;
    }
    return _bottomView;
}

- (NSLayoutConstraint *)collectionConstraint {
    if (_collectionConstraint == nil) {
        for (int i = 0; i < self.view.constraints.count; i++) {
            NSLayoutConstraint *constraint = self.view.constraints[i];
            if (constraint.firstItem == self.collectionView && constraint.firstAttribute == NSLayoutAttributeTop) {
                _collectionConstraint = constraint;
                break;
            }
        }
    }
    return _collectionConstraint;
}

- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _titleButton.titleColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];
    }
    return _titleButton;
}

- (UIView *)titleMenu {
    if (_titleMenu == nil) {
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:12];
        
        UIView *backgroudView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
        backgroudView.backgroundColor = [UIColor clearColor];
        backgroudView.tag = -1;
        backgroudView.alpha = 0;
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                                                     CGRectGetHeight(self.navigationController.view.frame) - CGRectGetHeight(self.view.frame),
                                                                     CGRectGetWidth(self.view.frame),
                                                                     CGRectGetHeight(self.view.frame))];
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        coverView.tag = -1;
        coverView.userInteractionEnabled = NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(coverView.frame),
                                                                               CGRectGetMinY(coverView.frame),
                                                                               CGRectGetWidth(coverView.frame),
                                                                               250)];
        imageView.userInteractionEnabled = YES;
        imageView.image = dp_PokerThreeImage(@"dropdownbg.png");
        imageView.tag = TitleMenuContentTag;
        
        // 95, 45
        for (int i = 0; i < 12; i++) {
            UIImageView *view = [[UIImageView alloc] init];
            [view setUserInteractionEnabled:YES];
            [view setTag:i];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavDropDown:)]];
            [view setImage:dp_PokerThreeImage(@"dropunselected.png")];
            [view setHighlightedImage:dp_PokerThreeImage(@"dropselected.png")];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:0.98 green:0.64 blue:0.15 alpha:1];
            label.highlightedTextColor = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:1];
            label.font = [UIFont dp_systemFontOfSize:15];
            label.text = pks_gameNames[i];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            UILabel *subLabel = [[UILabel alloc] init];
            subLabel.backgroundColor = [UIColor clearColor];
            subLabel.textColor = [UIColor colorWithRed:0.74 green:0.51 blue:0.22 alpha:1];
            subLabel.highlightedTextColor = [UIColor colorWithRed:0.93 green:0.66 blue:0.33 alpha:1];
            subLabel.font = [UIFont dp_systemFontOfSize:12];
            subLabel.text = pks_gameBonus[i];
            subLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:subLabel];
            
            [view addSubview:label];
            [view addSubview:subLabel];
            [imageView addSubview:view];
            [views addObject:view];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.bottom.equalTo(view.mas_centerY);
            }];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.top.equalTo(view.mas_centerY);
            }];
        }
        
        [views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@95);
                make.height.equalTo(@50);
            }];
        }];
        for (int i = 0; i < 4; i++) {
            UIView *view1 = views[i * 3];
            UIView *view2 = views[i * 3 + 1];
            UIView *view3 = views[i * 3 + 2];
            
            [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView);
            }];
            [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view2.mas_left).offset(-8);
                make.top.equalTo(view2);
            }];
            [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view2.mas_right).offset(8);
                make.top.equalTo(view2);
            }];
        }
        
        UIView *view1 = views[0 * 3 + 1];
        UIView *view2 = views[1 * 3 + 1];
        UIView *view3 = views[2 * 3 + 1];
        UIView *view4 = views[3 * 3 + 1];
        
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(8);
        }];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(63);
        }];
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(130);
        }];
        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(185);
        }];
        
        [backgroudView addSubview:coverView];
        [backgroudView addSubview:imageView];
        [backgroudView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavDropDown:)]];
        
        _titleMenu = backgroudView;
    }
    return _titleMenu;
}

- (UILabel *)lastDrawLabel {
    if (_lastDrawLabel == nil) {
        _lastDrawLabel = [[UILabel alloc] init];
        _lastDrawLabel.backgroundColor = [UIColor clearColor];
        _lastDrawLabel.text = @"--期开奖中.." ;
        _lastDrawLabel.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:1 alpha:1];
        _lastDrawLabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _lastDrawLabel;
}

- (DPPksBuyDrawView *)drawNumberView1 {
    if (_drawNumberView1 == nil) {
        _drawNumberView1 = [[DPPksBuyDrawView alloc] init];
    }
    return _drawNumberView1;
}

- (DPPksBuyDrawView *)drawNumberView2 {
    if (_drawNumberView2 == nil) {
        _drawNumberView2 = [[DPPksBuyDrawView alloc] init];
    }
    return _drawNumberView2;
}

- (DPPksBuyDrawView *)drawNumberView3 {
    if (_drawNumberView3 == nil) {
        _drawNumberView3 = [[DPPksBuyDrawView alloc] init];
    }
    return _drawNumberView3;
}

- (UILabel *)gameNameLabel {
    if (_gameNameLabel == nil) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.backgroundColor = [UIColor clearColor];
        _gameNameLabel.text = @"--期已截止..";
        _gameNameLabel.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:1 alpha:1];
        _gameNameLabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _gameNameLabel;
}

- (UILabel *)countDownLabel {
    if (_countDownLabel == nil) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.backgroundColor = [UIColor clearColor];
        _countDownLabel.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:1 alpha:1];
        _countDownLabel.font = [UIFont fontWithName:@"DigifaceWide" size:35];
        _countDownLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _countDownLabel;
}

- (NSLayoutConstraint *)countDownConstraint {
    return _countDownConstraint;
}

- (UIImageView *)expandImageView {
    if (_expandImageView == nil) {
        _expandImageView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"expandarrow.png")];
    }
    return _expandImageView;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.backgroundColor = [UIColor clearColor];
        _amountLabel.textColor = [UIColor colorWithRed:1 green:0.96 blue:0.35 alpha:1];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.font = [UIFont dp_boldSystemFontOfSize:12];
    }
    return _amountLabel;
}

- (int *)option {
    switch (self.gameIndex) {
        case PksGameIndexBaoxuan:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionBaoxuan, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
            return _optionBaoxuan;
        }
        case PksGameIndexDuizi:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionDuizi, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
            return _optionDuizi;
        }
        case PksGameIndexBaozi:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionBaozi, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionBaozi;
        case PksGameIndexTonghua:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionTonghua, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionTonghua;
        case PksGameIndexShunzi:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionShunzi, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionShunzi;
        case PksGameIndexTonghuashun:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionTonghuashun, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionTonghuashun;
        case PksGameIndexRenxuan1:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionRenxuan1, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionRenxuan1;
        case PksGameIndexRenxuan2:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionRenxuan2, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionRenxuan2;
        case PksGameIndexRenxuan3:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionRenxuan3, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionRenxuan3;
        case PksGameIndexRenxuan4:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionRenxuan4, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionRenxuan4;
        case PksGameIndexRenxuan5:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionRenxuan5, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionRenxuan5;
        case PksGameIndexRenxuan6:
        {
            int note = 0;
            note = _pksInstance->NotesCalculate(_optionRenxuan6, (PKType)self.gameIndex);
            [self pvt_loadAmtAndBonus:note >= 0 ? note : 0];
        }
            return _optionRenxuan6;
        default:
            DPAssert(NO);
            return nil;
    }
    
}

@end
