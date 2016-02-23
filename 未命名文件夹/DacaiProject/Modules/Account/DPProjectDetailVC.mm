//
//  DPProjectDetailVC.m
//  DacaiProject
//
//  Created by sxf on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailVC.h"
#import "DPProjectDetailTBHeaderCell.h"
#import "DProjectDetailMyOrderHeaderCell.h"
#import "DPProjectDetailWInNumberCell.h"
#import "DProjectDetailContentHeaderCell.h"
#import "DProjectDetailOptimizeHeaderCell.h"
#import "DProjectDetailFollowHeaderCell.h"
#import "DPProjectDetailVC+ProjectContent.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"

#import "DPBigLotteryVC.h"
#import "DPSevenHappyLotteryVC.h"
#import "DPQuick3LotteryVC.h"
#import "DPDoubleHappyLotteryVC.h"
#import "DPElevnSelectFiveVC.h"

#import "DPSdBuyViewController.h"
#import "DPPsBuyViewController.h"
#import "DPQxcBuyViewController.h"
#import "DPPwBuyViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPBdBuyViewController.h"
#import "DPSfcViewController.h"
#import "DPZcNineViewController.h"
#import "DPPksBuyViewController.h"
#import "DPElevnSelectFiveTransferVC.h"

#import "DPWF3DTicketTransferVC.h"
#import "DPRank3TransferVC.h"
#import "DPRank5TransferVC.h"
#import "DPSevenStartransferVC.h"
#import "DPDoubleHappyTransferVC.h"
#import "DPBigHappyTransferVC.h"
#import "DPSevenLuckTransferVC.h"
#import "DPQuick3transferVC.h"
#import "DPPoker3transferVC.h"
#import "DPRedPacketViewController.h"
#import "DPJczqBuyViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPBdBuyViewController.h"
#import <MDHTMLLabel.h>
#import "DPVerifyUtilities.h"
#import "DPRechargeToPayVC.h"
#import "DPPersonalCenterViewController.h"
#import "DPShareView.h"

#define buttonTagForPD 11000
@interface DPProjectDetailVC () <
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    DProjectDetailMyOrderHeaderCellDelegate,
    DProjectDetailOptimizeHeaderCellDelegate,
    DProjectDetailFollowHeaderCellDelegate,
    DProjectDetailFollowListCellDelegate,
    DProjectDetailContentHeaderCellDelegate,
    ModuleNotify,
    UIGestureRecognizerDelegate,
    DPRedPacketViewControllerDelegate,
    DPShareViewDelegate> {
@private
    BOOL _isSectionExpand[6];
    NSInteger _followExpandIndex;
    UITableView *_tableView;
    //    UIView *_continueView;      //合买数字彩满员投注
    UIView *_remindTitleView;   //提示文字
    UIView *_jcBottomView;      //竞彩代购投注
    UIView *_digitalBottomView; //数字彩代购投注
    UIView *_jcTBView;          //竞彩满员投注
    UIView *_rengouBotomView;   //合买未满员投注
    UITextField *_rengouTf;
    UIView *_goPayBtn; // 付款按钮
    UIView *_coverView;
    BOOL _isRengou; //标记下边一行是否是认购
    TTTAttributedLabel *_titleView;

    BOOL _isWined;          //是否中奖
    BOOL _isClickPayButton; //是否点击付款按钮
    BOOL _isAllBuy;         //是否自己全买

    MDHTMLLabel *_payLabel;

    NSInteger _projCmdId;
}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *jcBottomView, *rengouBotomView;
@property (nonatomic, strong, readonly) UIView *goPayBtn, *remindTitleView;
@property (nonatomic, strong, readonly) UIView *digitalBottomView;
//@property (nonatomic, strong, readonly) UIView *jcTBView;
@property (nonatomic, strong, readonly) UITextField *rengouTf;
@property (nonatomic, strong, readonly) UIView *coverView;
@property (nonatomic, strong, readonly) TTTAttributedLabel *titleView;
@end

@implementation DPProjectDetailVC
@dynamic tableView;
@dynamic jcBottomView, rengouBotomView, remindTitleView;
@dynamic digitalBottomView;
@dynamic rengouTf;
@dynamic coverView;
@dynamic titleView;
@dynamic goPayBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _followExpandIndex = -1;
        _isRengou = 1;
        self.isVisible = YES;
        for (int i = 0; i < 6; i++) {
            _isSectionExpand[i] = 1;
        }
        self.responseCount = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createClassData];
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.isVisible = 1;

    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(pvt_onShare)];
    _isClickPayButton = NO;
    [self buildLayout];

    [self showHUD];
    _projCmdId = _CpInstance->RefreshProjectInfo(self.projectId, self.gameType, self.purchaseOrderId);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIImage *image = [UIImage dp_globalImageNamed:@"red" makeBlock:^UIImage * {
        return [UIImage dp_imageWithColor:[UIColor dp_flatDarkRedColor]];
    }];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    UIButton *righetButtton1 = (UIButton *)[self.view viewWithTag:buttonTagForPD + 10];
    [righetButtton1 setTitle:[NSString stringWithFormat:@"%@投注", dp_GameTypeFirstName(self.gameType)] forState:UIControlStateNormal];
    UIButton *righetButtton2 = (UIButton *)[self.view viewWithTag:buttonTagForPD + 11];
    [righetButtton2 setTitle:[NSString stringWithFormat:@"%@投注", dp_GameTypeFirstName(self.gameType)] forState:UIControlStateNormal];
    UIButton *righetButtton3 = (UIButton *)[self.view viewWithTag:buttonTagForPD + 12];
    [righetButtton3 setTitle:[NSString stringWithFormat:@"%@投注", dp_GameTypeFirstName(self.gameType)] forState:UIControlStateNormal];
    UIButton *righetButtton4 = (UIButton *)[self.view viewWithTag:buttonTagForPD + 15];
    [righetButtton4 setTitle:[NSString stringWithFormat:@"%@投注", dp_GameTypeFirstName(self.gameType)] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];

    [self refreshDelegate];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ThirdShareSuccess object:nil];
}

- (void)projectDetailPriojectId:(int)projectId
                       gameType:(GameTypeId)lotteryGameType
                        pdBuyId:(int)pdBuyId
                       gameName:(int)gameName{
    self.projectId = projectId;
    self.gameType = lotteryGameType;
    self.ProjectBuyId = pdBuyId;
    self.gameName = gameName;
    self.navigationItem.titleView = self.titleView;
    self.titleView.frame = CGRectMake(0, 0, 200, 44);
    UIFont *font1 = [UIFont dp_systemFontOfSize:16.0];
    CTFontRef fontRef1 = CTFontCreateWithName((__bridge CFStringRef)font1.fontName, font1.pointSize, NULL);
    UIFont *font2 = [UIFont dp_systemFontOfSize:12.0];
    CTFontRef fontRef2 = CTFontCreateWithName((__bridge CFStringRef)font2.fontName, font2.pointSize, NULL);
    if (self.purchaseOrderId>0) {
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单%d", self.purchaseOrderId]];
        [hintString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, hintString.length)];
        [hintString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef1 range:NSMakeRange(0, 2)];
        [hintString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef2 range:NSMakeRange(2, hintString.length - 2)];
        [self.titleView setText:hintString];
    }else{
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"方案%d", projectId]];
    [hintString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, hintString.length)];
    [hintString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef1 range:NSMakeRange(0, 2)];
    [hintString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef2 range:NSMakeRange(2, hintString.length - 2)];
    [self.titleView setText:hintString];
    }

    if (fontRef1) {
        CFRelease(fontRef1);
    }
    if (fontRef2) {
        CFRelease(fontRef2);
    }
}

- (void)createClassData {
    switch (self.gameType) {
        case GameTypeSsq:
            _CDInstance = CFrameWork::GetInstance()->GetDoubleChromosphere();
            _CpInstance = _CDInstance;
            break;
        case GameTypeDlt:
            _CSLInstance = CFrameWork::GetInstance()->GetSuperLotto();
            _CpInstance = _CSLInstance;

            break;
        case GameTypeQlc:
            _CSLLInstance = CFrameWork::GetInstance()->GetSevenLuck();
            _CpInstance = _CSLLInstance;

            break;
        case GameTypeSd:
            _lottery3DInstance = CFrameWork::GetInstance()->GetLottery3D();
            _CpInstance = _lottery3DInstance;

            break;
        case GameTypePs:
            _Pl3Instance = CFrameWork::GetInstance()->GetPick3();

            _CpInstance = _Pl3Instance;
            break;
        case GameTypePw:
            _Pl5Instance = CFrameWork::GetInstance()->GetPick5();
            _CpInstance = _Pl5Instance;

            break;
        case GameTypeQxc:
            _SsInstance = CFrameWork::GetInstance()->GetSevenStar();
            _CpInstance = _SsInstance;

            break;
        case GameTypeJxsyxw:
            _CJXInstance = CFrameWork::GetInstance()->GetJxsyxw();
            _CpInstance = _CJXInstance;

            break;
        case GameTypeNmgks:
            _CQTInstance = CFrameWork::GetInstance()->GetQuickThree();
            _CpInstance = _CQTInstance;

            break;
        case GameTypeSdpks:
            _CPTInstance = CFrameWork::GetInstance()->GetPokerThree();
            _CpInstance = _CPTInstance;

            break;
        case GameTypeJcSpf: // 竞彩足球
        case GameTypeJcZjq:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
            _CJCzqInstance = CFrameWork::GetInstance()->GetLotteryJczq();
            _CpInstance = _CJCzqInstance;

            break;
        case GameTypeBdRqspf: // 北京单场
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            _CJCBdInstance = CFrameWork::GetInstance()->GetLotteryBd();
            _CpInstance = _CJCBdInstance;

            break;
        case GameTypeLcSf: // 竞彩篮球
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            _CJCLcInstance = CFrameWork::GetInstance()->GetLotteryJclq();
            _CpInstance = _CJCLcInstance;

            break;

        case GameTypeZc9:
            _CLZ9Instance = CFrameWork::GetInstance()->GetLotteryZc9();
            _CpInstance = _CLZ9Instance;

            break;
        case GameTypeZc14:
            _CLZ14Instance = CFrameWork::GetInstance()->GetLotteryZc14();
            _CpInstance = _CLZ14Instance;

            break;
        default:
            break;
    }
}

