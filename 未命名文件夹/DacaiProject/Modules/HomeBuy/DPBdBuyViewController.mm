//
//  DPBdBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "FrameWork.h"
#import "DPCollapseTableView.h"
#import "DPBdBuyViewController.h"
#import "DPBdBuyCell.h"
#import "DPJczqAnalysisCell.h"
#import "DPBetToggleControl.h"

#import "DPJingCaiMoreView.h"
#import "DPNavigationMenu.h"
#import "DPNavigationTitleButton.h"
#import "DPBdTransferViewController.h"
#import "DPBdBuyMoreView.h"
#import "../../Common/View/DPSportFilterView.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"
#import "DPNodataView.h"


typedef NS_ENUM(NSInteger, BdIndex) {
    BdIndexBdRqspf,
    BdIndexBdBf,
    BdIndexBdZjq,
    BdIndexBdSxds,
    BdIndexBdBqc,
};

@interface DPBdBuyViewController () <
    DPBdBuyCellDelegate,
    DPCollapseTableViewDelegate,
    DPCollapseTableViewDataSource,
    ModuleNotify,
    DPSportFilterViewDelegate,
    DPNavigationMenuDelegate,
    DPBdBuyMoreViewDelegate,
    DPDropDownListDelegate,
    UIGestureRecognizerDelegate> {
@private
    CLotteryBd *_bdInstance;

    DPCollapseTableView *_tableView;
    UIView *_bottomView;
    UILabel *_promptLabel;
    DPNavigationMenu *_menu;
    DPNavigationTitleButton *_titleButton;
    DPNodataView *_noDataView ;
    NSMutableSet *_collapseSections;
    NSInteger _cmdId;
}

@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomView;
@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, strong, readonly) DPNavigationMenu *menu;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;

@property (nonatomic, strong) NSMutableArray *competitionList;
@property (nonatomic, strong) NSMutableArray *rqsList;
@property (nonatomic, strong, readonly) DPNodataView *noDataView;
@property (nonatomic, strong) NSMutableDictionary *analysisDic;
@end

@implementation DPBdBuyViewController
@dynamic noDataView ;

- (instancetype)init {
    if (self = [super init]) {
        _bdInstance = CFrameWork::GetInstance()->GetLotteryBd();
        _bdInstance->SetDelegate(self);
        _collapseSections = [NSMutableSet setWithCapacity:10];

        self.gameType = GameTypeBdRqspf;
        self.analysisDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self buildLayout];

    __block CLotteryBd *weak_bdInstance = _bdInstance;
    __weak DPBdBuyViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weak_bdInstance->Refresh());
    }];

    self.titleButton.titleText = self.menu.items[self.gameIndex];
    self.navigationItem.titleView = self.titleButton;
    if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    } else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onBack)];
    }
    self.navigationItem.rightBarButtonItems = ({
        UIBarButtonItem *filterItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"filter.png") target:self action:@selector(pvt_onFilter)];
        UIBarButtonItem *moreItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)];
        @[moreItem, filterItem];
    });

    [self showHUD];
    _cmdId = _bdInstance->Refresh();
}

- (void)dealloc {
    REQUEST_CANCEL(_cmdId);
    _bdInstance->Clear();
}

- (void)buildLayout {
    UIView *contentView = self.view;

    [contentView addSubview:self.bottomView];
    [contentView addSubview:self.tableView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@45);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    contentView = self.bottomView;

    UIButton *cleanupButton = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];

    // config control
    [cleanupButton setImage:dp_CommonImage(@"delete001_21.png") forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor dp_flatRedColor]];

    // bind event
    [cleanupButton addTarget:self action:@selector(pvt_onCleanup) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(pvt_onConfirm) forControlEvents:UIControlEventTouchUpInside];

    // move to view
    [contentView addSubview:cleanupButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.promptLabel];
    [contentView addSubview:confirmView];
    [contentView addSubview:lineView];

    // layout
    [cleanupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@55);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(cleanupButton.mas_right);
        make.right.equalTo(contentView);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton).offset(10);
        make.centerY.equalTo(confirmButton);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmButton).offset(-20);
        make.centerY.equalTo(confirmButton);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _bdInstance->SetDelegate(self);
    if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
        self.noDataView.noDataState =DPNoDataNoworkNet ;;
        self.tableView.tableHeaderView = self.noDataView ;
        [self dismissHUD];
        return ;
    }else{
        self.tableView.tableHeaderView = nil ;
    }

    [self pvt_reloadFilterInfo];
    [self pvt_resetFilterInfo];
    [self.tableView closeAllCells];
    [self.tableView reloadData];
    [self pvt_updatePrompt];
}

