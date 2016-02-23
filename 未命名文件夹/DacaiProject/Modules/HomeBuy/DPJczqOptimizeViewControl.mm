//
//  DPJczqOptimizeViewControl.m
//  DacaiProject
//
//  Created by Ray on 14/11/10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJczqOptimizeViewControl.h"
#import "DPWebViewController.h"
#import "DPVerifyUtilities.h"
#import "DPCollapseTableView.h"
#import "DPJczqOptimizeCellTableViewCell.h"
#import "DPImageLabel.h"
#import "FrameWork.h"
#import "DPTogetherBuySetController.h"
#import "DPAccountViewControllers.h"
#import "DPRedPacketViewController.h"


@interface DPJczqOptimizeViewControl()<UITextFieldDelegate,UITableViewDataSource,DPCollapseTableViewDataSource,DPCollapseTableViewDelegate,DPJczqOptimizeCellDelegate,DPJczqOptimizeTextCellDelegate,UIGestureRecognizerDelegate,DPRedPacketViewControllerDelegate>{
    
    UITextField *_moneyTextField;
    UILabel* _passModeLabel ;


@private
    UIView *_submitView;
    UIView* _topBackView ;
    UIView* _caculateView ;
    DPCollapseTableView *_tableView;
    UIView *_configView;
    UITextField *_multipleField;
    UIView *_coverView;
    DPImageLabel* _imgLabel  ;


    BOOL _isSelectedPro;//是否选择协议
    
    NSArray* _expendCellarray ;
    CLotteryJczq *_jczqInstance;
    
    int _lastMoney ; //上一次计算投注的金额
    int _baseMoney ;//初始时的金额
    int _lowestMoney ; //最低金额
    BOOL _hasReloaded ;


}

@property (nonatomic, strong, readonly) UIView *submitView;
@property (nonatomic, strong, readonly) UIView *topBackView;
@property (nonatomic, strong, readonly) UIView *caculateView;
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *configView;
@property (nonatomic, strong, readonly) UIView *coverView;
@property (nonatomic, strong, readonly) DPImageLabel* imgLabel  ;




@end

@implementation DPJczqOptimizeViewControl
@dynamic submitView,topBackView,tableView,configView,multipleField,imgLabel,caculateView;
@synthesize bottomLabel = _bottomLabel, bottomBoundLabel = _bottomBoundLabel;


static NSString *rqspfNames[] = { @"让球胜", @"让球平", @"让球负" };

static NSString *bfNames[] = {
    @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
    @"0:0", @"1:1", @"2:2", @"3:3", @"平其他",
    @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"0:5", @"1:5", @"2:5", @"负其他",
};
static NSString *zjqNames[] = { @"0球", @"1球", @"2球", @"3球", @"4球", @"5球", @"6球", @"7+球" };
static NSString *bqcNames[] = { @"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负" };
static NSString *spfNames[] = { @"胜", @"平", @"负" };


- (instancetype)init
{
    self = [super init];
    if (self) {
        _jczqInstance = CFrameWork::GetInstance()->GetLotteryJczq();
        self.view.backgroundColor = [UIColor dp_flatBackgroundColor] ;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _jczqInstance->SetDelegate(self);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    [self pvt_changeBottomLabels];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[DPToast sharedToast]dismiss] ;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewDidLoad{

    [super viewDidLoad] ;
      self.title = @"奖金优化" ;
    _isSelectedPro=YES;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
   self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_TogetherBuyImage(@"rightIcon.png") target:self action:@selector(pvt_onMore)];
    
    UIView *contentView = self.view;
    [contentView addSubview:self.topBackView];
    [contentView addSubview:self.caculateView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.coverView];

    [contentView addSubview:self.configView];
    [contentView addSubview:self.submitView];


    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.coverView setHidden:YES];
    
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    
    [self.caculateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.top.equalTo(self.topBackView.mas_bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.caculateView.mas_bottom);
        make.bottom.equalTo(self.configView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    
    [self.configView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.bottom.equalTo(self.submitView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.tableView.mas_bottom);
    }];


    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];

    [self buildTopView];
    [self pvt_buildSubmitLayout];
    [self pvt_buildConfigLayout];
    
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
        tapRecognizer.delegate = self;
        tapRecognizer;
    })];

    int moneyCount = _jczqInstance->GetBalanceCost() ;
    _lowestMoney = _jczqInstance->GetBalanceCount()*2 ;
    _lastMoney = moneyCount ;
    _baseMoney = moneyCount ;
    self.moneyTextField.text = [NSString stringWithFormat:@"%d",moneyCount] ;
    [self pvt_changeBottomLabels];
    
    
}

