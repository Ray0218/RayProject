////
////  NSOperation实现多线程
////  MultiThread
////
////  Created by Kenshin Cui on 14-3-22.
////  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
////
//
//#import "KCMainViewController.h"
//
//@interface KCMainViewController (){
//    UIImageView *_imageView;
//}
//
//@end
//
//@implementation KCMainViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self layoutUI];
//}
//
//#pragma mark 界面布局
//-(void)layoutUI{
//    _imageView =[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
//    _imageView.contentMode=UIViewContentModeScaleAspectFit;
//    [self.view addSubview:_imageView];
//    
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame=CGRectMake(50, 500, 220, 25);
//    [button setTitle:@"加载图片" forState:UIControlStateNormal];
//    //添加方法
//    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}
//
//#pragma mark 将图片显示到界面
//-(void)updateImage:(NSData *)imageData{
//    UIImage *image=[UIImage imageWithData:imageData];
//    _imageView.image=image;
//}
//
//#pragma mark 请求图片数据
//-(NSData *)requestData{
//    //对于多线程操作建议把线程操作放到@autoreleasepool中
//    @autoreleasepool {
//        NSURL *url=[NSURL URLWithString:@"http://images.apple.com/iphone-6/overview/images/biggest_right_large.png"];
//        NSData *data=[NSData dataWithContentsOfURL:url];
//        return data;
//    }
//}
//
//#pragma mark 加载图片
//-(void)loadImage{
//    //请求数据
//    NSData *data= [self requestData];
//
//    //更新UI
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
//}
//
//#pragma mark 多线程下载图片
//-(void)loadImageWithMultiThread{
//    /*创建一个调用操作
//     object:调用方法参数
//    */
//    NSInvocationOperation *invocationOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
//    //创建完NSInvocationOperation对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作,而是添加到NSOperationQueue中
////    [invocationOperation start];
//    
//    //创建操作队列
//    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
//    //注意添加到操作队后，队列会开启一个线程执行此操作
//    [operationQueue addOperation:invocationOperation];
//}
//@end
