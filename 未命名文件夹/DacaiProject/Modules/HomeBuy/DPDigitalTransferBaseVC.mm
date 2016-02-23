//
//  DPDigitalTransferBaseVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-7.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalTransferBaseVC.h"
#import "DPDigitalIssueControl.h"
#import "DPVerifyUtilities.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "DPTogetherBuySetController.h"
#import "DPSmartFollowVC.h"
#import "DPWebViewController.h"
#import "DPDigitalCommon.h"
#import "NotifyType.h"
#import "DPNotifyCapturer.h"
#import "DPSmartPlanSetView.h"
@protocol IndroduceViewDelegate;
@interface IndroduceView : UIView
@property (nonatomic, weak) id<IndroduceViewDelegate> delegate;
@end

@protocol IndroduceViewDelegate <NSObject>
- (void)cancle:(IndroduceView *)view;
@end

@implementation IndroduceView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self buildLayout];
    }
}

-(UIView*)creaTableLayout:(MASViewAttribute*)top offset:(NSInteger)off bgCloor:(UIColor*)bgcolor heigh:(NSInteger)heigh superView:(UIView*)BaseView titleFir:(NSString*)title1  titleSec:(NSString*)title2 titlecolor:(UIColor*)titlecolor titleFont:(UIFont*)fonts {
    UIView* backView= [[UIView alloc]init];
    backView.backgroundColor = bgcolor ;
    backView.layer.borderColor = UIColorFromRGB(0xDEDBD5).CGColor ;
    backView.layer.borderWidth = 1 ;
    [BaseView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top).offset(off) ;
        make.width.equalTo(BaseView) ;
        make.centerX.equalTo(BaseView) ;
        make.height.equalTo(@(heigh)) ;
    }];
    
    UILabel* gradeLabel = [[UILabel alloc]init];
    gradeLabel.textAlignment = NSTextAlignmentCenter ;
    gradeLabel.layer.borderWidth = 0;
    gradeLabel.font = fonts ;
    gradeLabel.backgroundColor = [UIColor clearColor];
    gradeLabel.text= title1 ;
    [backView addSubview:gradeLabel];
    
    UILabel* line1 = [[UILabel alloc]init];
    line1.textAlignment = NSTextAlignmentCenter ;
    line1.layer.borderWidth = 0;
    line1.font = [UIFont dp_systemFontOfSize:11] ;
    line1.backgroundColor =[UIColor clearColor] ;
    line1.text= @"|" ;
    line1.textColor = UIColorFromRGB(0xDEDBD5) ;
    [backView addSubview:line1];
    
    UILabel* precentLabel = [[UILabel alloc]init];
    precentLabel.textAlignment = NSTextAlignmentCenter ;
    precentLabel.layer.borderWidth = 0;
    precentLabel.font = fonts ;
    precentLabel.backgroundColor = [UIColor clearColor] ;
    precentLabel.text= title2 ;
    precentLabel.textColor = titlecolor ;
    [backView addSubview:precentLabel];
    
    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(backView.mas_width).multipliedBy(0.6) ;
        make.top.equalTo(backView.mas_top);
        make.left.equalTo(backView) ;
        make.height.equalTo(backView) ;
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.left.equalTo(gradeLabel.mas_right) ;
        make.width.equalTo(@2) ;
        make.height.equalTo(backView);
    }];

    [precentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.right.equalTo(backView) ;
        make.left.equalTo(line1.mas_right) ;
        make.height.equalTo(backView) ;
    }];
    
    return backView;

}
-(void)buildLayout
{
    
    self.backgroundColor=UIColorFromRGB(0xFFFFFF);
    
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"追加投注奖金规则" ;
    titleLabel.font=[UIFont dp_systemFontOfSize:14.0];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor dp_flatBlackColor];
    [self addSubview:titleLabel];
    
    
    UIView* backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor] ;
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = UIColorFromRGB(0xDEDBD5).CGColor ;
    [self addSubview:backView];
    

    
    UILabel* egLabel = [[UILabel alloc]init];
    egLabel.text = @"例如：投一注2元的大乐透，若追加投注则投注金额为2+2x50%=3元，若中奖，奖金追加额度参考上面的表格。" ;
    egLabel.font=[UIFont dp_systemFontOfSize:11.0];
    egLabel.backgroundColor=[UIColor clearColor];
    egLabel.textAlignment=NSTextAlignmentCenter;
    egLabel.textColor=[UIColor dp_coverColor];
    egLabel.textAlignment= NSTextAlignmentLeft ;
    egLabel.numberOfLines = 0 ;
    [self addSubview:egLabel];
    
    
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
    confirmButton.backgroundColor=[UIColor dp_flatRedColor];
    confirmButton.titleLabel.font =[UIFont dp_boldSystemFontOfSize:16.0];
    [confirmButton setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pv_cancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    
   [ titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
       make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.9);
        make.top.equalTo(self).offset(10);
       make.height.equalTo(@20);
       
    }];
    
    
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10) ;
        make.centerX.equalTo(self) ;
        make.width.equalTo(self).multipliedBy(0.9) ;
        make.height.equalTo(@110);
    }] ;
    
    
   
    [egLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.9) ;
        make.centerX.equalTo(self.mas_centerX) ;
        make.top.equalTo(backView.mas_bottom).offset(5);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.9) ;
        make.centerX.equalTo(self.mas_centerX) ;
        make.top.equalTo(egLabel.mas_bottom).offset(5) ;
        make.bottom.equalTo(self).offset(-10) ;
    }];

    UIView* view1 = [self creaTableLayout:backView.mas_top offset:0  bgCloor:UIColorFromRGB(0xF1EFEA) heigh:23 superView:backView titleFir:@"等级" titleSec:@"奖金追加额度" titlecolor:[UIColor blackColor] titleFont:[UIFont dp_systemFontOfSize:11.0]];
   UIView* view2= [self creaTableLayout:view1.mas_bottom offset:-1  bgCloor:[UIColor clearColor] heigh:30 superView:backView titleFir:@"一等奖、二等奖、三等奖" titleSec:@"+60%" titlecolor:[UIColor redColor] titleFont:[UIFont dp_systemFontOfSize:12.0]];
    UIView* view3 = [self creaTableLayout:view2.mas_bottom offset:-1  bgCloor:[UIColor clearColor] heigh:30 superView:backView titleFir:@"四等奖、五等奖" titleSec:@"+50%" titlecolor:[UIColor redColor] titleFont:[UIFont dp_systemFontOfSize:12.0]];
    [self creaTableLayout:view3.mas_bottom offset:-1 bgCloor:[UIColor clearColor] heigh:30 superView:backView titleFir:@"六等奖" titleSec:@"不追加" titlecolor:[UIColor blackColor] titleFont:[UIFont dp_systemFontOfSize:12.0]];

}