#pragma mark - getter, setter

- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        [_titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onExpandNav)]];
    }
    return _titleButton;
}

- (DPNavigationMenu *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenu alloc] init];
        _menu.viewController = self;
        _menu.items = @[ @"胜平负", @"比分", @"总进球", @"上下单双", @"半全场" ];
    }
    return _menu;
}

- (void)setGameType:(GameTypeId)gameType {
    _gameType = gameType;

    switch (gameType) {
        case GameTypeBdRqspf:
            _gameIndex = BdIndexBdRqspf;
            break;
        case GameTypeBdBqc:
            _gameIndex = BdIndexBdBqc;
            break;
        case GameTypeBdZjq:
            _gameIndex = BdIndexBdZjq;
            break;
        case GameTypeBdBf:
            _gameIndex = BdIndexBdBf;
            break;
        case GameTypeBdSxds:
            _gameIndex = BdIndexBdSxds;
            break;
        default:
            DPAssert(NO);
            break;
    }
    _bdInstance->SetGameType(self.gameType);
}

- (void)setGameIndex:(NSInteger)gameIndex {
    _gameIndex = gameIndex;

    switch (gameIndex) {
        case BdIndexBdRqspf:
            _gameType = GameTypeBdRqspf;
            break;
        case BdIndexBdSxds:
            _gameType = GameTypeBdSxds;
            break;
        case BdIndexBdBf:
            _gameType = GameTypeBdBf;
            break;
        case BdIndexBdZjq:
            _gameType = GameTypeBdZjq;
            break;
        case BdIndexBdBqc:
            _gameType = GameTypeBdBqc;
            break;
        default:
            DPAssert(NO);
            break;
    }
    _bdInstance->SetGameType(self.gameType);
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (DPCollapseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UILabel *)promptLabel {
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textColor = [UIColor dp_flatWhiteColor];
        _promptLabel.font = [UIFont dp_systemFontOfSize:13];
    }
    return _promptLabel;
}

- (NSMutableArray *)rqsList {
    if (_rqsList == nil) {
        _rqsList = [NSMutableArray array];
    }
    return _rqsList;
}

- (NSMutableArray *)competitionList {
    if (_competitionList == nil) {
        _competitionList = [NSMutableArray array];
    }
    return _competitionList;
}
-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        
        __weak __typeof(self) weakSelf = self;
        __block CLotteryBd *weak_bdInstance = _bdInstance;
        
        [_noDataView setClickBlock:^(BOOL setOrUpDate){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (setOrUpDate) {
                DPWebViewController *webView = [[DPWebViewController alloc]init];
                webView.title = @"网络设置";
                NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
                NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                NSURL *url = [[NSBundle mainBundle] bundleURL];
                DPLog(@"html string =%@, url = %@ ", str, url);
                [webView.webView loadHTMLString:str baseURL:url];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }else{
                REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weak_bdInstance->Refresh());
            }
            
        }];
    }
    return _noDataView ;
}

#pragma mark - private function

- (void)pvt_onCleanup {
    _bdInstance->CleanupAllOptions();

    [self.tableView reloadData];
    [self pvt_updatePrompt];
}

- (void)pvt_onConfirm {
    int count = _bdInstance->GetSelectedCount();
    if (count <= 0) {
        [[DPToast makeText:@"至少选择一场比赛"] show];
    } else if (count > 15) {
        [[DPToast makeText:@"最多选择15场比赛"] show];
    } else {
        DPBdTransferViewController *viewController = [[DPBdTransferViewController alloc] init];
        viewController.gameType = self.gameType;
        viewController.title = (@[ @"胜平负投注", @"比分投注", @"总进球投注", @"上下单双投注", @"半全场投注" ])[self.gameIndex];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)tapRecognizer {
    [_collapseSections dp_turnObject:@(tapRecognizer.view.tag)];
    [self.tableView reloadData];
}

- (NSString *)pvt_titleForSection:(NSInteger)section {
    string gameName;
    int numberOfRows;

    if ((_bdInstance->GetGroupInfo(section, gameName)) < 0 ||
        (numberOfRows = _bdInstance->GetTargetCount(section)) < 0) {
        return @"";
    }

    NSString *dateString = [NSString stringWithUTF8String:gameName.c_str()];
    NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd];
    dateString = [date dp_stringWithFormat:@"YYYY年MM月dd日"];

    return [NSString stringWithFormat:@"%@ %@   %d场比赛可投", dateString, [date dp_weekdayName], numberOfRows];
}

