//
//  DPQuick3LotteryVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-4.
//  Copyright (c) 2014年 dacai. All rights reserved.

#import "FrameWork.h"
#import <SevenSwitch/SevenSwitch.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "../../Common/View/DPNavigationTitleButton.h"
#import "../../Common/View/DPNavigationMenu.h"
#import "DPQuick3LotteryVC.h"
#import "DPQuick3transferVC.h"
#import "DPHistoryTendencyCell.h"
#import "DPButtonCollectionCell.h"
#import "DPQuick3SectionView.h"
#import "NSDate+DPAdditions.h"
#import "NotifyType.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"
#import <MSWeakTimer/MSWeakTimer.h>
#import "DPDigitalCommon.h"
#import <AFNetworking.h>
#import "DPNoNetworkView.h"
#define quickButtonTag 1100
#define TrendDragHeight 250
#define TitleMenuContentTag 9001
static NSArray *Q3TypeNames = @[ @"和值", @"对子", @"豹子", @"顺子", @"二不同号", @"三不同号" ];
static NSArray *Q3BonusTypeNames = @[ @"奖金:9-240元", @"奖金:15-80元", @"奖金:40-240元", @"奖金:10-40元", @"奖金:8元", @"奖金:10-40元" ];
static int counterNumberBonus[6][3] = {{1, 3, 5}, {1, 1, 5}, {2, 2, 2}, {1, 2, 3}, {1, 3}, {1, 2, 5}};
// 和值投注数据
static int counterNumberTotal[4][4] = {{3, 4, 5, 6}, {7, 8, 9, 10}, {11, 12, 13, 14}, {15, 16, 17, 18}};
static int counterNumberTotalAmount[4][4] = {{240, 80, 40, 25}, {16, 12, 10, 9}, {9, 10, 12, 16}, {25, 40, 80, 240}};

// 二同号投注数据
static int counterNumberSame2[5][6] = {{112, 113, 114, 115, 116, 122}, {223, 224, 225, 226, 133, 233}, {334, 335, 336, 144, 244, 344}, {445, 446, 155, 255, 355, 455}, {556, 166, 266, 366, 466, 566}};
static NSString *counterNumberSame2More[6] = {@"11*", @"22*", @"33*", @"44*", @"55*", @"66*"};

// 三同号投注数据
static int counterNumberSame3[2][3] = {{111, 222, 333}, {444, 555, 666}};
// 顺子投注数据
static int counterNumberShunzi[5] = {123, 234, 345, 456};
// 二不同投注数据
static int counterNumberDifferent2[15] = {12, 13, 14, 15, 16, 23, 24, 25, 26, 34, 35, 36, 45, 46, 56};
// 三不同投注数据
static int counterNumberDifferent3[20] = {123, 124, 125, 126, 134, 135, 136, 145, 146, 156, 234, 235, 236, 245, 246, 256, 345, 346, 356, 456};

@interface DPQuick3LotteryVC () <DPNavigationMenuDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, DPPk3ButtonDelegate, DPDropDownListDelegate, UIGestureRecognizerDelegate> {
@private
    CQuickThree *_CQTInstance;
    UIView *_titleMenu;
    DPNavigationTitleButton *_titleButton;
    UICollectionView *_collectionView;
    NSLayoutConstraint *_countDownConstraint;
    DPNoNetworkView *_noNetView;
    int _hezhi[48];
    int _duizi[108];
    int _baozi[21];
    int _shunzi[5 * 3];
    int _different2[15 * 3];
    int _different3[21 * 3];
    int _maxMiss;

    BOOL _dissmissing;
}

@property (nonatomic, strong) UILabel *zhushuLabel;
@property (nonatomic, strong, readonly) DPNavigationMenu *titleMenu;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong) UIButton *jeton2;               // 筹码2元
@property (nonatomic, strong) UIButton *jeton10;              // 筹码10元
@property (nonatomic, strong) UIButton *jeton20;              // 筹码20元
@property (nonatomic, strong) UIButton *jeton50;              // 筹码50元
@property (nonatomic, strong) UIButton *jeton100;             // 筹码100元
@property (nonatomic, strong) NSString *curJetonAddImageName; // 筹码飞入图片名称
@property (nonatomic, assign) CGFloat curJetonAddCenterX;     // 筹码飞入图片 中心X

@property (nonatomic, assign) CounterNumberType curCounterNumberType;                // 当前筹码 类型
@property (nonatomic, strong) NSMutableArray *bonusImageAry;                         //开奖号码
@property (nonatomic, strong) UITableView *historyTableView;                         //历史走势
@property (nonatomic, strong) UICollectionView *collectionView;                      //投注界面
@property (nonatomic, strong) UILabel *bonusLabel, *rightIssuelabel, *deadLineLabel; //开奖公告，倒计时
@property (nonatomic, assign) NSInteger timeSpace;                                   //当前投注期的截止时间（秒）
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIImageView *expandImageView;
@property (nonatomic, strong, readonly) NSLayoutConstraint *countDownConstraint;
@property (nonatomic, strong, readonly) DPNoNetworkView *noNetView;
//@property (nonatomic, strong) MSWeakTimer *timer;
@end

@implementation DPQuick3LotteryVC
@synthesize tableConstraint = _tableConstraint;
@synthesize historyTableView = _historyTableView;
@synthesize headView = _headView;
@dynamic flImageview1, flImageview2, flImageview3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.indexpathRow = -1;
        self.gameType = KSTypeHezhi;
        self.bonusImageAry = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor clearColor];
            [self.bonusImageAry addObject:imageView];
        }

        _CQTInstance = CFrameWork::GetInstance()->GetQuickThree();
//        _CQTInstance->Refresh();

        self.curCounterNumberType = CounterNumberType10;
        [self ClearAllSelectedData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotify) name:dp_DigitalBetRefreshNofify object:nil];


    }
    return self;
}

- (void)ClearAllSelectedData {
    for (int i = 0; i < 16; i++) {
        _hezhi[i * 3] = 0;
        _hezhi[i * 3 + 1] = 0;
        _hezhi[i * 3 + 2] = 0;
    }
    for (int i = 0; i < 36; i++) {
        _duizi[i * 3] = 0;
        _duizi[i * 3 + 1] = 0;
        _duizi[i * 3 + 2] = 0;
    }
    for (int i = 0; i < 7; i++) {
        _baozi[i * 3] = 0;
        _baozi[i * 3 + 1] = 0;
        _baozi[i * 3 + 2] = 0;
    }
    for (int i = 0; i < 5; i++) {
        _shunzi[i * 3] = 0;
        _shunzi[i * 3 + 1] = 0;
        _shunzi[i * 3 + 2] = 0;
    }
    for (int i = 0; i < 15; i++) {
        _different2[i * 3] = 0;
        _different2[i * 3 + 1] = 0;
        _different2[i * 3 + 2] = 0;
    }
    for (int i = 0; i < 21; i++) {
        _different3[i * 3] = 0;
        _different3[i * 3 + 1] = 0;
        _different3[i * 3 + 2] = 0;
    }
}
- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_DigitalBetRefreshNofify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *tintColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];
    if (IOS_VERSION_7_OR_ABOVE) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self.navigationController.navigationBar setBackgroundImage:dp_NavigationImage(@"ks_bg128.png") forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : tintColor,
                                                                          UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:dp_NavigationImage(@"ks_bg88.png") forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : tintColor,
                                                                          UITextAttributeTextShadowOffset : [NSValue valueWithCGPoint:CGPointZero],
                                                                          UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    }
    [self dp_checkNetworkStatus];
//    [self startTimer];
//    _CQTInstance->SetDelegate(self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;

    if (!_dissmissing) {
        [self.navigationController dp_applyGlobalTheme];
    }
