//
//  DPAddBankVC.m
//  DacaiProject
//
//  Created by sxf on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAddBankVC.h"
#import "LLPaySdk.h"
#import "FrameWork.h"
#import "DPRechargeSuccessVC.h"
@interface DPAddBankVC () <
LLPaySdkDelegate,
UITextFieldDelegate,
ModuleNotify>{
@private
    UITextField *_bankTextfield;
    UILabel *_nameLabel, *_cardIdLabel;
    CAccount *_accountInstance;
    BOOL _isScrolBottom;       //是否滚动到最后一行
}
@property (nonatomic, strong, readonly) UITextField *bankTextfield;
@property (nonatomic, strong, readonly) UILabel *nameLabel, *cardIdLabel; //姓名，身份证
@property (nonatomic, strong) LLPaySdk *sdk;
@end

@implementation DPAddBankVC

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

    self.title = @"新增银行卡";
    self.view.backgroundColor = UIColorFromRGB(0xe9e7e1);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    [self buildLayout];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _isScrolBottom=NO;
    
}

-(void)setNameText:(NSString*)nameText   cardIdText:(NSString *)cardIdText{
    self.nameLabel.text=nameText;
    self.cardIdLabel.text=cardIdText;
}
- (void)buildLayout {
    UIImageView *topView = [[UIImageView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    topView.image = [dp_AccountImage(@"account_wave.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [self.view addSubview:topView];
    UILabel *label1 = [self createlabel:@"充值金额" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:15.0] alignment:NSTextAlignmentLeft];
    [topView addSubview:label1];
    UILabel *label2 = [self createlabel:self.moneyString titleColor:[UIColor dp_flatRedColor] titleFont:[UIFont dp_systemFontOfSize:15.0] alignment:NSTextAlignmentRight];
    [topView addSubview: label2];
    UILabel *label3 = [self createlabel:@"元" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentLeft];
    [topView addSubview:label3];

    UIView *tfbackView = [UIView dp_viewWithColor:[UIColor clearColor]];
    tfbackView.layer.cornerRadius = 3;
    tfbackView.layer.borderColor = UIColorFromRGB(0xc8c3b0).CGColor;
    tfbackView.layer.borderWidth = 0.5;
    [topView addSubview:tfbackView];

    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@110);
    }];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@100);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@20);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(@15);
    }];
    [ label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.right.equalTo(label3.mas_left);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@20);
    }];

    [tfbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.height.equalTo(@60);
    }];
    UILabel *label4 = [self createlabel:@"姓   名:" titleColor:UIColorFromRGB(0x8b825f) titleFont:[UIFont dp_systemFontOfSize:14.0] alignment:NSTextAlignmentRight];
    UILabel *label5 = [self createlabel:@"身份证:" titleColor:UIColorFromRGB(0x8b825f) titleFont:[UIFont dp_systemFontOfSize:14.0] alignment:NSTextAlignmentRight];
    [tfbackView addSubview:label4];
    [tfbackView addSubview:label5];
    [tfbackView addSubview:self.nameLabel];
    [tfbackView addSubview:self.cardIdLabel];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.left.equalTo(tfbackView).offset(14);
        make.top.equalTo(tfbackView).offset(5);
        make.height.equalTo(@25);
    }];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label4);
        make.right.equalTo(label4);
        make.top.equalTo(label4.mas_bottom);
        make.height.equalTo(@25);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label4.mas_right).offset(5);
        make.right.equalTo(tfbackView).offset(-10);
        make.top.equalTo(label4);
        make.bottom.equalTo(label4);
    }];
    [self.cardIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(label5);
        make.bottom.equalTo(label5);
    }];

    UIView *bottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom);
        //        make.height.equalTo(@125);
        make.bottom.equalTo(self.view);
    }];

    UIView *bankBackView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    bankBackView.layer.cornerRadius = 3;
    bankBackView.layer.borderColor = UIColorFromRGB(0xc8c3b0).CGColor;
    bankBackView.layer.borderWidth = 0.5;
    [bottomView addSubview:bankBackView];
    [bottomView addSubview:self.bankTextfield];

    [bankBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(topView.mas_bottom).offset(15);
        make.height.equalTo(@40);
    }];
    [self.bankTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tfbackView).offset(10);
        make.right.equalTo(tfbackView).offset(-10);
        make.top.equalTo(bankBackView).offset(5);
        make.height.equalTo(@30);
    }];
    UIImageView *bankView = ({
                UIImageView *view = [[UIImageView alloc] initWithImage:[dp_AccountImage(@"bankIdentification.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 0, 0)]];
               view;
    });
    [self.view addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(tfbackView).offset(5);
    make.width.equalTo(@15.5);
    make.top.equalTo(bankBackView.mas_bottom).offset(5);
    }];
    UILabel *label6 = [self createlabel:@"银行账户名必须和实名认证一致" titleColor:UIColorFromRGB(0x8e8e8e) titleFont:[UIFont dp_systemFontOfSize:11.0] alignment:NSTextAlignmentLeft];
    [self.view addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankView.mas_right).offset(3);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(bankBackView.mas_bottom).offset(5);
        make.centerY.equalTo(bankView);
    }];
    //    UIImageView *backView = ({
    //        UIImageView *view = [[UIImageView alloc] initWithImage:[dp_AccountImage(@"fundBg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 0, 0)]];
    //        view;
    //    });
    //    [midView addSubview:backView];
    //    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    //    }];
    UIButton *loginButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onNext) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"确认支付" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button;
    });
    [bottomView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_bottom).offset(10);
        make.left.equalTo(bankBackView);
        make.right.equalTo(bankBackView);
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
#pragma mark -getting,setting

- (UITextField *)bankTextfield {
    if (_bankTextfield == nil) {
        _bankTextfield = [[UITextField alloc] init];
        _bankTextfield.placeholder = @"输入新的银行卡号";
        _bankTextfield.backgroundColor = [UIColor clearColor];
        _bankTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _bankTextfield.font = [UIFont dp_systemFontOfSize:16];
        _bankTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _bankTextfield;
}
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColorFromRGB(0x333333);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont dp_systemFontOfSize:14.0];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (UILabel *)cardIdLabel {
    if (_cardIdLabel == nil) {
        _cardIdLabel = [[UILabel alloc] init];
        _cardIdLabel.text = @"";
        _cardIdLabel.textColor = UIColorFromRGB(0x333333);
        _cardIdLabel.backgroundColor = [UIColor clearColor];
        _cardIdLabel.font = [UIFont dp_systemFontOfSize:14.0];
        _cardIdLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cardIdLabel;
}

- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pvt_onNext {
    if (self.bankTextfield.text.length>1) {
        string bankNo=[self.bankTextfield.text cStringUsingEncoding:NSUTF8StringEncoding];
     _accountInstance->AddLianLianBank(bankNo, [self.moneyString integerValue]);
        [self showDarkHUD];
       
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.bankTextfield resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
