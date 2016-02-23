        //
//  DPExchangeViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-10-20.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPExchangeViewController.h"
#import "FrameWork.h"
#import "DPAcountPacketController.h"
//#import "XTSideMenu.h"
#import "DPAppParser.h"
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"
@interface DPExchangeSuccessVC : UIViewController

@end

@implementation DPExchangeSuccessVC
- (void)viewDidLoad
{
    [super viewDidLoad] ;
    self.title = @"红包兑换";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navLeftItemClick)];
    
    self.view.backgroundColor = [UIColor dp_colorFromHexString:@"#FAF9F2"];
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:dp_RedPacketImage(@"changeSuccessTop.png")];
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIImageView *gouView = [[UIImageView alloc]initWithImage:dp_AccountImage(@"account_success.png")];
    UILabel *wordsLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"恭喜您, 兑换成功!";
        label.textColor = [UIColor colorWithRed:24.0f/255 green:125.0f/255 blue:19.0f/255 alpha:1.0f];
        label.font = [UIFont dp_systemFontOfSize:18];
        label;
    });
    
    UIButton *toBuyBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"马上购彩" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button addTarget:self action:@selector(pvt_togoBuyClick) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    UIButton *toCheckBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看红包" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button addTarget:self action:@selector(pvt_togoCheckClick) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    [self.view addSubview:topImgView];
    [self.view addSubview:contentView];
    [contentView addSubview:gouView];
    [contentView addSubview:wordsLabel];
    [contentView addSubview:toBuyBtn];
    [contentView addSubview:toCheckBtn];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(- 10);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(- 20);
        make.height.equalTo(@190);
    }];
    
    [wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView.mas_centerY);
    }];
    
    [gouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(wordsLabel.mas_top).offset(-15);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [toBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wordsLabel.mas_bottom).offset(18);
        make.right.equalTo(contentView.mas_centerX).offset(-5);
        make.left.equalTo(contentView).offset(20);
        make.height.equalTo(@40);
    }];
    
    [toCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toBuyBtn);
        make.right.equalTo(contentView).offset(- 20);
        make.left.equalTo(contentView.mas_centerX).offset(5);
        make.height.equalTo(@40);
    }];
    
    
}
- (void)pvt_togoBuyClick
{
    if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
        [DPAppParser backToCenterRootViewController:YES];
    }

}
- (void)pvt_togoCheckClick
{
    NSMutableArray *arrayM = self.navigationController.viewControllers.mutableCopy;
    [arrayM removeLastObject];
    [arrayM addObject:[[DPAcountPacketController alloc]init]];
    [self.navigationController setViewControllers:arrayM animated:YES];

}
- (void)navLeftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end



@interface DPExchangeViewController () <UITextFieldDelegate> {
@private
    CAccount *_accountInstance;
    UITextField *_exchangeField;
    UIImageView *_bgView;
    UIView      *_pointView;
    UILabel     *_wordsLabel;
    UIImageView *_middleLine;
}
@property(strong, nonatomic, readonly)UIImageView   *bgView;
@property(strong, nonatomic, readonly)UIView *pointView;
@property(strong, nonatomic, readonly)UILabel *wordsLabel;
@property(strong, nonatomic, readonly)UIImageView *middleLine;
@end

@implementation DPExchangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _accountInstance = CFrameWork::GetInstance()->GetAccount();
        _accountInstance->SetDelegate(self);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)]];
    [self.navigationItem setTitle:@"兑换码"];
    [self.view setBackgroundColor:[UIColor dp_colorFromHexString:@"#FAF9F2"]];
    
