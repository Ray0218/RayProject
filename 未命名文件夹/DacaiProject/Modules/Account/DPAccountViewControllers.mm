//
//  DPAccountViewControllers.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAccountViewControllers.h"
#import "FrameWork.h"
#import "NotifyType.h"
#import <SSKeychain.h>
#import "DPVerifyUtilities.h"
#import "DPSecurityAccNameVC.h"
#import "DPWebViewController.h"
#import "DPPersonalCenterViewController.h"
#import "DPKeyboardCenter.h"
#import "DPAppParser.h"
#import "DPSecurityCenterViewController.h"
#import "DPThirdCallCenter.h"
#define thirdButtonTag 1210
#define kLoginBtnTagBase 70
@interface DPLoginViewController () <UITextFieldDelegate, ModuleNotify, DPKeyboardCenterDelegate> {
@private
    UITextField     *_userNameField;
    UITextField     *_passwordField;
    UIScrollView    *_scrollView;
//    UIButton        *_loginBtn;
    CAccount *_accountInstance;
    UILabel         *_adLable; // 广告
    CLotteryCommon  *_lotteryCommon;
    BOOL _canWriteIn ;
    
    CGFloat _lastOffset ;
}

@property (nonatomic, strong, readonly) UITextField *userNameField;
@property (nonatomic, strong, readonly) UITextField *passwordField;
@property (nonatomic, strong) TencentOAuth *autho;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, assign) int thirdType;
@end

@implementation DPLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _accountInstance = CFrameWork::GetInstance()->GetAccount();
        _lotteryCommon = CFrameWork :: GetInstance() -> GetLotteryCommon();
    }
    return self;
}
- (void)viewDidLoad {   
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1]];
    self.view.backgroundColor = [UIColor clearColor];
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    _scrollView = ({
       UIScrollView *scroll = [[UIScrollView alloc]init];
//        scroll.backgroundColor = [UIColor redColor];
        scroll.scrollEnabled = YES;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        [scroll setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1]];
//        scroll.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_contentviewTap)];
        [scroll addGestureRecognizer:tap];
        scroll;
    });
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1];
    [_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
        make.width.equalTo(_scrollView);
        make.height.equalTo(_scrollView).offset(40);
    }];
    
    UIImageView *headerView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"loginbg.png")];;
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    UIButton *homeButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:dp_NavigationImage(@"back.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onBack) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    [self.view addSubview:_scrollView];
    [contentView addSubview:headerView];
    [_scrollView dp_setWeakObject:headerView forKey:@"dp_login_headerView"];
//    [headerView addSubview:homeButton];
    [_scrollView  addSubview:homeButton];
//    [_scrollView dp_setStrongObject:homeButton forKey:@"dp_login_homeButton"];
    [self.view addSubview:homeButton];

//    [headerView addSubview:regButton];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        if (version < 7.0) {
            make.height.equalTo(@146.5);
        }
    }];
    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IOS_VERSION_7_OR_ABOVE) {
            make.top.equalTo(self.view).offset(25);
        } else {
            make.top.equalTo(self.view).offset(5);
        }
        make.left.equalTo(self.view);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];

    UIImageView *bigImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"bigpeople.png")];
        imageView;
    });

    UILabel *titlelabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor=[UIColor clearColor];
        label.text=@"欢迎登录大彩网";
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor dp_flatWhiteColor];
        label.font=[UIFont dp_systemFontOfSize:15.0];
        label;
    });

    [headerView addSubview:bigImage];
    [headerView addSubview:titlelabel];
    [bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.centerY.equalTo(headerView).offset(20);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigImage.mas_bottom).offset(3);
        make.centerX.equalTo(headerView);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    UIView *lineView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1];
        view;
    });
    UIImageView *usrImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"login_usr.png")];
        imageView;
    });
    UIImageView *pwdImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"login_pwd.png")];
        imageView;
    });

    [contentView addSubview:fieldView];
    [fieldView addSubview:self.userNameField];
    [fieldView addSubview:self.passwordField];
    [fieldView addSubview:usrImage];
    [fieldView addSubview:pwdImage];
    [fieldView addSubview:lineView];
    
    
    [self.userNameField addTarget:self action:@selector(pvt_editingDidEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordField addTarget:self action:@selector(pvt_editingDidEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(20);
        make.right.equalTo(contentView).offset(-20);
        make.top.equalTo(headerView.mas_bottom).offset(30);
        make.height.equalTo(@80);
    }];
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-40);
        make.top.equalTo(fieldView);
        make.height.equalTo(@40);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-40);
        make.bottom.equalTo(fieldView);
        make.height.equalTo(@40);
    }];
    [usrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fieldView).offset(-10);
        make.centerY.equalTo(self.userNameField);
    }];
    [pwdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fieldView).offset(-10);
        make.centerY.equalTo(self.passwordField);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView);
        make.right.equalTo(fieldView);
        make.top.equalTo(fieldView).offset(40);
        make.height.equalTo(@0.5);
    }];

    //忘记密码
    UIButton *forgetPasswordButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(pvt_onForgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.13 green:0.32 blue:0.63 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:11.0]];
        button;
    });
    [contentView addSubview:forgetPasswordButton];
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fieldView.mas_bottom).offset(5);
        make.width.equalTo(@60);
        make.right.equalTo(fieldView);
        make.height.equalTo(@20);
    }];
    //登录
    UIButton *loginButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"登  录" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        button.tag = kLoginBtnTagBase + 1;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:15]];
        button;
    });
    UIButton *registBtn = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor dp_flatWhiteColor];
        [button addTarget:self action:@selector(pvt_onReg) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"注 册" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:15]];
//        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor dp_colorFromHexString:@"ccc4c1"].CGColor;
        button;
    });
    
    [contentView addSubview:loginButton];
    [contentView addSubview:registBtn];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetPasswordButton.mas_bottom).offset(5);
        make.left.equalTo(fieldView);
        make.right.equalTo(fieldView);
        make.height.equalTo(@36);
    }];
    
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(10);
        make.left.equalTo(fieldView);
        make.right.equalTo(fieldView);
        make.height.equalTo(@36);
    }];
    
//    return;

    //第三方登录
    UIImageView *line1 = [[UIImageView alloc] init];
    line1.backgroundColor = [UIColor clearColor];
    line1.image = dp_AccountImage(@"loginleftLine.png");

    UIImageView *line2 = [[UIImageView alloc] init];
    line2.backgroundColor = [UIColor clearColor];
    line2.image = dp_AccountImage(@"loginRightLine.png");

    UILabel *loginlabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor=[UIColor clearColor];
        label.text=@"合作账号登录";
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor dp_flatBlackColor];
        label.font=[UIFont dp_systemFontOfSize:10.0];
        label;
    });
    [contentView addSubview:line1];
    [contentView addSubview:line2];
    [contentView addSubview:loginlabel];
    [loginlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registBtn.mas_bottom).offset(10);
        make.centerX.equalTo(fieldView);
        make.width.equalTo(@65);
        make.height.equalTo(@15);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginlabel);
        make.right.equalTo(loginlabel.mas_left);
        make.width.equalTo(@110);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginlabel);
        make.width.equalTo(@110);
        make.left.equalTo(loginlabel.mas_right);
        make.height.equalTo(@0.5);
    }];

