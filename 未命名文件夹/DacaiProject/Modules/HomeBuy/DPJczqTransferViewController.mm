//
//  DPJczqTransferViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJczqTransferViewController.h"
#import "DPJczqTransferCell.h"
#import "FrameWork.h"
#import "DPPassModeView.h"
#import "DPRedPacketViewController.h"
#import "DPTogetherBuySetController.h"
#import "DPAccountViewControllers.h"
#import "DPBetToggleControl.h"
#import "PassModeDefine.h"
#import "BaseMath.h"
#import "DPWebViewController.h"
#import "DPVerifyUtilities.h"
#import "DPJczqOptimizeViewControl.h"
@interface DPJczqTransferViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    DPJczqTransferCellDelegate,
    DPPassModeViewDelegate,
    UIGestureRecognizerDelegate,
    DPRedPacketViewControllerDelegate,
    UITextFieldDelegate
> {
@private
    UITableView *_tableView;
    UIView *_configView;
    UIView *_submitView;
    UITextField *_multipleField;
    UIButton *_passModeButton;
    NSMutableSet *_selectedPassModes;
    DPPassModeView *_passModeView;
    UIView *_coverView;
    CLotteryJczq *_jczqInstance;
    
    BOOL _isSelectedPro;//是否选择协议

}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *configView;
@property (nonatomic, strong, readonly) UIView *submitView;
@property (nonatomic, strong, readonly) UITextField *multipleField;
@property (nonatomic, strong, readonly) UIButton *passModeButton;
@property (nonatomic, strong, readonly) DPPassModeView *passModeView;
@property (nonatomic, strong, readonly) UIView *coverView;
@end

@implementation DPJczqTransferViewController
@dynamic tableView;
@dynamic configView;
@dynamic submitView;
@dynamic multipleField;
@dynamic passModeView;
@synthesize bottomLabel = _bottomLabel, bottomBoundLabel = _bottomBoundLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedPassModes = [NSMutableSet set];
        _jczqInstance = CFrameWork::GetInstance()->GetLotteryJczq();
        _jczqInstance->GenSelectedList();
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onBack)];

    
    _isSelectedPro=YES;

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
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.coverView setHidden:YES];
    [self pvt_buildConfigLayout];
    [self pvt_buildSubmitLayout];
    
    
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
        tapRecognizer.delegate = self;
        tapRecognizer;
    })];
    
    [self pvt_updateInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _jczqInstance->SetDelegate(self);
    _jczqInstance->SetProjectBuyType(1);
    
    [self calculateAllZhushu];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
        [button addTarget:self action:@selector(pvt_onModify) forControlEvents:UIControlEventTouchUpInside];
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
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button addTarget:self action:@selector(pvt_onReset) forControlEvents:UIControlEventTouchUpInside];
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
        make.width.equalTo(@70);
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
    
    UIButton* optimizeBtn = ({
    
        UIButton* btn  = [UIButton buttonWithType:UIButtonTypeSystem];
    
        [btn setTitle:@"  奖金优化  " forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor] ;
        btn.layer.borderWidth = 1 ;
        btn.layer.cornerRadius = 12 ;
        btn.layer.borderColor  = UIColorFromRGB(0x8D7C6E).CGColor ;
        [btn setTitleColor:UIColorFromRGB(0x8D7C6E) forState:UIControlStateNormal];
         [btn addTarget: self action:@selector(pvt_Optimize) forControlEvents:UIControlEventTouchUpInside];
        btn ;
    }) ;
    
    
    [contentView addSubview:left];
    [contentView addSubview:right];
    [contentView addSubview:optimizeBtn];
    
    if (self.gameType == GameTypeJcHt || self.gameType == GameTypeJcRqspf || self.gameType == GameTypeJcSpf) {
        optimizeBtn.hidden = NO ;
    }else{
        optimizeBtn.hidden = YES ;
    }

    
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.right.equalTo(self.multipleField.mas_left).offset(-2);
    }];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.left.equalTo(self.multipleField.mas_right).offset(2);
    }];
    
    [optimizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.height.equalTo(self.passModeButton.mas_height) ;
        make.right.equalTo(contentView).offset(-5) ;
    }];
}