- (void)pvt_onExpandNav {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.gameIndex];
    [self.menu show];
}

- (void)pvt_onBack {

    if (_bdInstance->GetSelectedCount() <= 0) {
        _bdInstance->CleanupAllOptions();
        NSUInteger coun = self.navigationController.viewControllers.count;
        if (coun > 1) {
            [self.navigationController popViewControllerAnimated:YES];

        } else
            [self dismissViewControllerAnimated:YES completion:nil];

        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            _bdInstance->CleanupAllOptions();
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

- (void)pvt_onFilter {
    vector<string> competitions;
    vector<int> rqs;
    _bdInstance->GetFilterInfo(competitions, rqs);
    if (rqs.size() == 0 && competitions.size() == 0) {
        return;
    }

    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    coverView.backgroundColor = [UIColor dp_coverColor];
    coverView.alpha = 0;
    [self.navigationController.view addSubview:coverView];

    DPSportFilterView *filterView = [[DPSportFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [filterView setDelegate:self];
    [coverView addSubview:filterView];

    NSMutableArray *competitionsList = [NSMutableArray arrayWithCapacity:competitions.size()];
    NSMutableArray *rqsList = [NSMutableArray arrayWithCapacity:rqs.size()];

    if (self.gameType == GameTypeBdRqspf) {
        for (int i = 0; i < rqs.size(); i++) {
            if (rqs[i] > 0) {
                [rqsList addObject:[NSString stringWithFormat:@"客让%d球", rqs[i]]];
            } else if (rqs[i] < 0) {
                [rqsList addObject:[NSString stringWithFormat:@"主让%d球", -rqs[i]]];
            } else {
                [rqsList addObject:@"不让球"];
            }
        }
        [filterView addGroupWithTitle:@"让球选择" allItems:rqsList selectedItems:self.rqsList];
    }

    for (int i = 0; i < competitions.size(); i++) {
        [competitionsList addObject:[NSString stringWithUTF8String:competitions[i].c_str()]];
    }
    [filterView addGroupWithTitle:@"赛事选择" allItems:competitionsList selectedItems:self.competitionList];
    [filterView.collectionView layoutIfNeeded];
    [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(coverView).offset(40).priorityHigh();
        make.bottom.lessThanOrEqualTo(coverView).offset(-20).priorityHigh();
        make.left.equalTo(coverView);
        make.right.equalTo(coverView);
        make.height.equalTo(@(filterView.collectionView.contentSize.height + 40)).priorityLow();
        make.centerY.equalTo(coverView);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        coverView.alpha = 1;
    }];
}

#pragma mark - 菜单

- (void)pvt_onMore {
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];

    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:@[ @"开奖公告", @"玩法介绍", @"帮助" ]];
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
        case 0: { // 开奖公告
            viewController = ({
                DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
                viewController.gameType = self.gameType;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        } break;
        case 1: { // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeBdNone)]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO ;
                viewController;
            });
        } break;
        case 2: { // 帮助
            viewController = [[DPHelpWebViewController alloc] init];
        } break;
        default:
            break;
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pvt_updatePrompt {
    int count = _bdInstance->GetSelectedCount();
    if (count < 1) {
        self.promptLabel.text = @"至少选择1场比赛";
    } else {
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
    }
}

// 获取底层所有的过滤条件, 将上层条件还原
- (void)pvt_reloadFilterInfo {
    vector<string> competition;
    vector<int> rqs;
    _bdInstance->GetFilterInfo(competition, rqs);

    [self.competitionList removeAllObjects];
    [self.rqsList removeAllObjects];
    for (int i = 0; i < competition.size(); i++) {
        [self.competitionList addObject:[NSString stringWithUTF8String:competition[i].c_str()]];
    }
    for (int i = 0; i < rqs.size(); i++) {
        if (rqs[i] > 0) {
            [self.rqsList addObject:[NSString stringWithFormat:@"客让%d球", rqs[i]]];
        } else if (rqs[i] < 0) {
            [self.rqsList addObject:[NSString stringWithFormat:@"主让%d球", -rqs[i]]];
        } else {
            [self.rqsList addObject:@"不让球"];
        }
    }
}

// 向底层设置过滤条件(上层选中的)
- (void)pvt_resetFilterInfo {
    NSMutableArray *competitionList = nil;
    NSMutableArray *rqsList = nil;

    vector<string> competition;
    vector<int> rqs;
    _bdInstance->GetFilterInfo(competition, rqs);

    competitionList = [NSMutableArray arrayWithCapacity:competition.size()];
    rqsList = [NSMutableArray arrayWithCapacity:rqs.size()];
    for (int i = 0; i < competition.size(); i++) {
        [competitionList addObject:[NSString stringWithUTF8String:competition[i].c_str()]];
    }
    for (int i = 0; i < rqs.size(); i++) {
        if (rqs[i] > 0) {
            [rqsList addObject:[NSString stringWithFormat:@"客让%d球", rqs[i]]];
        } else if (rqs[i] < 0) {
            [rqsList addObject:[NSString stringWithFormat:@"主让%d球", -rqs[i]]];
        } else {
            [rqsList addObject:@"不让球"];
        }
    }

    int *selectedComeptition = (int *)alloca(sizeof(int) * competition.size());
    int *selectedRqs = (int *)alloca(sizeof(int) * rqs.size());

    for (int i = 0; i < competition.size(); i++) {
        selectedComeptition[i] = [self.competitionList containsObject:competitionList[i]];
    }
    for (int i = 0; i < rqs.size(); i++) {
        selectedRqs[i] = [self.rqsList containsObject:rqsList[i]];
    }

    _bdInstance->SetFilterInfo(selectedComeptition, competition.size(), selectedRqs, rqs.size());
}

#pragma mark - table view's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int section = MAX(0, _bdInstance->GetGroupCount());
        return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_collapseSections containsObject:@(section)]) {
        return 0;
    }
    return MAX(0, _bdInstance->GetTargetCount(section));
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView dp_viewWithColor:[UIColor whiteColor]];
    view.tag = section;

    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.82 alpha:1];
    line1.userInteractionEnabled = NO;
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.82 alpha:1];
    line2.userInteractionEnabled = NO;

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    label.text = [self pvt_titleForSection:section];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[_collapseSections containsObject:@(section)] ? dp_CommonImage(@"black_arrow_down.png") : dp_CommonImage(@"black_arrow_up.png")];

    [view addSubview:label];
    [view addSubview:line1];
    [view addSubview:line2];
    [view addSubview:imageView];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-55);;
    }];

    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHeaderTap:)]];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"BuyCell%d", self.gameIndex];

    DPBdBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPBdBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gameType = self.gameType;

        [cell buildLayout];
    }

    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    int spList[25], betOption[25] = {0}, rqs;

    _bdInstance->GetTargetInfo(indexPath.section, indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
    _bdInstance->GetTargetSpList(indexPath.section, indexPath.row, spList);
    _bdInstance->GetTargetOption(indexPath.section, indexPath.row, betOption);

    cell.competitionLabel.text = [NSString stringWithUTF8String:competitionName.c_str()];
    cell.orderNameLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.matchDateLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:endTime.c_str()] fromFormat:@"YYYY-MM-dd HH:mm:ss" toFormat:@"HH:mm截止"];

    cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
    cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
    cell.analysisView.highlighted = [self.tableView isExpandAtModelIndex:indexPath];

    cell.homeRankLabel.text = homeTeamRank.length() ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeTeamRank.c_str()]] : nil;
    cell.awayRankLabel.text = awayTeamRank.length() ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayTeamRank.c_str()]] : nil;

    switch (self.gameType) {
        case GameTypeBdRqspf: {
            cell.middleLabel.text = rqs == 0 ? @"VS" : [NSString stringWithFormat:@"%@%d", rqs > 0 ? @"+" : @"", rqs];
            cell.middleLabel.textColor = rqs == 0 ? [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1] : (rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor]);

            for (int i = 0; i < cell.optionButtonRqspf.count; i++) {
                [cell.optionButtonRqspf[i] setOddsText:FloatTextForIntDivHundred(spList[i])];
                [cell.optionButtonRqspf[i] setSelected:betOption[i]];
            }
        } break;
        case GameTypeBdSxds: {
            for (int i = 0; i < cell.optionButtonSxds.count; i++) {
                [cell.optionButtonSxds[i] setOddsText:FloatTextForIntDivHundred(spList[i])];
                [cell.optionButtonSxds[i] setSelected:betOption[i]];
            }
        } break;
        case GameTypeBdZjq: {
            for (int i = 0; i < cell.optionButtonZjq.count; i++) {
                [cell.optionButtonZjq[i] setOddsText:FloatTextForIntDivHundred(spList[i])];
                [cell.optionButtonZjq[i] setSelected:betOption[i]];
            }
        } break;
        case GameTypeBdBf: {
            NSMutableArray *items = [NSMutableArray array];
            static NSString *bfNames[] = {
                @"1:0",
                @"2:0",
                @"2:1",
                @"3:0",
                @"3:1",
                @"3:2",
                @"4:0",
                @"4:1",
                @"4:2",
                @"胜其他",
                @"0:0",
                @"1:1",
                @"2:2",
                @"3:3",
                @"平其他",
                @"0:1",
                @"0:2",
                @"1:2",
                @"0:3",
                @"1:3",
                @"2:3",
                @"0:4",
                @"1:4",
                @"2:4",
                @"负其他",
            };
            for (int i = 0; i < 25; i++) {
                if (betOption[i]) {
                    [items addObject:bfNames[i]];
                }
            }

            if (items.count == 0) {
                cell.optionLabel.text = @"比分投注";
                cell.optionLabel.highlighted = NO;
            } else {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.firstLineHeadIndent = 15;
                paragraphStyle.tailIndent = -15;
                paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
                paragraphStyle.alignment = NSTextAlignmentCenter;

                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[items componentsJoinedByString:@","]];
                [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.string.length)];

                cell.optionLabel.attributedText = attributedText;
                cell.optionLabel.highlighted = YES;
            }
        } break;
        case GameTypeBdBqc: {
            NSMutableArray *items = [NSMutableArray array];
            static NSString *bqcNames[] = { @"胜胜",
                                            @"胜平",
                                            @"胜负",
                                            @"平胜",
                                            @"平平",
                                            @"平负",
                                            @"负胜",
                                            @"负平",
                                            @"负负" };
            for (int i = 0; i < 9; i++) {
                if (betOption[i]) {
                    [items addObject:bqcNames[i]];
                }
            }

            if (items.count == 0) {
                cell.optionLabel.text = @"半全场投注";
                cell.optionLabel.highlighted = NO;
            } else {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.firstLineHeadIndent = 15;
                paragraphStyle.tailIndent = -15;
                paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
                paragraphStyle.alignment = NSTextAlignmentCenter;

                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[items componentsJoinedByString:@","]];
                [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.string.length)];

                cell.optionLabel.attributedText = attributedText;
                cell.optionLabel.highlighted = YES;
            }
        } break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeBdZjq:
            return 95;
        case GameTypeBdRqspf:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
        case GameTypeBdBf:
            return 80;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *CellIdentifier =[NSString stringWithFormat:@"AnalysisCell%d",self.gameType];
    DPJczqAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqAnalysisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.gameType = self.gameType;
        __weak __typeof(self) weakSelf = self;
        [ cell setClickBlock:^(DPJczqAnalysisCell*nalysisCell){
            NSIndexPath *pathIndex = [weakSelf.tableView modelIndexForCell:nalysisCell];
            
            string competition ;  int matchId= 0;
            CFrameWork::GetInstance()->GetLotteryBd()->GetTargetDataInfo(pathIndex.section, pathIndex.row, competition, matchId) ;
            DPLiveDataCenterViewController* vc = [[DPLiveDataCenterViewController alloc]initWithGameType:GameTypeZcNone withDefaultIndex:1 withMatchId:matchId] ;
            vc.title = [NSString stringWithUTF8String:competition.c_str()];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }] ;

    }
    [cell clearAllData];
    [self finishDPJcBdAnalysisCellData:indexPath cell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.gameType==GameTypeBdRqspf) {
              return 163-25;
        }
