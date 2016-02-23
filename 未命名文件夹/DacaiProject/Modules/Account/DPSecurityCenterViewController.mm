//
//  DPSecurityCenterViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSecurityCenterViewController.h"
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPSecurityCell.h"
#import "DPSecurityAccNameVC.h"
#import "FrameWork.h"
#import "DPAppParser.h"
@interface DPSecurityCenterViewController () <UITableViewDelegate, UITableViewDataSource, DPsecurityCellDelegate, ModuleNotify> {
@private

    UITableView *_tableView;
    int _renzheng[3];
    CAccount *_accountInstance;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic,strong)UITextField *tempTextField;
@end

@implementation DPSecurityCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _accountInstance = CFrameWork::GetInstance()->GetAccount();
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    _accountInstance->SetDelegate(self);
//    _accountInstance->RefreshBindInfo();
//    _accountInstance->RefreshUserInfo();
    // 适配
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];

    [self.view setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1]];
    self.title = @"安全中心";

    //    UITableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(5);
                    make.right.equalTo(self.view).offset(-5);
                    make.top.equalTo(self.view).offset(5);
                    make.height.equalTo(self.view) ;
    }];
    //    for (int i=0; i<3; i++) {
    //        _renzheng[i]=0;
    //    }
    int drawPwdBound;
    int mobileBound;
    int identityBound;
    _accountInstance->IsUserBound(drawPwdBound, mobileBound, identityBound);
    _renzheng[0] = identityBound > 0 ? 1 : 0;
    _renzheng[1] = mobileBound > 0 ? 1 : 0;
    _renzheng[2] = drawPwdBound;
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onHome)];
    _accountInstance->SetDelegate(self);
    _accountInstance->RefreshBindInfo();
    [self showHUD];
//    _accountInstance->RefreshUserInfo();
    //    int drawPwdBound;
    //    int mobileBound;
    //    int identityBound;
    //    _accountInstance->IsUserBound(drawPwdBound, mobileBound, identityBound);
    //    _renzheng[0]=mobileBound>0?1:0;
    //    _renzheng[1]=identityBound>0?1:0;
    //   _renzheng[2]=0;
    //   [self.tableView reloadData];
    //    DPSecurityCell *cell1=(DPSecurityCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //     DPSecurityCell *cell2=(DPSecurityCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //    string userName;
    //    string realAmt;
    //    int coinAmt;
    //    _accountInstance->GetUserInfo(userName, realAmt, coinAmt);
    //    string phoneNumber;
    //    string actualName;
    //    string idCardNumber;
    //
    //    _accountInstance->GetBindInfo(phoneNumber,actualName,idCardNumber);
    //    if (identityBound) {
    //        cell1.usenameLabel.text=[NSString stringWithUTF8String:userName.c_str()];
    //        cell1.accuNamelabel.text=[NSString stringWithUTF8String:actualName.c_str()];
    //        cell1.idCardlabel.text=[NSString stringWithUTF8String:idCardNumber.c_str()];
    //    }
    //    if (identityBound) {
    //        cell2.iphoneLabel.text=[NSString stringWithUTF8String:phoneNumber.c_str()];
    //    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    [self.view resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 210;
    }else if (indexPath.row == 0){
    
        return 110 ;
    }
    
    return 90;
}
-(void)resiginALlTextField{
    //passTextfieldOld,*passTextFieldNew,*passTextFieldSure,*passTextfieldMoneyOld,*passTextFieldMoneyNew,*passTextFieldMoneySure;

    DPSecurityCell *cell=(DPSecurityCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (cell.passTextfieldOld.editing) {
        [cell.passTextfieldOld resignFirstResponder];
    }
    if (cell.passTextFieldNew.editing) {
        [cell.passTextFieldNew resignFirstResponder];
    }
    if (cell.passTextFieldSure.editing) {
        [cell.passTextFieldSure resignFirstResponder];
    }
    if (cell.passTextfieldMoneyOld.editing) {
        [cell.passTextfieldMoneyOld resignFirstResponder];
    }
    if (cell.passTextFieldMoneyNew.editing) {
        [cell.passTextFieldMoneyNew resignFirstResponder];
    }
    if (cell.passTextFieldMoneySure.editing) {
        [cell.passTextFieldMoneySure resignFirstResponder];
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d%d", indexPath.row, _renzheng[indexPath.row]];
    DPSecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[DPSecurityCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];

        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell createView:_renzheng[indexPath.row] indexPath:indexPath];
    }

    cell.isdrawing=_renzheng[2];
    [cell upDateUIForDrawing];
    if (indexPath.row == 2) {
        return cell;
    }
    string userName, realAmt, phoneNum, actualName, idCardNumber;
    int coinAmt, redElpCount;
    _accountInstance -> GetUserInfo(userName, realAmt, coinAmt, redElpCount);
    _accountInstance -> GetBindInfo(phoneNum, actualName, idCardNumber);
    
        NSString *uName = [NSString stringWithUTF8String:userName.c_str()];
        NSString *phoNum = [NSString stringWithUTF8String:phoneNum.c_str()];
        NSString *actName = [NSString stringWithUTF8String:actualName.c_str()];
        NSString *idCard = [NSString stringWithUTF8String:idCardNumber.c_str()];

    if (indexPath.row == 0 && _renzheng[0] > 0) {
        cell.usenameLabel.text = uName;
        cell.accuNamelabel.text = actName;
        cell.idCardlabel.text = idCard;
    }
    if (indexPath.row == 1 && _renzheng[1] > 0){
        cell.iphoneLabel.text = phoNum;
    }

    return cell;
}

