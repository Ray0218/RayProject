//
//  DPRechargeAccNameVC.m
//  DacaiProject
//
//  Created by sxf on 14-9-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRechargeAccNameVC.h"
#import "DPRechargeSuccessVC.h"
#import "FrameWork.h"
#import "LLPaySdk.h"
@interface DPRechargeAccNameVC ()<
LLPaySdkDelegate,
UITextFieldDelegate,
ModuleNotify> {
@private
    UITextField *_nameTf, *_cardIdTf;
    UILabel *_bankName, *_bankNumber;
    UIImageView *_bankView;
    CAccount *_accountInstance;
}
@property (nonatomic, strong, readonly) UITextField *nameTf, *cardIdTf;
@property (nonatomic, strong) LLPaySdk *sdk;
@end

@implementation DPRechargeAccNameVC
- (LLPaySdk *)sdk {
    if (_sdk == nil) {
        _sdk = [[LLPaySdk alloc] init];
        _sdk.sdkDelegate = self;
    }
    return _sdk;
}
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
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.title = @" ";
    self.view.backgroundColor = UIColorFromRGB(0xe9e7e1);
    [self buildLayout];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
}
- (void)buildLayout {
    UIImageView *topView = [[UIImageView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    topView.image = [dp_AccountImage(@"account_wave.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [self.view addSubview:topView];
    [topView addSubview:self.bankView];
    [topView addSubview:self.bankName];
    [topView addSubview:self.bankNumber];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@75);
    }];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@40);
        make.centerY.equalTo(topView);
        make.height.equalTo(@40);
    }];
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankView.mas_right).offset(5);
        make.right.equalTo(topView).offset(-10);
        make.top.equalTo(topView).offset(15);
        make.height.equalTo(@15);
    }];
    [self.bankNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankView.mas_right).offset(5);
        make.right.equalTo(topView).offset(-10);
        make.top.equalTo(self.bankName.mas_bottom).offset(10);
        make.height.equalTo(@20);
    }];

    UILabel *label1 = [self createlabel:@"姓   名:" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:14.0] alignment:NSTextAlignmentRight];
    UILabel *label2 = [self createlabel:@"身份证:" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:14.0] alignment:NSTextAlignmentRight];
    UIView *nameBack = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    nameBack.layer.cornerRadius = 3;
    nameBack.layer.borderColor = UIColorFromRGB(0xc8c3b0).CGColor;
    nameBack.layer.borderWidth = 0.5;
    [self.view addSubview:nameBack];
    UIView *cardIdBack = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    cardIdBack.layer.cornerRadius = 3;
    cardIdBack.layer.borderColor = UIColorFromRGB(0xc8c3b0).CGColor;
    cardIdBack.layer.borderWidth = 0.5;
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:nameBack];
    [self.view addSubview:cardIdBack];
    [nameBack addSubview:self.nameTf];
    [cardIdBack addSubview:self.cardIdTf];

    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.height.equalTo(@30);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1);
        make.right.equalTo(label1);
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.height.equalTo(@30);
    }];
    [nameBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(label1);
        make.bottom.equalTo(label1);
    }];
    [cardIdBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameBack);
        make.right.equalTo(nameBack);
        make.top.equalTo(label2);
        make.bottom.equalTo(label2);
    }];
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameBack).offset(5);
        make.right.equalTo(nameBack).offset(-5);
        make.top.equalTo(nameBack);
        make.bottom.equalTo(nameBack);
    }];
    [self.cardIdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardIdBack).offset(5);
        make.right.equalTo(cardIdBack).offset(-5);
        make.top.equalTo(cardIdBack).offset(5);
        make.bottom.equalTo(cardIdBack).offset(-5);
    }];

    UIButton *loginButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onNext) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button;
    });
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardIdBack.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@40);
    }];
}

- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}