//        return 163-80;
    return 163 - 50;
}

- (void)finishDPJcBdAnalysisCellData:(NSIndexPath *)indexPath cell:(DPJczqAnalysisCell *)cell {
    string betProportion[3];
    string passMatches[3];
    string recentRecord[6];
    string averageOdds[3];
    int count;
    _bdInstance->GetTargetAnalysis(indexPath.section, indexPath.row, betProportion, passMatches, count, recentRecord, averageOdds);
    
    if (cell.ratioWinLabel) {
        cell.ratioWinLabel.text = [NSString stringWithUTF8String:betProportion[0].c_str()];
        cell.ratioTieLabel.text = [NSString stringWithUTF8String:betProportion[1].c_str()];
        cell.ratioLoseLabel.text = [NSString stringWithUTF8String:betProportion[2].c_str()];
    }

    cell.newestWinLabel.text = [NSString stringWithUTF8String:averageOdds[0].c_str()];
    cell.newestTieLabel.text = [NSString stringWithUTF8String:averageOdds[1].c_str()];
    cell.newestLoseLabel.text = [NSString stringWithUTF8String:averageOdds[2].c_str()];

    NSString *homeWin = [NSString stringWithUTF8String:recentRecord[0].c_str()];
    NSString *homeEqual = [NSString stringWithUTF8String:recentRecord[1].c_str()];
    NSString *homeLose = [NSString stringWithUTF8String:recentRecord[2].c_str()];
    NSString *awayWin = [NSString stringWithUTF8String:recentRecord[3].c_str()];
    NSString *awayEqual = [NSString stringWithUTF8String:recentRecord[4].c_str()];
    NSString *awayLose = [NSString stringWithUTF8String:recentRecord[5].c_str()];
    NSString *recentString = [NSString stringWithFormat:@"  主队 %@ %@ %@,客队 %@ %@ %@", homeWin, homeEqual, homeLose, awayWin, awayEqual, awayLose];
    NSMutableAttributedString *hinString = [[NSMutableAttributedString alloc] initWithString:recentString];
    //            NSRange numberRange1= [recentString rangeOfString:homeWin options:NSCaseInsensitiveSearch] ;
    //            NSRange numberRange2= [recentString rangeOfString:homeEqual options:NSCaseInsensitiveSearch] ;
    //            NSRange numberRange3= [recentString rangeOfString:homeLose options:NSCaseInsensitiveSearch] ;
    //            NSRange numberRange4= [recentString rangeOfString:awayWin options:NSCaseInsensitiveSearch] ;
    //            NSRange numberRange5= [recentString rangeOfString:awayEqual options:NSCaseInsensitiveSearch] ;
    //            NSRange numberRange6= [recentString rangeOfString:awayLose options:NSCaseInsensitiveSearch] ;
    //            [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, hinString.length)];
    //            [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:numberRange1];
    //            [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:numberRange2];
    //            [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:numberRange3];
    //            [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:numberRange4];
    //            [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:numberRange5];
    //            [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:numberRange6];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, hinString.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(5, homeWin.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(6 + homeWin.length, homeEqual.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:NSMakeRange(7 + homeWin.length + homeEqual.length, homeLose.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(11 + homeWin.length + homeEqual.length + homeLose.length, awayWin.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(12 + homeWin.length + homeEqual.length + homeLose.length + awayWin.length, awayEqual.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:NSMakeRange(13 + homeWin.length + homeEqual.length + homeLose.length + awayWin.length + awayLose.length, awayLose.length)];
    [cell.zhanJiLabel setText:hinString];

    int rqs;
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    _bdInstance->GetTargetInfo(indexPath.section, indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
    NSString *homeWinHistory = [NSString stringWithUTF8String:passMatches[0].c_str()];
    NSString *homeEqualHistory = [NSString stringWithUTF8String:passMatches[1].c_str()];
    NSString *homeLoseHistory = [NSString stringWithUTF8String:passMatches[2].c_str()];
    NSString *historyString = [NSString stringWithFormat:@"  近%d交战,%@ %@ %@ %@", count, [NSString stringWithUTF8String:homeTeamName.c_str()], homeWinHistory, homeEqualHistory, homeLoseHistory];
    NSMutableAttributedString *hinString2 = [[NSMutableAttributedString alloc] initWithString:historyString];
    NSRange numberRange11 = [historyString rangeOfString:homeWinHistory options:NSCaseInsensitiveSearch];
    NSRange numberRange12 = [historyString rangeOfString:homeEqualHistory options:NSCaseInsensitiveSearch];
    NSRange numberRange13 = [historyString rangeOfString:homeLoseHistory options:NSCaseInsensitiveSearch];
    [hinString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, hinString2.length)];
    [hinString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:numberRange11];
    [hinString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:numberRange12];
    [hinString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:numberRange13];
    [cell.historyLabel setText:hinString2];
}

