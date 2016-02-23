//
//  DPBdTransferViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBdTransferViewController.h"
#import "FrameWork.h"
#import "DPPassModeView.h"
#import "DPBdTransferCell.h"
#import "../../Common/View/DPBetToggleControl.h"
#import "../../Common/View/DPAgreementLabel.h"
#import <MDHTMLLabel/MDHTMLLabel.h>
#import "DPToast.h"
#import "DPRedPacketViewController.h"
#import "DPTogetherBuySetController.h"
#import "DPAccountViewControllers.h"
#import "PassModeDefine.h"
#import "BaseMath.h"
#import "DPWebViewController.h"
#import "DPVerifyUtilities.h"
static NSString *const ConfigViewFrameKeyPath = @"frame";

@interface DPBdTransferViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    DPPassModeViewDelegate,
    DPBdTransferCellDelegate,
    UIGestureRecognizerDelegate,
    ModuleNotify,
    DPRedPacketViewControllerDelegate,
    UITextFieldDelegate
> {
@private
    UITableView *_tableView;
    UIView *_configView;
    UIView *_submitView;
    MDHTMLLabel *_bonusLabel;
    MDHTMLLabel *_notesLabel;
    UITextField *_multipleField;
    UIButton *_passModeButton;
    NSMutableSet *_selectedPassModes;
    DPPassModeView *_passModeView;
    UIView *_coverView;
    BOOL    _isAgreement;
    CLotteryBd *_bdInstance;
}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *configView;
@property (nonatomic, strong, readonly) UIView *submitView;
@property (nonatomic, strong, readonly) MDHTMLLabel *bonusLabel;
@property (nonatomic, strong, readonly) MDHTMLLabel *notesLabel;
@property (nonatomic, strong, readonly) UITextField *multipleField;
@property (nonatomic, strong, readonly) UIButton *passModeButton;
@property (nonatomic, strong, readonly) DPPassModeView *passModeView;
@property (nonatomic, strong, readonly) UIView *coverView;

@end

@implementation DPBdTransferViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bdInstance = CFrameWork::GetInstance()->GetLotteryBd();
        _bdInstance->GenSelectedList();
        _selectedPassModes = [NSMutableSet set];
        _isAgreement = YES;
        [self pvt_updateInfo];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _bdInstance->SetDelegate(self);;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onBack)];
    
    UIView *contentView = self.view;
    UIView *headerView = [self pvt_createHeaderView];
    
    [contentView addSubview:headerView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.coverView];
    [contentView addSubview:self.configView];
    [contentView addSubview:self.passModeView];
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
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.configView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.bottom.equalTo(self.passModeView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.greaterThanOrEqualTo(headerView.mas_bottom).offset(50);
    }];
    [self.passModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.submitView.mas_top);
        make.height.equalTo(@0).priorityLow();
    }];
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    
    [self.coverView setHidden:YES];
    [self pvt_buildConfigLayout];
    [self pvt_buildSubmitLayout];
    
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
        tapRecognizer.delegate = self;
        tapRecognizer;
    })];
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
            
            if (keyboardY != UIScreen.mainScreen.bounds.size.height && self.passModeButton.selected) {
                self.passModeButton.selected = NO;
                [self pvt_adaptPassModeHeight];
            }
            
            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
            [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
            
            *stop = YES;
        }
    }];
    
    if (keyboardY != UIScreen.mainScreen.bounds.size.height || self.passModeButton.isSelected) {
        [self pvt_hiddenCoverView:NO];
    } else {
        
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

- (void)pvt_onBack {
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [DPAppParser backToCenterRootViewController:YES] ;
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

- (void)pvt_onTap {
    if (self.multipleField.isEditing) {
        [self.multipleField resignFirstResponder];
    }
    if (self.passModeButton.isSelected) {
        self.passModeButton.selected = NO;
        
        [self pvt_adaptPassModeHeight];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    [self pvt_hiddenCoverView:YES];
}

- (UIView *)pvt_createHeaderView {
    UIView *contentView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view;
    });
    
    UIButton *addButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 添加/编辑赛事" forState:UIControlStateNormal];
        [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"add.png")] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onModify) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button.layer setBorderColor:[UIColor colorWithRed:0.75 green:0.73 blue:0.71 alpha:1].CGColor];
        [button.layer setBorderWidth:1];
        button;
    });
    UIButton *reselectButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 重新选择" forState:UIControlStateNormal];
        [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"reselect.png")] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onReset) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button.layer setBorderColor:[UIColor colorWithRed:0.75 green:0.73 blue:0.71 alpha:1].CGColor];
        [button.layer setBorderWidth:1];
        button;
    });
    UIView *lineView = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });
    
    [contentView addSubview:addButton];
    [contentView addSubview:reselectButton];
    [contentView addSubview:lineView];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView.mas_centerX);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(-10);
    }];
    [reselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX).offset(-1);
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
    
    [contentView addSubview:self.passModeButton];
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
    [self.passModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
        make.width.equalTo(@85);
        make.left.equalTo(contentView).offset(5);
    }];
    [self.multipleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.width.equalTo(@60);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    
    UILabel *left = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"投";
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    UILabel *right = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"倍";
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    [contentView addSubview:left];
    [contentView addSubview:right];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.right.equalTo(self.multipleField.mas_left).offset(-2);
    }];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.left.equalTo(self.multipleField.mas_right).offset(2);
    }];
}

