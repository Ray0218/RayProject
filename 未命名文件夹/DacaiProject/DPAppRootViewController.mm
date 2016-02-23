//
//  DPTestBottomLayerViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAppRootViewController.h"
#import "FrameWork.h"
#import "XTBlurView.h"
#import "DPBannerView.h"
#import "DPImageLabel.h"
#import "Common/Component/XTSideMenu/XTSideMenu.h"
#import "Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import <MDHTMLLabel/MDHTMLLabel.h>
#import <SSKeychain/SSKeychain.h>

#import "DPPersonalCenterViewController.h"
#import "DPAccountViewControllers.h"

// 投注页面
#import "Modules/HomeBuy/DPBigLotteryVC.h"          // 数组彩
#import "Modules/HomeBuy/DPSevenHappyLotteryVC.h"
#import "Modules/HomeBuy/DPDoubleHappyLotteryVC.h"
#import "Modules/HomeBuy/DPElevnSelectFiveVC.h"
#import "Modules/HomeBuy/DPSdBuyViewController.h"
#import "Modules/HomeBuy/DPPsBuyViewController.h"
#import "Modules/HomeBuy/DPQxcBuyViewController.h"
#import "Modules/HomeBuy/DPPwBuyViewController.h"
#import "Modules/HomeBuy/DPQuick3LotteryVC.h"       // 高频彩
#import "Modules/HomeBuy/DPQuick3transferVC.h"       // 高频彩
#import "Modules/HomeBuy/DPPksBuyViewController.h"
#import "Modules/HomeBuy/DPPoker3transferVC.h"
#import "Modules/HomeBuy/DPElevnSelectFiveTransferVC.h"
#import "Modules/HomeBuy/DPSfcViewController.h"     // 竞技彩
#import "Modules/HomeBuy/DPZcNineViewController.h"
#import "Modules/HomeBuy/DPJclqBuyViewController.h"
#import "Modules/HomeBuy/DPJczqBuyViewController.h"
#import "Modules/HomeBuy/DPBdBuyViewController.h"
#import "Modules/HomeBuy/DPJcdgBuyVC.h"

#import "DPWF3DTicketTransferVC.h"
#import "DPRank3TransferVC.h"
#import "DPRank5TransferVC.h"
#import "DPSevenStartransferVC.h"
#import "DPDoubleHappyTransferVC.h"
#import "DPBigHappyTransferVC.h"
#import "DPSevenLuckTransferVC.h"
#import "DPNoNetworkView.h"

// 各模块入口
#import "Modules/Draws/DPLotteryResultViewController.h"
#import "DPLiveDataCenterViewController.h"
#import "DPLotteryInfoViewController.h"
#import "DPTogetherBuyViewController.h"
#import "SVPullToRefresh.h"
#import "DPWebViewController.h"
#import "LLPaySdk.h"
#import "LotteryCommon.h"
#import "DPRechargeVC.h"

#import <AFNetworking.h>
#import "AFImageDiskCache.h"
#import "DPAppParser.h"

#import <libkern/OSAtomic.h>
#import <MSWeakTimer/MSWeakTimer.h>

#import "DPGameLivingBaseVC.h" //todo
#define kCellItemHeight     56
#define kCellRowHeight      45
#define kCoverViewTag       30077
#define kCellTextLabelTag   30087
#define kCellImageViewTag   30097
#define kBannerDuration     5.0

@class DPAppRootBuyCell;
@protocol DPAppRootBuyCellDelegate <NSObject>
@optional
- (void)didSelectedBuyCell:(DPAppRootBuyCell *)cell;
@end
@interface DPAppRootBuyCell : UICollectionViewCell <NSCopying>
@property (nonatomic, weak) id<DPAppRootBuyCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) MDHTMLLabel *describeLabel;
@property (nonatomic, strong, readonly) UIImageView *awardView;
@property (nonatomic, strong, readonly) UILabel *moneyLabel;

@end

#pragma mark
@interface DPAppRootBuyCellContentView : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) MDHTMLLabel *describeLabel;

@property (nonatomic, strong, readonly) UIImageView *awardView;
@property (nonatomic, strong, readonly) UILabel *moneyLabel;


@end

@interface DPAppRootBuyCell ()
@property (nonatomic, strong, readonly) DPAppRootBuyCellContentView *cellContentView;
@end


@interface DPAppRootViewController () <
ModuleNotify,
UIScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
DPAppRootBuyCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate,
UIWebViewDelegate,
XTSideMenuDelegate,
DPBannerViewDelegate
> {
    CLotteryCommon *_lotteryCommon;
    
    UILabel* _labelShow ;
    UILabel* _labelShow2 ;
    UILabel* _firstLab  ;
    UILabel* _secondLab  ;
    NSMutableArray* _recentWinArray ;
    int _index ;
    DPNoNetworkView *_noNetView;
}

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong, readonly) UIView *headerView;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) UIView *entryView;
@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong, readonly) UILabel *userLabel;
//@property (nonatomic, strong, readonly) UIImageView *messageRemind;
@property (nonatomic, strong, readonly) UIButton * changeButton;//充值
@property(nonatomic,strong,readonly)UIButton *projectedButton;//购彩记录
//@property (nonatomic, strong, readonly) UIButton* messageBtn;//消息
@property (nonatomic, strong, readonly) UIButton* loginButton ;//登录注册
@property(nonatomic,strong,readonly) UIImageView *usetHeaderimageView ;//用户头像
@property(nonatomic,strong,readonly) UIView* adView ; //广告

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) NSDictionary *typeMapping;

// banner
@property (nonatomic, strong, readonly) NSOperationQueue *imageQueue;
@property (nonatomic, strong, readonly) AFImageDiskCache *imageCache;
@property (nonatomic, strong) NSArray *actionLinks;
@property (nonatomic, strong, readonly) DPNoNetworkView *noNetView; // 无网络提示

