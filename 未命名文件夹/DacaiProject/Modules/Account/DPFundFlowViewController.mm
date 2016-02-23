//
//  DPFundFlowViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "DPFundFlowViewController.h"
#import "DPDrawingsVC.h"
#import "DPRechargeVC.h"
#import "FrameWork.h"
#import "DPAppParser.h"
#import "DPDrawingSuccessVC.h"
#import "DPNodataView.h"
#import "DPWebViewController.h"
@interface DPFundFlowCell : UITableViewCell {
@private
    UIView              *_colorLine;
    UIImageView         *_clockView;
    UILabel             *_monthLabel;
    UILabel             *_dayLabel;
    UILabel             *_timeLabel;
    UILabel             *_infoLabel;
    UILabel             *_titleLabel;
    UILabel             *_statusLabel;
    UILabel             *_amountLabel;
    UILabel             *_firstLineLabel;
    UILabel             *_secountLineLabel;
}

@property (nonatomic, strong, readonly) UIView              *colorLine;         // 彩色线
@property (nonatomic, strong, readonly) UIImageView         *clockView;         // 闹钟图标
@property (nonatomic, strong, readonly) UILabel             *monthLabel;        // 月
@property (nonatomic, strong, readonly) UILabel             *dayLabel;          // 日
@property (nonatomic, strong, readonly) UILabel             *timeLabel;         // 时间
@property (nonatomic, strong, readonly) UILabel             *infoLabel;         // 类型
@property (nonatomic, strong, readonly) UILabel             *titleLabel;        // 标题
@property (nonatomic, strong, readonly) UILabel             *statusLabel;       // 状态

@property (nonatomic, strong, readonly) UILabel             *amountLabel;       // 充值明细 单行
@property (nonatomic, strong, readonly) UILabel             *firstLineLabel;    // 第一行
@property (nonatomic, strong, readonly) UILabel             *secountLineLabel;  // 第二行

@end

@implementation DPFundFlowCell

- (void)buildLayout {
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.colorLine];
    [contentView addSubview:self.clockView];
    [contentView addSubview:self.monthLabel];
    [contentView addSubview:self.dayLabel];
    [contentView addSubview:self.timeLabel];
    [contentView addSubview:self.infoLabel];
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.statusLabel];
    [contentView addSubview:self.amountLabel];
    [contentView addSubview:self.firstLineLabel];
    [contentView addSubview:self.secountLineLabel];
    
    [self.colorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@4);
    }];
    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.width.equalTo(@12);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorLine.mas_right);
        make.width.equalTo(@30);
        make.bottom.equalTo(contentView.mas_centerY);
        make.height.equalTo(@13);
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorLine.mas_right);
        make.width.equalTo(@29);
        make.top.equalTo(contentView.mas_centerY);
        make.height.equalTo(@20);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clockView.mas_right);
        make.centerY.equalTo(self.dayLabel);
        make.width.equalTo(@35);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.centerY.equalTo(self.timeLabel);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clockView.mas_right);
        make.centerY.equalTo(self.monthLabel);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX).offset(10);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
    }];
    [self.firstLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView).offset(-5);
        make.right.equalTo(contentView).offset(-10);
    }];
    [self.secountLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLineLabel.mas_bottom);
        make.right.equalTo(contentView).offset(-10);
    }];
}

- (UIView *)colorLine {
    if (_colorLine == nil) {
        _colorLine = [[UIView alloc] init];
    }
    return _colorLine;
}

- (UIImageView *)clockView {
    if (_clockView == nil) {
        _clockView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"unwinclock.png") highlightedImage:dp_AccountImage(@"winclock.png")];
    }
    return _clockView;
}

- (UILabel *)monthLabel {
    if (_monthLabel == nil) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.backgroundColor = [UIColor clearColor];
        _monthLabel.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.37 alpha:1];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
