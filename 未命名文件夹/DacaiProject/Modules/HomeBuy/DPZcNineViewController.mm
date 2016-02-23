//
//  DPZcNineViewController.m
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#import "FrameWork.h"
#import "DPCollapseTableView.h"
#import "DPBetToggleControl.h"

#import "DPZcNineViewController.h"
#import "DPSfcTabBarView.h"
#import "DPZcBuyCell.h"
#import "DPJczqAnalysisCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "../../Modules/HomeBuy/DPRxninetransferVC.h"
#import "DPDropDownList.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DPHelpWebViewController.h"
#import "DPNodataView.h"


static const NSInteger kDPSfcTabBarHeight = 30;
@interface DPZcNineViewController () <DPCollapseTableViewDelegate,
                                      DPCollapseTableViewDataSource, DPScvTabBarViewDelegate, ModuleNotify, DPzcBuyCellDelegate, DPDropDownListDelegate, UIGestureRecognizerDelegate, DPRxninetransferVCDelegate> {
@private
    CLotteryZc9 *_zc9Instance;

    DPCollapseTableView *_onTableView;
    DPCollapseTableView *_preTableView;
    UIView *_bottomView;
    UILabel *_promptLabel;
    UIScrollView *_scrollView;
//    UIImageView *_noDataImgView;
    BOOL _isBuildLayout; //是否创建过UI ;
                      
    NSInteger _cmdId;
    DPNodataView *_noDataView ;
    NSInteger _ret ;
}
@property (nonatomic, strong) DPSfcTabBarView *tabBarView;
@property (nonatomic, strong, readonly) DPCollapseTableView *onTableView;
@property (nonatomic, strong, readonly) DPCollapseTableView *preTableView;
@property (nonatomic, strong, readonly) UIView *bottomView;
@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
//@property (nonatomic, strong, readonly) UIImageView *noDataImgView;
@property (nonatomic, strong, readonly) DPNodataView *noDataView;

@property (nonatomic, strong) NSMutableDictionary *analysisDic;

@end

@implementation DPZcNineViewController
//@dynamic noDataImgView;

- (instancetype)init {
    if (self = [super init]) {
        self.gameType = GameTypeZc9;

        _zc9Instance = CFrameWork::GetInstance()->GetLotteryZc9();

        self.indexPathAry = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
        self.analysisDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    REQUEST_CANCEL(_cmdId);
    _zc9Instance->Clear();
}

//- (UIImageView *)noDataImgView {
//    if (_noDataImgView == nil) {
//        _noDataImgView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"zcNoData.png")];
//    }
//    return _noDataImgView;
//}

//- (void)buildNodataView {
//    [self.view addSubview:self.noDataImgView];
//    [self.noDataImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view) ;
//        make.centerY.equalTo(self.view) ;
//    }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self setTitle:@"任选九"];
//    [self buildNodataView];
//    self.noDataImgView.hidden = YES;
    _isBuildLayout = NO;
    _ret = 0 ;

        [self buildLayout];
    if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
        [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)]];
    } else {
        [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(pvt_onBack)]];
    }
    //    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithImage:dp_NavigationImage(@"share.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onShare)];
    //    filterItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:dp_NavigationImage(@"more.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onMore)];
    moreItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:moreItem];
    // Do any additional setup after loading the view.
    [_tabBarView layoutIfNeeded];

    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)]];
    [self showHUD];
    _cmdId = _zc9Instance->Refresh();
}

