//
//  DPElevnSelectFiveVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
// 高频11选5

#import "DPElevnSelectFiveVC.h"
#import "DPElevnSelectFiveTransferVC.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "../../Common/View/DPNavigationTitleButton.h"
#import "../../Common/View/DPNavigationMenu.h"
#import "DPSdHistoryTrendCell.h"
#import "DPSyxwBuyCell.h"
#import "FrameWork.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"
#import "NotifyType.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DPDigitalCommon.h"
#import "BaseMath.h"

#define TrendDragHeight  250


static NSArray *syxwTypeNames = @[@"前一",@"前二直选",@"前二组选",@"前三直选",@"前三组选",@"任选二", @"任选三", @"任选四" ,@"任选五",@"任选六",@"任选七",@"任选八"];
@interface DPElevnSelectFiveVC () <UITableViewDelegate, UITableViewDataSource, DPNavigationMenuDelegate, DPSyxwBuyCellDelegate, DPDropDownListDelegate, UIGestureRecognizerDelegate>{
  @private
    DPNavigationMenu *_titleMenu;
    DPNavigationTitleButton *_titleButton;
    
    UIView *_drawedView;
    
    UITableView *_trendView;
    
    UITableView *_tableView;
    UIView *_controlView;
    TTTAttributedLabel *_bonusLabel;
    SevenSwitch *_missSwitch;
    
    UIView *_submitView;
    
    NSLayoutConstraint *_tableConstraint;
    CJxsyxw *_CJXInstance;
    int _renxuan2[11];
    int _renxuan3[11];
    int _renxuan4[11];
    int _renxuan5[11];
    int _renxuan6[11];
    int _renxuan7[11];
    int _renxuan8[11];
    int _direct1[11];
    int _direct2[22];
    int _direct3[33];
    int _group2[11];
    int _group3[11];
}
@property (nonatomic, strong, readonly) DPNavigationMenu *titleMenu;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;

@property (nonatomic, strong, readonly) UIView *drawedView;
@property (nonatomic, strong, readonly) UILabel *drawedLabel;
@property (nonatomic, strong) TTTAttributedLabel *endTimeLabel;

@property (nonatomic, strong, readonly) UITableView *trendView;

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *controlView;
@property (nonatomic, strong, readonly) TTTAttributedLabel *bonusLabel;
@property (nonatomic, strong, readonly) SevenSwitch *missSwitch;

@property (nonatomic, strong, readonly) UIView *submitView;

@property (nonatomic, strong, readonly) NSLayoutConstraint *tableConstraint;

@property (nonatomic, assign) SyxwType sdType;
@property (nonatomic, assign) BOOL showHistory;
@end

@implementation DPElevnSelectFiveVC
@synthesize zhushuLabel=_zhushuLabel;
@synthesize gameIndex=_gameIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _CJXInstance = CFrameWork::GetInstance()->GetJxsyxw();
       
        [self ClearAllSelectedData];
        [self setSdType:SyxwTypeRenxuan2];
        self.targetIndex = -1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotify) name:dp_DigitalBetRefreshNofify object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_DigitalBetRefreshNofify object:nil];
}


