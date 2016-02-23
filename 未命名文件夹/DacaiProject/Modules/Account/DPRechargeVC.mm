//
//  DPRechargeVC.m
//  DacaiProject
//
//  Created by sxf on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRechargeVC.h"
#import "DPRechargeBankCell.h"
#import "DPAddBankVC.h"
#import "DPRechargeAccNameVC.h"
#import "FrameWork.h"
#import "ModuleProtocol.h"
#import "WXApi.h"
#import "LTInterface.h"
#import <AlipaySDK/Alipay.h>
#import "LLPaySdk.h"
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"
#import "Tenpay.h"
#import "Umpay.h"
#import "DPWebViewController.h"
#import "DPVerifyUtilities.h"
#import "DPRechargeSuccessVC.h"
#import "XMLDictionary.h"
static NSArray *rcImageNames = @[ @"zhifubao.png", @"zhifubao.png", @"weixin.png", @"yinlian.png", @"caifutong.png", @"xinyongka.png" ];
static NSArray *rcTopNames = @[ @"支付宝快捷支付", @"支付宝网页支付", @"微信在线充值", @"银联卡在线充值", @"财付通充值", @"信用卡充值" ];
static NSArray *rcBottomNames = @[ @"支持支付宝余额和银行卡充值", @"支持支付宝余额和银行卡充值", @"无需开通网银，支持信用卡、借记卡", @"无需开通网银，支持信用卡，借记卡", @"需开通财付通账号", @"支持招行、工行、建行等信用卡" ];

@interface DPRechargeVC () <UITableViewDelegate,
                            UITableViewDataSource,
                            UITextFieldDelegate,
                            ModuleNotify,
                            WXApiDelegate,
                            LTInterfaceDelegate,
                            DPRechargeCellDelegate,
                            LLPaySdkDelegate,
                            UmpayDelegate> {
@private
    UITableView *_tableView;
    UITextField *_moneyTextField;
    BOOL _isBank;
    BOOL _isOtherRecharge;
    CAccount *_accountInstance;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UITextField *moneyTextField;
@property (nonatomic, assign) int bankCount;
@property (nonatomic, strong) LLPaySdk *sdk;
@property (nonatomic, strong) NSString *bankNo;

@property (nonatomic, strong) NSDictionary *orderParam;

@end

@implementation DPRechargeVC

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
        _isBank = 0;
        _isOtherRecharge = 1;
        _accountInstance = CFrameWork::GetInstance()->GetAccount();
        _accountInstance->ReLianLianBanks();
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
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请输入充值金额";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont dp_systemFontOfSize:14.0];
    [topView addSubview:label];

    UIView *tfbackView = [UIView dp_viewWithColor:[UIColor clearColor]];
    tfbackView.layer.cornerRadius = 3;
    tfbackView.layer.borderColor = UIColorFromRGB(0xc8c3b0).CGColor;
    tfbackView.layer.borderWidth = 0.5;
    [topView addSubview:tfbackView];
    [tfbackView addSubview:self.moneyTextField];

    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@90);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@20);
    }];
    [tfbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(label.mas_bottom).offset(5);
        make.height.equalTo(@35);
    }];
    UILabel *danweiLabel = [[UILabel alloc] init];
    danweiLabel.text = @"元";
    danweiLabel.textColor = UIColorFromRGB(0x333333);
    danweiLabel.textAlignment = NSTextAlignmentCenter;
    danweiLabel.font = [UIFont dp_systemFontOfSize:14.0];
    [tfbackView addSubview:danweiLabel];
    [danweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.right.equalTo(tfbackView).offset(-5);
        make.top.equalTo(tfbackView).offset(5);
        make.height.equalTo(@25);
    }];
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tfbackView).offset(10);
        make.right.equalTo(danweiLabel.mas_left);
        make.top.equalTo(tfbackView).offset(5);
        make.height.equalTo(@25);
    }];

    [self.view addSubview:self.tableView];

    [self.view bringSubviewToFront:topView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom).offset(-5);
        make.bottom.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

- (void)dealloc {
    _accountInstance->ClearLianLianBank();
}