@property (nonatomic, strong) MSWeakTimer *timer;

@end

static GameTypeId GameTypes[] = { GameTypeSdpks, GameTypeSd, GameTypePs, GameTypePw, GameTypeQxc, GameTypeQlc };


@implementation DPAppRootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _lotteryCommon = CFrameWork::GetInstance()->GetLotteryCommon();
    }
    return self;
}

- (void)_initialize {
    _imageCache = [[AFImageDiskCache alloc] init];
    
    _imageQueue = [[NSOperationQueue alloc] init];
    _imageQueue.maxConcurrentOperationCount = 1;
    
    _bannerView = [[DPBannerView alloc] init];
    _bannerView.delegate = self;
    
    _userLabel = [[UILabel alloc] init];
    _userLabel.backgroundColor = [UIColor clearColor];
    _userLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _userLabel.font = [UIFont dp_systemFontOfSize:11];
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.87 alpha:1];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 8) / 2, kCellItemHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout;
    })];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.allowsSelection = NO;
    [_collectionView registerClass:[DPAppRootBuyCell class] forCellWithReuseIdentifier:@"BuyCell"];
    
    _entryView = [[UIView alloc] init];
    _entryView.backgroundColor = [UIColor clearColor];
    
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    _webView.scalesPageToFit = NO;
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    _webView.opaque = NO;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    
    _typeMapping = @{ @0: @(GameTypeNmgks),
                      @1: @(GameTypeJxsyxw),
                      @2: @(GameTypeSsq),
                      @3: @(GameTypeDlt),
                      @4: @(GameTypeJcNone),
                      @5: @(GameTypeLcNone),
                      @6: @(GameTypeZc14),
                      @7: @(GameTypeBdNone),
                      @8: @(GameTypeZc9),
                      @9: @(GameTypeNone),};
    
}

-(void)createUnLoginedUI {
    _recentWinArray = [[NSMutableArray alloc]init];
    
    _adView = [[UIView alloc]init];
    _adView.clipsToBounds = YES ;
    _adView.backgroundColor = [UIColor clearColor];
    _adView.userInteractionEnabled = YES ;
    [self.headerView addSubview:_adView];
    
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView);
        make.height.equalTo(@36);
        make.width.equalTo(@200) ;
        make.left.greaterThanOrEqualTo(_loginButton.mas_right).offset(15) ;
    }];
    
    _labelShow2 = [[UILabel alloc]init];
    _labelShow2.textColor  = [UIColor redColor];
    _labelShow2.font = [UIFont dp_systemFontOfSize:13];
    _labelShow2. userInteractionEnabled = YES ;
    [_adView addSubview:_labelShow2];
    _labelShow2.textAlignment = NSTextAlignmentLeft ;
    
    _labelShow2.backgroundColor = [UIColor clearColor] ;
    
    [_labelShow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_adView) ;
        make.width.equalTo(_adView) ;
        make.height.equalTo(_adView);
        make.left.equalTo(_adView.mas_right) ;
    }];
    
    
    _labelShow = [[UILabel alloc]init];
    _labelShow.userInteractionEnabled = YES ;
    _labelShow.textAlignment = NSTextAlignmentLeft ;
    _labelShow.font = [UIFont dp_systemFontOfSize:13];
    [_adView addSubview:_labelShow];
    _labelShow.backgroundColor = [UIColor clearColor] ;
    _labelShow.textColor  = [UIColor redColor];
    [_labelShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_adView) ;
        make.width.equalTo(_adView) ;
        make.height.equalTo(_adView);
        make.left.equalTo(_adView.mas_right) ;
        
    }];
    
    _index = 0 ;
    
    if (self.timer == nil) {
        if (_recentWinArray.count == 0) {
            return ;
        }
        [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:3.0 target:self selector:@selector(moveLabel) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
    }
    [self.timer schedule];
    [self.timer fire];
}

- (void)moveLabel {
    [UIView animateWithDuration:1 animations:^{
        _firstLab.text = [_recentWinArray objectAtIndex:_index];
        
        CGRect frame = _firstLab.frame;
        frame.origin.x = 0;
        
        _firstLab.frame = frame;
        
        CGRect frame2 = _secondLab.frame;
        frame2.origin.x = -200;
        
        _secondLab.frame = frame2;
        
    } completion:^(BOOL finished) {
        if (_index + 1 >= _recentWinArray.count) {
            return;
        }
        _secondLab.text = [_recentWinArray objectAtIndex:_index + 1];
        
        _index += 1;
        if (_index >= _recentWinArray.count - 1) {
            _index = 0;
        }
        _secondLab = _firstLab;
        
        if ([_firstLab isEqual:_labelShow]) {
            CGRect frame = _labelShow2.frame;
            frame.origin.x = self.headerView.frame.size.width;
            _labelShow2.frame = frame;
            _firstLab = _labelShow2;
        } else {
            CGRect frame = _labelShow.frame;
            frame.origin.x = self.headerView.frame.size.width;
            _labelShow.frame = frame;
            _firstLab = _labelShow;
        }
    }];
}

#pragma mark-
#pragma mark 创建button
- (UIButton *)createButtonWithImage:(NSString *)image title:(NSString *)tex {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont dp_systemFontOfSize:13.0f];
    button.backgroundColor = [UIColor whiteColor];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
    [button setImage:dp_AppRootImage(image) forState:UIControlStateNormal];
    [button setTitle:tex forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 12;
    return button;
}
- (void)creaLoginedHeaderUI {
    _changeButton = [self createButtonWithImage:@"cz.png" title:@"充值"];
    _changeButton.hidden = YES;
    [_changeButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_changeButton];
    
    _projectedButton = [self createButtonWithImage:@"Record.png" title:@"购彩记录"];
    _projectedButton.hidden = YES;
    [_projectedButton addTarget:self action:@selector(buttonProjectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_projectedButton];
    
    [_projectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loginButton) ;
        make.height.equalTo(@24);
        make.width.equalTo(@84) ;
        make.right.equalTo(self.headerView).offset(-5);
    }];
    
    
    [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.loginButton) ;
        make.height.equalTo(@24);
        make.width.equalTo(@61) ;
        make.right.equalTo(self.projectedButton.mas_left).offset(-5);
    }];
    
}