- (void)pvt_onBack {
    [DPAppParser backToLeftRootViewController:YES];
}
- (void)pvt_onHome {
    [self.tableView reloadData];
}

- (void)buttonResponerForCell:(DPSecurityCell *)cell butttonIndex:(int)buttonIndex {
    [self resiginALlTextField];
    switch (buttonIndex) {
        case securityIndexName: {
            [self.navigationController pushViewController:[[DPSecurityAccNameVC alloc] init] animated:YES];
        } break;
        case securityIndexPhone: {
            [self.navigationController pushViewController:[[DPSecurityPhoneVC alloc] init] animated:YES];
        } break;
        case securityIndexlogin: {
            if (cell.passTextfieldOld.text.length<1) {
                [[DPToast makeText:@"旧登录密码不能为空"] show];
                return;
            }
            if ((cell.passTextfieldOld.text.length<6)||(cell.passTextfieldOld.text.length>15)) {
                [[DPToast makeText:@"旧登录密码为6-15位"] show];
                return;
            }
            if (cell.passTextFieldNew.text.length<1) {
                [[DPToast makeText:@"新登录密码不能为空"] show];
                return;
            }
            if ((cell.passTextFieldNew.text.length<6)||(cell.passTextFieldNew.text.length>15)) {
                [[DPToast makeText:@"新登录密码为6-15位"] show];
                return;
            }
            if (cell.passTextFieldSure.text.length<1) {
                [[DPToast makeText:@"确认登录密码不能为空"] show];
                return;
            }
            if (![cell.passTextFieldNew.text isEqualToString:cell.passTextFieldSure.text]) {
                [[DPToast makeText:@"两次密码输入不一致"]show];
                return;
            }
            _accountInstance->ResetLoginPwd(cell.passTextfieldOld.text.UTF8String, cell.passTextFieldNew.text.UTF8String);
            [self showDarkHUD];
        } break;
        case securityIndexMoney: {
            if (_renzheng[2]) {
                if (cell.passTextfieldMoneyOld.text.length<1) {
                    [[DPToast makeText:@"旧提款密码不能为空"] show];
                    return;
                }
                if ((cell.passTextfieldMoneyOld.text.length<6)||(cell.passTextfieldMoneyOld.text.length>15)) {
                    [[DPToast makeText:@"旧提款密码为6-15位"] show];
                    return;
                }
                if (cell.passTextFieldMoneyNew.text.length<1) {
                    [[DPToast makeText:@"新提款密码不能为空"] show];
                    return;
                }
                if ((cell.passTextFieldMoneyNew.text.length<6)||(cell.passTextFieldMoneyNew.text.length>15)) {
                    [[DPToast makeText:@"新提款密码为6-15位"] show];
                    return;
                }
                if (cell.passTextFieldMoneySure.text.length<1) {
                    [[DPToast makeText:@"提款密码不能为空"] show];
                    return;
                }
                if (![cell.passTextFieldMoneyNew.text isEqualToString:cell.passTextFieldMoneySure.text]) {
                    [[DPToast makeText:@"两次密码输入不一致"] show];
                    return;
                }
                _accountInstance->ResetDrawPwd(cell.passTextfieldMoneyOld.text.UTF8String, cell.passTextFieldMoneyNew.text.UTF8String);
                [self showDarkHUD];
            }else{
                if (cell.passTextfieldMoneyOld.text.length<1) {
                    [[DPToast makeText:@"登录不能为空"] show];
                    return;
                }
                if ((cell.passTextfieldMoneyOld.text.length<6)||(cell.passTextfieldMoneyOld.text.length>15)) {
                    [[DPToast makeText:@"登录密码为6-15位"] show];
                    return;
                }
                if (cell.passTextFieldMoneyNew.text.length<1) {
                    [[DPToast makeText:@"提款密码不能为空"] show];
                    return;
                }
                if ((cell.passTextFieldMoneyNew.text.length<6)||(cell.passTextFieldMoneyNew.text.length>15)) {
                    [[DPToast makeText:@"提款密码为6-15位"] show];
                    return;
                }
                if (cell.passTextFieldMoneySure.text.length<1) {
                    [[DPToast makeText:@"确认提款密码不能为空"] show];
                    return;
                }
                if (![cell.passTextFieldMoneyNew.text isEqualToString:cell.passTextFieldMoneySure.text]) {
                    [[DPToast makeText:@"两次密码输入不一致"] show];
                    return;
                }
                _accountInstance->SetDrawPwd(cell.passTextfieldMoneyOld.text.UTF8String, cell.passTextFieldMoneyNew.text.UTF8String);
                [self showDarkHUD];
            }
           
        } break;
        case securityIndexChangePhone: {
            [self.navigationController pushViewController:[[DPSecurityChangePhoneVC alloc] init] animated:YES];
        } break;
            
        case securityIndexForgetPassword: {
            DPForegetPassWordVC *forgetVC = [[DPForegetPassWordVC alloc]init];
            forgetVC.forgetType = kForgetTypeScenterPSW;
            [self.navigationController pushViewController:forgetVC animated:YES];
        } break;
        case securityIndexForgetTakeMoneyPSW:{
            // 判断是否已实名手机认证
            if (_renzheng[0] <= 0){
                // 未实名认证
                [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的安全，找回提款密码必须实名与手机认证" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去认证"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1)  [self.navigationController pushViewController:[[DPSecurityAccNameVC alloc] init] animated:YES];
                }];
            }else if (_renzheng[1] <= 0){
                // 未手机认证
                [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"为了您的安全，找回登录密码必须手机认证" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去认证"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1)  [self.navigationController pushViewController:[[DPSecurityPhoneVC alloc] init] animated:YES];
                }];
            }else{
                DPForegetPassWordVC *forgetVC = [[DPForegetPassWordVC alloc]init];
                forgetVC.forgetType = kForgetTypeTakeMoneyPSW;
                [self.navigationController pushViewController:forgetVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - getter, setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

-(NSString *)errorString:(int )ret{
    NSString *errorString=@"";
    if (ret<=-800) {
        errorString=[DPErrorParser AccountErrorMsg:ret];
    }else{
        errorString=[DPErrorParser CommonErrorMsg:ret];
    }
    return errorString;
    
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...

    dispatch_async(dispatch_get_main_queue(), ^{
       
      
        switch (cmdtype) {
            case ACCOUNT_REF_BIND :
                [self dismissHUD];
                if (ret<0) {
                    [[DPToast makeText:[self errorString:ret]]show];
                    return ;
                }
                int drawPwdBound;
                int mobileBound;
                int identityBound;
                _accountInstance->IsUserBound(drawPwdBound, mobileBound, identityBound);
                DPLog(@"reload");
                if ((_renzheng[0]==identityBound)&&(_renzheng[1]==mobileBound)) {
                    [self.tableView reloadData];
                    return ;
                }
                _renzheng[0]=identityBound>0?1:0;
                _renzheng[1]=mobileBound>0?1:0;
                _renzheng[2]=drawPwdBound;
                [self.tableView reloadData];
                break;
                case ACCOUNT_MODIFY_LOGIN_PWD:
            {
                 [self dismissDarkHUD];
                if (ret<0) {
                    [[DPToast makeText:[self errorString:ret]]show];
                    return ;
                }
                [[DPToast makeText:@"登录密码修改成功"] show];
                [self clearAllTextFieldText];
            
            }
                break;
            case ACCOUNT_MODIFY_DRAW_PWD:
            {
                 [self dismissDarkHUD];
                if (ret<0) {
                    [[DPToast makeText:[self errorString:ret]]show];
                    return ;
                }
                [[DPToast makeText:@"提款密码修改成功"] show];
                [self clearAllTextFieldText];
                
            }
                break;
            case ACCOUNT_SET_DRAWPWD:
            {
                [self dismissDarkHUD];
                if (ret<0) {
                    [[DPToast makeText:[self errorString:ret]]show];
                    return ;
                }
                [[DPToast makeText:@"提款密码设置成功"] show];
                _renzheng[2]=YES;
                [self clearAllTextFieldText];
                [self.tableView reloadData];
                
            }
                break;
            default:
                break;
        }
        
    });
}
-(void)clearAllTextFieldText{
 DPSecurityCell *cell=(DPSecurityCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.passTextFieldMoneyNew.text=@"";
     cell.passTextfieldMoneyOld.text=@"";
     cell.passTextFieldMoneySure.text=@"";
     cell.passTextFieldNew.text=@"";
     cell.passTextfieldOld.text=@"";
     cell.passTextFieldSure.text=@"";

}
- (void)dealloc
{
    
}
- (void)keyboardChanged:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    UIViewAnimationOptions curve = [info[UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        DPLog(@"show");
        self.tableView.scrollEnabled = YES;
        CGRect endFrame =  [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(endFrame), 0);
         self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
//        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
//        [self.tableView scrollRectToVisible:cell.frame animated:YES ];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
               });
//
    }else if(notification.name == UIKeyboardWillHideNotification){
        DPLog(@"hide");
//         self.tableView.contentInset = UIEdgeInsetsZero;
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            self.tableView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            self.tableView.scrollEnabled = NO;
        }];
    }
}
@end
