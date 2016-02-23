//
//  DPJclqBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJclqBuyViewController.h"
#import "FrameWork.h"
#import "DPCollapseTableView.h"
#import "DPBetToggleControl.h"
#import "DPNavigationMenu.h"
#import "DPNavigationTitleButton.h"
#import "DPJclqTransferVC.h"
#import "DPJcLqBuyCelll.h"
#import "DPLanCaiMoreView.h"
#import "DPDropDownList.h"
#import "../../Common/Component/SVPullToRefresh/SVPullToRefresh.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"

#import "DPNodataView.h"

typedef NS_ENUM(NSInteger, JczqIndex) {
    JclqIndexLcHt,
    JclqIndexLcSf,
    JclqIndexLcRqsf,
    JclqIndexLcDxf,
    JclqIndexLcSfc,
};
@interface DPJclqBuyViewController () <DPCollapseTableViewDelegate, DPCollapseTableViewDataSource, ModuleNotify, DPSportFilterViewDelegate, DPNavigationMenuDelegate, DPJcLqBuyCellDelegate, DPJclqMoreDelegate, UIGestureRecognizerDelegate, DPDropDownListDelegate> {

@private
    CLotteryJclq *_jclqInstance;
    DPCollapseTableView *_tableView;
    UIView *_bottomView;
    UILabel *_promptLabel;

    NSMutableSet *_collapseSections;
    DPNavigationMenu *_menu;

    DPNavigationTitleButton *_titleButton;
    UIImageView *_noDataImgView;
    NSInteger _cmdId;
    
    DPNodataView *_noDataView ;
    
}

@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomView;
@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, strong, readonly) DPNavigationMenu *menu;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong) NSMutableArray *competitionList;
@property (nonatomic, strong, readonly) UIImageView *noDataImgView;


@property (nonatomic, strong, readonly) DPNodataView *noDataView;

@end

@implementation DPJclqBuyViewController
@dynamic tableView;
@dynamic bottomView;
@dynamic promptLabel;
@dynamic menu;
@synthesize commands = _commands;
@dynamic noDataImgView;
@dynamic noDataView ;

- (instancetype)init {
    if (self = [super init]) {
        _jclqInstance = CFrameWork::GetInstance()->GetLotteryJclq();
        _jclqInstance->SetDelegate(self);
        _collapseSections = [NSMutableSet setWithCapacity:10];

        self.gameType = GameTypeLcHt;
    }
    return self;
}

- (void)dealloc {
    REQUEST_CANCEL(_cmdId);
    _jclqInstance->Clear();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self setTitle:@"竞彩篮球"];
    [self buildLayout];
    [self showHUD];
    __block CLotteryJclq *weak_jclqInstance = _jclqInstance;
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weak_jclqInstance->Refresh());
    }];

    self.titleButton.titleText = self.menu.items[self.gameIndex];
    self.navigationItem.titleView = self.titleButton;

    if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onNavLeft:)];
    } else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onNavLeft:)];
    }
    self.navigationItem.rightBarButtonItems = ({
        UIBarButtonItem *filterItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"filter.png") target:self action:@selector(pvt_onFilter)];
        UIBarButtonItem *moreItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)];
        @[moreItem, filterItem];
    });

    _cmdId = _jclqInstance->Refresh();
}

- (void)buildLayout {
    UIView *contentView = self.view;

    [contentView addSubview:self.bottomView];
    [contentView addSubview:self.tableView];
//    [contentView addSubview:self.noDataImgView];
    
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
    
    
    self.noDataImgView.hidden = YES;
    contentView = self.bottomView;

    UIButton *cleanupButton = [[UIButton alloc] init];
    [cleanupButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"delete001_21.png")] forState:UIControlStateNormal];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
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
    [super viewWillAppear:animated];
    _jclqInstance->SetDelegate(self);
  
    
    [self pvt_reloadFilterInfo];
    [self pvt_resetFilterInfo];
    [self showOrChangeBottomText];
    [self.tableView reloadData];
    [self showOrChangeBottomText];
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
        _menu.items = @[ @"混合过关", @"胜负", @"让分胜负", @"大小分", @"胜分差" ];
    }
    return _menu;
}

