//
//  DPJclqTransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJclqTransferVC.h"
#import "DPJclqTransferCell.h"
#import "FrameWork.h"
#import "DPPassModeView.h"
#import "../../Common/View/DPAgreementLabel.h"
#import "DPRedPacketViewController.h"
#import "DPTogetherBuySetController.h"
#import "DPAccountViewControllers.h"
#import "PassModeDefine.h"
#import "BaseMath.h"
#import "DPWebViewController.h"
#import "DPVerifyUtilities.h"
@interface DPJclqTransferVC () <UITableViewDelegate, UITableViewDataSource, DPPassModeViewDelegate, DPJcLqTransferCellDelegate,DPRedPacketViewControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate> {
@private
    UITableView *_tableView;
    UIView *_configView;
    UIView *_submitView;
    UITextField *_multipleField;
    UIButton *_passModeButton;
    NSMutableSet *_selectedPassModes;
    DPPassModeView *_passModeView;
    CLotteryJclq *_jclqInstance;
    UIView *_coverView;
    BOOL    _isAgreement;
}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *configView;
@property (nonatomic, strong, readonly) UIView *submitView;
@property (nonatomic, strong, readonly) UITextField *multipleField;
@property (nonatomic, strong, readonly) UIButton *passModeButton;
@property (nonatomic, strong, readonly) DPPassModeView *passModeView;

@property (nonatomic, strong) NSMutableArray *selectedIndexs;
@property (nonatomic, strong, readonly) UIView *coverView;
@end

@implementation DPJclqTransferVC
@dynamic tableView;
@dynamic configView;
@dynamic submitView;
@dynamic multipleField;
@dynamic passModeView;
@synthesize bottomLabel = _bottomLabel, bottomBoundLabel = _bottomBoundLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _jclqInstance = CFrameWork::GetInstance()->GetLotteryJclq();
        _selectedPassModes = [NSMutableSet set];
        _jclqInstance->GenSelectedList();
        _isAgreement = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self calculateAllZhushuWithZj:YES];
    _jclqInstance->SetDelegate(self);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    _jclqInstance->SetDelegate(self);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.multipleField resignFirstResponder];
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
   
      [self.coverView setHidden:YES];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

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

    [self pvt_buildConfigLayout];
    [self pvt_buildSubmitLayout];

    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
        tapGestureRecognizer.delegate = self;
        tapGestureRecognizer;
    })];
    
    [self pvt_updateInfo];
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
                [DPAppParser backToCenterRootViewController:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    if (keyboardY != UIScreen.mainScreen.bounds.size.height || self.passModeButton.isSelected) {
        [self pvt_hiddenCoverView:NO];
    } else {
    }
    [self calculateAllZhushuWithZj:YES];
    
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
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button.layer setBorderColor:[UIColor colorWithRed:0.75 green:0.73 blue:0.71 alpha:1].CGColor];
        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.Tag=1000;
        button;
    });

    UIButton *reselectButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 重新选择" forState:UIControlStateNormal];
        [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"reselect.png")] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button.layer setBorderColor:[UIColor colorWithRed:0.75 green:0.73 blue:0.71 alpha:1].CGColor];
        [button.layer setBorderWidth:1];
        button.tag=1001;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        make.top.equalTo(contentView).offset(9);
        make.bottom.equalTo(contentView).offset(-9);
    }];
    [reselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX).offset(-1);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(9);
        make.bottom.equalTo(contentView).offset(-9);
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
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"投";
    label1.textColor = [UIColor dp_flatBlackColor];
    label1.font = [UIFont dp_systemFontOfSize:12.0];
    [contentView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"倍";
    label2.textColor = [UIColor dp_flatBlackColor];
    label2.font = [UIFont dp_systemFontOfSize:12.0];
    [contentView addSubview:label2];

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
        make.width.equalTo(@70);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];

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
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];

    UIView *contentView = self.submitView;

    [contentView addSubview:groupButton];
    [contentView addSubview:submitButton];
    [contentView addSubview:self.bottomLabel];
    [contentView addSubview:self.bottomBoundLabel];
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
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView.mas_centerY);
    }];

    [self.bottomBoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupButton.mas_right).offset(10);
        make.right.equalTo(contentView).offset(-40);
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
}

