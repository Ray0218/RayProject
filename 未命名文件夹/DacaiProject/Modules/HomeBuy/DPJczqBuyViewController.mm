//
//  DPJczqBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "FrameWork.h"
#import "DPCollapseTableView.h"
#import "DPJczqBuyViewController.h"
#import "DPJczqBuyCell.h"
#import "DPJczqAnalysisCell.h"
#import "DPBetToggleControl.h"

#import "DPJingCaiMoreView.h"
#import "DPNavigationMenu.h"
#import "DPNavigationTitleButton.h"
#import "DPJczqTransferViewController.h"
#import "DPDropDownList.h"
#import "DPBetToggleControl.h"
#import "SVPullToRefresh.h"
#import "DPWebViewController.h"
#import "DPResultListViewController.h"
#import "DPHelpWebViewController.h"
#import "DPNodataView.h"


#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAppParser.h"
#import "DPJcdgBuyVC.h"
typedef NS_ENUM(NSInteger, JczqIndex) {
    JczqIndexJcHt,
    JczqIndexJcSpf,
    JczqIndexJcRqspf,
    JczqIndexJcBf,
    JczqIndexJcZjq,
    JczqIndexJcBqc,
};

@interface DPJczqBuyViewController () <
DPJczqBuyCellDelegate,
DPCollapseTableViewDelegate,
DPCollapseTableViewDataSource,
ModuleNotify,DPSportFilterViewDelegate,
DPJingCaiMoreDelegate,
DPNavigationMenuDelegate,
UIGestureRecognizerDelegate,
DPDropDownListDelegate> {
@private
    CLotteryJczq        *_jczqInstance;
    
    DPCollapseTableView *_tableView;
    UIView              *_bottomView;
    UILabel             *_promptLabel;
    
    NSMutableSet        *_collapseSections;
    DPNavigationMenu    *_menu;
    
    DPNavigationTitleButton *_titleButton;
//    BOOL _expand;
    NSInteger _cmdId;
    
    DPNodataView *_noDataView ;


}


@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomView;
@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, strong, readonly) DPNavigationMenu *menu;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong) NSMutableArray *competitionList;
@property (nonatomic, strong) NSMutableArray *rqsList;
//@property(nonatomic,strong)DPJczqBuyCell *jczqCell;
@property(nonatomic,strong)NSMutableDictionary *analysisDic;
@property (nonatomic, strong, readonly) DPNodataView *noDataView;

@end

@implementation DPJczqBuyViewController
@dynamic tableView;
@dynamic bottomView;
@dynamic promptLabel;
@dynamic menu;
@synthesize commands = _commands;
@synthesize noDataView ;

- (instancetype)init {
    if (self = [super init]) {
        _collapseSections = [NSMutableSet setWithCapacity:10];
        _competitionList = [NSMutableArray array];
        _rqsList = [NSMutableArray array];
        _jczqInstance = CFrameWork::GetInstance()->GetLotteryJczq();
        
        self.gameType = GameTypeJcHt;
    }
    return self;
}

- (void)dealloc {
    REQUEST_CANCEL(_cmdId);
    _jczqInstance->Clear();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self setTitle:@"竞彩足球"];
    [self buildLayout];
    [self showHUD];

    self.titleButton.titleText = self.menu.items[self.gameIndex];
    self.navigationItem.titleView = self.titleButton;
    if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    }else{
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onBack)];

    }
    self.navigationItem.rightBarButtonItems = ({
        UIBarButtonItem *filterItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"filter.png") target:self action:@selector(pvt_onFilter)];
        UIBarButtonItem *moreItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)];
        @[moreItem, filterItem];
    });
    
    __block __typeof(_jczqInstance) blockJczqInstance = _jczqInstance;
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, blockJczqInstance->Refresh());
    }];
    
    _cmdId = _jczqInstance->Refresh();
    self.analysisDic=[NSMutableDictionary dictionary];
}

