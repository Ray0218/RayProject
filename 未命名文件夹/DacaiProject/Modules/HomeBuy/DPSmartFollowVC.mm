//
//  DPSmartFollowVC.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-28.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#import "DPSmartFollowVC.h"
#import "DPImageLabel.h"
#import "DPSmartPlanSetView.h"
#import "FrameWork.h"
#import "DPKeyboardCenter.h"
#import <MSWeakTimer/MSWeakTimer.h>
#import "DPAccountViewControllers.h"
#import "DPRedPacketViewController.h"
#import "DPDigitalCommon.h"

@interface DPSmartTableViewCell : UITableViewCell
{
    UILabel          *_issueLabel;      // 期号
    UILabel          *_timesLabel;      // 倍数
    UILabel          *_devotionLabel;   // 投入
    UILabel          *_gainLabel;       // 中奖盈利
    UILabel          *_gainScaleLabel;  // 盈利率
    smartZhGameType   _gameType;
    NSIndexPath      *_indexPath;
    UIColor          *_cellColor;
    UIColor          *_foreTextColor;
    UIColor          *_backTextColor;
}
@property (assign, nonatomic)smartZhGameType gameType;
@property (copy, nonatomic)NSString *issueText;
@property (copy, nonatomic)NSString *timesText;
@property (copy, nonatomic)NSString *devotionText;
@property (copy, nonatomic)NSString *gainText;
@property (copy, nonatomic)NSString *gainScaleText;
@property (strong, nonatomic)NSIndexPath *indexPath;
- (void)setGameType:(smartZhGameType)gameType indexPath:(NSIndexPath *)indexPath;
@end

@implementation DPSmartTableViewCell
@dynamic issueText;
@dynamic timesText;
@dynamic devotionText;
@dynamic gainScaleText;
@dynamic gainText;
@dynamic gameType;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildUI];
    
    }
    return self;
}

- (void)buildUI
{
    
    _issueLabel =       [self createLabel];
    _timesLabel =       [self createLabel];
    _devotionLabel =    [self createLabel];
    _gainLabel =        [self createLabel];
    _gainScaleLabel =   [self createLabel];

    UIView *contentView = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_issueLabel];
    [contentView addSubview:_timesLabel];
    [contentView addSubview:_devotionLabel];
    [contentView addSubview:_gainLabel];
    [contentView addSubview:_gainScaleLabel];
    
    [_issueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.centerY.equalTo(contentView);
    }];
    
    [_timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_issueLabel.mas_left).offset(60);
        make.centerY.equalTo(contentView);
    }];
    
    [_devotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timesLabel.mas_centerX).offset(60);
        make.centerY.equalTo(contentView);
    }];
    
    [_gainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_devotionLabel.mas_centerX).offset(70);
        make.centerY.equalTo(contentView);
    }];
    
    [_gainScaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_right).offset(-25);
        make.centerY.equalTo(contentView);
    }];
}
- (void)setGameType:(smartZhGameType)gameType indexPath:(NSIndexPath *)indexPath
{
    self.gameType = gameType;
    self.indexPath = indexPath;
}

- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    
    return label;
}
#pragma mark - getter&setter
- (NSString *)issueText
{
    return _issueLabel.text;
}
- (void)setIssueText:(NSString *)issueText
{
    if (_issueLabel) _issueLabel.text = issueText;
}

- (NSString *)timesText
{
    return _timesLabel.text;
}

- (void)setTimesText:(NSString *)timesText
{
    if (_timesLabel) _timesLabel.text = timesText;
}

- (NSString *)devotionText
{
    return _devotionLabel.text;
}

- (void)setDevotionText:(NSString *)devotionText
{
    if (_devotionLabel) _devotionLabel.text = devotionText;
}

- (NSString *)gainText
{
    return _gainLabel.text;
}
- (void)setGainText:(NSString *)gainText
{
    if (_gainLabel) _gainLabel.text = gainText;
}

- (NSString *)gainScaleText
{
    return _gainScaleLabel.text;
}

- (void)setGainScaleText:(NSString *)gainScaleText
{
    if (_gainScaleLabel) _gainScaleLabel.text = gainScaleText;
}

- (smartZhGameType)gameType
{
    return _gameType;
}