#pragma mark - DPNavigationMenuDelegate

- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    self.gameIndex = index;
    [self.tableView closeAllCells];
    [self.tableView reloadData];
    [self pvt_updatePrompt];
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
}

#pragma mark - DPSportFilterViewDelegate

- (void)cancelFilterView:(DPSportFilterView *)filterView {
    [UIView animateWithDuration:0.3 animations:^{
        [filterView.superview setAlpha:0];
    } completion:^(BOOL finished) {
        [filterView.superview removeFromSuperview];
    }];
}

- (void)filterView:(DPSportFilterView *)filterView allGroups:(NSArray *)allGroups selectedGroups:(NSArray *)selectedGroups {
    [self cancelFilterView:filterView];

    NSMutableArray *competitionList = nil;
    NSMutableArray *rqsList = nil;

    if (selectedGroups.count == 1) {
        competitionList = [selectedGroups firstObject];
    } else if (selectedGroups.count == 2) {
        rqsList = [selectedGroups firstObject];
        competitionList = [selectedGroups lastObject];
    }
    [self.competitionList removeAllObjects];
    [self.rqsList removeAllObjects];
    [self.competitionList addObjectsFromArray:competitionList];
    [self.rqsList addObjectsFromArray:rqsList];

    [self pvt_resetFilterInfo];
    [self.tableView reloadData];
}