- (void)pvt_onPassMode {
    int count = _jclqInstance->GetSelectedCount();
    if (self.gameType == GameTypeLcSfc) {
        if (count < 1) {
            [[DPToast makeText:@"至少选择1场比赛"] show];
            return;
        }
    } else {
        if (count < 2) {
            [[DPToast makeText:@"至少选择2场比赛"] show];
            return;
        }
    }
    
    self.passModeButton.selected = !self.passModeButton.isSelected;
    if (self.passModeButton.selected) {
        vector<int> freedoms;
        vector<int> combines;
        vector<int> passMode;
        
        _jclqInstance->GetEnablePassMode(freedoms, combines);
        _jclqInstance->GetPassMode(passMode);
        
        NSMutableArray *freedomArray = [NSMutableArray arrayWithCapacity:freedoms.size()];
        NSMutableArray *combineArray = [NSMutableArray arrayWithCapacity:combines.size()];
        
        for (int i = 0; i < freedoms.size(); i++) {
            [freedomArray addObject:@(freedoms[i])];
        }
        for (int i = 0; i < combines.size(); i++) {
            [combineArray addObject:@(combines[i])];
        }
        
        [_selectedPassModes removeAllObjects];
        for (int i = 0; i < passMode.size(); i++) {
            [_selectedPassModes addObject:@(passMode[i])];
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
    _jclqInstance->GetPassMode(passMode);
    [_selectedPassModes removeAllObjects];
    for (int i = 0; i < passMode.size(); i++) {
        [_selectedPassModes addObject:@(passMode[i])];
    }
    
    [self pvt_updatePassMode];
//    int note = _jclqInstance->GetNotes();
//    int multiple = self.multipleField.text.integerValue;
//    
//    float minBonus = _jclqInstance->GetMinBonus();
//    float maxBonus = _jclqInstance->GetMaxBonus();
//    self.notesLabel.htmlText = [NSString stringWithFormat:@"%d注 %d倍 共<font color=\"#FDFF06\">%d</font>元", note, multiple, note * multiple * 2];
//    self.bonusLabel.htmlText = [NSString stringWithFormat:@"奖金：<font color=\"#FDFF06\">%.2f~%.2f</font>元", minBonus * multiple * 2, maxBonus * multiple * 2];
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
    int betOptionSf[2], betOptionRfsf[2], betOptionSfc[12], betOptionDxf[2];
    _jclqInstance->GetSelectedTargetOption(index, betOptionSf, betOptionRfsf, betOptionSfc, betOptionDxf);
    
    BOOL sf = !CMathHelper::IsZero(betOptionSf, sizeof(betOptionSf));
    BOOL rfsf = !CMathHelper::IsZero(betOptionRfsf, sizeof(betOptionRfsf));
    BOOL sfc = !CMathHelper::IsZero(betOptionSfc, sizeof(betOptionSfc));
    BOOL dxf = !CMathHelper::IsZero(betOptionDxf, sizeof(betOptionDxf));
    
    switch (self.gameType) {
        case GameTypeLcHt:
            return sf || rfsf || sfc || dxf;
        case GameTypeLcSf:
            return sf;
        case GameTypeLcRfsf:
            return rfsf;
        case GameTypeLcDxf:
            return dxf;
        case GameTypeLcSfc:
            return sfc;
        default:
            return NO;
    }
}
- (void)pvt_onAgreement {
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.title = @"合买代购协议";
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];
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
//       DPAgreementLabel *agreeLabel = [DPAgreementLabel purchaseLabelWithTarget:self action:@selector(pvt_onAgreement)];
        
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

- (TTTAttributedLabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[TTTAttributedLabel alloc] init];
        [_bottomLabel setNumberOfLines:1];
        [_bottomLabel setTextColor:[UIColor dp_flatWhiteColor]];
        [_bottomLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_bottomLabel setBackgroundColor:[UIColor clearColor]];
        [_bottomLabel setTextAlignment:NSTextAlignmentLeft];
        [_bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _bottomLabel.userInteractionEnabled=NO;
    }
    return _bottomLabel;
}
- (TTTAttributedLabel *)bottomBoundLabel {
    if (_bottomBoundLabel == nil) {
        _bottomBoundLabel = [[TTTAttributedLabel alloc] init];
        [_bottomBoundLabel setNumberOfLines:1];
        [_bottomBoundLabel setTextColor:[UIColor dp_flatWhiteColor]];
        [_bottomBoundLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_bottomBoundLabel setBackgroundColor:[UIColor clearColor]];
        [_bottomBoundLabel setTextAlignment:NSTextAlignmentLeft];
        [_bottomBoundLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _bottomBoundLabel.userInteractionEnabled=NO;
    }
    return _bottomBoundLabel;
}
- (UIView *)configView {
    if (_configView == nil) {
        _configView = [[UIView alloc] init];
        _configView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _configView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}
- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _submitView;
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
        _multipleField.keyboardType = UIKeyboardTypeNumberPad ;
        _multipleField.textAlignment = NSTextAlignmentCenter;
        _multipleField.text = @"1";
        _multipleField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            
            line;
        });
        _multipleField.delegate = self;

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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.passModeView]) {
        return NO;
    }
    return YES;
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
    return _jclqInstance->GetSelectedTargetCount();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DPJcLqTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJcLqTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];

        switch (self.gameType) {
            case GameTypeLcHt:
            case GameTypeLcSfc:
                [cell loadDragView];
                break;
            default:
                [cell loadRfDragView];
                break;
        }
    }

    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    int rf, zf;
    int spsf[2], sprqsf[2], spsfc[12], spdxf[2];
    int chksf[2], chkrqsf[2], chksfc[12], chkdxf[2];
    _jclqInstance->GetSelectedTargetInfo(indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rf, zf);
    _jclqInstance->GetSelectedTargetSpList(indexPath.row, spsf, sprqsf, spsfc, spdxf);
    _jclqInstance->GetSelectedTargetOption(indexPath.row, chksf, chkrqsf, chksfc, chkdxf);

    cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
    cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