-(void)pvt_Optimize{
    [self pvt_hiddenCoverView:YES];
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    
    int count = _jczqInstance->GetSelectedCount();
    int mark = 0;
    for (int i = 0; i < count; i++) {
        mark += _jczqInstance->GetMarkResult(i) ? 1 : 0;
    }
    if(mark>0){
        [[DPToast makeText:@"优化投注不能设胆!"] show];
        return ;
    }
    if (self.gameType == GameTypeJcBf) {
        if (count == 0) {
            [[DPToast makeText:@"至少选择1场比赛"] show];
            return;
        }
    } else {
        if ((_jczqInstance->IsSelectedAllSingle()<1)&&(count < 2)) {
            [[DPToast makeText:@"至少选择2场比赛"] show];
            return;
        }
    }
    if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return ;
    }
    if (_jczqInstance->GetNotes() >100 ) {
        [[DPToast makeText:@"最大不超过100注"]show];
        return ;
    }
    if(_jczqInstance->GetSelectedTargetCount()>8){
        [[DPToast makeText:@"优化投注最多只能支持8场比赛"]show];
        return ;
    }
    
    
    [self.view.window showDarkHUD];
    _jczqInstance->NetBalance() ;
    
    
//    __weak __typeof(self) weakSelf = self;
//    __block __typeof(_jczqInstance) weakJczqInstance = _jczqInstance;
//    void(^block)(void) = ^ {
//        
//        [weakSelf.view.window showDarkHUD];
//         weakJczqInstance->NetBalance() ;
//    };
//
//    if (CFrameWork::GetInstance()->IsUserLogin()) {
//        block();
//
//    } else {
//        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
//        viewController.finishBlock = block;
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
//
    
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
    
    UILabel* yuanLabel = ({
    
        UILabel* label = [[UILabel alloc]init];
        label.text = @"元" ;
        label.font = [UIFont dp_systemFontOfSize:12.0f] ;
        label.textColor = [UIColor dp_flatWhiteColor] ;
        label.backgroundColor = [UIColor clearColor] ;
        label ;
    }) ;
    [contentView addSubview:yuanLabel];
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
        make.right.equalTo(contentView).offset(-15);

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
        make.width.lessThanOrEqualTo(@160) ;
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBoundLabel.mas_right);
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];

}

- (NSInteger)pvt_markCount {
    return 0;
}

