//
//  MainVideoInfoViewController.m
//  HorizonLight
//
//  Created by BaQi on 15/9/23.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "MainVideoInfoViewController.h"
#import "MainVideoInfoView.h"
#import "UMSocial.h"
#import "JRPlayerViewController.h"
#import "Reachability.h"

@interface MainVideoInfoViewController ()<UIScrollViewDelegate, UMSocialUIDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MainVideoInfoView *mainVideoInfoView;

//创建一个接收图片的数组
@property (nonatomic, strong) NSMutableArray *pictureArray;
//网络检测
@property (nonatomic, strong) Reachability *conn;

@end

@implementation MainVideoInfoViewController
{
    UIAlertView *alertView;
    UIAlertView *alertView1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationController的透明度
    self.navigationController.navigationBar.translucent = NO;

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButton)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    //初始化UIView
    self.mainVideoInfoView = [[MainVideoInfoView alloc]initWithFrame:kBounds taget:self action:@selector(checkNetworkState)section:self.section row:_row array:self.videoArray];
    [self.mainVideoInfoView setUpViewWithModel:_videoListModel section:self.section array:self.videoArray];
    [self.mainVideoInfoView.clickPraiseButton addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainVideoInfoView.shareButton addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.mainVideoInfoView.scrollView.delegate = self;
    [self.view addSubview:self.mainVideoInfoView];
    
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
        [alertView1 show];
    }else if ([conn currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"使用手机自带网络进行上网");
        
        alertView1 = [[UIAlertView alloc] initWithTitle:@"提示"message:@"当前处于非WiFi状态" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self settingClick];
    }
}

#pragma mark----开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽时1");
}


#pragma mark----拖拽结束时
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"快要结束拖拽时2");
}


#pragma mark----拖拽结束时触发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSLog(@"拖拽时结束3");
}



#pragma mark----手指离开时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"手指离开之前4");
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
        //上一分区
        if (self.section != 0)
        {
            _section--;
            self.row = [self.videoArray[_section] count];
            self.videoListModel = self.videoArray[_section][_row - 1];
            [self.mainVideoInfoView setUpViewWithModel:self.videoListModel section:self.section array:self.videoArray];
            scrollView.contentOffset = CGPointMake(kScreenWidth * [self.videoArray[_section] count], 0);
        }
    }
    else if (self.row < [self.videoArray[self.section] count] + 1)
    {
        [self changeAnimationsWithView:self.mainVideoInfoView];
        self.videoListModel = self.videoArray[_section][_row - 1];
        [self.mainVideoInfoView changeContentValueWithModel:self.videoListModel];
    }
    //下一分区
    else
    {
        self.section++;
        self.row = 0;
        self.videoListModel = self.videoArray[_section][_row];
        [self.mainVideoInfoView setUpViewWithModel:self.videoListModel section:self.section array:self.videoArray];
        scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    }
}

- (void)changeAnimationsWithView:(UIView *)detailsView
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
    [detailsView.layer addAnimation:animation forKey:@"a"];
}

#pragma mark----设置图片的点击方法
- (void)settingClick
{
    if (_videoListModel.highUrl)
    {
        NSURL *url = [NSURL URLWithString:_videoListModel.highUrl];
        JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
        [self presentViewController:playerVC animated:NO completion:nil];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:_videoListModel.normalUrl];
        JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
        [self presentViewController:playerVC animated:NO completion:nil];
    }
}

#pragma mark----收藏按钮
- (void)click:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected == YES)
    {
        //点击第一次时收藏成功
        self.mainVideoInfoView.clickPraiseLabel.text = [NSString stringWithFormat:@"%lu",_videoListModel.collectionCount + 1];
        [[NewsDataBase shareDataBase] insertNewsOfDBTable:@"myCollectionDB" WithModel:self.videoListModel];
        
        //添加一个弹窗. 显示是否成功
        alertView = [[UIAlertView alloc]initWithTitle:@"已收藏成功" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        //设置弹窗自动消失
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(view:) userInfo:nil repeats:NO];
        [alertView show];
    }else
    {
        //点击第二次时取消收藏
        self.mainVideoInfoView.clickPraiseLabel.text = [NSString stringWithFormat:@"%lu", _videoListModel.collectionCount];
        [[NewsDataBase shareDataBase] deleteNewsOfDBTable:@"myCollectionDB" ByNewsTitle:self.videoListModel.title];
    }
}

#pragma mark----设置时间弹窗自动消失
- (void)view:(NSTimer *)timer
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark----分享按钮
- (void)shareClick:(UIButton *)button
{
    NSURL *url = [NSURL URLWithString:_videoListModel.coverForSharing];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [UMSocialSnsService presentSnsIconSheetView:self
                appKey:@"55fd0ce3e0f55a305b002070"
                shareText:@"你要分享的文字"
                shareImage:[UIImage imageWithData:data]
                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban, nil]
                                       delegate:self];
    button.selected = !button.selected;
    if (button.selected == YES)
    {
        self.mainVideoInfoView.shareLabel.text = [NSString stringWithFormat:@"%lu", _videoListModel.shareCount + 1];
    }
    else
    {
        self.mainVideoInfoView.shareLabel.text = [NSString stringWithFormat:@"%lu",_videoListModel.shareCount];
    }
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