-(void)buildTopView{
    
    UILabel* label1 = ({
        UILabel * label = [[UILabel alloc]init];
        label.text = @"预算金额" ;
        label.font = [UIFont dp_systemFontOfSize:13] ;
        label ;
    }) ;
    
    UILabel* label2 = ({
        UILabel * label = [[UILabel alloc]init];
        label.text = @"元" ;
        label.font = [UIFont dp_systemFontOfSize:13] ;
        label ;
    }) ;
    UIView *lineView = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });
    
    [self.topBackView addSubview:label1];
    [self.topBackView addSubview:label2];
    [self.topBackView addSubview:self.moneyTextField];
    [self.topBackView addSubview:lineView];

    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackView).offset(10) ;
        make.top.equalTo(self.topBackView) ;
        make.height.equalTo(self.topBackView) ;
    }];
    
    
    
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(label1.mas_right).offset(5) ;
        make.width.equalTo(@200) ;
        make.centerY.equalTo(label1.mas_centerY) ;
        make.height.equalTo(@30) ;

    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBackView) ;
        make.left.equalTo(self.moneyTextField.mas_right).offset(5) ;
        make.height.equalTo(self.topBackView) ;
    }];

    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackView);
        make.right.equalTo(self.topBackView);
        make.bottom.equalTo(self.topBackView);
        make.height.equalTo(@0.5);
    }];
    
    
    UIView* headerView = self.caculateView ;
    UIButton* caculateBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [caculateBtn setImage:dp_TogetherBuyImage(@"bg_normal.png")  forState:UIControlStateNormal];
    [caculateBtn setImage:dp_TogetherBuyImage(@"bg_pressed.png") forState:UIControlStateSelected];
    caculateBtn.backgroundColor = [UIColor clearColor] ;
    [caculateBtn addTarget:self action:@selector(pvt_caculateClick) forControlEvents:UIControlEventTouchUpInside];
    DPImageLabel *imgLabel = self.imgLabel ;
    self.imgLabel.userInteractionEnabled = NO;
    [headerView addSubview:caculateBtn];
    [headerView addSubview:imgLabel];
    
    [imgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView) ;
    }];
    [caculateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView) ;
        make.width.equalTo(imgLabel).multipliedBy(1.2) ;
    }];
    
    
    
}

- (void)pvt_buildSubmitLayout {
    
    UIView *lineView = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });
    
    DPImageLabel * groupButton = ({
            DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
        imageLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        imageLabel.imagePosition = DPImagePositionTop;
        imageLabel.textColor = UIColorFromRGB(0x867D6E);
        imageLabel.font = [UIFont dp_systemFontOfSize:12];
        imageLabel.layer.borderColor = [UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1].CGColor;
        imageLabel.layer.borderWidth = 0.5;
        imageLabel.image = dp_AppRootImage(@"gtoupByNew.png");
        imageLabel.text = @"发起合买" ;
        [imageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_togetherBuy)]];
    
        imageLabel ;
    }) ;
    
    
    UIButton *commitBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor dp_colorFromHexString:@"#e7161a"];
        [btn setTitle:@"付款" forState:UIControlStateNormal];
        [btn setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateNormal];
        [btn setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchDown];
        btn;
    });

    UIView *leftLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });

    
       
    UIView *contentView = self.submitView;
    [contentView addSubview:lineView];
    [contentView addSubview:groupButton];
    [contentView addSubview:commitBtn];
    [contentView addSubview:self.bottomLabel];
    [contentView addSubview:self.bottomBoundLabel];
    [contentView addSubview:leftLine];
    
    MDHTMLLabel* yuanLabel =({
      MDHTMLLabel* label =  [[MDHTMLLabel alloc]init];
        label.htmlText = @"<font size=12 color=\"#333333\">元</font>";
        label.font = [UIFont dp_systemFontOfSize:12.0f] ;
        label.backgroundColor = [UIColor clearColor] ;
        label ;
    }) ;
    [contentView addSubview:yuanLabel];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView);
        make.left.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@0.5) ;
    }];

    [groupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@75);
        make.left.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(0.5);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.right.equalTo(groupButton.mas_right);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];

    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@75);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
   
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupButton.mas_right).offset(5);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView.mas_centerY);
//        make.width.equalTo(@(160)) ;
        make.right.equalTo(commitBtn.mas_left) ;
    }];
    
    
    
    [self.bottomBoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupButton.mas_right).offset(5);
        make.top.equalTo(contentView.mas_centerY).offset(2);
        make.bottom.equalTo(contentView).offset(-5);
        make.width.lessThanOrEqualTo(@150) ;
    }];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBoundLabel.mas_right);
        make.top.equalTo(contentView.mas_centerY).offset(2);
        make.bottom.equalTo(contentView).offset(-5);
    }] ;

}
- (void)pvt_buildConfigLayout {
    UIView *topLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    UIView *middleLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    
    UIView *contentView = self.configView;
    
    [contentView addSubview:topLine];
    [contentView addSubview:middleLine];
    
    [contentView addSubview:self.passModeLabel];
    [contentView addSubview:self.multipleField];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView) ;
        make.height.equalTo(contentView);
        make.width.equalTo(@0.5) ;
        make.top.equalTo(contentView) ;
    }];
    [self.passModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
//        make.width.equalTo(contentView).multipliedBy(0.5);
        make.right.equalTo(middleLine.mas_left) ;
        make.left.equalTo(contentView).offset(5);
    }];
    [self.multipleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView).multipliedBy(1.5);
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