- (void)buildLayout {
    UIView *contentView = self.view;

    [contentView addSubview:self.bottomView];
    [contentView addSubview:self.tableView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@48);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    contentView = self.bottomView;

    UIButton *cleanupButton = [[UIButton alloc] init];
    [cleanupButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"delete001_21.png")] forState:UIControlStateNormal];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];

    // config control
    confirmButton.backgroundColor = [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];

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
        make.width.equalTo(@50);
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
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _jczqInstance->SetDelegate(self);
    
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
//    [self.tableView reloadData];
    [self pvt_updatePrompt];
    [self.tableView closeAllCells];
    [self.tableView reloadData];
    [self.navigationController dp_applyGlobalTheme];
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
        _menu.items = @[ @"混合过关", @"胜平负", @"让球胜平负", @"比分", @"总进球", @"半全场",@"单关固定"];
    }
    return _menu;
}

- (void)setGameType:(GameTypeId)gameType {
    _gameType = gameType;

    switch (gameType) {
        case GameTypeJcSpf:
            _gameIndex = JczqIndexJcSpf;
            break;
        case GameTypeJcHt:
            _gameIndex = JczqIndexJcHt;
            break;
        case GameTypeJcRqspf:
            _gameIndex = JczqIndexJcRqspf;
            break;
        case GameTypeJcBf:
            _gameIndex = JczqIndexJcBf;
            break;
        case GameTypeJcBqc:
            _gameIndex = JczqIndexJcBqc;
            break;
        case GameTypeJcZjq:
            _gameIndex = JczqIndexJcZjq;
            break;
        default:
            DPAssert(NO);
            break;
    }
    
    _jczqInstance->SetGameType(_gameType);
}

- (void)setGameIndex:(NSInteger)gameIndex {
    _gameIndex = gameIndex;

    switch (gameIndex) {
        case JczqIndexJcSpf:
            _gameType = GameTypeJcSpf;
            break;
        case JczqIndexJcHt:
            _gameType = GameTypeJcHt;
            break;
        case JczqIndexJcRqspf:
            _gameType = GameTypeJcRqspf;
            break;
        case JczqIndexJcBf:
            _gameType = GameTypeJcBf;
            break;
        case JczqIndexJcBqc:
            _gameType = GameTypeJcBqc;
            break;
        case JczqIndexJcZjq:
            _gameType = GameTypeJcZjq;
            break;
        default:
            DPAssert(NO);
            break;
    }
    
    _jczqInstance->SetGameType(_gameType);
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
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.font = [UIFont dp_systemFontOfSize:12];
    }
    return _promptLabel;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _coverView;
}

-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_jczqInstance) blockJczqInstance = _jczqInstance;
        
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
                REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, blockJczqInstance->Refresh());
            }
            
        }];
    }
    return _noDataView ;
}

#pragma mark - private function

- (void)pvt_onCleanup {
    _jczqInstance->CleanupAllOptions();
    [self pvt_updatePrompt];

    [self.tableView reloadData];
}

- (void)pvt_onConfirm {
    int count = _jczqInstance->GetSelectedCount();
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
    if (count > 15) {
        [[DPToast makeText:@"最多选择15场比赛"] show];
        return;
    }
    
    DPJczqTransferViewController *viewController = [[DPJczqTransferViewController alloc] init];
    viewController.gameType = self.gameType;
    viewController.title = (@[@"混合投注", @"胜平负投注", @"让球胜平负投注", @"比分投注", @"总进球投注", @"半全场投注"])[self.gameIndex];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)tapRecognizer {
    [_collapseSections dp_turnObject:@(tapRecognizer.view.tag)];
    [self.tableView reloadData];
}

- (NSString *)pvt_titleForSection:(NSInteger)section {
    string gameName;
    int numberOfRows;

    if ((_jczqInstance->GetGroupInfo(section, gameName)) < 0 ||
        (numberOfRows = _jczqInstance->GetTargetCount(section)) < 0) {
        return @"";
    }

    NSString *dateString = [NSString stringWithUTF8String:gameName.c_str()];
    NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd];
    dateString = [date dp_stringWithFormat:@"yyyy年MM月dd日"];

    return [NSString stringWithFormat:@"%@ %@   %d场比赛可投", dateString, [date dp_weekdayName], numberOfRows];
}

- (void)pvt_onExpandNav {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.gameIndex];
    [self.menu show];
}