- (void)setGameType:(GameTypeId)gameType {
    _gameType = gameType;

    switch (gameType) {
        case GameTypeLcHt:
            _gameIndex = JclqIndexLcHt;
            break;
        case GameTypeLcSf:
            _gameIndex = JclqIndexLcSf;
            break;
        case GameTypeLcRfsf:
            _gameIndex = JclqIndexLcRqsf;
            break;
        case GameTypeLcDxf:
            _gameIndex = JclqIndexLcDxf;
            break;
        case GameTypeLcSfc:
            _gameIndex = JclqIndexLcSfc;
            break;
        default:
            DPAssert(NO);
            break;
    }

    _jclqInstance->SetGameType(_gameType);
}

- (void)setGameIndex:(NSInteger)gameIndex {
    _gameIndex = gameIndex;

    switch (gameIndex) {
        case JclqIndexLcHt:
            _gameType = GameTypeLcHt;
            break;
        case JclqIndexLcSf:
            _gameType = GameTypeLcSf;
            break;
        case JclqIndexLcRqsf:
            _gameType = GameTypeLcRfsf;
            break;
        case JclqIndexLcDxf:
            _gameType = GameTypeLcDxf;
            break;
        case JclqIndexLcSfc:
            _gameType = GameTypeLcSfc;
            break;
        default:
            DPAssert(NO);
            break;
    }

    _jclqInstance->SetGameType(_gameType);
}

- (NSMutableArray *)competitionList {
    if (_competitionList == nil) {
        _competitionList = [NSMutableArray array];
    }
    return _competitionList;
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
- (UIImageView *)noDataImgView {
    if (_noDataImgView == nil) {
        _noDataImgView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"lcNoData.png")];
    }
    return _noDataImgView;
}
-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        _noDataView.gameType = GameTypeLcNone ;
        __weak __typeof(self) weakSelf = self;
        __block CLotteryJclq *weak_jclqInstance = _jclqInstance;

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
                REQUEST_RELOAD_BLOCK(strongSelf->_cmdId, weak_jclqInstance->Refresh());
            }
            
        }];
    }
    return _noDataView ;
}

#pragma mark - private function

- (void)pvt_onCleanup {
    _jclqInstance->CleanupAllOptions();
    [self showOrChangeBottomText];
    [self.tableView reloadData];
}

- (void)pvt_onConfirm {
    int count = _jclqInstance->GetSelectedCount();
    if (self.gameType == GameTypeLcSfc) {
        if (count < 1) {
            [[DPToast makeText:@"请至少选择1场比赛"] show];
            return;
        }
    } else if (count < 2) {
        [[DPToast makeText:@"请至少选择两场比赛"] show];
        return;
    }
    if (count > 15) {
        [[DPToast makeText:@"最多选择15场比赛"] show];
        return;
    }

    DPJclqTransferVC *viewController = [[DPJclqTransferVC alloc] init];
    viewController.gameType = self.gameType;
    viewController.title = (@[ @"混合投注", @"胜负投注", @"让分胜负投注", @"大小分投注", @"胜分差投注" ])[self.gameIndex];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)tapRecognizer {
    [_collapseSections dp_turnObject:@(tapRecognizer.view.tag)];
//    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tapRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)pvt_titleForSection:(NSInteger)section {
    string gameName;
    int numberOfRows;

    if ((_jclqInstance->GetGroupInfo(section, gameName)) < 0 ||
        (numberOfRows = _jclqInstance->GetTargetCount(section)) < 0) {
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

- (void)pvt_onNavLeft:(UIButton *)button {

    int count = _jclqInstance->GetSelectedCount();
    if (count <= 0) {
        _jclqInstance->CleanupAllOptions();

        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [self.navigationController popViewControllerAnimated:YES];
        } else
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            _jclqInstance->CleanupAllOptions();
            
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
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
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeLcNone)]];
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