- (void)pvt_buildSubmitLayout {
    UIButton *groupButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 合买" forState:UIControlStateNormal];
        [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"group.png")] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_togetherBuy) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:15]];
        button;
    });
    UIButton *submitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIImageView *tickView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"sumit001_24.png")];
        imageView;
    });
    
    UIView *contentView = self.submitView;
    
    [contentView addSubview:groupButton];
    [contentView addSubview:submitButton];
    [contentView addSubview:self.notesLabel];
    [contentView addSubview:self.bonusLabel];
    [contentView addSubview:tickView];
    
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
    [self.notesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(submitButton).offset(15);
        make.bottom.equalTo(submitButton.mas_centerY);
    }];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(submitButton).offset(15);
        make.top.equalTo(submitButton.mas_centerY);
    }];
    [tickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(submitButton);
        make.right.equalTo(submitButton.mas_right).offset(-15);
    }];
    
    [self pvt_updateInfo];
}

- (void)pvt_onAgreement {
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.title = @"合买代购协议";
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];

}

- (void)pvt_onSubmit {
    [self pvt_onTap];
    if (_isAgreement == NO) {
        [[DPToast makeText:@"请勾选用户协议"] show];
        return;
    }
    if (self.gameType == GameTypeBdBf && _bdInstance->GetSelectedCount() <= 0) {
        [[DPToast makeText:@"至少选择1场比赛!"] show];
        return;
    } else if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    } else if (self.multipleField.text.integerValue < 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    }else if (_bdInstance -> GetNotes() * 2 * [self.multipleField.text intValue] > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    }else {
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_bdInstance) weakBdInstance = _bdInstance;
        void(^block)(void) = ^() {
            [weakSelf.view.window showDarkHUD];
            
            weakBdInstance->SetMultiple(weakSelf.multipleField.text.integerValue);
            weakBdInstance->SetTogetherType(false);
            
            CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
            CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(weakSelf.gameType, 1, _bdInstance->GetNotes() * 2 * [weakSelf.multipleField.text integerValue], 0);
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
    [self pvt_onTap];
    if (_isAgreement == NO) {
        [[DPToast makeText:@"请勾选用户协议"] show];
        return;
    }
    if (self.gameType == GameTypeBdBf && _bdInstance->GetSelectedCount() <= 0) {
        [[DPToast makeText:@"至少选择1场比赛!"] show];
        return;
    } else if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    } else if (self.multipleField.text.integerValue < 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    }else if (_bdInstance ->GetNotes() * 2 * [self.multipleField.text intValue] > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    }else {
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_bdInstance) weakBdInstance = _bdInstance;
        void(^block)(void) = ^ {
            weakBdInstance->SetMultiple(weakSelf.multipleField.text.integerValue);
            weakBdInstance->SetTogetherType(true);
            
            CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
            DPTogetherBuySetController *vc = [[DPTogetherBuySetController alloc]init];
            vc.sum = weakBdInstance->GetNotes() * 2 * [weakSelf.multipleField.text integerValue];
            vc.gameType = weakSelf.gameType;
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

- (void)pvt_onPassMode {
    if (_bdInstance->GetSelectedCount() <= 0) {
        [[DPToast makeText:@"至少选择1场比赛"] show];
        return;
    }
    
    self.passModeButton.selected = !self.passModeButton.isSelected;
    
    if (self.passModeButton.isSelected) {
        vector<int> freedoms;
        vector<int> combines;
        
        _bdInstance->GetEnablePassMode(freedoms, combines);
        
        NSMutableArray *freedomArray = [NSMutableArray arrayWithCapacity:freedoms.size()];
        NSMutableArray *combineArray = [NSMutableArray arrayWithCapacity:combines.size()];
        
        for (int i = 0; i < freedoms.size(); i++) {
            [freedomArray addObject:@(freedoms[i])];
        }
        for (int i = 0; i < combines.size(); i++) {
            [combineArray addObject:@(combines[i])];
        }
        
        self.passModeView.freedoms = freedomArray;
        self.passModeView.combines = combineArray;
        
        [self.passModeView reloadData];
        
        if (self.multipleField.isEditing) {
            [self.multipleField resignFirstResponder];
        }
    }
    
    [self.passModeView layoutIfNeeded];
    [self pvt_adaptPassModeHeight];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    if (self.passModeButton.isSelected) {
        [self pvt_hiddenCoverView:NO];
    } else {
        [self pvt_hiddenCoverView:YES];
    }
}

- (void)pvt_onModify {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pvt_onReset {
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            CFrameWork::GetInstance()->GetLotteryBd()->CleanupAllOptions();
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)pvt_adaptPassModeHeight {
    [self.passModeView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.passModeView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = self.passModeButton.selected ? self.passModeView.contentSize.height + 20 : 0;
            *stop = YES;
        }
    }];
}