- (void)pvt_onBack {
    int count = _jczqInstance->GetSelectedCount();
    if (count<=0) {
        _jczqInstance->CleanupAllOptions();

        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft ) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        return ;
    }

    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            _jczqInstance->CleanupAllOptions();
            
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
    _jczqInstance->GetFilterInfo(competitions, rqs);
    if (rqs.size() == 0 && competitions.size() == 0) {
        return;
    }
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor dp_coverColor];
    coverView.alpha = 0;
    [self.navigationController.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    
    DPSportFilterView *filterView = [[DPSportFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [filterView setDelegate:self];
    [coverView addSubview:filterView];
    
    NSMutableArray *competitionsList = [NSMutableArray arrayWithCapacity:competitions.size()];
    NSMutableArray *rqsList = [NSMutableArray arrayWithCapacity:rqs.size()];
    
    if (self.gameType == GameTypeJcRqspf || self.gameType == GameTypeJcHt) {
        for (int i = 0; i < rqs.size(); i++) {
            if (rqs[i] > 0) {
                [rqsList addObject:[NSString stringWithFormat:@"客让%d球", rqs[i]]];
            } else if (rqs[i] < 0) {
                [rqsList addObject:[NSString stringWithFormat:@"主让%d球", -rqs[i]]];
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
    
    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:@[@"开奖公告", @"玩法介绍", @"帮助"]];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];
    
    
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coverView).offset(64);
        make.right.equalTo(coverView).offset(-20);
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


- (void)pvt_onTapMore:(UITapGestureRecognizer *)tapGestureRecognizer {
    [tapGestureRecognizer.view removeFromSuperview];
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
                viewController.gameType = self.gameType;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        }
            break;
        case 1: {   // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeJcNone)]];
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

#pragma mark - table view's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    int section = MAX(0, _jczqInstance->GetGroupCount());
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_collapseSections containsObject:@(section)]) {
        return 0;
    }
    return MAX(0, _jczqInstance->GetTargetCount(section));
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

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[_collapseSections containsObject:@(section)] ? dp_CommonImage(@"black_arrow_down.png") :  dp_CommonImage(@"black_arrow_up.png")];
    
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
        make.right.equalTo(view).offset(-55);
    }];

    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHeaderTap:)]];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"BuyCell%d", self.gameIndex];
    
    DPJczqBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gameType = self.gameType;

        [cell buildLayout];
    }
    
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    int spListRqspf[3], spListBf[31], spListZjq[8], spListBqc[9], spListSpf[3], rqs;
    int betOptionRqspf[3], betOptionBf[31], betOptionZjq[8], betOptionBqc[9], betOptionSpf[3];

    _jczqInstance->GetTargetInfo(indexPath.section, indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
    _jczqInstance->GetTargetSpList(indexPath.section, indexPath.row, spListRqspf, spListBf, spListZjq, spListBqc, spListSpf);
    _jczqInstance->GetTargetOption(indexPath.section, indexPath.row, betOptionRqspf, betOptionBf, betOptionZjq, betOptionBqc, betOptionSpf);
    
    cell.competitionLabel.text = [NSString stringWithUTF8String:competitionName.c_str()];
    cell.orderNameLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.matchDateLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:endTime.c_str()] fromFormat:@"YYYY-MM-dd HH:mm:ss" toFormat:@"HH:mm截止"];

    cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
    cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
    cell.analysisView.highlighted = [self.tableView isExpandAtModelIndex:indexPath];
    
    if (homeTeamRank.length() && homeTeamRank.length()) {
        NSString *homeRankString = [NSString stringWithUTF8String:homeTeamRank.c_str()];
        NSString *awayRankString = [NSString stringWithUTF8String:awayTeamRank.c_str()];
        
        cell.homeRankLabel.text = [NSString stringWithFormat:@"[%@]", homeRankString];
        cell.awayRankLabel.text = [NSString stringWithFormat:@"[%@]", awayRankString];
    }
    cell.hotView.hidden=!_jczqInstance->IsHotMatch(indexPath.section, indexPath.row);
    switch (self.gameType) {
        case GameTypeJcHt: {
           BOOL isVisible1= _jczqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeJcSpf);
            BOOL isVisible2= _jczqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeJcRqspf);

            BOOL moreBtnSelected = NO;
            for (int i = 0; i < 31; i++) {
                if (betOptionBf[i] >= 1) {
                    moreBtnSelected = YES;
                    break;
                }
            }
            if (moreBtnSelected == NO) {
                for (int i = 0; i < 9; i++) {
                    if (betOptionBqc[i] >= 1) {
                        moreBtnSelected = YES;
                        break;
                    }
                }
            }
            if (moreBtnSelected == NO) {
                for (int i = 0; i < 8; i++) {
                    if (betOptionZjq[i] >= 1) {
                        moreBtnSelected = YES;
                        break;
                    }
                }
            }
            cell.moreButton.selected = moreBtnSelected;
            cell.spfLabel.text = @"0";
            if (isVisible1) {
                cell.spfLabel.textColor = [UIColor dp_flatWhiteColor];
                cell.spfLabel.backgroundColor = [UIColor colorWithRed:0 green:0.67 blue:0.51 alpha:1];
                cell.spfLabel.layer.borderWidth=0;
            }else{
               
                cell.spfLabel.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];

                cell.spfLabel.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                cell.spfLabel.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
                cell.spfLabel.layer.borderWidth=1;
            }
            cell.rqspfLabel.text = [NSString stringWithFormat:@"%@%d", rqs > 0 ? @"+" : @"", rqs];
            if (isVisible2) {
                cell.rqspfLabel.textColor = rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];

                cell.rqspfLabel.backgroundColor = [UIColor colorWithRed:1 green:0.71 blue:0.15 alpha:1];
                cell.rqspfLabel.layer.borderWidth=0;
                
            }else{
                cell.rqspfLabel.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];

                cell.rqspfLabel.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                cell.rqspfLabel.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
                cell.rqspfLabel.layer.borderWidth=1;
            }
            
            cell.htSpfDGView.hidden=!_jczqInstance->IsSingleMatch(indexPath.section, indexPath.row, GameTypeJcSpf);
            cell.htRqDGView.hidden=!_jczqInstance->IsSingleMatch(indexPath.section, indexPath.row, GameTypeJcRqspf);
            
            
        }
            break;
            case GameTypeJcSpf:
            cell.otherDGView.hidden=!_jczqInstance->IsSingleMatch(indexPath.section, indexPath.row, self.gameType);
            break;
        case GameTypeJcRqspf: {
            cell.middleLabel.text = [NSString stringWithFormat:@"%@%d", rqs > 0 ? @"+" : @"", rqs];
            cell.middleLabel.textColor = rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
             cell.otherDGView.hidden=!_jczqInstance->IsSingleMatch(indexPath.section, indexPath.row, self.gameType);
        }
            break;
        case GameTypeJcBf: {
//            static NSString *bfNames[] = {
//                @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
//                @"0:0", @"1:1", @"2:2", @"3:3", @"平其他",
//                @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"0:5", @"1:5", @"2:5", @"负其他",
//            };
            
            
            NSArray *array = [NSArray arrayWithObjects:
                                          @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
                                          @"0:0", @"1:1", @"2:2", @"3:3", @"平其他", @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"0:5",
                                          @"1:5", @"2:5", @"负其他", nil];

            [self upDataJcBfBqcDataCell:cell array:array target:betOptionBf title:@"比分投注" divisionString:@","];
             cell.otherDGView.hidden=!_jczqInstance->IsSingleMatch(indexPath.section, indexPath.row, self.gameType);
        }
            break;
        case GameTypeJcZjq:
             cell.otherDGView.hidden=!_jczqInstance->IsSingleMatch(indexPath.section, indexPath.row, self.gameType);
            break;
        case GameTypeJcBqc: {
//            static NSString *bqcNames[] = { @"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负" };
            
            NSArray *array = [NSArray arrayWithObjects:@"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负", nil];
            [self upDataJcBfBqcDataCell:cell array:array target:betOptionBqc title:@"半全场投注" divisionString:@" | "];
             cell.otherDGView.hidden=!_jczqInstance->IsSingleMatch(indexPath.section, indexPath.row, self.gameType);
        }
            break;
           
        default:
            break;
    }
    
    for (int i = 0; i < cell.optionButtonsSpf.count; i++) {
        BOOL isVisible=YES;
        if (self.gameType==GameTypeJcHt) {
            isVisible= _jczqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeJcSpf);
        }
        DPBetToggleControl *control = cell.optionButtonsSpf[i];
        if (isVisible) {
             control.userInteractionEnabled=YES;
            control.oddsText = FloatTextForIntDivHundred(spListSpf[i]);
            control.selected = betOptionSpf[i];
            control.titleColor=[UIColor dp_flatBlackColor];
            cell.stopCellspf.hidden = YES ;
            

        }else {
            cell.stopCellspf.hidden = NO ;
            control.userInteractionEnabled=NO;
            control.titleColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
            control.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            control.oddsText =@"";
        }
    }
    for (int i = 0; i < cell.optionButtonsRqspf.count; i++) {
        BOOL isVisible=YES;
        if (self.gameType==GameTypeJcHt) {
            isVisible= _jczqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeJcRqspf);
        }
        DPBetToggleControl *control = cell.optionButtonsRqspf[i];
         if (isVisible) {
             control.userInteractionEnabled=YES;
            control.oddsText = FloatTextForIntDivHundred(spListRqspf[i]);
            control.selected = betOptionRqspf[i];
             cell.stopCellLabel.hidden = YES ;
         }else{
             cell.stopCellLabel.hidden = NO ;
             control.userInteractionEnabled=NO;
             control.titleColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
             control.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
             control.oddsText =@"";
         }
    }
    for (int i = 0; i < cell.optionButtonsZjq.count; i++) {
        DPBetToggleControl *control = cell.optionButtonsZjq[i];
        control.oddsText = FloatTextForIntDivHundred(spListZjq[i]);
        control.selected = betOptionZjq[i];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeJcHt:
            return 95;
        case GameTypeJcZjq:
            return 87;
        case GameTypeJcSpf:
        case GameTypeJcRqspf:
        case GameTypeJcBqc:
        case GameTypeJcBf:
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
        cell.gameType=self.gameType;
        
        __weak __typeof(self) weakSelf = self;
        [ cell setClickBlock:^(DPJczqAnalysisCell*nalysisCell){
            NSIndexPath *pathIndex = [weakSelf.tableView modelIndexForCell:nalysisCell];
            
            string competition ;  int matchId=0 ;
            CFrameWork::GetInstance()->GetLotteryJczq()->GetTargetDataInfo(pathIndex.section, pathIndex.row, competition, matchId) ;
            DPLiveDataCenterViewController* vc = [[DPLiveDataCenterViewController alloc]initWithGameType:GameTypeZcNone withDefaultIndex:1 withMatchId:matchId] ;
            vc.title = [NSString stringWithUTF8String:competition.c_str()];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }] ;

    }
    [cell clearAllData];

    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    int rqs;
    _jczqInstance->GetTargetInfo(indexPath.section, indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
     cell.rqs.text=[NSString stringWithFormat:@"%@%d", rqs > 0 ? @"+" : @"", rqs];
//   cell.rqs.textColor = rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
    
    [self finishDPJczqAnalysisCellData:indexPath cell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.gameType==GameTypeJcHt) {
         return 165;
    }
    if ((self.gameType==GameTypeJcSpf)||(self.gameType==GameTypeJcRqspf)) {
        return 140;
    }
    return 115;
}