- (void)pv_cancle {

    DPLog(@"我知道了===");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancle:)]) {
        [self.delegate cancle:self];
    }
}

@end

@interface DPDigitalTransferBaseVC ()<IndroduceViewDelegate> {
@private
     BOOL _isSelectedPro;//是否选择协议
     UIView *_coverView;
    UIView *_midlleLine;
    UIView *_bottomLine;
    BOOL _keyboardIsVisible ;
    MSWeakTimer *_timer;
}
@property (nonatomic, strong, readonly) UIView *coverView;
@end

@implementation DPDigitalTransferBaseVC
@synthesize issureTableView = _issureTableView;
@synthesize bottomView = _bottomView;
@synthesize bottomLabel = _bottomLabel;
@synthesize optionView = _optionView;
@synthesize addyizhuView = _addyizhuView;
@dynamic timeSpace;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [[DPNotifyCapturer defaultCapturer] setDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_ApplicationBecomeActive:) name:dp_ApplicationDidBecomeActive object:nil];

        [self setTimeSpace:0];
        [self loadInstance];
        [self.timer schedule];
        [self.timer fire];
    }
    return self;
}

- (void)dealloc {
    DPLog(@"dig dealloc");
    [self.timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ApplicationDidBecomeActive object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];

    [self pvt_hiddenCoverView:YES];
}

-(void)dp_ApplicationBecomeActive:(NSNotification*)notif{

//    [self recvRefresh:YES];
    [self sendRefresh];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    [self alertGameName];
}

- (void)keyboardDidShow
{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide
{
    _keyboardIsVisible = NO;
}

- (BOOL)keyboardIsVisible
{
    return _keyboardIsVisible;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
    
    __weak DPDigitalTransferBaseVC *weakSelf = self;

    [self.issureTableView addPullToRefreshWithActionHandler:^{
        [weakSelf digitalRandomData];
        [weakSelf calculateAllZhushuWithZj:weakSelf.addButton.selected];
        [weakSelf.issureTableView.pullToRefreshView stopAnimating];
        [weakSelf.issureTableView reloadData];
    }];
    _isSelectedPro=YES;
    [self.issureTableView.pullToRefreshView setTextColor:[UIColor dp_flatBlackColor]];
    [self.issureTableView.pullToRefreshView setTitle:@"下拉机选   " forState:SVPullToRefreshStateStopped];
    [self.issureTableView.pullToRefreshView setTitle:@"释放机选   " forState:SVPullToRefreshStateTriggered];
    [self.issureTableView.pullToRefreshView setTitle:@"正在机选..." forState:SVPullToRefreshStateLoading];

    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_DigitLotteryImage(@"ballAdd.png") title:@"手动添加" target:self action:@selector(pvt_add)];

    [self.view addSubview:self.issureTableView];
     [self.view addSubview:self.coverView];
    UIView *contentView = self.view;

//    [contentView addSubview:self.addyizhuView];
//    [self.addyizhuView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(contentView.mas_centerX);
//         make.centerY.equalTo(contentView.mas_centerY);
//        make.width.equalTo(@154);
//        make.height.equalTo(@112);
//    }];
    [self.addyizhuView setBounds:CGRectMake(0, 0, 154, 112)];
    [self.addyizhuView setCenter:CGPointMake(160, 180)];
    [self.issureTableView addSubview:self.addyizhuView];
    
    //底部view
    [contentView addSubview:self.bottomView];
    [contentView addSubview:self.optionView];
    //投注倍数和期号
    [contentView addSubview:self.mulAndIssueView];
    [self.issureTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.mulAndIssueView.mas_top);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@44);
    }];
    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.height.equalTo(@0);
    }];
    [self.mulAndIssueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.bottom.equalTo(self.optionView.mas_top);
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
    self.optionView.hidden = YES;
    UITapGestureRecognizer *tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
    [self pvt_buildConfigLayout];
    if (self.digitalType==GameTypeJxsyxw) {
        [self pvt_buildSyxwBottomLayout];
    }else{
    [self pvt_buildBottomLayout];
    }
    [self pvt_bulidOption];
}