#pragma mark - DPBdBuyCellDelegate

- (void)bdBuyCell:(DPBdBuyCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected {
    DPAssert(gameType == self.gameType);
    NSIndexPath *indexPath = [self.tableView modelIndexForCell:cell];
    _bdInstance->SetTargetOption(indexPath.section, indexPath.row, index, selected);

    [self pvt_updatePrompt];
}

- (void)moreBdBuyCell:(DPBdBuyCell *)cell {
    DPBdBuyMoreView *buyMoreView = [[DPBdBuyMoreView alloc] init];
    [buyMoreView setGameType:self.gameType];
    [buyMoreView setIndexPath:[self.tableView modelIndexForCell:cell]];
    [buyMoreView setDelegate:self];
    [buyMoreView buildLayout];
    [self.navigationController.view addSubview:buyMoreView];
    [buyMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    buyMoreView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        buyMoreView.alpha = 1;
    }];
}

- (void)bdBuyCellInfo:(DPBdBuyCell *)cell {
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];
     [cell analysisViewIsExpand:[self.tableView isExpandAtModelIndex:modelIndex]];
    [self.tableView toggleCellAtModelIndex:modelIndex animation:YES];
}

#pragma mark - DPBdBuyMoreViewDelegate

- (void)dismissBdBuyMoreView:(DPBdBuyMoreView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        [view setAlpha:0];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)cancelBuyMoreView:(DPBdBuyMoreView *)view {
    [self dismissBdBuyMoreView:view];
}