#pragma mark--UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((_isBank) && (section == 0)) {
        return (self.bankCount + 1);
    }
    if ((_isBank == 0) && (section == 0)) {
        return 1;
    }
    if (_isOtherRecharge) {
        return 6;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_isBank && (indexPath.section == 0)) {
        if (indexPath.row == self.bankCount) {
            static NSString *CellIdentifier = @"addbankCell";
            DPRechargeAddCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPRechargeAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
            }

            return cell;
        }
        static NSString *CellIdentifier = @"bankCell";
        DPRechargeBankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPRechargeBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        vector<string> bankGUIDs;
        vector<string> bankNames;
        vector<string> bankTypes;
        vector<string> bankCards;
        _accountInstance->GetLianLianBanks(bankGUIDs, bankNames, bankTypes, bankCards);
        NSString *bankType = [NSString stringWithUTF8String:bankTypes[indexPath.row].c_str()];
        [cell setInfoLabelText:[NSString stringWithUTF8String:bankNames[indexPath.row].c_str()] banktype:bankType number:[NSString stringWithUTF8String:bankCards[indexPath.row].c_str()]];

        return cell;
    }
    if ((_isBank == 0) && (indexPath.section == 0)) {
        static NSString *CellIdentifier = @"noBankCell";
        DPRechargeLLNoBankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPRechargeLLNoBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }

        return cell;
    }
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
    if (indexPath.section == 1) {
        return 60;
    }
    if (indexPath.section == 0) {
        if (_isBank == 0) {
            return 135;
        }
        if (indexPath.row == _bankCount) {
            return 53;
        }
    }

    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
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
    if (section == 0) {
        return view;
    }
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
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:_isOtherRecharge ? dp_CommonImage(@"black_arrow_down.png") : dp_CommonImage(@"black_arrow_up.png")];
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
    [self textfieldResignFirstResponder];
    if (indexPath.section == 0) {
        if (_isBank) {
            if (self.moneyTextField.text.length < 1) {
                [[DPToast makeText:@"请至少输入1元"] show];
                return;
            }
            if (self.moneyTextField.text.length > 10000) {
                [[DPToast makeText:@"最多只能输入10000元"] show];
                return;
            }
            if (indexPath.row == self.bankCount) {
                bool isband;
                string userName;
                string userIdCard;
                _accountInstance->GetLLUserInfo(isband, userName, userIdCard);
                DPAddBankVC *vc = [[DPAddBankVC alloc] init];
                vc.moneyString = self.moneyTextField.text;
                [vc setNameText:[NSString stringWithUTF8String:userName.c_str()] cardIdText:[NSString stringWithUTF8String:userIdCard.c_str()]];

                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            vector<string> bankGUIDs;
            vector<string> bankNames;
            vector<string> bankTypes;
            vector<string> bankCards;
            _accountInstance->GetLianLianBanks(bankGUIDs, bankNames, bankTypes, bankCards);
            _accountInstance->UseBoundBankGUID(bankGUIDs[indexPath.row], self.moneyTextField.text.integerValue);
            return;
        }
        return;
    }

    int money = [self.moneyTextField.text integerValue];
    switch (indexPath.row) {
        case 0:
            if (money < 1) {
                [[DPToast makeText:@"请至少输入1元"] show];
                return;
            }
            if (money > 50000) {
                [[DPToast makeText:@"最多只能输入50000元"] show];
                return;
            }
            _accountInstance->ReChargeByPayAlipay(money);
            [self showHUD];
            break;
        case 1: {
            if (money < 1) {
                [[DPToast makeText:@"请至少输入1元"] show];
                return;
            }
            if (money > 50000) {
                [[DPToast makeText:@"最多只能输入50000元"] show];
                return;
            }
            NSDictionary *postInfo = @{ @"UserToken" : @"",
                                        @"Amt" : @(money),
                                        @"OperateChanel" : @(CFrameWork::GetInstance()->GetChannelId()) };
            NSError *error;
            NSData *postData = [NSJSONSerialization dataWithJSONObject:postInfo options:0 error:&error];
            if (error == nil && postData) {
                DPWebViewController *web = [[DPWebViewController alloc] init];
                [web setCanHighlight:YES];
                [web setTitle:@"支付宝网页充值"];
                [web setPostRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kAlipayTopupURL]] postData:postData];
                [self.navigationController pushViewController:web animated:YES];
            }
        } break;
        case 2: {
            if (money < 1) {
                [[DPToast makeText:@"请至少输入1元"] show];
                return;
            }
            if (money > 1000) {
                [[DPToast makeText:@"最多只能输入1000元"] show];
                return;
            }
            if (![WXApi isWXAppInstalled]) {
                [[DPToast makeText:@"请安装微信"] show];
                return;
            }
            [self showHUD];
            _accountInstance->RefreshWeChatTopup(money);
        } break;
        case 3: {
            if ((money < 10) || (money > 2000)) {
                [[DPToast makeText:@"银联卡充值范围：10-2000元"] show];
                return;
            }
            _accountInstance->ReChargeByUnionPay(money);
            [self showHUD];
        } break;
        case 4:
            if ((money < 1) || (money > 1000)) {
                [[DPToast makeText:@"财付通充值范围：1-1000元"] show];
                return;
            }
            if ([Tenpay isTenpayAvailable]) {
                _accountInstance->ReChargeByTencent(money);
                [self showHUD];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装财付通客户端, 是否现在前往安装?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                av.tag = 93103;
                [av show];
            }

            break;
        case 5:
            if (money < 1) {
                [[DPToast makeText:@"请至少输入1元"] show];
                return;
            }
            if (money > 5000) {
                [[DPToast makeText:@"最多只能输入5000元"] show];
                return;
            }
            _accountInstance->ReUMPay(money);
            [self showHUD];
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 93103 && buttonIndex == 1) {
        [Tenpay gotoTenpayOnAppStore];
    }
}
#pragma mark--DPNoBankCellDelegate
- (void)bankInfoTextField:(UITextField *)textField {
    self.bankNo = textField.text;
}
- (void)rechargeLLNoBallCellNext:(DPRechargeLLNoBankCell *)cell {
    [cell.bankTextfield resignFirstResponder];
    bool isBind;
    string userName;
    string userIdCard;
    _accountInstance->GetLLUserInfo(isBind, userName, userIdCard);
    if (!isBind) {
        string cardId = [cell.bankTextfield.text cStringUsingEncoding:NSUTF8StringEncoding];
        int index = _accountInstance->RefreshBankName(cardId);
        if (index < 0) {
            [[DPToast makeText:@"银行信息错误"] show];
        } else {
            [self showHUD];
        }
        return;
    }
    if ([self.moneyTextField.text intValue] > 10000) {
        [[DPToast makeText:@"银行卡充值单笔不得超过10000元"] show];
        return;
    }
    if (self.moneyTextField.text.length <= 0) {
        [[DPToast makeText:@"请输入充值金额"] show];
        return;
    }
    if (self.bankNo.length < 1) {
        [[DPToast makeText:@"请输入银行卡信息"] show];
        return;
    }
    string bankNumber = [self.bankNo cStringUsingEncoding:NSUTF8StringEncoding];
    int amt = [self.moneyTextField.text integerValue];
    int ret = _accountInstance->AddLianLianBank(bankNumber, amt);
    if (ret >= 0) {
        [self showHUD];
    }
    //    [self createOrder];
    //    [self LLPaySDK];
}

- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)gesture {
    _isOtherRecharge = !_isOtherRecharge;
    [self.tableView reloadData];
}

- (void)pvt_onBack {
    [self textfieldResignFirstResponder];

    NSUInteger dd = self.navigationController.viewControllers.count;
    if (dd <= 1) {
        [self dismissViewControllerAnimated:YES completion:^{}];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pvt_onNext {
    DPRechargeAccNameVC *vc = [[DPRechargeAccNameVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
- (UITextField *)moneyTextField {
    if (_moneyTextField == nil) {
        _moneyTextField = [[UITextField alloc] init];
        //        _moneyTextField.placeholder = @"输入提款金额";
        _moneyTextField.backgroundColor = [UIColor clearColor];
        _moneyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _moneyTextField.font = [UIFont dp_systemFontOfSize:16];
        _moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextField.text = @"100";
        _moneyTextField.delegate = self;
    }
    return _moneyTextField;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self textfieldResignFirstResponder];
}

- (void)textfieldResignFirstResponder {
    if (self.moneyTextField.editing) {
        [self.moneyTextField resignFirstResponder];
    }
    if (!_isBank) {
        DPRechargeLLNoBankCell *cell = (DPRechargeLLNoBankCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell.bankTextfield.editing) {
            [cell.bankTextfield resignFirstResponder];
        }
    }
}

#pragma mark - textFieldDalegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[DPToast sharedToast] dismiss];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    if (string.length == 0) {
        return YES;
    }
    int newInt = [[textField.text stringByReplacingCharactersInRange:range withString:string] intValue];

    if (newInt <= 0) {
        [[DPToast makeText:@"充值金额不得小于1元"] show];
        return NO;
    }

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.moneyTextField) {
        [self.moneyTextField selectAll:self];
    }
}

#pragma mark - Mod  uleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissHUD];
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
                break;
            case ACCOUNT_PAYUNIONPAY://银联
            {
                string merchantId;
                string merchantOrderId;
                string merchantOrderTime;
                string sign;
                int index= _accountInstance->GetUnionPayInfo(merchantId, merchantOrderId, merchantOrderTime, sign);
                if (index<0) {
                    [[DPToast makeText:@"系统繁忙"] show];
                    return ;
                }
                NSString * order = [NSString stringWithFormat:@"\
                                    <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
                                    <upomp application='LanchPay.Req' version='1.0.0'>\
                                    <merchantId>%@</merchantId>\
                                    <merchantOrderId>%@</merchantOrderId>\
                                    <merchantOrderTime>%@</merchantOrderTime>\
                                    <sign>%@</sign>\
                                    </upomp>",
                                    [NSString stringWithUTF8String:merchantId.c_str()],
                                    [NSString stringWithUTF8String:merchantOrderId.c_str()],
                                    [NSString stringWithUTF8String:merchantOrderTime.c_str()],
                                    [NSString stringWithUTF8String:sign.c_str()]];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController * vc = [LTInterface getHomeViewControllerWithType:0 strOrder:order andDelegate:self];
                    [self.navigationController pushViewController:vc animated:NO];
                });
            }
                break;
            case ACCOUNT_PAYTENCENT://财付通
            {
                string tok;
                _accountInstance->GetToken(tok);
                
                NSError *error;
                NSString *token_id=[NSString stringWithUTF8String:tok.c_str()];
                NSString *bargainor_id = @"1219196401";
                NSString *notifyurl = @"hzdacai://payresult?result=${result}&retcode=${retcode}&retmsg=${retmsg}&sp_data=${sp_data}&whatever=tenpayCallBack";
                NSDictionary *payinfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                         token_id, PayInfoTokenIDKey,
                                         bargainor_id, PayInfoBargainorIDKey,
                                         notifyurl, PayInfoNotifyURLKey,
                                         nil];