//    UIButton *zhufuButton = ({
//        UIButton *button = [[UIButton alloc] init];
//        button.backgroundColor=UIColorFromRGB(0XFFFFFF);
//        [button addTarget:self action:@selector(pvt_onThirdLogin:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitle:@"支付宝" forState:UIControlStateNormal];
//        button.layer.cornerRadius = 5;
//        button.layer.borderWidth = 0.5;
//        button.layer.borderColor =UIColorFromRGB(0xdcd7d3).CGColor;
//        [button setImage:dp_AccountImage(@"loginzfb.png") forState:UIControlStateNormal];
//        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//        button.tag=thirdButtonTag;
//        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:13.0]];
//        [button setImage:dp_AccountImage(@"loginzfb.png") forState:UIControlStateHighlighted];
//        [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_colorFromHexString:@"#DAD6CA"]] forState:UIControlStateHighlighted];
//        button;
//    });
    UIButton *qqButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0XFFFFFF);
        [button addTarget:self action:@selector(pvt_onThirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@" QQ" forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor =UIColorFromRGB(0xdcd7d3).CGColor;
        [button setImage:dp_AccountImage(@"login_QQ.png") forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button.tag=thirdButtonTag+1;
        [button setImage:dp_AccountImage(@"login_QQ.png") forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_colorFromHexString:@"#DAD6CA"]] forState:UIControlStateHighlighted];
        button;
    });
    
    NSString *xlImgName = @"loginxinlang.png";
    BOOL xlEnable = YES;
    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeSinaWB]) {
        xlImgName = @"loginxinlang_hui.png";
        xlEnable = NO;
    }
    
    NSString *WXImgName = @"loginweixin.png";
    BOOL wxEnable = YES;
    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeWXC]) {
        WXImgName = @"登录_03.png";
        wxEnable = NO;
    }
    
    UIButton *xlButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0XFFFFFF);
        [button addTarget:self action:@selector(pvt_onThirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"新浪微博" forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor =UIColorFromRGB(0xdcd7d3).CGColor;
        [button setImage:dp_AccountImage(xlImgName) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:13.0]];
        button.tag=thirdButtonTag+2;
        [button setImage:dp_AccountImage(xlImgName) forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_colorFromHexString:@"#DAD6CA"]] forState:UIControlStateHighlighted];
        button.userInteractionEnabled = xlEnable;
        button;
    });
    UIButton *wxButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0XFFFFFF);
        [button addTarget:self action:@selector(pvt_onThirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@" 微信" forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor =UIColorFromRGB(0xdcd7d3).CGColor;
        [button setImage:dp_AccountImage(WXImgName) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:13.0]];
        button.tag=thirdButtonTag+3;
        [button setImage:dp_AccountImage(WXImgName) forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_colorFromHexString:@"#DAD6CA"]] forState:UIControlStateHighlighted];
        button.userInteractionEnabled = wxEnable;
        button;
    });
//    [contentView addSubview:zhufuButton];
    [contentView addSubview:qqButton];
    [contentView addSubview:xlButton];
    [contentView addSubview:wxButton];
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginlabel.mas_bottom).offset(10);
        make.height.equalTo(@38);
        make.left.equalTo(loginButton);
        make.width.equalTo(@86.7);
    }];
    [xlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqButton);
        make.height.equalTo(@38);
        make.left.equalTo(qqButton.mas_right).offset(9);
        make.width.equalTo(@86.7);
    }];
    [wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqButton);
        make.height.equalTo(@38);
        make.left.equalTo(xlButton.mas_right).offset(9);
        make.width.equalTo(@86.7);
//        make.bottom.equalTo(contentView).offset(40);
    }];
//    [wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(qqButton.mas_bottom).offset(10);
//        make.height.equalTo(@35);
//        make.left.equalTo(xlButton.mas_right).offset(9);
//        make.width.equalTo(@131.5);
//    }];
    
    UILabel *adLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatRedColor];
        label.font = [UIFont dp_systemFontOfSize:15];
        label.text = @"广告位置";
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_adLabelClick)];
        singleTap.numberOfTapsRequired = 1;
        [label addGestureRecognizer:singleTap];
        label;
    });
    [contentView addSubview:adLabel];
    _adLable = adLabel;
    
    [adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
//        make.bottom.equalTo(contentView).offset(- 10);
        make.top.equalTo(xlButton.mas_bottom).offset(20);
//        make.bottom.equalTo(self.view).offset(- 35);
    }];
    
    _lastOffset = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_ThirdLoginSuccess:) name:dp_ThirdLoginSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _accountInstance->SetDelegate(self);
    _canWriteIn = YES ;
    [self.xt_sideMenuViewController setPanGestureEnabled:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [[DPKeyboardCenter defaultCenter] addListener:self type:DPKeyboardListenerEventWillShow | DPKeyboardListenerEventWillHide];

    string adv, event;
    _lotteryCommon -> GetAdsLogin(adv, event);
    NSString *advString = [NSString stringWithUTF8String:adv.c_str()];
    _adLable.text = advString;
    
}
- (void)dp_ThirdLoginSuccess:(NSNotification *)info
{

    self.accessToken = info.userInfo[dp_ThirdOauthAccessToken];
    self.userID = info.userInfo[dp_ThirdOauthUserIDKey];
    self.thirdType = [info.userInfo[dp_ThirdType] intValue];
    [self showDarkHUD];
    
//    NSString *token = self.accessToken;
//    if (self.thirdType == 9) {
//        token = self.userID;
//    }
    _accountInstance->Net_OAuthLogin(self.accessToken.UTF8String, self.userID.UTF8String, self.thirdType);
    DPLog(@"c++ 登录接口调用一次----------记录");
//    if (_accountInstance->Login(qqAccessToken.UTF8String, qqOpenID.UTF8String) >= 0) {
//        [self.view.window showDarkHUD];
//    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [self.xt_sideMenuViewController setPanGestureEnabled:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [_userNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [[DPKeyboardCenter defaultCenter] removeListener:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
}