//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[DPImageLabel class]]) {
//        return NO;
//    }
//    return YES ;
//}

- (void)pvt_onTap {
    
    DPLog(@"taptaptaptaptaptaptap") ;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

    if (self.multipleField.isEditing) {
        [self.multipleField resignFirstResponder];
    }
    
    [self pvt_hiddenCoverView:YES];
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


-(void)pvt_onBack{
    
    [[DPToast sharedToast]dismiss];
    self.moneyTextField.text = [NSString stringWithFormat:@"%d",_lastMoney] ;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    self.coverView.hidden = YES ;

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pvt_onMore{

    [[DPToast sharedToast]dismiss];
    DPWebViewController * item = [[DPWebViewController alloc]init];
    item.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kYhIntroduce]];
    item.title = @"优化说明";
    item.canHighlight = NO ;
    [self.navigationController pushViewController:item animated:YES ];

}

-(void)pvt_showPassModel{
    
    [[DPToast makeText:self.passModeLabel.text]show];
}

-(void)pvt_onSubmit{

    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

    int quantity ; int64_t minBonus,maxBonus ;
    _jczqInstance->GetBalanceOrderInfo(quantity, minBonus, maxBonus) ;
    
    if (quantity == 0) {
        [[DPToast makeText:@"请先计算平衡投注"]show];
          return ;
        
    }

//    if (quantity*2*[self.multipleField.text intValue]<_lowestMoney){
//        [[DPToast makeText:[NSString stringWithFormat:@"付款金额必须大于最小金额%d",_lowestMoney]]show];
//        return ;
//    }else if (quantity*2*[self.multipleField.text intValue] >2000000){
//        [[DPToast makeText:[NSString stringWithFormat:@"付款金额必须小于200万"]]show];
//        return ;
//    
//    }
          else if (!_isSelectedPro) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    __block __typeof(_jczqInstance) weakJczqInstance = _jczqInstance;
    void(^block)(void) = ^ {
        [weakSelf.view.window showDarkHUD];
        
        weakJczqInstance->SetMultiple(weakSelf.multipleField.text.integerValue);
        weakJczqInstance->SetTogetherType(false);
        
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
        CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(weakSelf.gameType, 1, [weakSelf.multipleField.text integerValue]*2*quantity, 0);
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
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

    int quantity;int64_t minBonus,maxBonus ;
    _jczqInstance->GetBalanceOrderInfo(quantity, minBonus, maxBonus) ;
    if (quantity == 0) {
        [[DPToast makeText:@"请先计算平衡投注"]show];
        return ;
    }
//    if (quantity*2*[self.multipleField.text intValue]<_lowestMoney){
//        [[DPToast makeText:[NSString stringWithFormat:@"合买金额必须大于最小金额%d",_lowestMoney]]show];
//        return ;
//    }else if (quantity*2*[self.multipleField.text intValue] >2000000){
//        [[DPToast makeText:[NSString stringWithFormat:@"付款金额必须小于200万"]]show];
//        return ;
//        
//    }
          else if (!_isSelectedPro) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }

    _jczqInstance->GetBalanceCount() ;
    __weak __typeof(self) weakSelf = self;
    __block __typeof(_jczqInstance) weakJczqInstance = _jczqInstance;
    void(^block)(void) = ^ {
        //            [weakSelf.view.window showDarkHUD];
        
        weakJczqInstance->SetMultiple(weakSelf.multipleField.text.integerValue);
        weakJczqInstance->SetTogetherType(true);
        
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
        DPTogetherBuySetController *vc=[[DPTogetherBuySetController alloc]init];
        vc.sum= [weakSelf.multipleField.text integerValue]*2*quantity ;

        vc.gameType=self.gameType;
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

-(void)pvt_caculateClick{
    
    [[DPToast sharedToast]dismiss];
    [[[UIApplication sharedApplication]keyWindow ]endEditing:NO];
    self.multipleField.text = @"1" ;
    
    if([self.moneyTextField.text intValue] <_lowestMoney){
        [[DPToast makeText:[ NSString stringWithFormat:@"预算金额不能小于最低金额%d",_lowestMoney]]show];
        self.moneyTextField.text = [NSString stringWithFormat:@"%d",_lowestMoney] ;
        [self.view.window showDarkHUD];
        _jczqInstance->NetBalance([self.moneyTextField.text intValue]) ;
        return ;
    }
    
        [self.view.window showDarkHUD];
        _jczqInstance->NetBalance([self.moneyTextField.text intValue]) ;


}

-(void)pvt_changeBottomLabels{
    
    if (_jczqInstance->GetBalanceCount()<=0) {
        self.bottomLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font size=10 color=\"#e7161a\">%d</font>元", @"实际金额:", [self.moneyTextField.text intValue]*[self.multipleField.text intValue]];
        
        self.bottomBoundLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font size=10 color=\"#e7161a\">%@</font>", @"奖金范围:", @"0.00"];
        
        return ;
    }
    
    int quantity; int64_t minBonus,maxBonus ;
    _jczqInstance->GetBalanceOrderInfo(quantity, minBonus, maxBonus) ;
    if ( quantity*2*[self.multipleField.text intValue] > 2000000) {
        [[DPToast makeText:@"金额最大支持200万,请重新设置"]show];
        self.multipleField.text = @"1" ;
    }
    
    
    self.bottomLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font size=10 color=\"#e7161a\">%d</font> 元", @"实际金额:", quantity*2*[self.multipleField.text intValue]];
    if (minBonus == maxBonus) {
        self.bottomBoundLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font size=10 color=\"#e7161a\">%@</font>", @"奖金范围:", FloatTextForIntDivHundred(minBonus*[self.multipleField.text intValue])];
    }else
        self.bottomBoundLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font size=10 color=\"#e7161a\">%@~%@</font>", @"奖金范围:", FloatTextForIntDivHundred(minBonus*[self.multipleField.text intValue]),FloatTextForIntDivHundred(maxBonus*[self.multipleField.text intValue])];
}


