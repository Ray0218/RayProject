//
//  DPRxninetransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRxninetransferVC.h"
#import "FrameWork.h"
#import "../../Common/View/DPBetToggleControl.h"
#import "DPZcTransferCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPRedPacketViewController.h"
#import "DPTogetherBuySetController.h"
#import "DPAccountViewControllers.h"
#import "BaseMath.h"
#import "DPWebViewController.h"
#import "DPVerifyUtilities.h"
@interface DPRxninetransferVC ()
<UITableViewDelegate, UITableViewDataSource,DPZcTransferCellDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,DPRedPacketViewControllerDelegate>
{
@private
    UITableView *_tableView;
    UIView *_configView;
    UIView *_submitView;
    UITextField *_multipleField;
    CLotteryZc9*_zc9Instance;
     TTTAttributedLabel *_bottomLabel;
     BOOL _isSelectedPro;//是否选择协议

}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *configView;
@property (nonatomic, strong, readonly) UIView *submitView;
@property (nonatomic, strong, readonly) UITextField *multipleField;
@property (nonatomic, strong, readonly) TTTAttributedLabel *bottomLabel;
@end

@implementation DPRxninetransferVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _zc9Instance = CFrameWork::GetInstance()->GetLotteryZc9();
        
        self.gameType=GameTypeZc9;
        self.title=@"任选九投注";
         _isSelectedPro = YES; // 同意协议
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onBack)];
    
    UIView *contentView = self.view;
    UIView *headerView = [self pvt_createHeaderView];
    
    [contentView addSubview:headerView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.configView];
    [contentView addSubview:self.submitView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.height.equalTo(@50);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.equalTo(self.configView.mas_top);
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
    }];
    
    [self.configView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.bottom.equalTo(self.submitView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.greaterThanOrEqualTo(headerView.mas_bottom).offset(50);
    }];
    
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self pvt_buildConfigLayout];
    [self pvt_buildSubmitLayout];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
}
-(void)viewWillAppear:(BOOL)animated{
    

    [super viewWillAppear:animated];
    [self calculateAllZhushuWithZj:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    _zc9Instance->SetDelegate(self);

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.submitView && obj.firstAttribute == NSLayoutAttributeBottom) {
            
            obj.constant = keyboardY - screenHeight;
            
            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
            [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
            
            *stop = YES;
        }
    }];
}

- (void)pvt_onBack {
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            _zc9Instance->Clear();
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [DPAppParser backToCenterRootViewController:YES] ;
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

- (void)pvt_onTap {
    [self.view endEditing:YES];
}

- (UIView *)pvt_createHeaderView {
    UIView *contentView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view;
    });
    
     UIButton *reselectButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 修改选号方案" forState:UIControlStateNormal];
        [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"reselect.png")] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button.layer setBorderColor:[UIColor colorWithRed:0.75 green:0.73 blue:0.71 alpha:1].CGColor];
         [button addTarget:self action:@selector(pvt_add) forControlEvents:UIControlEventTouchUpInside];
        [button.layer setBorderWidth:1];
        button;
    });
    UIView *lineView = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });
    
    [contentView addSubview:reselectButton];
    [contentView addSubview:lineView];
    
    [reselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(-10);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    
    return contentView;
}

- (void)pvt_buildConfigLayout {
    UIView *topLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    UIView *bottomLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    
    UIView *contentView = self.configView;
    
    [contentView addSubview:topLine];
    [contentView addSubview:bottomLine];
    
    [contentView addSubview:self.multipleField];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.multipleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.width.equalTo(@70);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    
    UILabel *label1=[[UILabel alloc]init];
    label1.text=@"投";
    label1.textColor=[UIColor dp_flatBlackColor];
    label1.font=[UIFont dp_systemFontOfSize:12.0];
    [contentView addSubview:label1];
    UILabel *label2=[[UILabel alloc]init];
    label2.text=@"倍";
    label2.textColor=[UIColor dp_flatBlackColor];
    label2.font=[UIFont dp_systemFontOfSize:12.0];
    [contentView addSubview:label2];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.multipleField.mas_left);
        make.width.equalTo(@20);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.multipleField.mas_right).offset(3);
        make.width.equalTo(@20);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];

}