- (void)willPanHide {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
- (void)pvt_onBack {
    [self.view endEditing:YES];
    
    if (self.homeEntry) {
        [self.xt_sideMenuViewController hideMenuViewController];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)pvt_onReg {

    [self.navigationController pushViewController:[[DPRegisterViewController alloc] init] animated:YES];
}

- (void)pvt_adLabelClick
{
    DPLog(@"广告位点击");
    
    string adv, event;
    _lotteryCommon -> GetAdsLogin(adv, event);
    NSString *eventString = [NSString stringWithUTF8String:event.c_str()];
    if (eventString.length > 0) {
        NSData *data = [eventString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *obj = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]:nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [DPAppParser rootViewController:nil animated:NO userInfo:obj];
        }
    }
}
- (void)pvt_onSure {
    [self.view endEditing:YES];
    if (self.userNameField.text.length<1) {
         [[DPToast makeText:@"用户名不能为空"]show];
        return;
    }else if ([self caculateTheLength:self.userNameField.text]+self.userNameField.text.length>12){
        [[DPToast makeText:@"用户名长度不能超过12个字符"]show];
        return ;
    }
    if (self.passwordField.text.length<1) {
        [[DPToast makeText:@"密码不能为空"]show];
        return;
    }
    if (_accountInstance->Login([self.userNameField.text UTF8String], [self.passwordField.text UTF8String]) >= 0) {
        [self.view.window showDarkHUD];
    } else {
        [[DPToast makeText:@"用户名或密码不正确"] show];
    }
}

- (void)pvt_onThirdLogin:(UIButton *)button {
    
    DPLog(@"disanfang  denglu ");
    
    switch (button.tag - thirdButtonTag) {
        case 0:{ // 支付宝
//         [DPThirdCallCenter sharedInstance]
        }
            break;
        case 1:{
            [[DPThirdCallCenter sharedInstance] dp_QQLogout];
            [[DPThirdCallCenter sharedInstance] dp_QQLogin];
        }
            break;
        case 2:{
            [[DPThirdCallCenter sharedInstance] dp_sinaWeiboLogout];
            [[DPThirdCallCenter sharedInstance] dp_sinaWeiboLogin];
        }
            break;
        case 3:{
            [[DPThirdCallCenter sharedInstance] dp_wxLogin];
        }
            break;
        default:
            break;
    }
}

- (void)pvt_onForgetPassword {
    DPForegetPassWordVC *forgetVC = [[DPForegetPassWordVC alloc]init];
    forgetVC.forgetType = kForgetTypeLoginPSW;
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (UITextField *)userNameField {
    if (_userNameField == nil) {
        _userNameField = [[UITextField alloc] init];
        _userNameField.placeholder = @"大彩账号/手机号码";
        _userNameField.backgroundColor = [UIColor clearColor];
        _userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _userNameField.font = [UIFont dp_systemFontOfSize:16];
        _userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameField.returnKeyType = UIReturnKeyNext;
        _userNameField.delegate = self;
//        _userNameField.limitMax =  12 ;
    }
    return _userNameField;
}


- (UITextField *)passwordField {
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.placeholder = @"密码";
        _passwordField.backgroundColor = [UIColor clearColor];
        _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordField.font = [UIFont dp_systemFontOfSize:16];
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.secureTextEntry = YES;
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.delegate = self;
    }
    return _passwordField;
}

- (void)pvt_editingDidEnd:(UITextField *)textField {
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self pvt_onSure];
    }
}
- (void)pvt_contentviewTap
{
    if (self.userNameField.isEditing) {
        [self.userNameField resignFirstResponder];
    }else if (self.passwordField.isEditing){
        [self.passwordField resignFirstResponder];
    }
}
#pragma mark - textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[DPToast sharedToast]dismiss];
    return YES;
}
-(int )caculateTheLength:(NSString*)str{
    
    __block int length = 0 ;
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        DPLog(@"substring == %@ \n",substring) ;
        if ([DPVerifyUtilities isHanZi:substring]) {
            length+=1 ;
        }
    }] ;
    
    return length ;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO ;
    }
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {
        return YES ;
    }

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.userNameField) {
        int length =textField.text.length+ [self caculateTheLength:textField.text] ;
        
        if (length>=24) {
//            [[DPToast makeText:@"用户名长度不能超过12个字符"]show];
            return NO ;
        }
    }else if(textField == self.passwordField){
        if (newString.length > 15) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    if (cmdId == NOTIFY_LOGIN_ACCOUNT || cmdType == ACCOUNT_OAUTH_LOGIN) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window dismissHUD];
//            [self dismissDarkHUD];
            if (ret < 0) {
                DPLog(@"ret: %d", ret);
                NSString *errorString=@"";
                if (ret <= -800) {
                    errorString = [DPErrorParser AccountErrorMsg:ret];
                }else{
                    errorString = [DPErrorParser CommonErrorMsg:ret];
                }
                [[DPToast makeText:errorString] show];
                return ;
            }
            
            if (cmdType == ACCOUNT_OAUTH_LOGIN && ret == 1) {
                // 未绑定大彩账号
                DPCompleteDataVC *cpVC = [[DPCompleteDataVC alloc]init];
                cpVC.accessToken = self.accessToken;
                cpVC.userID = self.userID;
                cpVC.authoType = self.thirdType;
//                [self.navigationController dp_applyGlobalTheme];
                [self.navigationController pushViewController:cpVC animated:YES];
                return;
            }
            
            CFrameWork *frameWork = CFrameWork::GetInstance();
            string content;
            if (frameWork->GetSessionContent(content) >= 0) {
                [SSKeychain setPassword:[NSString stringWithUTF8String:content.c_str()] forService:(NSString *)dp_KeychainServiceName account:(NSString *)dp_KeychainSessionAccount];
            }
            
            DPPersonalCenterViewController *personal = [[(id)kAppDelegate.rootController.leftMenuViewController viewControllers] firstObject];
            if ([personal isKindOfClass:[DPPersonalCenterViewController class]]) {
                [personal recordTabReset];
            }
            
            __weak __typeof(self) weakSelf = self;
            [self.navigationController dp_popViewControllerAnimated:YES completion:^{
                if (CFrameWork::GetInstance()->IsUserLogin() && weakSelf.finishBlock) {
                    weakSelf.finishBlock();
                }
            }];
        });
    }
}
- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    if (event == DPKeyboardListenerEventWillShow) {
        if (![[DPKeyboardCenter defaultCenter] isKeyboardAppear])  _lastOffset = _scrollView.contentOffset.y ;

//        UIButton *homeButton = [_scrollView dp_strongObjectForKey:@"dp_login_homeButton"];
//          CGPoint targetPoint = [_scrollView convertPoint:homeButton.frame.origin fromView:self.view];
        UIView *headerView = [_scrollView dp_weakObjectForKey:@"dp_login_headerView"];
        CGFloat targetY = CGRectGetMaxY(headerView.frame);
//        if (_lastOffset > targetPoint.y) {
//            _scrollView.scrollEnabled = NO;
//            return;
//        }
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frameEnd) + 10, 0);
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            [_scrollView setContentOffset:CGPointMake(0, targetY -60)];
        } completion:^(BOOL finished) {
            _scrollView.scrollEnabled = NO;
        }];
    }else if (event == DPKeyboardListenerEventWillHide){
        _scrollView.scrollEnabled = YES;
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            _scrollView.contentInset = UIEdgeInsetsZero;
            _scrollView.contentOffset = CGPointMake(0, 0) ;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)dealloc
{
    [[DPKeyboardCenter defaultCenter] removeListener:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface DPRegisterSuccessVC : UIViewController

@end
@implementation DPRegisterSuccessVC
- (void)viewDidLoad
{
    [super viewDidLoad] ;
    self.title = @"注册完成";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(leftNavItemClick)];
    
    UIView *contentView = self.view;
    contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    
    UIView *upView = [[UIView alloc]init];
    upView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIImageView *gouView = [[UIImageView alloc]initWithImage:dp_AccountImage(@"account_success.png")];
    gouView.backgroundColor = [UIColor clearColor];
    
    UILabel *wordLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"恭喜您, 注册成功";
        label.font = [UIFont dp_systemFontOfSize:19];
        label.textColor = [UIColor colorWithRed:24.0f/255 green:125.0f/255 blue:19.0f/255 alpha:1.0f];
        label;
    });
    
    UIButton *goBuyBtn = ({
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"立即购彩" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor dp_flatRedColor]];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(gotoBuyNow) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    UIButton *finishBtn = ({
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"完善资料" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor dp_colorFromHexString:@"#645e4b"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor dp_flatWhiteColor]];
        btn.layer.borderColor = [[UIColor dp_colorFromHexString:@"ccc4c1"]CGColor];
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(gotoFinish) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    [contentView addSubview:upView];
    [upView addSubview:gouView];
    [upView addSubview:wordLabel];
    [contentView addSubview:goBuyBtn];
    [contentView addSubview:finishBtn];
    
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.height.equalTo(@150);
    }];
    
    [gouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(upView).offset(- 10);
        make.bottom.equalTo(upView.mas_centerY);
    }];
    
    [wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(upView);
        make.top.equalTo(gouView.mas_bottom).offset(20);
    }];
    
    [goBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(upView);
        make.height.equalTo(@35);
        make.top.equalTo(upView.mas_bottom).offset(10);
        make.left.equalTo(upView);
    }];
    
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(upView);
        make.height.equalTo(@35);
        make.top.equalTo(goBuyBtn.mas_bottom).offset(10);
        make.left.equalTo(goBuyBtn);
    }];
    
}
- (void)gotoFinish
{
    DPSecurityCenterViewController *securityVC=[[DPSecurityCenterViewController alloc] init];
    [self.navigationController pushViewController:securityVC animated:YES];
}
- (void)gotoBuyNow
{
    [DPAppParser backToCenterRootViewController:YES];
}
- (void)leftNavItemClick
{
    [DPAppParser backToLeftRootViewController:YES];
}
@end