- (void)pvt_buildConfigLayout {
    UIView *topLine = ({
        [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    });
    UIView *bottomLine = ({
        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        line.alpha = 0;
        line;
    });
    UIView *midLine = ({
        [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    });
    _bottomLine = bottomLine;
    [self.mulAndIssueView addSubview:topLine];
    [self.mulAndIssueView addSubview:bottomLine];
    [self.mulAndIssueView addSubview:midLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mulAndIssueView);
        make.right.equalTo(self.mulAndIssueView);
        make.top.equalTo(self.mulAndIssueView);
        make.height.equalTo(@0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mulAndIssueView);
        make.right.equalTo(self.mulAndIssueView);
        make.bottom.equalTo(self.mulAndIssueView);
        make.height.equalTo(@0.5);
    }];
    UILabel *label1 = [self labelWithText:@"投" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label1];
    UILabel *label2 = [self labelWithText:@"倍" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label2];

    UILabel *label3 = [self labelWithText:@"追" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label3];
    UILabel *label4 = [self labelWithText:@"期" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentCenter];
    [self.mulAndIssueView addSubview:label4];

    //    UILabel *label5=[self labelWithText:@"追加投注" font:[UIFont dp_systemFontOfSize:12.0] titleColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentCenter];
    //    [self.mulAndIssueView addSubview:label5];

    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.backgroundColor = [UIColor clearColor];
    _addButton.tag = 1000;
    [_addButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"uncheck.png")] forState:UIControlStateNormal];
    [_addButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"check.png")] forState:UIControlStateSelected];
    [_addButton setTitle:@" 追加投注" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _addButton.selected = NO;
    self.addTouzhu = NO;
    [_addButton addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mulAndIssueView addSubview:_addButton];
    
     _introduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _introduceButton.backgroundColor = [UIColor clearColor];
    [_introduceButton setImage:dp_AccountImage(@"drawingMoney.png") forState:UIControlStateNormal];
    [_introduceButton addTarget:self action:@selector(pvt_introduceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mulAndIssueView addSubview:_introduceButton];

    self.addTimesTextField = [[UITextField alloc] init];
    self.addTimesTextField.backgroundColor = [UIColor whiteColor];
    self.addTimesTextField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0].CGColor;
    self.addTimesTextField.layer.borderWidth = 0.5;
    self.addTimesTextField.layer.cornerRadius = 5;
    self.addTimesTextField.textAlignment = NSTextAlignmentCenter;
    self.addTimesTextField.delegate = self;
    self.addTimesTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.addTimesTextField.font = [UIFont boldSystemFontOfSize:14];
    self.addTimesTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.addTimesTextField.textColor = [UIColor dp_flatBlackColor];
    self.addTimesTextField.text = @"1";
    self.addTimesTextField.inputAccessoryView = ({
        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        line.bounds = CGRectMake(0, 0, 0, 0.5f);

        line;
    });
    [self.mulAndIssueView addSubview:self.addTimesTextField];


    self.addIssueTextField = [[UITextField alloc] init];
    self.addIssueTextField.backgroundColor = [UIColor whiteColor];
    self.addIssueTextField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0].CGColor;
    self.addIssueTextField.layer.borderWidth = 0.5;
    self.addIssueTextField.layer.cornerRadius = 5;
    self.addIssueTextField.textAlignment = NSTextAlignmentCenter;
    self.addIssueTextField.delegate = self;
    self.addIssueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.addIssueTextField.font = [UIFont boldSystemFontOfSize:14];
    self.addIssueTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.addIssueTextField.textColor = [UIColor dp_flatBlackColor];
    self.addIssueTextField.text = @"1";
    self.addIssueTextField.inputAccessoryView = ({
        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        line.bounds = CGRectMake(0, 0, 0, 0.5f);
        line;
    });
    [self.mulAndIssueView addSubview:self.addIssueTextField];

    if (self.digitalType == GameTypeDlt) {
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(5);
            make.bottom.equalTo(self.mulAndIssueView).offset(-5);
            make.left.equalTo(self.mulAndIssueView).offset(10);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        [self.addTimesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(6);
            make.bottom.equalTo(self.mulAndIssueView).offset(-5);
            make.left.equalTo(label1.mas_right);
            make.width.equalTo(@(kScreenWidth*0.17));
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(5);
            make.bottom.equalTo(self.mulAndIssueView).offset(-5);
            make.left.equalTo(self.addTimesTextField.mas_right);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(5);
            make.bottom.equalTo(self.mulAndIssueView).offset(-5);
            make.left.equalTo(label2.mas_right).offset(4);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        [self.addIssueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(6);
            make.bottom.equalTo(self.mulAndIssueView).offset(-6);
            make.left.equalTo(label3.mas_right);
            make.width.equalTo(@(kScreenWidth*0.17));
        }];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView).offset(6);
            make.bottom.equalTo(self.mulAndIssueView).offset(-6);
            make.left.equalTo(self.addIssueTextField.mas_right);
            make.width.equalTo(@(kScreenWidth*0.05));
        }];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mulAndIssueView.mas_centerY);
            make.height.equalTo(@14.5);
            make.left.equalTo(label4.mas_right).offset(10);
            make.width.equalTo(@74.5);
        }];
        
        [_introduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mulAndIssueView.mas_centerY);
            make.height.equalTo(self.mulAndIssueView.mas_height);
            make.right.equalTo(self.mulAndIssueView);