- (void)pvt_buildSubmitLayout {
    UIButton *groupButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 合买" forState:UIControlStateNormal];
        [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"group.png")] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_togetherBuy) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:15]];
        button;
    });
    UIButton *submitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    
    UIView *contentView = self.submitView;
    
    [contentView addSubview:groupButton];
    [contentView addSubview:submitButton];
    [contentView addSubview:self.bottomLabel];
    [contentView addSubview:confirmView];
    [groupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@90);
        make.left.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupButton.mas_right);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(submitButton).offset(-20);
        make.centerY.equalTo(submitButton);
        make.width.equalTo(@23.5);
        make.height.equalTo(@23);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupButton.mas_right).offset(10);
        make.right.equalTo(contentView).offset(-40);
        make.centerY.equalTo(contentView);
        make.height.equalTo(@40);
    }];
}
- (void)pvt_onSubmit {
    if (_zc9Instance->GetNotes() <= 0) {
        [[DPToast makeText:@"至少选择九场比赛!"] show];
        return;
    }  else if (self.multipleField.text.integerValue < 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    } else if (_zc9Instance -> GetNotes() * 2 * self.multipleField.text.intValue > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    } else if (_isSelectedPro == NO){
        [[DPToast makeText:@"请勾选用户协议"] show];
        return;
    } else {
        [self.view endEditing:YES];
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_zc9Instance) weakJczqInstance = _zc9Instance;
        void(^block)(void) = ^ {
            [weakSelf.view.window showDarkHUD];
            
            weakJczqInstance->SetMultiple(weakSelf.multipleField.text.integerValue);
            weakJczqInstance->SetTogetherType(false);
            
            CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
            CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(weakSelf.gameType, 1, weakJczqInstance->GetNotes() * 2 * [weakSelf.multipleField.text integerValue], 0);
        };
        
        if (CFrameWork::GetInstance()->IsUserLogin()) {
            block();
        } else {
            DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
            viewController.finishBlock = block;
            [self.navigationController pushViewController:viewController animated:YES];
        }

    }

}
-(void)pvt_togetherBuy{
    
    [self.multipleField resignFirstResponder];
    if (_zc9Instance->GetNotes() <= 0) {
        [[DPToast makeText:@"至少选择九场比赛!"] show];
        return;
    }  else if (self.multipleField.text.integerValue < 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    } else if (_zc9Instance -> GetNotes() * 2 * self.multipleField.text.intValue > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    } else if (_isSelectedPro == NO){
        [[DPToast makeText:@"请勾选用户协议"] show];
        return;
    } else {
        [self.view endEditing:YES];
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_zc9Instance) weakJczqInstance = _zc9Instance;
        void(^block)(void) = ^ {
            //            [weakSelf.view.window showDarkHUD];
            
            weakJczqInstance->SetMultiple(weakSelf.multipleField.text.integerValue);
            weakJczqInstance->SetTogetherType(true);
            
            CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
            DPTogetherBuySetController *vc=[[DPTogetherBuySetController alloc]init];
            vc.sum=weakJczqInstance->GetNotes() * 2*[weakSelf.multipleField.text integerValue];
            vc.gameType=weakSelf.gameType;
            [vc refreshResData];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        if (CFrameWork::GetInstance()->IsUserLogin()) {
            block();
        } else {
            DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
            viewController.finishBlock = block;
            [self.navigationController pushViewController:viewController animated:YES];
        }

    }
    
}

-(void)pvt_add{
 [self.navigationController popViewControllerAnimated:YES];
}

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{
    NSString * count=[NSString stringWithFormat:@"%d",_zc9Instance->GetNotes()];
    NSString * money=[NSString stringWithFormat:@"%d",[count integerValue]*[self.multipleField.text integerValue]*2];
   ;
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@注 %@倍 共%@元\n最多可中%d注一等奖", count,self.multipleField.text,money, _zc9Instance->GetMaxWinedNote()]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(count.length+self.multipleField.text.length+5,money.length)];
    [self.bottomLabel setText:hintString1];

}