- (void)finishDPJczqAnalysisCellData:(NSIndexPath *)indexPath cell:(DPJczqAnalysisCell *)cell {
    int status, count;
    string betProportion[6];
    string passMatches[3];
    string recentRecord[6];
    string averageOdds[3];
    
    _jczqInstance->GetTargetAnalysis(indexPath.section, indexPath.row, status, betProportion, passMatches, count, recentRecord, averageOdds);

       [cell.activityIndicatorView stopAnimating];
    
        cell.ratioWinLabel.text = [NSString stringWithUTF8String:betProportion[0].c_str()];
        cell.ratioTieLabel.text = [NSString stringWithUTF8String:betProportion[1].c_str()];
        cell.ratioLoseLabel.text = [NSString stringWithUTF8String:betProportion[2].c_str()];
    
   
        cell.rqWinLabel.text = [NSString stringWithUTF8String:betProportion[3].c_str()];
        cell.rqTieLabel.text = [NSString stringWithUTF8String:betProportion[4].c_str()];
        cell.rqLoseLabel.text = [NSString stringWithUTF8String:betProportion[5].c_str()];

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
//    NSRange numberRange1 = [recentString rangeOfString:homeWin options:NSCaseInsensitiveSearch];
//    NSRange numberRange2 = [recentString rangeOfString:homeEqual options:NSCaseInsensitiveSearch];
//    NSRange numberRange3 = [recentString rangeOfString:homeLose options:NSCaseInsensitiveSearch];
//    NSRange numberRange4 = [recentString rangeOfString:awayWin options:NSCaseInsensitiveSearch];
//    NSRange numberRange5 = [recentString rangeOfString:awayEqual options:NSCaseInsensitiveSearch];
//    NSRange numberRange6 = [recentString rangeOfString:awayLose options:NSCaseInsensitiveSearch];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, hinString.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(5, homeWin.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(6+homeWin.length, homeEqual.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:NSMakeRange(7+homeWin.length+homeEqual.length, homeLose.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(11+homeWin.length+homeEqual.length+homeLose.length, awayWin.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(12+homeWin.length+homeEqual.length+homeLose.length+awayWin.length, awayEqual.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:NSMakeRange(13+homeWin.length+homeEqual.length+homeLose.length+awayWin.length+awayLose.length, awayLose.length)];
    [cell.zhanJiLabel setText:hinString];

    int rqs;
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    _jczqInstance->GetTargetInfo(indexPath.section, indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
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

- (void)updateDPJczqAnalysisCellData:(NSIndexPath *)indexPath cell:(DPJczqAnalysisCell *)cell {

}

#pragma mark - DPSportFilterViewDelegate

- (void)cancelFilterView:(DPSportFilterView *)filterView {
    [UIView animateWithDuration:0.2 animations:^{
        filterView.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [filterView.superview removeFromSuperview];
    }];
    [self pvt_updatePrompt];
}

/**
 *  确定筛选条件
 *
 *  @param filterView     [in]触发事件的view
 *  @param allGroups      [in]所有条件的二维数据 e.g. @[@[@"主让2球", @"主让1球", @"不让球", @"客让2球"], @[@"德国杯", @"瑞士甲", @"英超", @"荷乙"]]
 *  @param selectedGroups [in]选中条件的二维数据 e.g. @[@[@"主让2球", @"不让球"], @[@"德国杯", @"瑞士甲"]]
 */
- (void)filterView:(DPSportFilterView *)filterView allGroups:(NSArray *)allGroups selectedGroups:(NSArray *)selectedGroups {
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
    [self cancelFilterView:filterView];
}

- (void)pvt_reloadFilterInfo {
    vector<string> competition;
    vector<int> rqs;
    _jczqInstance->GetFilterInfo(competition, rqs);
    
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
        }
    }
    [self pvt_updatePrompt];
}