@interface DPRegisterViewController () <UITextFieldDelegate, ModuleNotify> {
@private
    UITextField *_userNameField;
    UITextField *_passwordField;
    UITextField *_surePasswordField;
    CAccount *_accountInstance;
    BOOL        _agree;
    UIImageView *_agreeImageView;
    BOOL _viewNotShow;//离开界面时不提示提示语
}
@property (nonatomic, strong, readonly) UITextField *userNameField;
@property (nonatomic, strong, readonly) UITextField *passwordField;
@property (nonatomic, strong, readonly) UITextField *surePasswordField;
@end

@implementation DPRegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _accountInstance = CFrameWork::GetInstance()->GetAccount();
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1]];
    self.title = @"注册";
    _agree = YES;
    [self createRegisterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _accountInstance->SetDelegate(self);
    _viewNotShow=NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)]];

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 40)];
//        [button setTitle:@" 登录" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(pvt_onNavRight:) forControlEvents:UIControlEventTouchUpInside];
//        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:15]];
//        button;
//                                                                                         })];
}
- (void)createRegisterView {
    UIView *contentView = self.view;

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    UIView *lineView1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1];
        view;
    });
    UIView *lineView2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1];
        view;
    });
    UIImageView *usrImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"login_usr.png")];
        imageView;
    });
    UIImageView *pwdImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"login_pwd.png")];
        imageView;
    });
    UIImageView *sureImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"login_pwd.png")];
        imageView;
    });
    [self.view addSubview:fieldView];
    [fieldView addSubview:self.userNameField];
    [fieldView addSubview:self.passwordField];
    [fieldView addSubview:self.surePasswordField];
    [fieldView addSubview:usrImage];
    [fieldView addSubview:pwdImage];
    [fieldView addSubview:sureImage];
    [fieldView addSubview:lineView1];
    [fieldView addSubview:lineView2];

    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(contentView).offset(20);
        make.height.equalTo(@120);
    }];
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-40);
        make.top.equalTo(fieldView);
        make.height.equalTo(@40);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-40);
        make.top.equalTo(self.userNameField.mas_bottom);
        make.height.equalTo(@40);
    }];
    [self.surePasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-40);
        make.top.equalTo(self.passwordField.mas_bottom);
        make.height.equalTo(@40);
    }];
    [usrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fieldView).offset(-10);
        make.centerY.equalTo(self.userNameField);
    }];
    [pwdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fieldView).offset(-10);
        make.centerY.equalTo(self.passwordField);
    }];
    [sureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fieldView).offset(-10);
        make.centerY.equalTo(self.surePasswordField);
    }];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView);
        make.right.equalTo(fieldView);
        make.top.equalTo(fieldView).offset(40);
        make.height.equalTo(@0.5);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView);
        make.right.equalTo(fieldView);
        make.top.equalTo(fieldView).offset(80);
        make.height.equalTo(@0.5);
    }];

    //
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = dp_CommonImage(@"check@2x.png");
    [contentView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeButtonClick)];
    [imageView addGestureRecognizer:tap1];
    _agreeImageView = imageView;

    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x8e8e8e);
    label.text = @"我已阅读并同意";
    label.font = [UIFont systemFontOfSize:11.0];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    [contentView addSubview:label];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeButtonClick)];
    [label addGestureRecognizer:tap2];

    UIButton *proButton = [[UIButton alloc] init];
    proButton.backgroundColor = [UIColor clearColor];
    [proButton setTitle:@"《大彩网服务协议》" forState:UIControlStateNormal];
    [proButton.titleLabel setFont:[UIFont dp_systemFontOfSize:11.0]];
    [proButton setTitleColor:UIColorFromRGB(0x336699) forState:UIControlStateNormal];
    [contentView addSubview:proButton];
    [proButton addTarget:self action:@selector(proButtonClick) forControlEvents:UIControlEventTouchDown];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fieldView.mas_bottom).offset(10);
        make.left.equalTo(fieldView).offset(50);
        make.height.equalTo(@14.5);
        make.width.equalTo(@14.5);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right);
        make.height.equalTo(@14.5);
        make.width.equalTo(@80);
    }];
    [proButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView);
        make.left.equalTo(label.mas_right);
        make.height.equalTo(@14.5);
        make.width.equalTo(@100);
    }];

    //登录
    UIButton *registerButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onForgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"注  册" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button;
    });
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(proButton.mas_bottom).offset(10);
        make.left.equalTo(fieldView);
        make.right.equalTo(fieldView);
        make.height.equalTo(@36);
    }];
}
-(void)resignAllTextFieldFirstResponder{

}
- (void)proButtonClick
{
    _viewNotShow=YES;
    [self resignAllTextFieldFirstResponder];
    DPWebViewController *web = [[DPWebViewController alloc]init];
    web.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kRegisterAgreementURL]];
    web.title = @"服务协议";
    web.canHighlight = NO ;
    [self.navigationController pushViewController:web animated:YES];
}
- (void)agreeButtonClick
{
    _viewNotShow=YES;
    [self resignAllTextFieldFirstResponder];
    NSString *imageName = _agree ? @"uncheck.png" : @"check.png";
    _agreeImageView.image = dp_CommonImage(imageName);
    _agree = !_agree;
}
- (void)pvt_onBack {
    _viewNotShow=YES;
    [self resignAllTextFieldFirstResponder];
    [[DPToast sharedToast]dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)pvt_onNavRight:(UIButton *)button {
//       
//    _viewNotShow=YES;
//    [self resignAllTextFieldFirstResponder];
//    
//    NSMutableArray * arrayM = self.navigationController.viewControllers.mutableCopy;
//    [arrayM removeLastObject];
////    [self.navigationController pushViewController:[[DPLoginViewController alloc] init] animated:YES];
//    [self.navigationController setViewControllers:arrayM animated:YES];
//
//}
- (void)pvt_onForgetPassword {

    if (self.userNameField.text.length<=0) {
        [[DPToast makeText:@"用户名不能为空"]show];
        return;
    }
    if (![DPVerifyUtilities isUserName:self.userNameField.text]) {
        [[DPToast makeText:@"用户名只能由汉字、数字、字母组成"]show];
        return;
    }
    if ([DPVerifyUtilities isNumber:self.userNameField.text]) {
        [[DPToast makeText:@"用户名不能为纯数字"]show];
        return;
    }
    
    int length = 0;
    for (int i = 0; i < self.userNameField.text.length; i++) {
        NSString* c = [self.userNameField.text substringWithRange:NSMakeRange(i, 1)];
        if ([DPVerifyUtilities isHanZi:c]) {
            length += 2;
        }else{
            length += 1;
        }
    }
    if (length > 12) {
        [[DPToast makeText:@"用户名长度不得超过12个字符, 1个汉字为2个字符"]show];
        return;
    }else if (length < 3){
        [[DPToast makeText:@"用户名至少为2个汉字或3个字符"]show];
        return;
    }
    if (self.passwordField.text.length<=0) {
        [[DPToast makeText:@"密码不能为空"]show];
        return;
    }
    
    if (self.passwordField.text.length <6 || self.passwordField.text.length > 15) {
        [[DPToast makeText:@"密码长度最小6位, 最大15位"]show];
        return;
    }
    if (self.surePasswordField.text.length<=0) {
        [[DPToast makeText:@"确认密码不能为空"]show];
        return;
    }
    
    if (![self.passwordField.text isEqualToString:self.surePasswordField.text]) {
        [[DPToast makeText:@"两次输入密码不一致"]show];
        return;
    }   
    if(!_agree){
        [[DPToast makeText:@"请勾选大彩网服务协议"]show];
        return;
    }
    [self showDarkHUD];
    _accountInstance->Reg([self.userNameField.text UTF8String], [self.passwordField.text UTF8String]);
}
- (UITextField *)userNameField {
    if (_userNameField == nil) {
        _userNameField = [[UITextField alloc] init];
        _userNameField.placeholder = @"用户名最少两个汉字或三个字母";

        _userNameField.backgroundColor = [UIColor clearColor];
        _userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _userNameField.font = [UIFont dp_systemFontOfSize:14];
        _userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameField.delegate = self;
    }
    return _userNameField;
}

- (UITextField *)passwordField {
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.placeholder = @"密码，至少6个字符";
        _passwordField.backgroundColor = [UIColor clearColor];
        _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordField.font = [UIFont dp_systemFontOfSize:14];
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.secureTextEntry = YES;
        _passwordField.delegate = self;
    }
    return _passwordField;
}

- (UITextField *)surePasswordField {
    if (_surePasswordField == nil) {
        _surePasswordField = [[UITextField alloc] init];
        _surePasswordField.placeholder = @"确认密码";
        _surePasswordField.backgroundColor = [UIColor clearColor];
        _surePasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _surePasswordField.font = [UIFont dp_systemFontOfSize:14];
        _surePasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _surePasswordField.secureTextEntry = YES;
        _surePasswordField.delegate=self;
    }
    return _surePasswordField;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.surePasswordField resignFirstResponder];
}
#pragma mark - textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_viewNotShow) {
        return;
    }
    if (textField == self.userNameField) {

        if (![DPVerifyUtilities isUserName:textField.text]) {
            [[DPToast makeText:@"用户名只能由汉字、数字、字母组成"]show];
        }
        if ([DPVerifyUtilities isNumber:textField.text]) {
            [[DPToast makeText:@"用户名不能为纯数字"]show];
        }
        
        int length = 0;
        for (int i = 0; i < textField.text.length; i++) {
            NSString* c = [textField.text substringWithRange:NSMakeRange(i, 1)];
            if ([DPVerifyUtilities isHanZi:c]) {
                length += 2;
            }else{
                length += 1;
            }
        }
        if (length > 12) {
            [[DPToast makeText:@"用户名长度不得超过12个字符, 1个汉字为2个字符"]show];
        }else if (length < 3){
            [[DPToast makeText:@"用户名至少为2个汉字或3个字符"]show];
        }
        
    }else if (textField == self.passwordField){
        if (textField.text.length <6 || textField.text.length > 15) {
            [[DPToast makeText:@"密码长度最小6位, 最大15位"]show];
        }
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.userNameField) {
        if (newString.length > 126666664) {
            [[DPToast makeText:@"用户名长度不得超过12个字符, 1个汉字为2个字符"]show];
            return NO;
        }
    }else if (textField == self.passwordField){
        if (newString.length > 15) {
            [[DPToast makeText:@"密码长度不得超过15位"]show];
            return NO;
        }
    }else if (textField == self.surePasswordField){
        if (newString.length > 15) {
            [[DPToast makeText:@"密码长度不得超过15位"]show];
            return NO;
        }
    }

    
    return YES;
}
#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        if (cmdId == NOTIFY_REG_ACCOUNT) {
            [self dismissDarkHUD];
            if (ret<0) {
                NSString *errorString;
                if (ret <= -800) {
                    errorString = [DPErrorParser AccountErrorMsg:ret];
                } else {
                    errorString = [DPErrorParser CommonErrorMsg:ret];
                }
                [[DPToast makeText:errorString] show];
                return;
            }
            
            CFrameWork *frameWork = CFrameWork::GetInstance();
            string content;
            if (frameWork->GetSessionContent(content) >= 0) {
                [SSKeychain setPassword:[NSString stringWithUTF8String:content.c_str()] forService:(NSString *)dp_KeychainServiceName account:(NSString *)dp_KeychainSessionAccount];
            }
            
            [self.navigationController pushViewController:[[DPRegisterSuccessVC alloc]init] animated:YES];
            
        }
    });
}
@end