//                NSString *json = [NSString stringWithUTF8String:tok.c_str()];
//                id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
                BOOL ok = [Tenpay payWithDictionary:payinfo error:&error];
                if (!ok) {
                    NSString *message = [NSString stringWithFormat: @"错误原因：%@",
                                         [error localizedDescription]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:message
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles: nil];
                        [alert show];
                    });
                }

            }
                break;
            case ACCOUNT_PAYALIPAY://支付宝
            {
                string content;
                string sign;
                _accountInstance->GetPayAlipayInfo(content, sign);
                NSString * appScheme = @"hzdacai";
                
                NSString * orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                          [NSString stringWithUTF8String:content.c_str()],  [NSString stringWithUTF8String:sign.c_str()], @"RSA"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[Alipay defaultService] pay:orderString From:appScheme CallbackBlock:^(NSString *resultString) {
                      
                        if (resultString.length) {
                            NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
                            NSError *error;
                            NSDictionary *obj = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil;
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                               NSInteger resultStatus=[[obj objectForKey:@"ResultStatus"] integerValue];
                                if (resultStatus==9000) {
                                    DPRechargeSuccessVC *vc=[[DPRechargeSuccessVC alloc] init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                    return;
                                }
                                
                                if (resultStatus!=6001){
                                [[DPToast makeText:[obj objectForKey:@"memo"]]show];
                                }
                            }

                        }
                    }];
                });

            }
                break;
            case ACCOUNT_LL_BANK_LIST:  // 连连银行列表
            {
                vector<string> bankGUIDs;
                vector<string> bankNames;
                vector <string>bankTypes;
                vector <string>bankCards;
                _accountInstance->GetLianLianBanks(bankGUIDs,bankNames, bankTypes, bankCards);
                self.bankCount=bankNames.size();
                if (self.bankCount>0) {
                    _isBank=YES;
                }
                [self.tableView reloadData];
            }
                break;
            case ACCOUNT_LL_TOPUP:  // 连连获取token
            {
                string token;
                _accountInstance->GetBindLianLianInfo(token);
                
                NSError *error;
                NSString *json = [NSString stringWithUTF8String:token.c_str()];
                id obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
                [self.sdk presentPaySdkInViewController:self withTraderInfo:obj];
            }
                break;
            case ACCOUNT_BANKNAME:
            {
                string bankCode, bankName, bankJc;
                _accountInstance->GetBankNameFromId(bankCode, bankName, bankJc);
                       DPRechargeAccNameVC *vc=[[DPRechargeAccNameVC alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                       vc.amt=[self.moneyTextField.text integerValue];
                        vc.bankNumber.text=self.bankNo;
                       vc.bankName.text=[NSString stringWithUTF8String:bankName.c_str()];
                NSString* bankIcon =[NSString stringWithUTF8String:bankJc.c_str()] ;
                NSString* icon = [NSString stringWithFormat:@"%@.png",bankIcon] ;
                vc.bankView.image = dp_BankIconImage(icon) ;
            }
                break;
            case ACCOUNT_UMPAY_TOPUP: // U付获取token
            {
                string trade;
                string idCard;
                string actualName;
                _accountInstance->GetUMPayTrade(trade, idCard, actualName);
                BOOL isSuccess = [Umpay firstPay:[NSString stringWithUTF8String:trade.c_str()]
                                       merCustId:nil
                                   shortBankName:nil
                                      cardHolder:[NSString stringWithUTF8String:actualName.c_str()]
                                    identityCode:[NSString stringWithUTF8String:idCard.c_str()]
                                        editFlag:@"0"
                              rootViewController:self
                                        delegate:self];
                if (!isSuccess) {
                    [[DPToast makeText:@"信用卡充值失败"] show];
                }
            }
                break;
            default:
                break;
        }
    });
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
#pragma make - 信用卡支付
- (void)onPayResult:(NSString *)orderId resultCode:(NSString *)resultCode resultMessage:(NSString *)resultMessage {
    if ([resultCode isEqualToString:@"0000"]) {
        DPRechargeSuccessVC *vc = [[DPRechargeSuccessVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [[DPToast makeText:resultMessage] show];
}

#pragma make-- 连连支付

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"支付成功";
            NSString *result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                DPRechargeSuccessVC *vc=[[DPRechargeSuccessVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                });
            } else if ([result_pay isEqualToString:@"PROCESSING"]) {
                msg = @"支付单处理中";
            } else if ([result_pay isEqualToString:@"FAILURE"]) {
                msg = @"支付单失败";
            } else if ([result_pay isEqualToString:@"REFUND"]) {
                msg = @"支付单已退款";
            }
        } break;
        case kLLPayResultFail: {
            msg = @"支付失败";
        } break;
//        case kLLPayResultCancel: {
//            msg = @"支付取消";
//        } break;
        case kLLPayResultInitError: {
            msg = @"钱包初始化异常";
        } break;

        default:
            break;
    }
    [[DPToast makeText:msg] show];
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
            DPRechargeSuccessVC *vc=[[DPRechargeSuccessVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [[DPToast makeText:resp.errStr] show];
    });
}

#pragma make-- 银联支付
- (void)returnWithResult:(NSString *)strResult {
    if (strResult.length < 1) {
        return;
    }
     NSDictionary *dic = [NSDictionary dictionaryWithXMLString:strResult];
    if (dic==nil) {
        return;
    }
    NSString *respCode=[dic objectForKey:@"respCode"];
    if ([respCode isEqualToString:@"0000"]) {
        DPRechargeSuccessVC *vc = [[DPRechargeSuccessVC alloc] init];
       [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [[DPToast makeText:[dic objectForKey:@"respDesc"]] show];
    
   }
@end