- (void)pvt_updateInfo {
    vector<int> passMode;
    _bdInstance->GetPassMode(passMode);
    [_selectedPassModes removeAllObjects];
    for (int i = 0; i < passMode.size(); i++) {
        [_selectedPassModes addObject:@(passMode[i])];
    }
    
    int note = _bdInstance->GetNotes();
    int multiple = self.multipleField.text.integerValue;
    
    float minBonus = _bdInstance->GetMinBonus();
    float maxBonus = _bdInstance->GetMaxBonus();
    
    self.notesLabel.htmlText = [NSString stringWithFormat:@"%d注 %d倍 共<font color=\"#FDFF06\">%d</font>元", note, multiple, note * multiple * 2];
    
    NSString * minBonusStr = minBonus * multiple * 1.3>=0?[NSString stringWithFormat:@"%.2f", minBonus * multiple * 1.3] :@"?" ;
    NSString * maxBonusStr =  maxBonus * multiple * 1.3>=0?[NSString stringWithFormat:@"%.2f", maxBonus * multiple * 1.3] :@"?" ;
    
    self.bonusLabel.htmlText = [NSString stringWithFormat:@"奖金：<font color=\"#FDFF06\">%@~%@</font>元", minBonusStr, maxBonusStr];
    
    [self pvt_updatePassMode];
}

- (void)pvt_updatePassMode {
    if (_selectedPassModes.count == 0) {
        [self.passModeButton setTitle:@"过关方式" forState:UIControlStateNormal];
        [self.passModeButton setTitle:@"过关方式" forState:UIControlStateSelected];
        [self.passModeButton setTitleColor:[UIColor colorWithRed:0.55 green:0.49 blue:0.43 alpha:1] forState:UIControlStateNormal];
        [self.passModeButton setTitleColor:[UIColor colorWithRed:0.55 green:0.49 blue:0.43 alpha:1] forState:UIControlStateSelected];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"white_bg.png") forState:UIControlStateNormal];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"white_bg.png") forState:UIControlStateSelected];
        
        [self.passModeButton setImage:dp_SportLotteryImage(@"pass_up@2x.png") forState:UIControlStateNormal];
        [self.passModeButton setImage:dp_SportLotteryImage(@"pass_down@2x.png") forState:UIControlStateSelected];
        
    } else {
        NSArray *passModes = [[_selectedPassModes allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            int pre = GetPassModeNameSuffix(obj1.integerValue);
            int nxt = GetPassModeNameSuffix(obj2.integerValue);
            if ((pre >  1 && nxt >  1 && obj1.integerValue > obj2.integerValue) ||
                (pre == 1 && nxt == 1 && obj1.integerValue > obj2.integerValue) ||
                (pre >  1 && nxt == 1)) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        
        NSMutableArray *passModeTitles = [NSMutableArray arrayWithCapacity:_selectedPassModes.count];
        for (int i = 0; i < passModes.count; i++) {
            int passModeTag = [passModes[i] intValue];
            if (passModeTag == PASSMODE_1_1) {
                [passModeTitles addObject:@"单关"];
            } else {
                [passModeTitles addObject:[NSString stringWithFormat:@"%d串%d", GetPassModeNamePrefix(passModeTag), GetPassModeNameSuffix(passModeTag)]];
            }
        }
        NSString *title = [passModeTitles componentsJoinedByString:@", "];
        
        [self.passModeButton setTitle:title forState:UIControlStateNormal];
        [self.passModeButton setTitle:title forState:UIControlStateSelected];
        [self.passModeButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [self.passModeButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"red_bg.png") forState:UIControlStateNormal];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"red_bg.png") forState:UIControlStateSelected];
        
        [self.passModeButton setImage:dp_SportLotteryImage(@"arrow_up@2x.png") forState:UIControlStateNormal];
        [self.passModeButton setImage:dp_SportLotteryImage(@"arrow_down@2x.png") forState:UIControlStateSelected];
    }
}