@interface DPCompleteDataSuccessVC : DPSuccessDoneVC

@end

@implementation DPCompleteDataSuccessVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"完善资料";
    self.promptLabel.text = @"恭喜您已绑定成功";
    [self.commitBtn setTitle:@"立即购彩" forState:UIControlStateNormal];
}
- (void)dp_commitBtnClick
{
    [super dp_commitBtnClick];
    
    [DPAppParser backToCenterRootViewController:YES];
}
- (void)leftNavItemClick
{
    [super leftNavItemClick];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end



#define kCompleteCommonConerRadius 3
@interface DPCompleteDataVC () <DPKeyboardCenterDelegate,UITextFieldDelegate, ModuleNotify>
{
    CGPoint _contentOffset;
    CAccount *_account;
}
@property (nonatomic, assign) int tableIndex;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) UILabel *coverLabel;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UILabel *label0;
@property (nonatomic, strong, readonly) UILabel *label1;
@property (nonatomic, strong, readonly) UILabel *label2;
@property (nonatomic, strong, readonly) UITextField *textField0;
@property (nonatomic, strong, readonly) UITextField *textField1;
@property (nonatomic, strong, readonly) UITextField *textField2;
@property (nonatomic, strong, readonly) NSLayoutConstraint *changeCellCsrt;
@property (nonatomic, strong, readonly) UIButton *commitBtn;
@property (nonatomic, weak) UITextField *targetField; // 键盘弹出参考位置的textField
@end
@implementation DPCompleteDataVC
- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"完善资料";
        self.tableIndex = 0;
        _account = CFrameWork :: GetInstance() -> GetAccount();
        self.authoType = -1;
    }
    return self;
}
- (void)viewDidLoad
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navBarLeftItemClick)];
//    self.view.backgroundColor = [UIColor dp_colorFromHexString:@"#E9E7E1"];
    self.view.backgroundColor = [UIColor clearColor];
    
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]init];
//        scrollView.scrollEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
        scrollView;
    });
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_singleTap)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor dp_colorFromHexString:@"#F6F2E8"];
    headerView.layer.cornerRadius = kCompleteCommonConerRadius;
    
    UIButton *newUser = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"新用户" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTag:50];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        [button addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#827960"] forState:UIControlStateNormal];
        button;
    });
    
    UIButton *oldUser = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"绑定已有用户" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTag:51];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        [button addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#827960"] forState:UIControlStateNormal];
        button;
    });
    
    _coverLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_colorFromHexString:@"#46402e"];
        label.font = [UIFont dp_systemFontOfSize:15];
        label.text = @"新用户";
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = kCompleteCommonConerRadius;
        label.layer.borderColor = [UIColor dp_colorFromHexString:@"#e1dcc8"].CGColor;
        label.layer.borderWidth = 0.5f;
        label.layer.backgroundColor = [UIColor dp_flatWhiteColor].CGColor;
        label;
    });
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:contentView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.right.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    [contentView addSubview:headerView];
    [headerView addSubview:newUser];
    [headerView addSubview:oldUser];
    [headerView addSubview:self.coverLabel];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.width.equalTo(@296);
        make.height.equalTo(@38);
        make.centerX.equalTo(contentView);
    }];
    
    [newUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.left.equalTo(headerView);
        make.width.equalTo(@136.5);
        make.height.equalTo(headerView);
    }];
    [oldUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.left.equalTo(newUser.mas_right);
        //        make.width.equalTo(@136.);
        make.right.equalTo(headerView);
        make.height.equalTo(headerView);
    }];
    
    [self.coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(newUser);
        make.width.equalTo(newUser).offset(5);
        make.height.equalTo(newUser).offset(10);
    }];

    UIView *cell0 = [[UIView alloc]init];
    UIView *cell1 = [[UIView alloc]init];
    UIView *cell2 = [[UIView alloc]init];
    UIView *cell3 = [[UIView alloc]init];

    cell2.clipsToBounds = YES;
    cell0.backgroundColor = [UIColor dp_flatWhiteColor];
    cell1.backgroundColor = [UIColor dp_flatWhiteColor];
    cell2.backgroundColor = [UIColor dp_flatWhiteColor];
    cell3.backgroundColor = [UIColor dp_flatWhiteColor];
    
    [contentView addSubview:cell0];
    [contentView addSubview:cell1];
    [contentView addSubview:cell2];
    [contentView addSubview:cell3];
    
    [cell0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(- 10);
//        make.width.equalTo(@300);
        make.top.equalTo(headerView.mas_bottom);
        make.height.equalTo(@66);
    }];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.width.equalTo(@300);