- (void)refreshHeaderView {
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        string userName;
        CFrameWork::GetInstance()->GetUserName(userName);
        [_loginButton setTitle:[NSString stringWithFormat:@"     %@",[NSString stringWithUTF8String:userName.c_str()]] forState:UIControlStateNormal];
        if (_adView.hidden == NO) {
            _usetHeaderimageView.image = dp_AppRootImage(@"user.png");
            
            _loginButton.backgroundColor = [UIColor clearColor];
            _adView.hidden = YES;
            [self.timer invalidate];
            self.timer = nil ;
            
            _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //        _messageBtn.hidden = NO;
            _changeButton.hidden = NO;
            _projectedButton.hidden=NO;
            //        _messageRemind.hidden = NO;
        }
        
    } else if (!CFrameWork::GetInstance()->IsUserLogin() ) {
        
        _usetHeaderimageView.image = dp_AppRootImage(@"userUn.png");
        [_loginButton setTitle:@"     登录 注册   " forState:UIControlStateNormal];
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        _loginButton.backgroundColor = [UIColor whiteColor];
        _adView.hidden = NO;
        
        if (self.timer == nil) {
            if (_recentWinArray.count == 0) {
                return ;
            }
            [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:3.0 target:self selector:@selector(moveLabel) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
            [self.timer schedule];
            [self.timer fire];
        }
        
        
        
        //        _messageBtn.hidden = YES;
        _changeButton.hidden = YES;
        _projectedButton.hidden=YES;
        //        _messageRemind.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initialize];
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    
    _usetHeaderimageView = [[UIImageView alloc] initWithImage:dp_AppRootImage(@"userUn.png")];
    _usetHeaderimageView.userInteractionEnabled = YES ;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logInPress:)];
    [_usetHeaderimageView addGestureRecognizer:tap];
    
    _loginButton = [self createButtonWithImage:@"" title:@"    登录 注册  "] ;
    [_loginButton addTarget:self action:@selector(logInPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:_loginButton];
    [self.headerView addSubview:self.bannerView];
    [self.headerView addSubview:_usetHeaderimageView];
    [self.headerView addSubview:self.userLabel];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.entryView];
    [self.scrollView addSubview:self.webView];
    [self.view addSubview:self.scrollView];
    
    //    if (IOS_VERSION_7_OR_ABOVE) {
    //        self.statusBarView = [[UIView alloc] init];
    //        self.statusBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //        [self.view addSubview:self.statusBarView];
    //        [self.statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(self.view);
    //            make.right.equalTo(self.view);
    //            make.top.equalTo(self.view);
    //            make.height.equalTo(@20);
    //        }];
    //    }
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 36, 0));
    }];
    [_usetHeaderimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(18);
        make.bottom.equalTo(self.headerView).offset(-6);
        
    }];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom).offset(6) ;
        make.height.equalTo(@24);
        make.left.equalTo(self.usetHeaderimageView.mas_right).offset(-15);
        make.right.mas_lessThanOrEqualTo(self.headerView).offset(-155);
        //        make.right.equalTo(self.headerView).offset(- 155);
    }];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView);
        make.height.equalTo(@36);
        make.left.equalTo(_usetHeaderimageView.mas_right).offset(4);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@150);
    }];
    [self creaLoginedHeaderUI];
    
    [self createUnLoginedUI];
    
    [self refreshHeaderView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth));
    }];
    [self.collectionView layoutIfNeeded];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.collectionView.contentSize.height));
        make.width.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    [self.entryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@65);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(5);
        make.top.equalTo(self.entryView.mas_bottom);
        make.width.equalTo(@(kScreenWidth - 10));
        make.height.equalTo(@70);
        make.bottom.equalTo(self.scrollView).offset(-5);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    static NSString *EntryTitles[] = { @"合买", @"比分直播", @"资讯", @"开奖" };
    static NSString *EntryImages[] = { @"gtoupByNew.png", @"account.png", @"msg.png", @"draw.png" };
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
        imageLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        imageLabel.imagePosition = DPImagePositionTop;
        imageLabel.textColor = [UIColor dp_flatBlackColor];
        imageLabel.font = [UIFont dp_systemFontOfSize:12];
        imageLabel.layer.borderColor = [UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1].CGColor;
        imageLabel.layer.borderWidth = 0.5;
        imageLabel.layer.cornerRadius = 3;
        imageLabel.image = dp_AppRootImage(EntryImages[i]);
        imageLabel.text = EntryTitles[i];
        imageLabel.tag = i;
        [imageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEntryTap:)]];
        [self.entryView addSubview:imageLabel];
        [views addObject:imageLabel];
        [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.entryView).offset(7);
            make.bottom.equalTo(self.entryView).offset(-7);
            make.width.equalTo(@((kScreenWidth - 25) / 4));
        }];
    }
    [[views firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entryView).offset(5);
    }];
    [views dp_enumeratePairsUsingBlock:^(UIView *obj1, NSUInteger idx1, UIView *obj2, NSUInteger idx2, BOOL *stop) {
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj1.mas_right).offset(5);
        }];
    }];
    
    __weak __typeof(self) weakSelf = self;
    [self.scrollView addPullToRefreshWithActionHandler:^{
        CFrameWork::GetInstance()->GetLotteryCommon()->HomeBuyRefresh();
        //        [weakSelf.scrollView.pullToRefreshView stopAnimating];
//        [weakSelf dp_checkNetworkStatus];
    }];
    
    self.xt_sideMenuViewController.delegate = self;
    
    _lotteryCommon->ApplicationInit();
    [self reloadHome];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_checkNetworkStatus) name:dp_NetworkStatusCheckKey object:nil];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)logInPress:(id)press {
    
//    CFrameWork::GetInstance()->GetAccount()->ReUMPay(13);

    
    [self.xt_sideMenuViewController presentLeftViewController];
}