//        _monthLabel.font = [UIFont dp_regularArialOfSize:10];
        _monthLabel.font = [UIFont dp_systemFontOfSize:10.5];
    }
    return _monthLabel;
}

- (UILabel *)dayLabel {
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.backgroundColor = [UIColor clearColor];
        _dayLabel.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.37 alpha:1];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont dp_regularArialOfSize:18];
        _dayLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _dayLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.37 alpha:1];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont dp_systemFontOfSize:10.5];
    }
    return _timeLabel;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = [UIColor colorWithRed:0.43 green:0.36 blue:0.23 alpha:1];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _infoLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor dp_flatBlackColor];
        _titleLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont dp_systemFontOfSize:12];
        _statusLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.backgroundColor = [UIColor clearColor];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.textColor = [UIColor dp_flatRedColor];
        _amountLabel.font = [UIFont dp_regularArialOfSize:18];
    }
    return _amountLabel;
}

- (UILabel *)firstLineLabel {
    if (_firstLineLabel == nil) {
        _firstLineLabel = [[UILabel alloc] init];
        _firstLineLabel.backgroundColor = [UIColor clearColor];
        _firstLineLabel.font = [UIFont dp_regularArialOfSize:18];
        _firstLineLabel.textAlignment = NSTextAlignmentRight;
    }
    return _firstLineLabel;
}

- (UILabel *)secountLineLabel {
    if (_secountLineLabel == nil) {
        _secountLineLabel = [[UILabel alloc] init];
        _secountLineLabel.backgroundColor = [UIColor clearColor];
        _secountLineLabel.textAlignment = NSTextAlignmentRight;
        _secountLineLabel.font = [UIFont dp_systemFontOfSize:11];
        _secountLineLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    }
    return _secountLineLabel;
}

@end

@interface DPFundFlowViewController () <
UITableViewDelegate,
UITableViewDataSource,
ModuleNotify
> {
@private
    UIView *_headerView;
    UIView *_tabBarView;
    UITableView *_tableView;
    UILabel *_realAmtLabel;
    UILabel *_coinAmtLabel;
    
    CFrameWork *_frameWork;
    
    UIView          *_indicatorLine; // 指示下划线
    UIView          *_bgLine; // 分割竖线
    DPNodataView    *_noDataView;
    NSInteger            _refCmdId;
}

@property (nonatomic, strong, readonly) UIView *headerView;
@property (nonatomic, strong, readonly) UIView *tabBarView;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UILabel *realAmtLabel;
@property (nonatomic, strong, readonly) UILabel *coinAmtLabel;
@property (nonatomic, strong, readonly) DPNodataView *noDataView; // 无数据或网络错误提示

@end

@implementation DPFundFlowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _frameWork = CFrameWork::GetInstance();
        _frameWork->GetAccount()->SetDelegate(self);
        
        self.fundType = 0;
    }
    return self;
}


- (void)dealloc {
    _frameWork->GetAccount()->ClearFundRecord(0);
    _frameWork->GetAccount()->ClearFundRecord(1);
    _frameWork->GetAccount()->ClearFundRecord(2);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    
    self.navigationItem.title = @"我的资金";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    
    UIView *contentView = self.view;
    
    // 分割竖线
    UIView *bgLine = ({
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:183.0/255 green:184.0/255 blue:177.0/255 alpha:0.8f];
        view.hidden = YES;
        view;
    });
    _bgLine = bgLine;
    [contentView addSubview:bgLine];
    [contentView addSubview:self.headerView];
    [contentView addSubview:self.tabBarView];
    [contentView addSubview:self.tableView];
//    [contentView addSubview:self.noDataView];
//    self.noDataView.hidden = YES;
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@110);
    }];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarView.mas_bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    
    [bgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView);
        make.bottom.equalTo(contentView);
        make.width.equalTo(@0.8);
        make.left.equalTo(self.tableView).offset(35.6);
    }];
    
