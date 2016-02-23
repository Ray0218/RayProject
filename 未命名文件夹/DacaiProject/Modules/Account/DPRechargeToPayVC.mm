//
//  DPRechargeToPayVC.m
//  DacaiProject
//
//  Created by sxf on 14/11/13.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRechargeToPayVC.h"
#import "DPRechargeBankCell.h"
#import "FrameWork.h"
#import "ModuleProtocol.h"
#import "WXApi.h"
#import <AlipaySDK/Alipay.h>
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"
#import "DPWebViewController.h"
#import "DPVerifyUtilities.h"
#import "DPPaytoBuySuccessVC.h"
#import "DPPersonalCenterViewController.h"
#import "DPAppParser.h"
#import "DPPayAlertView.h"
//static NSArray *rcImageNames = @[ @"zhifubao.png", @"zhifubao.png", @"weixin.png", @"yinlian.png", @"caifutong.png", @"xinyongka.png" ];
//static NSArray *rcTopNames = @[ @"支付宝快捷支付", @"支付宝网页支付", @"微信在线充值", @"银联卡在线充值", @"财付通充值", @"信用卡充值" ];
//static NSArray *rcBottomNames = @[ @"支持支付宝余额和银行卡充值", @"支持支付宝余额和银行卡充值", @"无需开通网银，支持信用卡、借记卡", @"无需开通网银，支持信用卡，借记卡", @"需开通财付通账号", @"支持招行、工行、建行等信用卡" ];
static NSArray *rcImageNames = @[  @"zhifubao.png", @"weixin.png"];
static NSArray *rcTopNames = @[ @"支付宝网页支付", @"微信在线支付" ];
static NSArray *rcBottomNames = @[ @"支持支付宝余额和银行卡支付", @"无需开通网银，支持信用卡、借记卡"];
@interface DPRechargeToPayVC () <UITableViewDelegate,
UITableViewDataSource,
//UITextFieldDelegate,
ModuleNotify,
WXApiDelegate,
DPPayAlertViewDelegate
//LTInterfaceDelegate
//DPRechargeCellDelegate,
//LLPaySdkDelegate,
//UmpayDelegate
> {
@private
    UITableView *_tableView;
//    BOOL _isBank;
    BOOL _isOtherRecharge;//其他支付方式
    BOOL isMoreMoney;//余额是都大于付款金额
    CAccount *_accountInstance;
    
    UIButton *_sureButton;
    UILabel *_lotteryInfoLabel;//订单彩种信息
    UILabel *_lotteryMoneyLabel;//订单总金额（若红包页面进,则除去红包后总额）
    UIButton *_yueBtn;//是否选择余额
    UILabel *_yueMoneyLabel;//余额
    UILabel * _sureMoneylabel;//最终还缺多少钱？
}
@property (nonatomic, strong, readonly) UITableView *tableView;
//@property (nonatomic, assign) int bankCount;//银行卡的个数
//@property (nonatomic, strong) LLPaySdk *sdk;//连连支付
//@property (nonatomic, strong) NSString *bankNo;//银行号码
@property (nonatomic, strong) NSDictionary *orderParam;
@property(nonatomic,strong,readonly)UIButton *sureButton;
@property(nonatomic,strong,readonly)UILabel *lotteryInfoLabel;
@property(nonatomic,strong,readonly)UILabel *lotteryMoneyLabel;
@property(nonatomic,strong,readonly)UIButton *yueBtn;
@property(nonatomic,strong,readonly)UILabel *yueMoneyLabel;
@property(nonatomic,strong,readonly)UILabel *sureMoneylabel;
@end

@implementation DPRechargeToPayVC
//- (LLPaySdk *)sdk {
//    if (_sdk == nil) {
//        _sdk = [[LLPaySdk alloc] init];
//        _sdk.sdkDelegate = self;
//    }
//    return _sdk;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _isBank = 0;
        _isOtherRecharge = 1;
        _accountInstance = CFrameWork::GetInstance()->GetAccount();
