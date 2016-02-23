//
//  DPLotteryInfoViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLotteryInfoViewController.h"
#import "DPLotteryInfoDockView.h"
#import "DPLotteryInfoTableViewCell.h"
#import "DPSpecifyInfoViewController.h"
#import "SVPullToRefresh.h"
#import "FrameWork.h"
#import "EntryList.h"
#import "DPLotteryInfoRandomChipView.h"
#import "UIViewController+HUD.h"
#import "DPWebViewController.h"
#import "DPLotteryInfoWebViewController.h"
#import "DPNodataView.h"
@interface DPLotteryInfoCollectionCell : UICollectionViewCell
- (void)setImageName:(NSString *)imageName title:(NSString *)title;
@end

@interface DPLotteryInfoCollectionCell()
{
@private
    UIImageView         *_imageView;
    UILabel             *_classLabel;
}
@end

@implementation DPLotteryInfoCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 1.8;
        self.contentView.layer.borderColor = [[UIColor dp_colorFromHexString:@"#d5cfbd"] CGColor];
        self.contentView.layer.borderWidth = 0.5f;
        
        _imageView = [[UIImageView alloc]init];
        _classLabel = [[UILabel alloc]init];
        _classLabel.font = [UIFont systemFontOfSize:13];
        _classLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_classLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.width.equalTo(@36);
            make.height.equalTo(@36);
        }];
        
        [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_imageView.mas_right).offset(5);
            make.right.equalTo(self.contentView);
        }];
        
    }
    return self;
}
- (void)setImageName:(NSString *)imageName title:(NSString *)title
{
    [self setImageName:imageName];
    [self setTitle:title];
}

#pragma mark - set和get方法
- (void)setImageName:(NSString *)imageName
{
    if (imageName.length > 0 && imageName != nil) {
        
        _imageView.image = dp_AppRootImage(imageName);
    }
}

- (void)setTitle:(NSString *)title
{
    if (title.length > 0 && title != nil) {
        
        _classLabel.text = title;
    }
}

@end

#define kArrowAnimTime 0.3f
#define kDockHeight 38
#define kcollectionCellID    @"collectionCellID"
#define ktableViewRowHeight 60

@interface DPLotteryInfoViewController () <
UITableViewDataSource,
UITableViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
DPLotteryInfoDockViewDelegate,
ModuleNotify
>
{
@private
    DPLotteryInfoDockView           *_dockView;             // 选项卡视图
    UITableView                     *_recommendTableView;   // 推荐视图;
    UITableView                     *_hotTableView;         // 热门视图;
    UICollectionView                *_classView;            // 分类视图
    UIScrollView                    *_scrollView;           // 内容滚动视图
    NSArray                         *_colorArray;           // 随机色彩数组
    CLotteryInfo                    *_infoCenter;
    DPNodataView                    *_recTableNoDataView;
    DPNodataView                    *_hotTableNoDataView;
}

@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, strong) NSIndexPath *recSelIndex;  // 选中行
@property (nonatomic, strong) NSIndexPath *hotSelIndex;  // 选中行
@property (nonatomic, strong, readonly) DPNodataView *recTableNoDataView; // 网络错误提示
@property (nonatomic, strong, readonly) DPNodataView *hotTableNoDataView; // 网络错误提示
@end

static NSString *collectionCellID = kcollectionCellID;
@implementation DPLotteryInfoViewController

static NSString *titleArray[] = {@"双色球", @"大乐透", @"竞彩足球", @"北京单场",@"足球彩票" ,@"福彩3D",  @"排列三/五"};

- (instancetype)init
{
    self = [super init];
    if (self) {
        _infoCenter = CFrameWork::GetInstance()->GetLotteryInfo();
        _infoCenter ->SetDelegate(self);
        self.defaultIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"彩票资讯";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"home.png") target:self action:@selector(navBarLeftItemClick:)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(navBarRightItemClick:)];

    [self buildDockView];
    [self buildScorllView];
    [self showHUD];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    _infoCenter ->SetDelegate(self);
//    self.contentOffset = _scrollView.contentOffset;
    self.defaultIndex = _scrollView.contentOffset.x / 320;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _scrollView.contentOffset = CGPointZero;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.defaultIndex) {
        _scrollView.contentOffset = CGPointMake(self.defaultIndex * 320, 0);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    _infoCenter ->SetDelegate(self);
//    _scrollView.contentOffset = self.contentOffset;
    self.contentOffset = CGPointZero;
}

