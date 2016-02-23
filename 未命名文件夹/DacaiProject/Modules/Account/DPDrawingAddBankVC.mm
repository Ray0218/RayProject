//
//  DPDrawingAddBankVC.m
//  DacaiProject
//
//  Created by sxf on 14-9-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDrawingAddBankVC.h"
#import "FrameWork.h"
#import "ModuleProtocol.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPDrawingSuccessVC.h"
#import "DPWebViewController.h"
@interface DPDrawingAddBankVC () <UITableViewDelegate, UITableViewDataSource, ModuleNotify, UIGestureRecognizerDelegate, DPDrawingCellDelegate> {
@private
    UITableView *_tableView;
    CAccount *_accountInstance;
    BOOL _isdrawing, _isLogin; //  是否设置过提款密码
    int _tikuanMoney;          //提款金额
    NSString *_tikuanPassWord; //提款密码
    NSString *_sureTikuanPassword;
    BOOL _isShowMoney;      //是否显示手续费
    BOOL _isScrolBottom;    //是否滚动到最后一行
    BOOL _viewNotshow;      //界面是否显示//退出时或者进入下一界面时不进行提款金额的判断
    NSString *_bankNumber;  //银行卡号
    NSString *_usAbleMoney; //可用余额
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) UITextField *tempTf;
@end