#pragma mark - table view's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    int section = _jclqInstance->GetGroupCount();
    if (section){
        self.noDataImgView.hidden = YES;
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_collapseSections containsObject:@(section)]) {
        return 0;
    }

    return _jclqInstance->GetTargetCount(section);
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

    DPJcLqBuyCelll *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJcLqBuyCelll alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gameType = self.gameType;

        [cell buildLayout];
    }

    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    int rf, zf;
    int spsf[2], sprqsf[2], spsfc[12], spdxf[2];
    int chksf[2], chkrqsf[2], chksfc[12], chkdxf[2];

    _jclqInstance->GetTargetInfo(indexPath.section, indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rf, zf);
    _jclqInstance->GetTargetSpList(indexPath.section, indexPath.row, spsf, sprqsf, spsfc, spdxf);
    _jclqInstance->GetTargetOption(indexPath.section, indexPath.row, chksf, chkrqsf, chksfc, chkdxf);

    cell.competitionLabel.text = [NSString stringWithUTF8String:competitionName.c_str()];
    cell.orderNameLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.matchDateLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:endTime.c_str()] fromFormat:@"YYYY-MM-dd HH:mm:ss" toFormat:@"HH:mm截止"];

    cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
    cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
    cell.homeRankLabel.text = homeTeamRank.length() ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeTeamRank.c_str()]] : nil;
    cell.awayRankLabel.text = awayTeamRank.length() ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayTeamRank.c_str()]] : nil;

    switch (self.gameType) {
        case GameTypeLcHt: {
            cell.middleLabel.text = @"VS";
            cell.middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];

            //            cell.rangfenLabel.text=[NSString stringWithFormat:@"%.1f",rf/10.0];
            BOOL moreBtnSelected = NO;
            for (int i = 0; i < 2; i++) {
                if (chksf[i] >= 1) {
                    moreBtnSelected = YES;
                    break;
                }
            }
            if (moreBtnSelected == NO) {
                for (int i = 0; i < 12; i++) {
                    if (chksfc[i] >= 1) {
                        moreBtnSelected = YES;
                        break;
                    }
                }
            }
            cell.moreButton.selected = moreBtnSelected;

            BOOL isVisiable1 = YES;
            isVisiable1 = _jclqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeLcRfsf);
            if (rf > 0) {
                cell.rangfenLabel.text = [NSString stringWithFormat:@"+%.1f", rf / 10.0];
            } else {
                cell.rangfenLabel.text = [NSString stringWithFormat:@"%.1f", rf / 10.0];
            }

            cell.rangfenLabel.textColor = rf > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];

            if (isVisiable1) {
                cell.rangfenLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            } else {

                cell.rangfenLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            }

            BOOL isVisiable2 = YES;
            isVisiable2 = _jclqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeLcDxf);
            cell.dxfLabel.text = [NSString stringWithFormat:@"%.1f", zf / 10.0];
            if (isVisiable2) {

                cell.dxfLabel.backgroundColor = [UIColor dp_flatWhiteColor];

                cell.dxfTitleLabel.textColor = [UIColor dp_flatWhiteColor];
                cell.dxfTitleLabel.backgroundColor = [UIColor colorWithRed:0.18 green:0.53 blue:0.53 alpha:1.0];

            } else {
                cell.dxfLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            }

            for (int i = 0; i < cell.options132.count; i++) {
                DPBetToggleControl *control = cell.options132[i];
                BOOL isVisiable = YES;
                isVisiable = _jclqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeLcRfsf);
                if (isVisiable) {
                    control.titleColor = [UIColor dp_flatBlackColor];
                    control.backgroundColor = [UIColor dp_flatWhiteColor];
                    control.userInteractionEnabled = YES;
                    control.oddsText = FloatTextForIntDivHundred(sprqsf[i]);
                    control.selected = chkrqsf[i];

                } else {
                    control.userInteractionEnabled = NO;
                    control.oddsText = @"";
                    control.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                    control.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                }
            }
            for (int i = 0; i < cell.options134.count; i++) {
                DPBetToggleControl *control = cell.options134[i];
                BOOL isVisiable = YES;
                isVisiable = _jclqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, GameTypeLcDxf);
                if (isVisiable) {
                    control.titleColor = [UIColor dp_flatBlackColor];
                    control.backgroundColor = [UIColor dp_flatWhiteColor];
                    control.userInteractionEnabled = YES;
                    control.oddsText = FloatTextForIntDivHundred(spdxf[i]);
                    control.selected = chkdxf[i];

                } else {
                    control.userInteractionEnabled = NO;
                    control.oddsText = @"";
                    control.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                    control.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                }
            }

        }

        break;
        case GameTypeLcRfsf:
            if (rf > 0) {
                cell.middleLabel.text = [NSString stringWithFormat:@"+%.1f", rf / 10.0];
            } else {
                cell.middleLabel.text = [NSString stringWithFormat:@"%.1f", rf / 10.0];
            }

            cell.middleLabel.textColor = rf > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
            for (int i = 0; i < cell.options132.count; i++) {
                DPBetToggleControl *control = cell.options132[i];
                control.titleColor = [UIColor dp_flatBlackColor];
                control.backgroundColor = [UIColor dp_flatWhiteColor];
                control.userInteractionEnabled = YES;
                control.oddsText = FloatTextForIntDivHundred(sprqsf[i]);
                control.selected = chkrqsf[i];
            }

            break;
        case GameTypeLcSf:
            cell.middleLabel.text = @"VS";
            cell.middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
            for (int i = 0; i < cell.options131.count; i++) {
                DPBetToggleControl *control = cell.options131[i];
                control.oddsText = FloatTextForIntDivHundred(spsf[i]);
                control.selected = chksf[i];
            }
            break;
        case GameTypeLcSfc: {
            cell.middleLabel.text = @"VS";
            cell.middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
            NSArray *array = [NSArray arrayWithObjects:
                                          @"客胜1-5", @"客胜6-10", @"客胜11-15", @"客胜16-20", @"客胜21-25", @"客胜26+", @"主胜1-5", @"主胜6-10", @"主胜11-15", @"主胜16-20", @"主胜21-25", @"主胜26+", nil];

            [self upDataLcSfcDataCell:cell array:array target:chksfc title:@"胜分差投注" divisionString:@" "];
            return cell;
        } break;
        case GameTypeLcDxf: {
            cell.middleLabel.text = [NSString stringWithFormat:@"%.1f", zf / 10.0];
            cell.middleLabel.textColor = [UIColor dp_flatRedColor];
            for (int i = 0; i < cell.options134.count; i++) {
                DPBetToggleControl *control = cell.options134[i];
                control.titleColor = [UIColor dp_flatBlackColor];
                control.backgroundColor = [UIColor dp_flatWhiteColor];
                control.userInteractionEnabled = YES;
                control.oddsText = FloatTextForIntDivHundred(spdxf[i]);
                control.selected = chkdxf[i];
            }

        }

        break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeLcHt:
            return 90 + 18;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcDxf:
        case GameTypeLcSfc:
            return 80;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        //        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_tapCoverView)]];
    }
    return _coverView;
}
- (void)pvt_onFilter {
    vector<string> competitions;
    _jclqInstance->GetFilterInfo(competitions);

    if (competitions.size() == 0) {
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

    competitionList = [selectedGroups firstObject];
    [self.competitionList removeAllObjects];
    [self.competitionList addObjectsFromArray:competitionList];

    [self pvt_resetFilterInfo];
    [self.tableView reloadData];
    self.noDataImgView.hidden = [self.tableView numberOfSections];
}
- (void)pvt_resetFilterInfo {
    NSMutableArray *competitionList = nil;

    vector<string> competition;
    _jclqInstance->GetFilterInfo(competition);
    competitionList = [NSMutableArray arrayWithCapacity:competition.size()];
    for (int i = 0; i < competition.size(); i++) {
        [competitionList addObject:[NSString stringWithUTF8String:competition[i].c_str()]];
    }
    int *selectedComeptition = (int *)alloca(sizeof(int) * competition.size());

    for (int i = 0; i < competition.size(); i++) {
        selectedComeptition[i] = [self.competitionList containsObject:competitionList[i]];
    }
    _jclqInstance->SetFilterInfo(selectedComeptition, competition.size());
}
- (void)pvt_reloadFilterInfo {
    vector<string> competition;
    _jclqInstance->GetFilterInfo(competition);

    [self.competitionList removeAllObjects];
    for (int i = 0; i < competition.size(); i++) {
        [self.competitionList addObject:[NSString stringWithUTF8String:competition[i].c_str()]];
    }
}

- (void)showOrChangeBottomText {
    int count = _jclqInstance->GetSelectedCount();
    if (count < 1) {
        self.promptLabel.text = @"请选择比赛";
        return;
    }
    if (self.gameType == GameTypeLcSfc) {
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
        return;
    }
    if (count < 2) {
        self.promptLabel.text = @"已选1场，还差1场";
        return;
    }
    self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
}
#pragma mark - DPJcLqBuyCellDelegate

- (void)jcLqBuyCell:(DPJcLqBuyCelll *)cell event:(DPJcLqBuyCellEvent)event info:(NSDictionary *)info {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (event) {
        case DPJcLqBuyCellEventMore: {

            string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
            int rf, zf;
            _jclqInstance->GetTargetInfo(indexPath.section, indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rf, zf);
            int spsf[2], sprqsf[2], spsfc[12], spdxf[2];
            _jclqInstance->GetTargetSpList(indexPath.section, indexPath.row, spsf, sprqsf, spsfc, spdxf);
            int chksf[2], chkrqsf[2], chksfc[12], chkdxf[2];
            _jclqInstance->GetTargetOption(indexPath.section, indexPath.row, chksf, chkrqsf, chksfc, chkdxf);

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
            DPLanCaiMoreView *buyView = [[DPLanCaiMoreView alloc] init];
            buyView.indexPath = indexPath;
            buyView.gameType = self.gameType;
            buyView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
            buyView.spsf = spsf;
            buyView.sprf = sprqsf;
            buyView.spsfc = spsfc;
            buyView.spdxf = spdxf;

            buyView.rfSelect = chkrqsf;
            buyView.sfSelect = chksf;
            buyView.dxfSelect = chkdxf;
            buyView.sfcSelect = chksfc;
            buyView.rfIndex = rf;
            buyView.dxfIndex = zf;
            buyView.homeTeamName = [NSString stringWithUTF8String:homeTeamName.c_str()];
            buyView.awayTeamName = [NSString stringWithUTF8String:awayTeamName.c_str()];
            buyView.delegate = self;

            CGFloat ballHeight = 220;
            if (self.gameType == GameTypeLcHt) {

                int visiable[4] = {1};
                NSMutableArray *array = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GameTypeLcRfsf], [NSNumber numberWithInt:GameTypeLcDxf], [NSNumber numberWithInt:GameTypeLcSf], [NSNumber numberWithInt:GameTypeLcSfc], nil];
                for (int i = 0; i < array.count; i++) {
                    NSInteger gametype = [[array objectAtIndex:i] integerValue];
                    BOOL isVisble = _jclqInstance->LotteryTypeVisible(indexPath.section, indexPath.row, gametype);
                    visiable[i] = isVisble;
                }
                buyView.isVisible = visiable;

                ballHeight = 360;
                if (buyView.isVisible[3] == 0) {
                    ballHeight = 280;
                }
            }

            [self.coverView addSubview:buyView];
            [buyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth));
                make.centerX.equalTo(self.view);
                make.height.equalTo(@(ballHeight));
                make.centerY.equalTo(self.navigationController.view);
            }];

        } break;
        case DPJCLqBuyCellEventOption: {
            int tag = [[info objectForKey:@"tag"] integerValue];
            DPBetToggleControl *button = (DPBetToggleControl *)[cell viewWithTag:tag];
            //            int spIndex = 0;
            int index = button.tag & 0x0000FFFF;
            _jclqInstance->SetTargetOption(indexPath.section, indexPath.row, (button.tag & 0xFFFF0000) >> 16, index, button.selected);
            [self showOrChangeBottomText];
        } break;
        default:
            break;
    }
}
//提交
- (void)jingCaiMoreSureSelected:(DPLanCaiMoreView *)jingCaiView indexPath:(NSIndexPath *)indexPath {
    DPJcLqBuyCelll *cell = (DPJcLqBuyCelll *)[self.tableView cellForRowAtIndexPath:indexPath];
    switch (self.gameType) {
        case GameTypeLcHt: {
            [self sumitJcData:jingCaiView selectedType:GameTypeLcRfsf indexPath:indexPath count:2];
            [self sumitJcData:jingCaiView selectedType:GameTypeLcDxf indexPath:indexPath count:2];
            BOOL sfSelected = [self sumitJcData:jingCaiView selectedType:GameTypeLcSf indexPath:indexPath count:2];
            BOOL sfcSelected = [self sumitJcData:jingCaiView selectedType:GameTypeLcSfc indexPath:indexPath count:12];
            if (!sfcSelected && !sfSelected) {
                cell.moreButton.selected = NO;
            } else {
                cell.moreButton.selected = YES;
            }

        } break;
        case GameTypeLcSfc: {

            [self sumitJcData:jingCaiView selectedType:GameTypeLcSfc indexPath:indexPath count:12];
        } break;
        default:
            break;
    }
    [self showOrChangeBottomText];
    [self.tableView reloadData];
    [jingCaiView removeFromSuperview];
    [self pvt_tapCoverView];
}
- (void)jingCaiMoreCancel:(DPLanCaiMoreView *)jingCaiView {
    [jingCaiView removeFromSuperview];
    [self pvt_tapCoverView];
}
- (void)pvt_tapCoverView {
    [UIView animateWithDuration:0.1 animations:^{
        self.coverView.alpha = 0.2;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        self.coverView.alpha = 1;
    }];
}
//提交所选到低层<通用>
- (BOOL)sumitJcData:(DPLanCaiMoreView *)jingCaiView
       selectedType:(int)selectedType
          indexPath:(NSIndexPath *)indexPath
              count:(int)count {
    BOOL isSelected = NO;
    for (int i = 0; i < count; i++) {
        DPBetToggleControl *obj = (DPBetToggleControl *)[jingCaiView.scroView viewWithTag:(selectedType << 16) | i];
        _jclqInstance->SetTargetOption(indexPath.section, indexPath.row, selectedType, i, obj.selected);
        if (obj.selected > 0) {
            isSelected = YES;
        }
    }
    return isSelected;
}
//更新比分，半全场数据
- (void)upDataLcSfcDataCell:(DPJcLqBuyCelll *)cell array:(NSArray *)array target:(int[])chk title:(NSString *)title divisionString:(NSString *)divisionString {
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

//- (void)pvt_updatePrompt {
//    int count = _jclqInstance->GetSelectedCount();
//    if (self.gameType==GameTypeLcSfc) {
//        if (count < 1) {
//            self.promptLabel.text = [NSString stringWithFormat:@"已选%d场  至少选择1场比赛", count];
//        } else {
//            self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
//        }
//        return;
//    }
//    if (count < 2) {
//
//        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场  至少选择2场比赛", count];
//    } else {
//        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
//    }
//}
#pragma mark - DPNavigationMenuDelegate

- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(NSInteger)index {
    self.gameIndex = index;
    [self.tableView reloadData];
    [self showOrChangeBottomText];
     [self pvt_reloadFilterInfo];
    self.noDataImgView.hidden = [self.tableView numberOfSections];
    
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
}



#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        // 重载数据
         [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
        [self dismissHUD];
        [self showOrChangeBottomText];
        [self pvt_reloadFilterInfo];
        self.noDataImgView.hidden = [self.tableView numberOfSections];
        
        self.tableView.tableHeaderView = nil ;
        NSInteger sectionCount = _jclqInstance->GetGroupCount() ;
        if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
            if (sectionCount <=0) {
                self.noDataView.noDataState= DPNoDataNoworkNet ;
                self.tableView.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kNoWorkNet_]show];
            }
        }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
            if (sectionCount<=0) {
                self.noDataView.noDataState = DPNoDataWorkNetFail ;
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