//        make.left.equalTo(cell0);
//        make.right.equalTo(cell0);
        make.top.equalTo(cell0.mas_bottom);
        make.height.equalTo(@66);
    }];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(cell0);
//        make.right.equalTo(cell0);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@300);
        make.top.equalTo(cell1.mas_bottom);
        make.height.equalTo(@66);
    }];
    [cell3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(cell0);
//        make.right.equalTo(cell0);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@300);
        make.top.equalTo(cell2.mas_bottom);
        make.height.equalTo(@70);
    }];
    
    for (NSLayoutConstraint *constraint in cell2.constraints) {
        if (constraint.firstItem == cell2 && constraint.firstAttribute == NSLayoutAttributeHeight) {
            _changeCellCsrt = constraint;
            break;
        }
    }
    
    _label0 = [self dp_commonLabelWithTitle:@"购彩昵称"];
    _label1 = [self dp_commonLabelWithTitle:@"登录密码"];
    _label2 = [self dp_commonLabelWithTitle:@"重复密码"];
    _textField0 = [self dp_commonTextFieldWithHolder:@"填写昵称登录大彩网" returnType:UIReturnKeyNext secEnty:NO];
    _textField1 = [self dp_commonTextFieldWithHolder: @"填写登录密码" returnType:UIReturnKeyNext secEnty:YES];
    _textField2 = [self dp_commonTextFieldWithHolder: @"再次填写登录密码" returnType:UIReturnKeyDone secEnty:YES];

    [self dp_setCommonCell:cell0 withLabel:self.label0 textField:self.textField0];
    [self dp_setCommonCell:cell1 withLabel:self.label1 textField:self.textField1];
    [self dp_setCommonCell:cell2 withLabel:self.label2 textField:self.textField2];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor dp_flatWhiteColor ] forState:UIControlStateNormal];
    [_commitBtn setBackgroundColor:[UIColor dp_colorFromHexString:@"#efe9dc"]];
    [_commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_commitBtn.layer setCornerRadius:kCompleteCommonConerRadius];
    _commitBtn.userInteractionEnabled = NO;
    
    [cell3 addSubview:_commitBtn];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell3);
        make.centerY.equalTo(cell3);
        make.width.equalTo(@272);
        make.height.equalTo(@41);
    }];
}
- (void)dp_setCommonCell:(UIView *)cell withLabel:(UILabel *)label textField:(UITextField *)textField
{
    [cell addSubview:label];
    [cell addSubview:textField];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).offset(10);
        make.left.equalTo(cell).offset(14);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell);
//        make.top.equalTo(label.mas_bottom).offset(6);
        make.height.equalTo(@36);
        make.width.equalTo(@272);
        make.bottom.equalTo(cell);
    }];
}
- (UILabel *)dp_commonLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_systemFontOfSize:15];
    label.textColor = [UIColor dp_colorFromHexString:@"#46402e"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (UITextField *)dp_commonTextFieldWithHolder:(NSString *)holder returnType:(UIReturnKeyType)type secEnty:(BOOL)secEnty
{
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    [leftView setBounds:CGRectMake(0, 0, 10, 1)];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor clearColor];
    textField.layer.borderColor = [UIColor dp_colorFromHexString:@"#c8c3b0"].CGColor;
    textField.layer.borderWidth = 0.5f;
    textField.layer.cornerRadius = kCompleteCommonConerRadius;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    textField.delegate = self;
    textField.placeholder = holder;
    textField.returnKeyType = type;
    textField.secureTextEntry = secEnty;
    [textField addTarget:self action:@selector(pvt_textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    return textField;
}
- (void)dp_singleTap
{
    if ([self.textField0 isEditing]) [self.textField0 resignFirstResponder];
    if ([self.textField1 isEditing]) [self.textField1 resignFirstResponder];
    if ([self.textField2 isEditing]) [self.textField2 resignFirstResponder];
}
- (void)pvt_textFieldDone:(UITextField *)sender
{
    if (sender == self.textField0) {
        [self.textField1 becomeFirstResponder];
    }else if (sender == self.textField1 && self.tableIndex == 0){
        [self.textField2 becomeFirstResponder];
    }else if (sender == self.textField1 && self.tableIndex == 1){
        [self commitBtnClick];
    }else if (sender == self.textField2){
        [self dp_singleTap];
    }
}
- (void)commitBtnClick
{
//    [DPToast dismiss];
    DPAssertMsg(self.accessToken.length > 0, @"第三方登录token为空");
    DPAssertMsg(self.authoType >= 0, @"第三方登录type没有赋值");
    if (self.tableIndex == 0) {
        if (![self.textField1.text isEqualToString:self.textField2.text]) {
            [[DPToast makeText:@"前后密码输入不一致，请核对后再次输入"]show];
            return;
        }
        NSString *userID = self.userID;

        _account -> Net_OAuthRegAct(self.accessToken.UTF8String, userID.UTF8String, self.authoType, self.textField0.text.UTF8String, self.textField1.text.UTF8String);
    }else{
        _account -> Net_OAuthBindAct(self.accessToken.UTF8String, self.userID.UTF8String, self.authoType, self.textField0.text.UTF8String, self.textField1.text.UTF8String);
    }
    [self showDarkHUD];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (kScreenHeight > 480 && self.tableIndex == 0) {
        self.targetField = self.textField0;
    }else if (kScreenHeight > 480 && self.tableIndex == 1){
        self.targetField = nil;
    }else if (textField == self.textField2){
        self.targetField = self.textField1;
    }else if (textField == self.textField1 && self.tableIndex == 1){
        self.targetField = self.textField0;
    }else{
        self.targetField = textField;
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO ;
    }

    if ([string isEqualToString:@"\n"]) {
        return YES ;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.textField0) {
        int length =textField.text.length+ [self caculateTheLength:textField.text] ;
        
        if (length>=12) {
            [[DPToast makeText:@"用户名长度不能超过12个字符"]show];
            return NO ;
        }
    }else if(textField == self.textField1 || textField == self.textField2){
        if (newString.length > 15) {
            return NO;
        }
    }
    textField.text = newString;
    DPLog(@"------ field 输入 newString =%@", newString);
    UIColor *comitColor = [UIColor dp_flatRedColor];
    BOOL enable = YES;
    if (self.textField0.text.length > 0 && self.textField1.text.length > 0) {
        if (self.tableIndex == 0 && self.textField2.text.length <= 0) {
            comitColor = [UIColor dp_colorFromHexString:@"#efe9dc"];
            enable = NO;
            
        }
    }else{
        comitColor = [UIColor dp_colorFromHexString:@"#efe9dc"];
        enable = NO;
    }
    self.commitBtn.userInteractionEnabled = enable;
    [self.commitBtn setBackgroundColor:comitColor];
    
    return NO;
}
- (int)caculateTheLength:(NSString*)str{
    
    __block int length = 0 ;
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        DPLog(@"substring == %@ \n",substring) ;
        if ([DPVerifyUtilities isHanZi:substring]) {
            length+=1 ;
        }
    }] ;
    
    return length ;
}
- (void)optionBtnClick:(UIButton *)sender
{
    if (self.tableIndex == sender.tag - 50) {
        return;
    }
    [self dp_singleTap];
    self.tableIndex = sender.tag - 50;
    
    [self.coverLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sender);
        make.width.equalTo(sender).offset(5);
        make.height.equalTo(sender).offset(10);
    }];
    CGFloat constant = 66;
    NSString *cover = @"新用户";
    NSString *text0 = @"购彩昵称";
    NSString *text1 = @"登录密码";
    UIReturnKeyType type = UIReturnKeyNext;
    
    if (self.tableIndex == 1) {
        cover = @"绑定已有用户";
        text0 = @"用户名";
        text1 = @"密码";
        constant = 0;
        type = UIReturnKeyDone;
    }
    self.coverLabel.text = cover;
    self.label0.text = text0;
    self.label1.text = text1;
    self.changeCellCsrt.constant = constant;
    self.textField1.returnKeyType = type;
    
    self.textField0.text = @"";
    self.textField1.text = @"";
    self.textField2.text = @"";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DPKeyboardCenter defaultCenter] addListener:self type:DPKeyboardListenerEventWillShow | DPKeyboardListenerEventWillHide];
    _account -> SetDelegate(self);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DPKeyboardCenter defaultCenter] removeListener:self];
}