- (void)buildLayout {
    UIView *contentView = self.view;
    [contentView addSubview:self.tabBarView];
    [contentView addSubview:self.scrollView];
    [contentView sendSubviewToBack:self.scrollView];
    [contentView addSubview:self.bottomView];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@(kDPSfcTabBarHeight));
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@45);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kDPSfcTabBarHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];

    [self.scrollView addSubview:self.onTableView];
    [self.scrollView addSubview:self.preTableView];
    [self.onTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.right.equalTo(self.preTableView.mas_left);
        
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    [self.preTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
        make.left.equalTo(self.onTableView.mas_right);
        make.right.equalTo(self.scrollView);
        
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

    contentView = self.bottomView;

    UIButton *cleanupButton = [[UIButton alloc] init];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];

    // config control
    [cleanupButton setImage:dp_CommonImage(@"delete001_21.png") forState:UIControlStateNormal];
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
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];

    self.scrollView.scrollEnabled = YES;
    self.tabBarView.userInteractionEnabled = YES;
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.tabBarView.selectedIndex == 0 ? [self.onTableView reloadData] : [self.preTableView reloadData];
    [self showOrChangeBottomText];
    _zc9Instance->SetDelegate(self);

    //    if ( _zc9Instance->GetGameCount()<2) {
    //        self.tabBarView.rightZcBtn.enabled = NO ;
    //    }else{
    //        self.tabBarView.rightZcBtn.enabled = YES ;
    //    }
    
    
    
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (DPCollapseTableView *)onTableView {
    if (_onTableView == nil) {
        _onTableView = [[DPCollapseTableView alloc] init];
        _onTableView.delegate = self;
        _onTableView.dataSource = self;
        _onTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _onTableView.alwaysBounceHorizontal = NO ;
        _onTableView.backgroundColor = [UIColor clearColor];
    }
    return _onTableView;
}
- (DPCollapseTableView *)preTableView {
    if (_preTableView == nil) {
        _preTableView = [[DPCollapseTableView alloc] init];
        _preTableView.delegate = self;
        _preTableView.dataSource = self;
        _preTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _preTableView.alwaysBounceHorizontal = NO ;
        _preTableView.backgroundColor = [UIColor clearColor];
    }
    return _preTableView;
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
- (DPSfcTabBarView *)tabBarView {
    if (_tabBarView == nil) {
        _tabBarView = [[DPSfcTabBarView alloc] init];
        _tabBarView.delegate = self;
        _tabBarView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.99 alpha:1.0];
    }
    return _tabBarView;
}
-(DPNodataView*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        __weak __typeof(self) weakSelf = self;
        __block CLotteryZc9  *weak__zc9Instance = _zc9Instance;
        
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
                strongSelf->_cmdId = weak__zc9Instance->Refresh();
            }
            
        }];
    }
    return _noDataView ;
}
#pragma mark - private function

- (void)pvt_onCleanup {
    for (int i = 0; i < 14; i++) {
        _zc9Instance->SetTargetOption(i, 0, 0);
        _zc9Instance->SetTargetOption(i, 1, 0);
        _zc9Instance->SetTargetOption(i, 2, 0);
        self.indexPathAry[i] = @"0";
    }
    [self.onTableView reloadData];
    [self.preTableView reloadData];
    [self showOrChangeBottomText];
}
//得到所选中的个数
- (int)getSelectedCount {
    int count = 0;
    for (int i = 0; i < 14; i++) {

        int betOption[3] = {0};
        _zc9Instance->GetTargetOption(i, betOption);
        if ((betOption[0] > 0) || (betOption[1] > 0) || (betOption[2] > 0)) {
            self.indexPathAry[i] = @"1";
            count++;
        } else {
            self.indexPathAry[i] = @"0";
        }
    }

    return count;
}

- (void)pvt_onConfirm {
    int count = [self getSelectedCount];

    if (count < 9) {
        [[DPToast makeText:@"请至少选择9场比赛"] show];
        return;
    }
    DPRxninetransferVC *vc = [[DPRxninetransferVC alloc] init];
    vc.selectedAry = [NSMutableArray arrayWithArray:[self.indexPathAry copy]];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)updateArrayWithIndex:(int)index withSelect:(NSString *)selectOrNot {
    [self.indexPathAry replaceObjectAtIndex:index withObject:selectOrNot];
}