//    [self pvt_stopTimer];
    [self resignFirstResponder];
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
- (UIImageView *)headView {
    if (_headView == nil) {
        _headView = [[UIImageView alloc] initWithImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonusTimeBack.png")]];
        _headView.userInteractionEnabled = YES;
    }
    return _headView;
}
- (UILabel *)rightIssuelabel {
    if (_rightIssuelabel == nil) {
        _rightIssuelabel = [[UILabel alloc] init];
        _rightIssuelabel.backgroundColor = [UIColor clearColor];
        _rightIssuelabel.textColor = UIColorFromRGB(0xd4ec75);
        _rightIssuelabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _rightIssuelabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.height.equalTo(@65);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

    [self.headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHandleTap:)]];
    [self createHeadView];
    _maxMiss = 0;
    UIImageView *historyView = [[UIImageView alloc] init];
    historyView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonusTimeBack.png")];
    historyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:historyView];
    historyView.userInteractionEnabled = YES;
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(65);
        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [historyView addSubview:self.historyTableView];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyView);
        make.left.equalTo(historyView);
        make.right.equalTo(historyView);
        make.height.equalTo(@250);
    }];

    UIView *lineView1 = [UIView dp_viewWithColor:UIColorFromRGB(0x9ec65d)];
    [historyView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyView);
        make.left.equalTo(historyView);
        make.right.equalTo(historyView);
        make.height.equalTo(@1);
    }];
    //走势分析，高概率排行
    UIButton *zoushiBtn = [[UIButton alloc] init];
    zoushiBtn.backgroundColor = [UIColor clearColor];
    [zoushiBtn setBackgroundImage:dp_QuickThreeImage(@"q3HistoryBtnBack.png") forState:UIControlStateNormal];
    [zoushiBtn setTitle:@"走势分析" forState:UIControlStateNormal];
    [zoushiBtn setTitleColor:UIColorFromRGB(0x03360f) forState:UIControlStateNormal];
    zoushiBtn.titleLabel.font = [UIFont dp_systemFontOfSize:12.0];
    zoushiBtn.tag = quickButtonTag;
    [zoushiBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [historyView addSubview:zoushiBtn];
    zoushiBtn.hidden = YES;
    UIButton *gaoBtn = [[UIButton alloc] init];
    gaoBtn.backgroundColor = [UIColor clearColor];
    [gaoBtn setBackgroundImage:dp_QuickThreeImage(@"q3HistoryBtnBack.png") forState:UIControlStateNormal];
    [gaoBtn setTitle:@"高概率排行" forState:UIControlStateNormal];
    [gaoBtn setTitleColor:UIColorFromRGB(0x03360f) forState:UIControlStateNormal];
    gaoBtn.titleLabel.font = [UIFont dp_systemFontOfSize:12.0];
    gaoBtn.tag = quickButtonTag + 1;
    [gaoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [historyView addSubview:gaoBtn];
    gaoBtn.hidden = YES;
    [zoushiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(historyView);
        make.top.equalTo(historyView).offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@22);
    }];
    [gaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(historyView);
        make.top.equalTo(zoushiBtn.mas_bottom).offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@22);
    }];

    UIImageView *backView = [[UIImageView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    backView.userInteractionEnabled = YES;
    backView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3back.png")];
    [self.view addSubview:backView];
    [self.view addSubview:self.collectionView];
    //    [self.view bringSubviewToFront:self.collectionView];
    float collectionViewHeight = [[UIScreen mainScreen] bounds].size.height - 65 - 86.5 - 64;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
        make.height.equalTo(@(collectionViewHeight));
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self layOutBottomView];
    [self pvt_navigationDidLoad];

    [self.view addSubview:self.flImageview1];
    [self.view addSubview:self.flImageview2];
    [self.view addSubview:self.flImageview3];
    [self.flImageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.equalTo(@35);
        make.top.equalTo(self.view).offset(23);
        make.height.equalTo(@35);
    }];
    [self.flImageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(55);
        make.width.equalTo(@35);
        make.top.equalTo(self.view).offset(23);
        make.height.equalTo(@35);
    }];
    [self.flImageview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(95);
        make.width.equalTo(@35);
        make.top.equalTo(self.view).offset(23);
        make.height.equalTo(@35);
    }];
    self.flImageview1.hidden = YES;
    self.flImageview2.hidden = YES;
    self.flImageview3.hidden = YES;
      [self refreshNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_checkNetworkStatus) name:dp_NetworkStatusCheckKey object:nil];
}

- (void)pvt_navigationDidLoad {
    UIColor *tintColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];

      if (self.isTransfer || self.indexpathRow >= 0 || self.navigationController.viewControllers.count > 2) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_QuickThreeImage(@"q3transBack.png") title:nil tintColor:tintColor target:self action:@selector(pvt_onHome)];
    } else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"ks_home.png") title:nil tintColor:tintColor target:self action:@selector(pvt_onHome)];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"ks_more.png") title:nil tintColor:tintColor target:self action:@selector(pvt_onMore)];

    [self.navigationItem setTitleView:self.titleButton];

    [self.titleButton setTitleText:Q3TypeNames[self.gameType]];
    [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];
}

