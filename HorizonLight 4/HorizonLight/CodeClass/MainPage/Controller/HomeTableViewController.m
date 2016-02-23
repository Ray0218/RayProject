//
//  HomeTableViewController.m
//  HorizonLight
//
//  Created by BaQi on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "HomeModel.h"
#import "HomeWebViewController.h"
#import "MainTableViewController.h"
#import "ClassificationViewController.h"
#import "TopTableViewController.h"
#import "SettingViewController.h"
#import "RelaxationViewController.h"
#import "SkipViewController.h"
#import "HomeTableViewCell.h"
#import "MJRefresh.h"
@interface HomeTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SkipViewController *skipVC;

@end

@implementation HomeTableViewController

static NSInteger count = 1;


#pragma mark-----数据解析
- (void)reloadHomeDataJson:(NSString *)urlString isNil:(BOOL)isNil
{
    [LORequestManger GET:urlString success:^(id response) {
        NSMutableArray *array = (NSMutableArray *)response;
        if (isNil)
        {
            self.dataArray = nil;
        }

        for (NSDictionary *dic in array) {
            HomeModel *homeModel = [HomeModel shareJsonWithDictionary:dic];
            homeModel.feed_id = dic[@"id"];
            [self.dataArray addObject:homeModel];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建模糊视图
    BlurImageView *blurImageView = [[BlurImageView alloc] initWithFrame:kBounds imageURL:@"001.jpg"];
    self.tableView.backgroundView = blurImageView;
    
    
    //数据解析
    [self reloadHomeDataJson:[kHomeUrl stringByReplacingOccurrencesOfString:@"page=%@" withString:[NSString stringWithFormat:@"page=%ld", count]] isNil:YES];
    //去掉cell的分割线
    //self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    //注册cell
    [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCtrler) name:@"push" object:nil];
    
    //调用下拉刷新上拉加载
    [self setupRefresh];
    
    //创建左UIButton
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"linea_2b(0)_32"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"首页";
    
}

//左侧按钮的点击方法
-(void)leftButtonClick
{
    [[TheDrawerSwitch shareSwitchDrawer] openOrCloseTheDrawer];
}


- (void)pushCtrler
{
    if ([[TheDrawerSwitch shareSwitchDrawer].message isEqualToString:@"首页"])
    {
        self.skipVC = nil;
        [self.navigationController popToViewController:self animated:YES];
    }
    else if ([[TheDrawerSwitch shareSwitchDrawer].message isEqualToString:@"每日视频"])
    {
        [self loadSkipVC];
        MainTableViewController *mainVC = [[MainTableViewController alloc] init];
        [self.navigationController pushViewController:mainVC animated:YES];
    }
    else if ([[TheDrawerSwitch shareSwitchDrawer].message isEqualToString:@"往期分类"])
    {
        [self loadSkipVC];
        ClassificationViewController *classVC = [[ClassificationViewController alloc] init];
        [self.navigationController pushViewController:classVC animated:YES];
    }
    else if ([[TheDrawerSwitch shareSwitchDrawer].message isEqualToString:@"视频排行"])
    {
        [self loadSkipVC];
        TopTableViewController *topTVC = [[TopTableViewController alloc] init];
        topTVC.naviTitle = @"视频排行";
        [self.navigationController pushViewController:topTVC animated:YES];
    }
    else if ([[TheDrawerSwitch shareSwitchDrawer].message isEqualToString:@"闲闻趣事"])
    {
        [self loadSkipVC];
        RelaxationViewController *relaxationVC = [[RelaxationViewController alloc] init];
        [self.navigationController pushViewController:relaxationVC animated:YES];
    }
    else if ([[TheDrawerSwitch shareSwitchDrawer].message isEqualToString:@"设置"])
    {
        [self loadSkipVC];
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSkipVC
{
    if (self.skipVC)
    {
        [self.navigationController popToViewController:self.skipVC animated:NO];
    }
    else
    {
        self.skipVC = [[SkipViewController alloc] init];
        [self.navigationController pushViewController:self.skipVC animated:NO];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HomeModel *model = self.dataArray[indexPath.row];
    
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.feature_img]];
    cell.titleLabel.text = model.title;
    cell.typeNameLabel.text = model.node_name;
    
    return cell;
}

#pragma mark------设置每行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}


#pragma mark------设置cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWebViewController *homeWebVC = [[HomeWebViewController alloc]init];
    HomeModel *model = self.dataArray[indexPath.row];
    //获取到解析数据中的ID
    homeWebVC.ID = model.feed_id;
    [self.navigationController pushViewController:homeWebVC animated:YES];
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
        
    NSString *urlStr = [kHomeUrl stringByReplacingOccurrencesOfString:@"page=%@" withString:[NSString stringWithFormat:@"page=%d", 1]];
        [self reloadHomeDataJson:urlStr isNil:YES];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });

}

- (void)footerRereshing
{
    NSString *urlStr = [kHomeUrl stringByReplacingOccurrencesOfString:@"page=%@" withString:[NSString stringWithFormat:@"page=%ld", ++count]];
        [self reloadHomeDataJson:urlStr isNil:NO];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];

    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });

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