#pragma mark - 视图初始化
#pragma mark 顶部选项视图
- (void)buildDockView
{
    UIView *contentView = self.view;
    
    // 上面选项卡视图
    DPLotteryInfoDockView *dockView = [[DPLotteryInfoDockView alloc]init];
    dockView.delegate = self;
    _dockView = dockView;
    
    [contentView addSubview:dockView];
    // 选项卡视图
    dockView.backgroundColor = [UIColor whiteColor];
    [dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@kDockHeight);
    }];
    
    [dockView selectedItemChangeTo:self.defaultIndex isDelegateSend:YES]; // 默认选中第一个
}

#pragma mark  初始化内容视图scrollView
- (void)buildScorllView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    scrollView.delegate = self;
//    scrollView.contentSize = CGSizeMake(10000, 480);

    // 添加推荐视图
    UITableView *recommendTableView = [self createTableViewWithTag:0];
    // 添加热门视图
    UITableView *hotTableView = [self createTableViewWithTag:1];
    
//    // 如果没有网络
//    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
//        self.recTableNoDataView.noDataState = DPNoDataNoworkNet;
//        self.hotTableNoDataView.noDataState = DPNoDataNoworkNet;
//        recommendTableView.tableHeaderView = self.recTableNoDataView;
//        hotTableView.tableHeaderView = self.hotTableNoDataView;
//    }
    
    __block __typeof(_infoCenter) weakInfoCenter = _infoCenter;
    
    [recommendTableView addPullToRefreshWithActionHandler:^{
        weakInfoCenter -> RefreshRecommend(true);
        self.recSelIndex = nil;
    } position:SVPullToRefreshPositionTop];
    
    [hotTableView addPullToRefreshWithActionHandler:^{
        weakInfoCenter -> RefreshAnnouncement(true);
        self.hotSelIndex = nil;
    } position:SVPullToRefreshPositionTop];
    
    [recommendTableView addInfiniteScrollingWithActionHandler:^{
        weakInfoCenter -> RefreshRecommend();
    }];
    [hotTableView addInfiniteScrollingWithActionHandler:^{
        weakInfoCenter -> RefreshAnnouncement();
    }];
    
    [recommendTableView setShowsInfiniteScrolling:NO];
    [hotTableView setShowsInfiniteScrolling:NO];
//
    // 添加分类的collectionView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(140, 45);
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 20, 15);
    
    UICollectionView *collectionView = ({
        UICollectionView *collect = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [collect registerClass:[DPLotteryInfoCollectionCell class] forCellWithReuseIdentifier:collectionCellID];
        collect.dataSource = self;
        collect.delegate = self;
        collect.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
        collect.tag = 3;
        collect;
    });
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:recommendTableView];
    [scrollView addSubview:hotTableView];
    [scrollView addSubview:collectionView];
    
    _scrollView = scrollView;
    _recommendTableView = recommendTableView;
    _hotTableView = hotTableView;
    _classView = collectionView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dockView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.equalTo()
    }];
    [recommendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    [hotTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(recommendTableView.mas_right);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(hotTableView.mas_right);
        make.right.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.equalTo(scrollView);

    }];
    
    // 初始化刷新数据
    [self refreshDataWithTargetTag:0];
    [self refreshDataWithTargetTag:1];

}

#pragma mark - 初始化dockButton按钮方法
- (UIButton *)dockItemWithTitle:(NSString *)title tag:(int)tag target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = tag;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    return btn;
}
#pragma mark - 初始化tableView
- (UITableView *)createTableViewWithTag:(int)tag
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = ktableViewRowHeight;
    tableView.tag = tag;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor dp_colorFromHexString:@"#d2cebf"];
    tableView.tableFooterView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    if (IOS_VERSION_7_OR_ABOVE) {
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return tableView;
}

#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i = 0;
    
    if (tableView == _recommendTableView) {
        i = _infoCenter -> GetRecommendCount();
    }else if (tableView == _hotTableView){
        i = _infoCenter -> GetAnnouncementCount();
    }else{
         i = _infoCenter -> GetLotteryCount();
    }
    return i;
}

- (DPLotteryInfoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    DPLotteryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DPLotteryInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    }
    string title,time,url; int gameType=0;
    NSIndexPath *selectedIndex = nil;
    if (tableView == _recommendTableView) {
        _infoCenter -> GetRecommendTarget(indexPath.row, title, time, url, gameType);
        selectedIndex = self.recSelIndex;
    }else if (tableView == _hotTableView){
        _infoCenter -> GetAnnouncementTarget(indexPath.row, title, time, url, gameType);
        selectedIndex = self.hotSelIndex;
    }
    cell.showSel = NO;
    if (selectedIndex) {
        if (selectedIndex.row == indexPath.row){
            cell.showSel = YES;
        }
    }
    NSString *headTitle = [NSString stringWithUTF8String:title.c_str()];