//    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.tableView);
//        make.centerY.equalTo(self.tableView).offset(-20);
//        make.width.equalTo(@150);
//        make.height.equalTo(@150);
//    }];
    
    [self pvt_headerLayout];
    [self pvt_tabBarLayout];
    
    __weak DPFundFlowViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_refCmdId, CFrameWork::GetInstance()->GetAccount()->RefreshFundRecord(strongSelf.fundType, true));
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_refCmdId, CFrameWork::GetInstance()->GetAccount()->RefreshFundRecord(strongSelf.fundType));
    }];
    self.tableView.showsInfiniteScrolling = NO;
//    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
//        self.tableView.tableHeaderView = self.noDataView;
//    }
    [self showHUD];
    _refCmdId = _frameWork->GetAccount()->RefreshFundRecord(self.fundType);
}

- (void)pvt_headerLayout {
    self.headerView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIView *lineView = ({
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.87 alpha:1];
        lineView;
    });
    
    UIImageView *realImage = [[UIImageView alloc] initWithImage:dp_AccountImage(@"realAmt_big.png")];
    UIImageView *coinImage = [[UIImageView alloc] initWithImage:dp_AccountImage(@"coinAmt_big.png")];
    UILabel *realLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.62 green:0.59 blue:0.5 alpha:1];
        label.text = @"资金金额（元）";
        label.font = [UIFont dp_systemFontOfSize:11];
        label;
    });
    UILabel *coinLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.62 green:0.59 blue:0.5 alpha:1];
        label.text = @"大彩币（个）";
        label.font = [UIFont dp_systemFontOfSize:11];
        label;
    });
    UIImageView *bottomView = ({
        UIImageView *view = [[UIImageView alloc] initWithImage:dp_AccountImage(@"fundBg.png")];
        view;
    });
    UIButton *rechargeButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"充 值" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor dp_flatWhiteColor]];
        [button.layer setBorderWidth:1];
        [button.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.82 blue:0.78 alpha:1].CGColor];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14]];
        [button addTarget:self action:@selector(rechargeBtn) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *withdrawButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"提 款" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor dp_flatWhiteColor]];
        [button.layer setBorderWidth:1];
        [button.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.82 blue:0.78 alpha:1].CGColor];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14]];
        [button addTarget:self action:@selector(drawingBtn) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    UIView *contentView = self.headerView;
    
    [contentView addSubview:lineView];
    [contentView addSubview:realImage];
    [contentView addSubview:realLabel];
    [contentView addSubview:self.realAmtLabel];
    [contentView addSubview:coinImage];
    [contentView addSubview:coinLabel];
    [contentView addSubview:self.coinAmtLabel];
    [contentView addSubview:bottomView];
    [contentView addSubview:rechargeButton];
    [contentView addSubview:withdrawButton];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(10);
        make.height.equalTo(@50);
        make.width.equalTo(@0.5);
    }];
    [realImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(contentView).offset(10);
    }];
    [coinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView).offset(10);
    }];
    [realLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(45);
        make.top.equalTo(contentView).offset(15);
    }];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView).offset(45);
        make.top.equalTo(contentView).offset(15);
    }];
    [self.realAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(45);
        make.top.equalTo(contentView).offset(30);
    }];
    [self.coinAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView).offset(45);
        make.top.equalTo(contentView).offset(30);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@48);
    }];
    [rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_centerX).offset(-10);
        make.bottom.equalTo(contentView).offset(-6);
        make.height.equalTo(@30);
        make.width.equalTo(@135);
    }];
    [withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX).offset(10);
        make.bottom.equalTo(contentView).offset(-6);
        make.height.equalTo(@30);
        make.width.equalTo(@135);
    }];
    
    [self reFresheaderData];
}