- (void)pvt_onPassMode {
    int count = _jczqInstance->GetSelectedCount();
    if (self.gameType == GameTypeJcBf) {
        if (count == 0) {
            [[DPToast makeText:@"至少选择1场比赛"] show];
            return;
        }
    } else {
        if (count < 2) {
             if((_jczqInstance->IsSelectedAllSingle()<1)){
            [[DPToast makeText:@"至少选择2场比赛"] show];
            return;
             }
            
        }
    }
    
    self.passModeButton.selected = !self.passModeButton.isSelected;
    
    if (self.passModeButton.selected) {
        vector<int> freedoms;
        vector<int> combines;
        vector<int> passMode;
        
        _jczqInstance->GetEnablePassMode(freedoms, combines);
        _jczqInstance->GetPassMode(passMode);
        
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

- (void)pvt_onSubmit {
    if (self.gameType==GameTypeJcBf) {
        if (_jczqInstance->GetSelectedCount() <1){
            [[DPToast makeText:@"至少选择1场比赛!"] show];
            return;
        }
    }else if (_jczqInstance->GetSelectedCount() <2) {
        if (_jczqInstance->IsSelectedAllSingle()<1) {
            [[DPToast makeText:@"至少选择2场比赛!"] show];
             return;
        }
    }
    if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    }
    if (self.multipleField.text.integerValue <= 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    }
    if (!_isSelectedPro) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    if ((_jczqInstance -> GetNotes() * 2 * [self.multipleField.text integerValue]) > 200000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    }
    
        [[DPToast sharedToast] dismiss];
        [self.view endEditing:YES];
        if (self.passModeButton.selected) {
            [self.passModeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_jczqInstance) weakJczqInstance = _jczqInstance;
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
-(void)pvt_togetherBuy{
    if(self.gameType==GameTypeJcBf){
        if (_jczqInstance->GetSelectedCount() <1) {
            [[DPToast makeText:@"请至少选择一场比赛!"] show];
            return;
        }
       
    }else if (_jczqInstance->GetSelectedCount() <2) {
        if (_jczqInstance->IsSelectedAllSingle()<1) {
            [[DPToast makeText:@"至少选择2场比赛!"] show];
            return;
        }
        
    }
    if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    }
    if (self.multipleField.text.integerValue < 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"10"];
        return;
    }
    if (_isSelectedPro == NO){
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }else {
        unsigned int sum =_jczqInstance -> GetNotes() * 2 * self.multipleField.text.intValue;
        if (sum > 2000000) {
            [[DPToast makeText:dp_moneyLimitWarning]show];
            return;
        }
        [self.view endEditing:YES];
        if (self.passModeButton.selected) {
            [self.passModeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_jczqInstance) weakJczqInstance = _jczqInstance;
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

- (void)pvt_onModify {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pvt_onReset {
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            _jczqInstance->CleanupAllOptions();
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)pvt_updateInfo {
    vector<int> passMode;
    _jczqInstance->GetPassMode(passMode);
    [_selectedPassModes removeAllObjects];
    for (int i = 0; i < passMode.size(); i++) {
        [_selectedPassModes addObject:@(passMode[i])];
    }
    
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
    int betOptionRqspf[3], betOptionBf[31], betOptionZjq[8], betOptionBqc[9], betOptionSpf[3];
    _jczqInstance->GetSelectedTargetOption(index, betOptionRqspf, betOptionBf, betOptionZjq, betOptionBqc, betOptionSpf);
    
    BOOL rqspf = !CMathHelper::IsZero(betOptionRqspf, sizeof(betOptionRqspf));
    BOOL bf = !CMathHelper::IsZero(betOptionBf, sizeof(betOptionBf));
    BOOL zjq = !CMathHelper::IsZero(betOptionZjq, sizeof(betOptionZjq));
    BOOL bqc = !CMathHelper::IsZero(betOptionBqc, sizeof(betOptionBqc));
    BOOL spf = !CMathHelper::IsZero(betOptionSpf, sizeof(betOptionSpf));
    
    switch (self.gameType) {
        case GameTypeJcHt:
            return rqspf || bf || zjq || bqc || spf;
        case GameTypeJcRqspf:
            return rqspf;
        case GameTypeJcBf:
            return bf;
        case GameTypeJcZjq:
            return zjq;
        case GameTypeJcBqc:
            return bqc;
        case GameTypeJcSpf:
            return spf;
        default:
            return NO;
    }
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
            [button setImage:dp_CommonImage(@"check@2x.png") forState:UIControlStateSelected];
            [button setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
            button.selected = YES ;
//            [button setTitle:@" 我同意《用户合买代购协议》其中条款" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor colorWithRed:0.73 green:0.7 blue:0.65 alpha:1] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
//            [button.titleLabel setFont:[UIFont dp_systemFontOfSize:11]];
//            [button.titleLabel setNumberOfLines:0];
            [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            button;
        });
//        UILabel *agreementLabel = ({
//            UILabel *label = [[UILabel alloc]init];
//            label.backgroundColor = [UIColor clearColor];
//            label.text = @"我同意《用户合买代购协议》其中条款";
//            label.textColor = [UIColor colorWithRed:0.73 green:0.7 blue:0.65 alpha:1];
//            
//            label.numberOfLines = 0;
//            label.font = [UIFont dp_systemFontOfSize:11];
//            label.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreementLabelClick)];
//            [label addGestureRecognizer:tap];
//            label;
//        });
        
        UILabel *agreementLabel = ({
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreementLabelClick)];
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
        [contentView addSubview:agreementLabel];
        [contentView addSubview:redLabel];
        
        [gearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(contentView);
            make.left.equalTo(redLabel);
            make.top.equalTo(gearView.mas_bottom).offset(5);
        }];
        [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(agreementButton.mas_right);
            make.centerY.equalTo(agreementButton);
        }];
        
        [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.top.equalTo(agreementButton.mas_bottom).offset(2);
        }];
        
        _tableView.tableFooterView = contentView;
    }
    return _tableView;
}

- (void)onBtnClick:(UIButton *)button {

    button.selected = !button.selected;
    _isSelectedPro=button.selected;


}
- (void)agreementLabelClick
{
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.title = @"合买代购协议";
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];
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

- (UITextField *)multipleField {
    if (_multipleField == nil) {
        _multipleField = [[UITextField alloc] init];
        _multipleField.borderStyle = UITextBorderStyleNone;
        _multipleField.layer.cornerRadius = 3;
        _multipleField.layer.borderWidth = 0.5;
        _multipleField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
        _multipleField.backgroundColor = [UIColor clearColor];
        _multipleField.font = [UIFont dp_systemFontOfSize:12];
       _multipleField.keyboardType = UIKeyboardTypeNumberPad;
        _multipleField.textColor = [UIColor dp_flatBlackColor];
        _multipleField.textAlignment = NSTextAlignmentCenter;
        _multipleField.text = @"1";
        _multipleField.delegate = self;
        
        _multipleField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            
            line;
        });

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
- (MDHTMLLabel *)bottomBoundLabel {
    if (_bottomBoundLabel == nil) {
        _bottomBoundLabel = [[MDHTMLLabel alloc] init];
        [_bottomBoundLabel setNumberOfLines:1];
        [_bottomBoundLabel setTextColor:[UIColor dp_flatWhiteColor]];
        [_bottomBoundLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_bottomBoundLabel setBackgroundColor:[UIColor clearColor]];
        [_bottomBoundLabel setTextAlignment:NSTextAlignmentLeft];
        [_bottomBoundLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _bottomBoundLabel.userInteractionEnabled=NO;
    }
    return _bottomBoundLabel;
}
#pragma mark - tableView's data source and delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _jczqInstance->GetSelectedTargetCount();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DPJczqTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setDelegate:self];
        [cell setGameType:self.gameType];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];
    }
    
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    int spListRqspf[3], spListBf[31], spListZjq[8], spListBqc[9], spListSpf[3], rqs;
    int betOptionRqspf[3], betOptionBf[31], betOptionZjq[8], betOptionBqc[9], betOptionSpf[3];
    
    _jczqInstance->GetSelectedTargetInfo(indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
    _jczqInstance->GetSelectedTargetSpList(indexPath.row, spListRqspf, spListBf, spListZjq, spListBqc, spListSpf);
    _jczqInstance->GetSelectedTargetOption(indexPath.row, betOptionRqspf, betOptionBf, betOptionZjq, betOptionBqc, betOptionSpf);
    
    cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
    cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
    cell.middleLabel.text = @"VS";
    cell.orderNumberLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.markButton.selected = _jczqInstance->GetMarkResult(indexPath.row);
    
    static NSString *rqspfNames[] = { @"让球胜", @"让球平", @"让球负" };
    static NSString *bfNames[] = {
        @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
        @"0:0", @"1:1", @"2:2", @"3:3", @"平其他",
        @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"0:5", @"1:5", @"2:5", @"负其他",
    };
    static NSString *zjqNames[] = { @"0球", @"1球", @"2球", @"3球", @"4球", @"5球", @"6球", @"7+球" };
    static NSString *bqcNames[] = { @"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负" };
    static NSString *spfNames[] = { @"胜", @"平", @"负" };
    
    switch (self.gameType) {
        case GameTypeJcHt: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 3; i++)
                if (betOptionRqspf[i])
                    [items addObject:rqspfNames[i]];
            for (int i = 0; i < 31; i++)
                if (betOptionBf[i])
                    [items addObject:bfNames[i]];
            for (int i = 0; i < 8; i++)
                if (betOptionZjq[i])
                    [items addObject:zjqNames[i]];
            for (int i = 0; i < 9; i++)
                if (betOptionBqc[i])
                    [items addObject:bqcNames[i]];
            for (int i = 0; i < 3; i++)
                if (betOptionSpf[i])
                    [items addObject:spfNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text;
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
            cell.middleLabel.text = @"VS" ;//[NSString stringWithFormat:@"%@%d", rqs > 0 ? @"+" : @"", rqs];
            
        } break;
        case GameTypeJcRqspf: {
            
            for (int i = 0; i < cell.betOptionSpf.count; i++) {
                [cell.betOptionSpf[i] setSelected:betOptionRqspf[i]];
                DPBetToggleControl *toggle =  cell.betOptionSpf[i];
                toggle.oddsText = FloatTextForIntDivHundred(spListRqspf[i]);
            }
            cell.middleLabel.text = [NSString stringWithFormat:@"%@%d", rqs > 0 ? @"+" : @"", rqs];
            cell.middleLabel.textColor = rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
        } break;
        case GameTypeJcSpf: {
            for (int i = 0; i < cell.betOptionSpf.count; i++) {
                [cell.betOptionSpf[i] setSelected:betOptionSpf[i]];
                DPBetToggleControl *toggle =  cell.betOptionSpf[i];
                toggle.oddsText = FloatTextForIntDivHundred(spListSpf[i]);
            }
        } break;
        case GameTypeJcBf: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 31; i++)
                if (betOptionBf[i])
                    [items addObject:bfNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text;
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        case GameTypeJcZjq: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 8; i++)
                if (betOptionZjq[i])
                    [items addObject:zjqNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text;
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        case GameTypeJcBqc: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 9; i++)
                if (betOptionBqc[i])
                    [items addObject:bqcNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text;
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
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

#pragma mark - DPJczqTransferCellDelegate

- (void)jczqTransferCell:(DPJczqTransferCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _jczqInstance->SetSelectedTargetOption(indexPath.row, gameType, index, selected);
    
    [self calculateAllZhushu];
    [self pvt_updateInfo];
    
    if (![self pvt_selectedAtIndex:indexPath.row]) {
        cell.markButton.selected = NO;
        cell.markButton.enabled = NO;
    } else {
        cell.markButton.enabled = YES;
    }
}

- (void)jczqTransferCell:(DPJczqTransferCell *)cell mark:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _jczqInstance->SetMarkResult(indexPath.row, selected);
    
    [self calculateAllZhushu];
    [self pvt_updateInfo];
}