#pragma mark - getter, setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *contentView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        
        UIImageView *gearView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = dp_SportLotteryImage(@"gear.png");
            imageView;
        });
        UIButton *agreementButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled=YES;
            [button setImage:dp_CommonImage(@"check.png") forState:UIControlStateSelected];
            [button setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            button.tag=1002;
            button.selected=YES;
            [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        UILabel *proLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            NSString *words = @" 我同意《用户合买代购协议》其中条款";
            NSMutableAttributedString *stringM = [[NSMutableAttributedString alloc]initWithString:words];
            NSRange range1 = [words rangeOfString:@"我同意"];
            NSRange range2 = [words rangeOfString:@"《用户合买代购协议》"];
            NSRange range3 = [words rangeOfString:@"其中条款"];
            [stringM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.73 green:0.7 blue:0.65 alpha:1] range:range1];
            [stringM addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range2];
            [stringM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.73 green:0.7 blue:0.65 alpha:1] range:range3];
            [stringM addAttribute:NSFontAttributeName value:[UIFont dp_systemFontOfSize:11] range:NSMakeRange(0, stringM.length)];
            label.attributedText = stringM;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prolabelClick)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            label;
        });

        
        UILabel *redLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithRed:0.98 green:0.5 blue:0.49 alpha:1];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont dp_systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.text = @"您投注的奖金指数有可能在出票时发生变化\n方案奖金以实际出票的奖金为准";
            label;
        });
        
        [contentView addSubview:gearView];
        [contentView addSubview:agreementButton];
        [contentView addSubview:proLabel];
        [contentView addSubview:redLabel];
        
        [gearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
        }];
        [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView).offset(10);
//            make.top.equalTo(gearView.mas_bottom);
            make.centerY.equalTo(contentView);
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(proLabel.mas_left);
//            make.width.equalTo(@20);
//            make.top.equalTo(gearView.mas_bottom);
//            make.height.equalTo(@25);
            make.right.equalTo(proLabel.mas_left);
            make.centerY.equalTo(proLabel);
        }];
        [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.top.equalTo(agreementButton.mas_bottom);
        }];
        
        _tableView.tableFooterView = contentView;
    }
    return _tableView;
}
- (void)prolabelClick
{
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.title = @"合买代购协议";
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];
}
- (void)onBtnClick:(UIButton *)button {
    int index = button.tag - 1000;
    switch (index) {
        case 2: {
            button.selected = !button.selected;
            _isSelectedPro=button.selected;
            
        } break;
        default:
            break;
    }
}
- (UIView *)configView {
    if (_configView == nil) {
        _configView = [[UIView alloc] init];
        _configView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _configView;
}

- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _submitView;
}
-(TTTAttributedLabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[TTTAttributedLabel alloc] init];
        [_bottomLabel setNumberOfLines:2];
        [_bottomLabel setTextColor:[UIColor dp_flatWhiteColor]];
        [_bottomLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_bottomLabel setBackgroundColor:[UIColor clearColor]];
        [_bottomLabel setTextAlignment:NSTextAlignmentLeft];
        [_bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _bottomLabel.userInteractionEnabled=NO;
        
    }
    return _bottomLabel;
}
- (UITextField *)multipleField {
    if (_multipleField == nil) {
        _multipleField = [[UITextField alloc] init];
        _multipleField.borderStyle = UITextBorderStyleNone;
        _multipleField.layer.cornerRadius = 3;
        _multipleField.layer.borderWidth = 0.5;
        _multipleField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
        _multipleField.backgroundColor = [UIColor clearColor];
        _multipleField.font = [UIFont dp_systemFontOfSize:12];
        _multipleField.textColor = [UIColor dp_flatBlackColor];
        _multipleField.delegate=self;
        _multipleField.keyboardType = UIKeyboardTypeNumberPad ;
        _multipleField.textAlignment = NSTextAlignmentCenter;
        _multipleField.text = @"1";
        _multipleField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            line;
        });
    }
    return _multipleField;
}
#pragma mark - tableView's data source and delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count=0;
    for(int i=0;i<self.selectedAry.count;i++){
        if ([[self.selectedAry objectAtIndex:i]integerValue]!=0) {
            count++;
        }
    }
        return count;

    
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *CellIdentifier = @"Cell";
        DPZcTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPZcTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setDelegate:self];
            [cell setGameType:self.gameType];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell buildLayout];
        }
    int count=0;
    for(int i=0;i<self.selectedAry.count;i++){
        if ([[self.selectedAry objectAtIndex:i]intValue]!=0) {
            if (count==indexPath.row) {
                count=i;
                i=self.selectedAry.count;
            }else {
                count++;
            }
        }
       
    }
    
    if ([[self.selectedAry objectAtIndex:count]intValue] == 2) {
        cell.markButton.enabled = NO ;
    }else
        cell.markButton.enabled = YES ;
    
    int spList[3], betOption[3];
        string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime;
        
        _zc9Instance->GetTargetInfo(count, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime);
        _zc9Instance->GetTargetSpList(count, spList);
        _zc9Instance->GetTargetOption(count, betOption);
        
        cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
        cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
        cell.orderNumberLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
        cell.markButton.selected = _zc9Instance->GetMarkResult(count);

    
            cell.middleLabel.text =  @"VS" ;
                for (int i = 0; i < cell.betOption9.count; i++) {
                    DPBetToggleControl *control = cell.betOption9[i];
                    control.oddsText = FloatTextForIntDivHundred(spList[i]);
                    control.selected = betOption[i];
                }
                  return cell;
    }
    