//            make.width.equalTo(self.mulAndIssueView.mas_height).multipliedBy(0.6);
            make.left.equalTo(_addButton.mas_right) ;
        }];
        
        
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mulAndIssueView);
            make.bottom.equalTo(self.mulAndIssueView);
            make.left.equalTo(label2.mas_right).offset(1);
            make.width.equalTo(@0.5);
        }];
        return;
    }
    _addButton.hidden = YES;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(self.mulAndIssueView).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];
    [self.addTimesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(label1.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.25);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(self.addTimesTextField.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];

    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView);
        make.bottom.equalTo(self.mulAndIssueView);
        make.centerX.equalTo(self.mulAndIssueView);
        make.width.equalTo(@0.5);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(midLine.mas_right).offset(20);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];
    [self.addIssueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(label3.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.25);
    }];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mulAndIssueView).offset(6);
        make.bottom.equalTo(self.mulAndIssueView).offset(-6);
        make.left.equalTo(self.addIssueTextField.mas_right).offset(10);
        make.width.equalTo(self.mulAndIssueView).multipliedBy(0.05);
    }];
}
-(void)pvt_buildSyxwBottomLayout{
    UIView *contentView = self.bottomView;
    UIButton *cleanupButton = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    
    // config control
    confirmButton.backgroundColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
    
    // bind event
    cleanupButton.backgroundColor = [UIColor clearColor];
    [cleanupButton setTitle:@"智能追号" forState:UIControlStateNormal];
    [cleanupButton setTitleColor:UIColorFromRGB(0x491706) forState:UIControlStateNormal];
    [cleanupButton.titleLabel setFont:[UIFont dp_systemFontOfSize:15.0]];
    [cleanupButton addTarget:self action:@selector(onSmartPlan) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(pvt_submitss) forControlEvents:UIControlEventTouchUpInside];
    
    // move to view
    [contentView addSubview:cleanupButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.bottomLabel];
    [contentView addSubview:confirmView];
    [contentView addSubview:lineView];
    
    // layout
    [cleanupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(9);
        make.bottom.equalTo(contentView).offset(-9);
        make.left.equalTo(contentView).offset(8);
        make.width.equalTo(@60);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(cleanupButton.mas_right).offset(8);
        make.right.equalTo(contentView);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton).offset(10);
        make.right.equalTo(contentView).offset(-40);
        make.centerY.equalTo(confirmButton);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmButton).offset(-20);
        make.centerY.equalTo(confirmButton);
        make.width.equalTo(@23.5);
        make.height.equalTo(@23);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];

    
}
- (void)pvt_buildBottomLayout {

    UIView *contentView = self.bottomView;
    UIButton *cleanupButton = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];

    // config control
    confirmButton.backgroundColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];

    // bind event
    [cleanupButton setTitle:@" 合买" forState:UIControlStateNormal];
    [cleanupButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"group.png")] forState:UIControlStateNormal];
    [cleanupButton setTitleColor:[UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [cleanupButton.titleLabel setFont:[UIFont dp_systemFontOfSize:15]];

    cleanupButton.backgroundColor = [UIColor clearColor];
    [cleanupButton addTarget:self action:@selector(pvt_togetherBuy) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(pvt_submitss) forControlEvents:UIControlEventTouchUpInside];

    // move to view
    [contentView addSubview:cleanupButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.bottomLabel];
    [contentView addSubview:confirmView];
    [contentView addSubview:lineView];

    // layout
    [cleanupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(9);
        make.bottom.equalTo(contentView).offset(-9);
        make.left.equalTo(contentView).offset(8);
        make.width.equalTo(@60);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(cleanupButton.mas_right).offset(8);
        make.right.equalTo(contentView);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton).offset(10);
        make.right.equalTo(contentView).offset(-40);
        make.centerY.equalTo(confirmButton);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmButton).offset(-20);
        make.centerY.equalTo(confirmButton);
        make.width.equalTo(@23.5);
        make.height.equalTo(@23);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
}
- (void)pvt_bulidOption {

    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.tag = 1001;
    [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"uncheck.png")] forState:UIControlStateNormal];
    [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"check.png")] forState:UIControlStateSelected];
    button.selected = NO;
    [button setTitle:@"中奖后停止" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.74 green:0.72 blue:0.67 alpha:1.0]  forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont dp_systemFontOfSize:12.0];
    if (self.digitalType==GameTypeJxsyxw) {
        button.selected=YES;
    }
    self.afterWinStop=button.selected;
    [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.optionView addSubview:button];

    UIView *midLine = ({
        [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    });
    midLine.alpha = 0;
    _midlleLine = midLine;
    [self.optionView addSubview:midLine];

    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.optionView).offset(24.5);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.optionView);
        make.right.equalTo(self.optionView);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.optionView);
        make.height.equalTo(@24);
        make.left.equalTo(self.optionView).offset(5);
        make.width.equalTo(@94.5);
    }];

    NSArray *option128 = nil ;
    NSArray *array = nil ;
    if (self.digitalType == GameTypeDlt || self.digitalType == GameTypeSsq || self.digitalType == GameTypeQlc || self.digitalType == GameTypeQxc) {
       
        option128 = @[ [DPDigitalIssueControl twoRowControl], [DPDigitalIssueControl twoRowControl], [DPDigitalIssueControl twoRowControl] ];
        [option128 enumerateObjectsUsingBlock:^(DPDigitalIssueControl *obj, NSUInteger idx, BOOL *stop) {
            [self.optionView addSubview:obj];
        }];
       array = [NSArray arrayWithObjects:@"追一个月|13期", @"追三个月|40期", @"追一年|153期", nil];
    }else{
        option128 = @[ [self createIssueButton], [self createIssueButton], [self createIssueButton] ];
        [option128 enumerateObjectsUsingBlock:^(DPDigitalIssueControl *obj, NSUInteger idx, BOOL *stop) {
            [self.optionView addSubview:obj];
        }];
        array = [NSArray arrayWithObjects:@" 10期", @" 50期", @" 100期", nil];

    }

    for (int i = 0; i < option128.count; i++) {
        
        if (self.digitalType == GameTypeDlt || self.digitalType == GameTypeSsq || self.digitalType == GameTypeQlc || self.digitalType == GameTypeQxc) {
            
            DPDigitalIssueControl *obj = option128[i];
            obj.tag = 1200 + i;
            NSArray *arrayInfo = [[array objectAtIndex:i] componentsSeparatedByString:@"|"];
            if (arrayInfo.count < 2) {
                return;
            }
            obj.titleText = [arrayInfo objectAtIndex:0];
            obj.oddsText = [arrayInfo objectAtIndex:1];
            obj.titleColor = [UIColor dp_flatBlackColor];
            obj.oddsColor = [UIColor colorWithRed:0.74 green:0.72 blue:0.67 alpha:1.0];
            obj.selected = NO;
            [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.optionView).multipliedBy(0.333);
                make.height.equalTo(@35);
                make.bottom.equalTo(self.optionView);
                if (i == 1) {
                    make.centerX.equalTo(self.optionView);
                }
            }];
            if (i >= option128.count - 1) {
                
                continue;
            }
            UIImageView *line = [[UIImageView alloc] init];
            line.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0];
            [self.optionView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(obj);
                make.height.equalTo(@35);
                make.left.equalTo(obj.mas_right).offset(-0.5);
                make.width.equalTo(@0.5);
            }];
            DPDigitalIssueControl *obj1 = option128[i];
            DPDigitalIssueControl *obj2 = option128[i + 1];
            
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];



        }else
        {
            UIButton *obj = option128[i];
            obj.tag = 1200 + i;
            
            [obj setTitle: [array objectAtIndex:i] forState:UIControlStateNormal];
            [obj setTitle: [array objectAtIndex:i] forState:UIControlStateSelected];
            obj.selected = NO;
            [obj addTarget:self action:@selector(pvt_singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.optionView).multipliedBy(0.333);
                make.height.equalTo(@35);
                make.bottom.equalTo(self.optionView);
                if (i == 1) {
                    make.centerX.equalTo(self.optionView);
                }
            }];
            
            
            if (i >= option128.count - 1) {
                
                continue;
            }
            UIImageView *line = [[UIImageView alloc] init];
            line.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0];
            [self.optionView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(obj);
                make.height.equalTo(@35);
                make.left.equalTo(obj.mas_right).offset(-0.5);
                make.width.equalTo(@0.5);
            }];
            DPDigitalIssueControl *obj1 = option128[i];
            DPDigitalIssueControl *obj2 = option128[i + 1];
            
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];

        
        }
        
        
    }
}