- (void)createHeadView {
    UIImageView *line = [[UIImageView alloc] init];
    line.backgroundColor = UIColorFromRGB(0x033a10);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView);
        make.bottom.equalTo(self.headView);
        make.centerX.equalTo(self.headView);
        make.width.equalTo(@1);
    }];

    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"68期开奖：-- -- --";
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = UIColorFromRGB(0xd4ec75);
    leftLabel.font = [UIFont dp_systemFontOfSize:11.0];
    self.bonusLabel = leftLabel;
    [self.headView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView).offset(4);
        make.height.equalTo(@17);
        make.right.equalTo(line.mas_left).offset(-15);
        make.left.equalTo(self.headView);
    }];

    [self.bonusImageAry enumerateObjectsUsingBlock:^(UIImageView *imageview, NSUInteger idx, BOOL *stop) {
        [self.headView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftLabel.mas_bottom).offset(2.5);
            make.height.equalTo(@27.5);
            make.left.equalTo(self.headView).offset(28+idx*33.5);
            make.width.equalTo(@27.5);
        }];
    }];

    self.expandImageView = [[UIImageView alloc] initWithImage:dp_QuickThreeImage(@"bonus_down.png")];
    self.expandImageView.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:self.expandImageView];
    [self.expandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel.mas_bottom).offset(8);
        make.height.equalTo(@16);
        make.right.equalTo(line.mas_left).offset(-12);
        make.width.equalTo(@16);
    }];

    [self.headView addSubview:self.rightIssuelabel];
    [self.rightIssuelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line).offset(40);
        make.top.equalTo(self.headView).offset(7);
    }];

    UILabel *datelab = [[UILabel alloc] initWithFrame:CGRectZero];
    datelab.text = @"";
    datelab.font = [UIFont fontWithName:@"DigifaceWide" size:35];
    ; // digifacewide.ttf 文件
    datelab.textColor = UIColorFromRGB(0xffe761);
    self.deadLineLabel = datelab;
    datelab.backgroundColor = [UIColor clearColor];
    datelab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:datelab];
    [datelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightIssuelabel.mas_bottom);
        make.height.equalTo(@35);
        make.left.equalTo(line.mas_right);
        make.right.equalTo(self.headView);
    }];
    UIView *horizontalLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        view.userInteractionEnabled = NO;
        view;
    });
    UIView *countDownLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xfffa7e);
        view.userInteractionEnabled = NO;
        view;
    });
    [self.headView addSubview:horizontalLine];
    [self.headView addSubview:countDownLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right);
        make.right.equalTo(self.headView);
        make.bottom.equalTo(self.headView);
        make.height.equalTo(@4);
    }];
    [countDownLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(horizontalLine);
        make.bottom.equalTo(horizontalLine);
        make.top.equalTo(horizontalLine);
       make.width.equalTo(@0);
    }];
    [countDownLine.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == countDownLine && obj.firstAttribute == NSLayoutAttributeWidth) {
            _countDownConstraint = obj;
        }
    }];
}
- (void)assignmentBonusImage:(NSArray *)array {
    if (array.count != self.bonusImageAry.count) {
        for (int i = 0; i < self.bonusImageAry.count; i++) {
            UIImageView *imageView = [self.bonusImageAry objectAtIndex:i];
            imageView.image = nil;
        }
        return;
    }
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonus1.png")],
                                                                         [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonus2.png")],
                                                                         [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonus3.png")],
                                                                         [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonus4.png")],
                                                                         [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonus5.png")],
                                                                         [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"bonus6.png")], nil];
    for (int i = 0; i < self.bonusImageAry.count; i++) {
        int index = [[array objectAtIndex:i] integerValue] - 1;
        UIImage *image = [imageArray objectAtIndex:index];
        UIImageView *imageView = [self.bonusImageAry objectAtIndex:i];
        imageView.image = image;
    }
}
//获得底层View
- (void)layOutBottomView {
    UIImageView *backView = [[UIImageView alloc] init];
    backView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3Bottom.png")];
    backView.backgroundColor = [UIColor clearColor];
    backView.userInteractionEnabled = YES;
    [self.view insertSubview:backView aboveSubview:self.collectionView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.equalTo(@86.5);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

    UIImageView *labelView = [[UIImageView alloc] init];
    labelView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3Money.png")];
    labelView.backgroundColor = [UIColor clearColor];
    [backView addSubview:labelView];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-5);
        make.height.equalTo(@22);
        make.left.equalTo(backView).offset(120);
        make.width.equalTo(@63);
    }];
    UILabel *zhushulab = self.zhushuLabel;
    [labelView addSubview:zhushulab];
    [zhushulab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"清空" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x451907) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [button setBackgroundImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3Clear.png")] forState:UIControlStateNormal];
    button.tag = quickButtonTag + 3;
    [backView addSubview:button];
    button.backgroundColor = [UIColor clearColor];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(zhushulab);
        make.top.equalTo(zhushulab);
        make.left.equalTo(zhushulab.mas_right).offset(5);
        make.width.equalTo(@44);
    }];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *tijiaobutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tijiaobutton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3Sure.png")] forState:UIControlStateNormal];
    [tijiaobutton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3Sure.png")] forState:UIControlStateSelected];
    [backView addSubview:tijiaobutton];
    tijiaobutton.backgroundColor = [UIColor clearColor];

    [tijiaobutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView);
        make.height.equalTo(@53);
        make.right.equalTo(backView).offset(-5);
        make.width.equalTo(@53);
    }];

    [tijiaobutton addTarget:self action:@selector(pvt_submit) forControlEvents:UIControlEventTouchUpInside];

    self.jeton2 = [self choumabutton:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"choum2Normal.png")] selectedImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"choum2Selected.png")]];
    [backView addSubview:self.jeton2];
    self.jeton10 = [self choumabutton:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"choum10Normal.png")] selectedImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"choum10Selected.png")]];
    [backView addSubview:self.jeton10];
    self.jeton50 = [self choumabutton:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"choum50Normal.png")] selectedImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"choum50Selected.png")]];
    [backView addSubview:self.jeton50];
    
    
    [self.jeton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY).offset(-10);
        make.height.equalTo(@35);

        make.left.equalTo(backView);
        make.width.equalTo(@35);
    }];
    [self.jeton10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY).offset(3);
        make.height.equalTo(@49);
        make.left.equalTo(self.jeton2.mas_right).offset(1);
        make.width.equalTo(@49);
    }];
    [self.jeton50 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView).offset(11);
        make.height.equalTo(@35);
        make.left.equalTo(self.jeton10.mas_right).offset(1);
        make.width.equalTo(@35);
    }];
    switch (self.curCounterNumberType) {
        case CounterNumberType2: {
            self.curJetonAddImageName = @"jeton2Add.png";
            self.curJetonAddCenterX = self.jeton2.center.x;
            // 筹码2元
            self.jeton2.selected = YES;
        } break;
        case CounterNumberType10: {
            self.curJetonAddImageName = @"jeton10Add.png";
            self.curJetonAddCenterX = self.jeton10.center.x;
            // 默认选中 筹码10元
            self.jeton10.selected = YES;
        } break;
        case CounterNumberType50: {
            self.curJetonAddImageName = @"jeton50Add.png";
            self.curJetonAddCenterX = self.jeton50.center.x;
            // 筹码50元
            self.jeton50.selected = YES;
        } break;
        default:
            break;
    }
}
- (UIButton *)choumabutton:(UIImage *)normalimage selectedImage:(UIImage *)selectedImage {
    UIButton *chouMaBtn = [[UIButton alloc] init];
    chouMaBtn.backgroundColor = [UIColor clearColor];
    [chouMaBtn setBackgroundImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"choumKuang.png")] forState:UIControlStateSelected];
    [chouMaBtn setImage:normalimage forState:UIControlStateNormal];
    [chouMaBtn setImage:selectedImage forState:UIControlStateSelected];
    [chouMaBtn addTarget:self action:@selector(chouMaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return chouMaBtn;
}

- (void)btnClick:(UIButton *)button {
    int index = button.tag - quickButtonTag;
    switch (index) {
        case 0: //走势分析
        {

        } break;
        case 1: //高概率排行
        {

        } break;
        case 3: //清空
        {
            [self ClearAllSelectedData];
            [self.collectionView reloadData];
            [self calculateZhuShu];
        } break;
        default:
            break;
    }
}

- (UILabel *)zhushuLabel {
    if (_zhushuLabel == nil) {
        _zhushuLabel = [[UILabel alloc] init];
        _zhushuLabel.backgroundColor = [UIColor clearColor];
        _zhushuLabel.textColor = UIColorFromRGB(0xfff659);
        _zhushuLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _zhushuLabel.textAlignment = NSTextAlignmentCenter;
        _zhushuLabel.text = @"0元";
    }
    return _zhushuLabel;
}

// event
- (void)pvt_onHome {
    if (self.isTransfer) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.navigationController.viewControllers.count == 2) {
      
        int target[KSNUMMAX] = {0};
        [self touzhuInfo:target];
        if (_CQTInstance->NotesCalculate(target) <= 0) {
            _dissmissing = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                _dissmissing = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
        [self.navigationController popToViewController:viewController animated:YES];
    }
}

#pragma mark - 菜单

- (void)pvt_onMore {
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];

    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:@[ @"开奖公告", @"玩法介绍", @"帮助" ]];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view);
    }];

    [coverView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
        tap.delegate = self;
        tap;
                                    })];
}