- (void)refreshDelegate {

    switch (self.gameType) {
        case GameTypeSsq:
            _CDInstance->SetDelegate(self);

            break;
        case GameTypeDlt:
            _CSLInstance->SetDelegate(self);
            break;
        case GameTypeQlc:
            _CSLLInstance->SetDelegate(self);
            break;
        case GameTypeSd:
            _lottery3DInstance->SetDelegate(self);
            break;
        case GameTypePs:
            _Pl3Instance->SetDelegate(self);
            break;
        case GameTypePw:
            _Pl5Instance->SetDelegate(self);
            break;
        case GameTypeQxc:
            _SsInstance->SetDelegate(self);
            break;
        case GameTypeJxsyxw:
            _CJXInstance->SetDelegate(self);
            break;
        case GameTypeNmgks:
            _CQTInstance->SetDelegate(self);
            break;
        case GameTypeSdpks:
            _CPTInstance->SetDelegate(self);
            break;
        case GameTypeJcSpf: // 竞彩足球
        case GameTypeJcZjq:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
            _CJCzqInstance->SetDelegate(self);
            break;
        case GameTypeBdRqspf: // 北京单场
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            _CJCBdInstance->SetDelegate(self);
            break;
        case GameTypeLcSf: // 竞彩篮球
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            _CJCLcInstance->SetDelegate(self);
            break;

        case GameTypeZc9:
            _CLZ9Instance->SetDelegate(self);
            break;
        case GameTypeZc14:
            _CLZ14Instance->SetDelegate(self);
            break;
        default:
            break;
    }
}

- (void)refreshProjectInfo {
    if (_isClickPayButton) {
        __weak __typeof(self) weakSelf = self;
        void (^block)(void) = ^() {
            [weakSelf showHUD];
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            REQUEST_RELOAD_BLOCK(strongSelf->_projCmdId, _CpInstance->RefreshProjectInfo(weakSelf.projectId, weakSelf.gameType, weakSelf.purchaseOrderId));
        };

        if (CFrameWork::GetInstance()->IsUserLogin()) {
            block();
        } else {
            DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
            viewController.finishBlock = block;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else {
        REQUEST_RELOAD(_projCmdId, _CpInstance->RefreshProjectInfo(self.projectId, self.gameType, self.purchaseOrderId));
        [self showHUD];
    }
}

- (void)buildLayout {
    __weak DPProjectDetailVC *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshProjectInfo];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
    [self.tableView.pullToRefreshView setTextColor:[UIColor dp_flatBlackColor]];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新   " forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"释放刷新   " forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"正在刷新..." forState:SVPullToRefreshStateLoading];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.coverView];
    [self.coverView setHidden:YES];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.jcBottomView];
    [self.view addSubview:self.rengouBotomView];
    //    [self.view addSubview:self.continueView];
    [self.view addSubview:self.digitalBottomView];
    [self.view addSubview:self.goPayBtn];
    //    [self.view addSubview:self.jcTBView];
    [self.view addSubview:self.remindTitleView];

    [self.goPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];
    [self.jcBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];

    [self.remindTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];

    [self.digitalBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];
    [self.rengouBotomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@80);
        make.bottom.equalTo(self.view);
    }];
    //    [self.continueView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view);
    //        make.right.equalTo(self.view);
    //        make.height.equalTo(@50);
    //        make.bottom.equalTo(self.view);
    //    }];
    //    [self.jcTBView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view);
    //        make.right.equalTo(self.view);
    //        make.height.equalTo(@80);
    //        make.bottom.equalTo(self.view);
    //    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
       make.bottom.equalTo(self.view).offset(-80);
    }];
    [self buildRemindTitleView];
    //    [self bulidContinueViewView];
    [self bulidDigitalBottomView];
    [self bulidJcBottomView];
    //    [self bulidJcTBView];
    [self bulidRengouView];
    [self bulidGoPayBtn];
    self.remindTitleView.hidden = YES;
    self.jcBottomView.hidden = YES;
    self.rengouBotomView.hidden = YES;
    //    self.continueView.hidden = YES;
    //    self.jcTBView.hidden = YES;
    self.digitalBottomView.hidden = YES;
    self.goPayBtn.hidden = YES;
    UITapGestureRecognizer *tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
}
//- (void)bulidGoPayBtn
//{
//    UIView *line1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
//
//    UIButton *payButton = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = UIColorFromRGB(0xe7161a);
//        [button setTitle:@"付 款" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(pvt_onGoPay) forControlEvents:UIControlEventTouchDown];
//        button;
//    });
//
//    [self.goPayBtn addSubview:line1];
//    [self.goPayBtn addSubview:payButton];
//
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.top.equalTo(self.goPayBtn);
//        make.height.equalTo(@0.5);
//    }];
//
//    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.goPayBtn).offset(5);
//        make.right.equalTo(self.goPayBtn).offset(-5);
//        make.top.equalTo(self.goPayBtn).offset(5);
//        make.height.equalTo(@40);
//    }];
//
//}

- (void)bulidGoPayBtn {
    MDHTMLLabel *payLabel = ({
        MDHTMLLabel *label = [[MDHTMLLabel alloc]init];
        label.htmlText = [NSString stringWithFormat:@"<font color=\"#333333\">%@</font> <font color=\"#e7161a\">%d</font> 元", @"应支付", 0];
        label.font = [UIFont dp_systemFontOfSize:15];
        label;
    });

    UIButton *commitBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor dp_colorFromHexString:@"#e7161a"];
        [btn setTitle:@"付款" forState:UIControlStateNormal];
        [btn setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateNormal];
        [btn setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(pvt_onGoPay) forControlEvents:UIControlEventTouchDown];
        btn;
    });

    [self.goPayBtn addSubview:payLabel];
    [self.goPayBtn addSubview:commitBtn];

    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goPayBtn).offset(20);
        make.centerY.equalTo(self.goPayBtn);
    }];

    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goPayBtn);
        make.right.equalTo(self.goPayBtn);
        make.bottom.equalTo(self.goPayBtn);
        make.width.equalTo(@90);
    }];

    _payLabel = payLabel;
}

- (void)buildRemindTitleView {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"非常抱歉，方案已经满员了，看准了就要赶紧下手呦。";
    label.textColor = UIColorFromRGB(0x3f3f3f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dp_regularArialOfSize:12.0];
    [self.remindTitleView addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.remindTitleView) ;
    }];
}

