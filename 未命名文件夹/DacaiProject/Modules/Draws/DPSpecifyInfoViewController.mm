//
//  DPSpecifyInfoViewController.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-19.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSpecifyInfoViewController.h"
#import "DPLotteryInfoTableViewCell.h"
#import "SVPullToRefresh.h"
#import "FrameWork.h"
#import "DPLotteryInfoWebViewController.h"
@interface DPSpecifyInfoViewController () <ModuleNotify>
{
    GameTypeId      _gameType;
    NSString        *_navTitle;
    CLotteryInfo    *_infoCenter;
}
@end

@implementation DPSpecifyInfoViewController
@dynamic gameType;
@dynamic navTitle;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _infoCenter = CFrameWork::GetInstance()->GetLotteryInfo();
        _infoCenter -> SetDelegate(self);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navLeftItemClick)];
    self.tableView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view;
    });
    
    __block __typeof(_infoCenter) weakCenter = _infoCenter;
    __weak __typeof(self) weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakCenter -> RefreshLottery(true);
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakCenter -> RefreshLottery();
    }];
    [self.tableView setShowsInfiniteScrolling:NO];
    
    _infoCenter -> SetGameType(self.gameType);
    _infoCenter -> RefreshLottery();
    [self showHUD];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _infoCenter -> SetDelegate(self);
}
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoCenter -> GetLotteryCount();
}

- (DPLotteryInfoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    DPLotteryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DPLotteryInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    string title, time, url; int gameType;
    _infoCenter -> GetLotteryTarget(indexPath.row, title, time, url, gameType);
    
    NSString *resTitle = [NSString stringWithUTF8String:title.c_str()];
    NSString *resTime = [NSDate dp_coverDateString:[NSString stringWithUTF8String:time.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm];
    NSString *urlString = [NSString stringWithUTF8String:url.c_str()];
    [cell setTitle:resTitle subTitle:resTime urlString:urlString indexPath:indexPath];
    cell.gameType = (GameTypeId)gameType;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPLotteryInfoTableViewCell *cell = (DPLotteryInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.navigationController pushViewController:({
        DPLotteryInfoWebViewController *viewController = [[DPLotteryInfoWebViewController alloc] init];
        viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:cell.urlString]];
        viewController.title = @"资讯详情";
        viewController.canHighlight = NO ;
        viewController.gameType = cell.gameType;
        viewController;
    }) animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    string title, time, url;
    int gameType;

    _infoCenter->GetLotteryTarget(indexPath.row, title, time, url, gameType);

    NSString *resTitle = [NSString stringWithUTF8String:title.c_str()];

    CGSize size = [resTitle sizeWithFont:[UIFont dp_systemFontOfSize:kInfoTableViewCellTitleFont] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];

    return size.height + kInfoTabelViewCellHeightDelta;
}

#pragma mark - getter和setter
- (GameTypeId)gameType
{
    return _gameType;
}
- (void)setGameType:(GameTypeId)gameType
{
    _gameType = gameType;
}

- (NSString *)navTitle
{
    return _navTitle;
}

- (void)setNavTitle:(NSString *)navTitle
{
    if (navTitle!= nil && navTitle.length > 0) {
        
        self.title = navTitle;
        _navTitle = navTitle;
    }
}

#pragma mark - 数据加载代理方法
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
        int rows = [self.tableView numberOfRowsInSection:0];
        [self.tableView setShowsInfiniteScrolling:rows];
        [self dismissHUD];
    });
}

- (void)navLeftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    _infoCenter -> ClearLottery();
}
@end