- (void)confirmBuyMoreView:(DPBdBuyMoreView *)view {
    [self.tableView reloadCellAtModelIndex:view.indexPath];
    [self dismissBdBuyMoreView:view];
    [self pvt_updatePrompt];
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissHUD];
        [self.tableView.pullToRefreshView stopAnimating];
        // 重载数据
        [self.tableView closeAllCells];
        [self.tableView reloadData];
        [self pvt_updatePrompt];
        [self pvt_reloadFilterInfo];
//        if (ret >= 0) {
//            // 重载数据
//            [self.tableView closeAllCells];
//            [self.tableView reloadData];
//            [self pvt_updatePrompt];
//            [self pvt_reloadFilterInfo];
//        } else {
//            [[DPToast makeText:DPCommonErrorMsg(ret)] show];
//        }
//        
        self.tableView.tableHeaderView = nil ;
        NSInteger sectionCount = _bdInstance->GetGroupCount();
        if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
            if (sectionCount <=0) {
                self.noDataView.noDataState = DPNoDataNoworkNet ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kNoWorkNet]show];
            }
        }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
            if (sectionCount<=0) {
                self.noDataView.noDataState =DPNoDataWorkNetFail ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kWorkNetFail]show];
            }
        }else if (sectionCount <= 0){
            self.noDataView.noDataState = DPNoData ;
            self.tableView.tableHeaderView = self.noDataView ;
        }

    });
}

@end