//    NSString *bottomTitle = [NSString stringWithUTF8String:time.c_str()];
   NSString *bottomTitle = [NSDate dp_coverDateString:[NSString stringWithUTF8String:time.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm];
    NSString *urlString = [NSString stringWithUTF8String:url.c_str()];
    [cell setTitle:headTitle subTitle:bottomTitle urlString:urlString indexPath:indexPath];
    cell.gameType =(GameTypeId)gameType;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    string title, time, url; int gameType;
    if (tableView == _recommendTableView) {

        _infoCenter->GetRecommendTarget(indexPath.row, title, time, url, gameType);

    } else if (tableView == _hotTableView) {

        _infoCenter->GetAnnouncementTarget(indexPath.row, title, time, url, gameType);
    }

    NSString *headTitle = [NSString stringWithUTF8String:title.c_str()];

    CGSize size = [headTitle sizeWithFont:[UIFont dp_systemFontOfSize:kInfoTableViewCellTitleFont] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];

    DPLog(@"size height = %f", size.height);
    return size.height + kInfoTabelViewCellHeightDelta;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPLotteryInfoTableViewCell *cell = (DPLotteryInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    NSIndexPath *selectedIndex = tableView == _recommendTableView ? self.recSelIndex : self.hotSelIndex;
    if (selectedIndex) {
        DPLotteryInfoTableViewCell *selectedCell = (DPLotteryInfoTableViewCell *)[tableView cellForRowAtIndexPath:selectedIndex];
        if (selectedCell) [selectedCell setShowSel:NO];
    }
    [cell setShowSel:YES];
    
    if (tableView == _recommendTableView) {
        self.recSelIndex = indexPath;
    }else{
        self.hotSelIndex = indexPath;
    }
    
    [self.navigationController pushViewController:({
        DPLotteryInfoWebViewController *viewController = [[DPLotteryInfoWebViewController alloc] init];
        viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:cell.urlString]];
        viewController.title = @"资讯详情";
        viewController.canHighlight = NO ;
        viewController.gameType = cell.gameType;
        viewController;
    })animated:YES];
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DPLotteryInfoTableViewCell *cell = (DPLotteryInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:NO];
//    if (tableView == _recommendTableView) {
//        self.recSelIndex = nil;
//    }else{
//        self.hotSelIndex = nil;
//    }
//}
#pragma mark 实例化cell
- (UITableViewCell *)createCellForIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    cell.textLabel.font = [UIFont dp_systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.textColor = [UIColor dp_colorFromHexString:@"#998f70"];
    cell.detailTextLabel.font = [UIFont dp_systemFontOfSize:10];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    
    //左边彩条
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = [self getColorWithIndexPath:indexPath];
    [cell.contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell);
        make.left.equalTo(cell);
        make.bottom.equalTo(cell).offset(- 0.5);
        make.width.equalTo(@1.8);
    }];
    
    return cell;

}
#pragma mark - collectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (DPLotteryInfoCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *imageName[] = {@"ssq.png", @"dlt.png", @"jc.png",@"bd.png", @"zc14.png" , @"sd.png", @"ps.png"};
    DPLotteryInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    if (indexPath.row <= sizeof(titleArray) && indexPath.row <= sizeof(imageName))
    {
        [cell setImageName:imageName[indexPath.row] title:titleArray[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    static int gameTypeId[] = {GameTypeSsq, GameTypeDlt, GameTypeJcNone, GameTypeBdNone, GameTypeZcNone, GameTypeSd, GameTypePs,GameTypePw};
    
    DPSpecifyInfoViewController *specify = [[DPSpecifyInfoViewController alloc]initWithStyle:UITableViewStylePlain];
    specify.navTitle = titleArray[indexPath.row];
    specify.gameType = (GameTypeId)gameTypeId[indexPath.row];
    
    [self.navigationController pushViewController:specify animated:YES];
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        int tag = scrollView.contentOffset.x / scrollView.bounds.size.width;
        
        [_dockView selectedItemChangeTo:tag isDelegateSend:YES];
    }
}

#pragma mark DockView代理方法
- (void)dockItemChangedtoTag:(int)tag
{
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat x = _scrollView.contentOffset.x / width;
    if (tag == x) {
        return;
    }
    
    [_scrollView setContentOffset:CGPointMake(tag * width, 0) animated:YES];
    
    [self.view setNeedsLayout];
    [self.view needsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    //移动scrollView视图
    [UIView animateWithDuration:kArrowAnimTime animations:^{
        [self.view layoutIfNeeded];
    }];
    
    
    // 刷新数据
//    [self refreshDataWithTargetTag:tag];
    
}

#pragma mark - 获取随机颜色
- (UIColor *)getColorWithIndexPath:(NSIndexPath *)indexPath
{
    if (_colorArray == nil) {
        _colorArray = @[[UIColor dp_colorFromHexString:@"#546b05"], [UIColor dp_colorFromHexString:@"#00849c"], [UIColor dp_colorFromHexString:@"#ff3000"], [UIColor dp_colorFromHexString:@"ff8a00"], [UIColor dp_colorFromHexString:@"#ff8a00"]];
    }
    
    int index = indexPath.row % _colorArray.count;
    return _colorArray[index];
    
}
#pragma mark - navigationItem点击方法
- (void)navBarLeftItemClick:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype
{
    UITableView* target = nil;
    DPNodataView *noDataView = nil;
    switch (cmdtype) {
        case Info_Announcement:{
            target = _hotTableView;
            noDataView = self.hotTableNoDataView;
        }
            break;
        case Info_Recommend:{
            target = _recommendTableView;
            noDataView = self.recTableNoDataView;
        }
            break;
        case Info_Lottery:
            return;
            break;
        default:
            break;
    }
    DPLog(@"cmdtype = %d, _hotable=%@, _recoTable=%@", cmdtype, _hotTableView, _recommendTableView);
    // 主线程刷新界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [target reloadData];
        [target.pullToRefreshView stopAnimating];
        [target.infiniteScrollingView stopAnimating];
        int rows = [target numberOfRowsInSection:0];
        [target setShowsInfiniteScrolling:rows];
        
        target.tableHeaderView = nil ;
        NSInteger rowsCount = [target numberOfRowsInSection:0];
        if( [AFNetworkReachabilityManager sharedManager].reachable == NO){
            if (rowsCount <=0) {
                noDataView.noDataState = DPNoDataNoworkNet ;
                target.tableHeaderView = noDataView ;
            }else{
                [[DPToast makeText:kNoWorkNet]show];
            }
        }else if(ret ==ERROR_TimeOut ||ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA ) {
            if (rowsCount<=0) {
                noDataView.noDataState = DPNoDataWorkNetFail ;
                target.tableHeaderView = noDataView ;
            }else{
                [[DPToast makeText:kWorkNetFail]show];
            }
        }else if (rowsCount <= 0){
            noDataView.noDataState = DPNoData ;
            target.tableHeaderView = noDataView ;
        }

        [self dismissHUD];
    });
}