- (void)buttonPress:(UIButton *)buttons {
    [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPRechargeVC alloc] init]] animated:YES completion:nil];
}
- (void)buttonProjectedClick:(UIButton *)buttons {
    [self.xt_sideMenuViewController presentLeftViewController];
}
- (void)dp_checkNetworkStatus
{
//    return;
    BOOL hasNetwork = [[AFNetworkReachabilityManager sharedManager] isReachable];
    DPLog(@"net status = %d", hasNetwork);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!hasNetwork) {
            if (!self.noNetView.superview){
                [self.view addSubview:self.noNetView];
            }
        }else{
            if (self.noNetView.superview) {
                [self.noNetView removeFromSuperview];
            }
        }
    });
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshHeaderView];
    [self.bannerView setDuration:kBannerDuration];
    _lotteryCommon->SetDelegate(self);
    [self dp_checkNetworkStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView setDuration:0];
}

#pragma mark - XTSideMenuDelegate

- (void)sideMenu:(XTSideMenu *)sideMenu willShowLeftMenuViewController:(UIViewController *)menuViewController {
    UINavigationController *navigationController = (id)sideMenu.leftMenuViewController;
    if (!CFrameWork::GetInstance()->IsUserLogin()) {
        if (![navigationController.viewControllers.lastObject isKindOfClass:[DPLoginViewController class]]) {
            DPPersonalCenterViewController *personalController = navigationController.viewControllers.firstObject;
            [personalController panDidAppear];
            DPLoginViewController *loginController = [[DPLoginViewController alloc] init];
            loginController.homeEntry = YES;
            [navigationController pushViewController:loginController animated:NO];
        }
    } else {
        if (![navigationController.viewControllers.lastObject isKindOfClass:[DPPersonalCenterViewController class]]) {
            [navigationController popToRootViewControllerAnimated:NO];
        }
        [navigationController.viewControllers.lastObject tableView].contentOffset = CGPointZero;
        [navigationController.viewControllers.lastObject reloadHeader];
        [navigationController.viewControllers.lastObject recordTabReset];
        
        
    }
}

- (void)sideMenu:(XTSideMenu *)sideMenu willHideLeftMenuViewController:(UIViewController *)menuViewController {
    [self viewWillAppear:YES];
    UIViewController *viewController = [(UINavigationController *)sideMenu.leftMenuViewController visibleViewController];
    if ([viewController isKindOfClass:[DPLoginViewController class]]) {
        [(id)viewController willPanHide];
    }
}

- (void)sideMenu:(XTSideMenu *)sideMenu didShowLeftMenuViewController:(UIViewController *)menuViewController {
    
    [self viewWillDisappear:YES];
    UIViewController *viewController = [(UINavigationController *)sideMenu.leftMenuViewController visibleViewController];
    if ([viewController isKindOfClass:[DPPersonalCenterViewController class]]) {
        [(id)viewController panDidAppear];
        [viewController viewDidAppear:YES];
    }
}

- (void)sideMenu:(XTSideMenu *)sideMenu didHideLeftMenuViewController:(UIViewController *)menuViewController {
    [[(UINavigationController *)sideMenu.leftMenuViewController visibleViewController] viewDidDisappear:YES];
    
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        UINavigationController *leftViewController = (id)self.xt_sideMenuViewController.leftMenuViewController;
        if (![leftViewController.visibleViewController isKindOfClass:[DPPersonalCenterViewController class]]) {
            [leftViewController popToRootViewControllerAnimated:NO];
        } else {
            [(id)leftViewController.visibleViewController panDidDisappear];
        }
    } else {
        UINavigationController *leftViewController = (id)self.xt_sideMenuViewController.leftMenuViewController;
        if (![leftViewController.visibleViewController isKindOfClass:[DPLoginViewController class]]) {
            [leftViewController popToRootViewControllerAnimated:NO];
        }
    }
    
    sideMenu.panGestureEnabled = YES;
}

#pragma mark - Event

- (void)handleEntryTap:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case 0:{ // 合买
            
//            CFrameWork::GetInstance()->GetAccount()->ReUMPay(13);
            
           
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPTogetherBuyViewController alloc] init]] animated:YES completion:nil];

        }
            break;
        case 1: // 比分
        {
            //            CFrameWork::GetInstance()->GetAccount()->ReUMPay(13);
            
            DPGameLivingBaseVC*vc =  [[DPGameLivingBaseVC alloc] init] ;
            //            vc.gameType = GameTypeLcNone ;
            
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:vc] animated:YES completion:nil];
            //             [self.xt_sideMenuViewController presentLeftViewController];
        }
            break;
        case 2: // 资讯
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPLotteryInfoViewController alloc] init]] animated:YES completion:nil];
            break;
        case 3: // 开奖
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPLotteryResultViewController alloc] init]] animated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)entryGameType:(GameTypeId)gameType {
    switch (gameType) {
        case GameTypeSd: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPWF3DTicketTransferVC alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypeSsq: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPDoubleHappyTransferVC alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypeDlt: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPBigHappyTransferVC alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypeQlc: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPSevenLuckTransferVC alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypePs: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPRank3TransferVC alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypePw: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPRank5TransferVC alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypeQxc: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPSevenStartransferVC alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypeNmgks: {
            UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:nil];
            [nav setViewControllers:@[[[DPQuick3transferVC alloc] init], [[DPQuick3LotteryVC alloc]init]]];
            [self presentViewController:nav animated:YES completion:nil];
            
        } break;
        case GameTypeSdpks: {
            UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:nil];
            [nav setViewControllers:@[[[DPPoker3transferVC alloc] init], [[DPPksBuyViewController alloc]init]]];
            [self presentViewController:nav animated:YES completion:nil];
        } break;
        case GameTypeJxsyxw: {
            UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:nil];
            [nav setViewControllers:@[[[DPElevnSelectFiveTransferVC alloc] init], [[DPElevnSelectFiveVC alloc]init]]];
            [self presentViewController:nav animated:YES completion:nil];
            
        } break;
        case GameTypeZc14: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPSfcViewController alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypeZc9: {
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPZcNineViewController alloc] init]] animated:YES completion:nil];
        } break;
        case GameTypeJcHt:
        case GameTypeJcSpf:
        case GameTypeJcRqspf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcBf: {
            DPJczqBuyViewController *viewController = [[DPJczqBuyViewController alloc] init];
            viewController.gameType = gameType;
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
        } break;
        case GameTypeLcSfc:
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcDxf:
        case GameTypeLcHt: {
            DPJclqBuyViewController *viewController = [[DPJclqBuyViewController alloc] init];
            viewController.gameType = gameType;
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
        } break;
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdZjq:
        case GameTypeBdSxds: {
            DPBdBuyViewController *viewController = [[DPBdBuyViewController alloc] init];
            viewController.gameType = gameType;
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
        } break;
        default:
            break;
    }
}