- (void)bulidJcBottomView {
    UIView *line1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
    [self.jcBottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.jcBottomView);
        make.height.equalTo(@0.5);
    }];
    UIButton *fukuanView = [[UIButton alloc] init];
    fukuanView.backgroundColor = UIColorFromRGB(0xe7161a);
    fukuanView.tag = buttonTagForPD + 11;
    [fukuanView setTitle:@"换号投注" forState:UIControlStateNormal];
    fukuanView.titleLabel.font = [UIFont dp_regularArialOfSize:15.0];
    [fukuanView setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [fukuanView addTarget:self action:@selector(pvt_onTouzhu) forControlEvents:UIControlEventTouchUpInside];
    [self.jcBottomView addSubview:fukuanView];
    [fukuanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jcBottomView).offset(5);
        make.right.equalTo(self.jcBottomView).offset(-5);
        make.top.equalTo(self.jcBottomView).offset(5);
        make.height.equalTo(@40);
    }];
}
- (void)bulidDigitalBottomView {
    UIView *line1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
    [self.digitalBottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.digitalBottomView);
        make.height.equalTo(@0.5);
    }];
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.backgroundColor = UIColorFromRGB(0xe7161a);
    [leftButton setTitle:@"继续投注本注号码" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont dp_regularArialOfSize:15.0];
    [leftButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pvt_onCopy) forControlEvents:UIControlEventTouchUpInside];
    [self.digitalBottomView addSubview:leftButton];
    leftButton.tag = buttonTagForPD + 16;

    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.backgroundColor = UIColorFromRGB(0xe7161a);
    [rightButton setTitle:@"换号投注" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont dp_regularArialOfSize:15.0];
    rightButton.tag = buttonTagForPD + 15;
    [rightButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(pvt_onTouzhu) forControlEvents:UIControlEventTouchUpInside];
    [self.digitalBottomView addSubview:rightButton];

    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@(self.view.frame.size.width/2-15));
        make.top.equalTo(self.digitalBottomView).offset(5);
        make.bottom.equalTo(self.digitalBottomView).offset(-5);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.left.equalTo(@(self.view.frame.size.width/2+5));
        make.top.equalTo(self.digitalBottomView).offset(5);
        make.bottom.equalTo(self.digitalBottomView).offset(-5);
    }];
}
- (void)bulidRengouView {
    UIView *line1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
    [self.rengouBotomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.rengouBotomView);
        make.height.equalTo(@0.5);
    }];
    UIButton *rengouBtn = [[UIButton alloc] init];
    rengouBtn.backgroundColor = UIColorFromRGB(0xe7161a);
    [rengouBtn setTitle:@"认购" forState:UIControlStateNormal];
    rengouBtn.tag = buttonTagForPD;
    rengouBtn.titleLabel.font = [UIFont dp_regularArialOfSize:12.0];
    [rengouBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [rengouBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rengouBotomView addSubview:rengouBtn];

    UIButton *baodiBtn = [[UIButton alloc] init];
    baodiBtn.backgroundColor = UIColorFromRGB(0xe7161a);
    [baodiBtn setTitle:@"保底" forState:UIControlStateNormal];
    baodiBtn.tag = buttonTagForPD + 1;
    baodiBtn.hidden = YES;
    baodiBtn.titleLabel.font = [UIFont dp_regularArialOfSize:12.0];
    [baodiBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [baodiBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:baodiBtn];

    UIButton *jianbtn = [[UIButton alloc] init];
    jianbtn.backgroundColor = [UIColor dp_flatRedColor];
    [jianbtn setImage:dp_ProjectImage(@"minus.png") forState:UIControlStateNormal];
    jianbtn.tag = buttonTagForPD + 2;
    [jianbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rengouBotomView addSubview:jianbtn];

    UIButton *addBtn = [[UIButton alloc] init];
    addBtn.backgroundColor = [UIColor dp_flatRedColor];
    addBtn.tag = buttonTagForPD + 3;
    [addBtn setImage:dp_ProjectImage(@"add.png") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rengouBotomView addSubview:addBtn];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = dp_ProjectImage(@"rengouText.png");
    [self.rengouBotomView addSubview:imageView];
    [imageView addSubview:self.rengouTf];

    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    self.kerengouLabel = label;
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont dp_regularArialOfSize:15.0];
    [self.rengouBotomView addSubview:label];

    UIButton *fukuanView = [[UIButton alloc] init];
    fukuanView.backgroundColor = UIColorFromRGB(0xe7161a);
    fukuanView.tag = buttonTagForPD + 4;
    [fukuanView setTitle:@"付款" forState:UIControlStateNormal];
    fukuanView.titleLabel.font = [UIFont dp_regularArialOfSize:15.0];
    [fukuanView setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [fukuanView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rengouBotomView addSubview:fukuanView];

    [rengouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rengouBotomView).offset(5);
        make.width.equalTo(@50);
        make.top.equalTo(self.rengouBotomView).offset(5);
        make.height.equalTo(@25);
    }];
    [baodiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rengouBtn);
        make.right.equalTo(rengouBtn);
        make.bottom.equalTo(self.rengouBotomView.mas_top).offset(3);
        make.height.equalTo(@25);
    }];
    [jianbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rengouBtn.mas_right).offset(10);
        make.width.equalTo(@30);
        make.top.equalTo(rengouBtn);
        make.bottom.equalTo(rengouBtn);
    }];
    imageView.userInteractionEnabled = YES;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jianbtn.mas_right);
        make.width.equalTo(@50);
        make.top.equalTo(rengouBtn);
        make.bottom.equalTo(rengouBtn);
    }];
    [self.rengouTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).offset(2);
        make.right.equalTo(imageView).offset(-2);
        make.top.equalTo(imageView);
        make.bottom.equalTo(imageView);
    }];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right);
        make.width.equalTo(@30);
        make.top.equalTo(rengouBtn);
        make.bottom.equalTo(rengouBtn);
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn.mas_right).offset(2);
        make.right.equalTo(self.rengouBotomView);
        make.top.equalTo(rengouBtn);
        make.bottom.equalTo(rengouBtn);
    }];
    [fukuanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rengouBotomView).offset(5);
        make.right.equalTo(self.rengouBotomView).offset(-5);
        make.top.equalTo(rengouBtn.mas_bottom).offset(5);
        make.height.equalTo(@40);
    }];
}
- (void)buttonClick:(UIButton *)button {
    int index = button.tag - buttonTagForPD;

    switch (index) {
        case 0: {
            UIButton *baodiBtn = (UIButton *)[self.view viewWithTag:buttonTagForPD + 1];
            baodiBtn.hidden = NO;
            if (_isRengou) {
                [button setTitle:@"认购" forState:UIControlStateNormal];
                [baodiBtn setTitle:@"保底" forState:UIControlStateNormal];
            } else {
                [button setTitle:@"保底" forState:UIControlStateNormal];
                [baodiBtn setTitle:@"认购" forState:UIControlStateNormal];
            }
        } break;
        case 1: {
            UIButton *rengouBtn = (UIButton *)[self.view viewWithTag:buttonTagForPD];
            button.hidden = YES;
            if (_isRengou) {

                int IsCanVisit;
                int Quantity;
                int Multiple;
                int TotalAmount;
                int BuyedAmount;
                int FilledAmount;
                int JoinCount;
                int CommisionRate;
                int Commision;
                _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
                int rengou = TotalAmount - BuyedAmount - FilledAmount;
                //                if (rengou>=[self.rengouTf.text integerValue]) {
                //                    self.kerengouLabel.text=[NSString stringWithFormat:@"元，剩%d元",rengou-[self.rengouTf.text integerValue]];
                //                }else{
                //                self.kerengouLabel.text=@"元，剩0元";
                //                self.rengouTf.text =[NSString stringWithFormat:@"%d",rengou];
                //                }
                if (rengou > 0) {
                    self.kerengouLabel.text = [NSString stringWithFormat:@"元，剩%d元", rengou];
                    self.rengouTf.text = @"1";
                } else {
                    [[DPToast makeText:@"该方案保底已满员"] show];
                    return;
                    //                    self.kerengouLabel.text = [NSString stringWithFormat:@"元，剩%d元", 0];
                    //                    self.rengouTf.text = @"0";
                }
                [rengouBtn setTitle:@"保底" forState:UIControlStateNormal];

            } else {
                self.kerengouLabel.text = [NSString stringWithFormat:@"元，剩%d元", self.kerengouMoney];
                [rengouBtn setTitle:@"认购" forState:UIControlStateNormal];
                self.rengouTf.text = @"1";
            }
            _isRengou = !_isRengou;
        } break;
        case 2: {
            if ([self.rengouTf.text integerValue] <= 1) {
                self.rengouTf.text = @"1";
                return;
            }
            self.rengouTf.text = [NSString stringWithFormat:@"%d", [self.rengouTf.text integerValue] - 1];
            if (!_isRengou) {
                int IsCanVisit;
                int Quantity;
                int Multiple;
                int TotalAmount;
                int BuyedAmount;
                int FilledAmount;
                int JoinCount;
                int CommisionRate;
                int Commision;
                _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
                //                int rengou=TotalAmount-BuyedAmount-FilledAmount;
                //                    self.kerengouLabel.text=[NSString stringWithFormat:@"元，剩%d元",rengou-[self.rengouTf.text integerValue]];

            } else {
                //                self.kerengouLabel.text=[NSString stringWithFormat:@"元，剩%d元",self.kerengouMoney-[self.rengouTf.text integerValue]];
            }

        } break;
        case 3: {
            int rengou = self.kerengouMoney;
            if (!_isRengou) {
                int IsCanVisit;
                int Quantity;
                int Multiple;
                int TotalAmount;
                int BuyedAmount;
                int FilledAmount;
                int JoinCount;
                int CommisionRate;
                int Commision;
                _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
                rengou = TotalAmount - BuyedAmount - FilledAmount;
            }
            if ([self.rengouTf.text integerValue] >= rengou) {
                if (_isRengou) {
                    [[DPToast makeText:@"不能超过最大可认购数"] show];
                    return;
                }
                [[DPToast makeText:@"不能超过最大可保底数"] show];
                return;
            }
            self.rengouTf.text = [NSString stringWithFormat:@"%d", [self.rengouTf.text integerValue] + 1];
            //                 self.kerengouLabel.text=[NSString stringWithFormat:@"元，剩%d元",rengou-[self.rengouTf.text integerValue]];

        } break;
        case 4: {
            _isClickPayButton = YES;
            [self changeCurBottom];

        } break;

        default:
            break;
    }
}

//点击付款
- (void)changeCurBottom {
    int orderId = 0, needAmt = 0;
    _CpInstance->GetPurchaseOrderInfo(orderId, needAmt);
    if (orderId>0) {
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(self);
        [self showDarkHUD];
        int index = CFrameWork::GetInstance()->GetAccount()->NotHandlePay(orderId);
        if (index < 0) {
            [[DPToast makeText:@"支付失败"] show];
            [self dismissDarkHUD];
        }
        return;
    }
    int money = [self.rengouTf.text integerValue];
    if (money < 1) {
        [[DPToast makeText:@"至少投注一元"] show];
        return;
    }
    CFrameWork::GetInstance()->GetAccount()->SetDelegate(self);
    // todo: 判断保底or认购
   
    [self showDarkHUD];
    if (_isRengou) {
    CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(self.gameType, 3, money, 0,self.projectId);
    } else {
    CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(self.gameType, 4, 0, money,self.projectId);
    }
   
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self refreshProjectInfo];
    }
  
}
#pragma make - getter, setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)remindTitleView {
    if (_remindTitleView == nil) {
        _remindTitleView = [[UIView alloc] init];
        _remindTitleView.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.87 alpha:1.0];
    }
    return _remindTitleView;
}

- (UIView *)rengouBotomView {
    if (_rengouBotomView == nil) {
        _rengouBotomView = [[UIView alloc] init];
        _rengouBotomView.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.87 alpha:1.0];
    }
    return _rengouBotomView;
}
- (UIView *)jcBottomView {
    if (_jcBottomView == nil) {
        _jcBottomView = [[UIView alloc] init];
        _jcBottomView.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.87 alpha:1.0];
    }
    return _jcBottomView;
}
- (UIView *)digitalBottomView {
    if (_digitalBottomView == nil) {
        _digitalBottomView = [[UIView alloc] init];
        _digitalBottomView.backgroundColor = [UIColor clearColor];
    }
    return _digitalBottomView;
}