- (void)setGameType:(smartZhGameType)gameType
{
    switch (gameType) {
        case smartZhGameTypeK3:
            _cellColor = [UIColor colorWithRed:4.0/255 green:47.0/255 blue:15.0/255 alpha:0.2];
            _foreTextColor = [UIColor dp_colorFromHexString:@"#d0fccf"];
            _backTextColor = [UIColor dp_colorFromHexString:@"#deff00"];
            break;
        case smartZhGameTypePKS:
            _cellColor = [UIColor colorWithRed:1.0/255 green:53.0/255 blue:72.0/255 alpha:0.3f];
//            _cellColor = [UIColor dp_colorFromHexString:@"#013548"];
            _foreTextColor = [UIColor dp_colorFromHexString:@"#d0fccf"];
            _backTextColor = [UIColor dp_colorFromHexString:@"#deff00"];
            break;
        case smartZhGameType11X5:
            _cellColor = [UIColor dp_colorFromHexString:@"#f8f9f7"];
            _foreTextColor = [UIColor dp_colorFromHexString:@"#535353"];
            _backTextColor = [UIColor dp_colorFromHexString:@"#535353"];
            break;
        default:
            break;
    }
    _gameType = gameType;
}
- (NSIndexPath *)indexPath
{
    return _indexPath;
}
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    UIColor *firstColor = nil;
    switch (self.gameType) {
        case smartZhGameTypeK3:
        case smartZhGameTypePKS:
            firstColor = [UIColor clearColor];
            break;
        case smartZhGameType11X5:
            firstColor = [UIColor dp_colorFromHexString:@"ffffff"];
        default:
            break;
    }
    if (_cellColor != nil) {
        self.contentView.backgroundColor = indexPath.row % 2 ? firstColor : _cellColor;
    }
    
    _indexPath = indexPath;
    _issueLabel.textColor = _foreTextColor;
    _timesLabel.textColor = _foreTextColor;
    _devotionLabel.textColor = _foreTextColor;
    _gainLabel.textColor = _backTextColor;
    _gainScaleLabel.textColor = _backTextColor;
}
@end

@interface DPSmartFollowUI : NSObject

@property (strong, nonatomic, readonly)UIColor *deadTimeViewColor;
@property (strong, nonatomic, readonly)UIColor *deadTimeColor;
@property (strong, nonatomic, readonly)UIColor *tableViewBgColor;
@property (strong, nonatomic, readonly)UIColor *tableHeadBgColor;
@property (strong, nonatomic, readonly)UIColor *tableFootBgColor;
@property (strong, nonatomic, readonly)UIColor *tableHeadTextColor;
@property (strong, nonatomic, readonly)UIColor *tableFootTextColor;
@property (strong, nonatomic, readonly)UIColor *tableBorderColor;
@property (strong, nonatomic, readonly)UIColor *checkTextColor;
@property (strong, nonatomic, readonly)UIColor *commitViewColor;
@property (strong, nonatomic, readonly)UIColor *zhinengBtnTitleColor;
@property (strong, nonatomic, readonly)UIColor *confirmBtnTitleColor;
@property (strong, nonatomic, readonly)UIColor *bottomNumColor;
@property (strong, nonatomic, readonly)UIColor *bottomTextColor;
@property (strong, nonatomic, readonly)UIColor *bottomSpLineColor;
@property (strong, nonatomic, readonly)UIColor *navItemTintColor;
@property (strong, nonatomic, readonly)NSString *navBarImgString, *navBarImgStringB7;


@property(assign, nonatomic)smartZhGameType gameType;

@end

@implementation DPSmartFollowUI

- (id)initWithGameType:(smartZhGameType)gameType
{
    if (self = [super init]) {
        
        switch (gameType) {
            case smartZhGameTypeK3:
                _deadTimeViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
                _deadTimeColor = [UIColor dp_colorFromHexString:@"#58c854"];
                _tableViewBgColor = [UIColor clearColor];
                _tableHeadBgColor = [UIColor dp_colorFromHexString:@"#0b441a"];
                _tableFootBgColor = [UIColor dp_colorFromHexString:@"#0b441a"];
                _tableHeadTextColor = [UIColor dp_colorFromHexString:@"#8bee8b"];
                _tableFootTextColor = [UIColor dp_colorFromHexString:@"#fefefe"];
                _tableBorderColor = [UIColor dp_colorFromHexString:@"#0b4619"];
                _checkTextColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _commitViewColor = [UIColor dp_colorFromHexString:@"#4b1d0d"];
                _zhinengBtnTitleColor = UIColorFromRGB(0x491706);
                _confirmBtnTitleColor = [UIColor clearColor];
                _bottomNumColor = [UIColor dp_colorFromHexString:@"#deff00"];
                _bottomTextColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _bottomSpLineColor = UIColorFromRGB(0x381509);
                _navItemTintColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];
                _navBarImgString = @"pks_bg88.png";
                _navBarImgStringB7 = @"pks_bg128.png";
                break;
            case smartZhGameTypePKS:
                _deadTimeViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
                _deadTimeColor = [UIColor dp_colorFromHexString:@"#80daff"];
                _tableViewBgColor = [UIColor clearColor];
                _tableHeadBgColor = [UIColor dp_colorFromHexString:@"#013548"];
                _tableFootBgColor = [UIColor dp_colorFromHexString:@"#013548"];
                _tableHeadTextColor = [UIColor dp_colorFromHexString:@"#8bee8b"];
                _tableFootTextColor = [UIColor dp_colorFromHexString:@"#fefefe"];
                _tableBorderColor = [UIColor dp_colorFromHexString:@"#0b4619"];
                _checkTextColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _commitViewColor = [UIColor dp_colorFromHexString:@"#4b1d0d"];
                _zhinengBtnTitleColor = UIColorFromRGB(0x491706);
                _confirmBtnTitleColor = [UIColor clearColor];
                _bottomNumColor = [UIColor dp_colorFromHexString:@"#deff00"];
                _bottomTextColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _bottomSpLineColor = UIColorFromRGB(0x381509);
                _navItemTintColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];
                _navBarImgString = @"ks_bg88.png";
                _navBarImgStringB7 = @"ks_bg128.png";
                break;
            case smartZhGameType11X5:
                _deadTimeViewColor = [UIColor dp_colorFromHexString:@"#F4F3EF"];
                _deadTimeColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
//                _tableViewBgColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _tableViewBgColor = [UIColor clearColor];
                _tableHeadBgColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _tableFootBgColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _tableHeadTextColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
                _tableFootTextColor = [UIColor dp_colorFromHexString:@"#333333"];
                _tableBorderColor = [UIColor dp_colorFromHexString:@"#dad9ce"];
                _checkTextColor = [UIColor dp_colorFromHexString:@"#b9b2a5"];
                _commitViewColor = [UIColor dp_colorFromHexString:@"#ffffff"];
                _zhinengBtnTitleColor = [UIColor dp_colorFromHexString:@"#867d6d"];
                _confirmBtnTitleColor = [UIColor dp_colorFromHexString:@"#E7161A"];
                _bottomNumColor = [UIColor dp_colorFromHexString:@"#e7161a"];
                _bottomTextColor = [UIColor dp_colorFromHexString:@"#333333"];
                _bottomSpLineColor = [UIColor dp_colorFromHexString:@"#dad9ce"];
                _navItemTintColor = [UIColor dp_flatWhiteColor];
                break;
            default:
                break;
        }
        
    }
    return self;
}