- (void)pvt_onCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - DPDropDownListDelegate
- (void)dropDownList:(DPDropDownList *)dropDownList selectedAtIndex:(NSInteger)index {
    [dropDownList.superview removeFromSuperview];

    UIViewController *viewController;
    switch (index) {
        case 0: { // 开奖公告
            viewController = ({
                DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
                viewController.gameType = GameTypeNmgks;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        } break;
        case 1: { // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeNmgks)]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO ;

                viewController;
            });
        } break;
        case 2: { // 帮助
            viewController = [[DPHelpWebViewController alloc] init];
        } break;
        default:
            break;
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
- (void)dp_checkNetworkStatus
{
    BOOL hasNetwork = [[AFNetworkReachabilityManager sharedManager] isReachable];
    DPLog(@"net status = %d", hasNetwork);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!hasNetwork) {
            if (!self.noNetView.superview){
                [self.noNetView setCenter:CGPointMake(160, 15)];
                [self.view addSubview:self.noNetView];
                
//                [self.noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(self.view).offset(49);
//                    make.centerX.equalTo(self.view);
//                    make.width.equalTo(@290);
//                    make.height.equalTo(@60);
//                }];
            }
        }else{
            [self.noNetView removeFromSuperview];
        }
    });
}
- (void)pvt_onShare {
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
- (void)pvt_onHandleTap:(UITapGestureRecognizer *)tapRecognizer {
    if ([tapRecognizer locationInView:self.headView].x < (CGRectGetWidth(self.headView.frame) / 2 + 10)) {
        if (self.showHistory) {
            self.tableConstraint.constant = 0;
        } else {
            self.tableConstraint.constant = TrendDragHeight;
        }

        [self.view setNeedsLayout];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.showHistory = self.tableConstraint.constant == TrendDragHeight;
            [self pvt_turnArrow];
        }];
    }
}
- (void)pvt_onNavTitle {
    [self pvt_titleMenuAt:self.gameType];
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
        [self changeselectedView:tapGestureRecognizer.view.tag];
        [self.titleButton setTitleText:Q3TypeNames[tapGestureRecognizer.view.tag]];
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

- (void)pvt_clear {
}

//点击筹码
- (void)chouMaBtnClick:(UIButton *)button {
    CounterNumberType curJN = CounterNumberTypeNone;
    if (button == self.jeton2) {
        curJN = CounterNumberType2;
        self.curJetonAddImageName = @"jeton2Add.png";
        self.curJetonAddCenterX = self.jeton2.center.x;
    } else if (button == self.jeton10) {
        curJN = CounterNumberType10;
        self.curJetonAddImageName = @"jeton10Add.png";
        self.curJetonAddCenterX = self.jeton10.center.x;
    } else if (button == self.jeton50) {
        curJN = CounterNumberType50;
        self.curJetonAddImageName = @"jeton50Add.png";
        self.curJetonAddCenterX = self.jeton50.center.x;
    }
    if (self.curCounterNumberType == curJN) {
        return;
    }
    self.curCounterNumberType = curJN;
    NSArray *array = [NSArray arrayWithObjects:self.jeton2, self.jeton10, self.jeton50, nil];
    for (int i = 0; i < array.count; i++) {
        UIButton *jetButton = [array objectAtIndex:i];
        int height = 35;
        if (jetButton == button) {
            jetButton.selected = YES;
            height = 49;
        } else {
            jetButton.selected = NO;
        }
        [jetButton.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if (constraint.firstItem == jetButton && constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = height;
                *stop = YES;
            }
        }];
        [jetButton.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if (constraint.firstItem == jetButton && constraint.firstAttribute == NSLayoutAttributeWidth) {
                constraint.constant = height;
                *stop = YES;
            }
        }];
    }
}

- (UITableView *)historyTableView {
    if (_historyTableView == nil) {
        _historyTableView = [[UITableView alloc] init];
        _historyTableView.backgroundColor = [UIColor clearColor];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.scrollEnabled = YES;
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _historyTableView.rowHeight = 25;

        if ([_historyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_historyTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _historyTableView;
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
        NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:dp_QuickThreeImage(@"navTitleImage1.png"), dp_QuickThreeImage(@"navTitleImage2.png"), dp_QuickThreeImage(@"navTitleImage3.png"), dp_QuickThreeImage(@"navTitleImage4.png"), dp_QuickThreeImage(@"navTitleImage5.png"), nil];
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
                                                                               150)];
        imageView.userInteractionEnabled = YES;
        imageView.image = dp_QuickThreeImage(@"navTitleDropDown.png");
        imageView.tag = TitleMenuContentTag;

        // 95, 45
        for (int i = 0; i < 6; i++) {
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
            label.font = [UIFont dp_systemFontOfSize:14.0];
            label.text = Q3TypeNames[i];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];

            UILabel *subLabel = [[UILabel alloc] init];
            subLabel.backgroundColor = [UIColor clearColor];
            subLabel.textColor = [UIColor colorWithRed:0.74 green:0.51 blue:0.22 alpha:1];
            subLabel.highlightedTextColor = [UIColor colorWithRed:0.93 green:0.66 blue:0.33 alpha:1];
            subLabel.font = [UIFont dp_systemFontOfSize:10.0];
            subLabel.text = Q3BonusTypeNames[i];
            subLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:subLabel];

            [view addSubview:label];
            [view addSubview:subLabel];
            [imageView addSubview:view];
            [views addObject:view];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.top.equalTo(view).offset(5);
                make.height.equalTo(@20);
            }];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.top.equalTo(label.mas_bottom).offset(-2);
                make.height.equalTo(@15);
            }];

            //图片
            UIImageView *dic1 = [[UIImageView alloc] init];
            dic1.backgroundColor = [UIColor clearColor];
            [view addSubview:dic1];
            UIImageView *dic2 = [[UIImageView alloc] init];
            dic2.backgroundColor = [UIColor clearColor];
            [view addSubview:dic2];
            UIImageView *dic3 = [[UIImageView alloc] init];
            dic3.backgroundColor = [UIColor clearColor];
            [view addSubview:dic3];
            if (i != 4) {
                dic1.image = (UIImage *)[imageArray objectAtIndex:counterNumberBonus[i][0] - 1];
                dic2.image = (UIImage *)[imageArray objectAtIndex:counterNumberBonus[i][1] - 1];
                dic3.image = (UIImage *)[imageArray objectAtIndex:counterNumberBonus[i][2] - 1];
                [dic1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(subLabel.mas_bottom).offset(2);
                    make.right.equalTo(dic2.mas_left).offset(-8);
                    make.width.equalTo(@12.5);
                    make.height.equalTo(@12.5);
                }];
                [dic2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view);
                    make.top.equalTo(subLabel.mas_bottom).offset(2);
                    make.width.equalTo(@12.5);
                    make.height.equalTo(@12.5);
                }];
                [dic3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(dic2.mas_right).offset(8);
                    make.top.equalTo(subLabel.mas_bottom).offset(2);
                    make.width.equalTo(@12.5);
                    make.height.equalTo(@12.5);
                }];
                if (i == 0) {
                    UILabel *label1 = [[UILabel alloc] init];
                    label1.backgroundColor = [UIColor clearColor];
                    label1.text = @"+";
                    label1.font = [UIFont dp_systemFontOfSize:10.0];
                    label1.textColor = [UIColor colorWithRed:0.74 green:0.51 blue:0.22 alpha:1];
                    [view addSubview:label1];
                    UILabel *label2 = [[UILabel alloc] init];
                    label2.backgroundColor = [UIColor clearColor];
                    label2.text = @"+";
                    label2.font = [UIFont dp_systemFontOfSize:10.0];
                    label2.textColor = [UIColor colorWithRed:0.74 green:0.51 blue:0.22 alpha:1];
                    [view addSubview:label2];
                    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(dic1);
                        make.left.equalTo(dic1.mas_right).offset(1);
                        make.right.equalTo(dic2.mas_left);
                        make.height.equalTo(@12.5);
                    }];
                    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(dic1);
                        make.left.equalTo(dic2.mas_right).offset(1);
                        make.right.equalTo(dic3.mas_left);
                        make.height.equalTo(@12.5);
                    }];
                }
            } else {
                dic1.image = (UIImage *)[imageArray objectAtIndex:counterNumberBonus[i][0] - 1];
                dic2.image = (UIImage *)[imageArray objectAtIndex:counterNumberBonus[i][1] - 1];
                [dic1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(subLabel.mas_bottom).offset(2);
                    make.centerX.equalTo(view).offset(-10);
                    make.width.equalTo(@12.5);
                    make.height.equalTo(@12.5);
                }];
                [dic2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view).offset(10);
                    make.top.equalTo(subLabel.mas_bottom).offset(2);
                    make.width.equalTo(@12.5);
                    make.height.equalTo(@12.5);
                }];
            }
        }

        [views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@95);
                make.height.equalTo(@60);
            }];
        }];

        for (int i = 0; i < 2; i++) {
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

        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(8);
        }];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).offset(73);
        }];
        [backgroudView addSubview:coverView];
        [backgroudView addSubview:imageView];
        [backgroudView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavDropDown:)]];

        _titleMenu = backgroudView;
    }
    return _titleMenu;
}

