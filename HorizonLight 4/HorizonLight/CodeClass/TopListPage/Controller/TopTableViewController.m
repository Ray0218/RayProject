//
//  TopTableViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/23.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "TopTableViewController.h"
#import "VideoListModel.h"
#import "VideoTableViewCell.h"
#import "TopTableViewCell.h"
#import "TheEndTableViewCell.h"
#import "TopListHeaderView.h"
#import "ClassVideoInfoViewController.h"
#import "UIViewController+AnimationMake.h"

@interface TopTableViewController ()

@property (nonatomic, strong) NSMutableArray *videoListMArray;
@property (nonatomic, strong) NSString *nextPageUrl;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) TopListHeaderView *headerView;

@end

@implementation TopTableViewController

#pragma mark ---网络请求----

- (void)reloadVideoListWithUrl:(NSString *)url
{
    [LORequestManger GET:url success:^(id response)
     {
        [SVProgressHUD show];
        NSDictionary *dic = (NSDictionary *)response;
        //        NSLog(@"%@", self.nextPageUrl);
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
    
    self.urlArray = @[kWeekTopUrl, kMonthTopUrl, kTotalTopUrl];
    //调用
    [self reloadVideoListWithUrl:self.urlArray[0]];
    [self setUpUIBarButtonItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    [self.tableView registerClass:[TopTableViewCell class] forCellReuseIdentifier:@"TopCell"];
    [self.tableView registerClass:[TheEndTableViewCell class] forCellReuseIdentifier:@"EndCell"];
    
    //创建模糊视图
    BlurImageView *blurImageView = [[BlurImageView alloc] initWithFrame:kBounds imageURL:@"001.jpg"];
    self.tableView.backgroundView = blurImageView;
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
    titleLabel.text =self.naviTitle;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"linea_2b(0)_32"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

}

//点击方法
-(void)leftButtonClick
{
    [[TheDrawerSwitch shareSwitchDrawer] openOrCloseTheDrawer];
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
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.videoListMArray.count > 0)
    {
        return self.videoListMArray.count + 1;
    }
    return self.videoListMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 30)
    {
        TheEndTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndCell" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        TopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
        VideoListModel *model = self.videoListMArray[indexPath.row];
        cell.ranking = indexPath.row;
        [cell setValueWithModel:model];
        return cell;
    }
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
    if (indexPath.row < _videoListMArray.count)
    {
        ClassVideoInfoViewController *classVideoInfoVC = [[ClassVideoInfoViewController alloc]init];
        
        classVideoInfoVC.videoArray = self.videoListMArray;
        classVideoInfoVC.model = self.videoListMArray[indexPath.row];
        classVideoInfoVC.row = indexPath.row;
        [self.navigationController setAnimationWithSubtype:1 andAnimationType:8];
        [self.navigationController pushViewController:classVideoInfoVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headerView == nil)
    {
        NSArray *array = @[@"周排行", @"月排行", @"总排行"];
        self.headerView = [[TopListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) array:array];
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
        NSLog(@"%@", _urlArray[0]);
        self.headerView.weekbtn.selected = YES;
        self.headerView.weekbtn.userInteractionEnabled = NO;
        self.headerView.monthbtn.selected = NO;
        self.headerView.monthbtn.userInteractionEnabled = YES;
        self.headerView.totalbtn.selected = NO;
        self.headerView.totalbtn.userInteractionEnabled = YES;
        self.videoListMArray = nil;
        [self reloadVideoListWithUrl:_urlArray[0]];
    }
    else if (button.tag == 1101)
    {
        [self reloadVideoListWithUrl:_urlArray[1]];
        self.headerView.weekbtn.selected = NO;
        self.headerView.weekbtn.userInteractionEnabled = YES;
        self.headerView.monthbtn.selected = YES;
        self.headerView.monthbtn.userInteractionEnabled = NO;
        self.headerView.totalbtn.selected = NO;
        self.headerView.totalbtn.userInteractionEnabled = YES;
        self.videoListMArray = nil;
        NSLog(@"%@", _urlArray[1]);
    }
    else if (button.tag == 1102)
    {
        [self reloadVideoListWithUrl:_urlArray[2]];
        self.headerView.weekbtn.selected = NO;
        self.headerView.weekbtn.userInteractionEnabled = YES;
        self.headerView.monthbtn.selected = NO;
        self.headerView.monthbtn.userInteractionEnabled = YES;
        self.headerView.totalbtn.selected = YES;
        self.headerView.totalbtn.userInteractionEnabled = NO;
        self.videoListMArray = nil;
        NSLog(@"%@", _urlArray[2]);
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