//    cell.middleLabel.text = @"VS";
    cell.orderNumberLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.markButton.selected = _jclqInstance->GetMarkResult(indexPath.row);
    cell.middleLabel.text = @"VS";
    cell.middleLabel.textColor = [UIColor colorWithRed:0.79 green:0.74 blue:0.62 alpha:1];

    switch (self.gameType) {
        case GameTypeLcHt: {

            NSMutableArray *items = [NSMutableArray array];

            for (int i = 0; i < 2; i++) {
                if (chksf[i]) {
                    [items addObject:dp_TransferOptionNameLcSf[i]];
                }
            }
            for (int i = 0; i < 2; i++) {
                if (chkrqsf[i]) {
                    [items addObject:dp_TransferOptionNameLcRqsf[i]];
                }
            }
            for (int i = 0; i < 12; i++) {
                if (chksfc[i]) {
                    [items addObject:dp_TransferOptionNameLcSfc[i]];
                }
            }
            for (int i = 0; i < 2; i++) {
                if (chkdxf[i]) {
                    [items addObject:dp_TransferOptionNameLcDxf[i]];
                }
            }

            NSString *text = [items componentsJoinedByString:@"  "];

            cell.contentLabel.text = text;
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        case GameTypeLcSfc: {
                       NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 12; i++) {
                if (chksfc[i]) {
                    [items addObject:dp_TransferOptionNameLcSfc[i]];
                }
                NSString *text = [items componentsJoinedByString:@"  "];

                cell.contentLabel.text = text;
                cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
            }
        } break;
        case GameTypeLcSf:
            
            [cell.jclqtleftBtn setTitle:[NSString stringWithFormat:@"主负 %@", FloatTextForIntDivHundred(spsf[0])] forState:UIControlStateNormal];
            [cell.jclqtRightBtn setTitle:[NSString stringWithFormat:@"主胜 %@", FloatTextForIntDivHundred(spsf[1])] forState:UIControlStateNormal];
            if (chksf[0]) {
                cell.jclqtleftBtn.selected = YES;
            }else{
                cell.jclqtleftBtn.selected = NO ;
            }
            if (chksf[1]) {
                cell.jclqtRightBtn.selected = YES;
            }else{
                cell.jclqtRightBtn.selected = NO ;
            }
            
            if (CMathHelper::IsZero(chksf, sizeof(chksf))) {
                cell.markButton.enabled = NO ;
            }else
                cell.markButton.enabled = YES ;
            
            break;
        case GameTypeLcRfsf:
            cell.middleLabel.text = [NSString stringWithFormat:@"%+.1f",rf/10.0];
            if (rf>=0) {
                cell.middleLabel.textColor = [UIColor dp_flatRedColor];
            }else{
                cell.middleLabel.textColor = [UIColor dp_flatBlueColor];
            }

            [cell.jclqtleftBtn setTitle:[NSString stringWithFormat:@"主负 %@", FloatTextForIntDivHundred(sprqsf[0])] forState:UIControlStateNormal];
            [cell.jclqtRightBtn setTitle:[NSString stringWithFormat:@"主胜 %@", FloatTextForIntDivHundred(sprqsf[1])] forState:UIControlStateNormal];
            if (chkrqsf[0]) {
                cell.jclqtleftBtn.selected = YES;
            }else{
                cell.jclqtleftBtn.selected = NO ;
            }
                
            if (chkrqsf[1]) {
                cell.jclqtRightBtn.selected = YES;
            }else{
                cell.jclqtRightBtn.selected = NO ;
            }
            
            if (CMathHelper::IsZero(chkrqsf, sizeof(chkrqsf))) {
                cell.markButton.enabled = NO ;
            }else
                cell.markButton.enabled = YES ;
            break;
        case GameTypeLcDxf:
            cell.middleLabel.text = [NSString stringWithFormat:@"%.1f",zf/10.0];
            cell.middleLabel.textColor = [UIColor dp_flatRedColor];
           
            [cell.jclqtleftBtn setTitle:[NSString stringWithFormat:@"大分 %@", FloatTextForIntDivHundred(spdxf[0])] forState:UIControlStateNormal];
            [cell.jclqtRightBtn setTitle:[NSString stringWithFormat:@"小分 %@", FloatTextForIntDivHundred(spdxf[1])] forState:UIControlStateNormal];
            if (chkdxf[0]) {
                cell.jclqtleftBtn.selected = YES;
            }else{
                cell.jclqtleftBtn.selected = NO ;
            }
            if (chkdxf[1]) {
                cell.jclqtRightBtn.selected = YES;
            }else{
                cell.jclqtRightBtn.selected  = NO ;
            }
            
            
            if (CMathHelper::IsZero(chkdxf, sizeof(chkdxf))) {
                cell.markButton.enabled = NO ;
            }else
                cell.markButton.enabled = YES ;
            break;
        default:
            break;
    }
    //    cell.contentLabel

    return cell;
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
        if ([newString intValue] > 100000) {
            self.multipleField.text = @"100000";
            return NO;
        }
        if (newString.length == 0) {
            textField.text = @"";
            [self calculateAllZhushuWithZj:YES];
            return NO;
        }
        
        if (newString.intValue <= 0) {
            textField.text = @"1";
            [self calculateAllZhushuWithZj:YES];
            return NO;
        }
    }
     newString = [NSString stringWithFormat:@"%d", aString];
    if ([textField.text isEqualToString:newString]) {
        textField.text = nil;   // fix iOS8
    }
    textField.text = newString;
    [self calculateAllZhushuWithZj:YES];
    return NO;
}
#pragma mark - DPJclqTransferCellDelegate
- (void)jclqTransferCell:(DPJcLqTransferCell *)cell event:(DPJclqTransferCellEvent)event {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    switch (event) {
        case DPJclqTransferCellEventDelete: {
            _jclqInstance->DelSelectedTarget(indexPath.row);
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (_jclqInstance->GetSelectedCount()<=0) {
                
               [ self.navigationController popViewControllerAnimated:YES];
            }
            
        } break;
        case DPJclqTransferCellEventMark: {
            BOOL lastResult = _jclqInstance->GetMarkResult(indexPath.row);
            _jclqInstance->SetMarkResult(indexPath.row, !lastResult);
        }
        default:
            break;
    }
    
    [self calculateAllZhushuWithZj:YES];
    [self pvt_updateInfo];
}