- (UITextField *)rengouTf {
    if (_rengouTf == nil) {
        _rengouTf = [[UITextField alloc] init];
        _rengouTf.backgroundColor = [UIColor clearColor];
        _rengouTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _rengouTf.font = [UIFont dp_systemFontOfSize:16];
        _rengouTf.delegate = self;
        _rengouTf.text = @"1";
        _rengouTf.keyboardType = UIKeyboardTypeNumberPad;
        //        _rengouTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _rengouTf.textAlignment = NSTextAlignmentCenter;
    }
    return _rengouTf;
}
- (UIView *)goPayBtn {
    if (_goPayBtn == nil) {
        _goPayBtn = [[UIView alloc] init];
        _goPayBtn.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _goPayBtn;
}

- (TTTAttributedLabel *)titleView {
    if (_titleView == nil) {
        _titleView = [[TTTAttributedLabel alloc] init];
        [_titleView setTextColor:[UIColor dp_flatWhiteColor]];
        [_titleView setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleView setBackgroundColor:[UIColor clearColor]];
        [_titleView setTextAlignment:NSTextAlignmentCenter];
        _titleView.userInteractionEnabled = NO;
    }
    return _titleView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
    //    return _projectDetailModel ? sizeof(_isSectionExpand) / sizeof(BOOL) : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DProjectSectionTypeHeader:
            return 1;
        case DProjectSectionTypeMyOrder: {
            if (self.ProjectBuyId == 2) // 合买
            {
                int num;
                _CpInstance->GetPjoinNum(num);
                if (num == 0) {
                    return 0;
                }
                return _isSectionExpand[DProjectSectionTypeMyOrder] ? num + 2 : 1;
            }
            return 0;
        }
        case DProjectSectionTypeWinningSituation: {

            string InsertTime;
            string EndTime;
            string PName;
            string TName;
            string WinedAmt;
            string Result;
            string WinDescription;
            _CpInstance->GetPBaseInfo4(InsertTime, EndTime, PName, TName, WinedAmt, Result, WinDescription);
            switch (self.gameType) {

                case GameTypeJcBf:
                case GameTypeJcBqc:
                case GameTypeJcZjq:
                case GameTypeJcSpf:
                case GameTypeJcRqspf:
                case GameTypeJcHt:
                case GameTypeBdSxds:
                case GameTypeBdRqspf:
                case GameTypeBdBf:
                case GameTypeBdBqc:
                case GameTypeBdZjq:
                case GameTypeLcHt:
                case GameTypeLcRfsf:
                case GameTypeLcSf:
                case GameTypeLcDxf:
                case GameTypeLcSfc:
                    return 0;
                default:
                    return (self.sysProcessStepId >= 6 && WinDescription.length() > 0) ? 1 : 0;
            }
        }
        case DProjectSectionTypeProjectContent: {

            if (_isSectionExpand[DProjectSectionTypeProjectContent]) {

                if (self.contentType != 0) {
                    return 2;
                }
                if (self.responseCount < 1) {
                    return 1;
                }
                int FilledAmountRate;
                int IsGlfa;
                int CanBuy;
                _CpInstance->GetPBaseInfo5(FilledAmountRate, CanBuy, IsGlfa);
                if (IsGlfa) {
                    return 2;
                }

                // 方案是否不可见
                return (!self.isVisible) ? 2 : (1 + [self numberOfProjectContent]);
            }
            return 1;
        }
        case DProjectSectionTypeOptimizeDetail: {
            if ((self.gameType >= 120) && (self.gameType <= 128)) {
                int index = _CJCzqInstance->GetPYhNum();
                if (index > 0) {
                    return _isSectionExpand[DProjectSectionTypeOptimizeDetail] ? (index + 2) : 1;
                }
            }
            return 0;
        }
        case DProjectSectionTypeFollowSchedule: {
            int IsFollow;
            int StatusId;
            int StopTypeId;
            int StopMoney;
            int TotalPeriod;
            int CurrentPeriod;
            _CpInstance->GetPFollowInfo(IsFollow, StatusId, StopTypeId, StopMoney, TotalPeriod, CurrentPeriod);
            if (!IsFollow) {
                return 0;
            }
            return _isSectionExpand[DProjectSectionTypeFollowSchedule] ? _followExpandIndex >= 0 ? (TotalPeriod + 3) : (TotalPeriod + 2) : 1;
        }
    }

    return 0;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case DProjectSectionTypeHeader:
            //            if (self.ProjectBuyId == 1 || // 代购
            //                self.ProjectBuyId == 3 || // 保存
            //                self.ProjectBuyId == 4)   // 代购追号
            //            {
            //                return 115;
            //            }
            return 175;
        case DProjectSectionTypeMyOrder:
            int num;
            _CpInstance->GetPjoinNum(num);
            if (num == 0) {
                return 0.0;
            }
            return (indexPath.row == 0) ? 30 : (((indexPath.row == 1) || (indexPath.row == 1 + num)) ? 30 : 25);
        case DProjectSectionTypeWinningSituation:
            return 60;
        //            return (self.gameType > 100 && self.gameType < 200) ? [DCLTProjectDetailWinningSportCell cellHeightOfContent:_projectDetailModel.projectInfo.winDescription] : [DCLTProjectDetailWinningNumberCell cellHeightOfContent:_projectDetailModel.projectInfo.winDescription];
        case DProjectSectionTypeProjectContent: {
            // 方案是否不可见
            int FilledAmountRate;
            int IsGlfa;
            int CanBuy;
            _CpInstance->GetPBaseInfo5(FilledAmountRate, CanBuy, IsGlfa);
            if (indexPath.row == 0)
                return 30;
            else if ((!self.isVisible) || (IsGlfa)) // 方案不可见
                return 60;
            else
                return [self cellHeightAtRow:indexPath.row - 1];
        }
        case DProjectSectionTypeOptimizeDetail: {
            if (indexPath.row == 0)
                return 30;
            else if (indexPath.row == 1)
                return 20;
            else {
                NSString *infoString = @"";
                int index = indexPath.row - 2;
                string ggfs;
                string bonus;
                int quantity;
                int beysNum;
                _CJCzqInstance->GetPYhInfo(index, ggfs, bonus, quantity, beysNum);
                for (int i = 0; i < beysNum; i++) {
                    string bet;
                    _CJCzqInstance->GetPYhBet(index, i, bet);
                    if (i == 0) {
                        infoString = [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:bet.c_str()]];
                    } else {
                        infoString = [NSString stringWithFormat:@"%@*[%@]", infoString, [NSString stringWithUTF8String:bet.c_str()]];
                    }
                }
                CGSize fitLabelSize = CGSizeMake(170, 2000);
                CGSize labelSize = [infoString sizeWithFont:[UIFont dp_systemFontOfSize:10.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
                return ceilf(labelSize.height) + 15;
                //                            int index=indexPath.row-2;
                //                            string ggfs;
                //                            string bonus;
                //                            int quantity;
                //                            int beysNum;
                //                            _CJCzqInstance->GetPYhInfo(index, ggfs, bonus, quantity, beysNum);
                //                            return [DProjectDetailOptimizeListCell heightWithLineCount:(beysNum - 1) / 3 + 1];
            }
        }
        case DProjectSectionTypeFollowSchedule: {
            if (indexPath.row == 0)
                return 30;
            else if (indexPath.row == 1)
                return 25;
            else
                return 30;
        }

        default:
            break;
    }

    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case DProjectSectionTypeHeader: {
            if (self.ProjectBuyId == 2) //合买
            {
                static NSString *CellIdentifier = @"HeaderCellGroup";
                DPProjectDetailTBHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DPProjectDetailTBHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier lottery:self.gameType];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }

                [cell setLottertNameLabelText:dp_GameTypeFullName(self.gameType) issue:[NSString stringWithFormat:@"%d", self.gameName]];
                if (self.responseCount == 0) {
                    return cell;
                }
                [self gainProjectDetailTBHeaderCellData:cell];
                return cell;
            }
            static NSString *CellIdentifierAgent = @"HeaderCellAgent";
            DPProjectDetailDaiGouHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierAgent];
            if (cell == nil) {
                cell = [[DPProjectDetailDaiGouHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierAgent lottery:self.gameType];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            if (self.responseCount == 0) {
                return cell;
            }
            [self gainProjectDetailDaigouCellData:cell];
            return cell;
        }
        case DProjectSectionTypeMyOrder: {
            switch (indexPath.row) {
                case 0: {
                    static NSString *CellIdentifier = @"OrderHeaderCell";
                    DProjectDetailMyOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailMyOrderHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.delegate = self;
                    }
                    if (self.responseCount == 0) {
                        return cell;
                    }
                    if (self.sysProcessStepId < 6) {
                        [cell setBuyAmount:[NSString stringWithFormat:@"%d", [self gainMyOrderTotal]] bonus:[NSString stringWithFormat:@"--"]];

                    } else {
                        [cell setBuyAmount:[NSString stringWithFormat:@"%d", [self gainMyOrderTotal]] bonus:[NSString stringWithFormat:@"%.2f", [self gainMyOrderTotalBonus]]];
                    }

                    cell.expand = _isSectionExpand[DProjectSectionTypeMyOrder];
                    return cell;
                } break;
                case 1: {
                    static NSString *CellIdentifier = @"OrderTitleCell";
                    DProjectDetailMyOrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailMyOrderTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //                        cell.delegate = self;
                    }
                    return cell;
                } break;
                default:
                    static NSString *CellIdentifier = @"OrderInfoCell";
                    DProjectDetailMyOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailMyOrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    if (self.responseCount == 0) {
                        return cell;
                    }
                    int index = indexPath.row - 2;
                    string time;
                    int type;
                    int amount;
                    int winedAmount;
                    int isUseRed;
                    _CpInstance->GetPJoinInfo(index, time, type, amount, winedAmount, isUseRed);
                    NSString *dateString1 = [NSString stringWithUTF8String:time.c_str()];
                    NSDate *date1 = [NSDate dp_dateFromString:dateString1 withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
                    cell.timeLabel.text = [date1 dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];
                    if (isUseRed) {
                        cell.rengouLabel.image = dp_ProjectImage(@"money.png");
                    } else {
                        cell.rengouLabel.image = nil;
                    }
                    if (type == 2) {
                        cell.rengouLabel.text = [NSString stringWithFormat:@"%d(保)", amount];

                    } else if (type == 1) {
                        cell.rengouLabel.text = [NSString stringWithFormat:@" %d", amount];
                    }

                    if (self.sysProcessStepId < 6) {
                        [cell setBonusLabelTitle:@"--"];

                    } else {
                        [cell setBonusLabelTitle:[NSString stringWithFormat:@"%.2f", (float)winedAmount / 100.0]];
                    }

                    return cell;
            }

        } break;

        case DProjectSectionTypeWinningSituation: //过关方式/奖金
        {
            static NSString *CellIdentifier = @"WinNumberCell";
            DPProjectDetailWInNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPProjectDetailWInNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier lotteryType:self.gameType];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.responseCount == 0) {
                return cell;
            }
            string InsertTime;
            string EndTime;
            string PName;
            string TName;
            string WinedAmt;
            string Result;
            string WinDescription;
            _CpInstance->GetPBaseInfo4(InsertTime, EndTime, PName, TName, WinedAmt, Result, WinDescription);
            [cell.resultView loadDrawResult:[NSString stringWithUTF8String:Result.c_str()]];
            cell.bonusInfo.text = [NSString stringWithUTF8String:WinDescription.c_str()];
            return cell;

        } break;
        case DProjectSectionTypeProjectContent: //方案内容
        {
            switch (indexPath.row) {
                case 0: {
                    static NSString *CellIdentifier = @"ContentHeaderCell";
                    DProjectDetailContentHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailContentHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.delegate = self;
                    }
                    if (self.responseCount == 0) {
                        return cell;
                    }
                    cell.expand = _isSectionExpand[DProjectSectionTypeProjectContent];
                    int ProjectBuyTypeId;
                    int ContentType;
                    int SysProcessStepId;
                    int ProjectStatusId;
                    int TicketStatusId;
                    int projectId = self.projectId;
                    int gameType = self.gameType;
                    _CpInstance->GetPBaseInfo(projectId, gameType, ProjectBuyTypeId, ContentType, SysProcessStepId, ProjectStatusId, TicketStatusId);
                    self.ticketStatusId = TicketStatusId;
                    int IsCanVisit;
                    int Quantity;
                    int Multiple;
                    int TotalAmount;
                    int BuyedAmount;
                    int FilledAmount;
                    int JoinCount;
                    int CommisionRate;
                    int Commision;
                    _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
                    string gamaName;
                    string AccessName;
                    string WapUrl;
                    string ShareUrl;
                    _CpInstance->GetPBaseInfo3(gamaName, AccessName, WapUrl, ShareUrl);
                    NSString *accessName = [NSString stringWithUTF8String:AccessName.c_str()];
                    [cell setAccessText:[NSString stringWithFormat:@"方案内容（%@）", accessName.length > 0 ? accessName : @"未公开"] notesText:(ContentType == 1 ? @"方案未补全" : [NSString stringWithFormat:@"%d注×%d倍", Quantity, Multiple])];
                    return cell;
                }

                default:
                    // 方案不可见
                    int FilledAmountRate;
                    int IsGlfa;
                    int CanBuy;
                    _CpInstance->GetPBaseInfo5(FilledAmountRate, CanBuy, IsGlfa);
                    if ((!self.isVisible) || (IsGlfa)) {
                        static NSString *CellIdentifier = @"ContentInvisibleCell";
                        DPProjectDetailContentUnknownCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            cell = [[DPProjectDetailContentUnknownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        if (IsGlfa) {
                            cell.unKnowView.image = dp_ProjectImage(@"pdguolv.png");
                        }
                        if (!self.isVisible) {
                            cell.unKnowView.image = dp_ProjectImage(@"pdHidden.png");
                        }
                        return cell;
                    } else {
                        return [self tableView:tableView contentCellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
                    }
            }

        } break;
        case DProjectSectionTypeFollowSchedule: // 追号详情
        {
            switch (indexPath.row) {
                case 0: {
                    static NSString *CellIdentifier = @"FollowHeaderCell";
                    DProjectDetailFollowHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailFollowHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.delegate = self;
                    }
                    if (self.responseCount == 0) {
                        return cell;
                    }
                    int IsFollow;
                    int StatusId;
                    int StopTypeId;
                    int StopMoney;
                    int TotalPeriod;
                    int CurrentPeriod;
                    _CpInstance->GetPFollowInfo(IsFollow, StatusId, StopTypeId, StopMoney, TotalPeriod, CurrentPeriod);

                    cell.expand = _isSectionExpand[DProjectSectionTypeFollowSchedule];
                    [cell setConditionLabelText:StopTypeId stopMoney:StopMoney];
                    cell.followIssues = TotalPeriod;
                    return cell;
                }
                case 1: {
                    static NSString *CellIdentifier = @"FollowTitleCell";
                    DProjectDetailFollowTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailFollowTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }

                    return cell;
                }
                default: {
                    if (_followExpandIndex >= 0 && indexPath.row == _followExpandIndex + 3) {
                        static NSString *CellIdentifier = @"FollowResultCell";
                        if (self.gameType == GameTypeSdpks) {
                            DProjectDetailFollowResultPK3Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            if (cell == nil) {
                                cell = [[DProjectDetailFollowResultPK3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            }
                            if (self.responseCount == 0) {
                                return cell;
                            }
                            int Multiple;
                            int StatusId;
                            int WinedAmount;
                            string GameName;
                            string StatusName;
                            string Result;
                            _CpInstance->GetPFollowCell(_followExpandIndex, Multiple, StatusId, WinedAmount, GameName, StatusName, Result);
                            [cell setResultLabelText:[NSString stringWithUTF8String:Result.c_str()]];

                            return cell;
                        }
                        DProjectDetailFollowResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            cell = [[DProjectDetailFollowResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        if (self.responseCount == 0) {
                            return cell;
                        }
                        int Multiple;
                        int StatusId;
                        int WinedAmount;
                        string GameName;
                        string StatusName;
                        string Result;
                        _CpInstance->GetPFollowCell(_followExpandIndex, Multiple, StatusId, WinedAmount, GameName, StatusName, Result);
                        [cell setResultLabelText:[NSString stringWithUTF8String:Result.c_str()] lotteryType:self.gameType];

                        return cell;
                    } else {
                        static NSString *CellIdentifier = @"FollowListCell";
                        DProjectDetailFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            cell = [[DProjectDetailFollowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.delegate = self;
                        }
                        int index = indexPath.row - 2;
                        if ((_followExpandIndex >= 0) && (indexPath.row > _followExpandIndex + 2)) {
                            index = indexPath.row - 2 - 1;
                        }

                        int Multiple;
                        int StatusId;
                        int WinedAmount;
                        string GameName;
                        string StatusName;
                        string Result;
                        _CpInstance->GetPFollowCell(index, Multiple, StatusId, WinedAmount, GameName, StatusName, Result);
                        [cell setIssueLabelText:[NSString stringWithUTF8String:GameName.c_str()]];
                        [cell setBeishuLabelText:[NSString stringWithFormat:@"%d", Multiple]];
                        [cell setStateLabelText:[NSString stringWithUTF8String:StatusName.c_str()]];
                        NSString *dd = [NSString stringWithUTF8String:StatusName.c_str()];
                        DPLog(@"ddddddddddd ==  %@", dd);
                        cell.expand = _followExpandIndex >= 0 ? (indexPath.row == _followExpandIndex + 2) : NO;
                        cell.lineView.hidden = NO;
                        if (_followExpandIndex >= 0 && indexPath.row == _followExpandIndex + 2) {
                            cell.lineView.hidden = YES;
                        }
                        return cell;
                    }
                }
            }
        }

        case DProjectSectionTypeOptimizeDetail: // 优化详情
        {
            switch (indexPath.row) {
                case 0: {
                    static NSString *CellIdentifier = @"OptimizeHeaderCell";
                    DProjectDetailOptimizeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailOptimizeHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.delegate = self;
                    }

                    cell.expand = _isSectionExpand[DProjectSectionTypeOptimizeDetail];

                    return cell;
                }
                case 1: {
                    static NSString *CellIdentifier = @"OptimizeTitleCell";
                    DProjectDetailOptimizeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailOptimizeTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }

                    return cell;
                }
                default: {
                    static NSString *CellIdentifier = @"OptimizeListCell";
                    DProjectDetailOptimizeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DProjectDetailOptimizeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    if (self.responseCount == 0) {
                        return cell;
                    }
                    [self upDataProjectDetailOptimizeListCell:cell indexPath:indexPath];

                    return cell;
                }
            }
        }

        default:
            break;
    }
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
}
//总认购
- (int)gainMyOrderTotal {
    int rengou = 0;
    int num;
    _CpInstance->GetPjoinNum(num);
    for (int i = 0; i < num; i++) {
        int type;
        string time;
        int amount;
        int winedAmount;
        int isUseRed;
        _CpInstance->GetPJoinInfo(i, time, type, amount, winedAmount, isUseRed);
        rengou = rengou + amount;
    }
    return rengou;
}

//我的认购(不好保底)
- (int)gainMyOrder {
    int rengou = 0;
    int num;
    _CpInstance->GetPjoinNum(num);
    for (int i = 0; i < num; i++) {
        int type;
        string time;
        int amount;
        int winedAmount;
        int isUseRed;
        _CpInstance->GetPJoinInfo(i, time, type, amount, winedAmount, isUseRed);
        if (type == 2) {
            continue;
        }
        rengou = rengou + amount;
    }
    return rengou;
}

//总奖金
- (float)gainMyOrderTotalBonus {
    float rengou = 0.0;
    int num;
    _CpInstance->GetPjoinNum(num);
    for (int i = 0; i < num; i++) {
        int type;
        string time;
        int amount;
        int winedAmount;
        int isUseRed;
        _CpInstance->GetPJoinInfo(i, time, type, amount, winedAmount, isUseRed);
        rengou = rengou + winedAmount;
    }
    return rengou / 100.0;
}
- (void)upDataProjectDetailOptimizeListCell:(DProjectDetailOptimizeListCell *)cell indexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row - 2;
    string ggfs;
    string bonus;
    int quantity;
    int beysNum;
    _CJCzqInstance->GetPYhInfo(index, ggfs, bonus, quantity, beysNum);
    cell.zhushuLabel.text = [NSString stringWithFormat:@"%d", quantity];
    cell.bonusLabel.text = [[NSString stringWithUTF8String:bonus.c_str()] stringByReplacingOccurrencesOfString:@"," withString:@"" ]; //[NSString stringWithFormat:@"%d", quantity];
    NSString *infoString = @"";
    for (int i = 0; i < beysNum; i++) {
        string bet;
        _CJCzqInstance->GetPYhBet(index, i, bet);
        if (i == 0) {
            infoString = [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:bet.c_str()]];
        } else {
            infoString = [NSString stringWithFormat:@"%@*[%@]", infoString, [NSString stringWithUTF8String:bet.c_str()]];
        }
    }
    //    int rowTotal=beysNum/3+1;
    //    if (beysNum%3==0) {
    //        rowTotal=beysNum/3;
    //    }
    //    NSString *infoString=@"";
    //
    //    for (int i=0; i<rowTotal; i++) {
    //        if (i*3<beysNum) {
    //            string bet;
    //            _CJCzqInstance->GetPYhBet(index, i*3, bet);
    //            if (i==0) {
    //                infoString=[NSString stringWithFormat:@"[%@]",[NSString stringWithUTF8String:bet.c_str()]];
    //            }else{
    //            infoString=[NSString stringWithFormat:@"%@*[%@]",infoString,[NSString stringWithUTF8String:bet.c_str()]];
    //            }
    //        }
    //        if ((i*3+1)<beysNum) {
    //            string bet;
    //            _CJCzqInstance->GetPYhBet(index, i*3+1, bet);
    //             infoString=[NSString stringWithFormat:@"%@*[%@]",infoString,[NSString stringWithUTF8String:bet.c_str()]];
    //        }
    //        if ((i*3+2)<beysNum) {
    //            string bet;
    //            _CJCzqInstance->GetPYhBet(index, i*3+2, bet);
    //             infoString=[NSString stringWithFormat:@"%@*[%@]\n",infoString,[NSString stringWithUTF8String:bet.c_str()]];
    //        }
    //            }
    cell.infoLabel.text = infoString;
}
//tableView头部数据
- (void)gainProjectDetailTBHeaderCellData:(DPProjectDetailTBHeaderCell *)cell {
    int ProjectBuyTypeId;
    int ContentType;
    int SysProcessStepId;
    int ProjectStatusId;
    int TicketStatusId;
    int projectId = self.projectId;
    int gameType = self.gameType;
    _CpInstance->GetPBaseInfo(projectId, gameType, ProjectBuyTypeId, ContentType, SysProcessStepId, ProjectStatusId, TicketStatusId);
    self.ticketStatusId = TicketStatusId;
    string gamaName;
    string AccessName;
    string WapUrl;
    string ShareUrl;
    _CpInstance->GetPBaseInfo3(gamaName, AccessName, WapUrl, ShareUrl);
    int IsCanVisit;
    int Quantity;
    int Multiple;
    int TotalAmount;
    int BuyedAmount;
    int FilledAmount;
    int JoinCount;
    int CommisionRate;
    int Commision;
    _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
    string InsertTime;
    string EndTime;
    string PName;
    string TName;
    string WinedAmt;
    string Result;
    string WinDescription;
    _CpInstance->GetPBaseInfo4(InsertTime, EndTime, PName, TName, WinedAmt, Result, WinDescription);
    string UserName;
    string Scores;
    int WinedAmount;
    int WinedCount;
    _CpInstance->GetPCreaterInfo(UserName, Scores, WinedAmount, WinedCount);
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", dp_GameTypeFullName(self.gameType)]];
        [cell.lottertNameLabel setText:buyString];
    } else {
        NSString *issueText = [NSString stringWithUTF8String:gamaName.c_str()];
        self.gameName = [issueText intValue];
        [cell setLottertNameLabelText:dp_GameTypeFullName(self.gameType) issue:issueText];
    }
    cell.projectStatelabel.text = [NSString stringWithFormat:@"%@ %@", [NSString stringWithUTF8String:PName.c_str()], [NSString stringWithUTF8String:TName.c_str()]];
    cell.projectMoneyLabel.text = [NSString stringWithFormat:@"%d", TotalAmount];
    cell.renzhouLabel.text = [NSString stringWithFormat:@"%d", TotalAmount - BuyedAmount];
    [cell setBaodiLabelText:(float)FilledAmount / (float)TotalAmount];
    [cell setYongjinLabeText:CommisionRate];
    NSString *dateString1 = [NSString stringWithUTF8String:InsertTime.c_str()];
    NSDate *date1 = [NSDate dp_dateFromString:dateString1 withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    cell.startTimeLabel.text = [date1 dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];
    NSString *dateString2 = [NSString stringWithUTF8String:EndTime.c_str()];
    NSDate *date2 = [NSDate dp_dateFromString:dateString2 withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    cell.endTimeLabel.text = [date2 dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];
    cell.peopleNameLabel.text = [NSString stringWithUTF8String:UserName.c_str()];
    cell.winLabel.text = [NSString stringWithFormat:@"中%d次 共%d元", WinedCount, WinedAmount];
    [cell setLevelImageView:[NSString stringWithUTF8String:Scores.c_str()]];

    if ((self.ProjectStatusId == 2) || (self.ProjectStatusId == 3) || (self.ProjectStatusId == 4)) {
        cell.kerengouLabel.text = @"中奖金额";
        NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", [NSString stringWithUTF8String:WinedAmt.c_str()]]];
        if (SysProcessStepId < 6) {
            hinstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", @"--"]];
        }
        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length - 1)];
        cell.renzhouLabel.attributedText = hinstring;
    }
    if (SysProcessStepId >= 6) {

        if ([[NSString stringWithUTF8String:WinedAmt.c_str()] floatValue] > 0.00) {
            cell.winyjImage.hidden = NO;

            if (TicketStatusId == 3) {
                cell.winyjImage.image = dp_ProjectImage(@"winseal.png");

            } else {
                cell.winyjImage.image = dp_ProjectImage(@"unwinseal.png");
            }
        } else {
            cell.winyjImage.hidden = YES;
        }

    } else {
        cell.winyjImage.hidden = YES;
    }
}
//tableView头部数据
- (void)gainProjectDetailDaigouCellData:(DPProjectDetailDaiGouHeaderCell *)cell {
    int ProjectBuyTypeId;
    int ContentType;
    int SysProcessStepId;
    int ProjectStatusId;
    int TicketStatusId;
    int projectId = self.projectId;
    int gameType = self.gameType;
    _CpInstance->GetPBaseInfo(projectId, gameType, ProjectBuyTypeId, ContentType, SysProcessStepId, ProjectStatusId, TicketStatusId);
    self.ticketStatusId = TicketStatusId;
    string gamaName;
    string AccessName;
    string WapUrl;
    string ShareUrl;
    _CpInstance->GetPBaseInfo3(gamaName, AccessName, WapUrl, ShareUrl);
    int IsCanVisit;
    int Quantity;
    int Multiple;
    int TotalAmount;
    int BuyedAmount;
    int FilledAmount;
    int JoinCount;
    int CommisionRate;
    int Commision;
    _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
    string InsertTime;
    string EndTime;
    string PName;
    string TName;
    string WinedAmt;
    string Result;
    string WinDescription;
    _CpInstance->GetPBaseInfo4(InsertTime, EndTime, PName, TName, WinedAmt, Result, WinDescription);
    string UserName;
    string Scores;
    int WinedAmount;
    int WinedCount;
    _CpInstance->GetPCreaterInfo(UserName, Scores, WinedAmount, WinedCount);
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", dp_GameTypeFullName(self.gameType)]];
        [cell.lottertNameLabel setText:buyString];
    } else {
        self.gameName=[[NSString stringWithUTF8String:gamaName.c_str()] integerValue];
        [cell setLottertNameLabelText:dp_GameTypeFullName(self.gameType) issue:[NSString stringWithUTF8String:gamaName.c_str()]];
    }
    cell.projectStatelabel.text = [NSString stringWithFormat:@"%@ %@", [NSString stringWithUTF8String:PName.c_str()], [NSString stringWithUTF8String:TName.c_str()]];
    cell.projectMoneyLabel.text = [NSString stringWithFormat:@"%d元", TotalAmount];

    NSString *dateString1 = [NSString stringWithUTF8String:InsertTime.c_str()];
    NSDate *date1 = [NSDate dp_dateFromString:dateString1 withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    cell.startTimeLabel.text = [date1 dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];
    NSString *dateString2 = [NSString stringWithUTF8String:EndTime.c_str()];
    NSDate *date2 = [NSDate dp_dateFromString:dateString2 withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    cell.endTimeLabel.text = [date2 dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];
    cell.peopleNameLabel.text = [NSString stringWithUTF8String:UserName.c_str()];
    cell.winInfoLabel.text = [NSString stringWithFormat:@"中%d次 共%d元", WinedCount, WinedAmount];
    [cell setLevelImageView:[NSString stringWithUTF8String:Scores.c_str()]];

    if (SysProcessStepId >= 6) {
        [cell setYongjinLabeText:[NSString stringWithUTF8String:WinedAmt.c_str()]];
        if ([[NSString stringWithUTF8String:WinedAmt.c_str()] floatValue] > 0.00) {
            cell.winImage.hidden = NO;

            if (TicketStatusId == 3) {
                cell.winImage.image = dp_ProjectImage(@"winseal.png");

            } else {
                cell.winImage.image = dp_ProjectImage(@"unwinseal.png");
            }
        } else {
            cell.winImage.hidden = YES;
        }

    } else {
        cell.winImage.hidden = YES;
        [cell setYongjinLabeText:@"--"];
    }
}
- (void)dealloc {
    REQUEST_CANCEL(_projCmdId);

    switch (self.gameType) {
        case GameTypeJcSpf:
        case GameTypeJcRqspf:
        case GameTypeJcZjq:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
            _CJCzqInstance->ProjectInfoClear();
            break;
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
            _CJCBdInstance->ProjectInfoClear();
            break;
        case GameTypeLcSf:
        case GameTypeLcDxf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcHt:
            _CJCLcInstance->ProjectInfoClear();
            break;
        case GameTypeSd:
            _lottery3DInstance->ProjectInfoClear();
            break;
        case GameTypeSsq:
            _CDInstance->ProjectInfoClear();
            break;
        case GameTypeQlc:
            _CSLLInstance->ProjectInfoClear();
            break;
        case GameTypeDlt:
            _CSLInstance->ProjectInfoClear();
            break;
        case GameTypePs:
            _Pl3Instance->ProjectInfoClear();
            break;
        case GameTypePw:
            _Pl5Instance->ProjectInfoClear();
            break;
        case GameTypeQxc:
            _SsInstance->ProjectInfoClear();
            break;
        case GameTypeHdsyxw:
            break;
        case GameTypeDfljy:
            break;
        case GameTypeZjtcljy:
            break;
            ;
        case GameTypeTc22x5:
            break;
        case GameTypeJxsyxw:
            _CJXInstance->ProjectInfoClear();
            break;
        case GameTypeNmgks:
            _CQTInstance->ProjectInfoClear();
            break;
        case GameTypeSdpks:
            _CPTInstance->ProjectInfoClear();
            break;
        case GameTypeHljsyxw:
            break;
        case GameTypeKlsf:
            break;
        case GameTypeZc14:
            _CLZ14Instance->ProjectInfoClear();
            break;
        case GameTypeZc9:
            _CLZ9Instance->ProjectInfoClear();
            break;
        default:
            break;
    }
}

- (void)pvt_onBack {
    if ([self backToRefresh] && [self.navigationController.viewControllers.firstObject isKindOfClass:[DPPersonalCenterViewController class]]) {
        DPPersonalCenterViewController* vc= (DPPersonalCenterViewController*)self.navigationController.viewControllers.firstObject ;
        [vc recordTabReset];
        [self.navigationController.viewControllers.firstObject panDidAppear];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)pvt_onShare
{
    for (UIView *view in self.view.window.subviews) {
        if ([view isKindOfClass:[DPShareView class]]) {
            return;
        }
    }
    DPShareView *shareView = [[DPShareView alloc]init];
    shareView.delegate = self;
    shareView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.navigationController.view addSubview:shareView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_thirdShareFinish:) name:dp_ThirdShareFinishKey object:nil];
}
- (void)dp_thirdShareFinish:(NSNotification *)notification
{
    BOOL result = [notification.userInfo[dp_ThirdShareResultKey] boolValue];
    int thirdType = [notification.userInfo[dp_ThirdType] intValue];
    if (result) {
        for (UIView *view in self.navigationController.view.subviews) {
            if ([view isKindOfClass:[DPShareView class]]) {
                [view removeFromSuperview];
            }
        }
         [[DPToast makeText:@"分享成功" color:[UIColor dp_colorFromHexString:@"#54b146"] style:DPToastStyleCorrect] show];
    }
}
#pragma mark - shareView deleagate
- (void)shareWithThirdType:(kThirdShareType)type
{
    int WinedAmount, WinedCount;
    string UserName, Scores, urlPath;
    _CpInstance->GetPCreaterInfo(UserName, Scores, WinedAmount, WinedCount);
    _CpInstance->GetProjectURL(urlPath);
    NSString *name = [NSString stringWithUTF8String:UserName.c_str()];
    NSString *title = @"分享了个中奖机会给您";
    NSString *content = nil;
    NSString *urlString = [NSString stringWithUTF8String:urlPath.c_str()];
    if (urlString.length == 0 || urlString == nil) {
        urlString = @"https://m.dacai.com/";
    }
    if (self.ProjectBuyId == 2){
        content = [NSString stringWithFormat:@"%@发起了一个%@合买方案。", name, dp_GameTypeFirstName(self.gameType)];
    }else if (self.ProjectBuyId != 2 && type == kThirdShareTypeQQzone){
        content = [NSString stringWithFormat:@"%@发起了一个%@代购方案。", name, dp_GameTypeFirstName(self.gameType)];
    }else{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, kScreenHeight), NO, 2.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.navigationController.view.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[DPThirdCallCenter sharedInstance] dp_shareWithType:type title:nil content:nil image:image urlString:urlString];
        return;
    }
    [[DPThirdCallCenter sharedInstance] dp_shareWithType:type title:title content:content image:nil urlString:urlString];