#pragma mark -
#pragma mark 改变视图高度
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
    
    if (keyboardY != UIScreen.mainScreen.bounds.size.height && self.multipleField.editing ) {
        [self pvt_hiddenCoverView:NO];
    } else {
        [self pvt_hiddenCoverView:YES];

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
   
    
    if ([textField isEqual:self.moneyTextField] ) {
        _hasReloaded = NO ;
        if ([textField.text integerValue] <= 0) {
            textField.text = [NSString stringWithFormat:@"%d",_baseMoney];
        }else if([textField.text integerValue]%2 != 0){
        
            textField.text = [NSString stringWithFormat:@"%d",[textField.text intValue]+1] ;
        }
        [self pvt_changeBottomLabels];
        return ;

    }
    
    
    if ([textField.text integerValue] <= 0) {
        textField.text = @"1";
    }
    [self pvt_changeBottomLabels];

    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

//    textField.text = [NSString stringWithFormat:@"%d",[textField.text intValue]] ;
//    if ([textField isEqual:self.moneyTextField] && [textField.text integerValue]%2 != 0 ) {
//        [[DPToast makeText:@"只能输入偶数"]show];
//            return NO ;
//    }
    
    return YES ;

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    
    if ([textField isEqual:self.moneyTextField]) {
        
        if (![textField.text isEqualToString:newString] ) {
            self.multipleField.text = @"1" ;
            if (!_hasReloaded) {
                _jczqInstance->ClearBalanceData() ;
                [self.tableView reloadData];
                _hasReloaded = YES ;

            }
            
        }
        
        if([newString intValue]>2000000  ){
            [[DPToast makeText:@"实际金额最大支持200万"]show];
            textField.text = @"2000000";
            [self pvt_changeBottomLabels];
            
            return NO ;
        }
        
        if (newString.length<=0) {
            textField.text = @"" ;
            [self pvt_changeBottomLabels];

            return NO ;
        }
        

        if ([textField.text isEqualToString:newString]) {
            textField.text = @"";   // fix iOS8
        }
        textField.text = [NSString stringWithFormat:@"%d",[newString intValue]];

        [self pvt_changeBottomLabels];

        return NO ;
    }
    
    if([textField isEqual:self.multipleField]){
        if (newString.length == 0) {
            textField.text = @"";
            [self pvt_changeBottomLabels];
            return NO;
        }
        if([newString intValue] > 100000){
            textField.text = @"100000";
            [[DPToast makeText:@"最大倍数不得超过100000"] show];
            [self pvt_changeBottomLabels];
            
            return NO;
        }

        int quantity ; int64_t minBonus,maxBonus ;
        _jczqInstance->GetBalanceOrderInfo(quantity, minBonus, maxBonus) ;
        
        if (quantity*2*[newString intValue] >2000000){
            [[DPToast makeText:[NSString stringWithFormat:@"实际金额必须小于200万"]]show];
            return NO;
            
        }
        
        if (quantity == 0) {
            if ([newString intValue]*[self.moneyTextField.text intValue] >2000000) {
                [[DPToast makeText:[NSString stringWithFormat:@"实际金额必须小于200万"]]show];
                return NO;
            }
        }

       
       
        if ([textField.text isEqualToString:newString]) {
            textField.text = @"";   // fix iOS8
        }
        textField.text = [NSString stringWithFormat:@"%d",[newString intValue]];
        [self pvt_changeBottomLabels];
        
    
    }
    
    
    return NO;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
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

- (UITextField *)moneyTextField {
    if (_moneyTextField == nil) {
        _moneyTextField = [[UITextField alloc] init];
        _moneyTextField.borderStyle = UITextBorderStyleRoundedRect ;
        _moneyTextField.backgroundColor = [UIColor clearColor];
        _moneyTextField.textAlignment = NSTextAlignmentLeft ;
        _moneyTextField.font = [UIFont dp_systemFontOfSize:16];
//        _moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextField.text = @"100";
        _moneyTextField.textColor = [UIColor dp_flatRedColor] ;
        _moneyTextField.delegate = self;
        _moneyTextField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            line;
        }) ;
    }
    return _moneyTextField;
}