#pragma mark - DPNavigationMenuDelegate
- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    [self.titleButton setTitleText:Q3TypeNames[index]];
    [self changeselectedView:index];
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
}

- (void)changeselectedView:(int)index {
    switch (index) {
        case 0: {
            self.gameType = KSTypeHezhi;

        } break;
        case 1: {
            self.gameType = KSTypeDuizi;

        } break;
        case 2: {
            self.gameType = KSTypeBaozi;

        } break;
        case 3: {
            self.gameType = KSTypeShunzi;
        } break;
        case 4: {
            self.gameType = KSTypeErbutong;
        } break;
        case 5: {
            self.gameType = KSTypeSanbutong;
        } break;
        default:
            break;
    }

    int mis[KSCountMax] = {0};
    _CQTInstance->GetMiss(mis, self.gameType);
    _maxMiss = 0;
    for (int i = 0; i < KSCountMax; i++) {
        if (mis[i] > _maxMiss) {
            _maxMiss = mis[i];
        }
    }

    [self.collectionView reloadData];
    [self calculateZhuShu];
}
- (void)calculateZhuShu {
    int target[KSNUMMAX] = {0};
    [self touzhuInfo:target];
    self.zhushuLabel.text = [NSString stringWithFormat:@"%d元", 2 * _CQTInstance->NotesCalculate(target)];
}
//获取界面元素
- (void)touzhuInfo:(int[])target {

    switch (self.gameType) {
        case KSTypeHezhi:
            for (int i = 0; i < 48; i++) {
                target[i] = _hezhi[i];
            }
            break;
        case KSTypeDuizi:
            for (int i = 0; i < 108; i++) {
                target[i] = _duizi[i];
            }
            break;
        case KSTypeBaozi:
            for (int i = 0; i < 21; i++) {
                target[i] = _baozi[i];
            }
            break;
        case KSTypeShunzi:
            for (int i = 0; i < 15; i++) {
                target[i] = _shunzi[i];
            }
            break;
        case KSTypeErbutong:
            for (int i = 0; i < 45; i++) {
                target[i] = _different2[i];
            }
            break;
        case KSTypeSanbutong:
            for (int i = 0; i < 63; i++) {
                target[i] = _different3[i];
            }
            break;
        default:
            break;
    }
}

//提交
- (void)pvt_submit {
    int target[KSNUMMAX] = {0};
    [self touzhuInfo:target];
    if (_CQTInstance->NotesCalculate(target) <= 0) {
        [[DPToast makeText:@"请至少选择一注"] show];
        return;
    }
    int AddTargetReturn = 0;
    if (self.indexpathRow >= 0) {
        AddTargetReturn = _CQTInstance->ModifyTarget(self.indexpathRow, target, self.gameType);
    } else {
        AddTargetReturn = _CQTInstance->AddTarget(target, self.gameType);
    }
    if (AddTargetReturn >= 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [[DPToast makeText:@"提交失败"] show];
}
//中转界面跳转过来
- (void)jumpToSelectPage:(int)row gameType:(int)gameTypes {
    self.indexpathRow = row;
    self.isTransfer = YES;
    self.gameType = (KSType)gameTypes;
    [self ClearAllSelectedData];
    if (row >= 0) {
        int content[3] = {0};
        KSType subType;
        int pos;
        int note;
        _CQTInstance->GetTarget(row, content, note, subType, pos);
        switch (gameTypes) {
            case KSTypeHezhi:
                _hezhi[pos * 3] = content[0];
                _hezhi[pos * 3 + 1] = content[1];
                _hezhi[pos * 3 + 2] = content[2];
                break;
            case KSTypeDuizi:
                _duizi[pos * 3] = content[0];
                _duizi[pos * 3 + 1] = content[1];
                _duizi[pos * 3 + 2] = content[2];
                break;
            case KSTypeBaozi:
                _baozi[pos * 3] = content[0];
                _baozi[pos * 3 + 1] = content[1];
                _baozi[pos * 3 + 2] = content[2];
                break;
            case KSTypeShunzi:
                _shunzi[pos * 3] = content[0];
                _shunzi[pos * 3 + 1] = content[1];
                _shunzi[pos * 3 + 2] = content[2];
                break;
            case KSTypeErbutong:
                _different2[pos * 3] = content[0];
                _different2[pos * 3 + 1] = content[1];
                _different2[pos * 3 + 2] = content[2];
                break;
            case KSTypeSanbutong:
                _different3[pos * 3] = content[0];
                _different3[pos * 3 + 1] = content[1];
                _different3[pos * 3 + 2] = content[2];
                break;
            default:
                break;
        }
    } else {
        self.zhushuLabel.text = @"";
        [self.titleButton setTitleText:Q3TypeNames[gameTypes]];
    }
    [self changeselectedView:gameTypes];
    [self.collectionView reloadData];
    [self calculateZhuShu];
}

#pragma mark - DZHLTQuick3ButtonDelegate
- (void)quick3Button:(DPButtonCollectionCell *)quick3Button touchPoint:(CGPoint)point {

    // 生成最新的筹码按钮 实例
    UIImageView *btn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 16, 16)];
    btn.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, self.curJetonAddImageName)];
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = 2100;
    btn.center = CGPointMake(self.curJetonAddCenterX, self.view.frame.size.height - 70);
    [self.collectionView addSubview:btn];
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:quick3Button];
    // 飞到 点击处
    [UIView animateWithDuration:0.2 animations:^{
        btn.center = [quick3Button.contentView convertPoint:point toView:self.collectionView];
    } completion:^(BOOL finished) {
        btn.center = point;
        [quick3Button addSubview:btn];
    }];

    int index = indexpath.row;
    switch (self.gameType) {
        case KSTypeHezhi: {
            _hezhi[index * 3 + self.curCounterNumberType] = _hezhi[index * 3 + self.curCounterNumberType] + 1;

        } break;
        case KSTypeDuizi: {
            if (indexpath.section == 0) {
                _duizi[index * 3 + self.curCounterNumberType] = _duizi[index * 3 + self.curCounterNumberType] + 1;
            } else {
                _duizi[index * 3 + self.curCounterNumberType + 90] = _duizi[index * 3 + self.curCounterNumberType + 90] + 1;
            }

        } break;
        case KSTypeBaozi: {
            if (indexpath.section == 0) {
                _baozi[index * 3 + self.curCounterNumberType] = _baozi[index * 3 + self.curCounterNumberType] + 1;
            } else {
                _baozi[index * 3 + self.curCounterNumberType + 18] = _baozi[index * 3 + self.curCounterNumberType + 18] + 1;
            }

        } break;
        case KSTypeShunzi: {
            if (indexpath.section == 0) {
                _shunzi[index * 3 + self.curCounterNumberType] = _shunzi[index * 3 + self.curCounterNumberType] + 1;
            } else {
                _shunzi[index * 3 + self.curCounterNumberType + 12] = _shunzi[index * 3 + self.curCounterNumberType + 12] + 1;
            }

        } break;
        case KSTypeErbutong: {
            _different2[index * 3 + self.curCounterNumberType] = _different2[index * 3 + self.curCounterNumberType] + 1;

        } break;
        case KSTypeSanbutong: {
            if (indexpath.section == 0) {
                _different3[index * 3 + self.curCounterNumberType] = _different3[index * 3 + self.curCounterNumberType] + 1;
            } else {
                _different3[index * 3 + self.curCounterNumberType + 60] = _different3[index * 3 + self.curCounterNumberType + 60] + 1;
            }

        } break;
        default:
            break;
    }
    [self calculateZhuShu];
}

- (void)cleanViewAllSelected:(UIView *)selctedView indextag:(int)indexTag total:(int)total {

    for (int i = 0; i < total; i++) {
        UILabel *label = (UILabel *)[selctedView viewWithTag:indexTag + i];
        label.text = @"0 0 0";
    }
}

