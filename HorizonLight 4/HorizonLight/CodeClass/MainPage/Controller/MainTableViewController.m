//
//  MainTableViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "MainTableViewController.h"
#import "VideoListModel.h"
#import "VideoTableViewCell.h"
#import "SettingViewController.h"
#import "ClassificationViewController.h"
#import "TopTableViewController.h"
#import "SettingViewController.h"
#import "MainVideoInfoViewController.h"
#import "UIViewController+AnimationMake.h"
#import "HomeTableViewController.h"
#import "RelaxationViewController.h"
#import "MJRefresh.h"
@interface MainTableViewController ()

@property (nonatomic, strong) NSMutableArray *videoListMArray;
@property (nonatomic, strong) NSMutableArray *dateListMArray;
@property (nonatomic, strong) NSString *nextPageUrl;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MainTableViewController

#pragma mark ---网络请求----

- (void)reloadVideoListWithUrl:(NSString *)url isNil:(BOOL)isNil
{
    
    [LORequestManger GET: url success:^(id response) {
        NSDictionary *dic = (NSDictionary *)response;
        if (isNil)
        {
            self.dateListMArray = nil;
        }

        self.nextPageUrl = dic[@"nextPageUrl"];
        for (NSDictionary *dailyList in dic[@"dailyList"])
        {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *videoList in dailyList[@"videoList"])
            {
                VideoListModel *model = [VideoListModel shareJsonWithDic1:dailyList dic2:videoList dic3:videoList[@"consumption"] dic4:videoList[@"provider"] arr:videoList[@"playInfo"]];
                [array addObject:model];
            }
            [SVProgressHUD dismiss];
            [self.dateListMArray addObject:array];
        }
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
#pragma mark ----懒加载----

-(NSMutableArray *)dateListMArray
{
    if (!_dateListMArray)
    {
        _dateListMArray = [[NSMutableArray alloc] init];
    }
    return _dateListMArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    
    //设置navigationController的透明度
    self.navigationController.navigationBar.translucent = YES;
    //调用
    [self reloadVideoListWithUrl:[NSString stringWithFormat:kTodaySelectionUrl, [self getsTheCurrentTime]] isNil:YES];
    [self setUpUIBarButtonItem];
    [self setupRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:@"cell"];
    //创建模糊视图
    BlurImageView *blurImageView = [[BlurImageView alloc] initWithFrame:kBounds imageURL:@"001.jpg"];
    self.tableView.backgroundView = blurImageView;
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
        
    [self reloadVideoListWithUrl:[NSString stringWithFormat:kTodaySelectionUrl, [self getsTheCurrentTime]]isNil:YES];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    [self reloadVideoListWithUrl:self.nextPageUrl isNil:NO];

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
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"linea_2b(0)_32"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    //创建titleView
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 130, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    
    //创建一个UILabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 130, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:22];
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    titleLabel.text = @"HorizonLight";
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
}

-(void)leftButtonClick
{
    [[TheDrawerSwitch shareSwitchDrawer] openOrCloseTheDrawer];
}

//获取当前日期
-(NSString *)getsTheCurrentTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    self.month = month;
    NSInteger day=[conponent day];
    self.day = day;
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4ld%02ld%02ld",(long)year,(long)month,(long)day];
    return nsDateString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return self.dateListMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSMutableArray *array = self.dateListMArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    VideoListModel *model = self.dateListMArray[indexPath.section][indexPath.row];
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
    return kScreenHeight / 10;
    
}
#pragma mark ----- 点击cell ------

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MainVideoInfoViewController *mainViedeoInfoVC = [[MainVideoInfoViewController alloc]init];
    
    mainViedeoInfoVC.videoArray = self.dateListMArray;
    mainViedeoInfoVC.videoListModel = self.dateListMArray[indexPath.section][indexPath.row];
    mainViedeoInfoVC.section = indexPath.section;
    mainViedeoInfoVC.row = indexPath.row;
    [self.navigationController setAnimationWithSubtype:1 andAnimationType:8];
    [self.navigationController pushViewController:mainViedeoInfoVC animated:YES];
//    [self achieverAnimationByClickTheCell];
    
}

//-(void)achieverAnimationByClickTheCell
//{
////    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
////    view.backgroundColor = [UIColor clearColor];
////    [self.tableView addSubview:view];
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    scrollView.backgroundColor = [UIColor clearColor];
//    [self.tableView addSubview:scrollView];
//    self.navigationController.navigationBar.translucent = NO;
//
//    //播放背景图片
//    self.settingImageView = [[TouchImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight / 10,  kScreenWidth , kScreenHeight / 2 - 32)];
//    self.settingImageView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.settingImageView];
//    //模糊图片
//    self.vagueImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight / 2 - 32, kScreenWidth, kScreenHeight / 2 )];
//    self.vagueImageView.backgroundColor = [UIColor lightGrayColor];
//    [scrollView insertSubview:self.vagueImageView belowSubview:self.settingImageView];
//    [self gointoNextPage];
//}
//
//-(void)gointoNextPage
//{
//    [UIView animateWithDuration:.35 animations:^{
//        self.settingImageView.frame = CGRectMake(0, 0,  kScreenWidth , kScreenHeight / 2 - 32);
//        self.vagueImageView.frame =  CGRectMake(0, kScreenHeight / 2 - 32, kScreenWidth, kScreenHeight / 2 );
//    }];
//
//}
////UItableview处理section的不悬浮，禁止section停留的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = kScreenHeight / 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    VideoListModel *model = self.dateListMArray[section][0];
    NSString *str=model.date;//时间戳
    NSTimeInterval time=[str doubleValue] / 1000+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormatter stringFromDate:detaildate];//将nsdate按formatter格式转成nsstring
    NSString *month = [timeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [timeStr substringWithRange:NSMakeRange(8, 2)];
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 10)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:18];
    label.text = [NSString stringWithFormat:@"- %@%@ -", kMonths[[month integerValue] - 1], day];
    [titleView addSubview:label];
    return  titleView;
    
}
//添加每个cell出现时的3D动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CATransform3D rotation;//3D旋转
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    //逆时针旋转
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    
    [UIView beginAnimations:@"rotation" context:NULL];
    //旋转时间
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

//- (void)pushCtrlerWithNumber:(NSUInteger)number
//{
//    self.classificationVC = [[ClassificationViewController alloc] init];
//    self.topTVC = [[TopTableViewController alloc] init];
//    NSArray *array = @[_mainTVC, _classificationVC, _topTVC];
//    [self.navigationController pushViewController:array[number] animated:YES];
//}

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