@end

#define kRowHeight 35
@interface DPSmartFollowVC () <UITableViewDelegate, UITableViewDataSource, DPSmartPlanSetViewDelegate,DPRedPacketViewControllerDelegate>
{
    
    UIImageView     *_contentView;
    UIView          *_deadTimeView;
    UITableView     *_tableView;
    DPImageLabel    *_checkView;
    UIView          *_commitView;
    UILabel         *_bottomLabel;          // 底部金额label
    UILabel         *_deadIssueLabel,*_timeLabel;       // 截止期号  倒计时时间
    CCapacityFactor *_factorCenter;
    int             _amount;                // 方案金额
    int             _periods;               // 追号期数
    int             _multiple;              // 倍数
    int             _profitRate;            // 最低盈利率
    vector<int>     _szMultiple;            // 倍数数组
    vector<int>     _szMmount;              // 累计投入数组
    vector<int>     _szMinProfit;           // 盈利数组
    vector<int>     _szRate;                // 盈利率
    int             _gameIsuue;             // 期号
    string          _endTime;               // 截止时间
    NSMutableArray  *_smartSetDefault;    // 设置页面默认值
    int             _resultType;              // 数据加载结果
    int             _userPreferLine;        // 用户默认设置行
    int             _minGain;               //全程最低盈利
    int             _beforePeriod;          // 前几期
    int             _foreScale;             // 前几期最低盈利率
    int             _nextScale;              // 后几期最低盈利率
    CPokerThree *_pokerThree;
    CQuickThree *_quickThree;
    CJxsyxw *_jxsyxw;
}

@property (strong, nonatomic, readonly)UILabel *bottomLabel;
@property (strong, nonatomic, readonly)UILabel *deadIssueLabel,*timeLabel;
@property (strong, nonatomic, readonly)DPSmartFollowUI *UItype;
@property (nonatomic, assign) NSInteger timeSpace;
@property (nonatomic, strong) MSWeakTimer *timer;

@end