- (void)navBarLeftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - keyboard delegate
- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    if (self.targetField == nil) {
        return;
    }
    CGPoint targetPoint = CGPointZero;
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (event == DPKeyboardListenerEventWillShow) {
        inset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frameEnd) - 50, 0);
        self.scrollView.contentInset = inset;
        CGPoint point = [self.targetField convertPoint:CGPointZero toView:self.scrollView];
        targetPoint = CGPointMake(0, point.y - 20);
        
    }else if (event == DPKeyboardListenerEventWillHide){

    }
    [UIView animateKeyframesWithDuration:duration delay:0 options:curve animations:^{
        [self.scrollView setContentOffset:targetPoint];
    } completion:^(BOOL finished) {
        self.scrollView.contentInset = inset;
    }];
}
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype
{
    if (cmdtype == ACCOUNT_OAUTH_REG || cmdtype == ACCOUNT_OAUTH_BIND) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.view.window dismissHUD];
            [self dismissDarkHUD];
            if (ret < 0) {
                DPLog(@"ret: %d", ret);
                NSString *errorString=@"";
                if (ret <= -800) {
                    errorString = [DPErrorParser AccountErrorMsg:ret];
                }else{
                    errorString = [DPErrorParser CommonErrorMsg:ret];
                }
                [[DPToast makeText:errorString] show];
                return ;
            }
            
            NSMutableArray *arrayM = self.navigationController.mutableCopy;
            DPAssertMsg(arrayM.count >= 3, @"完善资料页面跳转问题");
            [arrayM removeLastObject];
            [arrayM removeLastObject];
            [arrayM addObject:[[DPCompleteDataSuccessVC alloc]init]];
            [self.navigationController setViewControllers:arrayM animated:YES];
        });
    }

}
@end


@interface DPModifySuccessVC : DPSuccessDoneVC
@property (nonatomic, assign) BOOL modifyPsw; // 是否修改了密码
@end

@implementation DPModifySuccessVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改用户名";
    self.promptLabel.text = self.modifyPsw ? @"用户名和密码修改成功" : @"用户名修改成功";
    [self.commitBtn setTitle:@"立即购彩" forState:UIControlStateNormal];
}
- (void)dp_commitBtnClick
{
    [super dp_commitBtnClick];
    
    [DPAppParser backToCenterRootViewController:YES];
}
- (void)leftNavItemClick
{
    [super leftNavItemClick];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

@interface DPModifyNameVC () <UITextFieldDelegate, DPKeyboardCenterDelegate, ModuleNotify>
{
    CAccount *_account;
}
@property (nonatomic, strong, readonly) UITextField     *textField0;
@property (nonatomic, strong, readonly) UITextField     *textField1;
@property (nonatomic, strong, readonly) UITextField     *textField2;
@property (nonatomic, strong, readonly) UIButton        *commitBtn;
@property (nonatomic, strong, readonly) UIScrollView    *scrollView;
@end

@implementation DPModifyNameVC

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"修改用户名";
        self.canModifyPassword = YES;
        _account = CFrameWork :: GetInstance() -> GetAccount();
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navBackItemClick)];
    self.view.backgroundColor = [UIColor clearColor];
    [self dp_buildCommonUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewSingleTap)];
    [self.view addGestureRecognizer:tap];
}
- (void)viewSingleTap
{
    if ([self.textField0 isEditing]) [self.textField0 resignFirstResponder];
    if ([self.textField1 isEditing]) [self.textField1 resignFirstResponder];
    if ([self.textField2 isEditing]) [self.textField2 resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    _account -> SetDelegate(self);
    [[DPKeyboardCenter defaultCenter] addListener:self type:DPKeyboardListenerEventWillShow | DPKeyboardListenerEventWillHide];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DPKeyboardCenter defaultCenter] removeListener:self];
}
- (void)dp_buildCommonUI
{
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView;
    });
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:contentView];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    
    UIView *cell0 = [[UIView alloc]init];
    UIView *cell1 = [[UIView alloc]init];
    UIView *cell2 = [[UIView alloc]init];
    
    cell0.backgroundColor = [UIColor clearColor];
    cell1.backgroundColor = [UIColor clearColor];
    cell2.backgroundColor = [UIColor clearColor];
    
    _commitBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确 认" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor dp_colorFromHexString:@"#fa201e"]];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(dp_commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
