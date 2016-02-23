//
//  NSObject封装
//  MultiThread
//
//  Created by Kenshin Cui on 14-3-22.
//  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
//

#import "KCMainViewController.h"
#import "KCImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
#define IMAGE_COUNT 9

@interface KCMainViewController (){
    NSMutableArray *_imageViews;
}

@end

@implementation KCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

#pragma mark 界面布局
-(void)layoutUI{
    //创建多个图片空间用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    for (int i=0; i<IMAGE_COUNT; i++) {
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",i]];
    }
}

#pragma mark 将图片显示到界面
-(void)updateImageWithData:(KCImageData *)data{
    UIImage *image=[UIImage imageWithData:data.data];
    UIImageView *imageView= _imageViews[data.index];
    imageView.image=image;
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
    NSData *data;
    NSString *name;
    NSLog(@"%@",[NSThread currentThread]);
    @synchronized(self){
        if (_imageNames.count>0) {
            name=[_imageNames lastObject];
    //        [NSThread sleepForTimeInterval:0.001f];
            [_imageNames removeObject:name];
        }
        if(name){
            NSURL *url=[NSURL URLWithString:name];
            data=[NSData dataWithContentsOfURL:url];
        }
    }
    
    return data;
}

#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i=[index integerValue];
    //请求数据
    NSData *data= [self requestData:i];
    
    KCImageData *imageData=[[KCImageData alloc]init];
    imageData.index=i;
    imageData.data=data;
    //更新UI界面,此处调用了GCD主线程队列的方法
    [self performSelectorOnMainThread:@selector(updateImageWithData:) withObject:imageData waitUntilDone:YES];
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    int count=ROW_COUNT*COLUMN_COUNT;
    NSConditionLock *a;
    for (int i=0; i<count; ++i) {
        [self performSelectorInBackground:@selector(loadImage:) withObject:[NSNumber numberWithInt:i]];
    }
}

@end