@implementation DPSmartFollowVC
@dynamic bottomLabel;
@dynamic deadIssueLabel,timeLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"智能追号";
        _periods = 10; // 期数
        _multiple = 1; // 初始默认值
        _profitRate = 30;
        self.timeSpace = -1;
        _userPreferLine = -1;
        _minGain = 30;
        _beforePeriod = 5;
        _foreScale = 50;
        _nextScale = 20;
        _smartSetDefault = [NSMutableArray arrayWithCapacity:5];
        [_smartSetDefault addObjectsFromArray:@[@30, @30, @5, @50, @20]];
        if (IOS_VERSION_7_OR_ABOVE) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }

    }
    return self;
}
-(void)createDataObject{
    switch (self.gameType) {
        case smartZhGameType11X5:
        {
            _jxsyxw=CFrameWork :: GetInstance() -> GetJxsyxw();
        }
            break;
        case smartZhGameTypePKS:
        {
            _pokerThree=CFrameWork :: GetInstance() -> GetPokerThree();
        }
            break;
        case smartZhGameTypeK3:
        {
            _quickThree= CFrameWork :: GetInstance() -> GetQuickThree();;
        }
            break;
        default:
            break;
    }
}
- (void)loadData
{
        int minBonus, maxBonus; // 最大最小金额
    switch (self.gameType) {
        case smartZhGameType11X5:
        {
           
            _jxsyxw -> CapacityBonusRange(minBonus, maxBonus);
            _amount = 2 * _jxsyxw -> GetTotalNote();
            _jxsyxw -> GetInfo(_gameIsuue, _endTime);
        }
            break;
        case smartZhGameTypePKS:
        {
           
            _pokerThree -> CapacityBonusRange(minBonus, maxBonus);
            _amount = 2 * _pokerThree -> GetTotalNote();
            _pokerThree -> GetInfo(_gameIsuue, _endTime);
        }
            break;
        case smartZhGameTypeK3:
        {
            _quickThree -> CapacityBonusRange(minBonus, maxBonus);
            _amount = 2 * _quickThree -> GetTotalNote();
            _quickThree -> GetInfo(_gameIsuue, _endTime);
        }
            break;
        default:
            break;
    }
    _factorCenter = CFrameWork :: GetInstance() -> GetCapacityFactor();
    _factorCenter -> SetProjectInfo(_amount, minBonus, maxBonus, _periods, _multiple);
    
    switch (_userPreferLine) {
        case 0:
            _factorCenter -> SetProfitAmount(_minGain);
            break;
        case 1:
            _factorCenter -> SetProfitRate(_profitRate);
            break;
        case 2:
            _factorCenter -> SetCondition(_beforePeriod, _foreScale, _nextScale);
            break;
        default:
            _factorCenter -> SetProfitRate(_profitRate);
            break;
    }
    
    vector<int> maxProfit;
    _resultType = _factorCenter -> Generate(_szMultiple, _szMmount, _szMinProfit, maxProfit, _szRate);

}
- (void)loadDataFirstTime
{
    [self loadData];
    if (_resultType == ERROR_OVERLARGE_EXPECT) {
        [self planSetButonClick];
    }
}
- (void)reloadUIData
{
    _deadIssueLabel.text = [NSString stringWithFormat:@"距离%02d期投注截止 :", _gameIsuue % 100];
    [self resetBottomLabelText];
    
    [_tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    UIColor *tintColor = [UIColor colorWithRed:0.98 green:0.71 blue:0.25 alpha:1];
    if (self.gameType == smartZhGameType11X5) {
        tintColor = [UIColor dp_flatWhiteColor];
    }
    NSString *imageName = nil;
    if (IOS_VERSION_7_OR_ABOVE) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : tintColor,
                                                                          UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
         imageName = self.UItype.navBarImgStringB7;
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : tintColor,
                                                                          UITextAttributeTextShadowOffset : [NSValue valueWithCGPoint:CGPointZero],
                                                                          UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
        imageName = self.UItype.navBarImgString;
    }

    switch (self.gameType) {
        case smartZhGameTypeK3:
             [self.navigationController.navigationBar setBackgroundImage:dp_NavigationImage(imageName) forBarMetrics:UIBarMetricsDefault];
            _quickThree->SetDelegate(self);
            break;
        case smartZhGameTypePKS:
            [self.navigationController.navigationBar setBackgroundImage:dp_NavigationImage(imageName) forBarMetrics:UIBarMetricsDefault];
            _pokerThree->SetDelegate(self);
            break;
            case smartZhGameType11X5:
            _jxsyxw->SetDelegate(self);
            break;
        default:
            break;
    }
    [self loadDataFirstTime];
    [self reloadUIData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_QuickThreeImage(@"q3transBack.png") title:nil tintColor:self.UItype.navItemTintColor target:self action:@selector(navLeftBtnClick)];

    [self _initialize];
    [self buildUI];
    
}
- (void)_initialize
{
    _contentView = [[UIImageView alloc]init];
    _contentView.userInteractionEnabled = YES;
    _deadTimeView = [[UIView alloc]init];
    _deadTimeView.backgroundColor = self.UItype.deadTimeViewColor;

    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = self.UItype.tableViewBgColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = kRowHeight;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.layer.borderColor = [self.UItype.tableBorderColor CGColor];
        tableView.layer.borderWidth = 0.5f;
        tableView;
    });
    
    _checkView = ({
        DPImageLabel *label = [[DPImageLabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.imagePosition = DPImagePositionLeft;
        label.image = dp_CommonImage(@"uncheck.png");
        label.highlightedImage = dp_CommonImage(@"check.png");
        label.highlighted = YES;
        label.font = [UIFont dp_systemFontOfSize:14];
        label.text = @"中奖后停止追号";
        label.textColor = self.UItype.checkTextColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkLabelClick)];
        [label addGestureRecognizer:tap];
        label;
    });
    _commitView = [[UIView alloc]init];
    _commitView.backgroundColor = self.UItype.commitViewColor;

    
    UIImage *bgImg = nil;
    
    switch (self.gameType) {
        case smartZhGameTypeK3:
            bgImg = dp_QuickThreeImage(@"quick3back.png");
            break;
        case smartZhGameTypePKS:
            bgImg = dp_PokerThreeImage(@"bg.png");
            break;
        case smartZhGameType11X5:
            _contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#F4F3EF"];
            break;
        default:
            break;
    }
    if (bgImg != nil) {
        _contentView.image = bgImg;
    }
}