-(UILabel*)passModeLabel{

    if (_passModeLabel == nil) {
        _passModeLabel = [[UILabel alloc]init];
        _passModeLabel.numberOfLines = 1 ;
        _passModeLabel.font = [UIFont dp_systemFontOfSize:12] ;
        _passModeLabel.textAlignment = NSTextAlignmentCenter ;
        _passModeLabel.text = @"过关方式:2串1" ;
        _passModeLabel.userInteractionEnabled = YES ;
        _passModeLabel.backgroundColor = [UIColor clearColor] ;
        [_passModeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_showPassModel)]];

    }
    
    return _passModeLabel ;
}


- (MDHTMLLabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[MDHTMLLabel alloc] init];
        [_bottomLabel setNumberOfLines:1];
        [_bottomLabel setFont:[UIFont dp_systemFontOfSize:12.0f]];
        [_bottomLabel setBackgroundColor:[UIColor clearColor]];
        [_bottomLabel setTextAlignment:NSTextAlignmentLeft];
        [_bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _bottomLabel.userInteractionEnabled=NO;
        _bottomLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font size=10 color=\"#e7161a\">%d</font> 元", @"实际金额:", 1900];
    }
    return _bottomLabel;
}
- (MDHTMLLabel *)bottomBoundLabel {
    if (_bottomBoundLabel == nil) {
        _bottomBoundLabel = [[MDHTMLLabel alloc] init];
        [_bottomBoundLabel setNumberOfLines:1];
        [_bottomBoundLabel setFont:[UIFont dp_systemFontOfSize:12.0f]];
        [_bottomBoundLabel setBackgroundColor:[UIColor clearColor]];
        [_bottomBoundLabel setTextAlignment:NSTextAlignmentCenter];
        [_bottomBoundLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _bottomBoundLabel.userInteractionEnabled=NO;
        _bottomBoundLabel.htmlText =  [NSString stringWithFormat:@"<font size = 12 color=\"#333333\">%@</font><font size=10 color=\"#e7161a\">%@</font>", @"奖金范围:", @"123.05~9000.34"];

    }
    return _bottomBoundLabel;
}

- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _submitView;
}