//更新资金
-(void)reFresheaderData{
    string userName, realAmt;
    int coinAmt, redElpCount;
    if (_frameWork->GetAccount()->GetUserInfo(userName, realAmt, coinAmt, redElpCount) >= 0) {
        self.realAmtLabel.text = realAmt.length() == 0 ? @"0" : [NSString stringWithUTF8String:realAmt.c_str()];
        self.coinAmtLabel.text = [NSString stringWithFormat:@"%d", coinAmt];
    } else {
        
    }
}


//充值
-(void)rechargeBtn{
    DPRechargeVC *vc=[[DPRechargeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

// 
-(void)drawingBtn{
    DPDrawingsVC *vc=[[DPDrawingsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pvt_tabBarLayout {
    self.tabBarView.backgroundColor = [UIColor dp_flatWhiteColor];
    self.tabBarView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.82 blue:0.78 alpha:1].CGColor;
    self.tabBarView.layer.borderWidth = 0.5;
    
    UIButton *button1 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTag:0];
        [button setTitle:@"收支明细" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onTabBar:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        button;
    });
    UIButton *button2 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTag:1];
        [button setTitle:@"充值明细" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onTabBar:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        button;
    });
    UIButton *button3 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTag:2];
        [button setTitle:@"提款明细" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_onTabBar:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        button;
    });
    
    UIView *contentView = self.tabBarView;
    
    [contentView addSubview:button1];
    [contentView addSubview:button2];
    [contentView addSubview:button3];
   
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@100);
    }];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.right.equalTo(button2.mas_left);
        make.width.equalTo(@100);
    }];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(button2.mas_right);
        make.width.equalTo(@100);
    }];
    UIButton *defaultButton = nil;
    for (UIButton *button in contentView.subviews) {
        if (button.tag == self.fundType) {
            button.selected = YES;
            defaultButton = button;
            break;
        }
    }
    _indicatorLine = [[UIView alloc]init];
    _indicatorLine.backgroundColor = [UIColor dp_flatRedColor];
    [self.tabBarView addSubview:_indicatorLine];
    if (defaultButton != nil) {
        [_indicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(defaultButton);
            make.height.equalTo(@2);
            make.width.equalTo(defaultButton.titleLabel);
            
            make.bottom.equalTo(self.tabBarView);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _frameWork->GetAccount()->SetDelegate(self);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self reFresheaderData];
}

#pragma mark - event 

- (void)pvt_onBack {
    [DPAppParser backToLeftRootViewController:YES];
}

- (void)pvt_onTabBar:(UIButton *)button {
    UIView *contentView = button.superview;
    _bgLine.hidden = YES;
    for (id btn in contentView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setSelected:button == btn];
        }    }
    [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.height.equalTo(@2);
        make.width.equalTo(button.titleLabel);
        make.bottom.equalTo(contentView);
    }];

    self.fundType = button.tag;
    [self.tableView reloadData];
    int hasMore = 0;
    int count = _frameWork->GetAccount()->GetFundRecordCount(self.fundType, hasMore);
    if (hasMore && count == 0) {
        [self showHUD];
        REQUEST_RELOAD(_refCmdId, _frameWork->GetAccount()->RefreshFundRecord(self.fundType, true));
    }else{
        int rows = [self.tableView numberOfRowsInSection:0];
        _bgLine.hidden = !rows;
        self.tableView.tableHeaderView = nil;
        if (rows == 0 && hasMore == false) {
            self.noDataView.noDataState = DPNoData;
            self.tableView.tableHeaderView = self.noDataView;
        }
    }
    self.tableView.showsInfiniteScrolling = count > 0 && hasMore;
}