- (void)buildUI
{
    [self.view addSubview:_contentView];
    [_contentView addSubview:_deadTimeView];
    [_contentView addSubview:_tableView];
    [_contentView addSubview:_checkView];
    [_contentView addSubview:_commitView];
    
    UIView *superView = _contentView;
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];

    [_deadTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@32);
    }];

    [_commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(superView);
        make.height.equalTo(@44);
    }];
    
    [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(15);
        make.bottom.equalTo(_commitView.mas_top).offset(- 20);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deadTimeView.mas_bottom).offset(10);
        make.left.equalTo(superView).offset(10);
        make.right.equalTo(superView).offset(- 10);
        make.bottom.equalTo(_checkView.mas_top).offset(- 10);
    }];
    
    [self buildDeadTimeView];
    
}
- (void)buildDeadTimeView
{
    [_deadTimeView addSubview:self.deadIssueLabel];
    [_deadTimeView addSubview:self.timeLabel];
    [self.deadIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deadTimeView).offset(15);
        make.top.equalTo(_deadTimeView.mas_centerY).offset(- 5);
        
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deadIssueLabel.mas_right).offset(5);
        make.centerY.equalTo(_deadTimeView.mas_centerY);

        
    }];
    [self buildCommitView];
}

- (void)buildCommitView
{
    UIButton *planSetBtn = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIView *lineView1 = [UIView dp_viewWithColor:self.UItype.bottomSpLineColor];
    UIView *lineView2 = [UIView dp_viewWithColor:self.UItype.bottomSpLineColor];
    
    if (self.gameType == smartZhGameType11X5) {
        [confirmButton setTitle:@"付款" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [confirmButton setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateNormal];
    }else {
        planSetBtn.backgroundColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
        [planSetBtn setBackgroundImage:dp_QuickThreeImage(@"q3transznzh.png") forState:UIControlStateNormal];
        [planSetBtn.titleLabel setFont:[UIFont dp_systemFontOfSize:14.0]];
        [confirmButton setBackgroundImage:dp_QuickThreeImage(@"q3transferSure.png") forState:UIControlStateNormal];
        [confirmButton setImage:dp_QuickThreeImage(@"q3transSumit.png") forState:UIControlStateNormal];
    }
    [planSetBtn setTitle:@"修改方案" forState:UIControlStateNormal];
    planSetBtn.titleLabel.font = [UIFont dp_systemFontOfSize:15];
     [planSetBtn setTitleColor:self.UItype.zhinengBtnTitleColor forState:UIControlStateNormal];
    [planSetBtn addTarget:self action:@selector(planSetButonClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.backgroundColor=self.UItype.confirmBtnTitleColor;
    
    [_commitView addSubview:planSetBtn];
    [_commitView addSubview:confirmButton];
    [_commitView addSubview:self.bottomLabel];
    [_commitView addSubview:lineView1];
    [_commitView addSubview:lineView2];
    
    [planSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commitView).offset(5);
        make.bottom.equalTo(_commitView).offset(-5);
        make.left.equalTo(_commitView).offset(3);
        make.width.equalTo(@70);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.gameType == smartZhGameType11X5) {
            make.top.equalTo(lineView2.mas_bottom);
            make.bottom.equalTo(_commitView);
            make.width.equalTo(@80);
            make.right.equalTo(_commitView);
        }else{
            make.top.equalTo(planSetBtn);
            make.bottom.equalTo(planSetBtn);
            make.width.equalTo(@70);
            make.right.equalTo(_commitView).offset(-3);
        }
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_commitView);
        make.centerY.equalTo(_commitView);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commitView);
        make.bottom.equalTo(_commitView);
        make.left.equalTo(planSetBtn.mas_right).offset(3);
        make.width.equalTo(@0.5);
        
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.gameType == smartZhGameType11X5) {
            make.bottom.equalTo(_commitView.mas_top);
            make.right.equalTo(_commitView);
            make.left.equalTo(_commitView);
            make.height.equalTo(@0.5);
        }else{
            make.top.equalTo(_commitView);
            make.bottom.equalTo(_commitView);
            make.right.equalTo(confirmButton.mas_left).offset(-3);
            make.width.equalTo(@0.5);
        }
    }];
    
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int legth = _szMultiple.size();
    return legth;
}