-(void)ClearAllSelectedData{
    for (int i = 0; i < 11; i++) {
        _renxuan2[i]=0;
        _renxuan3[i]=0;
        _renxuan4[i]=0;
        _renxuan5[i]=0;
        _renxuan6[i]=0;
        _renxuan7[i]=0;
        _renxuan8[i]=0;
        _direct1[i]=0;
        _direct2[i * 2] = 0;
        _direct2[i * 2 + 1] = 0;
        _direct3[i * 3] = 0;
        _direct3[i * 3 + 1] = 0;
        _direct3[i * 3 + 2] = 0;
        _group2[i] = 0;
        _group3[i] = 0;
    }

}
-(void)setSdType:(SyxwType)sdType{
    _sdType=sdType;
    switch (sdType) {
        case SyxwTypeRenxuan2:
            _gameIndex=5;
            break;
        case SyxwTypeRenxuan3:
            _gameIndex=6;
            break;
        case SyxwTypeRenxuan4:
            _gameIndex=7;
            break;
        case SyxwTypeRenxuan5:
            _gameIndex=8;
            break;
        case SyxwTypeRenxuan6:
           _gameIndex=9;
            break;
        case SyxwTypeRenxuan7:
           _gameIndex=10;
            break;
        case SyxwTypeRenxuan8:
           _gameIndex=11;
            break;
        case SyxwTypeZhixuan1:
           _gameIndex=0;
            break;
        case SyxwTypeZhixuan2:
           _gameIndex=1;
            break;
        case SyxwTypeZhixuan3:
           _gameIndex=3;
            break;
        case SyxwTypeZuxuan2:
            _gameIndex=2;
            break;
        case SyxwTypeZuxuan3:
            _gameIndex=4;
            break;
        default:
            DPAssert(NO);
            break;
    }
}
-(void)setGameIndex:(NSInteger)gameIndex{
     _gameIndex = gameIndex;
    switch (gameIndex) {
        case 0:
            _sdType=SyxwTypeZhixuan1;
            break;
        case 1:
            _sdType=SyxwTypeZhixuan2;
            break;
        case 3:
            _sdType=SyxwTypeZhixuan3;
            break;
        case 2:
            _sdType=SyxwTypeZuxuan2;
            break;
        case 4:
            _sdType=SyxwTypeZuxuan3;
            break;
        case 5:
            _sdType=SyxwTypeRenxuan2;
            break;
        case 6:
            _sdType=SyxwTypeRenxuan3;
            break;
        case 7:
            _sdType=SyxwTypeRenxuan4;
            break;
        case 8:
            _sdType=SyxwTypeRenxuan5;
            break;
        case 9:
            _sdType=SyxwTypeRenxuan6;
            break;
        case 10:
            _sdType=SyxwTypeRenxuan7;
            break;
        case 11:
            _sdType=SyxwTypeRenxuan8;
            break;
        
        default:
            DPAssert(NO);
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self calculateZhushu];
    [self.titleMenu setSelectedIndex:self.gameIndex];
    [self.titleButton setTitleText:syxwTypeNames[self.gameIndex]];
    [self.tableView reloadData];
    [self pvt_reloadBonusLabel];
    [self canBecomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf9f8ee);//[UIColor dp_flatBackgroundColor];
    
    UIView *contentView = self.view;
    
    [contentView addSubview:self.drawedView];
    [contentView addSubview:self.trendView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.submitView];
    UIView* lineView = ({
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor dp_colorFromRGB:0xE1D7C2] ;
        view ;
    }) ;
    [contentView addSubview:lineView];
    [self.drawedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@25);
    }];
    
    [self.trendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.drawedView.mas_bottom);
        make.bottom.equalTo(self.submitView.mas_top);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.drawedView.mas_bottom);
        make.bottom.equalTo(self.submitView.mas_top);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5) ;
        make.width.equalTo(self.view) ;
        make.left.equalTo(self.view) ;
        make.bottom.equalTo(self.trendView.mas_top).offset(0.5) ;
        
    }] ;
    
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@45);
    }];
    
    [self pvt_navigationDidLoad];
    [self pvt_drawedViewDidLoad];
    [self pvt_submitViewDidLoad];
    [self pvt_controlViewDidLoad];
    
    [self pvt_reloadBonusLabel];
    
    if (self.targetIndex >= 0) {
        SyxwType subType;
        int num[33];
        int note;
        _CJXInstance->GetTarget(self.targetIndex, num, num + 11, num + 22,subType,note);
        
        self.sdType = (SyxwType)subType;
        switch (self.sdType) {
            case SyxwTypeRenxuan2:
                memcpy(_renxuan2, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan3:
                memcpy(_renxuan3, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan4:
                memcpy(_renxuan4, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan5:
                 memcpy(_renxuan5, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan6:
                 memcpy(_renxuan6, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan7:
                 memcpy(_renxuan7, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan8:
                 memcpy(_renxuan8, num, sizeof(int) * 11);
                break;
            case SyxwTypeZhixuan1:
                 memcpy(_direct1, num, sizeof(int) * 11);
                break;
            case SyxwTypeZhixuan2:
                 memcpy(_direct2, num, sizeof(int) * 22);
                break;
            case SyxwTypeZhixuan3:
                 memcpy(_direct3, num, sizeof(int) * 33);
                break;
            case SyxwTypeZuxuan2:
                 memcpy(_group2, num, sizeof(int) * 11);
                break;
            case SyxwTypeZuxuan3:
                memcpy(_group3, num, sizeof(int) * 11);
                break;
            default:
                break;
        }
    }
}

- (void)pvt_navigationDidLoad {
    if (self.isTransfer || self.navigationController.viewControllers.count > 2) {
        [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onHome)]];
    } else {
        [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onHome)]];
    }
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)]];
    [self.navigationItem setTitleView:self.titleButton];
    
    [self.titleButton setTitleText:syxwTypeNames[self.sdType]];
    [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];
}
- (void)pvt_drawedViewDidLoad {
    TTTAttributedLabel *hintLabel1 = [[TTTAttributedLabel alloc] init];
    [hintLabel1 setNumberOfLines:0];
    [hintLabel1 setTextColor:[UIColor dp_flatRedColor]];
    [hintLabel1 setFont:[UIFont systemFontOfSize:11.0f]];
    [hintLabel1 setBackgroundColor:[UIColor clearColor]];
    [hintLabel1 setTextAlignment:NSTextAlignmentLeft];
    [hintLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
     hintLabel1.userInteractionEnabled=NO;
    self.endTimeLabel = hintLabel1;
    [self.view addSubview:hintLabel1];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(2);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-2);
        make.height.equalTo(@22);
    }];

}

- (void)pvt_controlViewDidLoad {
    UIView *contentView = self.view;
    
    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.84 blue:0.76 alpha:1];
        view;
    });
    UIButton *indicateButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateNormal];
        [button setImage:dp_DigitLotteryImage(@"digitalPage001_03.png") forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(pvt_onTrend) forControlEvents:UIControlEventTouchUpInside];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 20, 5)];
        button;
    });
    [contentView addSubview:line];
    [contentView addSubview:indicateButton];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.tableView);
        make.height.equalTo(@0.5);
    }];
    [indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    
    contentView = self.controlView;
    
    UILabel *missCommentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"遗漏";
        label.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.37 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:10];
        label;
    });
    
    [contentView addSubview:self.bonusLabel];
    [contentView addSubview:missCommentLabel];
    [contentView addSubview:self.missSwitch];
    self.missSwitch.on = YES ;
    
    [missCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.missSwitch.mas_left).offset(-3);
        make.centerY.equalTo(contentView).offset(-12);
    }];
    [self.missSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(8);
        make.right.equalTo(contentView).offset(-20);
        make.width.equalTo(@52);
        make.height.equalTo(@25);
    }];
    
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.missSwitch.mas_bottom).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
        make.left.equalTo(contentView).offset(10);
//        make.right.equalTo(contentView).offset(-10) ;
    }];
   
    UIButton *randomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    randomButton.backgroundColor = [UIColor clearColor];
    [randomButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"randomSharkoff.png")] forState:UIControlStateNormal];
    [randomButton addTarget:self action:@selector(digitalDataRandom) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:randomButton];
    [randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.missSwitch);
        make.left.equalTo(contentView).offset(-1);
        make.height.equalTo(@27);
        make.width.equalTo(@111);
    }];

    self.tableView.tableHeaderView = self.controlView;
    
   }