#pragma mark - UIGestureRecognizerDelegate
    
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
        if ([touch.view isKindOfClass:[UIControl class]]) {
            return NO;
        }
        return YES;
    }
#pragma makr - UITextfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int  aString = [newString intValue];
    if (newString.length == 0) {
        textField.text = @"";
        [self calculateAllZhushuWithZj:YES];
        return NO;
    }
    
    if (aString <=0) {
        aString = 1;
    }

    if (textField == self.multipleField) {
        if (newString.intValue > 1000) {
            textField.text = @"1000";
            [self calculateAllZhushuWithZj:YES];
//            [[DPToast makeText:@"倍数最大不能超过1000"]show];
            return NO;
        }
        if (newString.length == 0) {
            textField.text = @"";
            [self calculateAllZhushuWithZj:YES];
            return NO;
        }
        if (newString.intValue <= 0) {
            newString = @"1";
            textField.text = newString;
            [self calculateAllZhushuWithZj:YES];
            return NO;
        }
        newString = [NSString stringWithFormat:@"%d", aString];
        if ([textField.text isEqualToString:newString]) {
            textField.text = nil;   // fix iOS8
        }
        textField.text = newString;
        [self calculateAllZhushuWithZj:YES];
        return NO;
    }
    return YES;
}

#pragma mark - DPBdTransferCellDelegate
- (void)zcTransferCell:(DPZcTransferCell *)cell index:(NSInteger)index selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    int count=0;
    for(int i=0;i<self.selectedAry.count;i++){
        if ([[self.selectedAry objectAtIndex:i]intValue]!=0) {
            if (count==indexPath.row) {
                count=i;
                i=self.selectedAry.count;
            }else {
                count++;
            }
        }
    }
    
    _zc9Instance->SetTargetOption(count, index, selected);
    int Options[3];
    _zc9Instance->GetTargetOption(count, Options) ;
    [self calculateAllZhushuWithZj:YES];
    
    if (CMathHelper::IsZero(Options, sizeof(Options))) {
        cell.markButton.selected = NO ;
        cell.markButton.enabled = NO ;
        _zc9Instance->SetMarkResult(count, NO);

        
        [self.selectedAry replaceObjectAtIndex:count withObject:@"2"] ;
        [self.delegate updateArrayWithIndex:count withSelect:@"0"];
        
        
    }else{
        cell.markButton.enabled = YES ;
        [self.selectedAry replaceObjectAtIndex:count withObject:@"1"] ;
        [self.delegate updateArrayWithIndex:count withSelect:@"1"];

    }
   
}