//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, kScreenHeight), NO, 2.0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self.navigationController.view.layer renderInContext:context];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    [[DPThirdCallCenter sharedInstance] dp_shareWithType:type title:nil content:nil image:image urlString:nil];
}
- (void)shareViewCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ThirdShareSuccess object:nil];
    
}
- (void)pvt_onTouzhu {
    switch (self.gameType) {
        case GameTypeSd: {
            [self.navigationController pushViewController:[[DPWF3DTicketTransferVC alloc] init] animated:YES];
        } break;
        case GameTypeSsq: {
            [self.navigationController pushViewController:[[DPDoubleHappyTransferVC alloc] init] animated:YES];
        } break;
        case GameTypeDlt: {
            [self.navigationController pushViewController:[[DPBigHappyTransferVC alloc] init] animated:YES];
        } break;
        case GameTypeQlc: {
            [self.navigationController pushViewController:[[DPSevenLuckTransferVC alloc] init] animated:YES];
        } break;
        case GameTypePs: {
            [self.navigationController pushViewController:[[DPRank3TransferVC alloc] init] animated:YES];
        } break;
        case GameTypePw: {
            [self.navigationController pushViewController:[[DPRank5TransferVC alloc] init] animated:YES];
        } break;
        case GameTypeQxc: {
            [self.navigationController pushViewController:[[DPSevenStartransferVC alloc] init] animated:YES];
        } break;
        case GameTypeJxsyxw: {
            DPElevnSelectFiveVC *vc = [[DPElevnSelectFiveVC alloc] init];
            DPElevnSelectFiveTransferVC *transVC = [[DPElevnSelectFiveTransferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeNmgks: {
            DPQuick3LotteryVC *vc = [[DPQuick3LotteryVC alloc] init];
            DPQuick3transferVC *transVC = [[DPQuick3transferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeSdpks: {
            DPPksBuyViewController *vc = [[DPPksBuyViewController alloc] init];
            DPPoker3transferVC *transVC = [[DPPoker3transferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeJcSpf:
        case GameTypeJcRqspf:
        case GameTypeJcZjq:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt: {
            DPJczqBuyViewController *dpVc = [[DPJczqBuyViewController alloc] init];
            dpVc.gameType = self.gameType;
            [self.navigationController pushViewController:dpVc animated:YES];
        } break;
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
        case GameTypeBdZjq: {
            DPBdBuyViewController *bdVc = [[DPBdBuyViewController alloc] init];
            bdVc.gameType = self.gameType;
            [self.navigationController pushViewController:bdVc animated:YES];
        } break;
        case GameTypeLcSf:
        case GameTypeLcDxf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcHt: {
            DPJclqBuyViewController *vc = [[DPJclqBuyViewController alloc] init];
            vc.gameType = self.gameType;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case GameTypeZc14:
            [self.navigationController pushViewController:[[DPSfcViewController alloc] init] animated:YES];
            break;
        case GameTypeZc9:
            [self.navigationController pushViewController:[[DPZcNineViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}

//未支付
- (void)pvt_onGoPay {

    _isClickPayButton = YES;
    [self changeCurBottom];
}

- (void)pvt_onCopy {
    int FilledAmountRate;
    int IsGlfa;
    int CanBuy;
    _CpInstance->GetPBaseInfo5(FilledAmountRate, CanBuy, IsGlfa);
    if (CanBuy) {
        switch (self.gameType) {
            case GameTypeSd: {
                _lottery3DInstance->PSave();
                DPWF3DTicketTransferVC *vc = [[DPWF3DTicketTransferVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } break;
            case GameTypeSsq: {
                _CDInstance->PSave();
                DPDoubleHappyTransferVC *vc = [[DPDoubleHappyTransferVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];

            } break;
            case GameTypeDlt: {
                _CSLInstance->PSave();
                DPBigHappyTransferVC *vc = [[DPBigHappyTransferVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];

            } break;
            case GameTypeQlc: {
                _CSLLInstance->PSave();
                DPSevenLuckTransferVC *vc = [[DPSevenLuckTransferVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } break;
            case GameTypePs: {
                _Pl3Instance->PSave();
                DPRank3TransferVC *vc = [[DPRank3TransferVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } break;
            case GameTypePw: {
                _Pl5Instance->PSave();
                DPRank5TransferVC *vc = [[DPRank5TransferVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } break;
            case GameTypeQxc: {
                _SsInstance->PSave();
                DPSevenStartransferVC *vc = [[DPSevenStartransferVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } break;
            case GameTypeJxsyxw: {
                _CJXInstance->PSave();
                DPElevnSelectFiveTransferVC *transVC = [[DPElevnSelectFiveTransferVC alloc] init];
                [self.navigationController pushViewController:transVC animated:YES];
            } break;
            case GameTypeNmgks: {
                _CQTInstance->PSave();
                DPQuick3transferVC *transVC = [[DPQuick3transferVC alloc] init];
                [self.navigationController pushViewController:transVC animated:YES];
            } break;
            case GameTypeSdpks: {
                _CPTInstance->PSave();
                DPPoker3transferVC *transVC = [[DPPoker3transferVC alloc] init];
                [self.navigationController pushViewController:transVC animated:YES];

            } break;
            default:
                break;
        }
    } else {
        [[DPToast makeText:@"当前无法复制投注"] show];
    }
}
//我的订单
- (void)tapOrderHeaderCell:(DProjectDetailMyOrderHeaderCell *)cell {
    _isSectionExpand[DProjectSectionTypeMyOrder] = !_isSectionExpand[DProjectSectionTypeMyOrder];

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:DProjectSectionTypeMyOrder] withRowAnimation:UITableViewRowAnimationFade];
}
//追号
- (void)tapFollowHeaderCell:(DProjectDetailFollowHeaderCell *)cell {

    _isSectionExpand[DProjectSectionTypeFollowSchedule] = !_isSectionExpand[DProjectSectionTypeFollowSchedule];

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:DProjectSectionTypeFollowSchedule] withRowAnimation:UITableViewRowAnimationFade];
}
//优化详情
- (void)tapOptimizeHeaderCell:(DProjectDetailOptimizeHeaderCell *)cell {
    _isSectionExpand[DProjectSectionTypeOptimizeDetail] = !_isSectionExpand[DProjectSectionTypeOptimizeDetail];

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:DProjectSectionTypeOptimizeDetail] withRowAnimation:UITableViewRowAnimationFade];
}
//方案内容
- (void)tapContentHeaderCell:(DProjectDetailContentHeaderCell *)cell {
    _isSectionExpand[DProjectSectionTypeProjectContent] = !_isSectionExpand[DProjectSectionTypeProjectContent];

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:DProjectSectionTypeProjectContent] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - DCLTProjectDetailFollowListCellDelegate

- (void)tapFollowListCell:(DProjectDetailFollowListCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSUInteger row = indexPath.row;
    int Multiple;
    int StatusId;
    int WinedAmount;
    string GameName;
    string StatusName;
    string Result;
    int index = row - 2;
    if (_followExpandIndex >= 0 && row > _followExpandIndex + 2) {
        index = row - 3;
    }
    _CpInstance->GetPFollowCell(index, Multiple, StatusId, WinedAmount, GameName, StatusName, Result);
    if (Result.length() < 1) {
        switch (StatusId) {
            case 0:
                [[DPToast makeText:@"当前方案未成功"] show];
                return;
                break;
            case 6:
                [[DPToast makeText:@"当前追号已暂停"] show];
                return;
                break;
            case 7:
                [[DPToast makeText:@"当前追号已取消"] show];
                return;
                break;
            case 2:
                [[DPToast makeText:@"当前出票失败"] show];
                return;
                break;
            case 9:
                [[DPToast makeText:@"当前追号已停止"] show];
                return;
                break;
            default:
                break;
        }
        [[DPToast makeText:@"当前未开奖"] show];
        return;
    }
    if (_followExpandIndex >= 0 && row > _followExpandIndex + 2) {
        row -= 1;
    }

    if (row == _followExpandIndex + 2) {
        _followExpandIndex = -1;
    } else {
        _followExpandIndex = row - 2;
    }

    [_tableView reloadData];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.rengouBotomView && obj.firstAttribute == NSLayoutAttributeBottom) {
            
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
    }
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
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}
- (void)pvt_onTap {
    if (self.rengouTf.isEditing) {
        [self.rengouTf resignFirstResponder];
        [self.rengouBotomView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if (constraint.firstItem == self.rengouBotomView && constraint.firstAttribute == NSLayoutAttributeBottom) {
                constraint.constant = 0;
                *stop = YES;
            }
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }

    [self pvt_hiddenCoverView:YES];
}
#pragma mark--UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
    });
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int aString = [newString intValue];

    if (textField == self.rengouTf) {
        int rengou = self.kerengouMoney;
        if (!_isRengou) {
            int IsCanVisit;
            int Quantity;
            int Multiple;
            int TotalAmount;
            int BuyedAmount;
            int FilledAmount;
            int JoinCount;
            int CommisionRate;
            int Commision;
            _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
            rengou = TotalAmount - BuyedAmount - FilledAmount;
        }
        if (newString.length == 0) {
            textField.text = @"";
            return NO;
        } else if (aString <= 0 && newString.length > 0) {
            aString = 0;
        }

        if (aString > rengou) {
            self.rengouTf.text = [NSString stringWithFormat:@"%d", rengou];
            if (_isRengou) {
                return NO;
            }
            return NO;
        }
    }
    self.rengouTf.text = [NSString stringWithFormat:@"%d", aString];

    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] <= 1) {
        textField.text = @"1";
    }
    int rengou = self.kerengouMoney;
    if (!_isRengou) {
        int IsCanVisit;
        int Quantity;
        int Multiple;
        int TotalAmount;
        int BuyedAmount;
        int FilledAmount;
        int JoinCount;
        int CommisionRate;
        int Commision;
        _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
        rengou = TotalAmount - BuyedAmount - FilledAmount;
    }
    if ([textField.text integerValue] > rengou) {
        self.rengouTf.text = [NSString stringWithFormat:@"%d", rengou];
        //        self.kerengouLabel.text=@"元，剩0元";
        if (_isRengou) {
            [[DPToast makeText:@"不能超过最大可认购数"] show];
            return;
        }
        [[DPToast makeText:@"不能超过最大可保底数"] show];
        return;
    }
    //    self.kerengouLabel.text=[NSString stringWithFormat:@"元，剩%d元",rengou-[textField.text integerValue]];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    return YES;
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        switch (cmdType) {
            case ACCOUNT_RED_PACKET: {
                [self dismissDarkHUD];
                if (ret < 0) {
                    NSString * titleStr = DPAccountErrorMsg(ret) ;

                    if(ret==ERROR_REDPKT_PRO_PASS || ret==ERROR_NOTPAY_HANDLED || ret==ERROR_NOTPAY_PASSED || ret==ERROR_NOTPAY_NOT_EXIST){
                        titleStr = [NSString stringWithFormat:@"%@,请刷新重试",titleStr] ;
                    }
                   [[DPToast makeText:titleStr] show];
                    
                    return ;
                }
                BOOL isRedpacket=NO;
                if (moduleInstance->GetPayRedPacketCount()) {
                     isRedpacket=YES;
                }
                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                viewController.gameTypeText = dp_GameTypeFullName(self.gameType);
                viewController.projectAmount = [self.rengouTf.text integerValue];
                viewController.gameType = self.gameType;
                viewController.buyType = 2;
                viewController.rengouType = _isRengou ? 1 : 2;
                viewController.projectid = self.projectId;
                viewController.delegate = self;
                viewController.entryType = kEntryTypeProject;
                viewController.isredPacket=isRedpacket;
                viewController.gameNameText = [NSString stringWithFormat:@"%d", self.gameName];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case PROJECTINFO: {
                [self dismissHUD];
                
                if (ret < 0) {
                    [[DPToast makeText:DPCommonErrorMsg(ret)] show];
                    // 要添加无数据图片
                } else {
                    // 解析数据
                    self.responseCount = self.responseCount + 1;
                    int ProjectBuyTypeId;
                    int ContentType;
                    int SysProcessStepId;
                    int ProjectStatusId;
                    int TicketStatusId;
                    int projectId = self.projectId;
                    int gameType = self.gameType;
                    _CpInstance->GetPBaseInfo(projectId, gameType, ProjectBuyTypeId, ContentType, SysProcessStepId, ProjectStatusId, TicketStatusId);
                    self.ProjectBuyId = ProjectBuyTypeId;
                    self.ProjectStatusId = ProjectStatusId;
                    self.contentType = ContentType;
                    self.sysProcessStepId = SysProcessStepId;
                    self.ticketStatusId = TicketStatusId;
                    int IsCanVisit;
                    int Quantity;
                    int Multiple;
                    int TotalAmount;
                    int BuyedAmount;
                    int FilledAmount;
                    int JoinCount;
                    int CommisionRate;
                    int Commision;
                    _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
                    self.kerengouMoney = TotalAmount - BuyedAmount;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    self.isVisible = IsCanVisit;
                    if (TotalAmount <= [self gainMyOrder]) {
                        _isAllBuy = YES;
                    } else {
                        _isAllBuy = NO;
                    }
                    [self upDateBootomView];
                }
            } break;
            case ACCOUNT_NOT_HANDLE_PAY: {
                [self dismissDarkHUD];
                if (ret < 0) {
                    NSString * titleStr = DPAccountErrorMsg(ret) ;
                    
                    if(ret==ERROR_REDPKT_PRO_PASS || ret==ERROR_NOTPAY_HANDLED || ret==ERROR_NOTPAY_PASSED || ret==ERROR_NOTPAY_NOT_EXIST){
                        titleStr = [NSString stringWithFormat:@"%@,请刷新重试",titleStr] ;
                    }
                   [[DPToast makeText:titleStr] show];
                    return;
                }
                CAccount *account=CFrameWork::GetInstance()->GetAccount();
                
                int pid, needAmt;
                string realAmt;
                    account->GetNotPayInfo(pid, realAmt, needAmt);
                    DPRechargeToPayVC *vc=[[DPRechargeToPayVC alloc]init];
                    vc.gameId=self.gameType;
                    vc.gameName=self.gameName;
                    vc.pid=pid;
                     vc.projectId=self.projectId;
                    vc.needAmt=[NSString stringWithFormat:@"%d",needAmt];
                    vc.realAmt=[NSString stringWithUTF8String:realAmt.c_str()];
                if (needAmt<=[vc.realAmt floatValue]) {
                    string purchaseOrderToken;
                    account->GetNotPayOrderToken(purchaseOrderToken);
                    vc.purchaseOrderToken=[NSString stringWithUTF8String:purchaseOrderToken.c_str()];
                }
                    [self.navigationController pushViewController:vc animated:YES];
              } break;
            default:
                break;
        }
    });
}

- (void)upDateBootomView {
    if (self.ProjectBuyId == 0) { //2 合买
        return;
    }

    int FilledAmountRate;
    int IsGlfa;
    int CanBuy;
    _CpInstance->GetPBaseInfo5(FilledAmountRate, CanBuy, IsGlfa);

    self.jcBottomView.hidden = YES;      //投注
    self.rengouBotomView.hidden = YES;   //认购，保底
                                         //    self.jcTBView.hidden = YES; //抱歉  投注
    self.digitalBottomView.hidden = YES; //继续  投注
    self.goPayBtn.hidden = YES;          //支付
    self.remindTitleView.hidden = YES;   //提示
    int height = -50;
    
    int orderId = 0, needAmt = 0;
    _CpInstance->GetPurchaseOrderInfo(orderId, needAmt);
    if (orderId > 0) { //未付款
        
        self.goPayBtn.hidden = NO;

//        if (self.ticketStatusId == 1 && orderId > 0) {
//
//            self.goPayBtn.hidden = NO;
//        } else if (self.ticketStatusId == 2) {
//            self.remindTitleView.hidden = NO;
//        } else {
//            if (CanBuy && !(IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType) || IsGameTypeBd(self.gameType) || IsGameTypeZc(self.gameType)) && self.contentType == 0) {
//                self.digitalBottomView.hidden = NO;
//            } else {
//                self.jcBottomView.hidden = NO;
//            }
//        }
        _payLabel.htmlText = [NSString stringWithFormat:@"<font color=\"#333333\">%@</font> <font color=\"#e7161a\">%d</font> 元", @"应支付", needAmt];
        
    }
    
    
    
    
    
    
    else if (self.ProjectStatusId == 1) { //未满
        if (self.ticketStatusId == 4) {
            if (CanBuy&& !IsGlfa && !(IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType) || IsGameTypeBd(self.gameType) || IsGameTypeZc(self.gameType)) && self.contentType == 0) {
                self.digitalBottomView.hidden = NO;
            } else {
                self.jcBottomView.hidden = NO;
            }
        } else {
            height = -80;
            self.rengouBotomView.hidden = NO;

            int rengou = self.kerengouMoney;
            if (!_isRengou) {
                int IsCanVisit;
                int Quantity;
                int Multiple;
                int TotalAmount;
                int BuyedAmount;
                int FilledAmount;
                int JoinCount;
                int CommisionRate;
                int Commision;
                _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
                rengou = TotalAmount - BuyedAmount - FilledAmount;
            }
            int kerengou = rengou;
            self.rengouTf.text = @"1";
            self.kerengouLabel.text = [NSString stringWithFormat:@"元，剩%d元", kerengou <= 0 ? 0 : kerengou];
        }
    } else if (self.ProjectStatusId == 2) { //成功
        if ((self.ticketStatusId == 1 || self.ticketStatusId == 2) && self.ProjectBuyId == 2) {
            if (_isAllBuy && !IsGlfa && !(IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType) || IsGameTypeBd(self.gameType) || IsGameTypeZc(self.gameType)) && self.contentType == 0) {
                self.digitalBottomView.hidden = NO;
            } else {
                self.remindTitleView.hidden = NO;
            }
        } else {
            if (CanBuy&& !IsGlfa && !(IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType) || IsGameTypeBd(self.gameType) || IsGameTypeZc(self.gameType)) && self.contentType == 0) {
                self.digitalBottomView.hidden = NO;
            } else {
                self.jcBottomView.hidden = NO;
            }
        }
    } else {
        if (CanBuy && !IsGlfa&& !(IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType) || IsGameTypeBd(self.gameType) || IsGameTypeZc(self.gameType)) && self.contentType == 0) {
            self.digitalBottomView.hidden = NO;
        } else {
            self.jcBottomView.hidden = NO;
        }
    }

    /*
    if(0){
        if (self.ProjectBuyId == 1 || // 代购
            self.ProjectBuyId == 3 || // 保存
            self.ProjectBuyId == 4)   // 代购追号
        {
            height = -50;
            if ((((self.gameType >= 1) && (self.gameType <= 11)) || ((self.gameType >= 201) && (self.gameType <= 207))) && CanBuy) {
                
                self.digitalBottomView.hidden = NO;//继续和投注都有
                
            } else {
                
                self.jcBottomView.hidden = NO;//只有投注按钮
            }
            
        } else {
            
            if (self.ProjectStatusId == 1) {
                self.rengouBotomView.hidden = NO;
                int rengou=self.kerengouMoney;
                if (!_isRengou) {
                    int IsCanVisit;
                    int Quantity;
                    int Multiple;
                    int TotalAmount;
                    int BuyedAmount;
                    int FilledAmount;
                    int JoinCount;
                    int CommisionRate;
                    int Commision;
                    _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
                    rengou=TotalAmount-BuyedAmount-FilledAmount;
                }
                int kerengou=rengou;
                self.kerengouLabel.text = [NSString stringWithFormat:@"元，剩%d元", kerengou<=0?0:kerengou];
            } else if (self.ProjectStatusId == 2){
            
                height = -50 ;
                self.remindTitleView.hidden = NO ;
            
            } else {
                
                height = -50 ;
                
                self.jcBottomView.hidden = NO;
                self.jcBottomView.backgroundColor=[UIColor whiteColor];
                    
            }
        }
        
    }
    */

    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.tableView && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = height;
            
            *stop = YES;
        }
    }];
    [self.view layoutIfNeeded];
}

//- (void)upDateBootomView {
//    if (self.ProjectBuyId == 0) {
//        return;
//    }
//
//
//    int FilledAmountRate;
//    int IsGlfa;
//    int CanBuy;
//    _CpInstance->GetPBaseInfo5(FilledAmountRate, CanBuy, IsGlfa);
//
//
//    self.continueView.hidden = YES;
//    self.jcBottomView.hidden = YES;
//    self.rengouBotomView.hidden = YES;
//    self.jcTBView.hidden = YES;
//    self.digitalBottomView.hidden = YES;
//    self.goPayBtn.hidden = YES;
//    int height = -80;
//
//    if (self.ProjectStatusId == 5) {
//        height = - 50;
//        self.goPayBtn.hidden = NO;
//    }else{
//        if (self.ProjectBuyId == 1 || // 代购
//            self.ProjectBuyId == 3 || // 保存
//            self.ProjectBuyId == 4)   // 代购追号
//        {
//            height = -50;
//            if ((((self.gameType >= 1) && (self.gameType <= 11)) || ((self.gameType >= 201) && (self.gameType <= 207))) && CanBuy) {
//
//                self.digitalBottomView.hidden = NO;//继续和投注都有
//
//            } else {
//
//                self.jcBottomView.hidden = NO;//只有投注按钮
//            }
//
//        } else {
//            if (self.ProjectStatusId == 1) {
//                self.rengouBotomView.hidden = NO;
//                int rengou=self.kerengouMoney;
//                if (!_isRengou) {
//                    int IsCanVisit;
//                    int Quantity;
//                    int Multiple;
//                    int TotalAmount;
//                    int BuyedAmount;
//                    int FilledAmount;
//                    int JoinCount;
//                    int CommisionRate;
//                    int Commision;
//                    _CpInstance->GetPBaseInfo2(IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision);
//                    rengou=TotalAmount-BuyedAmount-FilledAmount;
//                }
//                int kerengou=rengou;
//                self.kerengouLabel.text = [NSString stringWithFormat:@"元，剩%d元", kerengou<=0?0:kerengou];
//            } else {
//                height = -50 ;
//                if (((self.gameType >= 1) && (self.gameType <= 11)) || ((self.gameType >= 201) && (self.gameType <= 207))) {
//                    self.continueView.hidden = NO;
//
//                } else {
//                    if (self.ProjectStatusId == 2) {
//                        height = -80 ;
//                        self.jcTBView.hidden = NO;
//                        self.jcTBView.backgroundColor=[UIColor whiteColor];
//
//                    }else
//                    {
//                        height = -50 ;
//                        self.jcBottomView.hidden = NO;//只有投注按钮
//                    }
//                }
//            }
//        }
//
//    }
//    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
//        if (constraint.firstItem == self.tableView && constraint.firstAttribute == NSLayoutAttributeBottom) {
//            constraint.constant = height;
//
//            *stop = YES;
//        }
//    }];
//    [self.view layoutIfNeeded];
//}
- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType {
    if (ret >= 0) {
        [self goPayCallback];
    }
}

- (void)goPayCallback {
   
    int buyType;
    string guid;
    CFrameWork::GetInstance()->GetAccount()->GetJoinBuyWebPayment(buyType, guid);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kConfirmPayURL(buyType, [NSString stringWithUTF8String:guid.c_str()])]];
    kAppDelegate.gotoHomeBuy = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