- (void)pvt_onBack {
    int count = [self getSelectedCount];
    if (count <= 0) {
        _zc9Instance->Clear();
        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

- (void)pvt_onShare {
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
                viewController.gameType = GameTypeZcNone;
                viewController.isFromClickMore = YES ;
                viewController;
            });
        } break;
        case 1: { // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kPlayIntroduceURL(GameTypeZc9)]];
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

- (void)showOrChangeBottomText {
    int count = [self getSelectedCount];
    if(count==0)
    {
        self.promptLabel.text = @"至少选择9场比赛";
        return;
    }
    if (count < 9) {
        self.promptLabel.text = [NSString stringWithFormat:@"选了%d场 还差%d场比赛", count,9-count];
        return;
    }
    self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
}
- (NSMutableAttributedString *)gainGlobalSurplus:(int)globalSurplus {
    NSArray *array = [[self logogramForMoney:globalSurplus] componentsSeparatedByString:@" "];
    if (array.count < 2) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSString *money = [array objectAtIndex:0];
    NSString *danwei = [array objectAtIndex:1];
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖池 : %@", [self logogramForMoney:globalSurplus]]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0, 5)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(5, money.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(hintString1.length - danwei.length, danwei.length)];
    return hintString1;
}

//得到滚存钱
- (NSString *)logogramForMoney:(int)money {
    if (money <= 0) {
        return @"-- 元";
    }
    NSString *string1 = @"0";
    NSString *string2 = @"元";
    if (money / 100000000.0 >= 1) {
        string1 = [NSString stringWithFormat:@"%.2f", money / 100000000.0];
        string2 = @"亿元";
    } else {
        if (money / 10000.0 >= 1) {
            string1 = [NSString stringWithFormat:@"%.2f", money / 10000.0];
            string2 = @"万元";
        } else {
            string1 = [NSString stringWithFormat:@"%.2f", money / 1.0];
        }
    }
    return [NSString stringWithFormat:@"%@ %@", string1, string2];
}
#pragma mark - table view's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_zc9Instance->GetTargetCount()<0){
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _zc9Instance->GetTargetCount();
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    int gameName;
    int onSale;
    string combinationBuyDeadline;
    int globalSurplus;
    if ((_zc9Instance->GetGameInfo(gameName, onSale, combinationBuyDeadline, globalSurplus)) < 0 ||
        (_zc9Instance->GetTargetCount()) < 0) {
        return nil;
    }

    NSString *dateString = [NSString stringWithUTF8String:combinationBuyDeadline.c_str()];
    NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    dateString = [date dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm];

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
    label.text = [NSString stringWithFormat:@"截止时间 %@", dateString];

    TTTAttributedLabel *label2 = [[TTTAttributedLabel alloc] init];
    [label2 setNumberOfLines:1];
    [label2 setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
    [label2 setFont:[UIFont systemFontOfSize:12.0f]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setLineBreakMode:NSLineBreakByWordWrapping];
    label2.userInteractionEnabled = NO;
    [view addSubview:label];
    [view addSubview:label2];
    [view addSubview:line1];
    [view addSubview:line2];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-20);
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
    [label2 setText:[self gainGlobalSurplus:globalSurplus]];
    if(globalSurplus>0){
        label2.hidden=NO;
    }else{
        label2.hidden=YES;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *CellIdentifier = [NSString stringWithFormat:@"BuyCell%d", self.tabBarView.selectedIndex];

    DPZcBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPZcBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gameType = GameTypeZc9;
        [cell buildLayout];
    }

    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime;
    int spList[3], betOption[3] = {0};

    _zc9Instance->GetTargetInfo(indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime);
    _zc9Instance->GetTargetSpList(indexPath.row, spList);
    _zc9Instance->GetTargetOption(indexPath.row, betOption);

    cell.competitionLabel.text = [NSString stringWithUTF8String:competitionName.c_str()];
    cell.orderNameLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.matchDateLabel.text = [NSDate dp_coverDateString:[NSString stringWithUTF8String:endTime.c_str()] fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:dp_DateFormatter_MM_dd_HH_mm];

    cell.homeNameLabel.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
    cell.awayNameLabel.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
    if (homeTeamRank.length() && awayTeamRank.length()) {
        NSString *homeRankString = [NSString stringWithUTF8String:homeTeamRank.c_str()];
        NSString *awayRankString = [NSString stringWithUTF8String:awayTeamRank.c_str()];
        cell.homeRankLabel.text = homeRankString;
        cell.awayRankLabel.text = awayRankString;
    }

    if (self.tabBarView.selectedIndex == 1) {
        cell.analysisView.highlighted = [self.preTableView isExpandAtModelIndex:indexPath];
    } else {
        cell.analysisView.highlighted = [self.onTableView isExpandAtModelIndex:indexPath];
    }
    cell.homeRankLabel.text = homeTeamRank.length() ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeTeamRank.c_str()]] : nil;
    cell.awayRankLabel.text = awayTeamRank.length() ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayTeamRank.c_str()]] : nil;

    cell.middleLabel.text = @"VS";
    int gameName,onSale,globalSurplus;
    string combinationBuyDeadline;
    _zc9Instance->GetGameInfo(gameName, onSale, combinationBuyDeadline, globalSurplus) ;
    for (int i = 0; i < cell.optionButtonSpf.count; i++) {
        [cell.optionButtonSpf[i] setOddsText:FloatTextForIntDivHundred(spList[i])];
        [cell.optionButtonSpf[i] setSelected:betOption[i]];
        
        DPBetToggleControl *control = cell.optionButtonSpf[i];
        if (onSale) {
            control.userInteractionEnabled=YES;
        }else{
         control.userInteractionEnabled=NO;
        control.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
        }
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"analysisCell%d", self.tabBarView.selectedIndex];
    DPJczqAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqAnalysisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.gameType = GameTypeZc9;
        
        __weak __typeof(self) weakSelf = self;
        [cell setClickBlock:^(DPJczqAnalysisCell*nalysisCell){
            NSIndexPath *pathIndex = [weakSelf.onTableView modelIndexForCell:nalysisCell];
            if (weakSelf.tabBarView.selectedIndex == 1) {
                pathIndex = [weakSelf.preTableView modelIndexForCell:nalysisCell];
            }
            string competition ;  int matchId=0 ;
            CFrameWork::GetInstance()->GetLotteryZc9()->GetTargetDataInfo(pathIndex.row, competition, matchId) ;
            DPLiveDataCenterViewController* vc = [[DPLiveDataCenterViewController alloc]initWithGameType:GameTypeZcNone withDefaultIndex:1 withMatchId:matchId] ;
            vc.title = [NSString stringWithUTF8String:competition.c_str()];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }] ;

    }
    [cell clearAllData];
    [self updateDPzc9AnalysisCellData:indexPath cell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 143 ; //隐藏赛事分析
    return 140;

}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.tabBarView.selectedIndex==1) {
//        [self.preTableView toggleCellAtModelIndex:[self.preTableView modelIndexFromTableIndex:indexPath expand:nil] animation:YES];
//    }else{
//    [self.onTableView toggleCellAtModelIndex:[self.onTableView modelIndexFromTableIndex:indexPath expand:nil] animation:YES];
//    }
//    DPZcBuyCell *cell = (DPZcBuyCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (self.tabBarView.selectedIndex==1) {
//        cell.analysisView.highlighted = [self.preTableView isExpandAtModelIndex:[self.preTableView modelIndexFromTableIndex:indexPath expand:nil]];
//        return;
//    }
//    cell.analysisView.highlighted = [self.onTableView isExpandAtModelIndex:[self.onTableView modelIndexFromTableIndex:indexPath expand:nil]];
//}

- (void)updateDPzc9AnalysisCellData:(NSIndexPath *)indexPath cell:(DPJczqAnalysisCell *)cell {
    string betProportion[6];
    string passMatches[3];
    string recentRecord[6];
    string averageOdds[3];
    int count;
    _zc9Instance->GetTargetAnalysis(indexPath.row, betProportion, passMatches, count, recentRecord, averageOdds);
   
    cell.ratioWinLabel.text = [NSString stringWithUTF8String:betProportion[0].c_str()];
    cell.ratioTieLabel.text = [NSString stringWithUTF8String:betProportion[1].c_str()];
    cell.ratioLoseLabel.text = [NSString stringWithUTF8String:betProportion[2].c_str()];

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
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0, hinString.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(5, homeWin.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(6 + homeWin.length, homeEqual.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:NSMakeRange(7 + homeWin.length + homeEqual.length, homeLose.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(11 + homeWin.length + homeEqual.length + homeLose.length, awayWin.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0] CGColor] range:NSMakeRange(12 + homeWin.length + homeEqual.length + homeLose.length + awayWin.length, awayEqual.length)];
    [hinString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] CGColor] range:NSMakeRange(13 + homeWin.length + homeEqual.length + homeLose.length + awayWin.length + awayLose.length, awayLose.length)];
    [cell.zhanJiLabel setText:hinString];

    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, endTime, competitionName;
    _zc9Instance->GetTargetInfo(indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime);
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

#pragma mark - DPBdBuyCellDelegate

- (void)zcBuyCell:(DPZcBuyCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected {

    DPToast *post = [DPToast sharedToast];
    [post dismiss];

    NSIndexPath *indexPath = [self.onTableView modelIndexForCell:cell];
    if (self.tabBarView.selectedIndex == 1) {
        indexPath = [self.preTableView modelIndexForCell:cell];
    }
    _zc9Instance->SetTargetOption(indexPath.row, index, selected);
    int betOption[3] = {0};
    _zc9Instance->GetTargetOption(indexPath.row, betOption);
    [self showOrChangeBottomText];
}

- (void)zcBuyCellInfo:(DPZcBuyCell *)cell {
    DPCollapseTableView *tableView = self.tabBarView.selectedIndex == 1 ? self.preTableView : self.onTableView;
    NSIndexPath *modelIndex = [tableView modelIndexForCell:cell];
    [cell analysisViewIsExpand:[tableView isExpandAtModelIndex:modelIndex]];
    [tableView toggleCellAtModelIndex:modelIndex animation:YES];
}

#pragma mark - DCLTZcCathecticTabBarViewDelegate
- (void)tabBarView:(DPSfcTabBarView *)tabBarView selectedAtIndex:(NSInteger)index {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);

    [self.scrollView scrollRectToVisible:CGRectMake(index * width, 0, width, 1) animated:YES];
    _zc9Instance->SetGameIndex(index);
    [self changeHeaderViewWithIndex:index ];

    [self getSelectedCount];
    if (index == 0) {
        [self.preTableView closeAllCells];
        [self.onTableView reloadData];
    } else if (index == 1) {
        [self.onTableView closeAllCells];
        [self.preTableView reloadData];
    }

    [self showOrChangeBottomText];
}

-(void)changeHeaderViewWithIndex:(NSInteger)index{
    UITableView *_tableVi ;
    if (index == 0) {
        _tableVi = self.onTableView ;
    }else
        _tableVi = self.preTableView ;
    
    _tableVi.tableHeaderView = nil ;
    NSInteger sectionCount = _zc9Instance->GetTargetCount();
    if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
        if (sectionCount <=0) {
            self.noDataView.noDataState= DPNoDataNoworkNet ;
            _tableVi.tableHeaderView = self.noDataView ;
        }else{
            [[DPToast makeText:kNoWorkNet_]show];
        }
    }else if(_ret ==ERROR_TimeOut ||_ret == ERROR_ConnectHostFail || _ret == ERROR_NET || _ret == ERROR_DATA ) {
        if (sectionCount<=0) {
            self.noDataView.noDataState = DPNoDataWorkNetFail ;
            _tableVi.tableHeaderView = self.noDataView ;
        }else{
            [[DPToast makeText:kWorkNetFail_]show];
        }
    }else if (sectionCount <= 0){
        self.noDataView.noDataState = DPNoData ;
        _tableVi.tableHeaderView = self.noDataView ;
    }

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [self.tabBarView selectedItemChangeTo:index];
        _zc9Instance->SetGameIndex(index);
        [self changeHeaderViewWithIndex:index ];

        if (index == 0) {
            [self.preTableView closeAllCells];
            [self.onTableView reloadData];
        } else if (index == 1) {
            [self.onTableView closeAllCells];
            [self.preTableView reloadData];
        }
        

    }
    [self showOrChangeBottomText];
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissHUD];
//        if (!_isBuildLayout ) {
//            [self buildLayout];
//            _isBuildLayout = YES ;
////            [self.noDataImgView removeFromSuperview];
//        }else
//        {
//            _isBuildLayout = NO ;
//        }
        if (cmdtype==ANALYSIS) {
            DPCollapseTableView *tableView = self.tabBarView.selectedIndex == 1 ? self.preTableView : self.onTableView;
            NSIndexPath *modexIndex = [self.analysisDic objectForKey:@(cmdId)];
            DPJczqAnalysisCell *cell = [tableView cellForRowAtModelIndex:modexIndex expand:YES];
            if (cell) {
                [self updateDPzc9AnalysisCellData:modexIndex cell:cell];
            }
            
            return;
        }
