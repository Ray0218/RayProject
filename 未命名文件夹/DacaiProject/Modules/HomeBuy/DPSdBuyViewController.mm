//
//  DPSdBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-31.
//  Copyright (c) 2014年 dacai. All rights reserved.
// 3D、、、、

#import <SevenSwitch/SevenSwitch.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "../../Common/View/DPNavigationTitleButton.h"
#import "../../Common/View/DPNavigationMenu.h"
#import "DPSdBuyViewController.h"
#import "DPSdHistoryTrendCell.h"
#import "DPSdBuyCell.h"
#import "FrameWork.h"
#import "DPWF3DTicketTransferVC.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DPDigitalCommon.h"
#define TrendDragHeight  270

static NSArray *SDTypeNames = @[@"直选", @"组三", @"组六"];

@interface DPSdBuyViewController () <UITableViewDelegate, UITableViewDataSource, DPNavigationMenuDelegate, DPSdBuyCellDelegate, DPDropDownListDelegate, UIGestureRecognizerDelegate> {
@private
    DPNavigationMenu *_titleMenu;
    DPNavigationTitleButton *_titleButton;
    
    UIView *_drawedView;
    UILabel *_drawedLabel;
    UILabel *_endTimeLabel;
    
    UITableView *_trendView;
    
    UITableView *_tableView;
    UIView *_controlView;
    TTTAttributedLabel *_bonusLabel;
    SevenSwitch *_missSwitch;
    
    UIView *_submitView;
    
    NSLayoutConstraint *_tableConstraint;
    UILabel *_zhushuLabel;
    CLottery3D *_lottery3DInstance;
    int _direct[30];
    int _group3[10];
    int _group6[10];
}

@property (nonatomic, strong, readonly) DPNavigationMenu *titleMenu;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;

@property (nonatomic, strong, readonly) UIView *drawedView;
@property (nonatomic, strong, readonly) UILabel *drawedLabel;
@property (nonatomic, strong, readonly) UILabel *endTimeLabel;

@property (nonatomic, strong, readonly) UITableView *trendView;

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *controlView;
@property (nonatomic, strong, readonly) TTTAttributedLabel *bonusLabel;
@property (nonatomic, strong, readonly) SevenSwitch *missSwitch;

@property (nonatomic, strong, readonly) UIView *submitView;

@property (nonatomic, strong, readonly) NSLayoutConstraint *tableConstraint;

@property (nonatomic, assign) SDType sdType;
@property (nonatomic, assign) BOOL showHistory;
@property(nonatomic,strong)    UILabel *zhushuLabel;//注数

@end

@implementation DPSdBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _lottery3DInstance = CFrameWork::GetInstance()->GetLottery3D();

        for (int i = 0; i < 10; i++) {
            _direct[i * 3] = 0;
            _direct[i * 3 + 1] = 0;
            _direct[i * 3 + 2] = 0;
            _group3[i] = 0;
            _group6[i] = 0;
        }
        self.targetIndex = -1;
        self.sdType = SDTypeDirect;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotify) name:dp_DigitalBetRefreshNofify object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_DigitalBetRefreshNofify object:nil];
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
        int subType;
        int num[30];
        int note;
        _lottery3DInstance->GetTarget(self.targetIndex, subType, note,num, num + 10, num + 20);
        
        self.sdType = (SDType)subType;
        switch (self.sdType) {
            case SDTypeDirect:
                memcpy(_direct, num, sizeof(int) * 30);
                break;
            case SDTypeGroup3:
                memcpy(_group3, num, sizeof(int) * 10);
                break;
            case SDTypeGroup6:
                memcpy(_group6, num, sizeof(int) * 10);
                break;
            default:
                break;
        }
    }
    
    [self refreshNotify];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self calculateZhushu];
    [self.titleMenu setSelectedIndex:self.sdType];
    [self.titleButton setTitleText:SDTypeNames[self.sdType]];
    [self.tableView reloadData];
    [self pvt_reloadBonusLabel];
    [self canBecomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)pvt_navigationDidLoad {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)];
    [self.navigationItem setTitleView:self.titleButton];
    
    [self.titleButton setTitleText:SDTypeNames[self.sdType]];
    [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];
}