- (void)jclqTranCell:(DPJcLqTransferCell *)cell selectedIndex:(int)selectedIndex isSelected:(int)isSelected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _jclqInstance->SetSelectedTargetOption(indexPath.row, self.gameType, selectedIndex, isSelected);
    [self calculateAllZhushuWithZj:YES];
    [self pvt_updateInfo];
    
    if (![self pvt_selectedAtIndex:indexPath.row]) {
        cell.markButton.selected = NO;
        cell.markButton.enabled = NO;
    } else {
        cell.markButton.enabled = YES;
    }
}

- (BOOL)shouldMarkJclqTransferCell:(DPJcLqTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (_jclqInstance->GetMarkResult(indexPath.row)) {
        return YES;
    }
    if (![self pvt_selectedAtIndex:indexPath.row]) {
        return NO;
    }
    
    int count = _jclqInstance->GetSelectedCount();
    int mark = 0;
    for (int i = 0; i < count; i++) {
        mark += _jclqInstance->GetMarkResult(i) ? 1 : 0;
    }
    vector<int> freedoms, combines;
    _jclqInstance->GetEnablePassMode(freedoms, combines);
    int maxMark = MAX(freedoms.size() ? GetPassModeNamePrefix(freedoms.back()) : 0, combines.size() ? GetPassModeNamePrefix(combines.back()) : 0);
    if (mark >= maxMark) {
        [[DPToast makeText:[NSString stringWithFormat:@"最多设置%d个胆", maxMark]] show];
        return NO;
    }
    
    return YES;
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

    NSArray *objects = _selectedPassModes.allObjects;
    int passModes[100] = {0};
    for (int i = 0; i < objects.count; i++) {
        passModes[i] = [objects[i] integerValue];
    }

    _jclqInstance->SetPassMode(passModes, objects.count);
    
    [self calculateAllZhushuWithZj:YES];
    [self pvt_updateInfo];
}