- (BOOL)shouldMarkJczqTransferCell:(DPJczqTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (_jczqInstance->GetMarkResult(indexPath.row)) {
        return YES;
    }
    if (![self pvt_selectedAtIndex:indexPath.row]) {
        return NO;
    }
    
    int count = _jczqInstance->GetSelectedCount();
    int mark = 0;
    for (int i = 0; i < count; i++) {
        mark += _jczqInstance->GetMarkResult(i) ? 1 : 0;
    }
    vector<int> freedoms, combines;
    _jczqInstance->GetEnablePassMode(freedoms, combines);
    int maxMark = MAX(freedoms.size() ? GetPassModeNamePrefix(freedoms.back()) : 0, combines.size() ? GetPassModeNamePrefix(combines.back()) : 0);
    if (mark >= maxMark) {
        [[DPToast makeText:[NSString stringWithFormat:@"最多设置%d个胆", maxMark]] show];
        return NO;
    }
    
    return YES;
}

- (void)deleteJczqTransferCell:(DPJczqTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _jczqInstance->DelSelectedTarget(indexPath.row);
    [self.tableView reloadData];
    
    [self calculateAllZhushu];
    [self pvt_updateInfo];
    
    if (_jczqInstance->GetSelectedCount() == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
        
    });
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] <= 0) {
        textField.text = @"1";
    }
    [self calculateAllZhushu];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
    if([newString intValue] > 100000){
        textField.text = @"100000";
        [self calculateAllZhushu];
//        [[DPToast makeText:@"最大倍数不得超过100000"] show];
        return NO;
    }
    if (newString.length == 0) {
        textField.text = @"";
        [self calculateAllZhushu];
        return NO;
    }
    
    if ([newString intValue] <= 0) {
        newString = @"1";
    }
    if ([textField.text isEqualToString:newString]) {
        textField.text = nil;   // fix iOS8
    }
    textField.text = newString;
    [self calculateAllZhushu];
    return NO;
}