#pragma make - UItabelViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"historyCell";
    DPQuick3HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPQuick3HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];

        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    int result[3] = {0};
    int name;
    int index = _CQTInstance->GetHistory(indexPath.row, result, name);
    cell.issueLabel.text = [NSString stringWithFormat:@"%02d期:", name % 100];
    if(index<0)
    {
         cell.infoLabel.text=@"";
        return cell;
    }
    if (index == 1) {
        cell.bonuslabel.hidden = NO;
        cell.dic1.hidden=YES;
        cell.dic2.hidden=YES;
        cell.dic3.hidden=YES;
        cell.infoLabel.text=@"";
        return cell;
    }
    int total = result[0] + result[1] + result[2];
    if (total < 10) {
        cell.infoLabel.text = [NSString stringWithFormat:@"和值: %d    %@%@", total, total < 11 ? @"小" : @"大", total % 2 == 0 ? @"双" : @"单"];
    } else {
        cell.infoLabel.text = [NSString stringWithFormat:@"和值: %d  %@%@", total, total < 11 ? @"小" : @"大", total % 2 == 0 ? @"双" : @"单"];
    }
    cell.bonuslabel.hidden = YES;
    cell.dic1.hidden=NO;
    cell.dic2.hidden=NO;
    cell.dic3.hidden=NO;
    NSString *dicString1 = [NSString stringWithFormat:@"%d.png", result[0]];
    NSString *dicString2 = [NSString stringWithFormat:@"%d.png", result[1]];
    NSString *dicString3 = [NSString stringWithFormat:@"%d.png", result[2]];
    cell.dic1.image = dp_QuickThreeImage(dicString1);
    cell.dic2.image = dp_QuickThreeImage(dicString2);
    cell.dic3.image = dp_QuickThreeImage(dicString3);
    return cell;
}