- (void)handleCoverTap:(UITapGestureRecognizer *)tap {
    UIView *coverView = [self.view.window viewWithTag:kCoverViewTag];
    
    [UIView animateWithDuration:0.2 animations:^{
        [coverView setAlpha:0];
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
}

- (void)didSelectedBuyCell:(DPAppRootBuyCell *)cell {
    if ([self.view.window viewWithTag:kCoverViewTag]) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    GameTypeId gameType = (GameTypeId)[self.typeMapping[@(indexPath.row)] integerValue];
    
    string title, surplus; bool award = NO, isStop = NO,isTonight = NO ;
    _lotteryCommon->GetHomeEntryInfo(gameType, title, isTonight, surplus, award, isStop);
    if (isStop) {
        return ;
    }
    
    
    if (gameType != GameTypeJcNone &&
        gameType != GameTypeBdNone &&
        gameType != GameTypeLcNone &&
        gameType != GameTypeNone) {
        [self entryGameType:gameType];
        return;
    }
    
    
    CGRect frame = [self.collectionView convertRect:cell.frame toView:self.view.window];
    UIView *backgroundView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake((indexPath.row % 2 == 0) ? 0 : (kScreenWidth / 2), CGRectGetMinY(frame), kScreenWidth / 2, kCellItemHeight);
        view.userInteractionEnabled = NO;
        view;
    });
    DPAppRootBuyCell *view = ({
        DPAppRootBuyCell *view = cell.copy;
        view.frame = frame;
        view.userInteractionEnabled = NO;
        view;
    });
    UITableView *detailView = ({
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.scrollEnabled = NO;
        view.rowHeight = kCellRowHeight;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.tag = gameType;
        view;
    });
    
    UIView *coverView = ({
        UIView *view = [[UIView alloc] initWithFrame:self.view.window.bounds];
        view.backgroundColor = [UIColor dp_coverColor];
        view.alpha = 0;
        view.tag = kCoverViewTag;
        view;
    });
    [self.view.window addSubview:coverView];
    //    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view.window);
    //    }];
    [coverView addSubview:backgroundView];
    [coverView addSubview:view];
    [coverView addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (indexPath.row % 2 == 0) {
            make.left.equalTo(backgroundView.mas_right);
        } else {
            make.right.equalTo(backgroundView.mas_left);
        }
        make.width.equalTo(@(kScreenWidth / 2));
        make.centerY.equalTo(backgroundView).priorityLow();
        make.top.greaterThanOrEqualTo(self.view).priorityHigh();
        make.bottom.lessThanOrEqualTo(self.view).priorityHigh();
        
        switch (gameType) {
            case GameTypeNone:
                make.height.equalTo(@(kCellRowHeight * 6));
                break ;
            case GameTypeJcNone:
                make.height.equalTo(@(kCellRowHeight * 7));
                break;
            case GameTypeBdNone:
            case GameTypeLcNone:
                make.height.equalTo(@(kCellRowHeight * 5));
                break;
            default:
                break;
        }
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        coverView.alpha = 1;
    }];
    
    [coverView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCoverTap:)];
        tap.delegate = self;
        tap;
    })];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag != kCoverViewTag) {
        return NO;
    }
    return YES;
}

#pragma mark - DPBannerViewDelegate
- (void)bannerView:(DPBannerView *)bannerView didSelectedAtIndex:(NSInteger)index {
    if (index >= self.actionLinks.count) {
        return;
    }
    NSString *jsonString = self.actionLinks[index];
    if (jsonString.length) {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//[DPCryptUtilities base64Decode:self.actionLinks[index]];
        NSError *error;
        NSDictionary *obj = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [DPAppParser rootViewController:self animated:YES userInfo:obj];
        }
    }
}