-(UIButton *)createIssueButton{
    UIButton *button=[[UIButton alloc]init];
    [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
    [button setImage:nil forState:UIControlStateNormal];
    [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"selectedIssue001_11.png")] forState:UIControlStateSelected];
    return button;
}

- (void)pvt_singleButtonClick:(id)sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *bet = (UIButton *)sender;
        NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:50], [NSNumber numberWithInt:100], nil];
        bet.backgroundColor = [UIColor clearColor];
        int index = bet.tag - 1200;
        if (index < array.count) {
            self.addIssueTextField.text = [NSString stringWithFormat:@"%d", [[array objectAtIndex:index] integerValue]];
        }
        for (int i = 0; i < 3; i++) {
            UIButton *allBet = (UIButton *)[self.optionView viewWithTag:1200 + i];
            allBet.selected = NO;
        }
        bet.selected = YES;

    }else if ([sender isKindOfClass:[DPDigitalIssueControl class]]){
    
        DPDigitalIssueControl *bet = (DPDigitalIssueControl *)sender;
        NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:13], [NSNumber numberWithInt:40], [NSNumber numberWithInt:153], nil];
        bet.backgroundColor = [UIColor clearColor];
        int index = bet.tag - 1200;
        if (index < array.count) {
            self.addIssueTextField.text = [NSString stringWithFormat:@"%d", [[array objectAtIndex:index] integerValue]];
        }
        for (int i = 0; i < 3; i++) {
            DPDigitalIssueControl *allBet = (DPDigitalIssueControl *)[self.optionView viewWithTag:1200 + i];
            allBet.selected = NO;
            allBet.selectView.hidden = YES;
        }
        bet.selected = YES;
        bet.selectView.hidden = NO;

    }
    
    
    [self calculateAllZhushuWithZj:self.addButton.selected];
}

- (UIView *)mulAndIssueView {
    if (_mulAndIssueView == nil) {
        _mulAndIssueView = [[UIView alloc] init];
        _mulAndIssueView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _mulAndIssueView;
}
- (UIView *)optionView {
    if (_optionView == nil) {
        _optionView = [[UIView alloc] init];
        _optionView.backgroundColor = [UIColor dp_flatBackgroundColor];
    }
    return _optionView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}
- (UITableView *)issureTableView {
    if (_issureTableView == nil) {
        _issureTableView = [[UITableView alloc] init];
        _issureTableView.backgroundColor = [UIColor clearColor];
        _issureTableView.delegate = self;
        _issureTableView.dataSource = self;
        _issureTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIView *contentView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
            view.backgroundColor = [UIColor clearColor];
            view;
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
        [contentView addSubview:proLabel];
        [contentView addSubview:agreementButton];
        [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.centerY.equalTo(contentView);
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(proLabel.mas_left);
            make.centerY.equalTo(proLabel);
        }];
        _issureTableView.tableFooterView = contentView;
    }
    return _issureTableView;
}
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UIImageView *)addyizhuView {
    if (_addyizhuView == nil) {
        _addyizhuView = [[UIImageView alloc] init];
        _addyizhuView.backgroundColor = [UIColor clearColor];
        _addyizhuView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"addyiZhuBall.png")];
    }
    return _addyizhuView;
}

- (TTTAttributedLabel *)bottomLabel {
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
- (UILabel *)labelWithText:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    label.text = title;
    return label;
}
/**
 *  点击显示说明·
 
 *
 *  @param button <#button description#>
 */
-(void)pvt_introduceClick:(UIButton*)button
{
    DPLog(@"说明") ;
    
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    
    
    UIView* covvewView = [[UIView alloc]init];
    covvewView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6] ;

    [self.navigationController.view addSubview:covvewView];
    
    [covvewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
 
    IndroduceView * Intview = [[IndroduceView alloc]init];
    Intview.alpha = 1 ;
    Intview.backgroundColor = [UIColor blackColor] ;
    Intview.delegate = self ;
    [covvewView addSubview:Intview];
    
    [Intview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(covvewView);
        make.right.equalTo(covvewView);
        make.height.equalTo(@(240));
        make.centerY .equalTo(covvewView.mas_centerY) ;
    }];
    
    
}

-(void)cancle:(IndroduceView *)view
{
    
    [UIView animateWithDuration:0.2 animations:^{
        [view.superview setAlpha:0];
    } completion:^(BOOL finished) {
        [view.superview removeFromSuperview];
    }];
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
        case 0: {
            button.selected = !button.selected;
            self.addTouzhu = !self.addTouzhu;
            [self.issureTableView reloadData];

            [self calculateAllZhushuWithZj:button.selected];

        } break;
        case 1: {
            button.selected = !button.selected;
            self.afterWinStop = !self.afterWinStop;

        } break;
        case 2: {
            button.selected = !button.selected;
            _isSelectedPro=button.selected;

        } break;
        default:
            break;
    }
}
#pragma mark UITableViewDelete
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = [self gainOneRowHight:indexPath];
    return height > 0 ? height + 44 : 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", indexPath.row];
    DPDigitalBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[DPDigitalBuyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];

        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        //        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self touzhuInfotableCell:cell indexPath:indexPath];