// 计算注数
- (void)calculateAllZhushu {
    int note = _jczqInstance->GetNotes();
    int multiple = [self.multipleField.text integerValue];
    float minBonus = _jczqInstance->GetMinBonus();
    float maxBonus = _jczqInstance->GetMaxBonus();
    
    NSString *count = [NSString stringWithFormat:@"%d", note];
    NSString *maxBound = maxBonus * multiple * 2>=0? [NSString stringWithFormat:@"%.2f", maxBonus * multiple * 2]:@"?";
    NSString *minBound =  minBonus * multiple * 2>=0 ?[NSString stringWithFormat:@"%.2f", minBonus * multiple * 2]:@"?";
    NSString *money = [NSString stringWithFormat:@"%d", note * multiple * 2];
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@注 %@倍 共%@元", count, self.multipleField.text, money]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, count.length + self.multipleField.text.length + 5)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(count.length + self.multipleField.text.length + 5, money.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(hintString1.length - 1, 1)];
    [self.bottomLabel setText:hintString1];
    
//    NSMutableAttributedString *hintString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖金: %@-%@元", minBound, maxBound]];
//    [hintString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, 3)];
//    [hintString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(3, minBound.length + maxBound.length + 2)];
//    [hintString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(hintString2.length - 1, 1)];
    
    
    self.bottomBoundLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#FFFFFF\">%@</font><font size=12 color=\"#FFF538\">%@-%@</font>", @"奖金:", minBound, maxBound];
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

    _jczqInstance->SetPassMode(passModes, objects.count);
    
    [self calculateAllZhushu];
    [self pvt_updateInfo];
}