//    [self.view addSubview:self.exchangeField];
//    [self.exchangeField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.view).offset(100);
//        make.width.equalTo(@100);
//        make.height.equalTo(@40);
//    }];
//
    
    UIButton *submibButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:dp_RedPackertResizeImage(@"exchangeBtnBg.png") forState:UIControlStateNormal];
        [button setTitle:@"立即兑换" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#bd0720"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:20];
//        button.layer.borderColor = [[UIColor dp_colorFromHexString:@"#bd0720"]CGColor];
//        button.layer.borderWidth = 1.0f;
        [button addTarget:self action:@selector(pvt_onExchange) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    [self.view addSubview:self.bgView];
    UIView *contentView = self.bgView;
    [contentView addSubview:self.pointView];
    [contentView addSubview:self.wordsLabel];
    [contentView addSubview:self.middleLine];
    [contentView addSubview:self.exchangeField];
    [contentView addSubview:submibButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exchangeField);
//        make.centerY.equalTo(self.wordsLabel);
        make.centerY.equalTo(contentView.mas_top).offset(55);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    [self.wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_right).offset(5);
//        make.top.equalTo(contentView).offset(30);
        make.centerY.equalTo(self.pointView);
    }];
    
    [self.exchangeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.centerY.equalTo(contentView).offset(-15);
        make.width.equalTo([NSNumber numberWithFloat:self.bgView.intrinsicContentSize.width - 60]);
        make.height.equalTo(@40);
    }];
    
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exchangeField.mas_bottom).offset(10);
        make.centerX.equalTo(contentView);
        make.width.equalTo(self.exchangeField).offset(10);
    }];
    
    [submibButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleLine.mas_bottom).offset(10);
        make.left.equalTo(self.exchangeField);
        make.width.equalTo(self.exchangeField);
        make.height.equalTo(self.exchangeField);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pvt_onExchange {
    if (self.exchangeField.text.length == 0) {
        [[DPToast makeText:@"请输入兑换码"] show];
        return;
    }
    
    _accountInstance->ExchangeRedPackage(self.exchangeField.text.UTF8String);
    
    [self showHUD];
}
- (void)pvt_bgViewTap
{
    if (self.exchangeField.isEditing == YES) {
        [self.exchangeField endEditing:YES];
    }
}
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (cmdType == ACCOUNT_EXCHANGE_PACKAGE) {
            [self dismissHUD];
            if (ret >= 0) {
                [[DPToast makeText:@"兑换成功!"] show];
        
                NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
                [viewControllers removeLastObject];
                [viewControllers addObject:[[DPExchangeSuccessVC alloc]init]];
                [self.navigationController setViewControllers:viewControllers animated:YES];
//                [self.navigationController pushViewController:[[DPExchangeSuccessVC alloc]init] animated:YES];
            } else {
                [[DPToast makeText:DPAccountErrorMsg(ret)] show];
            }
        }
    });
}
#pragma mark - getter和setter
- (UITextField *)exchangeField {
    if (_exchangeField == nil) {
        _exchangeField = [[UITextField alloc] init];
        _exchangeField.delegate = self;
        _exchangeField.borderStyle = UITextBorderStyleRoundedRect;
        _exchangeField.layer.borderColor = [[UIColor dp_colorFromHexString:@"#bd0720"]CGColor];
        _exchangeField.textColor = [UIColor dp_colorFromHexString:@"#7c6e4c"];
        _exchangeField.font = [UIFont dp_systemFontOfSize:21];
    }
    return _exchangeField;
}
- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc]initWithImage:dp_RedPacketImage(@"exchangeBg.png")];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_bgViewTap)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
- (UIView *)pointView
{
    if (_pointView == nil) {
        _pointView = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor dp_colorFromHexString:@"#fecacb"];
//            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 5.0f;
            view;
        });
        
    }
    return _pointView;
}
- (UILabel *)wordsLabel
{
    if (_wordsLabel == nil) {
        _wordsLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor dp_colorFromHexString:@"#fecacb"];
            label.font = [UIFont dp_systemFontOfSize:15];
            label.text = @"请输入兑换码";
            label;
        });
    }
    return _wordsLabel;
}
- (UIImageView *)middleLine
{
    if (_middleLine == nil) {
        _middleLine = [[UIImageView alloc]initWithImage:dp_RedPacketImage(@"middleSpLine.png")];
    }
    return _middleLine;
}
@end