#pragma mark - 刷新数据
- (void)refreshDataWithTargetTag:(int)tag {
    switch (tag) {
        case 0:
            _infoCenter->RefreshRecommend();
            break;
        case 1:
            _infoCenter->RefreshAnnouncement();
            break;
        case 2:
            _infoCenter->RefreshLottery();
        default:
            break;
    }
}

-(DPNodataView*)recTableNoDataView{
    if (_recTableNoDataView == nil) {
        _recTableNoDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kDockHeight - 44)];
        _recTableNoDataView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_infoCenter) blockInfoInstance = _infoCenter;
        
        [_recTableNoDataView setClickBlock:^(BOOL setOrUpDate){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (setOrUpDate) {
                DPWebViewController *webView = [strongSelf dp_createCommonNoNetVC];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }else{
                blockInfoInstance -> RefreshRecommend();
                blockInfoInstance -> RefreshAnnouncement();
            }
            
        }];
    }
    return _recTableNoDataView ;
}
-(DPNodataView*)hotTableNoDataView{
    if (_hotTableNoDataView == nil) {
        _hotTableNoDataView = [[DPNodataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kDockHeight - 44)];
        _hotTableNoDataView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
        __weak __typeof(self) weakSelf = self;
        __block __typeof(_infoCenter) blockInfoInstance = _infoCenter;
        
        [_hotTableNoDataView setClickBlock:^(BOOL setOrUpDate){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (setOrUpDate) {
                DPWebViewController *webView = [strongSelf dp_createCommonNoNetVC];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }else{
                [strongSelf showHUD];
                blockInfoInstance -> RefreshRecommend();
                blockInfoInstance -> RefreshAnnouncement();            }
            
        }];
    }
    return _hotTableNoDataView ;
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
- (void)dealloc {
    _infoCenter->Clear();
}

@end