//        _accountInstance->ReLianLianBanks();
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _accountInstance->SetDelegate(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    [self.navigationController dp_applyGlobalTheme];
    self.title = @"选择支付方式";
    self.view.backgroundColor = UIColorFromRGB(0xe9e7e1);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiXinPayFinish:) name:@"WeiXinPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayWebFinish:) name:@"AlipayWeb" object:nil];

    [self buildLayout];
}

- (void)buildLayout {
    UIImageView *topView = [[UIImageView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    topView.userInteractionEnabled = YES;
    topView.image = [dp_AccountImage(@"account_wave.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [self.view addSubview:topView];
    
    UILabel *label1=[[UILabel alloc]init];
    label1.backgroundColor=[UIColor clearColor];
    label1.text=@"元";
    label1.textColor=[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
    label1.font=[UIFont dp_systemFontOfSize:12.0];
    [topView addSubview:label1];
    UILabel *label2=[[UILabel alloc]init];
    label2.backgroundColor=[UIColor clearColor];
    label2.text=@"元";
    label2.textColor=[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
    label2.font=[UIFont dp_systemFontOfSize:12.0];
    [topView addSubview:label2];
    UILabel *label31=[[UILabel alloc]init];
    label31.backgroundColor=[UIColor clearColor];
    label31.text=@"最终应付";
    label31.textColor=[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
    label31.textAlignment=NSTextAlignmentLeft;
    label31.font=[UIFont dp_systemFontOfSize:12.0];
    [topView addSubview:label31];
    UILabel *label32=[[UILabel alloc]init];
    label32.backgroundColor=[UIColor clearColor];
    label32.text=@"元";
    label32.textColor=[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
    label32.font=[UIFont dp_systemFontOfSize:12.0];
    [topView addSubview:label32];
    
    UIImageView *line1=[[UIImageView alloc] init];
    line1.backgroundColor=[UIColor colorWithRed:0.85 green:0.81 blue:0.72 alpha:1];
    [topView addSubview:line1];
    UIImageView *line2=[[UIImageView alloc] init];
    line2.backgroundColor=[UIColor colorWithRed:0.85 green:0.81 blue:0.72 alpha:1];
    [topView addSubview:line2];
    [topView addSubview:self.lotteryInfoLabel];
    [topView addSubview:self.lotteryMoneyLabel];
    [topView addSubview:self.yueBtn];
    [topView addSubview:self.yueMoneyLabel];
    [topView addSubview:self.sureMoneylabel];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.equalTo(@125);
        }];
    [self.lotteryInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(10);
        make.width.equalTo(@160);
        make.top.equalTo(topView).offset(5);
        make.height.equalTo(@30);
    }];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-10);
        make.width.equalTo(@20);
        make.top.equalTo(topView).offset(5);
        make.height.equalTo(@30);
    }];
    [self.lotteryMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lotteryInfoLabel.mas_right);
        make.right.equalTo(label1.mas_left);
        make.top.equalTo(topView).offset(5);
        make.height.equalTo(@30);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(10);
        make.right.equalTo(topView).offset(-10);
        make.top.equalTo(self.lotteryInfoLabel.mas_bottom).offset(5);
        make.height.equalTo(@0.5);
    }];
    [self.yueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(10);
        make.width.equalTo(@110);
        make.top.equalTo(line1).offset(5);
        make.height.equalTo(@30);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-10);
        make.width.equalTo(@20);
        make.top.equalTo(line1).offset(5);
        make.height.equalTo(@30);
    }];
    [self.yueMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lotteryInfoLabel.mas_right);
        make.right.equalTo(label2.mas_left);
        make.top.equalTo(line1).offset(5);
        make.height.equalTo(@30);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(10);
        make.right.equalTo(topView).offset(-10);
        make.top.equalTo(self.yueBtn.mas_bottom).offset(5);
        make.height.equalTo(@0.5);
    }];
    
    [label31 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(10);
        make.width.equalTo(@100);
        make.top.equalTo(line2).offset(5);
        make.height.equalTo(@30);
    }];
    [label32 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-10);
        make.width.equalTo(@20);
        make.top.equalTo(line2).offset(5);
        make.height.equalTo(@30);
    }];
    [self.sureMoneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lotteryInfoLabel.mas_right);
        make.right.equalTo(label2.mas_left);
        make.top.equalTo(line2).offset(5);
        make.height.equalTo(@30);
    }];
    
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.tableView];
    
    [self.view bringSubviewToFront:topView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.bottom.equalTo(self.view);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(topView.mas_bottom).offset(13);
        make.height.equalTo(@40);
    }];
    if ([self.sureMoneylabel.text floatValue]>0) {
        self.tableView.hidden=NO;
        self.sureButton.hidden=YES;
        [self.tableView reloadData];
    }else{
    self.tableView.hidden=YES;
    self.sureButton.hidden=NO;
    }
    
}