- (void)pvt_drawedViewDidLoad {
    UILabel *drawedCommentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"上期开奖: ";
        label.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    UILabel *endTimeCommentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"当前期停售时间: ";
        label.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    
    UIView *contentView = self.drawedView;
    
    [contentView addSubview:drawedCommentLabel];
    [contentView addSubview:self.drawedLabel];
    [contentView addSubview:endTimeCommentLabel];
    [contentView addSubview:self.endTimeLabel];
    self.drawedLabel.font=[UIFont dp_systemFontOfSize:12.0];
    self.drawedLabel.textColor=[UIColor dp_flatRedColor];
    self.endTimeLabel.font=[UIFont dp_systemFontOfSize:12.0];
    self.endTimeLabel.textColor=[UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    [drawedCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
    }];
    [self.drawedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(drawedCommentLabel.mas_right);
    }];
    [endTimeCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX).offset(-6);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(endTimeCommentLabel.mas_right);
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
    
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.missSwitch.mas_bottom).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
        make.left.equalTo(contentView).offset(10);
    }];
    [missCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [missCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.missSwitch.mas_left).offset(-3);
            make.centerY.equalTo(contentView).offset(-12);
        }];
    }];
    [self.missSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(8);
        make.right.equalTo(contentView).offset(-20);
        make.width.equalTo(@52);
        make.height.equalTo(@25);
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

//    UIView *footLine = [[UIView alloc]init];
//    footLine.backgroundColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.87 alpha:1];
//    footLine.bounds = CGRectMake(0, 0, 0, 0.5);
    self.tableView.tableHeaderView = self.controlView;
//    self.tableView.tableFooterView = footLine;
    
    
    // 历史走势
    self.trendView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        view.backgroundColor = [UIColor colorWithRed:0.92 green:0.89 blue:0.83 alpha:1];
        
        UILabel *issueCommentLabel = [[UILabel alloc] init];
        issueCommentLabel.text = @"期次";
        issueCommentLabel.backgroundColor = [UIColor clearColor];
        issueCommentLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        issueCommentLabel.font = [UIFont dp_systemFontOfSize:11];
        issueCommentLabel.textAlignment = NSTextAlignmentCenter;
        UILabel *drawedCommentLabel = [[UILabel alloc] init];
        drawedCommentLabel.text = @"开奖号码";
        drawedCommentLabel.backgroundColor = [UIColor clearColor];
        drawedCommentLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        drawedCommentLabel.font = [UIFont dp_systemFontOfSize:11];
        UILabel *shapeCommentLabel = [[UILabel alloc] init];
        shapeCommentLabel.text = @"形态";
        shapeCommentLabel.backgroundColor = [UIColor clearColor];
        shapeCommentLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        shapeCommentLabel.font = [UIFont dp_systemFontOfSize:11];
        UILabel *tryCommentLabel = [[UILabel alloc] init];
        tryCommentLabel.text = @"试机号";
        tryCommentLabel.backgroundColor = [UIColor clearColor];
        tryCommentLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        tryCommentLabel.font = [UIFont dp_systemFontOfSize:11];
        
        [view addSubview:issueCommentLabel];
        [view addSubview:drawedCommentLabel];
        [view addSubview:shapeCommentLabel];
        [view addSubview:tryCommentLabel];
        
        [issueCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.width.equalTo(view).multipliedBy(0.20);
            make.left.equalTo(view);
        }];
        [drawedCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.width.equalTo(view).multipliedBy(0.25);
            make.left.equalTo(issueCommentLabel.mas_right).offset(10);
        }];
        [shapeCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.width.equalTo(view).multipliedBy(0.1);
            make.left.equalTo(view.mas_centerX);
        }];
        [tryCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(shapeCommentLabel.mas_right).offset(5);
        }];
        
        view;
    });
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
    switch (self.sdType) {
        case SDTypeDirect: {
            NSMutableAttributedString *bonusString = [[NSMutableAttributedString alloc] initWithString:@"每位至少选择1个号码，与开奖号码按位一致即中1040元"];
            NSRange numberRange = [[bonusString string] rangeOfString:@"1040" options:NSCaseInsensitiveSearch];
            [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] CGColor] range:NSMakeRange(0, bonusString.length)];
            [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:numberRange];
            [self.bonusLabel setText:bonusString];
        }
            break;
        case SDTypeGroup6: {
            NSMutableAttributedString *bonusString = [[NSMutableAttributedString alloc] initWithString:@"至少选择3个号码，猜中开奖号码即中173元"];
            NSRange numberRange = [[bonusString string] rangeOfString:@"173" options:NSCaseInsensitiveSearch];
            [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] CGColor] range:NSMakeRange(0, bonusString.length)];
            [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:numberRange];
            [self.bonusLabel setText:bonusString];
        }
            break;
        case SDTypeGroup3: {
            NSMutableAttributedString *bonusString = [[NSMutableAttributedString alloc] initWithString:@"至少选择2个号码，猜中开奖号码即中346元"];
            NSRange numberRange = [[bonusString string] rangeOfString:@"346" options:NSCaseInsensitiveSearch];
            [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] CGColor] range:NSMakeRange(0, bonusString.length)];
            [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:numberRange];
            [self.bonusLabel setText:bonusString];
        }
            break;
        default:
            break;
    }

   
}
-(void)pvt_onClear{
    for (int i = 0; i < 10; i++) {
        if (self.sdType==SDTypeDirect) {
            _direct[i * 3] = 0;
            _direct[i * 3 + 1] = 0;
            _direct[i * 3 + 2] = 0;
        }else if(self.sdType==SDTypeGroup6){
        _group6[i] = 0;
        }else if(self.sdType==SDTypeGroup3){
        _group3[i] = 0;
        }
       
    }
    [self.tableView reloadData];
    [self calculateZhushu];
}
// event
- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
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
                viewController.gameType = GameTypeSd;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        }
            break;
        case 1: {   // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeSd)]];
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
      int index=-1;
    switch (self.sdType) {
        case SDTypeDirect: {
            if ([self ballSelectedTotal:_direct beginIndex:0]<1) {
                [[DPToast makeText:@"百位至少选择一个号码"]show];
                return;
            }
            if ([self ballSelectedTotal:_direct  beginIndex:10]<1) {
                [[DPToast makeText:@"十位至少选择一个号码"]show];
                return;
            }
            if ([self ballSelectedTotal:_direct  beginIndex:20]<1) {
                [[DPToast makeText:@"个位至少选择一个号码"]show];
                return;
            }
            if (self.targetIndex<0) {
            index= _lottery3DInstance->AddTarget(_direct, _direct + 10, _direct + 20, self.sdType);
            }else{
                index=_lottery3DInstance->ModifyTarget(self.targetIndex, _direct,  _direct + 10, _direct + 20, self.sdType);
            }
            
        }
            break;
        case SDTypeGroup6: {
            if ([self ballSelectedTotal:_group6 beginIndex:0]<3) {
                [[DPToast makeText:@"至少选择3个号码"]show];
                return;
            }
            if (self.targetIndex<0) {
                index= _lottery3DInstance->AddTarget(_group6, NULL, NULL, self.sdType);
            }
            else{
                index=_lottery3DInstance->ModifyTarget(self.targetIndex, _group6,NULL, NULL, self.sdType);
            }
           
        }
            break;
        case SDTypeGroup3: {
            if ([self ballSelectedTotal:_group3 beginIndex:0]<2) {
                [[DPToast makeText:@"至少选择2个号码"]show];
                return;
            }

            if (self.targetIndex) {
                 index= _lottery3DInstance->AddTarget(_group3, NULL, NULL, self.sdType);
            }else{
            index=_lottery3DInstance->ModifyTarget(self.targetIndex, _group3,NULL, NULL, self.sdType);
            }
          
        }
            break;
        default:
            break;
    }
    if (index>=0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
     [[DPToast makeText:@"提交失败"]show];

}
//判断当前选中几个球
-(int)ballSelectedTotal:(int[])num   beginIndex:(int)beginIndex{
    int  selectedTotal=0;
    for (int i=beginIndex; i<beginIndex+10; i++) {
        if (num[i]==1) {
            selectedTotal=selectedTotal+1;
        }
    }
    return selectedTotal;
}
-(void)calculateZhushu{
    int zhushu=0;
    switch (self.sdType) {
        case SDTypeDirect: {
            zhushu=_lottery3DInstance->NotesCalculate(_direct, _direct + 10, _direct + 20, self.sdType);
        }
            break;
        case SDTypeGroup3: {
            zhushu=_lottery3DInstance->NotesCalculate(_group3, NULL, NULL, self.sdType);
        }
            break;
        case SDTypeGroup6: {
            zhushu=_lottery3DInstance->NotesCalculate(_group6, NULL, NULL, self.sdType);
        }
            break;
    
               default:
            break;
    }
    self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元",zhushu, 2 * zhushu];
}

#pragma mark - getter, setter

- (UILabel *)zhushuLabel {
    if (_zhushuLabel == nil) {
        _zhushuLabel = [[UILabel alloc] init];
        _zhushuLabel.backgroundColor = [UIColor clearColor];
        _zhushuLabel.textColor = [UIColor whiteColor];
        _zhushuLabel.font = [UIFont dp_systemFontOfSize:12];
    }
    return _zhushuLabel;
}
- (UIView *)drawedView {
    if (_drawedView == nil) {
        _drawedView = [[UIView alloc] init];
        _drawedView.backgroundColor = [UIColor clearColor];
    }
    return _drawedView;
}

- (UILabel *)drawedLabel {
    if (_drawedLabel == nil) {
        _drawedLabel = [[UILabel alloc] init];
        _drawedLabel.backgroundColor = [UIColor clearColor];
    }
    return _drawedLabel;
}

- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _endTimeLabel;
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
        _missSwitch.on = YES ;
        [_missSwitch addTarget:self action:@selector(pvt_onSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _missSwitch;
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
        _titleMenu.items = SDTypeNames;
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
    [self.titleButton setTitleText:SDTypeNames[index]];
    [self setSdType:(SDType)index];
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
        case SDTypeDirect:
            return 3;
        case SDTypeGroup3:
        case SDTypeGroup6:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.trendView) {
        NSString *CellIdentifier = @"TrendCell";
        DPSdHistoryTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPSdHistoryTrendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.issueLabel.highlighted = indexPath.row == 0;
        cell.pointView.highlighted = indexPath.row == 0;
        
        int result[3]= {0}, test[3]= {0};
        int gameName;
       int ret = _lottery3DInstance->GetHistory(indexPath.row, result, test, gameName);

//        if (_lottery3DInstance->GetHistory(indexPath.row, result, test, gameName) == 0) {
        
        NSString * drawStr = [NSString stringWithFormat:@"%d  %d  %d", result[0], result[1], result[2]];
        if ([drawStr isEqualToString:@"0  0  0"]) {
            drawStr = @"" ;
            if (ret == 1) {
                drawStr = @"正在开奖..." ;
            }

        }
            cell.issueLabel.text = [NSString stringWithFormat:@"%d期", gameName];
        cell.drawedLabel.text = drawStr ;
        
        NSString* stryStr = [NSString stringWithFormat:@"%d  %d  %d", test[0], test[1], test[2]];
        if ([stryStr isEqualToString:@"0  0  0"]) {
//            stryStr = @"-  -  -" ;
            stryStr = @"" ;

        }
        cell.tryLabel.text = stryStr;
            if (result[0] == result[1] && result[1] == result[2]) {
                cell.shapeLabel.text = nil;;
            } else if (result[0] == result[1] || result[0] == result[2] || result[1] == result[2]) {
                cell.shapeLabel.text = @"组三";
            } else {
                cell.shapeLabel.text = @"组六";
            }
//        } else {
//            cell.issueLabel.text = nil;
//            cell.drawedLabel.text = nil;
//            cell.shapeLabel.text = nil;
//            cell.tryLabel.text = nil;
//        }
        
        return cell;
    }
    
    NSString *CellIdentifier = @"Cell";
    DPSdBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPSdBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];
    }
    
    if (self.sdType == SDTypeDirect) {
        switch (indexPath.row) {
            case 0:
                cell.commentLabel.text = @"百位";
                break;
            case 1:
                cell.commentLabel.text = @"十位";
                break;
            case 2:
                cell.commentLabel.text = @"个位";
                break;
            default:
                break;
        }
    } else {
        cell.commentLabel.text = @"选号";
    }
    
    switch (self.sdType) {
        case SDTypeDirect: {
            for (int i = 0; i < 10; i++) {
                                [cell.balls[i] setSelected:_direct[indexPath.row * 10 + i]];
            }
        }
            break;
        case SDTypeGroup3: {
            for (int i = 0; i < 10; i++) {
                [cell.balls[i] setSelected:_group3[i]];
            }
        }
            break;
        case SDTypeGroup6: {
            for (int i = 0; i < 10; i++) {
                [cell.balls[i] setSelected:_group6[i]];
            }
        }
            break;
        default:
            break;
    }
    
    int directMiss[30] = { 0 };
    int groupMiss[10] = { 0 };