#pragma mark - collection view's date source and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.typeMapping.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *BuyImages[] = { @"ks.png", @"syxw.png", @"ssq.png", @"dlt.png", @"jc.png", @"lc.png", @"zc14.png", @"bd.png", @"zc9.png", @"more.png" };
    static NSString *BuyImages_[] = { @"ks_.png", @"syxw_.png", @"ssq_.png", @"dlt_.png", @"jc_.png", @"lc_.png", @"zc14_.png", @"bd_.png", @"zc9_.png", @"more.png" };
    static NSString *BuyTitles[] = { @"快3", @"11选5", @"双色球", @"大乐透", @"竞彩足球", @"竞彩篮球", @"胜负彩", @"北京单场", @"任选九", @"更多彩种" };
    
    GameTypeId gameType = (GameTypeId)[self.typeMapping[@(indexPath.row)] integerValue];
    
    DPAppRootBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuyCell" forIndexPath:indexPath];
    if (cell.superview == nil) {
        cell.delegate = self;
    }
    
    cell.textLabel.text = BuyTitles[indexPath.row];
    
    if (gameType == GameTypeNone) {
        cell.imageView.image = dp_AppRootImage(BuyImages[indexPath.row]);
        cell.describeLabel.htmlText = nil;
        cell.textLabel.highlighted = NO;
        cell.awardView.image = nil;
        cell.moneyLabel.text = @"" ;
    } else {
        string title, surplus; bool award = NO, isStop = NO,isTonight = NO ;
        _lotteryCommon->GetHomeEntryInfo(gameType, title, isTonight, surplus, award, isStop);
        
        cell.imageView.image = isStop ? dp_AppRootImage(BuyImages_[indexPath.row]) : dp_AppRootImage(BuyImages[indexPath.row]);
        NSString *htmlTitle = [NSString stringWithUTF8String:title.c_str()];
        if (htmlTitle.length == 0 || htmlTitle == nil) {
            htmlTitle = @"宣传内容";
        }
        cell.describeLabel.htmlText = [NSString stringWithUTF8String:title.c_str()];
        cell.textLabel.highlighted = cell.describeLabel.highlighted = isStop;
        cell.awardView.image = award ? dp_AppRootImage(@"award.png") : nil;
        
        cell.moneyLabel.text = [NSString stringWithUTF8String:surplus.c_str()] ;    }
    
    [cell.cellContentView invalidateIntrinsicContentSize];
    [cell.cellContentView setNeedsLayout];
    
    return cell;
}

#pragma mark - table view's data source and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case GameTypeNone:
            return 6 ;
        case GameTypeJcNone:
            return 7;
        case GameTypeBdNone:
        case GameTypeLcNone:
            return 5;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = [UIColor dp_flatBlackColor];
        textLabel.highlightedTextColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1];
        textLabel.font = [UIFont dp_systemFontOfSize:12];
        textLabel.tag = kCellTextLabelTag;
        textLabel.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = kCellImageViewTag;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:textLabel];
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(8);
            make.centerY.equalTo(cell);
        }];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(cell);
        }];
    }
    cell.contentView.backgroundColor = indexPath.row % 2 ? [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1] : [UIColor dp_flatWhiteColor];
    
    UILabel *textLabel = (id)[cell.contentView viewWithTag:kCellTextLabelTag];
    UIImageView *imageView = (id)[cell.contentView viewWithTag:kCellImageViewTag];
    
    switch (tableView.tag) {
        case GameTypeNone: {
            
            static NSString *CellTitles[] = { @"扑克3", @"福彩3D", @"排列三", @"排列五", @"七星彩", @"七乐彩" };
            static NSString *CellImages[] = { @"pks.png", @"sd.png", @"ps.png", @"pw.png", @"qxc.png", @"qlc.png" };
            static NSString *CellImages_[] = { @"pks_.png", @"sd_.png", @"ps_.png", @"pw_.png", @"qxc_.png", @"qlc_.png" };
            
            textLabel.text = CellTitles[indexPath.row];

            GameTypeId gameType = GameTypes[indexPath.row] ;
            string title, surplus; bool award = NO, isStop = NO,isTonight = NO ;
            _lotteryCommon->GetHomeEntryInfo(gameType, title, isTonight, surplus, award, isStop);
            imageView.image = isStop ? dp_AppRootImage(CellImages_[indexPath.row]) : dp_AppRootImage(CellImages[indexPath.row]);
            
        }
            break;
        case GameTypeJcNone: {
            static NSString *CellTitles[] = { @"单关固定",@"混合过关", @"胜平负", @"让球胜平负", @"比分", @"总进球", @"半全场", };
            static NSString *CellImages[] = {  @"jcdg.png", @"hh.png", @"sfp.png", @"rq.png", @"bf.png", @"zjq.png", @"bqc.png"};
            
            textLabel.text = CellTitles[indexPath.row];
            imageView.image = dp_AppRootImage(CellImages[indexPath.row]);
        }
            break;
        case GameTypeBdNone: {
            static NSString *CellTitles[] = { @"胜平负", @"比分", @"总进球", @"上下单双", @"半全场" };
            static NSString *CellImages[] = { @"bjsfp.png", @"bjbf.png", @"bjzjq.png", @"bjsxds.png", @"bjbqc.png"};
            
            textLabel.text = CellTitles[indexPath.row];
            imageView.image = dp_AppRootImage(CellImages[indexPath.row]);
        }
            break;
        case GameTypeLcNone: {
            static NSString *CellTitles[] = { @"混合过关", @"胜负", @"让分胜负", @"大小分", @"胜分差", };
            static NSString *CellImages[] = { @"ht.png", @"sf.png", @"rf.png", @"dxf.png", @"sfc.png"};
            
            textLabel.text = CellTitles[indexPath.row];
            imageView.image = dp_AppRootImage(CellImages[indexPath.row]);
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self handleCoverTap:nil];
    
    switch (tableView.tag) {
        case GameTypeNone: {
//            static GameTypeId GameTypes[] = { GameTypeSdpks, GameTypeSd, GameTypePs, GameTypePw, GameTypeQxc, GameTypeQlc };
            
            GameTypeId gameType = GameTypes[indexPath.row] ;
            string title, surplus; bool award = NO, isStop = NO,isTonight = NO ;
            _lotteryCommon->GetHomeEntryInfo(gameType, title, isTonight, surplus, award, isStop);
            if (isStop) {
                return ;
            }
            
            [self entryGameType:GameTypes[indexPath.row]];
        }
            break;
        case GameTypeJcNone: {
            if (indexPath.row==0) {
                [self presentViewController:[UINavigationController dp_controllerWithRootViewController:[[DPJcdgBuyVC alloc]init]] animated:YES completion:nil];
                return;
            }
            static GameTypeId GameTypes[] = { GameTypeJcHt, GameTypeJcSpf, GameTypeJcRqspf, GameTypeJcBf, GameTypeJcZjq, GameTypeJcBqc };
            [self entryGameType:GameTypes[indexPath.row-1]];
        }
            break;
        case GameTypeBdNone : {
            static GameTypeId GameTypes[] = { GameTypeBdRqspf, GameTypeBdBf, GameTypeBdZjq, GameTypeBdSxds, GameTypeBdBqc };
            [self entryGameType:GameTypes[indexPath.row]];
        }
            break;
        case GameTypeLcNone: {
            static GameTypeId GameTypes[] = { GameTypeLcHt, GameTypeLcSf, GameTypeLcRfsf, GameTypeLcDxf, GameTypeLcSfc };
            [self entryGameType:GameTypes[indexPath.row]];
        }
        default:
            break;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView dp_fitWidth];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([[[request.URL scheme] lowercaseString] isEqualToString:dp_URLScheme]) {
            NSString *resourceSpecifier = [request.URL resourceSpecifier];
            if (resourceSpecifier.length > 9 && [[[resourceSpecifier substringToIndex:9] lowercaseString] hasPrefix:@"//action?"]) {
                resourceSpecifier = [resourceSpecifier substringFromIndex:9];
                
                resourceSpecifier = [DPCryptUtilities URLDecode:resourceSpecifier];
                resourceSpecifier = [[NSString alloc] initWithData:[DPCryptUtilities base64Decode:resourceSpecifier] encoding:NSUTF8StringEncoding];
                
                NSError *error;
                NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[resourceSpecifier dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [DPAppParser rootViewController:self animated:YES userInfo:obj];
                }
            }
        }
        return NO;
    }
    return YES;
}