- (void)pvt_submitViewDidLoad {
    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.84 blue:0.76 alpha:1];
        view;
    });
    UIButton *deleteButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:dp_CommonImage(@"delete001_21.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onClear) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *submitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIImageView *submitImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"sumit001_24.png")];
        imageView;
    });
    
    UIView *contentView = self.submitView;
    
    [contentView addSubview:deleteButton];
    [contentView addSubview:submitButton];
    [contentView addSubview:self.zhushuLabel];
    [contentView addSubview:submitImageView];
    [contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@55);
    }];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(deleteButton.mas_right);
        make.right.equalTo(contentView);
    }];
    [self.zhushuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(submitButton).offset(10);
        make.centerY.equalTo(submitButton);
    }];
    [submitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-15);
    }];
}

//
- (void)pvt_reloadBonusLabel {
    NSString *bonus=@"";
    switch (self.sdType) {
        case SyxwTypeRenxuan2:
            bonus=@"至少选2个号码,猜对任意2个开奖号码即中6元";
            break;
        case SyxwTypeRenxuan3:
//            bonus=@"竞猜开奖号码的前面三位，选择3个或以上,即中19元";
            bonus=@"至少选3个号码,猜对任意3个开奖号码即中19元";
            break;
        case SyxwTypeRenxuan4:
            bonus=@"至少选4个号码,猜对任意4个开奖号码即中78元";
            break;
        case SyxwTypeRenxuan5:
            bonus=@"至少选5个号码,猜对全部中奖号码即中540元";
            break;
        case SyxwTypeRenxuan6:
            bonus=@"至少选6个号码,猜对全部中奖号码即中90元";

            break;
        case SyxwTypeRenxuan7:
             bonus=@"至少选择7个号码,猜对全部中奖号码即中26元";
            break;
        case SyxwTypeRenxuan8:
            bonus=@"至少选择8个号码,猜对全部中奖号码即中9元";

            break;
        case SyxwTypeZhixuan1:
            bonus=@"至少选1个号，猜对开奖号码第1位即中13元";

            break;
        case SyxwTypeZhixuan2:
             bonus=@"竞猜开奖号码的前面两位且位置一致,即中130元";

            break;
        case SyxwTypeZhixuan3:
            bonus=@"竞猜开奖号码的前面三位且位置一致即中1170元";

            break;
        case SyxwTypeZuxuan2:
            bonus=@"至少选2个号，猜对开奖号码前2位即中65元";
            break;
        case SyxwTypeZuxuan3:
            bonus=@"至少选3个号，猜对前3位开奖号码即中195元";

            break;
        default:
            break;

    }
    NSMutableAttributedString *bonusString = [[NSMutableAttributedString alloc] initWithString:bonus];
//    NSRange numberRange = [[bonusString string] rangeOfString:@"1000" options:NSCaseInsensitiveSearch];
        [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] CGColor] range:NSMakeRange(0, bonusString.length)];
//    [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:numberRange];
    
    [self.bonusLabel setText:bonusString];
    
    
}

// event
- (void)pvt_onHome {
    if (self.isTransfer) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.navigationController.viewControllers.count == 2) {
        if (![self hasSelectedNum]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return ;
        }
        
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
        [self.navigationController popToViewController:viewController animated:YES];
    }
}

#pragma mark - 菜单

- (void)pvt_onMore {
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];
    
    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:@[@"开奖公告", @"玩法介绍", @"帮助"]];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view);
    }];
    
    [coverView addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
        tap.delegate = self;
        tap;
    })];
}