- (DPSmartTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    DPSmartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DPSmartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell setGameType:self.gameType indexPath:indexPath];
    
    NSString *issueString = [NSString stringWithFormat:@"%d", _gameIsuue + indexPath.row];
    NSString *shortStr = issueString;
    if (issueString.length > 2) {
     shortStr = [issueString substringFromIndex:issueString.length - 2];
    }
    cell.issueText = shortStr;
    cell.timesText = [NSString stringWithFormat:@"%d", _szMultiple[indexPath.row]];
    cell.devotionText = [NSString stringWithFormat:@"%d", _szMmount[indexPath.row]];
    cell.gainText = [NSString stringWithFormat:@"%d",_szMinProfit[indexPath.row]];
    cell.gainScaleText = [NSString stringWithFormat:@"%d%c",_szRate[indexPath.row],'%'];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = self.UItype.tableHeadBgColor;
    UILabel *issueLabel = [self createHeaderLabelWithColor:self.UItype.tableHeadTextColor text:@"期号"];
    UILabel *timesLabel = [self createHeaderLabelWithColor:self.UItype.tableHeadTextColor text:@"倍数"];
    UILabel *devotionLabel = [self createHeaderLabelWithColor:self.UItype.tableHeadTextColor text:@"累计投入"];
    UILabel *gainLabel = [self createHeaderLabelWithColor:self.UItype.tableHeadTextColor text:@"中奖盈利"];
    UILabel *gainScaleLabel = [self createHeaderLabelWithColor:self.UItype.tableHeadTextColor text:@"盈利率"];
    UIView  *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor dp_colorFromHexString:@"#dad9ce"];
    
    UIView *contentView = view;
    [contentView addSubview:issueLabel];
    [contentView addSubview:timesLabel];
    [contentView addSubview:devotionLabel];
    [contentView addSubview:gainLabel];
    [contentView addSubview:gainScaleLabel];
    [contentView addSubview:bottomLine];
    
    [issueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.centerY.equalTo(contentView);
    }];
    
    [timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(issueLabel.mas_left).offset(65);
        make.centerY.equalTo(contentView);
    }];
    
    [devotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(timesLabel.mas_centerX).offset(60);
        make.centerY.equalTo(contentView);
    }];
    
    [gainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(devotionLabel.mas_centerX).offset(70);
        make.centerY.equalTo(contentView);
    }];
    
    [gainScaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_right).offset(-25);
        make.centerY.equalTo(contentView);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    if (self.gameType != smartZhGameType11X5) {
        [bottomLine removeFromSuperview];
    }

    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = self.UItype.tableHeadBgColor;
    
    UILabel *footLabel = [[UILabel alloc]init];

//    footLabel.text = @"共10期 ,全程最低盈利率50%";
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.textColor = self.UItype.tableFootTextColor;
    footLabel.font = [UIFont dp_systemFontOfSize:13];
    int issueNum = _szMmount.size();
    int minRate = 0;
    if (_szRate.size() > 0) {
        minRate = _szRate[0];
        for (int i = 0; i < _szRate.size(); i++) {
            minRate = _szRate[i] < minRate ? _szRate[i] : minRate;
        }
        
    }
    NSString *minRateString = [NSString stringWithFormat:@"%d%c", minRate, '%'];
    footLabel.text = [NSString stringWithFormat:@"共%d期 ,全程最低盈利率%@",issueNum, minRateString];

    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor dp_colorFromHexString:@"#dad9ce"];
    [view addSubview:footLabel];
    [view addSubview:topLine];
    
    [footLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    
    if (self.gameType != smartZhGameType11X5) {
        [topLine removeFromSuperview];
    }

        return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UILabel *)createHeaderLabelWithColor:(UIColor *)color text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = [UIFont dp_systemFontOfSize:12];
    return label;
}
#pragma mark - DPSmartFollowSetViewDelegate
- (void)userPreferSetdown:(DPSmartPlanSetView *)setView
{
    _periods = setView.issue;
    _multiple = setView.times;
    _userPreferLine = setView.selectedLine;
    _minGain = setView.minGain;
    _profitRate = setView.minGainScale;
    _beforePeriod = setView.period; // 前几期
    _foreScale = setView.foreScale;
    _nextScale = setView.nextScale;
    
    _smartSetDefault = setView.textFieldsDatas; // 取得用户设置的默认数据
    
    [self loadData];
    [self reloadUIData];
}
#pragma mark - button点击
- (void)navLeftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)planSetButonClick
{
    int length = _periods;
//    int times = 1;
//    if (_szMultiple.size() > 0) {
//        times = _szMultiple[0];
//    }
    
     DPSmartPlanSetView *planSet = [[DPSmartPlanSetView alloc]init];
    planSet.myDelegate = self;
    planSet.originTimes = _multiple;
    planSet.originIssue = length;
    planSet.textFieldsDatas = _smartSetDefault;
    planSet.showWarning = _resultType == ERROR_OVERLARGE_EXPECT ? YES : NO;
    UIView *contentView = self.navigationController.view.window;
    [contentView addSubview:planSet];
    
    [planSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

}

- (void)confirmButtonClick {
    
    if (_resultType == ERROR_OVERLARGE_EXPECT) {
        [[DPToast makeText:@"您的盈利率设置过大, 无法达到预期, 请重新设置"]show];
        return;
    }
    
    if (_amount > 2000000) {
        [[DPToast makeText:dp_moneyLimitWarning]show];
        return;
    }
    
    int *followMultiple = (int *)alloca(sizeof(int) * _szMultiple.size());
    for (int i = 0; i < _szMultiple.size(); i++) {
        followMultiple[i] = _szMultiple[i];
    }
     int lotteryType=0;
    switch (self.gameType) {
        case smartZhGameTypePKS: {

            _pokerThree->SetCapacityInfo(followMultiple, _szMultiple.size(), _checkView.isHighlighted);
            lotteryType=GameTypeSdpks;
//            _pokerThree->SetDelegate(self);
            
//            __weak __typeof(self) weakSelf = self;
//            __block __typeof(pokerThree) weakInstance = pokerThree;
//            pokerThree->GoPay();
        } break;
        case smartZhGameTypeK3: {
            lotteryType=GameTypeNmgks;
            _quickThree->SetCapacityInfo(followMultiple, _szMultiple.size(), _checkView.isHighlighted);
//            _quickThree->SetDelegate(self);

//            quickThree->GoPay();
        } break;
        case smartZhGameType11X5: {
            
            _jxsyxw->SetCapacityInfo(followMultiple, _szMultiple.size(), _checkView.isHighlighted);
              lotteryType=GameTypeJxsyxw;
//            _jxsyxw->SetDelegate(self);
//            jxsyxw->GoPay();
        } break;
        default:
            break;
    }
    __weak __typeof(self) weakSelf = self;
    //            __block __typeof(pokerThree) weakInstance = pokerThree;
    void(^block)(void) = ^() {
        int length = _szMmount.size();
        int lastMount = length > 0 ? _szMmount[length - 1] : 0;
        CFrameWork::GetInstance()->GetAccount()->SetDelegate(weakSelf);
        CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(lotteryType, 1, lastMount, 0);
        [weakSelf.view.window showDarkHUD];
    };
    
    if (CFrameWork::GetInstance()->IsUserLogin()) {
        block();
    } else {
        DPLoginViewController *viewController = [[DPLoginViewController alloc] init];
        viewController.finishBlock = block;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)checkLabelClick {
    _checkView.highlighted = !_checkView.isHighlighted;
    
}

#pragma mark - getter和setter
- (UILabel *)bottomLabel
{
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.font = [UIFont dp_systemFontOfSize:13];

    }
    return _bottomLabel;
}

- (UILabel *)deadIssueLabel
{
    if (_deadIssueLabel == nil) {
        _deadIssueLabel = [[UILabel alloc]init];
        _deadIssueLabel.text = [NSString stringWithFormat:@"距离%02d期投注截止 :", _gameIsuue % 100];
        _deadIssueLabel.textColor = self.UItype.deadTimeColor;
        _deadIssueLabel.font = [UIFont dp_systemFontOfSize:12];
        _deadIssueLabel.backgroundColor = [UIColor clearColor];
        
        }
    
    return _deadIssueLabel;
}
- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        if (self.gameType == smartZhGameType11X5 ) {
            _timeLabel.textColor = self.UItype.deadTimeColor;
        }else{
            _timeLabel.textColor = UIColorFromRGB(0xffe761);
        }
        _timeLabel.font = [UIFont fontWithName:@"DigifaceWide" size:21];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    return _timeLabel;
}
- (void)setGameType:(smartZhGameType)gameType
{
    _gameType = gameType;
    
    _UItype = [[DPSmartFollowUI alloc]initWithGameType:gameType];
}