@implementation DPDrawingAddBankVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _accountInstance = CFrameWork::GetInstance()->GetAccount();
        _accountInstance->SetDelegate(self);
        _accountInstance->RefreshDrawBanks();
        _accountInstance->RefreshBindInfo();

        _isLogin = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe9e7e1);
    self.title = @"提款";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    [self buildLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    _isScrolBottom = NO;
    _viewNotshow = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DPToast sharedToast] dismiss];
}
- (void)buildLayout {
    UIView *contentView = self.view;
    [contentView addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        //        make.height.equalTo(@(self.view.frame.size.height-64));
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    UITapGestureRecognizer *tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
}

#pragma mark -UIGestureRecognizerDelegate
- (void)pvt_onTap {
    [self.view endEditing:YES];
}
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    if (screenHeight == keyboardY) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(endFrame), 0);
    }

    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
    //        if (obj.firstItem == self.tableView && obj.firstAttribute == NSLayoutAttributeBottom) {
    //
    //            obj.constant = keyboardY - screenHeight;
    //
    //            [self.view setNeedsUpdateConstraints];
    //            [self.view setNeedsLayout];
    //
    //            [self.view layoutIfNeeded];
    //
    //            *stop = YES;
    //        }
    //    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_isScrolBottom&&(keyboardY<screenHeight)) {
            NSUInteger rowCount = [self.tableView numberOfRowsInSection:1];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:1];
            UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
            [self.tableView scrollRectToVisible:cell.frame animated:YES ];
            //            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //    CGPoint point = [touch locationInView:self.tableView];
    //
    //    if (CGRectContainsPoint(self.tableView.bounds, point)) {
    //        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    //
    //        if ((indexPath.section == 1) && (indexPath.row == 1)) {
    //            return NO;
    //        }
    //    }

    return YES;
}
#pragma mark--UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {

        return 2;
    }
    if (_isShowMoney) {
        return 4;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                static NSString *CellIdentifier = @"acceNameCell";
                DPDrawingCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DPDrawingCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                string phoneNumber;
                string actualName;
                string idCardNumber;
                _accountInstance->GetBindInfo(phoneNumber, actualName, idCardNumber);
                cell.acceNameLabel.text = [NSString stringWithUTF8String:actualName.c_str()];
                cell.cardNameLabel.text = [NSString stringWithUTF8String:idCardNumber.c_str()];
                return cell;

            } break;
            case 1: {
                static NSString *CellIdentifier = @"noBankCell";
                DPDrawingNoBankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DPDrawingNoBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                string ActualUsableBalance;
                int IsIdCarBound;
                int IsDrawPwd;
                int BankNum;

                _accountInstance->GetDrawBanksInfo(ActualUsableBalance, IsIdCarBound, IsDrawPwd, BankNum);

                cell.yueLabel.text = [NSString stringWithFormat:@"%@元", [NSString stringWithUTF8String:ActualUsableBalance.c_str()]];
                return cell;
            } break;

            default:
                break;
        }
    }

    switch (indexPath.row) {

        case 0: {
            static NSString *CellIdentifier = @"drawMoneyCell";
            DPDrawingMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPDrawingMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            return cell;
        } break;

        case 1: {
            if (_isShowMoney) {
                static NSString *CellIdentifier = @"drawExMoneyCell";
                DPDrawingExMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DPDrawingExMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    ;
                }
                int charge;
                _accountInstance->GetCharge(charge);
                [cell setMoneyLabelText:charge totalMoney:_tikuanMoney];
                return cell;
            }
            if (!_isLogin) {
                static NSString *CellIdentifier = @"drawPassWordCell";
                DPDrawingChangePassWordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DPDrawingChangePassWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                return cell;
            }
            static NSString *CellIdentifier = @"drawgChangeBankCell";
            DPDrawingPassWordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPDrawingPassWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            if (!_isdrawing) {
                cell.drawPassWordTf.placeholder = @"初始提款密码和登录密码一致";
            } else {
                cell.drawPassWordTf.placeholder = @"输入提款密码";
            }
            return cell;
        }

        case 2: {
            if (_isShowMoney) {
                if (!_isLogin) {
                    static NSString *CellIdentifier = @"drawPassWordCell";
                    DPDrawingChangePassWordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[DPDrawingChangePassWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.delegate = self;
                    }
                    return cell;
                }
                static NSString *CellIdentifier = @"drawgChangeBankCell";
                DPDrawingPassWordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DPDrawingPassWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                if (!_isdrawing) {
                    cell.drawPassWordTf.placeholder = @"初始提款密码和登录密码一致";
                } else {
                    cell.drawPassWordTf.placeholder = @"输入提款密码";
                }

                return cell;

            } else {
                static NSString *CellIdentifier = @"sureDrawCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    UIButton *sureButton = ({
                        UIButton *button = [[UIButton alloc] init];
                        [button setBackgroundColor:[UIColor redColor]];
                        button.layer.cornerRadius=5;
                        [button addTarget:self action:@selector(pvt_sure) forControlEvents:UIControlEventTouchUpInside];
                        [button setTitle:@"确认提款" forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
                        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:15.0]];
                        button;
                    });
                    [cell.contentView addSubview:sureButton];
                    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell).offset(10);
                        make.left.equalTo(cell).offset(10);
                        make.right.equalTo(cell).offset(-10);
                        make.height.equalTo(@40);
                    }];
                    UIButton *proButton = ({
                        UIButton *button = [[UIButton alloc] init];
                        [button setBackgroundColor:[UIColor clearColor]];
                        [button addTarget:self action:@selector(pvt_proWeb) forControlEvents:UIControlEventTouchUpInside];
                        [button setTitle:@"注意事项" forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor dp_flatBlueColor] forState:UIControlStateNormal];
                        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:12.0]];
                        button;
                    });
                    [cell.contentView addSubview:proButton];
                    [proButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(sureButton.mas_bottom).offset(5);
                        make.width.equalTo(@60);
                        make.right.equalTo(cell.contentView).offset(-10);
                        make.height.equalTo(@25);
                    }];
                }
                return cell;
            }
        } break;

        default:

            break;
    }

    static NSString *CellIdentifier = @"sureDrawCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIButton *sureButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setBackgroundColor:[UIColor redColor]];
            button.layer.cornerRadius=5;
            [button addTarget:self action:@selector(pvt_sure) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"确认提款" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont dp_boldArialOfSize:15.0]];
            button;
        });
        [cell.contentView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(10);
            make.left.equalTo(cell).offset(10);
            make.right.equalTo(cell).offset(-10);
            make.height.equalTo(@40);
        }];
        UIButton *proButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(pvt_proWeb) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"注意事项" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor dp_flatBlueColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont dp_boldArialOfSize:12.0]];
            button;
        });
        [cell.contentView addSubview:proButton];
        [proButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sureButton.mas_bottom).offset(5);
            make.width.equalTo(@60);
            make.right.equalTo(cell.contentView).offset(-10);
            make.height.equalTo(@25);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {

        switch (indexPath.row) {
            case 0:
                return 70;
                break;
            case 1:
                return 140;
                break;
            default:
                break;
        }

        return 55;
    }
    switch (indexPath.row) {

        case 0:

            return 45;

        case 1: {
            if (_isShowMoney) {
                return 30;
            }
            if (!_isLogin) {
                return 90;
            }
            return 45;
        } break;
        case 2:
            if (_isShowMoney) {
                if (!_isLogin) {
                    return 90;
                }
                return 45;
            } else {
                return 50 + 30;
            }

        default:
            break;
    }
    return 50 + 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0;
}
- (void)pvt_proWeb {
    _viewNotshow = YES;
    if (self.tempTf.editing) {
        [self.tempTf resignFirstResponder];
    }
    DPWebViewController *webCtrl = [[DPWebViewController alloc] init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kDrawAttentionURL]];
    webCtrl.title = @"注意事项";
    webCtrl.canHighlight = NO;
    [self.navigationController pushViewController:webCtrl animated:YES];
}
- (void)pvt_sure {
    if (self.tempTf.editing) {
        [self.tempTf resignFirstResponder];
    }
    NSDecimalNumber *drawMoney=(NSDecimalNumber *)[NSNumber numberWithInt:_tikuanMoney];
    NSDecimalNumber *ableMoney=[NSDecimalNumber decimalNumberWithString:_usAbleMoney];

    DPDrawingNoBankCell *cell = (DPDrawingNoBankCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell.bankNumberTf.text.length < 1) {
        [[DPToast makeText:@"请输入银行卡号"] show];
        return;
    }
    string BankCardNumber = [cell.bankNumberTf.text cStringUsingEncoding:NSUTF8StringEncoding];
    string bankCode, bankName, bankJc;
    _accountInstance->GetBankNameFromId(bankCode, bankName, bankJc);

    if (_tikuanMoney < 1) {
        [[DPToast makeText:@"提款金额至少为5元"] show];
        return;
    }
    if ([drawMoney compare:ableMoney]==NSOrderedDescending) {
        [[DPToast makeText:@"可提款金额不足，请重新输入"] show];
        return;
    }
    if (_tikuanPassWord.length < 1) {
        [[DPToast makeText:@"提款密码不能为空"] show];
        return;
    }
    if ((bankCode.length() < 1) && (bankName.length() < 1)) {
        [[DPToast makeText:@"银行卡输入错误"] show];
        return;
    }
    if ((_tikuanPassWord.length < 6) || (_tikuanPassWord.length > 15)) {
        [[DPToast makeText:@"提款密码为6到15位"] show];
        return;
    }
    if (!_isLogin) {
        //        if (![_tikuanPassWord isEqualToString:_sureTikuanPassword]) {
        //            [[DPToast makeText:@"两次密码输入不一致"] show];
        //            return;
        //        }
        //        _accountInstance->SubmitDrawMoney4(bankCode, bankName, BankCardNumber, _tikuanMoney, [_tikuanPassWord cStringUsingEncoding:NSUTF8StringEncoding]);
        //        [self showDarkHUD];
        return;
    } else {
        _accountInstance->SubmitDrawMoney2(bankCode, bankName, BankCardNumber, _tikuanMoney, [_tikuanPassWord cStringUsingEncoding:NSUTF8StringEncoding]);
        [self showDarkHUD];
        return;
    }
}

