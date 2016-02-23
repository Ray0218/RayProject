//
//  ClassVideoInfoViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ClassVideoInfoViewController.h"
#import "ClassificationVideoInfoView.h"
#import "UMSocial.h"
#import "JRPlayerViewController.h"
#import "Reachability.h"
@interface ClassVideoInfoViewController ()<UIScrollViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) ClassificationVideoInfoView *classVideoInfoView;
@property (nonatomic, strong) NSMutableArray *imageMArray;
//网络检测
@property (nonatomic, strong) Reachability *conn;

@end

@implementation ClassVideoInfoViewController
{
    UIAlertView *alertView;
    UIAlertView *alertView1;

}

#pragma mark ---网络请求----

- (void)reloadVideoListWithUrl:(NSString *)url
{
    [LORequestManger GET:url success:^(id response) {
        [SVProgressHUD show];
        NSDictionary *dic = (NSDictionary *)response;
        self.nextPageUrl = dic[@"nextPageUrl"];
        for (NSDictionary *videoList in dic[@"videoList"])
        {
            VideoListModel *model = [VideoListModel shareJsonWithDic2:videoList dic3:videoList[@"consumption"] dic4:videoList[@"provider"]
                arr:videoList[@"playInfo"]];
            [self.videoArray addObject:model];
        }
        [SVProgressHUD dismiss];
        //移除原有视图
        [self.view removeAllSubviews];
        //初始化UIView
        self.classVideoInfoView = [[ClassificationVideoInfoView alloc]initWithFrame:kBounds taget:self action:@selector(checkNetworkState) row:_row - 1 array:self.videoArray];
        self.model = self.videoArray[_row - 1];
        [self.classVideoInfoView setValueWithModel:_model row:_row array:_videoArray];
        [self.classVideoInfoView.collectButton addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.classVideoInfoView.shareButton addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
        self.classVideoInfoView.scrollView.delegate = self;
        [self.view addSubview:self.classVideoInfoView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navigationController的透明度
    self.navigationController.navigationBar.translucent = NO;

    //初始化UIView
    self.classVideoInfoView = [[ClassificationVideoInfoView alloc]initWithFrame:kBounds taget:self action:@selector(checkNetworkState) row:_row array:self.videoArray];
    [self.classVideoInfoView setValueWithModel:_model row:_row array:_videoArray];
    [self.classVideoInfoView.collectButton addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.classVideoInfoView.shareButton addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.classVideoInfoView.scrollView.delegate = self;
    [self.view addSubview:self.classVideoInfoView];
    self.section = [self.videoArray count] / 20;
    
    //把拖进去的图片放进一个数组中
    self.imageMArray = [NSMutableArray array];
    for (int i = 1; i < 10; i++)
    {
        //拼接图片名字
        NSString *name = [NSString stringWithFormat:@"yun－%d.jpg", i];
        //用名字初始化图片
        UIImage *image = [UIImage imageNamed:name];
        //添加进数组
        [self.imageMArray addObject:image];
    }
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButton)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    //网络检测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];

}
-(void)leftButton
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)networkStateChange
{
    //    [self checkNetworkState];
    
}
-(void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)checkNetworkState
{
    //检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网(wifi\3G);
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"有wifi");
        
        alertView1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前处于WiFi状态" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        //设置弹窗是自动消失的
        [alertView1 show];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(view1:) userInfo:nil repeats:NO];
    }else if ([conn currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"使用手机自带网络进行上网");
        
        alertView1 = [[UIAlertView alloc] initWithTitle:@"提示"message:@"当前处于非WiFi状态" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView1 show];
    }else
    {
        NSLog(@"没有网络");
        
        alertView1 = [[UIAlertView alloc] initWithTitle:@"提示"message:@"网络无法连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView1 show];
    }
}
- (void)view1:(NSTimer *)timer
{
    [alertView1 dismissWithClickedButtonIndex:0 animated:YES];
    [self settingClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----滑动图片结束时触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"========%@", NSStringFromCGPoint(scrollView.contentOffset));
    NSLog(@"滑动时触发5");
    self.row = scrollView.contentOffset.x / kScreenWidth;
    NSLog(@"%ld",self.row);
    if (_row == 0)
    {
        //至顶部
        scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    }
    else if (self.row < [self.videoArray count] + 1)
    {
        [self changeAnimationsWithView:self.classVideoInfoView];
        self.model = self.videoArray[_row - 1];
        [self.classVideoInfoView changeContentValueWithModel:self.model];
    }
    //下一分区
    else
    {
        [self reloadVideoListWithUrl:self.nextPageUrl];
    }
}

- (void)changeAnimationsWithView:(UIView *)view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    //设置运动时间
    animation.duration = 0.5;
    animation.delegate = self;
    //设置运动type
    animation.type = @"rippleEffect";
    //设置子类
    animation.subtype = kCATransitionFromTop;
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"a"];
}

#pragma mark-----ImageView的点击方法
- (void)settingClick
{
    if (_model.highUrl)
    {
        NSURL *url = [NSURL URLWithString:_model.highUrl];
        JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
        [self presentViewController:playerVC animated:YES completion:nil];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:_model.normalUrl];
        JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
        [self presentViewController:playerVC animated:YES completion:nil];
    }
}

#pragma mark-----Click  点赞
- (void)click:(UIButton *)button
{
    
    button.selected = !button.selected;
    if (button.selected == YES)
    {
        //设置点击第一次完成收藏
        [button setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f004(0)_48"] forState:(UIControlStateSelected)];
        self.classVideoInfoView.collectLabel.text = [NSString stringWithFormat:@"%lu", self.model.collectionCount + 1];
        //添加一个弹窗,  显示是否收藏成功
        alertView = [[UIAlertView alloc]initWithTitle:@"已收藏成功" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        //设置弹窗是自动消失的
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(view:) userInfo:nil repeats:NO];
        [alertView show];
    }else
    {
        //当点击第二次取消收藏
        [button setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f08a(0)_48"] forState:(UIControlStateNormal)];
        self.classVideoInfoView.collectLabel.text = [NSString stringWithFormat:@"%lu", self.model.collectionCount];
    }
}
- (void)view:(NSTimer *)timer
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark----分享按钮
- (void)shareClick:(UIButton *)button
{
    NSURL *url = [NSURL URLWithString:_model.coverForSharing];
    NSData *data = [NSData dataWithContentsOfURL:url];
    //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    [UMSocialSnsService presentSnsIconSheetView:self
                                appKey:@"55fd0ce3e0f55a305b002070"
                                shareText:@"你要分享的文字"
                                shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban, nil]
                                       delegate:self];
    button.selected = !button.selected;
    if (button.selected == YES)
    {
        self.classVideoInfoView.shareLabel.text = [NSString stringWithFormat:@"%lu", _model.shareCount + 1];
    }else
    {
        self.classVideoInfoView.shareLabel.text = [NSString stringWithFormat:@"%lu",_model.shareCount];
    }
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