- (BOOL)pvt_selectedAtIndex:(NSInteger)index {
    int betOption[25] = { 0 };
    _bdInstance->GetSelectedTargetOption(index, betOption);
    
    return !CMathHelper::IsZero(betOption, sizeof(betOption));
}
- (void)pvt_agreementBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isAgreement = sender.selected;
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
        
        UILabel *agreeLabel = ({
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_onAgreement)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            label;
        });

        
//        MDHTMLLabel *agreeLabel = [[MDHTMLLabel alloc]init];
//        agreeLabel.htmlText = [NSString stringWithFormat:@"<font color=\"#FA807F\">%@</font> <font color=\"#0000FF\">%@</font> <font color=\"#FA807F\">%@</font>", @"我同意",@"《用户合买代购协议》",@"其中条款"];
//        agreeLabel.font = [UIFont dp_systemFontOfSize:11];
//        agreeLabel.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_onAgreement)];
//        [agreeLabel addGestureRecognizer:tap];
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
        
        UIButton *agreementButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled=YES;
            [button setImage:dp_CommonImage(@"check.png") forState:UIControlStateSelected];
            [button setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
//            button.tag=1002;
            button.selected=YES;
            [button addTarget:self action:@selector(pvt_agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        [contentView addSubview:gearView];
        [contentView addSubview:agreeLabel];
        [contentView addSubview:redLabel];
        [contentView addSubview:agreementButton];
        
        [gearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
        }];
        [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gearView.mas_bottom).offset(5);
            make.centerX.equalTo(contentView).offset(5);
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(agreeLabel);
            make.right.equalTo(agreeLabel.mas_left).offset(- 2);
        }];
        [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.top.equalTo(agreeLabel.mas_bottom).offset(2);
        }];
        
        _tableView.tableFooterView = contentView;
    }
    return _tableView;
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

- (MDHTMLLabel *)bonusLabel {
    if (_bonusLabel == nil) {
        _bonusLabel = [[MDHTMLLabel alloc] init];
        _bonusLabel.font = [UIFont dp_systemFontOfSize:11];
        _bonusLabel.backgroundColor = [UIColor clearColor];
        _bonusLabel.textColor = [UIColor dp_flatWhiteColor];
        _bonusLabel.userInteractionEnabled = NO;
    }
    return _bonusLabel;
}

- (MDHTMLLabel *)notesLabel {
    if (_notesLabel == nil) {
        _notesLabel = [[MDHTMLLabel alloc] init];
        _notesLabel.font = [UIFont dp_systemFontOfSize:11];
        _notesLabel.backgroundColor = [UIColor clearColor];
        _notesLabel.textColor = [UIColor dp_flatWhiteColor];
        _notesLabel.userInteractionEnabled = NO;
    }
    return _notesLabel;
}