- (void)resetBottomLabelText
{
    int length = _szMmount.size();
    int lastMount = length > 0 ? _szMmount[length - 1] : 0;
    NSString *text = [NSString stringWithFormat:@"共追%d期 %d元", length, lastMount];
    NSString *lengthText = [NSString stringWithFormat:@"%d", length];
    NSString *lastMountText = [NSString stringWithFormat:@"%d", lastMount];
    
    NSMutableAttributedString *attribuString = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attribuString addAttribute:NSForegroundColorAttributeName value:self.UItype.bottomTextColor range:NSMakeRange(0, 2)];
    [attribuString addAttribute:NSForegroundColorAttributeName value:self.UItype.bottomTextColor range:NSMakeRange(2 + lengthText.length, 1)];
    [attribuString addAttribute:NSForegroundColorAttributeName value:self.UItype.bottomTextColor range:NSMakeRange(attribuString.length - 1, 1)];
    [attribuString addAttribute:NSForegroundColorAttributeName value:self.UItype.bottomNumColor range:NSMakeRange(2, lengthText.length)];
    [attribuString addAttribute:NSForegroundColorAttributeName value:self.UItype.bottomNumColor range:NSMakeRange(4 + lengthText.length, lastMountText.length)];
    
    _bottomLabel.attributedText = attribuString;
}