#pragma mark - framework notify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (cmdType) {
            case REFRESH: {
                [self.scrollView.pullToRefreshView stopAnimating];
                if (ret >= 0) {
                    [self reloadHome];
                }
            }
                break;
            case APP_ACTIVE: {
                if (ret == 0) {
                    CFrameWork::GetInstance()->GetAccount()->Logout();
                    [SSKeychain deletePasswordForService:dp_KeychainServiceName account:dp_KeychainSessionAccount];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:dp_ActiveApplicationNotify object:nil userInfo:@{@"Result":@(ret)}];
                
                int updateType = 0; string download; vector<string> contents;
                CFrameWork::GetInstance()->GetLotteryCommon()->GetUpdateInfo(updateType, contents, download);
                NSMutableString *content = [NSMutableString string];
                for (int i = 0; i < contents.size(); i++) {
                    [content appendString:[NSString stringWithUTF8String:contents[i].c_str()]];
                    if (i < contents.size() - 1) {
                        [content appendFormat:@"\n"];
                    }
                }
                
                switch (updateType) {
                    case 2: {
                        [UIAlertView bk_showAlertViewWithTitle:@"有新版本" message:content cancelButtonTitle:@"暂不更新" otherButtonTitles:@[@"前往更新"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:download.c_str()]]];
                            }
                        }];
                    } break;
                    case 3: {
                        [UIAlertView bk_showAlertViewWithTitle:@"有新版本" message:content cancelButtonTitle:@"前往更新" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:download.c_str()]]];
                        }];
                    } break;
                    default:
                        break;
                }
                
            }
                break;
            default:
                break;
        }
        
    });
}

- (void)reloadHome {
    [self.collectionView reloadData];
    
    vector<string> recentWin;
    _lotteryCommon->GetHomeRecentWin(recentWin) ;
    for(int i=0 ;i < recentWin.size();i++) {
        [_recentWinArray addObject:[NSString stringWithUTF8String:recentWin[i].c_str()]] ;
    }
    [_recentWinArray addObject:@""];
    [self refreshHeaderView];
    
    vector<string> imageURLs; vector<string> actionURLs; string webURL;
    _lotteryCommon->GetHomeImages(imageURLs, actionURLs, webURL);
    [self.webView stopLoading];
    if (webURL.length() == 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[kServerBaseURL stringByAppendingString:@"/web/home/index"]]]];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:webURL.c_str()]]]];
    }
    int count = imageURLs.size();
    if (count == 0) {
        UIImage *image = [UIImage imageWithContentsOfFile:dp_ImagePath(kStartupImageBundlePath, @"top.jpg")];
        self.bannerView.images = @[image];
        self.actionLinks = nil;
        return;
    }
    [self.imageQueue cancelAllOperations];
    [self setRequestCount:0];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageURLs.size()];
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:actionURLs.size()];
    for (int i = 0; i < count; i++) {
        [actions addObject:[NSString stringWithUTF8String:actionURLs[i].c_str()]];
    }
    for (int i = 0; i < count; i++) {
        [images addObject:[NSNull null]];
    }
    for (int i = 0; i < count; i++) {
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:imageURLs[i].c_str()]]];
        UIImage *image = [self.imageCache cachedImageForRequest:requset];
        if (image) {
            images[i] = image;
            self.requestCount++;
            if (self.requestCount == count) {
                [self loadImages:images actions:actions];
            }
        } else {
            __weak __typeof(self) weakSelf = self;
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requset];
            operation.responseSerializer = [AFImageResponseSerializer serializer];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf.imageCache cacheImage:responseObject forRequest:operation.request];
                
                images[i] = responseObject;
                weakSelf.requestCount++;
                if (weakSelf.requestCount == count) {
                    [weakSelf loadImages:images actions:actions];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                weakSelf.requestCount++;
                if (weakSelf.requestCount == count) {
                    [weakSelf loadImages:images actions:actions];
                }
            }];
            
            [self.imageQueue addOperation:operation];
        }
    }
}