#pragma mark--UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        if (_isOtherRecharge) {
            return 2;
        }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"otherCell";
    DPRechargeOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPRechargeOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.rechargeImageView.image = dp_AccountImage(rcImageNames[indexPath.row]);
    cell.topLabel.text = rcTopNames[indexPath.row];
    cell.bottomLabel.text = rcBottomNames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 33;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *backView = [UIView dp_viewWithColor:UIColorFromRGB(0xffffff)];
    backView.layer.borderColor = UIColorFromRGB(0xdad69c).CGColor;
    backView.layer.borderWidth = 0.5;
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB(0x7b6d5c);
    label.text = @"其他支付方式";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont dp_systemFontOfSize:14.0];
    [backView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView).offset(-50);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:_isOtherRecharge ? dp_CommonImage(@"black_arrow_up.png") : dp_CommonImage(@"black_arrow_down.png")];
    rightImageView.backgroundColor = [UIColor clearColor];
    [backView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-10);
        make.centerY.equalTo(backView);
    }];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHeaderTap:)]];
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self showDarkHUD];
            _accountInstance->NGenNotPayRedis(self.sureMoneylabel.text.UTF8String, self.pid);
        } break;
        case 1: {
            if (![WXApi isWXAppInstalled]) {
                [[DPToast makeText:@"请安装微信"] show];
                return;
            }
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];   // 类型
            [formatter setMaximumFractionDigits:0];                     // 保留0位小数
            [formatter setMinimumFractionDigits:0];                     // 保留0位小数
            [formatter setRoundingMode:NSNumberFormatterRoundCeiling];  // 进位
             NSDecimalNumber *sureAmt = [NSDecimalNumber decimalNumberWithString:self.sureMoneylabel.text];
             NSString *realAmtStr = [formatter stringFromNumber:sureAmt];
             NSDecimalNumber *realAmt = [NSDecimalNumber decimalNumberWithString:realAmtStr];
            [self showDarkHUD];
            _accountInstance->RefreshWeChatTopup([realAmt integerValue], self.pid);
                }
            break;
        default:
            break;
    }
}

-(void)payAlertViewSure:(DPPayAlertView *)payAlertView{
    [UIView animateWithDuration:0.2 animations:^{
        [payAlertView.superview setAlpha:0];
    } completion:^(BOOL finished) {
        [payAlertView.superview removeFromSuperview];
    }];
    [self weChatStartRequest];
   
}