#pragma mark - table view's data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = _frameWork->GetAccount()->GetFundRecordCount(self.fundType, section);
    if (rows > 0) {
        _bgLine.hidden = NO;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DPFundFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPFundFlowCell alloc] init];
        [cell buildLayout];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    cell.backgroundColor = indexPath.row % 2 ? [UIColor colorWithRed:0.98 green:0.98 blue:0.95 alpha:1] : [UIColor colorWithRed:0.96 green:0.95 blue:0.91 alpha:1];
    
    //    static NSInteger COLOR_HEX[] = {0x16A085, 0x27AE60, 0x2980B9, 0x8E44AD, 0x2C3E50, 0xF39C12, 0xD35400, 0xC0392B, 0xBDC3C7, 0x7F8C8D};
    static NSInteger COLOR_HEX[] = {0x16A085, 0xF39C12, 0x2980B9, 0xC0392B, 0x8E44AD, 0x2C3E50, 0x7F8C8D};
    
    string time;
    int dayIndex, dayBegin, dayEnd;
    
    _frameWork->GetAccount()->GetFundRecordBaseInfo(self.fundType, indexPath.row, time, dayIndex, dayBegin, dayEnd);
    
    NSDate *date = [NSDate dp_dateFromString:[NSString stringWithUTF8String:time.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    
    cell.colorLine.backgroundColor = UIColorFromRGB(COLOR_HEX[dayIndex % ((sizeof(COLOR_HEX) / sizeof(NSInteger)))]);
    
    if (dayBegin) {
        cell.monthLabel.text = [NSString stringWithFormat:@"%02d月", date.dp_month];
        cell.dayLabel.text = [NSString stringWithFormat:@"%02d", date.dp_day];
    } else {
        cell.monthLabel.text = nil;
        cell.dayLabel.text = nil;
    }
    cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", date.dp_hour, date.dp_minute];
    
    switch (self.fundType) {
        case 0: {   // 收支明细
            string typeName, amount;
            int isProject, orderId, accountType;
            _frameWork->GetAccount()->GetFundRecordIncomeExpenses(self.fundType, indexPath.row, typeName, isProject, orderId, amount, accountType);
            
            NSString *amountText = [NSString stringWithUTF8String:amount.c_str()];
            if (amountText.floatValue > 0) {
                amountText = [@"+" stringByAppendingString:amountText];
            }
            cell.titleLabel.text = [NSString stringWithUTF8String:typeName.c_str()];
            cell.infoLabel.text = [(isProject ? @"方案号：" : @"订单号：") stringByAppendingFormat:@"%d", orderId];
            cell.firstLineLabel.text = amountText;
            cell.firstLineLabel.textColor = amountText.floatValue < 0 ? [UIColor colorWithRed:0.33 green:0.42 blue:0.02 alpha:1] : [UIColor dp_flatRedColor];
            switch (accountType) {
                case 1:
                    cell.secountLineLabel.text = @"资金";
                    break;
                case 2:
                    cell.secountLineLabel.text = @"大彩币";
                    break;
                case 3:
                    cell.secountLineLabel.text = @"红包";
                    break;
                default:
                    cell.secountLineLabel.text = nil;
                    break;
            }
            
            cell.statusLabel.text = nil;
            cell.amountLabel.text = nil;
        }
            break;
        case 1: {   // 充值明细
            string typeName, status, amount;
            _frameWork->GetAccount()->GetFundRecordRecharge(self.fundType, indexPath.row, typeName, status, amount);
            
            cell.titleLabel.text = [NSString stringWithUTF8String:typeName.c_str()];
            cell.statusLabel.text = [NSString stringWithUTF8String:status.c_str()];
            cell.amountLabel.text = [@"+" stringByAppendingString:[NSString stringWithUTF8String:amount.c_str()]];
            
            cell.infoLabel.text = nil;
            cell.firstLineLabel.text = nil;
            cell.secountLineLabel.text = nil;
        }
            break;
        case 2: {
            string cardName, cardNo, status, amount, charge;
            _frameWork->GetAccount()->GetFundRecordWithdraw(self.fundType, indexPath.row, cardName, cardNo, status, amount, charge);
            
            cell.titleLabel.text = [NSString stringWithUTF8String:cardName.c_str()];
            cell.infoLabel.text = [NSString stringWithUTF8String:cardNo.c_str()];
            cell.firstLineLabel.text = [NSString stringWithUTF8String:amount.c_str()];
            cell.firstLineLabel.textColor = [UIColor colorWithRed:0.33 green:0.42 blue:0.02 alpha:1];
            cell.secountLineLabel.text = [@"手续费：" stringByAppendingString:[NSString stringWithUTF8String:charge.c_str()]];
            cell.statusLabel.text = [NSString stringWithUTF8String:status.c_str()];
            
            cell.amountLabel.text = nil;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissHUD];
        if (ret < 0) {
            [[DPToast makeText:DPAccountErrorMsg(ret)] show];
        } else {
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
            _bgLine.hidden = ![self.tableView numberOfRowsInSection:0];
            int moreData = 0;
            int count = _frameWork->GetAccount()->GetFundRecordCount(self.fundType, moreData);
            self.tableView.showsInfiniteScrolling = count > 0 && moreData;
            
            [self reFresheaderData];
            
            self.tableView.tableHeaderView = nil ;
            NSInteger rowsCount = [self.tableView numberOfRowsInSection:0];
            if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
                if (rowsCount <=0) {
                    self.noDataView.noDataState = DPNoDataNoworkNet ;
                    self.tableView.tableHeaderView = self.noDataView ;
                }else{
                    [[DPToast makeText:kNoWorkNet]show];
                }
            }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
                if (rowsCount<=0) {
                    self.noDataView.noDataState = DPNoDataWorkNetFail ;
                    self.tableView.tableHeaderView = self.noDataView ;
                }else{
                    [[DPToast makeText:kWorkNetFail]show];
                }
            }else if (rowsCount <= 0){
                self.noDataView.noDataState = DPNoData ;
                self.tableView.tableHeaderView = self.noDataView ;
            }

        }
    });
}