//    UIView *contentView = self.view;
    [contentView addSubview:cell0];
    [contentView addSubview:cell1];
    [contentView addSubview:cell2];
    [contentView addSubview:_commitBtn];
    
    [cell0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(- 10);
        make.top.equalTo(contentView).offset(15);
        make.height.equalTo(@40);
    }];
    
    UIView *compareView = cell2;
    if (self.canModifyPassword) {
        [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell0);
            make.right.equalTo(cell0);
            make.top.equalTo(cell0.mas_bottom).offset(10);
            make.height.equalTo(cell0);
        }];
        
        [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell0);
            make.right.equalTo(cell1);
            make.top.equalTo(cell1.mas_bottom).offset(10);
            make.height.equalTo(cell0);
        }];
    
    }else{
        compareView = cell0;
        [cell1 removeFromSuperview];
        [cell2 removeFromSuperview];
    }
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell0);
        make.right.equalTo(cell0);
        make.top.equalTo(compareView.mas_bottom).offset(15);
        make.height.equalTo(cell0);
    }];
    
    _textField0 = [self dp_buildCommonCell:cell0 title:@"新用户名" holder:@"用户名可用于大彩网登录" secret:NO];
    _textField1 = [self dp_buildCommonCell:cell1 title:@"登录密码" holder:@"设置您的登录密码" secret:YES];
    _textField2 = [self dp_buildCommonCell:cell2 title:@"确认密码" holder:@"确认您的登录密码" secret:YES];
    
    NSString *warnTitle = @"1.您的用户名只能修改一次\n2.修改后您此后购彩时会使用新的用户名，修改钱前的购彩记录、方案详情等内容稍后会替换成新的用户名。\n3.在法律允许的范围内大彩网保留此功能的解释权。";
    NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc]init];
    parStyle.lineSpacing = 5.0f;

    NSDictionary *atrDict = @{NSParagraphStyleAttributeName : parStyle};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:warnTitle attributes:atrDict];
    
    UILabel *warnLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_colorFromHexString:@"#8c8778"];
        label.font = [UIFont dp_systemFontOfSize:14];
        label.numberOfLines = 0;
        label.attributedText = attrStr;
        label;
    });
    
    [contentView addSubview:warnLabel];
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commitBtn.mas_bottom).offset(15);
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(- 10);
    }];
}
- (UITextField *)dp_buildCommonCell:(UIView *)cell title:(NSString *)title holder:(NSString *)holder secret:(BOOL)secret
{
    UILabel *label = [self dp_createCommonLabelWithTitle:title];
    UITextField *field = [self dp_createCommonTextfieldWithHolder:holder secret:secret];
    [cell addSubview:label];
    [cell addSubview:field];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell);
        make.centerY.equalTo(cell);
    }];
    
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(label.mas_right).offset(5);
        make.centerY.equalTo(cell);
        make.right.equalTo(cell);
        make.height.equalTo(cell);
        make.width.equalTo(@235);
    }];
    
    return field;
}
- (UILabel *)dp_createCommonLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor dp_colorFromHexString:@"#333333"];
    label.font = [UIFont dp_boldSystemFontOfSize:15];
    return label;
    
}
- (UITextField *)dp_createCommonTextfieldWithHolder:(NSString *)holder secret:(BOOL)secret
{
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor dp_flatWhiteColor];
    textField.placeholder = holder;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = [UIColor dp_colorFromHexString:@"#B1AEA5"].CGColor;
    textField.layer.borderWidth = 0.5;
    UIView *leftView = [[UIView alloc]init];
    leftView.bounds = CGRectMake(0, 0, 10, 5);
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.secureTextEntry = secret;
    [textField addTarget:self action:@selector(dp_textFieldDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    textField.delegate = self;
    
    return textField;
}
- (void)navBackItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dp_commitBtnClick
{
    if (self.canModifyPassword) {
        if (![self.textField1.text isEqualToString:self.textField2.text]) {
            [[DPToast makeText:@"前后密码输入不一致，请核对后再次输入"]show];
            return;
        }
        _account -> Net_ChangeNameAndPwd(self.textField0.text.UTF8String, self.textField1.text.UTF8String);
    }else{
        _account -> Net_ChangeName(self.textField0.text.UTF8String);
    }
    
}
- (void)dp_textFieldDidEndExit:(UITextField *)sender
{
    if (!self.canModifyPassword && sender == self.textField0) {
        [sender resignFirstResponder];
        return;
    }
    if (sender == self.textField0) {
        [self.textField1 becomeFirstResponder];
    }else if (sender == self.textField1){
        [self.textField2 becomeFirstResponder];
    }else{
        [sender resignFirstResponder];
    }

}
#pragma mark - textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO ;
    }
    
    if ([string isEqualToString:@"\n"]) {
        return YES ;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.textField0) {
        int length =textField.text.length+ [self caculateTheLength:textField.text] ;
        
        if (length>=12) {
            [[DPToast makeText:@"用户名长度不能超过12个字符"]show];
            return NO ;
        }
    }else if(textField == self.textField1 || textField == self.textField2){
        if (newString.length > 15) {
            return NO;
        }
    }
    textField.text = newString;
    DPLog(@"------ field 输入 newString =%@", newString);
    UIColor *comitColor = [UIColor dp_colorFromHexString:@"#fa201e"];
    BOOL enable = YES;
    if (self.canModifyPassword) {
        if (self.textField0.text.length <= 0 || self.textField1.text.length <= 0 || self.textField2.text.length <=0){
            comitColor = [UIColor dp_colorFromHexString:@"#efe9dc"];
            enable = NO;
        }
    }else if (self.textField0.text.length <= 0){
        comitColor = [UIColor dp_colorFromHexString:@"#efe9dc"];
        enable = NO;
    }
    
    self.commitBtn.userInteractionEnabled = enable;
    [self.commitBtn setBackgroundColor:comitColor];
    
    return NO;

}
-(int)caculateTheLength:(NSString*)str{
    
    __block int length = 0 ;
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        DPLog(@"substring == %@ \n",substring) ;
        if ([DPVerifyUtilities isHanZi:substring]) {
            length+=1 ;
        }
    }] ;
    
    return length ;
}
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype
{
    if (cmdtype == ACCOUNT_CHANGE_NAME || cmdtype == ACCOUNT_CHANGE_NAMEPWD) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.view.window dismissHUD];
            [self dismissDarkHUD];
            if (ret < 0) {
                DPLog(@"ret: %d", ret);
                NSString *errorString=@"";
                if (ret <= -800) {
                    errorString = [DPErrorParser AccountErrorMsg:ret];
                }else{
                    errorString = [DPErrorParser CommonErrorMsg:ret];
                }
                [[DPToast makeText:errorString] show];
                return ;
            }
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            [array removeLastObject];
            [array addObject:[[DPModifySuccessVC alloc]init]];
            [self.navigationController setViewControllers:array animated:YES];
            
        });
    }

}
#pragma mark - keyBoard delegate
- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    if (!self.canModifyPassword || kScreenHeight > 480) {
        return;
    }
    CGPoint targetPoint = CGPointZero;
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (event == DPKeyboardListenerEventWillShow) {
        inset = UIEdgeInsetsMake(0, 0, 40, 0);
        CGPoint point = [self.textField0 convertPoint:CGPointZero toView:self.scrollView];
        targetPoint = CGPointMake(0, point.y);
    }
    [UIView animateKeyframesWithDuration:duration delay:0 options:curve animations:^{
        self.scrollView.contentInset = inset;
        self.scrollView.contentOffset = targetPoint;
    } completion:nil];
}
@end


@implementation DPSuccessDoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dp_colorFromHexString:@"#E9E7E1"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(leftNavItemClick)];
    UIView *bockView = [[UIView alloc]init];
    bockView.backgroundColor = [UIColor dp_colorFromHexString:@"#ffffff"];
    
    UIImageView * successArrow = [[UIImageView alloc]initWithImage:dp_AccountImage(@"account_success.png")];
    UILabel * sayLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:20];
        label.textColor = [UIColor dp_colorFromHexString:@"#1d911a"];
        label;
    });
    _promptLabel = sayLabel;
    
    UIButton *loginBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor dp_colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor dp_colorFromHexString:@"#FA201E"]];
        btn.titleLabel.font = [UIFont dp_systemFontOfSize:17];
        btn.layer.cornerRadius = 3.0f;
        [btn addTarget:self action:@selector(dp_commitBtnClick) forControlEvents:UIControlEventTouchDown];
        btn;
    });
    _commitBtn = loginBtn;
    
    [self.view addSubview:bockView];
    [self.view addSubview:loginBtn];
    [bockView addSubview:successArrow];
    [bockView addSubview:sayLabel];
    
    [bockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(- 10);
        make.height.equalTo(@180);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(bockView.mas_bottom).offset(15);
        make.right.equalTo(self.view).offset(- 10);
        make.height.equalTo(@35);
    }];
    
    [successArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bockView);
        make.bottom.equalTo(bockView.mas_centerY);
    }];
    
    [sayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bockView);
        make.top.equalTo(bockView.mas_centerY).offset(5);
    }];
}
- (void)leftNavItemClick
{
    // 继承 重写
}
- (void)dp_commitBtnClick
{
    // 继承 重写
}
@end