- (void)loadImages:(NSMutableArray *)images actions:(NSMutableArray *)actions {
    for (int i = 0; i < images.count; ) {
        if (images[i] == [NSNull null]) {
            [images removeObjectAtIndex:i];
            [actions removeObjectAtIndex:i];
        } else {
            i++;
        }
    }
    
    if (images.count > 0) {
        self.bannerView.images = images;
        self.actionLinks = actions;
    }
}
- (DPNoNetworkView *)noNetView
{
    if (_noNetView == nil) {
        
        _noNetView = [[DPNoNetworkView alloc]initWithFrame:CGRectMake(50, 0, 230, 30)] ;
        __weak __typeof(self) weakSelf = self;

        _noNetView.tapBlock = ^{
            
            DPWebViewController *webView = [[DPWebViewController alloc]init];
            webView.title = @"网络设置";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
            NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSURL *url = [[NSBundle mainBundle] bundleURL];
            DPLog(@"html string =%@, url = %@ ", str, url);
            [webView.webView loadHTMLString:str baseURL:url];
            UINavigationController *navCtrl = [UINavigationController dp_controllerWithRootViewController:webView];
            [weakSelf presentViewController:navCtrl animated:YES completion:nil];
        } ;
        
//        _noNetView = [[DPNoNetworkView alloc]initWithTapBlock:^{
//            DPWebViewController *webView = [[DPWebViewController alloc]init];
//            webView.title = @"网络设置";
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
//            NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            NSURL *url = [[NSBundle mainBundle] bundleURL];
//            DPLog(@"html string =%@, url = %@ ", str, url);
//            [webView.webView loadHTMLString:str baseURL:url];
//            UINavigationController *navCtrl = [UINavigationController dp_controllerWithRootViewController:webView];
//            [self presentViewController:navCtrl animated:YES completion:nil];
//        }];
    }
    return _noNetView;
}
@end

@implementation DPAppRootBuyCellContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [self addSubview:self.textLabel];
        [self addSubview:self.awardView];
        [self addSubview:self.describeLabel];
        [self addSubview:self.moneyLabel];
    }
    return self;
}


- (void)layoutSubviews {
    self.textLabel.frame = CGRectMake(0, 0, self.textLabel.dp_intrinsicWidth, self.textLabel.dp_intrinsicHeight);
    self.awardView.frame = CGRectMake(self.textLabel.dp_maxX, 0, self.awardView.dp_intrinsicWidth, self.awardView.dp_intrinsicHeight);
    
    self.moneyLabel.frame = CGRectMake(self.awardView.dp_maxX+2, 0, self.moneyLabel.dp_intrinsicWidth, 13.5);
    self.moneyLabel.layer.cornerRadius =self.moneyLabel.dp_intrinsicHeight*0.15 ;
    self.moneyLabel.layer.masksToBounds = YES ;
    CGPoint centerPoint= self.moneyLabel.center;
    centerPoint.y = self.textLabel.center.y ;
    self.moneyLabel.center = centerPoint  ;
    
    
    self.describeLabel.frame = CGRectMake(0, self.textLabel.dp_maxY, self.describeLabel.dp_intrinsicWidth, self.describeLabel.dp_intrinsicHeight);
    
    self.awardView.center = CGPointMake(self.awardView.center.x, self.textLabel.center.y);
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    
    _awardView = [[UIImageView alloc] init];
    _awardView.highlightedImage = nil;
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor dp_flatBlackColor];
    _textLabel.highlightedTextColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1];
    _textLabel.font = [UIFont dp_systemFontOfSize:14];
    
    _describeLabel = [[MDHTMLLabel alloc] init];
    _describeLabel.backgroundColor = [UIColor clearColor];
    _describeLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    _describeLabel.highlightedTextColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1];
    _describeLabel.font = [UIFont dp_systemFontOfSize:8];
    _describeLabel.userInteractionEnabled = NO;
    
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.backgroundColor = [UIColor dp_flatRedColor] ;
    _moneyLabel.textAlignment = NSTextAlignmentCenter ;
    _moneyLabel.font = [UIFont dp_boldSystemFontOfSize:10] ;
    _moneyLabel.textColor = [UIColor dp_flatWhiteColor] ;
    
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(MAX(self.textLabel.dp_intrinsicWidth, self.describeLabel.dp_intrinsicWidth) + 40,
                      self.textLabel.dp_intrinsicHeight + self.describeLabel.dp_intrinsicHeight);
}
@end

@implementation DPAppRootBuyCell

- (instancetype)copyWithZone:(NSZone *)zone {
    DPAppRootBuyCell *cell = [[DPAppRootBuyCell allocWithZone:zone] init];
    cell.imageView.image = self.imageView.image;
    cell.textLabel.text = self.textLabel.text;
    cell.describeLabel.htmlText = self.describeLabel.htmlText;
    cell.awardView.image = self.awardView.image;
    cell.moneyLabel.text = self.moneyLabel.text ;
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initialize];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.cellContentView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(18);;
        }];
        [self.cellContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(2);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
            tap.delaysTouchesEnded = NO;
            tap;
        })];
    }
    return self;
}

- (void)_initialize {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _imageView = [[UIImageView alloc] init];
    _cellContentView = [[DPAppRootBuyCellContentView alloc] init];
}

- (void)pvt_onTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedBuyCell:)]) {
        [self.delegate didSelectedBuyCell:self];
    }
}

- (UILabel *)textLabel {
    return _cellContentView.textLabel;
}

- (UIImageView *)awardView {
    return _cellContentView.awardView;
}

-(UILabel*)moneyLabel{
    return _cellContentView.moneyLabel ;
}


- (UILabel *)describeLabel {
    return _cellContentView.describeLabel;
}

@end