//    [cell changeCurrentViewHeight:[self gainOneRowHight:indexPath] + 39.0];

    return cell;
}
- (float)gainOneRowHight:(NSIndexPath *)indexPath {
    float heigit = 55;
    return heigit;
}
//更新投注信息
- (void)touzhuInfotableCell:(DPDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {
}
- (void)pvt_add {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    [self addOneZhu];
}
//自选一注
- (void)addOneZhu {
}
//返回
- (void)pvt_onBack {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSmartPlan {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    [self pvt_hiddenCoverView:YES];
    if (_isSelectedPro == NO) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    
}

- (void)pvt_togetherBuy {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    [self pvt_hiddenCoverView:YES];
    int index=[self getPayTotalMoney];
    if (index<1) {
        [[DPToast makeText:@"请至少选择一注"]show];
        return ;
    }
    if ([self.addTimesTextField.text integerValue]<1) {
        [[DPToast makeText:@"请至少选择一倍"]show];
        return ;
    }
    
    if ([self.addIssueTextField.text integerValue]<1) {
        [[DPToast makeText:@"请至少选择一期"]show];
        return ;
    }
    if ([self.addIssueTextField.text integerValue]>1) {
        [[DPToast makeText:@"合买不能超过一期"]show];
        return ;
    }
    if (index*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue] > 2000000){
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;

    }
    if (_isSelectedPro == NO) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    
    [self.view endEditing:YES];
    
    __weak __typeof(self) weakSelf = self;
    void(^block)(void) = ^() {
       [weakSelf togetherType];
        int money=index*[weakSelf.addTimesTextField.text integerValue]*[weakSelf.addIssueTextField.text integerValue];
        DPTogetherBuySetController *vc=[[DPTogetherBuySetController alloc]init];
        vc.sum=money;
        vc.gameType=(GameTypeId)weakSelf.digitalType;
        [vc refreshResData];
//        DPSmartFollowVC *vc = [[DPSmartFollowVC alloc]init];
//        vc.gameType = smartZhGameType11X5;
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
- (void)pvt_submitss {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    int index=[self getPayTotalMoney];
    if (index<1) {
        [[DPToast makeText:@"请至少选择一注"]show];
        return ;
    }
    if ([self.addTimesTextField.text integerValue]<1) {
        [[DPToast makeText:@"请至少选择一倍"]show];
        return ;
    }
    if ([self.addIssueTextField.text integerValue]<1) {
        [[DPToast makeText:@"请至少选择一期"]show];
        return ;
    }
    if (index * self.addTimesTextField.text.intValue * self.addIssueTextField.text.intValue > 2000000) {
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    }
    if (!_isSelectedPro) {
        [[DPToast makeText:@"请勾选用户协议"]show];
        return;
    }
    [self.view endEditing:YES];
   
    __weak __typeof(self) weakSelf = self;
    void (^block)(void) = ^() {
        [weakSelf OrderInfoMultiple];
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
        int money = index * [weakSelf.addTimesTextField.text integerValue] * [weakSelf.addIssueTextField.text integerValue];
        if (money > 2000000) {
            [[DPToast makeText:dp_moneyLimitWarning] show];
            return;
        }
        
        int regindex = CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(weakSelf.digitalType, 1, money, 0);
        if (regindex < 0) {
            [[DPToast makeText:@"提交红包失败"] show];
            return;
        }
        [weakSelf showDarkHUD];
    };
    
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        block();
    } else {
        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
        viewController.finishBlock = block;
        [self.navigationController pushViewController:viewController animated:YES];
    }
  
}
-(void)togetherType{

}
- (int)toGoPayMoney {

    return 0;
}
- (int)getPayTotalMoney {
    return 0;
}
-(void)OrderInfoMultiple{

}
//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{

}

#pragma DPDigitalBuyCellDelegate

- (void)DPDigitalBuyDelegate:(DPDigitalBuyCell *)cell {
    [self deleteBuyCell:cell];
    
    [self  calculateAllZhushuWithZj:self.addButton.selected];
}
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)digitalRandomData {
}
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random() % ((total - i) == 0?1:(total-i));
        target[[array[x] integerValue]] = 1;
        [array removeObjectAtIndex:x];
    }
}

#pragma mark -UITextDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    float height = 0.0;
    self.optionView.hidden = YES;
    float alp = 0;
    if (textField == self.addIssueTextField) {
        height = 60;
        self.optionView.hidden = NO;
        alp = 1.0f;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pvt_adaptPassModeHeight:height];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            _midlleLine.alpha = alp;
            _bottomLine.alpha = alp;
        }];
    });
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
    });
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int aString = [newString intValue];
    if (textField == self.addTimesTextField) {
        if (aString > 1000) {
            textField.text = @"1000";
            [self calculateAllZhushuWithZj:YES];
            return NO;
        }
    }
    if (newString.length == 0) {
        textField.text = @"";
        [self calculateAllZhushuWithZj:YES];
        return NO;
    }
    if (aString <= 0) {
        textField.text = @"1";
        [self calculateAllZhushuWithZj:YES];
        return NO;
    }
    
    if (textField == self.addIssueTextField) {
        
        if (self.digitalType == GameTypeDlt || self.digitalType == GameTypeSsq || self.digitalType == GameTypeQlc || self.digitalType == GameTypeQxc) {
            for (int i = 0; i < 3; i++) {
                DPDigitalIssueControl *allBet = (DPDigitalIssueControl *)[self.optionView viewWithTag:1200 + i];
                allBet.selected = NO;
            }
            if (aString == 13) {
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1200];
                obj.selected = YES;
            }
            if (aString == 40) {
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1201];
                obj.selected = YES;
            }
            if (aString == 153) {
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1202];
                obj.selected = YES;
            }
            if (aString > 153) {
                self.addIssueTextField.text = @"153";
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1202];
                obj.selected = YES;
                [self calculateAllZhushuWithZj:self.addButton.selected];
                return NO;
            }

        }else{
        
            for (int i = 0; i < 3; i++) {
                DPDigitalIssueControl *allBet = (DPDigitalIssueControl *)[self.optionView viewWithTag:1200 + i];
                allBet.selected = NO;
                //
            }
            if (aString == 10) {
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1200];
                obj.selected = YES;
            }
            if (aString == 50) {
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1201];
                obj.selected = YES;
                
            }
            if (aString == 100) {
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1202];
                obj.selected = YES;
                
            }
            if (aString > 100) {
                self.addIssueTextField.text = @"100";
                DPDigitalIssueControl *obj = (DPDigitalIssueControl *)[self.view viewWithTag:1202];
                obj.selected = YES;
                [self calculateAllZhushuWithZj:self.addButton.selected];
                return NO;
            }

        }
        
    }
    newString = [NSString stringWithFormat:@"%d", aString];
    if ([textField.text isEqualToString:newString]) {
        textField.text = nil;   // fix iOS8
    }
    textField.text = newString;