- (void)UpDateRequestedData {
    int issue;
    string endTime;
    int ret = -1;
    switch (self.gameType) {
        case smartZhGameTypePKS: {

            ret = _pokerThree->GetInfo(issue, endTime);
        } break;
        case smartZhGameTypeK3: {

            ret = _quickThree->GetInfo(issue, endTime);
        } break;
        case smartZhGameType11X5: {

            ret = _jxsyxw->GetInfo(issue, endTime);
        } break;
        default:
            break;
    }

    if (ret >= 0) {
        NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
        self.timeSpace = [[NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        _deadIssueLabel.text = [NSString stringWithFormat:@"距离%02d期投注截止 :", issue % 100];
        _gameIsuue = issue;
        [_tableView reloadData];
    }
}

#pragma NSTimer


- (void)pvt_reloadTimer {
    if (self.timeSpace == -1) {
        [self UpDateRequestedData];
    }
    if (self.timeSpace == 8) {
        switch (self.gameType) {
            case smartZhGameTypePKS: {
                
                _pokerThree->TimeOut();
            } break;
            case smartZhGameTypeK3: {
                
               _quickThree->TimeOut();
            } break;
            case smartZhGameType11X5: {
                
               _jxsyxw->TimeOut();
            } break;
                
            default:
                break;
        }
        
    }
    if (self.timeSpace == 0) {
        [self UpDateRequestedData];
    }
//    if (self.timeSpace == 0) {
//        // todo:
//        for (UIView *subView in self.navigationController.view.window.subviews) {
//            if ([subView isKindOfClass:[DPSmartPlanSetView class]]) {
//                [subView removeFromSuperview];
//            }
//        }
//
//        BOOL isShowSureView = NO;
//        for (UIView *subView in self.navigationController.view.window.subviews) {
//            if ([subView isKindOfClass:[DPSmartCountSureView class]]) {
//                isShowSureView = YES;
//                break;
//            }
//        }
//        if (!isShowSureView) {
//            int oldIssue = _gameIsuue;
//            [self UpDateRequestedData];
//            int curIssueShort = oldIssue % 100;
//            int nextIssue = _gameIsuue % 100;
//            NSString *issueString = [NSString stringWithFormat:@"%02d", curIssueShort];
//            NSString *nextIssueString = [NSString stringWithFormat:@"%02d", nextIssue];
//
////            DPSmartCountSureView *sureView = [[DPSmartCountSureView alloc] init];
////            [sureView setAlertText:[NSString stringWithFormat:@"%@期已经截止，现在初始期是%@期，请核对期号", issueString, nextIssueString]];
////            [self.navigationController.view.window addSubview:sureView];
////            [sureView mas_makeConstraints:^(MASConstraintMaker *make) {
////                        make.edges.equalTo(self.navigationController.view.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
////                           }];
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                if (sureView) {
////                    [sureView removeFromSuperview];
////                }
////            });
//
//        }
//
//        DPLog(@"end: %@", [[NSDate dp_date] dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]);
//    }
    
    if (self.timeSpace > 0) {

        int hours = ((int)self.timeSpace) / 3600;
        int mins = (((int)self.timeSpace) - 3600 * hours) / 60;
        int seconds = ((int)self.timeSpace) - 3600 * hours - 60 * mins;
        if (hours <= 0) {
            self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", mins, seconds];
        } else {
            self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds];
        }
    }
}

- (NSInteger)timeSpace {
    switch (self.gameType) {
        case smartZhGameTypeK3:
            return g_nmgksTimeSpace;
        case smartZhGameTypePKS:
            return g_sdpksTimeSpace;
        case smartZhGameType11X5:
            return g_jxsyxwTimeSpace;
        default:
            return 0;
    }
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    // ...
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
                int lotteryType = 0;
                switch (self.gameType) {
                    case smartZhGameTypePKS: {
                        lotteryType = GameTypeSdpks;
                    } break;
                    case smartZhGameTypeK3: {
                        lotteryType = GameTypeNmgks;
                    } break;
                    case smartZhGameType11X5: {
                        lotteryType = GameTypeJxsyxw;
                    } break;
                    default:
                        break;
                }
                
                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                viewController.gameTypeText = dp_GameTypeFullName((GameTypeId)lotteryType);
                int length = _szMmount.size();
                int lastMount = length > 0 ? _szMmount[length - 1] : 0;
                viewController.projectAmount = lastMount;
                viewController.delegate = self;
                viewController.gameType =(GameTypeId)lotteryType;
                viewController.isredPacket=isRedpacket;
                //                    if (self.addIssueTextField.text.intValue > 1) {
                //                        viewController.entryType = kEntryTypeFollow;
                //                    }
                [self.navigationController dp_applyGlobalTheme];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
//            case GOPLAY: {
//                [self dismissDarkHUD];
//                if (ret < 0) {
//                    [[DPToast makeText:DPPaymentErrorMsg(ret)] show];
//                } else {
//                    [self goPayCallback];
//                }
//            } break;    
            default:
                break;
        }
    });
}

#pragma mark - DPRedPacketViewControllerDelegate
- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType{
    if (ret >= 0) {
        [self goPayCallback];
    }
}


- (void)goPayCallback {
    int buyType; string token;
    switch (self.gameType) {
        case smartZhGameTypePKS: {
            
            _pokerThree->GetWebPayment(buyType, token);
        } break;
        case smartZhGameTypeK3: {
             _quickThree->GetWebPayment(buyType, token);
        } break;
        case smartZhGameType11X5: {
            
          _jxsyxw->GetWebPayment(buyType, token);
        } break;
        default:
            break;
    }

   
    NSString *urlString=kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    kAppDelegate.gotoHomeBuy = YES;
}


@end