-(void)payAlertViewCancle:(DPPayAlertView *)payAlertView{
    [UIView animateWithDuration:0.2 animations:^{
        [payAlertView.superview setAlpha:0];
    } completion:^(BOOL finished) {
        [payAlertView.superview removeFromSuperview];
    }];
  

}
//当金额不为整数时，需要弹框提示（微信）
-(void)gotoPayAlertView{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];   // 类型
    [formatter setMaximumFractionDigits:0];                     // 保留0位小数
    [formatter setMinimumFractionDigits:0];                     // 保留0位小数
    [formatter setRoundingMode:NSNumberFormatterRoundCeiling];  // 进位
    
    // 需要支付的金额
    NSDecimalNumber *sureAmt = [NSDecimalNumber decimalNumberWithString:self.sureMoneylabel.text];
    NSString *realAmtStr = [formatter stringFromNumber:sureAmt];
    // 需要充值的金额
    NSDecimalNumber *realAmt = [NSDecimalNumber decimalNumberWithString:realAmtStr];
    
    if ([sureAmt compare:realAmt] != NSOrderedSame) {
        // 剩余要返回账户的金额
        NSDecimalNumber *surplusAmt = [realAmt decimalNumberBySubtracting:sureAmt];
        
        NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
        [formatter1 setNumberStyle:NSNumberFormatterNoStyle];   // 类型
        [formatter1 setMaximumFractionDigits:2];                     // 保留2位小数
        [formatter1 setMinimumFractionDigits:2];                     // 保留2位小数
        [formatter1 setMinimumIntegerDigits:1];                     // 整位保留1位
        [formatter1 setRoundingMode:NSNumberFormatterRoundFloor];    // 截取
        
        UIView* covvewView = [[UIView alloc]init];
        covvewView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6] ;
        
        [self.navigationController.view addSubview:covvewView];
        
        [covvewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view);
        }];
        
        DPPayAlertView *alertView=[[DPPayAlertView alloc] init];
        [alertView buildLayoutForEgLabelText:@"由于微信支付方式必须为整数，故我们将对您的支付金额进位取整，多余的金额将会返还到您的大彩账户中"];
        alertView.delegate=self;
        [covvewView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(covvewView);
            make.right.equalTo(covvewView);
            make.height.equalTo(@(220));
            make.centerY .equalTo(covvewView.mas_centerY) ;
        }];
        
        NSMutableAttributedString *payMoneyText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d元",[realAmt integerValue]]];
        [payMoneyText addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0, payMoneyText.length-1)];
        NSMutableAttributedString *backMoneyText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", [formatter1 stringFromNumber:surplusAmt]]];
        [backMoneyText addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0, backMoneyText.length-1)];
        [alertView.payMoneyLabel setAttributedText:payMoneyText];
        [alertView.backMoneyLabel setAttributedText:backMoneyText];
        return;
    }
    [self weChatStartRequest];
    
}
//显示充值方式
- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)gesture {
    _isOtherRecharge = !_isOtherRecharge;
    [self.tableView reloadData];
}

//返回
- (void)pvt_onBack {
    // 后退到上上个界面
    DbgAssert(self.navigationController.viewControllers.count >= 3);
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
}

//确认支付
- (void)pvt_onNext {
    if ((self.pid<=0)||(self.purchaseOrderToken.length<1)) {
        return;
    }
    NSString *urlString = kUnpaidURL(self.purchaseOrderToken);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    kAppDelegate.gotoHomeBuy = YES;
}