- (void)zcTransferCell:(DPZcTransferCell *)cell mark:(BOOL)selected {
   
    int _selectCount = 0 ;
    for (int i=0; i<self.selectedAry.count; i++) {
        if (_zc9Instance->GetMarkResult(i)) {
            _selectCount+=1 ;
        }
    }
    
    if (_selectCount>=8&& selected) {
        [[DPToast makeText:@"最多只能设8个胆"]show];
        cell.markButton.selected = !cell.markButton.selected ;
        return ;
    }

 
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    int count=0;
    for(int i=0;i<self.selectedAry.count;i++){
        if ([[self.selectedAry objectAtIndex:i]intValue]!=0) {
            if (count==indexPath.row) {
                count=i;
                i=self.selectedAry.count;
            }else {
                
                count++;
            }
        }
    }
    
    
    _zc9Instance->SetMarkResult(count, selected);
    
    [self calculateAllZhushuWithZj:YES];
}
    
- (void)deleteZcTransferCell:(DPZcTransferCell *)cell {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        int count=0;
        for(int i=0;i<self.selectedAry.count;i++){
            if ([[self.selectedAry objectAtIndex:i]intValue]!=0) {
                if (count==indexPath.row) {
                    count=i;
                    i=self.selectedAry.count;
                }else {
                    count++;
                }
            }
        }
    [self.selectedAry replaceObjectAtIndex:count withObject:@"0"];
    [self.delegate updateArrayWithIndex:count withSelect:@"0"];
    _zc9Instance->SetTargetOption(count, 0, NO);
    _zc9Instance->SetTargetOption(count, 1, NO);
    _zc9Instance->SetTargetOption(count, 2, NO);
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     [self calculateAllZhushuWithZj:YES];
    
    
    int num=0;
    for(int i=0;i<self.selectedAry.count;i++){
        if ([[self.selectedAry objectAtIndex:i]integerValue]!=0) {
            num++;
        }
    }
    if (num<= 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
  

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
    });
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text integerValue]<=0) {
        textField.text=@"1";
    }
    [self calculateAllZhushuWithZj:YES];
    
}
#pragma mark - Notfiy

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        [self.view.window dismissHUD];
        switch (cmdType) {
            case ACCOUNT_RED_PACKET: {
                if (ret < 0) {
                    [self dismissDarkHUD];
                    [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                    break;
                }
                [self dismissDarkHUD];
                BOOL isRedpacket=NO;
                if (moduleInstance->GetPayRedPacketCount()) {
                   isRedpacket=YES;
                }
                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                viewController.gameTypeText = dp_GameTypeFullName(self.gameType);
                viewController.projectAmount = _zc9Instance->GetNotes() * 2*[self.multipleField.text integerValue];
                viewController.delegate = self;
                viewController.gameType = self.gameType;
                viewController.isredPacket=isRedpacket;
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case GOPLAY: {
                [self.view.window dismissHUD];
                if (ret < 0) {
                    [[DPToast makeText:DPPaymentErrorMsg(ret)] show];
                } else {
                    [self goPayCallback];
                }
            }
                break;
            default:
                break;
        }
    });
}

#pragma mark - DPRedPacketViewControllerDelegate
#pragma mark - DPRedPacketViewControllerDelegate
- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType{
    if (ret >= 0) {
        [self goPayCallback];
    }
}
- (void)goPayCallback {
    int buyType; string token;
    _zc9Instance->GetWebPayment(buyType, token);
    NSString *urlString=kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    kAppDelegate.gotoHomeBuy = YES;
}

@end
