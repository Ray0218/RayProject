//
//  ClassificationViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/17.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ClassificationCollectionViewCell.h"
#import "ClassificationModel.h"
#import "LORequestManger.h"
#import "VideoListTableViewController.h"
#import "TopTableViewController.h"

@interface ClassificationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
//设置一个数组, 接收存储的model
@property (nonatomic, strong) NSMutableArray *classIficationArray;
//设置ClassificationViewController为属性,  刷新界面
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationController的透明度
    self.navigationController.navigationBar.translucent = YES;
    [SVProgressHUD show];
   
    //调用解析内容
    [self reloadClassification];
    //调用集合视图和布局
    [self setUpCollectionView];
    
    //调用
    [self setUpUIBarButtonItem];
}
#pragma mark --------设置titleView-------------
-(void)setUpUIBarButtonItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"linea_2b(0)_32"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Material Icons_e905(2)_32.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(buttonClick) ];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    
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

//点击方法
-(void)buttonClick
{
    TopTableViewController *videoTVC = [[TopTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    videoTVC.urlArray = @[kWeekTopUrl, kMonthTopUrl, kTotalTopUrl];
    [self.navigationController pushViewController:videoTVC animated:YES];
}
-(void)leftButtonClick
{
    [[TheDrawerSwitch shareSwitchDrawer] openOrCloseTheDrawer];
}


#pragma mark -----分类页面数据解析
- (void)reloadClassification
{
    [LORequestManger GET:kClassificationUrl success:^(id response) {
        NSArray *array = (NSArray *)response;
        //获取数组中的键值对
        for (NSDictionary *dic in array) {
            //创建model接收数据
            ClassificationModel *model = [ClassificationModel shareJsonWithDictionary:dic];
            //创建可变数组接收model的数据
            [self.classIficationArray addObject:model];
        }
        [SVProgressHUD dismiss];
        //刷新界面
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}
// 懒加载-----初始化属性数组
- (NSMutableArray *)classIficationArray
{
    if (!_classIficationArray) {
        _classIficationArray = [[NSMutableArray alloc]init];
    }
    return _classIficationArray;
}

#pragma mark -----创建CollectionView并设置
- (void)setUpCollectionView
{
    //创建布局对象
     UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置每一行之间的间距
    layout.minimumLineSpacing = 10;
    //获取高度
    CGFloat width = self.view.frame.size.width;
    //设置每个item的大小
    layout.itemSize = CGSizeMake((width - 10) / 2, (width - 10) / 2) ;

    //创建集合视图
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    //设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //设置颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //去掉滑动的垂直线
    self.collectionView.showsVerticalScrollIndicator = NO;
  
    //注册cell
    [self.collectionView registerClass:[ClassificationCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
 
    [self.view addSubview:self.collectionView];
    
}

#pragma mark -----返回的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.classIficationArray.count;
}

#pragma mark ----- cell的方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //设置一个标识
    ClassificationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //获取数组中的数据
    ClassificationModel *model = self.classIficationArray[indexPath.row];
    [cell setValueWithModel:model];

    return cell;
}

#pragma mark -----点击每个ImageView的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListTableViewController *videoTVC = [[VideoListTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    
    //获取数组中的数据
    ClassificationModel *model = self.classIficationArray[indexPath.row];
    videoTVC.classNameStr = model.name;
    [self.navigationController pushViewController:videoTVC animated:YES];
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