- (UITextField *)nameTf {
    if (_nameTf == nil) {
        _nameTf = [[UITextField alloc] init];
        _nameTf.placeholder = @"必须和银行卡账户名一致";
        _nameTf.backgroundColor = [UIColor clearColor];
        _nameTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameTf.font = [UIFont dp_systemFontOfSize:13];
        _nameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nameTf;
}
- (UITextField *)cardIdTf {
    if (_cardIdTf == nil) {
        _cardIdTf = [[UITextField alloc] init];
        _cardIdTf.placeholder = @"请输入身份证号";
        _cardIdTf.backgroundColor = [UIColor clearColor];
        _cardIdTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _cardIdTf.font = [UIFont dp_systemFontOfSize:14];
        _cardIdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _cardIdTf;
}

- (UILabel *)bankName {
    if (_bankName == nil) {
        _bankName = [[UILabel alloc] init];
//        _bankName.text = @"工商银行";
        _bankName.textColor = UIColorFromRGB(0x333333);
        _bankName.backgroundColor = [UIColor clearColor];
        _bankName.font = [UIFont dp_systemFontOfSize:13.0];
        _bankName.textAlignment = NSTextAlignmentLeft;
    }
    return _bankName;
}
- (UILabel *)bankNumber {
    if (_bankNumber == nil) {
        _bankNumber = [[UILabel alloc] init];
//        _bankNumber.text = @"63341234456778999090";
        _bankNumber.textColor = UIColorFromRGB(0x333333);
        _bankNumber.backgroundColor = [UIColor clearColor];
        _bankNumber.font = [UIFont dp_systemFontOfSize:14.0];
        _bankNumber.textAlignment = NSTextAlignmentLeft;
    }
    return _bankNumber;
}
- (UIImageView *)bankView {
    if (_bankView == nil) {
        _bankView = [[UIImageView alloc] init];
        _bankView.backgroundColor = [UIColor clearColor];
        _bankView.image = dp_BankIconImage(@"default.png") ;

    }
    
    return _bankView;
}
- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pvt_onNext {
    if ((self.bankNumber.text.length<1)||(self.nameTf.text.length<1)||(self.cardIdTf.text.length<1)) {
        [[DPToast makeText:@"不能为空"] show];
    }
    string bankNoString=[self.bankNumber.text cStringUsingEncoding:NSUTF8StringEncoding];
    string userName=[self.nameTf.text cStringUsingEncoding:NSUTF8StringEncoding];
    string userCard=[self.cardIdTf.text cStringUsingEncoding:NSUTF8StringEncoding];
    _accountInstance->BindLianLianBank(bankNoString, userName, userCard, self.amt);
    [self showDarkHUD];
//    DPRechargeSuccessVC *vc = [[DPRechargeSuccessVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nameTf resignFirstResponder];
    [self.cardIdTf resignFirstResponder];
}
#pragma mark - Mod  uleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (cmdtype) {
                
            case ACCOUNT_LL_TOPUP: {
                [self dismissDarkHUD];
                if (ret<0) {
                    NSString *errorString=@"";
                    if (ret<=-800) {
                        errorString=[DPErrorParser AccountErrorMsg:ret];
                    }else{
                        errorString=[DPErrorParser CommonErrorMsg:ret];
                    }
                    [[DPToast makeText:errorString]show];
                    return ;
                }
                string token;
                _accountInstance->GetBindLianLianInfo(token);
                
                NSError *error;
                NSString *json = [NSString stringWithUTF8String:token.c_str()];
                id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
                [self.sdk presentPaySdkInViewController:self withTraderInfo:obj];
            }
                break;
            default:
                break;
        }
    });
}

#pragma make--连连支付

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary*)dic {
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                //
                dispatch_async(dispatch_get_main_queue(),^{
                    DPRechargeSuccessVC *vc=[[DPRechargeSuccessVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"钱包初始化异常";
        }
            break;
            
        default:
            break;
    }
    [[[UIAlertView alloc] initWithTitle:@"结果"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