- (UITextField *)multipleField {
    if (_multipleField == nil) {
        _multipleField = [[UITextField alloc] init];
        _multipleField.borderStyle = UITextBorderStyleNone;
        _multipleField.backgroundColor = [UIColor clearColor];
        _multipleField.font = [UIFont dp_systemFontOfSize:12];
        _multipleField.textColor = [UIColor dp_flatBlackColor];
        _multipleField.textAlignment = NSTextAlignmentCenter;
        _multipleField.text = @"1";
        _multipleField.delegate = self;
        _multipleField.keyboardType = UIKeyboardTypeNumberPad;
        _multipleField.inputAccessoryView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            view.backgroundColor = [UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1];
            view;
        });
        _multipleField.layer.cornerRadius = 3;
        _multipleField.layer.borderWidth = 0.5;
        _multipleField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
    }
    return _multipleField;
}

- (UIButton *)passModeButton {
    if (_passModeButton == nil) {
        _passModeButton = [[UIButton alloc] init];
        [_passModeButton.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [_passModeButton setImage:dp_SportLotteryImage(@"arrow_up.png") forState:UIControlStateNormal];
        [_passModeButton setImage:dp_SportLotteryImage(@"arrow_down.png") forState:UIControlStateSelected];
        [_passModeButton addTarget:self action:@selector(pvt_onPassMode) forControlEvents:UIControlEventTouchUpInside];
        [_passModeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
        [_passModeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 20)];
        [_passModeButton setAdjustsImageWhenHighlighted:NO];
        [_passModeButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return _passModeButton;
}

- (DPPassModeView *)passModeView {
    if (_passModeView == nil) {
        _passModeView = [[DPPassModeView alloc] init];
        _passModeView.passModeDelegate = self;
    }
    return _passModeView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
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
    return _bdInstance->GetSelectedTargetCount();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DPBdTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPBdTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setDelegate:self];
        [cell setGameType:self.gameType];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];
    }
    
    int spList[25], betOption[25], rqs;
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime;
    
    _bdInstance->GetSelectedTargetInfo(indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
    _bdInstance->GetSelectedTargetSpList(indexPath.row, spList);
    _bdInstance->GetSelectedTargetOption(indexPath.row, betOption);
    
    cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
    cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
    cell.orderNumberLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.markButton.selected = _bdInstance->GetMarkResult(indexPath.row);
    
    if (self.gameType == GameTypeBdRqspf) {
        cell.middleLabel.text = rqs == 0 ? @"VS" : [NSString stringWithFormat:@"%@%d", rqs > 0 ? @"+" : @"", rqs];
        cell.middleLabel.textColor = rqs == 0 ? [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1] : (rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor]);
    }
    
//
    switch (self.gameType) {
        case GameTypeBdRqspf: {
            for (int i = 0; i < cell.betOptionSpf.count; i++) {
                DPBetToggleControl *control = cell.betOptionSpf[i];
                control.oddsText = FloatTextForIntDivHundred(spList[i]);
                control.selected = betOption[i];
            }
        }
            break;
        case GameTypeBdSxds: {
            for (int i = 0; i < cell.betOptionSdxs.count; i++) {
                DPBetToggleControl *control = cell.betOptionSdxs[i];
                control.oddsText = FloatTextForIntDivHundred(spList[i]);
                control.selected = betOption[i];
            }
        }
            break;
        case GameTypeBdBf:
        case GameTypeBdZjq:
        case GameTypeBdBqc: {
            NSMutableArray *items = [NSMutableArray array];
            
            switch (self.gameType) {
                case GameTypeBdBf: {
                    static NSString *bfNames[] = {
                        @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"胜其他",
                        @"0:0", @"1:1", @"2:2", @"3:3", @"平其他",
                        @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"负其他",
                    };
                    for (int i = 0; i < 25; i++) {
                        if (betOption[i]) {
                            [items addObject:bfNames[i]];
                        }
                    }
                }
                    break;
                case GameTypeBdZjq: {
                    static NSString *zjqNames[] = {@"0球", @"1球", @"2球", @"3球", @"4球", @"5球", @"6球", @"7+球"};
                    for (int i = 0; i < 8; i++) {
                        if (betOption[i]) {
                            [items addObject:zjqNames[i]];
                        }
                    }
                }
                    break;
                case GameTypeBdBqc: {
                    static NSString *bqcNames[] = {@"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负"};
                    for (int i = 0; i < 9; i++) {
                        if (betOption[i]) {
                            [items addObject:bqcNames[i]];
                        }
                    }
                }
                    break;
                default:
                    break;
            }
            
            NSString *text = [items componentsJoinedByString:@"  "];
            
            cell.contentLabel.text = text;
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.passModeView]) {
        return NO;
    }
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}
#pragma mark - UITextfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int  aString = [newString intValue];
    if (newString.length == 0) {
        textField.text = @"";
        [self pvt_updateInfo];
        return NO;
    }
    
    if (aString <=0) {
        aString = 1;
    }
    if (textField == self.multipleField) {
        if (newString.intValue > 100000) {
            textField.text = @"100000";
            [self pvt_updateInfo];
//            [[DPToast makeText:@"倍数最大不能超过1000"]show];
            return NO;
        }
        if (newString.length == 0) {
            textField.text = @"";
            [self pvt_updateInfo];
            return NO;
        }
        if (newString.intValue <= 0) {
            newString = @"1";
            textField.text = newString;
            [self pvt_updateInfo];
            return NO;
        }
        newString = [NSString stringWithFormat:@"%d", aString];
        if ([textField.text isEqualToString:newString]) {
            textField.text = nil;   // fix iOS8
        }
        textField.text = newString;
        [self pvt_updateInfo];
        return NO;
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
}
#pragma mark - DPBdTransferCellDelegate