- (void)pvt_resetFilterInfo {
    NSMutableArray *competitionList = nil;
    NSMutableArray *rqsList = nil;
    
    vector<string> competition;
    vector<int> rqs;
    _jczqInstance->GetFilterInfo(competition, rqs);
    
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
    
    _jczqInstance->SetFilterInfo(selectedComeptition, competition.size(), selectedRqs, rqs.size());
    [self pvt_updatePrompt];
}

#pragma mark - DPJczqBuyCellDelegate

- (void)jczqBuyCell:(DPJczqBuyCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView modelIndexForCell:cell];
    _jczqInstance->SetTargetOption(indexPath.section, indexPath.row, gameType, index, selected);
    [self pvt_updatePrompt];
}

- (void)jczqBuyCellInfo:(DPJczqBuyCell *)cell {
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];
    [cell analysisViewIsExpand:[self.tableView isExpandAtModelIndex:modelIndex]];
    [self.tableView toggleCellAtModelIndex:modelIndex animation:YES];
}

- (void)moreJczqBuyCell:(DPJczqBuyCell *)cell {
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];
    
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime; int rqs;
    int spListRqspf[3], spListBf[31], spListZjq[8], spListBqc[9], spListSpf[3];
    int betOptionRqspf[3], betOptionBf[31], betOptionZjq[8], betOptionBqc[9], betOptionSpf[3];
    _jczqInstance->GetTargetInfo(modelIndex.section, modelIndex.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
    _jczqInstance->GetTargetSpList(modelIndex.section, modelIndex.row, spListRqspf, spListBf, spListZjq, spListBqc, spListSpf);
    _jczqInstance->GetTargetOption(modelIndex.section, modelIndex.row, betOptionRqspf, betOptionBf, betOptionZjq, betOptionBqc, betOptionSpf);
    
    if (self.coverView.superview == nil) {
        [self.navigationController.view addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navigationController.view);
            make.right.equalTo(self.navigationController.view).offset(1);
            make.top.equalTo(self.navigationController.view);
            make.bottom.equalTo(self.navigationController.view);
        }];
        
        [self.coverView setAlpha:0.2];
        [UIView animateWithDuration:0.1 animations:^{
            self.coverView.alpha = 1;
        }];
    }
    DPJingCaiMoreView *buyView = [[DPJingCaiMoreView alloc] init];
    buyView.indexPath = modelIndex;
    buyView.tag=10020;
    buyView.gameType = self.gameType;
    buyView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    buyView.sp1 = spListRqspf;
    buyView.sp2 = spListBf;
    buyView.sp3 = spListZjq;
    buyView.sp4 = spListBqc;
    buyView.sp5 = spListSpf;
    buyView.isSel1=betOptionRqspf;
    buyView.isSel2=betOptionBf;
    buyView.isSel3=betOptionZjq;
    buyView.isSel4=betOptionBqc;
    buyView.isSel5=betOptionSpf;
    buyView.homeTeamName=[NSString stringWithUTF8String:homeTeamName.c_str()];
    buyView.awayTeamName=[NSString stringWithUTF8String:awayTeamName.c_str()];
    buyView.hotView.hidden=!_jczqInstance->IsHotMatch(modelIndex.section, modelIndex.row);//是否热门
    buyView.rqs=rqs;
    buyView.delegate = self;
    if (self.gameType==GameTypeJcHt) {
    int visible[5]={1};
    NSMutableArray *array=[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GameTypeJcSpf],[NSNumber numberWithInt:GameTypeJcRqspf],[NSNumber numberWithInt:GameTypeJcBf],[NSNumber numberWithInt:GameTypeJcZjq],[NSNumber numberWithInt:GameTypeJcBqc], nil];
    for (int i=0; i<array.count;i++){//是否可售
         NSInteger  gameType= [[array objectAtIndex:i] integerValue];
         BOOL isVisible= _jczqInstance->LotteryTypeVisible(modelIndex.section, modelIndex.row,gameType);
          visible[i]=isVisible;
         }
        buyView.isVisible=visible;
    }
    [self.coverView addSubview:buyView];
    CGFloat ballHeight=220;
    if (self.gameType==GameTypeJcHt) {
        
        ballHeight=kScreenHeight>540?540:kScreenHeight;
    }else if (self.gameType==GameTypeJcBf){
        ballHeight=280;
    }
    [buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(ballHeight));
        make.centerY.equalTo(self.navigationController.view);
    }];
    if (self.gameType==GameTypeJcHt) {//是否单关
        buyView.spfDanView.hidden=!_jczqInstance->IsSingleMatch(modelIndex.section, modelIndex.row, GameTypeJcSpf);
        buyView.rqDanView.hidden=!_jczqInstance->IsSingleMatch(modelIndex.section, modelIndex.row, GameTypeJcRqspf);
         buyView.bfDanView.hidden=!_jczqInstance->IsSingleMatch(modelIndex.section, modelIndex.row, GameTypeJcBf);
         buyView.zjqDanView.hidden=!_jczqInstance->IsSingleMatch(modelIndex.section, modelIndex.row, GameTypeJcZjq);
         buyView.bqcDanView.hidden=!_jczqInstance->IsSingleMatch(modelIndex.section, modelIndex.row, GameTypeJcBqc);
    }

}

