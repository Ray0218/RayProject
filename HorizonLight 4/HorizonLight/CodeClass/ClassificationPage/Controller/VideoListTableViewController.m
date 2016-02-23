//
//  VideoListTableViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/23.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "VideoListTableViewController.h"
#import "VideoListModel.h"
#import "VideoTableViewCell.h"
#import "TopTableViewCell.h"
#import "VideoListHeaderView.h"
#import "ClassVideoInfoViewController.h"
#import "ClassificationViewController.h"
#import "ClassificationModel.h"
#import "UIViewController+AnimationMake.h"
#import "MJRefresh.h"

@interface VideoListTableViewController ()

@property (nonatomic, strong) NSMutableArray *videoListMArray;
@property (nonatomic, strong) NSString *nextPageUrl;
@property (nonatomic, strong) VideoListHeaderView *headerView;

@end

@implementation VideoListTableViewController

#pragma mark ---网络请求----

- (void)reloadVideoListWithUrl:(NSString *)url isNil:(BOOL)isNil
{
    [LORequestManger GET:url success:^(id response) {
        [SVProgressHUD show];
        NSDictionary *dic = (NSDictionary *)response;
        if (isNil)
        {
            self.videoListMArray = nil;
        }
        self.nextPageUrl = dic[@"nextPageUrl"];
        for (NSDictionary *videoList in dic[@"videoList"])
        {
            VideoListModel *model = [VideoListModel shareJsonWithDic2:videoList dic3:videoList[@"consumption"] dic4:videoList[@"provider"] arr:videoList[@"playInfo"]];
            [self.videoListMArray addObject:model];
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark ----懒加载----

- (NSMutableArray *)videoListMArray
{
    if (!_videoListMArray)
    {
        _videoListMArray = [[NSMutableArray alloc] init];
    }
    return _videoListMArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationController的透明度
    self.navigationController.navigationBar.translucent = YES;
    //确认网址,调用
//    self.classURLStr = [NSString stringWithFormat:kClassUrl, _classNameStr, @"date"];
    self.classURLStr = [[kClassUrl stringByAppendingString:self.classNameStr] stringByAppendingString:kClassUrldate];
    _classURLStr = [_classURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self reloadVideoListWithUrl:_classURLStr isNil:YES];
    
    //两个刷新
    [self setupRefresh];
    [self setUpUIBarButtonItem];
    
    //去线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //创建模糊视图
    BlurImageView *blurImageView = [[BlurImageView alloc] initWithFrame:kBounds imageURL:@"001.jpg"];
    self.tableView.backgroundView = blurImageView;
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButton)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}
-(void)leftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -----刷新方法------------

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    //[self.tableView footerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"主人,小强正在玩命刷新...";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.tableView.footerRefreshingText = @"主人,小强正在玩命加载...";
}


#pragma mark -------开始进入刷新状态-------

- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [self reloadVideoListWithUrl:self.classURLStr isNil:YES];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (self.nextPageUrl != NULL)
    {
        [self reloadVideoListWithUrl:self.nextPageUrl isNil:NO];
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}
#pragma mark --------设置titleView-------------
-(void)setUpUIBarButtonItem
{
    //创建titleView
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 130, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    //创建一个UILabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 130, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:20];
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text =self.classNameStr;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
}

//点击方法
-(void)searchprogram
{
    
}

//添加每个cell出现时的动画(从左边出现)
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransform3D rotation;//3D旋转
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    //逆时针旋转
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    cell.alpha = 0;
    
    cell.contentView.layer.transform = rotation;
    //旋转定点
    cell.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
    
    [UIView beginAnimations:@"rotation" context:NULL];
    //旋转时间
    [UIView setAnimationDuration:0.8];
    cell.contentView.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoListMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    VideoListModel *model = self.videoListMArray[indexPath.row];
    cell.ranking = indexPath.row;
    [cell setValueWithModel:model];
    return cell;
}


#pragma mark -------返回每分区高度--------

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight / 5 * 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


#pragma mark ----- 点击cell ------

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassVideoInfoViewController *classVideoInfoVC = [[ClassVideoInfoViewController alloc]init];
    
    classVideoInfoVC.videoArray = self.videoListMArray;
    classVideoInfoVC.model = self.videoListMArray[indexPath.row];
    classVideoInfoVC.row = indexPath.row;
    classVideoInfoVC.nextPageUrl = self.nextPageUrl;
    [self.navigationController setAnimationWithSubtype:1 andAnimationType:8];
    [self.navigationController pushViewController:classVideoInfoVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headerView == nil)
    {
        NSArray *array = @[@"按时间排序", @"分享排行榜"];
        self.headerView = [[VideoListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) array:array];
        [self addTagetForBtnWithCount:array.count view:_headerView];
    }
    return _headerView;
}

- (void)addTagetForBtnWithCount:(NSUInteger)count view:(UIView *)view
{
    for (int i = 0; i < count; i++)
    {
        UIButton *button = (UIButton *)[self.headerView viewWithTag:1100 + i];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)btnClick:(UIButton *)button
{
    if (button.tag == 1100)
    {
        self.headerView.timebtn.selected = YES;
//        [self.headerView.timebtn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
        self.headerView.timebtn.userInteractionEnabled = NO;
        self.headerView.sharebtn.selected = NO;
        self.headerView.sharebtn.userInteractionEnabled = YES;
        self.videoListMArray = nil;
    self.classURLStr = [[kClassUrl stringByAppendingString:self.classNameStr] stringByAppendingString:kClassUrldate];
        _classURLStr = [_classURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self reloadVideoListWithUrl:_classURLStr isNil:YES];
    }
    else if (button.tag == 1101)
    {
        self.headerView.timebtn.selected = NO;
        self.headerView.timebtn.userInteractionEnabled = YES;
        self.headerView.sharebtn.selected = YES;
        self.headerView.sharebtn.userInteractionEnabled = NO;
        self.videoListMArray = nil;
    self.classURLStr = [[kClassUrl stringByAppendingString:self.classNameStr] stringByAppendingString:kClassUrlshareCount];
        _classURLStr = [_classURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self reloadVideoListWithUrl:_classURLStr isNil:YES];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