- (void)bdTransferCell:(DPBdTransferCell *)cell index:(NSInteger)index selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _bdInstance->SetSelectedTargetOption(indexPath.row, index, selected);
    
    [self pvt_updateInfo];
    
    if (![self pvt_selectedAtIndex:indexPath.row]) {
        cell.markButton.selected = NO;
        cell.markButton.enabled = NO;
    } else {
        cell.markButton.enabled = YES;
    }
}

- (BOOL)shouldMarkBdTransferCell:(DPBdTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (_bdInstance->GetMarkResult(indexPath.row)) {
        return YES;
    }
    if (![self pvt_selectedAtIndex:indexPath.row]) {
        return NO;
    }
    
    int count = _bdInstance->GetSelectedCount();
    int mark = 0;
    for (int i = 0; i < count; i++) {
        mark += _bdInstance->GetMarkResult(i) ? 1 : 0;
    }
    vector<int> freedoms, combines;
    _bdInstance->GetEnablePassMode(freedoms, combines);
    int maxMark = MAX(freedoms.size() ? GetPassModeNamePrefix(freedoms.back()) : 0, combines.size() ? GetPassModeNamePrefix(combines.back()) : 0);
    if (mark >= maxMark) {
        [[DPToast makeText:[NSString stringWithFormat:@"最多设置%d个胆", maxMark]] show];
        return NO;
    }
    
    return YES;
}

- (void)bdTransferCell:(DPBdTransferCell *)cell mark:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    _bdInstance->SetMarkResult(indexPath.row, selected);
    
    [self pvt_updateInfo];
}

- (void)deleteBdTransferCell:(DPBdTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _bdInstance->DelSelectedTarget(indexPath.row);
    
    [self.tableView reloadData];
    
    if (_bdInstance->GetSelectedCount() <= 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
       
    }
    
    [self pvt_updateInfo];
}

#pragma mark - DPPassModeViewDelegate

- (void)passModeView:(DPPassModeView *)passModeView expand:(BOOL)expand {
    [self.passModeView reloadData];
    [self.passModeView layoutIfNeeded];
    [self pvt_adaptPassModeHeight];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)passModeView:(DPPassModeView *)passModeView toggle:(NSInteger)passModeTag {
    [_selectedPassModes dp_turnObject:@(passModeTag)];
    
    int i = 0;
    int passMode[100];
    for (NSNumber *tag in _selectedPassModes) {
        passMode[i++] = tag.integerValue;
    }
    
    _bdInstance->SetPassMode(passMode, i);
    
    [self pvt_updateInfo];
}

- (BOOL)passModeView:(DPPassModeView *)passModeView isSelectedModel:(NSInteger)passModeTag {
    return [_selectedPassModes containsObject:@(passModeTag)];
}

#pragma mark - Notfiy

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        
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
                    viewController.projectAmount = _bdInstance->GetNotes() * 2 *[self.multipleField.text integerValue];
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
- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType {
    if (ret >= 0) {
        [self goPayCallback];
    }
}

- (void)goPayCallback {
    int buyType; string token;
    _bdInstance->GetWebPayment(buyType, token);
    NSString *urlString=kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    kAppDelegate.gotoHomeBuy = YES;
}

@end