-(void)pvt_yue:(UIButton *)button{
    button.selected=!button.selected;
    NSDecimalNumber *needAmt = [NSDecimalNumber decimalNumberWithString:self.needAmt];
    NSDecimalNumber *realAmt = [NSDecimalNumber decimalNumberWithString:self.realAmt];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];   // 类型
    [formatter setMaximumFractionDigits:2];                     // 保留2位小数
    [formatter setMinimumFractionDigits:2];                     // 保留2位小数
    [formatter setMinimumIntegerDigits:1];                     // 整位保留1位
    [formatter setRoundingMode:NSNumberFormatterRoundFloor];    // 截取
    
    if (button.selected) {
        self.tableView.hidden=YES;
        self.sureButton.hidden=NO;
        if ([needAmt compare:realAmt] == NSOrderedAscending) {
            _sureMoneylabel.text = @"0.00";
        } else {
            self.tableView.hidden=NO;
            self.sureButton.hidden=YES;
            NSDecimalNumber *finalAmt = [needAmt decimalNumberBySubtracting:realAmt];
            _sureMoneylabel.text = [formatter stringFromNumber:finalAmt];
        }
    }else{
        self.tableView.hidden=NO;
        self.sureButton.hidden=YES;
        _sureMoneylabel.text = [formatter stringFromNumber:needAmt];
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
- (UIButton *)sureButton {
    if (_sureButton == nil) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [_sureButton setTitle:@"确认支付" forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius=2;
        _sureButton.titleLabel.font=[UIFont dp_systemFontOfSize:15.0];
        [_sureButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(pvt_onNext) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sureButton;
}

- (UILabel *)lotteryInfoLabel {
    if (_lotteryInfoLabel == nil) {
        _lotteryInfoLabel = [[UILabel alloc] init];
        _lotteryInfoLabel.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];;
        _lotteryInfoLabel.backgroundColor = [UIColor clearColor];
        _lotteryInfoLabel.font = [UIFont dp_systemFontOfSize:13.0];
        _lotteryInfoLabel.textAlignment = NSTextAlignmentLeft;
        if (IsGameTypeJc(self.gameId) || IsGameTypeLc(self.gameId)){
        _lotteryInfoLabel.text = [NSString stringWithFormat:@"%@",dp_GameTypeFirstName(self.gameId)];
        return _lotteryInfoLabel;
        }
        NSString *qihao=[NSString stringWithFormat:@" %d期",self.gameName];
        if(self.gameName<=0){
        qihao =@" 不定期";
        }
         NSMutableAttributedString *stringM = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",dp_GameTypeFirstName(self.gameId),qihao]];
        [stringM addAttribute:NSFontAttributeName value:[UIFont dp_systemFontOfSize:11] range:NSMakeRange(stringM.length-qihao.length, qihao.length)];
        _lotteryInfoLabel.attributedText = stringM;
       
    }
    return _lotteryInfoLabel;
}
- (UILabel *)lotteryMoneyLabel {
    if (_lotteryMoneyLabel == nil) {
        _lotteryMoneyLabel = [[UILabel alloc] init];
        _lotteryMoneyLabel.text = [NSString stringWithFormat:@"%d",[self.needAmt integerValue]];;
        _lotteryMoneyLabel.textColor = [UIColor dp_flatRedColor];
        _lotteryMoneyLabel.backgroundColor = [UIColor clearColor];
        _lotteryMoneyLabel.font = [UIFont dp_systemFontOfSize:13.0];
        _lotteryMoneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _lotteryMoneyLabel;
}
- (UIButton *)yueBtn {
    if (_yueBtn == nil) {
        _yueBtn = [[UIButton alloc] init];
        _yueBtn.backgroundColor=[UIColor clearColor];
        [_yueBtn setImage:dp_AccountImage(@"nopayNormal.png") forState:UIControlStateNormal];
        [_yueBtn setImage:dp_AccountImage(@"nopaySelected.png") forState:UIControlStateSelected];
        _yueBtn.selected=YES;
        [_yueBtn setTitle:@" 是否使用余额" forState:UIControlStateNormal];
        [_yueBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        _yueBtn.titleLabel.font=[UIFont dp_systemFontOfSize:13.0];
        _yueBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
        [_yueBtn setTitleColor:[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1] forState:UIControlStateNormal];
        [_yueBtn addTarget:self action:@selector(pvt_yue:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _yueBtn;
}
- (UILabel *)yueMoneyLabel {
    if (_yueMoneyLabel == nil) {
        _yueMoneyLabel = [[UILabel alloc] init];
        if (self.realAmt.length<1) {
            _yueMoneyLabel.text =@"0.00";
        }else{
        _yueMoneyLabel.text = [NSString stringWithFormat:@"%@",self.realAmt];
        }
        _yueMoneyLabel.textColor =  [UIColor dp_flatRedColor];
        _yueMoneyLabel.backgroundColor = [UIColor clearColor];
        _yueMoneyLabel.font = [UIFont dp_systemFontOfSize:13.0];
        _yueMoneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _yueMoneyLabel;
}
- (UILabel *)sureMoneylabel {
    if (_sureMoneylabel == nil) {
        _sureMoneylabel = [[UILabel alloc] init];
        _sureMoneylabel.textColor = [UIColor dp_flatRedColor];
        _sureMoneylabel.backgroundColor = [UIColor clearColor];
        _sureMoneylabel.font = [UIFont dp_systemFontOfSize:13.0];
        _sureMoneylabel.textAlignment = NSTextAlignmentRight;
        
        NSDecimalNumber *needAmt = [NSDecimalNumber decimalNumberWithString:self.needAmt];
        NSDecimalNumber *realAmt = [NSDecimalNumber decimalNumberWithString:self.realAmt];
        
        if ([needAmt compare:realAmt] == NSOrderedAscending) {
            _sureMoneylabel.text = @"0.00";
        } else {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterNoStyle];   // 类型
            [formatter setMaximumFractionDigits:2];                     // 保留2位小数
            [formatter setMinimumFractionDigits:2];                     // 保留2位小数
            [formatter setMinimumIntegerDigits:1];                     // 整位保留1位
            [formatter setRoundingMode:NSNumberFormatterRoundFloor];    // 截取
            
            NSDecimalNumber *finalAmt = [needAmt decimalNumberBySubtracting:realAmt];
            _sureMoneylabel.text = [formatter stringFromNumber:finalAmt];
        }
    }
    return _sureMoneylabel;
}

#pragma mark - Mod  uleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissDarkHUD];
        if (ret < 0) {
            NSString *errorString = nil;
            if (ret <= -800) {
                errorString = [DPErrorParser AccountErrorMsg:ret];
            } else {
                errorString = [DPErrorParser CommonErrorMsg:ret];
            }
            [[DPToast makeText:errorString] show];
            return;
        }
        
        switch (cmdtype) {
            case ACCOUNT_WECHATTOPUP://微信
            {
                [self gotoPayAlertView];
            }
                break;
                case ACCOUNT_NOTPAY_GENREDIS:
            {
                string purchaseOrderToken;
                _accountInstance->GetNotPayTopupToken(purchaseOrderToken);
                if(purchaseOrderToken.length()<1){
                    [DPToast makeText:@"支付失败"];
                    return;
                }
                NSString *url = kAlipayTopupPayURL([NSString stringWithUTF8String:purchaseOrderToken.c_str()]);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                kAppDelegate.gotoHomeBuy = YES;
            
            }
                break;
            default:
                break;
        }
    });
}
//开始跳转微信界面
-(void)weChatStartRequest{
    string signature;
    string noncestr;
    string package;
    string partnerid;
    string prepayid;
    string timestamp;
    int index=_accountInstance->GetWeChatTopup(signature, noncestr, package, partnerid, prepayid, timestamp);
    if (index<0) {
        [[DPToast makeText:@"系统繁忙"] show];
        return ;
    }
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [NSString stringWithUTF8String:partnerid.c_str()];
    request.prepayId = [NSString stringWithUTF8String:prepayid.c_str()];
    request.package = [NSString stringWithUTF8String:package.c_str()]; // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
    request.nonceStr = [NSString stringWithUTF8String:noncestr.c_str()];
    request.timeStamp = [[NSString stringWithUTF8String:timestamp.c_str()] integerValue];
    request.sign = [NSString stringWithUTF8String:signature.c_str()];
    
    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
    [WXApi sendReq:request];
}
#pragma make - 支付宝网页支付
- (void)alipayWebFinish:(NSNotification *)notify
{
    NSDictionary * userInfo = [notify userInfo];
    NSURL * url = [userInfo objectForKey:@"URL"];
    if ([[url resourceSpecifier] hasSuffix:@"app_buycenter"])
    {
        
    }
}



#pragma make-- 微信支付
- (void)WeiXinPayFinish:(NSNotification *)notify {
    NSDictionary * userInfo = [notify userInfo];
    NSURL * url=[userInfo objectForKey:@"URL"];
    [WXApi handleOpenURL:url delegate:self];
    
}
-(void) onResp:(BaseResp*)resp{
    if (resp.errCode>=0) {
        dispatch_async(dispatch_get_main_queue(),^{
            DPPaytoBuySuccessVC *vc=[[DPPaytoBuySuccessVC alloc] init];
            vc.gameId=self.gameId;
            vc.projectId=self.projectId;
            [self.navigationController pushViewController:vc animated:YES];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(),^{
        if (resp.errCode==-2){
        [[DPToast makeText:@"取消支付"] show];
            return ;
        }
        [[DPToast makeText:@"支付失败"] show];
    });
}


@end