- (BOOL)passModeView:(DPPassModeView *)passModeView isSelectedModel:(NSInteger)passModeTag {
    return [_selectedPassModes containsObject:@(passModeTag)];
}

#pragma mark - Notfiy

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window dismissHUD];
        
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        switch (cmdType) {
            case JCZQ_Balance: {
                 [self dismissDarkHUD];
                if(_jczqInstance->GetBalanceCost()>2000000){
                    [[DPToast makeText:@"方案金额最大支持200万"]show];
                    return  ;
                }
                _jczqInstance->SetProjectBuyType(2);
                DPJczqOptimizeViewControl* vc = [[DPJczqOptimizeViewControl alloc]init];
                vc.multipleField.text = self.multipleField.text ;
                vc.passModeLabel.text = [NSString stringWithFormat:@"过关方式：%@",self.passModeButton.titleLabel.text]  ;
                vc.gameType = self.gameType ;
                vc.gameTypeText=dp_GameTypeFullName(self.gameType);
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
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
                viewController.projectAmount = _jczqInstance->GetNotes() * self.multipleField.text.integerValue * 2;
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
    int buyType;
    string token;
    _jczqInstance->GetWebPayment(buyType, token);
    NSString *urlString = kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    kAppDelegate.gotoHomeBuy = YES;
}

@end