- (NSLayoutConstraint *)tableConstraint {
    if (_tableConstraint == nil) {
        for (int i = 0; i < self.view.constraints.count; i++) {
            NSLayoutConstraint *constraint = self.view.constraints[i];
            if (constraint.firstItem == self.collectionView && constraint.firstAttribute == NSLayoutAttributeTop) {
                _tableConstraint = constraint;
                break;
            }
        }
    }
    return _tableConstraint;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isTracking) {
        return;
    }

    CGFloat y = scrollView.contentOffset.y; // + 10;
    if (self.tableConstraint.constant - y < 0) {
        UIButton *button = (UIButton *)[self.view viewWithTag:quickButtonTag + 2];
        button.selected = NO;
        self.tableConstraint.constant = 0;
    } else if (self.tableConstraint.constant - y > TrendDragHeight) {
        self.tableConstraint.constant = TrendDragHeight;
        UIButton *button = (UIButton *)[self.view viewWithTag:quickButtonTag + 2];
        button.selected = YES;
        scrollView.contentOffset = CGPointZero;
    } else {
        self.tableConstraint.constant = self.tableConstraint.constant - y;
        scrollView.contentOffset = CGPointZero;
    }

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (self.showHistory) {
        self.tableConstraint.constant = self.tableConstraint.constant < TrendDragHeight - 6 ? 0 : TrendDragHeight;

    } else {
        self.tableConstraint.constant = self.tableConstraint.constant > 6 ? TrendDragHeight : 0;
    }
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.showHistory = self.tableConstraint.constant == TrendDragHeight;
        [self pvt_turnArrow];
    }];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.showHistory) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.itemSize = CGSizeMake(75, 60);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsSelection = NO;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[DPButtonCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[DPQuick3SectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize height = CGSizeMake(320, 28);

    switch (self.gameType) {
        case KSTypeBaozi: {
            if (section == 1) {
                height = CGSizeMake(320, 60);
            }
        } break;
        case KSTypeShunzi:
            if (section == 1) {
                height = CGSizeMake(320, 40);
            }
            break;
        case KSTypeSanbutong:
            if (section == 1) {
                height = CGSizeMake(320, 28);
            }
            break;

        default:
            break;
    }
    return height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    int count = 2;
    switch (self.gameType) {
        case KSTypeHezhi:
        case KSTypeErbutong:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int count = 16;
    switch (self.gameType) {
        case KSTypeHezhi:
            count = 16;
            break;
        case KSTypeDuizi:
            if (section == 0) {
                count = 30;
            } else {
                count = 6;
            }
            break;
        case KSTypeBaozi:
            if (section == 0) {
                count = 6;
            } else {
                count = 1;
            }
            break;
        case KSTypeShunzi:
            if (section == 0) {
                count = 4;
            } else {
                count = 1;
            }
            break;
        case KSTypeErbutong:
            count = 15;
            break;
        case KSTypeSanbutong:
            if (section == 0) {
                count = 20;
            } else {
                count = 1;
            }
            break;

        default:
            break;
    }
    return count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPButtonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell.superview == nil) {

        cell.delegate = self;
        [cell bulidLayOut];
    }
    NSString *number = @"0";
    int amont = 0;
    BOOL isMissString = NO;
    BOOL showAmount = NO;
    switch (self.gameType) {
        case KSTypeHezhi:
            number = [NSString stringWithFormat:@"%d", counterNumberTotal[indexPath.row / 4][indexPath.row % 4]];
            amont = counterNumberTotalAmount[indexPath.row / 4][indexPath.row % 4];
            showAmount = YES;
            if (indexPath.row == 0) {
                isMissString = YES;
            }
            break;
        case KSTypeDuizi:
            if ((indexPath.row == 0) && (indexPath.section == 0)) {
                isMissString = YES;
            }
            if (indexPath.section == 0) {
                number = [NSString stringWithFormat:@"%d", counterNumberSame2[indexPath.row / 6][indexPath.row % 6]];
            } else {
                number = counterNumberSame2More[indexPath.row];
            }
            break;
        case KSTypeBaozi:
            if ((indexPath.row == 0) && (indexPath.section == 0)) {
                isMissString = YES;
            }
            if (indexPath.section == 0) {
                number = [NSString stringWithFormat:@"%d", counterNumberSame3[indexPath.row / 3][indexPath.row % 3]];
            } else {
                number = @"111/222/333/444/555/666";
            }
            break;
        case KSTypeShunzi:
            if ((indexPath.row == 0) && (indexPath.section == 0)) {
                isMissString = YES;
            }
            if (indexPath.section == 0) {
                number = [NSString stringWithFormat:@"%d", counterNumberShunzi[indexPath.row]];
            } else {
                number = @"123/234/345/456";
            }
            break;
        case KSTypeErbutong:
            number = [NSString stringWithFormat:@"%d", counterNumberDifferent2[indexPath.row]];
            showAmount = NO;
            if (indexPath.row == 0) {
                isMissString = YES;
            }
            break;
        case KSTypeSanbutong:
            if ((indexPath.row == 0) && (indexPath.section == 0)) {
                isMissString = YES;
            }
            if (indexPath.section == 0) {
                number = [NSString stringWithFormat:@"%d", counterNumberDifferent3[indexPath.row]];
            } else {
                number = @"123/234/345/456";
            }
            break;
        default:
            break;
    }
    [self upDateYilouzhi:cell indexPath:indexPath];
    [cell creatViewWithNumber:number amount:amont showAmount:showAmount hasMissString:isMissString quick3GameDetailType:self.gameType withNaxMiss:_maxMiss];
    [self creatRandombet:cell indexPath:indexPath];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize point = CGSizeMake(75, 55);
    switch (self.gameType) {
        case KSTypeHezhi: {
            point = CGSizeMake(75, 59);
        } break;
        case KSTypeDuizi: {
            point = CGSizeMake(50, 40);
        } break;
        case KSTypeBaozi: {
            if (indexPath.section == 0) {
                point = CGSizeMake(100, 45);
            } else {
                point = CGSizeMake(300, 45);
            }

        } break;
        case KSTypeShunzi: {
            if (indexPath.section == 0) {
                point = CGSizeMake(75, 60);
            } else {
                point = CGSizeMake(300, 40);
            }

        } break;
        case KSTypeErbutong: {
            point = CGSizeMake(50, 40);

        } break;
        case KSTypeSanbutong: {
            if (indexPath.section == 0) {
                point = CGSizeMake(50, 40);
            } else {
                point = CGSizeMake(300, 40);
            }

        } break;
        default:
            break;
    }

    return point;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    DPQuick3SectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    CGRect rt = sectionView.titleLabel.frame;
    NSString *title = @"";
    NSString * award = @"" ;
    switch (self.gameType) {
        case KSTypeHezhi:
            rt.origin.y = 6;
            rt.size.width = 35;
            title = @" 和值:开奖号码相加的和 ";
            award = @" 奖金9-240元 " ;
            break;
        case KSTypeDuizi:
            if (indexPath.section == 0) {
                title = @" 对子:2个奖号相同 ";
                award = @" 奖金80元 " ;
                rt.size.width = 110;
                rt.origin.y = 6;
            } else if (indexPath.section == 1) {
                title = @" 对子复选 ";
                award = @" 奖金15元 " ;
                rt.size.width = 110;
                rt.origin.y = 6;
            }
            break;
        case KSTypeBaozi:
            if (indexPath.section == 0) {
                title = @" 豹子:3个奖号相同 ";
                award = @" 奖金240元 " ;
                rt.size.width = 120;
                rt.origin.y = 6;
            } else if (indexPath.section == 1) {
                title = @" 豹子通选 ";
                award =@" 奖金40元 " ;
                rt.size.width = 110;
                rt.origin.y = 35;
            }
            break;
        case KSTypeShunzi:
            if (indexPath.section == 0) {
                title = @" 顺子:连续的3个号 ";
                award = @" 奖金40元 " ;
                rt.size.width = 110;
                rt.origin.y = 6;
            } else if (indexPath.section == 1) {
                rt.size.width = 110;
                title = @" 顺子通选 ";
                award = @" 奖金10元 " ;
                rt.origin.y = 15;
            }
            break;
        case KSTypeErbutong:
            rt.size.width = 125;
            title = @" 二不同号:猜开奖号码的任意2位 ";
            award = @" 奖金8元 " ;
            rt.origin.y = 6;
            break;
        case KSTypeSanbutong:
            if (indexPath.section == 0) {
                title = @" 三不同号:3个奖号均不同 ";
                award = @" 奖金40元 " ;
                rt.size.width = 135;
                rt.origin.y = 6;
            } else if (indexPath.section == 1) {
                title = @" 顺子通选 ";
                award = @" 奖金10元 " ;
                rt.size.width = 110;
                rt.origin.y = 6;
            }
            break;
        default:
            break;
    }
//    sectionView.titleLabel.frame = rt;
    sectionView.titleLabel.text = title;
    sectionView.awardLabel.text = award ;

    return sectionView;
}

//更新遗漏值
- (void)upDateYilouzhi:(DPButtonCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {

    int mis[KSCountMax] = {0};
    _CQTInstance->GetMiss(mis, self.gameType);
    int index = indexPath.row;
    switch (self.gameType) {
        case KSTypeDuizi: {
            if (indexPath.section == 1) {
                index = 30 + indexPath.row;
            }
        } break;
        case KSTypeBaozi: {
            if (indexPath.section == 1) {
                index = 6 + indexPath.row;
            }
        } break;
        case KSTypeShunzi: {
            if (indexPath.section == 1) {
                index = 4 + indexPath.row;
            }
        } break;
        case KSTypeSanbutong: {

            if (indexPath.section == 1) {
                index = 20 + indexPath.row;
            }
        } break;
        default:
            break;
    }

    //    int mis[KSCountMax] = {0};
    _CQTInstance->GetMiss(mis, self.gameType);
    _maxMiss = 0;
    for (int i = 0; i < KSCountMax; i++) {
        if (mis[i] >= _maxMiss) {
            _maxMiss = mis[i];
        }
    }

    if (mis[index] == _maxMiss) {
        cell.missLabel.textColor = [UIColor greenColor];
    } else {
        cell.missLabel.textColor = UIColorFromRGB(0xFECE00);
    }
    cell.missLabel.text = [NSString stringWithFormat:@"%d", mis[index]];
}

- (void)creatRandombet:(DPButtonCollectionCell *)cell indexPath:(NSIndexPath *)indexpath {
    [cell borderBGColorSelected:NO];
    [[cell subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (view.tag==2100) {
                [view removeFromSuperview];
            }
            
        }
    }];
    int count2 = 0;
    int count10 = 0;
    int count50 = 0;
    switch (self.gameType) {
        case KSTypeHezhi: {
            count2 = _hezhi[indexpath.row * 3];
            count10 = _hezhi[indexpath.row * 3 + 1];
            count50 = _hezhi[indexpath.row * 3 + 2];
        } break;
        case KSTypeDuizi: {
            if (indexpath.section == 0) {
                count2 = _duizi[indexpath.row * 3];
                count10 = _duizi[indexpath.row * 3 + 1];
                count50 = _duizi[indexpath.row * 3 + 2];
            } else {
                count2 = _duizi[indexpath.row * 3 + 90];
                count10 = _duizi[indexpath.row * 3 + 91];
                count50 = _duizi[indexpath.row * 3 + 92];
            }
        } break;
            break;
        case KSTypeBaozi: {
            if (indexpath.section == 0) {
                count2 = _baozi[indexpath.row * 3];
                count10 = _baozi[indexpath.row * 3 + 1];
                count50 = _baozi[indexpath.row * 3 + 2];
            } else {
                count2 = _baozi[indexpath.row * 3 + 18];
                count10 = _baozi[indexpath.row * 3 + 19];
                count50 = _baozi[indexpath.row * 3 + 20];
            }
        } break;
        case KSTypeShunzi: {
            if (indexpath.section == 0) {
                count2 = _shunzi[indexpath.row * 3];
                count10 = _shunzi[indexpath.row * 3 + 1];
                count50 = _shunzi[indexpath.row * 3 + 2];
            } else {
                count2 = _shunzi[indexpath.row * 3 + 12];
                count10 = _shunzi[indexpath.row * 3 + 13];
                count50 = _shunzi[indexpath.row * 3 + 14];
            }
        } break;
        case KSTypeErbutong: {
            count2 = _different2[indexpath.row * 3];
            count10 = _different2[indexpath.row * 3 + 1];
            count50 = _different2[indexpath.row * 3 + 2];
        } break;
        case KSTypeSanbutong: {
            if (indexpath.section == 0) {
                count2 = _different3[indexpath.row * 3];
                count10 = _different3[indexpath.row * 3 + 1];
                count50 = _different3[indexpath.row * 3 + 2];
            } else {
                count2 = _different3[indexpath.row * 3 + 60];
                count10 = _different3[indexpath.row * 3 + 61];
                count50 = _different3[indexpath.row * 3 + 62];
            }
        } break;
        default:
            break;
    }
    if ((count2 == 0) && (count10 == 0) && (count50 == 0)) {
        return;
    }
    [cell borderBGColorSelected:YES];
    [self createcurJetonButtonForCell:cell count:count2 curJetonImageName:@"jeton2Add.png"];
    [self createcurJetonButtonForCell:cell count:count10 curJetonImageName:@"jeton10Add.png"];
    [self createcurJetonButtonForCell:cell count:count50 curJetonImageName:@"jeton50Add.png"];
}
- (void)createcurJetonButtonForCell:(DPButtonCollectionCell *)cell count:(int)count curJetonImageName:(NSString *)curJetonImageName {
    if (count <= 0) {
        return;
    }
    for (int i = 0; i < count; i++) {
        UIImageView *btn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 2100;
        btn.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, curJetonImageName)];
        CGPoint centerInBtn = CGPointMake(7 + arc4random_uniform(cell.frame.size.width - 16), 7 + arc4random_uniform(cell.frame.size.height - 16));
        btn.center = centerInBtn;
        [cell addSubview:btn];
    }
}