//    int group6Miss[10] = { 0 };
    
    _lottery3DInstance->GetMiss(directMiss, groupMiss);
    int maxNum = 0 ;

    if (self.sdType  == SDTypeDirect) {
        for (int i=10*indexPath.row; i<(10*indexPath.row+10); i++) {
            if (directMiss[i] >=maxNum) {
                maxNum = directMiss[i] ;
            }
        }
    }else{
        for (int i = 0; i < cell.misses.count; i++) {

            if(groupMiss[indexPath.row * 10 + i] >=maxNum){
                maxNum = groupMiss[indexPath.row * 10 + i] ;
            }
        }
    }
    
//    for (int i = 0; i < cell.misses.count; i++) {
//        if (directMiss[indexPath.row * 10 + i] >=maxNum) {
//            maxNum = directMiss[indexPath.row * 10 + i] ;
//        }else if(groupMiss[indexPath.row * 10 + i] >=maxNum){
//            maxNum = groupMiss[indexPath.row * 10 + i] ;
//        }
//    }
    for (int i = 0; i < cell.misses.count; i++) {
        UILabel *label = cell.misses[i];
        
        
        if (self.missSwitch.isOn) {
            
            switch (self.sdType) {
                case SDTypeDirect: {
                    if (directMiss[indexPath.row * 10 + i] == maxNum) {
                        label.textColor = [UIColor dp_flatRedColor] ;
                    }else{
                        label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
                    }
                    label.text = [NSString stringWithFormat:@"%d", directMiss[indexPath.row * 10 + i]];
                } break;
                case SDTypeGroup3: {
                    if (groupMiss[ i] == maxNum) {
                        label.textColor = [UIColor dp_flatRedColor] ;
                    }else{
                        label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
                    }
                    label.text = [NSString stringWithFormat:@"%d", groupMiss[i]];
                } break;
                case SDTypeGroup6: {
                    if (groupMiss[ i] == maxNum) {
                        label.textColor = [UIColor dp_flatRedColor] ;
                    }else{
                        label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
                    }

                    label.text = [NSString stringWithFormat:@"%d", groupMiss[i]];
                } break;
                default:
                    break;
            }
        } else {
            label.text = nil;
        }
    }
    
    int rowCount = [tableView numberOfRowsInSection:0];
    if (indexPath.row == rowCount - 1) {
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
- (void)buyCell:(DPSdBuyCell *)cell touchDown:(UIButton *)button {
    self.tableView.scrollEnabled = NO;
}

- (void)buyCell:(DPSdBuyCell *)cell touchUp:(UIButton *)button {
    self.tableView.scrollEnabled = YES;
    
    if (button) {
        button.selected = !button.selected;
        
        switch (self.sdType) {
            case SDTypeDirect: {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                _direct[indexPath.row * 10 + button.tag] = button.selected;
            }
                break;
            case SDTypeGroup3: {
                _group3[button.tag] = button.selected;
            }
                break;
            case SDTypeGroup6: {
                _group6[button.tag] = button.selected;
            }
                break;
            default:
                break;
        }
    }
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
     int red[30]={0};
    switch (self.sdType) {
        case SDTypeDirect:
        {
             [self partRandom:1 total:SDNum target2:red];
            for(int i=0;i<10;i++){
                _direct[i]=red[i];
            }
            [self partRandom:1 total:SDNum target2:red];
            for(int i=0;i<10;i++){
                _direct[i+10]=red[i];
            }

            [self partRandom:1 total:SDNum target2:red];
            for(int i=0;i<10;i++){
                _direct[i+20]=red[i];
            }

        }
            break;
        case SDTypeGroup3: {
            [self partRandom:2 total:SDNum target2:red];
            for(int i=0;i<10;i++){
                _group3[i]=red[i];
            }
        }
            break;
        case SDTypeGroup6: {
            [self partRandom:3 total:SDNum target2:red];
            for(int i=0;i<10;i++){
                _group6[i]=red[i];
            }
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
        NSLog(@"ssss=%d",[array[x] integerValue]);
        [array removeObjectAtIndex:x];
        
    }
    
}

#pragma mark - 倒计时

- (void)updateUIData {
    [self.tableView reloadData];
    [self.trendView reloadData];
    
    int gameName;
    string endTime;
    int globalSurplus;
    int results[3]={0};
    int test[3]={0};
    _lottery3DInstance->GetInfo(gameName, endTime, globalSurplus);
    int ret = _lottery3DInstance->GetHistory(0, results, test, gameName);
    if (ret == 0) {
        self.drawedLabel.text=[NSString stringWithFormat:@"%d %d %d",results[0],results[1],results[2]];
    } else if (ret == 1) {
        self.drawedLabel.text = @"正在开奖...";
    } else {
        self.drawedLabel.text = nil;
    }
    NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
    NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    self.endTimeLabel.text =[date dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];
}

- (void)refreshNotify {
    int lastGameName, currGameName; string endTime;
    int status = _lottery3DInstance->GetGameStatus(lastGameName, currGameName, endTime);
    if (status != 1) {
        [self updateUIData];
    } else {
        DPLog(@"未获取到数据");
    }
}

- (NSInteger)timeSpace {
    return g_sdTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_sdTimeSpace = timeSpace;
}

@end