//        int index= _zc9Instance->GetGameCount();
//        if (index<2) {
//            self.tabBarView.rightZcBtn.userInteractionEnabled=YES;
//            self.scrollView.scrollEnabled=YES;
//            self.tabBarView.rightZcBtn.backgroundColor=[UIColor grayColor];
//        }else{
//            self.tabBarView.rightZcBtn.userInteractionEnabled=YES;
//            self.scrollView.scrollEnabled=YES;
//            self.tabBarView.rightZcBtn.backgroundColor=[UIColor clearColor];
//        }
        
//        int gameName;
//        int onSale;
//        string combinationBuyDeadline;
//        int globalSurplus;
//        _zc9Instance->GetGameInfo(gameName, onSale, combinationBuyDeadline, globalSurplus) ;
//        
//        if (gameName <= 0) {
//            [_tabBarView changeCurrentData:@"不定"];
//        }else{
//            [_tabBarView changeCurrentData:[NSString stringWithFormat:@"%d",gameName]];
//        }
        _ret = ret ;
        if (ret<0) {
            
        }
        int gameName;
        int onSale;
        string combinationBuyDeadline;
        int globalSurplus;
       int index1= _zc9Instance->SetGameIndex(0) ;
        _zc9Instance->GetGameInfo(gameName, onSale, combinationBuyDeadline, globalSurplus) ;
        
        int gameNamePre ;
        int index2=  _zc9Instance->SetGameIndex(1) ;
        _zc9Instance->GetGameInfo(gameNamePre, onSale, combinationBuyDeadline, globalSurplus) ;
        
        
        if (index1>=0) {
            [_tabBarView changeCurrentData:[NSString stringWithFormat:@"%d",gameName]];
            self.tabBarView.leftZcBtn.enabled=YES;
            
        }else{
            [_tabBarView changeCurrentData:@""];
            self.tabBarView.leftZcBtn.enabled=NO;
        }
        if (index2>=0) {
            [_tabBarView changePreData:[NSString stringWithFormat:@"%d",gameNamePre]];
            self.tabBarView.rightZcBtn.enabled=YES;
            
        }else{
            [_tabBarView changePreData:@""];
            self.tabBarView.rightZcBtn.enabled=NO;
            
        }
        if ((index1<0)||(index2<0)) {
            self.scrollView.scrollEnabled=NO;
        }else{
            self.scrollView.scrollEnabled=YES;
        }
    
        UITableView *_tableVi ;
        if (self.tabBarView.selectedIndex==0) {
            _zc9Instance->SetGameIndex(0) ;
            [self.onTableView reloadData];
            _tableVi = self.onTableView ;

//           self.noDataImgView.hidden = _zc9Instance->GetTargetCount()>0?YES:NO;
        }else{
            _zc9Instance->SetGameIndex(1) ;
            // 重载数据
            [self.preTableView reloadData];
            _tableVi = self.preTableView ;

//           self.noDataImgView.hidden = _zc9Instance->GetTargetCount()>0?YES:NO;
            
        }
        
        _tableVi.tableHeaderView = nil ;
        NSInteger sectionCount = _zc9Instance->GetTargetCount();
        if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
            if (sectionCount <=0) {
                self.noDataView.noDataState= DPNoDataNoworkNet ;
                _tableVi.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kNoWorkNet_]show];
            }
        }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
            if (sectionCount<=0) {
                self.noDataView.noDataState = DPNoDataWorkNetFail ;
                _tableVi.tableHeaderView = self.noDataView ;
            }else{
                [[DPToast makeText:kWorkNetFail_]show];
            }
        }else if (sectionCount <= 0){
            self.noDataView.noDataState = DPNoData ;
            _tableVi.tableHeaderView = self.noDataView ;
        }

        
        
    });
}

@end