- (void)pvt_onCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - DPDropDownListDelegate
- (void)dropDownList:(DPDropDownList *)dropDownList selectedAtIndex:(NSInteger)index {
    [dropDownList.superview removeFromSuperview];
    
    UIViewController *viewController;
    
    switch (index) {
        case 0: {   // 开奖公告
            viewController = ({
                DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
                viewController.gameType = GameTypeJxsyxw;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        }
            break;
        case 1: {   // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeJxsyxw)]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO ;

                viewController;
            });
        }
            break;
        case 2: {   // 帮助
            viewController = [[DPHelpWebViewController alloc] init];
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pvt_onNavTitle {
    [self.titleButton turnArrow];
    [self.titleMenu setViewController:self];
    [self.titleMenu show];
}

- (void)pvt_onSwitch {
    [self.tableView reloadData];
}

- (void)pvt_onTrend {
    if (self.showHistory) {
        self.tableConstraint.constant = 0;
    } else {
        self.tableConstraint.constant = TrendDragHeight;
    }
    
    self.showHistory = self.tableConstraint.constant == TrendDragHeight;
    
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)pvt_onSubmit {
    if ([self calculateZhushu]<1) {
          [[DPToast makeText:@"至少选择一注"] show];
            return;
    }
    int index=-1;
    switch (self.sdType) {
        case SyxwTypeRenxuan2: {
            if (self.targetIndex<0) {
               index= _CJXInstance->AddTarget(_renxuan2,NULL, NULL, self.sdType);
            
            }else{
            index=_CJXInstance->ModifyTarget(self.targetIndex, _renxuan2, NULL, NULL, self.sdType);
           }
        }
            break;
        case SyxwTypeRenxuan3: {
            if (self.targetIndex<0) {
              index=_CJXInstance->AddTarget(_renxuan3, NULL, NULL, self.sdType);
            }else{
                index=_CJXInstance->ModifyTarget(self.targetIndex, _renxuan3, NULL, NULL, self.sdType);
        
            }
        }
            break;
        case SyxwTypeRenxuan4: {
            if (self.targetIndex<0) {
              index= _CJXInstance->AddTarget(_renxuan4, NULL, NULL, self.sdType);
            }else{
            index=_CJXInstance->ModifyTarget(self.targetIndex, _renxuan4, NULL, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeRenxuan5: {
            if (self.targetIndex<0) {
               index= _CJXInstance->AddTarget(_renxuan5, NULL, NULL, self.sdType);
                
            }else{
            index=_CJXInstance->ModifyTarget(self.targetIndex, _renxuan5, NULL, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeRenxuan6: {
            if (self.targetIndex<0) {
              index= _CJXInstance->AddTarget(_renxuan6, NULL, NULL, self.sdType);
            }else{
            
                 index=_CJXInstance->ModifyTarget(self.targetIndex, _renxuan6, NULL, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeRenxuan7: {
            if (self.targetIndex<0) {
               index=_CJXInstance->AddTarget(_renxuan7, NULL, NULL, self.sdType);
            }else{
            index=_CJXInstance->ModifyTarget(self.targetIndex, _renxuan7, NULL, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeRenxuan8: {
            if (self.targetIndex<0) {
                index=_CJXInstance->AddTarget(_renxuan8, NULL, NULL, self.sdType);
               
            }else{
            index=_CJXInstance->ModifyTarget(self.targetIndex, _renxuan8, NULL, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeZhixuan1: {
            if (self.targetIndex<0) {
              index= _CJXInstance->AddTarget(_direct1, NULL, NULL, self.sdType);
            }else{
           index= _CJXInstance->ModifyTarget(self.targetIndex, _direct1, NULL, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeZhixuan2: {
            if (self.targetIndex<0) {
               index=_CJXInstance->AddTarget(_direct2, _direct2 + 11,NULL, self.sdType);
            }else{
            index=_CJXInstance->ModifyTarget(self.targetIndex, _direct2, _direct2 + 11, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeZhixuan3: {
            if (self.targetIndex<0) {
             index= _CJXInstance->AddTarget(_direct3, _direct3 + 11, _direct3 + 22, self.sdType);
            }else{
            index=_CJXInstance->ModifyTarget(self.targetIndex, _direct3, _direct3 + 11,  _direct3 + 22, self.sdType);
            }
        }
            break;
        case SyxwTypeZuxuan2: {
            if (self.targetIndex<0) {
              index=_CJXInstance->AddTarget(_group2, NULL, NULL, self.sdType);
            }else{
             index=_CJXInstance->ModifyTarget(self.targetIndex, _group2, NULL, NULL, self.sdType);
            }
        }
            break;
        case SyxwTypeZuxuan3: {
            if (self.targetIndex<0) {
            index=_CJXInstance->AddTarget(_group3, NULL, NULL, self.sdType);
            }else{
           index=_CJXInstance->ModifyTarget(self.targetIndex, _group3, NULL, NULL, self.sdType);
            }
        }
            break; 
        
            break;
        default:
            break;
    }
    if (index>=0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [[DPToast makeText:@"提交失败"] show];
}

-(void)pvt_onClear
{
    switch (self.sdType) {
        case SyxwTypeRenxuan2: {
            for(int i=0;i<11;i++){
                _renxuan2[i]=0;
            }
        }
            break;
        case SyxwTypeRenxuan3: {
            for(int i=0;i<11;i++){
                _renxuan3[i]=0;
            }
        }
            break;
        case SyxwTypeRenxuan4: {
            for(int i=0;i<11;i++){
                _renxuan4[i]=0;
            }
        }
            break;
        case SyxwTypeRenxuan5: {
            for(int i=0;i<11;i++){
                _renxuan5[i]=0;
            }
        }
            break;
        case SyxwTypeRenxuan6: {
            for(int i=0;i<11;i++){
                _renxuan6[i]=0;
            }
        }
            break;
        case SyxwTypeRenxuan7: {
            for(int i=0;i<11;i++){
                _renxuan7[i]=0;
            }
        }
            break;
        case SyxwTypeRenxuan8: {
            for(int i=0;i<11;i++){
                _renxuan8[i]=0;
            }
        }
            break;
        case SyxwTypeZhixuan1: {
            for(int i=0;i<11;i++){
                _direct1[i]=0;
            }
        }
            break;
        case SyxwTypeZhixuan2: {
            for(int i=0;i<22;i++){
                _direct2[i]=0;
            }
        }
            break;
        case SyxwTypeZhixuan3: {
            for(int i=0;i<33;i++){
                _direct3[i]=0;
            }
        }
            break;
        case SyxwTypeZuxuan2: {
            for(int i=0;i<11;i++){
                _group2[i]=0;
            }
        }
            break;
        case SyxwTypeZuxuan3: {
            for(int i=0;i<11;i++){
                _group3[i]=0;
            }
        }
            break;
        default:
            break;
    }
    
    [self calculateZhushu];

    [self.tableView reloadData];
}
-(int)calculateZhushu{
    int zhushu=0;
    switch (self.sdType) {
        case SyxwTypeRenxuan2: {
        zhushu=_CJXInstance->NotesCalculate(_renxuan2,NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeRenxuan3: {
            zhushu=_CJXInstance->NotesCalculate(_renxuan3, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeRenxuan4: {
            zhushu=_CJXInstance->NotesCalculate(_renxuan4, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeRenxuan5: {
            zhushu=_CJXInstance->NotesCalculate(_renxuan5, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeRenxuan6: {
            zhushu=_CJXInstance->NotesCalculate(_renxuan6, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeRenxuan7: {
            zhushu=_CJXInstance->NotesCalculate(_renxuan7, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeRenxuan8: {
            zhushu=_CJXInstance->NotesCalculate(_renxuan8, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeZhixuan1: {
            zhushu=_CJXInstance->NotesCalculate(_direct1, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeZhixuan2: {
            zhushu=_CJXInstance->NotesCalculate(_direct2, _direct2 + 11,NULL, self.sdType);
        }
            break;
        case SyxwTypeZhixuan3: {
            zhushu=_CJXInstance->NotesCalculate(_direct3, _direct3 + 11, _direct3 + 22, self.sdType);
        }
            break;
        case SyxwTypeZuxuan2: {
            zhushu=_CJXInstance->NotesCalculate(_group2, NULL, NULL, self.sdType);
        }
            break;
        case SyxwTypeZuxuan3: {
            zhushu=_CJXInstance->NotesCalculate(_group3, NULL, NULL, self.sdType);
        }
            break;
        default:
            break;
     }
   self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元",zhushu, 2 * zhushu];
    return zhushu;
}
#pragma mark - getter, setter

- (UIView *)drawedView {
    if (_drawedView == nil) {
        _drawedView = [[UIView alloc] init];
        _drawedView.backgroundColor = [UIColor clearColor];
    }
    return _drawedView;
}


- (UITableView *)trendView {
    if (_trendView == nil) {
        _trendView = [[UITableView alloc] init];
        _trendView.delegate = self;
        _trendView.dataSource = self;
        _trendView.backgroundColor = [UIColor clearColor];
        _trendView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _trendView.allowsSelection = NO;
    }
    return _trendView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    }
    return _tableView;
}

- (UIView *)controlView {
    if (_controlView == nil) {
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        _controlView.backgroundColor = [UIColor clearColor];
    }
    return _controlView;
}

- (TTTAttributedLabel *)bonusLabel {
    if (_bonusLabel == nil) {
        _bonusLabel = [[TTTAttributedLabel alloc] init];
        _bonusLabel.font = [UIFont dp_systemFontOfSize:11];
        _bonusLabel.lineBreakMode = NSLineBreakByClipping;
        _bonusLabel.numberOfLines = 0;
        _bonusLabel.backgroundColor = [UIColor clearColor];
         _bonusLabel.userInteractionEnabled=NO;
    }
    return _bonusLabel;
}

- (SevenSwitch *)missSwitch {
    if (_missSwitch == nil) {
        _missSwitch = [[SevenSwitch alloc] init];
        _missSwitch.onImage = dp_DigitLotteryImage(@"yilouOpen.png");
        _missSwitch.offImage = dp_DigitLotteryImage(@"yilouClose.png");
        _missSwitch.inactiveColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _missSwitch.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _missSwitch.onTintColor = [UIColor dp_flatRedColor];
        
        [_missSwitch addTarget:self action:@selector(pvt_onSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _missSwitch;
}
- (UILabel *)zhushuLabel {
    if (_zhushuLabel == nil) {
        _zhushuLabel = [[UILabel alloc] init];
        _zhushuLabel.backgroundColor = [UIColor clearColor];
        _zhushuLabel.textColor = [UIColor whiteColor];
        _zhushuLabel.font = [UIFont dp_systemFontOfSize:12];
    }
    return _zhushuLabel;
}

- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor clearColor];
    }
    return _submitView;
}

- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    }
    return _titleButton;
}

- (DPNavigationMenu *)titleMenu {
    if (_titleMenu == nil) {
        _titleMenu = [[DPNavigationMenu alloc] init];
        _titleMenu.items = syxwTypeNames;
        
    }
    return _titleMenu;
}

- (NSLayoutConstraint *)tableConstraint {
    if (_tableConstraint == nil) {
        for (int i = 0; i < self.view.constraints.count; i++) {
            NSLayoutConstraint *constraint = self.view.constraints[i];
            if (constraint.firstItem == self.tableView && constraint.firstAttribute == NSLayoutAttributeTop) {
                _tableConstraint = constraint;
                break;
            }
        }
    }
    return _tableConstraint;
}

#pragma mark - DPNavigationMenuDelegate
- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    [self.titleButton setTitleText:syxwTypeNames[index]];
    self.gameIndex=index;
    [self.tableView reloadData];
    [self calculateZhushu];
    [self pvt_reloadBonusLabel];
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
}

#pragma mark - table's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.trendView) {
        return 25;
    }
    return self.missSwitch.isOn ? 110 : 86;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.trendView) {
        return 10;
    }
    
    switch (self.sdType) {
        case SyxwTypeZhixuan2:
            return 2;
        case SyxwTypeZhixuan3:
            return 3;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.trendView) {
        NSString *CellIdentifier = @"TrendCell";
        DPHistoryTendencyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPHistoryTendencyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  digitalType:GameTypeJxsyxw];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row==0) {
                cell.ballView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"ballHistoryBonus_02.png")];
        }
       }
        int results[5]={0};
        int names;
       int index= _CJXInstance->GetHistory(indexPath.row, results, names);
        NSString* str = @"";
        if (index<0) {
             str = @"-- -- -- -- --" ;
        }else if(index==1){
          str=@"正在开奖";
        }else{
          str = [NSString stringWithFormat:@"%02d %02d %02d %02d %02d",results[0],results[1],results[2],results[3],results[4]] ;
       
        }
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:str ];

        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0,hintString1.length)];
         cell.gameInfoLab.attributedText=hintString1;
        cell.gameNameLab.text=[NSString stringWithFormat:@"%d期",names];
        return cell;
    }
    
    NSString *CellIdentifier = @"Cell";
    DPSyxwBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPSyxwBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];
    }
    
    if (self.sdType == SyxwTypeZhixuan3) {
        switch (indexPath.row) {
            case 0:
                cell.commentLabel.text = @"万位";
                break;
            case 1:
                cell.commentLabel.text = @"千位";
                break;
            case 2:
                cell.commentLabel.text = @"百位";
                break;
            default:
                break;
        }
    } else if(self.sdType==SyxwTypeZhixuan2){
        switch (indexPath.row) {
            case 0:
                cell.commentLabel.text = @"万位";
                break;
            case 1:
                cell.commentLabel.text = @"千位";
                break;
            default:
                break;
        }

    }
    else
    {
        cell.commentLabel.text = @"选号";
    }
    int count=0;
    int ballMiss[SYXWNUMCOUNTMAX] = { 0 };
    _CJXInstance->GetMiss(ballMiss,self.sdType);
    int maxNum = 0 ;

    switch (self.sdType) {
            
        case SyxwTypeRenxuan2: {
            for (int i = 0; i < 11; i++) {
                count=_renxuan2[i]+count;
                [cell.balls[i] setSelected:_renxuan2[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }
            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }

        }
            break;
        case SyxwTypeRenxuan3: {
            for (int i = 0; i < 11; i++) {
                 count=_renxuan3[i]+count;
                [cell.balls[i] setSelected:_renxuan3[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }

            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeRenxuan4: {
            for (int i = 0; i < 11; i++) {
                count=_renxuan4[i]+count;
                [cell.balls[i] setSelected:_renxuan4[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }

            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeRenxuan5: {
            for (int i = 0; i < 11; i++) {
                count=_renxuan5[i]+count;
                [cell.balls[i] setSelected:_renxuan5[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }

            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeRenxuan6: {
            for (int i = 0; i < 11; i++) {
                count=_renxuan6[i]+count;
                [cell.balls[i] setSelected:_renxuan6[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }

            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeRenxuan7: {
            for (int i = 0; i < 11; i++) {
                count=_renxuan7[i]+count;
                [cell.balls[i] setSelected:_renxuan7[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }

            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeRenxuan8: {
            for (int i = 0; i < 11; i++) {
                count=_renxuan8[i]+count;
                [cell.balls[i] setSelected:_renxuan8[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }

            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeZhixuan1: {
            for (int i = 0; i < 11; i++) {
                count=_direct1[indexPath.row * 11 +i]+count;
                [cell.balls[i] setSelected:_direct1[indexPath.row * 11 + i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }

            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeZhixuan2: {
            for (int i = 0; i < 11; i++) {
                count=_direct2[indexPath.row * 11 +i]+count;
                [cell.balls[i] setSelected:_direct2[indexPath.row * 11 + i]];
            }
            
            for (int i = indexPath.row*11; i<(indexPath.row*11+11); i++) {
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }
            }
            
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeZhixuan3: {
            for (int i = 0; i < 11; i++) {
                count=_direct3[indexPath.row * 11 +i]+count;
                [cell.balls[i] setSelected:_direct3[indexPath.row * 11 + i]];
            }
            for (int i = indexPath.row*11; i<(indexPath.row*11+11); i++) {
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }
            }

            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeZuxuan2: {
            for (int i = 0; i < 11; i++) {
                 count=_group2[i]+count;
                [cell.balls[i] setSelected:_group2[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }
            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        case SyxwTypeZuxuan3: {
            for (int i = 0; i < 11; i++) {
                 count=_group3[i]+count;
                [cell.balls[i] setSelected:_group3[i]];
                if (ballMiss[i] >= maxNum) {
                    maxNum = ballMiss[i] ;
                }
            }
            [cell.balls[11] setSelected:NO];
            if (count==11) {
                [cell.balls[11] setSelected:YES];
            }
        }
            break;
        default:
            break;
    }
    
   
    
    for (int i = 0; i < cell.misses.count; i++) {
        UILabel *label = cell.misses[i];
        if (ballMiss[indexPath.row * 10 + i]== maxNum) {
            label.textColor = [UIColor dp_flatRedColor] ;
        }else{
            label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        }
        
        if ((self.missSwitch.isOn)&&(i<cell.misses.count-1)) {
            label.text = [NSString stringWithFormat:@"%d", ballMiss[indexPath.row * 10 + i]];
            
        } else {
            label.text = nil;
        }
    }
    
    // 底部分割线
    int rowsCount = [tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == rowsCount - 1) {
        cell.footLine.hidden = NO;
    }else{
        cell.footLine.hidden = YES;
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isTracking) {
        //        if (scrollView.contentOffset.y < 0) {
        //            scrollView.contentOffset = CGPointZero;
        //        }
        return;
    }
    
    if (self.tableConstraint.constant - scrollView.contentOffset.y < 0) {
        self.tableConstraint.constant = 0;
    } else if (self.tableConstraint.constant - scrollView.contentOffset.y > TrendDragHeight) {
        self.tableConstraint.constant = TrendDragHeight;
        scrollView.contentOffset = CGPointZero;
    } else {
        self.tableConstraint.constant = self.tableConstraint.constant - scrollView.contentOffset.y;
        scrollView.contentOffset = CGPointZero;
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.showHistory) {
        self.tableConstraint.constant = self.tableConstraint.constant < TrendDragHeight - 20 ? 0 : TrendDragHeight;
    } else {
        self.tableConstraint.constant = self.tableConstraint.constant > 20 ? TrendDragHeight : 0;
    }
    
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.showHistory = self.tableConstraint.constant == TrendDragHeight;
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.showHistory) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }
}

#pragma mark - DPSdBuyCellDelegate
- (void)buyCell:(DPSyxwBuyCell *)cell touchDown:(UIButton *)button {
    self.tableView.scrollEnabled = NO;
}

- (void)buyCell:(DPSyxwBuyCell *)cell touchUp:(UIButton *)button {
    self.tableView.scrollEnabled = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (button) {
    button.selected = !button.selected;
        switch (self.sdType) {
            case SyxwTypeRenxuan2:
                 _renxuan2[button.tag] = button.selected;
                if ((button.tag==11)) {
                    for(int i=0;i<12;i++){
                        _renxuan2[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeRenxuan3:
                _renxuan3[button.tag] = button.selected;
                if (button.tag==11) {
                    
                    for(int i=0;i<11;i++){
                         _renxuan3[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeRenxuan4:
               _renxuan4[button.tag] = button.selected;
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                        _renxuan4[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeRenxuan5:
                _renxuan5[button.tag] = button.selected;
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                          _renxuan5[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeRenxuan6:
                _renxuan6[button.tag] = button.selected;
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                        _renxuan6[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeRenxuan7:
               _renxuan7[button.tag] = button.selected;
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                        _renxuan7[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeRenxuan8:
               _renxuan8[button.tag] = button.selected;
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                        _renxuan8[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeZhixuan1:
              
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                        _direct1[i]=button.selected;
                    }
                }else{
                     _direct1[button.tag] = button.selected;
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                }
                break;
            case SyxwTypeZhixuan2:
                if (button.tag==11) {
//                    if (button.selected==1) {
//                        for(int i=0;i<22;i++){
//                            _direct2[i]=NO;
//                        }
//                    }
                    for(int i=0;i<11;i++){
                        _direct2[i+indexPath.row * 11]=button.selected;
                    }
                }else{
                    _direct2[button.tag+indexPath.row * 11] = button.selected;
                    if (button.selected==0) {
                        UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                        endButton.selected=0;
                    }
//                    else{
//                        _direct2[button.tag]=0;
//
//                        _direct2[button.tag+11]=0;
//                        _direct2[button.tag+indexPath.row * 11]=1;
//                    }
                }
                break;
            case SyxwTypeZhixuan3:
                if (button.tag==11) {
//                    if (button.selected==1) {
//                        for(int i=0;i<33;i++){
//                            _direct3[i]=NO;
//                        }
//                    }
                    
                    for(int i=0;i<11;i++){
                        _direct3[i+indexPath.row * 11]=button.selected;
                    }
                }else{
                _direct3[button.tag+indexPath.row * 11] = button.selected;
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
//                else{
//                    _direct3[button.tag]=0;
//                    _direct3[button.tag+11]=0;
//                    _direct3[button.tag+22]=0;
//                 _direct3[button.tag+indexPath.row * 11]=1;
//            
//                }
                }
                break;
            case SyxwTypeZuxuan2:
                _group2[button.tag] = button.selected;
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                        _group2[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            case SyxwTypeZuxuan3:
                _group3[button.tag] = button.selected;
                if (button.tag==11) {
                    for(int i=0;i<11;i++){
                        _group3[i]=button.selected;
                    }
                }
                if (button.selected==0) {
                    UIButton *endButton=(UIButton *)[cell.contentView viewWithTag:11];
                    endButton.selected=0;
                }
                break;
            default:
                break;
                
        }

    }
    [self calculateZhushu];
    [self.tableView reloadData];
}
-(BOOL)hasSelectedNum
{
    BOOL hasSelectOne = NO ;

    switch (self.sdType) {
        case SyxwTypeRenxuan2:
            if (CMathHelper::IsZero(_renxuan2, sizeof(_renxuan2)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            break;
        case SyxwTypeRenxuan3:
            if (CMathHelper::IsZero(_renxuan3, sizeof(_renxuan3)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            break;
        case SyxwTypeRenxuan4:
            if (CMathHelper::IsZero(_renxuan4, sizeof(_renxuan4)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            break;
        case SyxwTypeRenxuan5:
            if (CMathHelper::IsZero(_renxuan5, sizeof(_renxuan5)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            break;
        case SyxwTypeRenxuan6:
            if (CMathHelper::IsZero(_renxuan6, sizeof(_renxuan6)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            break;
        case SyxwTypeRenxuan7:
            if (CMathHelper::IsZero(_renxuan7, sizeof(_renxuan7)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            break;
        case SyxwTypeRenxuan8:
            if (CMathHelper::IsZero(_renxuan8, sizeof(_renxuan8)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            break;
        case SyxwTypeZhixuan1:
            
            if (CMathHelper::IsZero(_direct1, sizeof(_direct1)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;

            break;
        case SyxwTypeZhixuan2:
            if (CMathHelper::IsZero(_direct2, sizeof(_direct2)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
           
            break;
        case SyxwTypeZhixuan3:
            if (CMathHelper::IsZero(_direct3, sizeof(_direct3)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
           
            break;
        case SyxwTypeZuxuan2:
            if (CMathHelper::IsZero(_group2, sizeof(_group2)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
            
            break;
        case SyxwTypeZuxuan3:
            if (CMathHelper::IsZero(_group3, sizeof(_group3)) ) {
                hasSelectOne = NO ;
            }else
                hasSelectOne = YES ;
           
            break;
        default:
            break;
            
    }

    return hasSelectOne ;

}


//中转界面跳转过来
- (void)jumpToSelectPage:(int)row gameType:(int)gameTypes {
    self.targetIndex = row;
    self.isTransfer=YES;
    self.sdType = (SyxwType)gameTypes;
    [self ClearAllSelectedData];
    if (row >= 0) {
        SyxwType subType;
        int num[33];
        int note;
         _CJXInstance->GetTarget(self.targetIndex, num, num + 11, num + 22,subType,note);
        switch (gameTypes) {
                
            case SyxwTypeRenxuan2:
                memcpy(_renxuan2, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan3:
               memcpy(_renxuan3, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan4:
                memcpy(_renxuan4, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan5:
               memcpy(_renxuan5, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan6:
               memcpy(_renxuan6, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan7:
               memcpy(_renxuan7, num, sizeof(int) * 11);
                break;
            case SyxwTypeRenxuan8:
                memcpy(_renxuan8, num, sizeof(int) * 11);
                break;
            case SyxwTypeZhixuan1:
                
               memcpy(_direct1, num, sizeof(int) * 11);
                break;
            case SyxwTypeZhixuan2:
                 memcpy(_direct2, num, sizeof(int) * 22);
                break;
            case SyxwTypeZhixuan3:
               memcpy(_direct3, num, sizeof(int) * 33);
                break;
            case SyxwTypeZuxuan2:
                for (int i=0; i<11; i++) {
                    _group2[i]=num[i];
                }
                break;
            case SyxwTypeZuxuan3:
                for (int i=0; i<11; i++) {
                    _group3[i]=num[i];
                }
                break;
            default:
                break;
        }
    } else {
        self.zhushuLabel.text = @"";
    }
    [self.tableView reloadData];
    [self calculateZhushu];
}

#pragma mark- 摇一摇

//摇一摇功能
-(BOOL)canBecomeFirstResponder {
    
    return YES;
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event

{
    if(motion == UIEventSubtypeMotionShake)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self digitalDataRandom];
    }
}


//摇一摇
-(void)digitalDataRandom{
    int red[SYXWNUMCOUNT]={0};
    switch (self.sdType) {
        case SyxwTypeRenxuan2:
          [self partRandom:2 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _renxuan2[i]=red[i];
            }
            break;
        case SyxwTypeRenxuan3:
        
            [self partRandom:3 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _renxuan3[i]=red[i];
            }
            break;
        case SyxwTypeRenxuan4:
            [self partRandom:4 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _renxuan4[i]=red[i];
            }
            break;
        case SyxwTypeRenxuan5:
            [self partRandom:5 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _renxuan5[i]=red[i];
            }
            break;
        case SyxwTypeRenxuan6:
            [self partRandom:6 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _renxuan6[i]=red[i];
            }
            break;
        case SyxwTypeRenxuan7:
            [self partRandom:7 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _renxuan7[i]=red[i];
            }
          
            break;
        case SyxwTypeRenxuan8:
            [self partRandom:8 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _renxuan8[i]=red[i];
            }
            break;
        case SyxwTypeZhixuan1:
            [self partRandom:1 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _direct1[i]=red[i];
            }
            break;
        case SyxwTypeZhixuan2:
        {
            for (int i=0; i<22; i++) {
                _direct2[i]=0;
            }
            [self partRandom:2 total:SYXWNUMCOUNT target2:red];
            int count=0;
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                if (red[i]==1) {
                    count=count+1;
                }
                if (count==1) {
                    _direct2[i]=red[i];
                }else if(count==2){
                    _direct2[i+11]=red[i];
                }
            }
         }
            break;
        case SyxwTypeZhixuan3:{
            for (int i=0; i<SYXWNUMCOUNTMAX; i++) {
                _direct3[i]=0;
            }
            [self partRandom:3 total:SYXWNUMCOUNT target2:red];
            int count=0;
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                if (red[i]==1) {
                    count=count+1;
                }
                if (count==1) {
                     _direct3[i]=red[i];
                }else if(count==2){
                _direct3[i+11]=red[i];
                }else if(count==3){
                _direct3[i+22]=red[i];
                }
            }
    }
            break;
        case SyxwTypeZuxuan2:
            [self partRandom:2 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _group2[i]=red[i];
            }
            break;
        case SyxwTypeZuxuan3:
            [self partRandom:3 total:SYXWNUMCOUNT target2:red];
            for (int i=0; i<SYXWNUMCOUNT; i++) {
                _group3[i]=red[i];
            }
            break;
        default:
            break;
            
    }
    
[self calculateZhushu];
[self.tableView reloadData];
}
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    for(int i=0;i<total;i++){
        target[i]=0;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random() % ((total - i) == 0?1:(total-i));
        target[[array[x] integerValue]] = 1;
         DPLog(@"ssss=%d",[array[x] integerValue]);
        [array removeObjectAtIndex:x];
       
    }
    
}
#pragma mark - ModuleNotify

//- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.missSwitch.isOn) {
//            [self.tableView reloadData];
//        }
//        if (self.showHistory) {
//            [self.trendView reloadData];
//        }
//        switch (cmdId) {
//                if (self.timeSpace < 0) {
//                    [self.tableView reloadData];
//                    [self.trendView reloadData];
//                    [self UpDateRequestedData];
//                }
//                
//                DPLog(@"NOTIFY_TIMEOUT_LOTTERY");
//                break;
//                [self.tableView reloadData];
//                [self.trendView reloadData];
//                [self UpDateRequestedData];
//                
//                DPLog(@"NOTIFY_FINISH_LOTTERY");
//                break;
//            default:
//                [self.tableView reloadData];
//                [self.trendView reloadData];
//                [self UpDateRequestedData];
//                DPLog(@"defj...");
//                break;
//        }
//
//        int gameName;
//        string endTime;
//        _CJXInstance->GetInfo(gameName, endTime);
//        
//         NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
//        NSDate * senddate=[NSDate dp_date];
//        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *  locationString=[dateformatter stringFromDate:senddate];//todo
//        self.timeSpace=[self getDateFrom:locationString toDate:dateString];
//        self.timeSpace=0;
//        if (self.timeSpace>0) {
//            [self startTimer];
////        }
//    });
//}
- (void)UpDateRequestedData {
    int issue;
    string endTime;
    int ret= _CJXInstance->GetInfo(issue, endTime);
    if (ret>=0) {
        NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];

        self.timeSpace = [[NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
    }
    
}

#pragma NSTimer

- (void)pvt_reloadTimer {
//    if (self.timeSpace == 0) {
//        // todo:
//
//        DPLog(@"end: %@", [[NSDate dp_date] dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]);
//
//        [self.tableView reloadData];
//        [self.trendView reloadData];
//        [self UpDateRequestedData];
//    }
//
//    if (self.timeSpace == 8) {
//        // todo:
//
//        //        DPLog(@"five second: %@", [[NSDate dp_date] dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]);
//        //       _CJXInstance->TimeOut();
//    }
    if (self.timeSpace == 8) {
        _CJXInstance -> TimeOut();
    }
    
    int issue;
    string endTime;
    _CJXInstance->GetInfo(issue, endTime);
    if (self.timeSpace > 0) {
        NSString *time = @"";
        int hours = ((int)self.timeSpace) / 3600;
        int mins = (((int)self.timeSpace) - 3600 * hours) / 60;
        int seconds = ((int)self.timeSpace) - 3600 * hours - 60 * mins;
        time = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds];
        NSString *gameString = [NSString stringWithFormat:@"距%d投注截止还有", issue];
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", gameString, time]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0, gameString.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(gameString.length + 1, time.length)];
        [self.endTimeLabel setText:hintString1];
    } else {
        

    }
}

- (void)refreshNotify {
    int currGameName; string endTime;
    int status = _CJXInstance->GetGameStatus(currGameName, endTime);
    if (status >= 0) {
        [self.tableView reloadData];
        [self.trendView reloadData];
        [self UpDateRequestedData];
//        [super refreshNotify];
    } else {
        DPLog(@"未获取到数据");
    }
}

- (NSInteger)timeSpace {
    return g_jxsyxwTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_jxsyxwTimeSpace = timeSpace;
}

@end