- (BOOL)passModeView:(DPPassModeView *)passModeView isSelectedModel:(NSInteger)passModeTag {
    return [_selectedPassModes containsObject:@(passModeTag)];
}

- (void)pvt_onSubmit {
    if (self.gameType == GameTypeLcSfc && _jclqInstance->GetSelectedCount() < 1) {
        [[DPToast makeText:@"至少选择1注比赛!"] show];
        return;
    } else if (self.gameType != GameTypeLcSfc && _jclqInstance->GetSelectedCount() < 2) {
        [[DPToast makeText:@"至少选择2注比赛!"] show];
        return;
    } else if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    } else if (self.multipleField.text.integerValue < 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    } else if (_jclqInstance -> GetNotes() * 2 * [self.multipleField.text intValue] > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    }else if (_isAgreement == NO){
        [[DPToast makeText:@"请勾选用户协议"] show];
        return;
    }else{
        
        [self.view endEditing:YES];
        if (self.passModeButton.selected) {
            [self.passModeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_jclqInstance) weakJczqInstance = _jclqInstance;
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
    if (self.gameType == GameTypeLcSfc && _jclqInstance->GetSelectedCount() < 1) {
        [[DPToast makeText:@"至少选择1注比赛!"] show];
        return;
    } else if (self.gameType != GameTypeLcSfc && _jclqInstance->GetSelectedCount() < 2) {
        [[DPToast makeText:@"至少选择2注比赛!"] show];
        return;
    } else if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    } else if (self.multipleField.text.integerValue < 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    } else if ([self.multipleField.text intValue] * 2 * _jclqInstance -> GetNotes() > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    } else if (_isAgreement == NO){
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }else {
        [self.view endEditing:YES];
        if (self.passModeButton.selected) {
            [self.passModeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_jclqInstance) weakJczqInstance = _jclqInstance;
        void(^block)(void) = ^ {
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

- (void)buttonClick:(UIButton *)button {
    int index = button.tag - 1000;
    switch (index) {
        case 0: {
            [self.navigationController popViewControllerAnimated:YES];
        } break;
        case 1: {
            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    _jclqInstance->CleanupAllOptions();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
    });
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField.text integerValue] <= 0) {
        textField.text = @"1";
    }
    [self calculateAllZhushuWithZj:YES];
    return YES;
}
 
//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addrNot
{

    int note = _jclqInstance->GetNotes();
    int multiple = [self.multipleField.text integerValue];
    float minBonus = _jclqInstance->GetMinBonus();
    float maxBonus = _jclqInstance->GetMaxBonus();
    
    NSString *count = [NSString stringWithFormat:@"%d", note];
    NSString *maxBound = maxBonus * multiple * 2>=0? [NSString stringWithFormat:@"%.2f", maxBonus * multiple * 2] :@"?";
    NSString *minBound = minBonus * multiple * 2>=0?[NSString stringWithFormat:@"%.2f", minBonus * multiple * 2]:@"?";
    NSString *money = [NSString stringWithFormat:@"%d", note * multiple * 2];
    
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@注 %@倍 共%@元", count, self.multipleField.text, money]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, count.length + self.multipleField.text.length + 5)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(count.length + self.multipleField.text.length + 5, money.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(hintString1.length - 1, 1)];
    [self.bottomLabel setText:hintString1];
    
    NSMutableAttributedString *hintString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖金: %@-%@元", minBound, maxBound]];
    [hintString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, 3)];
    [hintString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(3, maxBound.length + minBound.length + 2)];
    [hintString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(hintString2.length - 1, 1)];
    [self.bottomBoundLabel setText:hintString2];

}
#pragma mark - Notfiy

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window dismissHUD];
        
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
                viewController.projectAmount = _jclqInstance->GetNotes() * self.multipleField.text.integerValue * 2;
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
    _jclqInstance->GetWebPayment(buyType, token);
    NSString *urlString=kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    kAppDelegate.gotoHomeBuy = YES;
    
}

@end