- (void)UpDateRequestedData {
    int result[3] = {0};
    int name;
    int index = _CQTInstance->GetHistory(0, result, name);
    if (index == 0) {
        self.flImageview1.hidden = YES;
        self.flImageview2.hidden = YES;
        self.flImageview3.hidden = YES;
        [self assignmentBonusImage:[NSArray arrayWithObjects:@(result[0]), @(result[1]), @(result[2]), nil]];
        self.bonusLabel.text = [NSString stringWithFormat:@"%02d期开奖: %d %d %d", name % 100, result[0], result[1], result[2]];
    } else if (index == 1) {
        self.bonusLabel.text = [NSString stringWithFormat:@"%02d期开奖中..", name % 100];
        [self assignmentBonusImage:nil];
        self.flImageview1.hidden = NO;
        self.flImageview2.hidden = NO;
        self.flImageview3.hidden = NO;
    }

    int issue;
    string endTime;
    int ret = _CQTInstance->GetInfo(issue, endTime);
    if (ret >= 0) {
        NSDate *endDate = [NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
        self.timeSpace = [endDate timeIntervalSinceDate:[NSDate dp_date]];

        //    self.rightIssuelabel.text = [NSString stringWithFormat:@"距%02d期截止:", issue % 100];
        NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
        self.timeSpace = [[NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        self.gameName = issue;
        if (self.timeSpace > 0) {
            self.rightIssuelabel.text = [NSString stringWithFormat:@"距%02d期截止：", self.gameName % 100];
            int hours = ((int)self.timeSpace) / 3600;
            int mins = (((int)self.timeSpace) - 3600 * hours) / 60;
            int seconds = ((int)self.timeSpace) - 3600 * hours - 60 * mins;
            if (hours < 1) {
                self.deadLineLabel.text = [NSString stringWithFormat:@"%02d:%02d", mins, seconds];
            } else {
                self.deadLineLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds]; //@"05:29";
            }

        } else {
            self.rightIssuelabel.text = [NSString stringWithFormat:@"%02d期已截止..", self.gameName % 100];
            self.deadLineLabel.text = nil;
        }
        //    } else {
        //        self.rightIssuelabel.text = [NSString stringWithFormat:@"%02d期已截止..", issue % 100];
    }
}
#pragma NSTimer

//- (void)startTimer {
//    [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:1.0 target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
//    [self.timer schedule];
//    [self.timer fire];
//}
//
//- (void)pvt_stopTimer {
//    [self.timer invalidate];
//    [self setTimer:nil];
//}
- (void)pvt_reloadTimer {
//    if (self.timeSpace == 0) {
//        // todo:
//
//        DPLog(@"end: %@", [[NSDate dp_date] dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]);
//
//        [self.collectionView reloadData];
//        [self.historyTableView reloadData];
//        [self UpDateRequestedData];
//    }
//
//    if (self.timeSpace == 8) {
//        // todo:
//
//        DPLog(@"five second: %@", [[NSDate dp_date] dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]);
//
//        _CQTInstance->TimeOut();
//    }

    if (self.timeSpace > 0) {
        self.rightIssuelabel.text = [NSString stringWithFormat:@"距%02d期截止：", self.gameName % 100];
        int hours = ((int)self.timeSpace) / 3600;
        int mins = (((int)self.timeSpace) - 3600 * hours) / 60;
        int seconds = ((int)self.timeSpace) - 3600 * hours - 60 * mins;
        if (hours < 1) {
            self.deadLineLabel.text = [NSString stringWithFormat:@"%02d:%02d", mins, seconds];
        } else {
            self.deadLineLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds]; //@"05:29";
        }
        self.countDownConstraint.constant = MIN(1, self.timeSpace / 600.0) * (kScreenWidth / 2 - 10);
    } else {
        self.rightIssuelabel.text = [NSString stringWithFormat:@"%02d期已截止..", self.gameName % 100];
        self.deadLineLabel.text = nil;
        self.countDownConstraint.constant = 0;
    }

    [self.countDownConstraint.firstItem setNeedsLayout];
    [self.countDownConstraint.firstItem setNeedsUpdateConstraints];
    [self.countDownConstraint.firstItem updateConstraintsIfNeeded];
    [self.countDownConstraint.firstItem layoutIfNeeded];

    self.timeSpace--;
}
#pragma mark - ModuleNotify

- (void)refreshNotify {
    [self pvt_reloadTimer];
    int currGameName; string endTime;
    int status = _CQTInstance->GetGameStatus(currGameName, endTime);
    if (status >= 0) {
        [self.collectionView reloadData];
        [self.historyTableView reloadData];
        [self UpDateRequestedData];
        //        [super refreshNotify];
    } else {
        DPLog(@"未获取到数据");
    }
}

- (NSInteger)timeSpace {
    return g_nmgksTimeSpace;
}

//- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
//    // ...
//    //    dispatch_async(dispatch_get_main_queue(), ^{
//    //        // 解析数据
//    //                [self.collectionView reloadData];
//    //                 [self.historyTableView reloadData];
//    //        [self UpDateRequestedData];
//    //    });
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//                
//        switch (cmdId) {
//            case NOTIFY_TIMEOUT_LOTTERY:
//                if (self.timeSpace < 0) {
//                    [self.collectionView reloadData];
//                    [self.historyTableView reloadData];
//                    [self UpDateRequestedData];
//                }
//               
//                DPLog(@"NOTIFY_TIMEOUT_LOTTERY");
//                break;
//            case NOTIFY_FINISH_LOTTERY:
//                [self.collectionView reloadData];
//                [self.historyTableView reloadData];
//                [self UpDateRequestedData];
//               
//                DPLog(@"NOTIFY_FINISH_LOTTERY");
//                break;
//            default:
//                [self.collectionView reloadData];
//                [self.historyTableView reloadData];
//                [self UpDateRequestedData];
//                DPLog(@"defj...");
//                break;
//        }
//    });
//}

- (FLAnimatedImageView *)flImageview1 {
    if (_flImageview1 == nil) {
        _flImageview1 = [[FLAnimatedImageView alloc] init];
        _flImageview1.image = dp_QuickThreeImage(@"kuai3ballgif01.gif");
        NSData *data = [NSData dataWithContentsOfFile:[kQuickThreeImageBundlePath stringByAppendingPathComponent:@"kuai3ballgif01.gif"]];
        FLAnimatedImage *animatedImage3 = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
        _flImageview1.animatedImage = animatedImage3;
    }
    return _flImageview1;
}

- (FLAnimatedImageView *)flImageview2 {
    if (_flImageview2 == nil) {
        _flImageview2 = [[FLAnimatedImageView alloc] init];
        _flImageview2.image = dp_QuickThreeImage(@"kuai3ballgif01.gif");
        NSData *data = [NSData dataWithContentsOfFile:[kQuickThreeImageBundlePath stringByAppendingPathComponent:@"kuai3ballgif01.gif"]];
        FLAnimatedImage *animatedImage3 = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
        _flImageview2.animatedImage = animatedImage3;
    }
    return _flImageview2;
}

- (FLAnimatedImageView *)flImageview3 {
    if (_flImageview3 == nil) {
        _flImageview3 = [[FLAnimatedImageView alloc] init];
        _flImageview3.image = dp_QuickThreeImage(@"kuai3ballgif01.gif");
        NSData *data = [NSData dataWithContentsOfFile:[kQuickThreeImageBundlePath stringByAppendingPathComponent:@"kuai3ballgif01.gif"]];
        FLAnimatedImage *animatedImage3 = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
        _flImageview3.animatedImage = animatedImage3;
    }
    return _flImageview3;
}

@end
