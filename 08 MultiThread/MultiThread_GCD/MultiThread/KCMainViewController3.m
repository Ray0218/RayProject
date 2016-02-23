////
////  GCD实现多线程--其他常用方法
////  MultiThread
////
////  Created by Kenshin Cui on 14-3-22.
////  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
////
//
//#import "KCMainViewController.h"
//#import "KCImageData.h"
//#define ROW_COUNT 5
//#define COLUMN_COUNT 3
//#define ROW_HEIGHT 100
//#define ROW_WIDTH ROW_HEIGHT
//#define CELL_SPACING 10
//
//@interface KCMainViewController (){
//    NSMutableArray *_imageViews;
//    NSMutableArray *_imageNames;
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
//    //创建多个图片空间用于显示图片
//    _imageViews=[NSMutableArray array];
//    for (int r=0; r<ROW_COUNT; r++) {
//        for (int c=0; c<COLUMN_COUNT; c++) {
//            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
//            imageView.contentMode=UIViewContentModeScaleAspectFit;
////            imageView.backgroundColor=[UIColor redColor];
//            [self.view addSubview:imageView];
//            [_imageViews addObject:imageView];
//
//        }
//    }
//
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame=CGRectMake(50, 500, 220, 25);
//    [button setTitle:@"加载图片" forState:UIControlStateNormal];
//    //添加方法
//    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    //创建图片链接
//    _imageNames=[NSMutableArray array];
//    for (int i=0; i<ROW_COUNT*COLUMN_COUNT; i++) {
//        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",i]];
//    }
//}
//
//#pragma mark 将图片显示到界面
//-(void)updateImageWithData:(NSData *)data andIndex:(int )index{
//    UIImage *image=[UIImage imageWithData:data];
//    UIImageView *imageView= _imageViews[index];
//    imageView.image=image;
//}
//
//#pragma mark 请求图片数据
//-(NSData *)requestData:(int )index{
//    NSURL *url=[NSURL URLWithString:_imageNames[index]];
//    NSData *data=[NSData dataWithContentsOfURL:url];
//
//    return data;
//}
//
//#pragma mark 加载图片
//-(void)loadImage:(NSNumber *)index{
//    
//    //如果在串行队列中会发现当前线程的变化完全一样，因为他们在一个线程中
//    NSLog(@"thread is :%@",[NSThread currentThread]);
//    
//    int i=[index integerValue];
//    //请求数据
//    NSData *data= [self requestData:i];
//    //更新UI界面,此处调用了GCD主线程队列的方法
//    dispatch_queue_t mainQueue= dispatch_get_main_queue();
//    dispatch_sync(mainQueue, ^{
//        [self updateImageWithData:data andIndex:i];
//    });
//}
//
//#pragma mark 多线程下载图片
//-(void)loadImageWithMultiThread{
//    int count=ROW_COUNT*COLUMN_COUNT;
////    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    //这里创建一个并发队列（使用全局并发队列也可以）
//    dispatch_queue_t queue=dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_barrier_async(queue, ^{
//        [self loadImage:[NSNumber numberWithInt:(count-1)]];
//    });
//    
//    for (int i=0; i<count-1; i++) {
//        dispatch_async(queue, ^{
//            [self loadImage:[NSNumber numberWithInt:i]];
//        });
//    }
//}
//
//
////#pragma mark 多线程下载图片
////-(void)loadImageWithMultiThread{
////    int count=ROW_COUNT*COLUMN_COUNT;
//////    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
////    
////    //这里创建一个并发队列（使用全局并发队列也可以）
////    dispatch_queue_t queue=dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
////    dispatch_apply(count, queue, ^(size_t i) {
////        dispatch_async(queue, ^{
////            [self loadImage:[NSNumber numberWithInt:i]];
////        });
////    });
////    
////    
////}
//
////#pragma mark 多线程下载图片
////-(void)loadImageWithMultiThread{
////    int count=ROW_COUNT*COLUMN_COUNT;
////    
////    /*取得全局队列
////     第一个参数：线程优先级
////     第二个参数：标记参数，目前没有用，一般传入0
////    */
////    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
////    //创建多个线程用于填充图片
////    for (int i=0; i<count; ++i) {
////        //异步执行队列任务
////        dispatch_async(globalQueue, ^{
////            [self loadImage:[NSNumber numberWithInt:i]];
////        });
//////        dispatch_sync(globalQueue, ^{
//////            [self loadImage:[NSNumber numberWithInt:i]];
//////        });
////    }
////    
////}
//@end