//    if (textField == self.addTimesTextField) {
//        self.addTimesTextField.text=textField.text;
//    }
    [self calculateAllZhushuWithZj:self.addButton.selected];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.addIssueTextField) {
        [self pvt_adaptPassModeHeight:0];
        self.optionView.hidden = YES;
    }
    if ([textField.text integerValue] <= 0) {
        textField.text = @"1";
    }
    if ([self.addTimesTextField.text integerValue] > 1000) {
        self.addTimesTextField.text = @"1000";
    }
    if (self.digitalType == GameTypeDlt || self.digitalType == GameTypeSsq || self.digitalType == GameTypeQlc || self.digitalType == GameTypeQxc) {
   
        if ([self.addIssueTextField.text integerValue] > 153) {
            self.addIssueTextField.text = @"153";
        }
    }else
    {
        if ([self.addIssueTextField.text integerValue] > 100) {
            self.addIssueTextField.text = @"100";
        }
    }
    
    [self calculateAllZhushuWithZj:self.addButton.selected];

}
- (void)pvt_onTap {
    if (self.addIssueTextField.isEditing) {
        [self.addIssueTextField resignFirstResponder];
    }
    if (self.addTimesTextField.isEditing) {
        [self.addTimesTextField resignFirstResponder];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self pvt_hiddenCoverView:YES];
}
- (void)pvt_hiddenCoverView:(BOOL)hidden {
    if (hidden) {
        if (!self.coverView.hidden) {
            self.coverView.alpha = 1;
            [UIView animateWithDuration:0.2 animations:^{
                self.coverView.alpha = 0;
                _midlleLine.alpha = 0;
                _bottomLine.alpha = 0;
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
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.bottomView && obj.firstAttribute == NSLayoutAttributeBottom) {
            
            obj.constant = keyboardY - screenHeight;
            
            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
            [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
            
            *stop = YES;
        }
    }];
    if (keyboardY != UIScreen.mainScreen.bounds.size.height) {
        [self pvt_hiddenCoverView:NO];
    }else{
     [self pvt_hiddenCoverView:YES];
    }
}
- (void)pvt_adaptPassModeHeight:(float)height {
    [self.optionView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.optionView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
            *stop = YES;
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    DPLog(@"%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"DPDigitalIssueControl"]) {
        return NO;
    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewWrapperView"]) {
        return YES;
    }
    if ([touch.view isDescendantOfView:self.issureTableView]) {
        return NO;
    }
    return YES;
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        switch (cmdId) {
            case NOTIFY_TIMEOUT_LOTTERY: {
                if (self.timeSpace > 0) {
                    break;
                }
            }
            case NOTIFY_FINISH_LOTTERY: {
                [self recvRefresh:NO];
                [self alertGameName];
                [[NSNotificationCenter defaultCenter] postNotificationName:dp_DigitalBetRefreshNofify object:nil];
            }
                return;
            default:
                break;
        }
        switch (cmdType) {
            case ACCOUNT_RED_PACKET: {
                if (ret < 0) {
                    [self dismissDarkHUD];
                    [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                    break;
                }
                [self dismissDarkHUD];
                int index = [self getPayTotalMoney];
                int money = index * [self.addTimesTextField.text integerValue] * [self.addIssueTextField.text integerValue];
                BOOL isRedpacket=NO;
                if (moduleInstance->GetPayRedPacketCount()) {
                    isRedpacket=YES;
                }
//                else {
//                    int code = [self toGoPayMoney];
//                    if (code < 0) {
//                        [self dismissDarkHUD];
//                        [[DPToast makeText:DPGoPayErrorMsg(code)] show];
//                    }
//                }
                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                viewController.gameTypeText = dp_GameTypeFullName((GameTypeId)self.digitalType);
                viewController.projectAmount = money;
                viewController.delegate = self;
                viewController.isredPacket=isRedpacket;
                viewController.gameType = (GameTypeId)self.digitalType;
                if (self.addIssueTextField.text.intValue > 1) {
                    viewController.entryType = kEntryTypeFollow;
                }
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
//            case GOPLAY: {
//                [self dismissDarkHUD];
//                if (ret < 0) {
//                    if (ret==ERROR_NO_DATA) {
//                        [[DPToast makeText:@"未取到期号"] show];
//                    }else if(ret==ERROR_PARAMETER){
//                    [[DPToast makeText:@"数据错误"] show];
//                    }else{
//                    [[DPToast makeText:DPPaymentErrorMsg(ret)] show];
//                    }
//                } else {
//                    [self goPayCallback];
//                }
//            } break;
            case REFRESH: {
                if (ret >= 0) {
                    [self recvRefresh:NO];
                    [self alertGameName];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:dp_DigitalBetRefreshNofify object:nil];
                } else {
                    self.timeSpace = -60;
                }
            } break;
            default:
                break;
        }
    });
}

- (void)alertGameName {
    BOOL showAlert = NO;
    int lastGameName = 0, currGameName = 0; string drawTime;
    switch (self.digitalType) {
        case GameTypeSsq: {
            int ret = CFrameWork::GetInstance()->GetDoubleChromosphere()->GetGameStatus(lastGameName, currGameName, drawTime);
            if (ret == 2 && g_ssqLastGameName != currGameName) {
                g_ssqLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        case GameTypeDlt: {
            int ret = CFrameWork::GetInstance()->GetSuperLotto()->GetGameStatus(lastGameName, currGameName, drawTime);
            if (ret == 2 && g_dltLastGameName != currGameName) {
                g_dltLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        case GameTypeQlc: {
            int ret = CFrameWork::GetInstance()->GetSevenLuck()->GetGameStatus(lastGameName, currGameName, drawTime);
            if (ret == 2 && g_qlcLastGameName != currGameName) {
                g_qlcLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        case GameTypeQxc: {
            int ret = CFrameWork::GetInstance()->GetSevenStar()->GetGameStatus(lastGameName, currGameName, drawTime);
            if (ret == 2 && g_qxcLastGameName != currGameName) {
                g_qxcLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        case GameTypeSd: {
            int ret = CFrameWork::GetInstance()->GetLottery3D()->GetGameStatus(lastGameName, currGameName, drawTime);
            if (ret == 2 && g_sdLastGameName != currGameName) {
                g_sdLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        case GameTypePs: {
            int ret = CFrameWork::GetInstance()->GetPick3()->GetGameStatus(lastGameName, currGameName, drawTime);
            if (ret == 2 && g_psLastGameName != currGameName) {
                g_psLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        case GameTypePw: {
            int ret = CFrameWork::GetInstance()->GetPick5()->GetGameStatus(lastGameName, currGameName, drawTime);
            if (ret == 2 && g_pwLastGameName != currGameName) {
                g_pwLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        case GameTypeJxsyxw: {
            int ret = CFrameWork::GetInstance()->GetJxsyxw()->GetGameStatus(currGameName, drawTime);
            if (ret < 0) {
                DPLog(@"333");
                break;
            }
            if (g_jxsyxwLastGameName == 0) {
                g_jxsyxwLastGameName = currGameName;
            }
            if (g_jxsyxwLastGameName != currGameName) {
                lastGameName = g_jxsyxwLastGameName;
                g_jxsyxwLastGameName = currGameName;
                showAlert = YES;
            }
        }
            break;
        default:
            break;
    }
    
    UIViewController *currentController = self.navigationController.viewControllers.lastObject;
    if (!(currentController == self) && // 中转界面
        ![self isBuyController:currentController] && // 投注界面
        ![currentController isKindOfClass:[DPTogetherBuySetController class]] &&    // 合买设置界面
        ![currentController isKindOfClass:[DPSmartFollowVC class]]) {   // 智能追号界面
        return;
    }
    
    if (showAlert) {
        DPLog(@"跨期弹框提示");
        NSString *gameName = dp_GameTypeFullName((GameTypeId)self.digitalType);
        NSString *time = [NSDate dp_coverDateString:[NSString stringWithUTF8String:drawTime.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm];
        NSString *msg = [NSString stringWithFormat:@"尊敬的用户, %@第%d期已截止, %d期预售中, 预计开奖时间: %@", gameName, lastGameName, currGameName, time];
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [av show];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [av dismissWithClickedButtonIndex:0 animated:YES];
//        });
        
        UIView* smartView = ({
                    DPSmartCountSureView * view = [[DPSmartCountSureView alloc]init];
            view.alertText = msg ;
            view ;
        }) ;
        [self.navigationController.view.window addSubview:smartView];
        [smartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//            make.edges.equalTo(self.navigationController.view.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (smartView) {
                [smartView removeFromSuperview];
            }
        });


//        [[DPToast makeText:msg] show];
    }
}

- (NSString *)orderInfoUrl {
    return @"";
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
//    DPAssertMsg(NO, @"子类需实现");
}

- (MSWeakTimer *)timer {
    if (_timer == nil) {
        _timer = [[MSWeakTimer alloc] initWithTimeInterval:1 target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    }
    return _timer;
}
- (void)pvt_reloadTimer {
    DPLog(@"当前倒计时: %d", self.timeSpace);
    
//    if (self.timeSpace == 8) {
//        if (self.digitalType == GameTypeJxsyxw) {
//            DPLog(@"TimeOut");
//            CFrameWork::GetInstance()->GetJxsyxw()->TimeOut();
//        }
//    }
    if (self.timeSpace > 0) {
        
        self.timeSpace--;
    } else if (self.timeSpace < 0) {
        
        self.timeSpace++;
    } else if (self.timeSpace == 0) {
        DPLog(@"self.timeSpace == 0");
        
        if (self.digitalType != GameTypeJxsyxw) {
            [self sendRefresh];
        } else {
            DPLog(@"GameTypeJxsyxw");
            
            [self sendRefresh];
            [self recvRefresh:NO];
            [self alertGameName];
            [[NSNotificationCenter defaultCenter] postNotificationName:dp_DigitalBetRefreshNofify object:nil];
        }
        
        if (self.timeSpace == 0) {
            self.timeSpace = -60;   // 无数据1分钟后刷新
        }
    }
    
    if ((self.digitalType == GameTypeSsq || self.digitalType == GameTypeDlt || self.digitalType == GameTypeJxsyxw) && self.navigationController.viewControllers.lastObject != self) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *nextViewController = self.navigationController.viewControllers[index + 1];
        if ([self isBuyController:nextViewController]) {
            [nextViewController performSelector:@selector(pvt_reloadTimer) withObject:nil];
        } else if ([nextViewController isKindOfClass:[DPSmartFollowVC class]]) {
            [nextViewController performSelector:@selector(pvt_reloadTimer) withObject:nil];
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return NO;
}

#pragma mark - DPRedPacketViewControllerDelegate

- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType {
    if (ret >= 0) {
        [self goPayCallback];
    }
}

- (void)goPayCallback {
    NSString *ulrString = [self orderInfoUrl];
    if (ulrString.length < 1) {
        [[DPToast makeText:@"返回网址为空"] show];
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ulrString]];
    kAppDelegate.gotoHomeBuy = YES;
}

@end