- (void)pvt_tapCoverView {
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}
//提交
- (void)jingCaiMoreSureSelected:(DPJingCaiMoreView *)jingCaiView indexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeJcHt: {
            [self sumitJcData:jingCaiView spIndex:0 selectedType:GameTypeJcRqspf indexPath:indexPath count:3];
            [self sumitJcData:jingCaiView spIndex:1 selectedType:GameTypeJcBf indexPath:indexPath count:31];
           [self sumitJcData:jingCaiView spIndex:2 selectedType:GameTypeJcZjq indexPath:indexPath count:8];
            [self sumitJcData:jingCaiView spIndex:3 selectedType:GameTypeJcBqc indexPath:indexPath count:9];
            [self sumitJcData:jingCaiView spIndex:4 selectedType:GameTypeJcSpf indexPath:indexPath count:3];
//                             if (bfSelected||zjqSelected||bqcSelected) {
//                                 cell.moreButton.selected=YES;
//                             }else{
//                                 cell.moreButton.selected=NO;
//                             }
        } break;
        case GameTypeJcBf: {
            [self sumitJcData:jingCaiView spIndex:1 selectedType:GameTypeJcBf indexPath:indexPath count:31];
        } break;
        case GameTypeJcBqc: {
            [self sumitJcData:jingCaiView spIndex:3 selectedType:GameTypeJcBqc indexPath:indexPath count:9];
        } break;
        default:
            break;
    }
    [self.tableView reloadData];
   
    [self pvt_updatePrompt];
     [self pvt_tapCoverView];
     [jingCaiView removeFromSuperview];
}
-(void)jingCaiMoreCancel:(DPJingCaiMoreView *)jingCaiView{
  
    [self pvt_tapCoverView];
    [self pvt_updatePrompt];
      [jingCaiView removeFromSuperview];
}
//提交所选到低层<通用>
- (void)sumitJcData:(DPJingCaiMoreView *)jingCaiView
            spIndex:(int)spIndex
       selectedType:(int)selectedType
          indexPath:(NSIndexPath *)indexPath
              count:(int)count {
    
    for (int i = 0; i < count; i++) {
        DPBetToggleControl *obj = (DPBetToggleControl *)[jingCaiView.scroView viewWithTag:(selectedType << 16) | i];
      _jczqInstance->SetTargetOption(indexPath.section, indexPath.row, selectedType, i, obj.selected);
      
    }
}
//更新比分，半全场数据
- (void)upDataJcBfBqcDataCell:(DPJczqBuyCell *)cell array:(NSArray *)array target:(int[])chk title:(NSString *)title divisionString:(NSString *)divisionString {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    int count = 0;
    for (int i = 0; i < array.count; i++) {
        if (chk[i] == 1) {
            if (count == 0) {
                [string appendFormat:@"%@", [array objectAtIndex:i]];
            } else {
                [string appendFormat:@"%@%@", divisionString, [array objectAtIndex:i]];
            }
            count = count + 1;
        }
    }
    UIButton *button = (UIButton *)[cell viewWithTag:(self.gameType << 16) | 0];
    if (string.length > 0) {
        [button setTitleColor:UIColorFromRGB(0xe7161a) forState:UIControlStateNormal];
        [button setTitle:string forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        return;
    }
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
}

#pragma mark - DPNavigationMenuDelegate

- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    if (index==6) {
        DPJcdgBuyVC *vc=[[DPJcdgBuyVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    self.gameIndex = index;
    [self.tableView closeAllCells];
    [self.tableView reloadData];
    [self pvt_updatePrompt];
    [self pvt_reloadFilterInfo];
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    if(self.menu.selectedIndex==6){
        return;
    }
    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
}
- (void)pvt_updatePrompt {
    int count = _jczqInstance->GetSelectedCount();
    if(count<1){
        self.promptLabel.text=@"请选择比赛";
        return;
    }
    if (self.gameType == GameTypeJcBf) {
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
        return;
    }
    if(_jczqInstance->IsSelectedAllSingle()){
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
        return;
    }
        if (count < 2) {
            self.promptLabel.text = @"已选1场，还差1场";
            return;
        }
    
    self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        if (cmdtype == ANALYSIS) {
//            [self.tableView reloadData];
            NSIndexPath *modexIndex = [self.analysisDic objectForKey:@(cmdId)];
            DPJczqAnalysisCell *cell = [self.tableView cellForRowAtModelIndex:modexIndex expand:YES];
            if (cell) {
                [self finishDPJczqAnalysisCellData:modexIndex cell:cell];
            }
            return ;
        }
        [self.tableView.pullToRefreshView stopAnimating];
        // 重载数据
        [self dismissLoadingView];
        [self dismissHUD];
        [self.tableView closeAllCells];
        [self.tableView reloadData];
        [self pvt_updatePrompt];
        [self pvt_reloadFilterInfo];
        
        
        self.tableView.tableHeaderView = nil ;
        NSInteger sectionCount = _jczqInstance->GetGroupCount();
        if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
            if (sectionCount <=0) {
                self.noDataView.noDataState = DPNoDataNoworkNet ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kNoWorkNet_]show];
            }
        }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
            if (sectionCount<=0) {
                self.noDataView.noDataState =DPNoDataWorkNetFail ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kWorkNetFail_]show];
            }
        }else if (sectionCount <= 0){
            self.noDataView.noDataState = DPNoData ;
            self.tableView.tableHeaderView = self.noDataView ;
        }

    });
}

@end