#pragma mark - getter

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (UIView *)tabBarView {
    if (_tabBarView == nil) {
        _tabBarView = [[UIView alloc] init];
        _tabBarView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _tabBarView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 55;
    }
    return _tableView;
}

- (UILabel *)realAmtLabel {
    if (_realAmtLabel == nil) {
        _realAmtLabel = [[UILabel alloc] init];
        _realAmtLabel.backgroundColor = [UIColor clearColor];
        _realAmtLabel.textColor = [UIColor dp_flatRedColor];
        _realAmtLabel.font = [UIFont dp_regularArialOfSize:18];
    }
    return _realAmtLabel;
}

- (UILabel *)coinAmtLabel {
    if (_coinAmtLabel == nil) {
        _coinAmtLabel = [[UILabel alloc] init];
        _coinAmtLabel.backgroundColor = [UIColor clearColor];
        _coinAmtLabel.textColor = [UIColor dp_flatRedColor];
        _coinAmtLabel.font = [UIFont dp_regularArialOfSize:18];
    }
    return _coinAmtLabel;
}
-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44 - 140)];
        _noDataView.backgroundColor = [UIColor dp_colorFromHexString:@"#f4f3ef"];
        __weak __typeof(self) weakSelf = self;
        [_noDataView setClickBlock:^(BOOL setOrUpDate){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (setOrUpDate) {
                DPWebViewController *webView = [strongSelf dp_createCommonNoNetVC];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }else{
                [strongSelf showHUD];
                REQUEST_RELOAD_BLOCK(strongSelf->_refCmdId, CFrameWork::GetInstance()->GetAccount()->RefreshFundRecord(strongSelf.fundType, true));
            }
            
        }];
    }
    return _noDataView ;
}
- (DPWebViewController *)dp_createCommonNoNetVC
{
    DPWebViewController *webView = [[DPWebViewController alloc]init];
    webView.title = @"网络设置";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [[NSBundle mainBundle] bundleURL];
    [webView.webView loadHTMLString:str baseURL:url];
    return webView;
}
@end
