//
//  RelaxationViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/26.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "RelaxationViewController.h"
#import "RelaxationModel.h"
#import "ImageCollectionViewCell.h"
#import "RelaxationFlowLayout.h"
#import "DetailsViewController.h"
#import "MJRefresh.h"
@interface RelaxationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RelaxationFlowLayoutDelegate,UIWebViewDelegate>
{
    float width;
    float height;
    NSString *timerSP;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@end

@implementation RelaxationViewController


#pragma mark ----网络请求-----
- (void)reloadVideoListWithUrl:(NSString *)url isNil:(BOOL)isNil
{
    [LORequestManger GET:url success:^(id response) {
        
        NSDictionary *dic = (NSDictionary *)response;
        if (isNil)
        {
            self.dataArray = nil;
        }

        for (NSDictionary *result in dic[@"result"]) {
            RelaxationModel *model = [RelaxationModel shareJsonWithDictionary:result];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

#pragma mark ---懒加载-----
-(NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建左UIButton
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"linea_2b(0)_32"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"闲闻趣事";
    
    //创建布局对象
    RelaxationFlowLayout *flowLayout = [[RelaxationFlowLayout alloc] init];
    flowLayout.delegate = self;
    //指2列
    flowLayout.numberOfColumn = 2;
    //创建集合视图
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //给collectionView注册一个cell类
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionView];
    
    //进行时间转换
    NSDate *date = [NSDate date];
    timerSP = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    [self reloadVideoListWithUrl:[[kRelaxationUrl stringByAppendingString:timerSP] stringByAppendingString:kRelaxationUrlTwo]isNil:YES];
    //调用
    [self setupRefresh];
    
    //创建模糊视图
    BlurImageView *blurImageView = [[BlurImageView alloc] initWithFrame:kBounds imageURL:@"001.jpg"];
    self.collectionView.backgroundView = blurImageView;
}
//点击方法
-(void)leftButtonClick
{
    [[TheDrawerSwitch shareSwitchDrawer] openOrCloseTheDrawer];
}


#pragma mark -----刷新方法------------

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    //[self.collectionView footerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.collectionView.headerPullToRefreshText = @"下拉可以刷新";
    self.collectionView.headerReleaseToRefreshText = @"松开马上刷新";
    self.collectionView.headerRefreshingText = @"主人,小强正在玩命刷新...";
    
    self.collectionView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.collectionView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.collectionView.footerRefreshingText = @"主人,小强正在玩命加载...";
}


#pragma mark -------开始进入刷新状态-------

- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //进行时间转换
        NSDate *date = [NSDate date];
        timerSP = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
        [self reloadVideoListWithUrl:[[kRelaxationUrl stringByAppendingString:timerSP] stringByAppendingString:kRelaxationUrlTwo]isNil:YES];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.collectionView headerEndRefreshing];
    });
}
- (void)footerRereshing
{
    //根据网址数组最后一个拼接
    RelaxationModel *model = [self.dataArray lastObject];
    //网址拼接
    [self reloadVideoListWithUrl:[[kRelaxationUrl stringByAppendingString: [NSString stringWithFormat:@"%ld", model.date_picked]] stringByAppendingString:kRelaxationUrlTwo] isNil:NO];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.collectionView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.collectionView footerEndRefreshing];
    });
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RelaxationModel *model = self.dataArray[indexPath.row];
    //获取图片的宽  高
    CGFloat cellWidth = (kScreenWidth - 10) / 2;
    NSRange range = [model.headline_img_tb rangeOfString:@"w/"];
    if (range.length != 0) {
        NSArray *rangOne = [model.headline_img_tb componentsSeparatedByString:@"w/"];
        NSArray *rangTwo = [[rangOne objectAtIndex:1] componentsSeparatedByString:@"/"];
        width = [[rangTwo objectAtIndex:0] floatValue];
        height = [[rangTwo lastObject]floatValue];
    }else
    {
        height = 250.0;
    }
    return CGSizeMake(cellWidth, height / 1.7 + 70);

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);

}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0 ;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return 6.5;
}

#pragma mark -----DataSource-----
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    RelaxationModel *model = [self.dataArray objectAtIndex:indexPath.item];
    [cell setRelaxationModel:model];
    return cell;

}
//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
    RelaxationModel *model = self.dataArray[indexPath.row];
    detailsVC.urlString = model.link_v2;
//    detailsVC.title = model.title;
    [self.navigationController pushViewController:detailsVC animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