- (UIView *)configView {
    if (_configView == nil) {
        _configView = [[UIView alloc] init];
        _configView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _configView;
}

- (UIView *)topBackView {
    if (_topBackView == nil) {
        _topBackView = [[UIView alloc] init];
        _topBackView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _topBackView;
}

- (UIView *)caculateView {
    if (_caculateView == nil) {
        _caculateView = [[UIView alloc] init];
        _caculateView.backgroundColor = [UIColor clearColor];
        _caculateView.layer.borderWidth = 1 ;
        _caculateView.layer.borderColor = UIColorFromRGB(0xD5D4C8).CGColor ;
    }
    return _caculateView;
}


- (DPCollapseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
        _tableView.scrollIndicatorInsets = self.tableView.contentInset;

//        UIView* headerView = ({
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
//            view.backgroundColor = [UIColor clearColor];
//            view.userInteractionEnabled = YES ;
//            view;
//        });
//        UIButton* caculateBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
//        [caculateBtn setImage:dp_TogetherBuyImage(@"bg_normal.png")  forState:UIControlStateNormal];
//        [caculateBtn setImage:dp_TogetherBuyImage(@"bg_pressed.png") forState:UIControlStateSelected];
//        caculateBtn.backgroundColor = [UIColor clearColor] ;
//        [caculateBtn addTarget:self action:@selector(pvt_caculateClick) forControlEvents:UIControlEventTouchUpInside];
//        DPImageLabel *imgLabel = self.imgLabel ;
//        self.imgLabel.userInteractionEnabled = NO;
//        [headerView addSubview:caculateBtn];
//        [headerView addSubview:imgLabel];
//        
//        [imgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(headerView) ;
//        }];
//        [caculateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(headerView) ;
//            make.width.equalTo(imgLabel).multipliedBy(1.2) ;
//        }];
//
//
//        _tableView.tableHeaderView = headerView ;
        
        
        UIView *contentView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        
        UIButton *agreementButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setImage:dp_CommonImage(@"check@2x.png") forState:UIControlStateSelected];
            [button setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
            button.selected = YES ;
           [button setBackgroundColor:[UIColor clearColor]];
           [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
       
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
        
        [contentView addSubview:agreementButton];
        [contentView addSubview:agreementLabel];
        [contentView addSubview:redLabel];

        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerX.equalTo(contentView);
            make.left.equalTo(redLabel);
            make.top.equalTo(contentView).offset(5);
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
- (void)agreementLabelClick
{
    DPWebViewController *webCtrl = [[DPWebViewController alloc]init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.title = @"合买代购协议";
    webCtrl.canHighlight = NO ;
    [self.navigationController pushViewController:webCtrl animated:YES];
}
- (void)onBtnClick:(UIButton *)button {
    
    button.selected = !button.selected;
    _isSelectedPro=button.selected;
    
}

#pragma mark - tableView's data source and delegate


-(DPImageLabel*)imgLabel{
    if (_imgLabel == nil) {
        _imgLabel = [[DPImageLabel alloc]init];
        _imgLabel.text = @"  计算平衡投注  " ;
        _imgLabel.image = dp_TogetherBuyImage(@"down_arrow.png") ;
        _imgLabel.imagePosition = DPImagePositionRight ;
        _imgLabel.backgroundColor = [UIColor clearColor] ;
        _imgLabel.font = [UIFont dp_systemFontOfSize:14] ;
        _imgLabel.textColor = [UIColor dp_flatWhiteColor] ;
        _imgLabel.offset = -3 ;
        _imgLabel.userInteractionEnabled = YES ;
        
    }
    
    return _imgLabel ;
}

-(CGFloat)caculateLabelHight:(NSString*)str width:(CGFloat)width{

 UILabel*   _matchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 1)];

    _matchLabel.numberOfLines = 0 ;
    _matchLabel.font = [UIFont dp_systemFontOfSize:12] ;
    _matchLabel.text = str ;
    [_matchLabel sizeToFit] ;
    
    return CGRectGetHeight(_matchLabel.frame) ;

}

-(NSString*)getContentStringwithIndextPath:(NSIndexPath*)indexPath{
    
    NSMutableString* resultString = [[NSMutableString alloc]initWithString:@""] ;
    int sportCount = _jczqInstance->GetBalanceRowCount(indexPath.row/2) ;

    for (int i=0; i<sportCount; i++) {
        
        int gameType,betOption,sp,rqs ;
        string  orderNumberName ,homeTeamName, awayTeamName;
        
        _jczqInstance->GetBalanceRowInfo(indexPath.row/2, i , orderNumberName, homeTeamName, awayTeamName,rqs, gameType, betOption, sp) ;
        NSString* resultStr  ;
        
        switch (gameType) {
            case GameTypeJcRqspf:
//                resultStr = rqspfNames[betOption] ;
                resultStr = [NSString stringWithFormat:@"%d%@",rqs,spfNames[betOption]] ;

                break;
            case GameTypeJcBf:
                resultStr = bfNames[betOption] ;

                break ;
            case GameTypeJcSpf:
                resultStr = spfNames[betOption] ;

                break;
            case GameTypeJcZjq:
                resultStr = zjqNames[betOption] ;
                
                break ;
            case GameTypeJcBqc:
                resultStr = bqcNames[betOption] ;

                break ;
            default:
                break;
        }

        [resultString appendString:[NSString stringWithFormat:@"—%@(%@)",[NSString stringWithUTF8String:homeTeamName.c_str()],resultStr]] ;
    }

    [resultString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""] ;
    return resultString ;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row %2 == 0) {
        
        NSString* str = [self getContentStringwithIndextPath:indexPath];

        return [self caculateLabelHight:str width:260]+10 ;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCount = _jczqInstance->GetBalanceCount() ;
    if (rowCount == 0) {
        self.tableView.tableFooterView.hidden = YES ;
    }else
        self.tableView.tableFooterView.hidden = NO ;
    return rowCount*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row%2 == 0) {
        static NSString *CellIdentifier1 = @"Cell1";
        DPJczqOptimizeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[DPJczqOptimizeTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.contentView.backgroundColor = [UIColor dp_colorFromRGB:0xF4F3EF] ;
            cell.backgroundColor = [UIColor dp_colorFromRGB:0xF4F3EF] ;
            [cell buildLayout];
            cell.delegate =self ;
        }
        cell.matchLabel.text = [self getContentStringwithIndextPath:indexPath];
        
        cell.rightImg.highlighted = [self.tableView isExpandAtModelIndex:indexPath] ;
        return cell;

    }else{
    
        static NSString *CellIdentifier = @"Cell2";
        DPJczqOptimizeCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPJczqOptimizeCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentView.backgroundColor = [UIColor dp_colorFromRGB:0xF4F3EF] ;
            cell.backgroundColor = [UIColor dp_colorFromRGB:0xF4F3EF] ;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell buildLayout];
            cell.delegate = self ;
        }
        int multiple;int64_t bonus ;
          _jczqInstance-> GetBalanceContentOption((indexPath.row/2), multiple, bonus);
        cell.numberField.text = [NSString stringWithFormat:@"%d",multiple] ;
        cell.awardLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font color=\"#e7161a\">%@</font>", @"注,奖金:", FloatTextForIntDivHundred(bonus*multiple)];
        return cell;

    
    }
    
    return  nil ;
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    int sportCount = _jczqInstance->GetBalanceRowCount(indexPath.row/2) ;
 
    NSString *CellIdentifier = [NSString stringWithFormat:@"ReuseCell%d", sportCount];
    DPJczqOptimizeAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqOptimizeAnalysisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell buildLayout];
        [cell buildContentWithSportCount:sportCount];
    }
    
    
    for (int i=0; i<sportCount; i++) {

        int gameType,betOption,sp,rqs ;
        string  orderNumberName ,homeTeamName, awayTeamName;
        
        _jczqInstance->GetBalanceRowInfo(indexPath.row/2, i , orderNumberName, homeTeamName, awayTeamName,rqs,gameType, betOption, sp) ;
    
        UILabel* sessionLab = [cell.sessionArray objectAtIndex:i] ;
        UILabel* homeLab = [cell.homeArray objectAtIndex:i] ;
        UILabel *awayLab = [cell.awayArray objectAtIndex:i] ;
        UILabel* contentLab = [cell.contentArray objectAtIndex:i];

        
        sessionLab.text = [NSString stringWithUTF8String:orderNumberName.c_str()] ;
        homeLab.text = [NSString stringWithUTF8String:homeTeamName.c_str()] ;
        awayLab.text = [NSString stringWithUTF8String:awayTeamName.c_str()] ;
        
        switch (gameType) {
            case GameTypeJcRqspf:
                contentLab.text= [NSString stringWithFormat:@"%@(%+d)%@",spfNames[betOption],rqs,FloatTextForIntDivHundred(sp)] ;

                break;
            case GameTypeJcBf:
                contentLab.text= [NSString stringWithFormat:@"(%@)%@",bfNames[betOption],FloatTextForIntDivHundred(sp)] ;

                
                break ;
            case GameTypeJcSpf:
                contentLab.text= [NSString stringWithFormat:@"%@%@",spfNames[betOption],FloatTextForIntDivHundred(sp)] ;

                break;
            case GameTypeJcZjq:
                contentLab.text= [NSString stringWithFormat:@"(%@)%@",zjqNames[betOption],FloatTextForIntDivHundred(sp)] ;

                break ;
            case GameTypeJcBqc:
                contentLab.text= [NSString stringWithFormat:@"%@%@",bqcNames[betOption],FloatTextForIntDivHundred(sp)] ;

                break ;
            default:
                break;
        }

    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell layoutIfNeeded];
    
    return cell;

}