- (void)pvt_onBack {
    _viewNotshow = YES;
    if (self.tempTf.editing) {
        [self.tempTf resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma make - getter, setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma make DPDrawingCellDelegate

- (void)bankNameFromBankNumber:(DPDrawingNoBankCell *)cell {
    _bankNumber = cell.bankNumberTf.text;
    if (cell.bankNumberTf.text.length < 6) {
        [[DPToast makeText:@"银行卡输入错误"] show];
        cell.bankNameLabel.text = @"";
        return;
    }
    string bankCode = [cell.bankNumberTf.text cStringUsingEncoding:NSUTF8StringEncoding];
    _accountInstance->RefreshBankName(bankCode);
    [self showHUD];
}
- (void)drawingMoneyCell:(DPDrawingMoneyCell *)cell {
     _tikuanMoney = [cell.drawMoneyTf.text integerValue];
    NSDecimalNumber *drawMoney=[NSDecimalNumber decimalNumberWithString:cell.drawMoneyTf.text];
    NSDecimalNumber *ableMoney=[NSDecimalNumber decimalNumberWithString:_usAbleMoney];
    if (_tikuanMoney < 5) {
        _isShowMoney = NO;
            [[DPToast makeText:@"提款金额最少5元"] show];
            [self.tableView reloadData];
        return;
    }
    if ([drawMoney compare:ableMoney]==NSOrderedDescending)
    {
            [[DPToast makeText:@"可提款金额不足，请重新输入"] show];
            _isShowMoney=NO;
            [self.tableView reloadData];
        return ;
    }

   
    if (_bankNumber.length < 1) {
        [[DPToast makeText:@"银行卡号不能为空"] show];
        return;
    }
    string bankCode, bankName, bankJc;
    _accountInstance->GetBankNameFromId(bankCode, bankName, bankJc);
    if ((bankCode.length() < 1) && (bankName.length() < 1)) {
        [[DPToast makeText:@"银行卡输入错误"] show];
        return;
    }

    //    string bankCode, bankName, bankJc;
    //    _accountInstance->GetBankNameFromId(bankCode, bankName, bankJc);
    _accountInstance->RefreshCharge(_tikuanMoney, _bankNumber.UTF8String, 0);
    [self showHUD];
}
//其他状态点击获取手续费
- (void)refreshOtherShouxufei {
    if (_tikuanMoney < 5) {
        return;
    }
    string bankCode;
    if (_bankNumber.length < 1) {
        return;
    }
    _accountInstance->RefreshCharge(_tikuanMoney, _bankNumber.UTF8String, 0);
    [self showHUD];
}
- (void)drawingPassWordCell:(DPDrawingPassWordCell *)cell {

    _tikuanPassWord = cell.drawPassWordTf.text;
}
- (void)drawingChangePassWordCell:(DPDrawingChangePassWordCell *)cell {
    _sureTikuanPassword = cell.sureDrawPassWordTf.text;
}
- (void)textFieldBeginCell:(UITableViewCell *)cell texfField:(UITextField *)texfField isScrollBottom:(BOOL)scrollBottom {
    self.tempTf = texfField;
    _isScrolBottom = scrollBottom;
    //    CGRect point = [self.view convertRect:texfField.frame fromView:texfField];
    //    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    //    int height = screenHeight - 64 - point.origin.y - point.size.height - 231;
    //
    //    if ([cell isKindOfClass:[DPDrawingMoneyCell class]] || [cell isKindOfClass:[DPDrawingPassWordCell class]] || [cell isKindOfClass:[DPDrawingChangePassWordCell class]]) {
    //        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
    //            if (obj.firstItem == self.tableView && obj.firstAttribute == NSLayoutAttributeTop) {
    //
    //                obj.constant =height;
    //
    //                [self.view setNeedsUpdateConstraints];
    //                [self.view setNeedsLayout];
    //                [self.view layoutIfNeeded];
    //                //                [UIView animateWithDuration:0.2 delay:0 options:2 << 16 animations:^{
    //                //                    [self.view layoutIfNeeded];
    //                //                } completion:nil];
    //                //
    //                *stop = YES;
    //            }
    //        }];
    //    }
}
- (void)drawingMoneyButtonClick {
    _viewNotshow = YES;
    if (self.tempTf.editing) {
        [self.tempTf resignFirstResponder];
    }
    DPWebViewController *web = [[DPWebViewController alloc] init];
    web.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kDrawPoundageURL]];
    web.title = @"提款说明";
    [self.navigationController pushViewController:web animated:YES];
}
- (NSString *)errorString:(int)ret {
    NSString *errorString = @"";
    if (ret <= -800) {
        errorString = [DPErrorParser AccountErrorMsg:ret];
    } else {
        errorString = [DPErrorParser CommonErrorMsg:ret];
    }
    return errorString;
}
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {

    dispatch_async(dispatch_get_main_queue(), ^{
        
       
            if (cmdtype==ACCOUNT_BANKNAME) {
                 [self dismissHUD];
                if (ret<0) {
                    [[DPToast makeText:[self errorString:ret]]show];
                    return ;
                }

            DPDrawingNoBankCell *cell=(DPDrawingNoBankCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            string bankCode, bankName, bankJc;
            _accountInstance->GetBankNameFromId(bankCode, bankName, bankJc);
            cell.bankNameLabel.text=[NSString stringWithUTF8String:bankName.c_str()];
                [self refreshOtherShouxufei];
            return;
        }else if (cmdtype==ACCOUNT_CHARGE){
            [self dismissHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            _isShowMoney=YES;
            [self.tableView reloadData];
            return;
        }else if (cmdtype==ACCOUNT_DRAWBANK){
            [self dismissDarkHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            string ActualUsableBalance;
            int  IsIdCarBound;
            int  IsDrawPwd;
            int  BankNum;
            _accountInstance-> GetDrawBanksInfo(ActualUsableBalance,IsIdCarBound,IsDrawPwd,BankNum);
            _isdrawing=IsDrawPwd;
            _usAbleMoney = [NSString stringWithUTF8String:ActualUsableBalance.c_str()];
            [self.tableView reloadData];
        }else if ((cmdtype>=ACCOUNT_DRAWMONEY1)&&(cmdtype<=ACCOUNT_DRAWMONEY6)){
            [self dismissDarkHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            string ActualUsableBalance;
            int  IsIdCarBound;
            int  IsDrawPwd;
            int  BankNum;
            _accountInstance-> GetDrawBanksInfo(ActualUsableBalance,IsIdCarBound,IsDrawPwd,BankNum);
            string amount,handfee,balance,arriveTime;
            _accountInstance->GetDrawMoneyInfo(amount, handfee, balance, arriveTime);
            DPDrawingSuccessVC *vc=[[DPDrawingSuccessVC alloc]init];
            NSString* usableBalaneStr = [NSString stringWithUTF8String:ActualUsableBalance.c_str()] ;
            NSArray* arr = [usableBalaneStr componentsSeparatedByString:@","] ;
            NSMutableString* usableMoney = [[NSMutableString alloc]initWithCapacity:arr.count] ;
            for (NSString* ss in arr) {
                [usableMoney appendString:ss] ;
            }
           [vc bulidLayout:[NSString stringWithUTF8String:amount.c_str()] shouxuMoney:[NSString stringWithUTF8String:handfee.c_str()] yueMoney:[NSString stringWithUTF8String:balance.c_str()] arriveTime:[NSString stringWithUTF8String:arriveTime.c_str()]];
            [self.navigationController pushViewController:vc animated:YES];
        }

        DPDrawingCardCell *cell=(DPDrawingCardCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        string phoneNumber;
        string actualName;
        string idCardNumber;
        _accountInstance->GetBindInfo(phoneNumber, actualName, idCardNumber);
        cell.acceNameLabel.text=[NSString stringWithUTF8String:actualName.c_str()];
        cell.cardNameLabel.text=[NSString stringWithUTF8String:idCardNumber.c_str()];
    });
}

@end