-(CGFloat)tableView:(DPCollapseTableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    int sportCount = _jczqInstance->GetBalanceRowCount(indexPath.row/2) ;
    
    return  sportCount*cellHigh + offSet-_expendCellarray.count+2 ;
}

#pragma mark-
#pragma mark DPJczqOptimizeCellDelegate
-(void)changnum:(NSString*)num OptimizeCell:(DPJczqOptimizeCellTableViewCell*)cell {
    
    cell.numberField.text = [NSString stringWithFormat:@"%d",[num intValue]] ;
    
    NSIndexPath * indexPath =  [self.tableView modelIndexForCell:cell];//[self.tableView indexPathForCell:cell] ;
    DPLog(@"num ===  %@ ,, index = %@",num,indexPath) ;
    _jczqInstance->SetBalanceRowMultiple(indexPath.row/2 , [num intValue]);
    
    int quantity; int64_t minBonus,maxBonus ;
    _jczqInstance->GetBalanceOrderInfo(quantity, minBonus, maxBonus) ;
    if (quantity*2*[self.multipleField.text intValue] >2000000) {
        _jczqInstance->SetBalanceRowMultiple(indexPath.row/2 ,cell.lastNum );
        [[DPToast makeText:@"实际金额最大支持200万"]show];
        [cell stopChangeNum];
        return ;
    }

    
    int multiple;int64_t bonus ;
    _jczqInstance-> GetBalanceContentOption((indexPath.row/2), multiple, bonus);
    
    cell.awardLabel.htmlText =  [NSString stringWithFormat:@"<font size=12 color=\"#333333\">%@</font><font color=\"#e7161a\">%@</font>", @"注,奖金:", FloatTextForIntDivHundred(bonus*multiple)];
    
//    [self.tableView reloadCellAtModelIndex:indexPath] ;
    [self pvt_changeBottomLabels];

    
}


#pragma mark-
#pragma mark DPJczqOptimizeTextCellDelegate

-(void)jczqOptimizeInfo:(DPJczqOptimizeTextCell*)cell{
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];
    [cell analysisViewIsExpand:[self.tableView isExpandAtModelIndex:modelIndex]] ;

    [self.tableView toggleCellAtModelIndex:modelIndex animation:YES];

}

- (void)dealloc {
    _jczqInstance->ClearBalanceData();
}

#pragma mark - Notfiy

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    int quantity ; int64_t minBonus,maxBonus ;
    _jczqInstance->GetBalanceOrderInfo(quantity, minBonus, maxBonus) ;
    __weak __typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window dismissHUD];
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();

        switch (cmdType) {
            case JCZQ_Balance:
            {
                _lastMoney = [self.moneyTextField.text intValue] ;
                [self.tableView reloadData];
                [self pvt_changeBottomLabels];
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
                viewController.gameTypeText =self.gameTypeText;
                viewController.projectAmount = [weakSelf.multipleField.text integerValue]*2*quantity ;

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
