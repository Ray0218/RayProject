//
//  NSThread实现多线程
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

@interface KCMainViewController (){
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
    NSMutableArray *_threads;
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
//            imageView.backgroundColor=[UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];

        }
    }

    //加载按钮
    UIButton *buttonStart=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame=CGRectMake(50, 500, 100, 25);
    [buttonStart setTitle:@"加载图片" forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStart];
    
    //停止按钮
    UIButton *buttonStop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStop.frame=CGRectMake(160, 500, 100, 25);
    [buttonStop setTitle:@"停止加载" forState:UIControlStateNormal];
    [buttonStop addTarget:self action:@selector(stopLoadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStop];
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/e2eb61a8c8a36abcf4ee6ea343a97811?fid=2637405421-250528-427976146823627&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-4rsm4fkKSIZ03MDf09QlBxfdB5o%3D&rt=sh&expires=2h&r=926397348&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/de7e3817061146590684acc35981ed99?fid=2637405421-250528-457200000198194&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-S3hvNK3flVKpRH356C4JaOHQ%2ByY%3D&rt=sh&expires=2h&r=371152628&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/cd435950f7f2ca3c99e842557d423004?fid=2637405421-250528-499114072296878&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-2%2F3DrEr%2Fw0n1XWgd1SVa15vfq7Y%3D&rt=sh&expires=2h&r=985890307&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/98c6f715496492d7482cecee2093bebf?fid=2637405421-250528-744557588153728&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-ed3qPerMdGTtMvmxb%2Festf0Ib44%3D&rt=sh&expires=2h&r=911553653&sharesign=unknown&size=c850_u580&quality=100"];
    
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/fe744451b0d07a21671b488744acffea?fid=2637405421-250528-1041183547028500&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-5Ie%2FkpAMrzF0Vet2kS9KhkICXcI%3D&rt=sh&expires=2h&r=296057714&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/178167b69632108de56f0486041a938a?fid=2637405421-250528-792617735312884&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-eTZxP%2BKcR3wmS36HOWGnAr1681s%3D&rt=sh&expires=2h&r=661097853&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/915fac2807aefe74fe3b4003b0d499cd?fid=2637405421-250528-1125022926582204&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-sHZUoqtIF%2BhlGeN0FwUBWJeBBas%3D&rt=sh&expires=2h&r=552734380&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/28816ef2149269e6bab314458e187112?fid=2637405421-250528-358909248400619&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-9nkVP6ZLJvtmfQa9GDCaDTL9kjY%3D&rt=sh&expires=2h&r=452851199&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/445b8f6f0b387f6f744f33ad5b531b17?fid=2637405421-250528-849921016634467&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-6PfyIqn8WwaaPwSi6IMz6%2F39M4g%3D&rt=sh&expires=2h&r=857801273&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/d4657836506fcbffdfcc3a05bf0ec861?fid=2637405421-250528-1070193473554196&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-yzFMKAxPdY8OpoykVDau9EMR9hM%3D&rt=sh&expires=2h&r=573796882&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/98bc0733c5836576e0538109d7b609f9?fid=2637405421-250528-527727066451971&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-K2BFaXsdmwCQhc5gq1Biwp%2BTAoM%3D&rt=sh&expires=2h&r=257829657&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/d64301d47ce222ed2d16bd4e3cefe463?fid=2637405421-250528-729533307672651&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-0VtOWae8%2FOQXzGfPtZHwI5F%2FZGc%3D&rt=sh&expires=2h&r=805424361&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/6427b55749c5a0d8211fc7f39161f7d5?fid=2637405421-250528-713254084806501&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-Sdsq2pgWnuwXjw%2FpcCGhBJ%2F4mso%3D&rt=sh&expires=2h&r=120178831&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/a3f163aa69cca84e28d31bba867c7aed?fid=2637405421-250528-312934263180853&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-tdHYL4WD1X1Si5ny0q59ue5OsEo%3D&rt=sh&expires=2h&r=452370773&sharesign=unknown&size=c850_u580&quality=100"];
    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/b996e8b77a63b08f7c5494e440cc04c3?fid=2637405421-250528-612197976068180&time=1411023600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-NgHV3uVfaMRrnyStazlT5Alvm3s%3D&rt=sh&expires=2h&r=428875771&sharesign=unknown&size=c850_u580&quality=100"];
    
}

#pragma mark 将图片显示到界面
-(void)updateImage:(KCImageData *)imageData{
    UIImage *image=[UIImage imageWithData:imageData.data];
    UIImageView *imageView= _imageViews[imageData.index];
    imageView.image=image;
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
    //对于多线程操作建议把线程操作放到@autoreleasepool中
    @autoreleasepool {
        NSURL *url=[NSURL URLWithString:_imageNames[index]];
        NSData *data=[NSData dataWithContentsOfURL:url];

        return data;
    }
}

#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i=[index integerValue];

    NSData *data= [self requestData:i];

    
    NSThread *currentThread=[NSThread currentThread];
    
//    如果当前线程处于取消状态，则退出当前线程
    if (currentThread.isCancelled) {
        NSLog(@"thread(%@) will be cancelled!",currentThread);
        [NSThread exit];//取消当前线程
    }
    
    KCImageData *imageData=[[KCImageData alloc]init];
    imageData.index=i;
    imageData.data=data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    int count=ROW_COUNT*COLUMN_COUNT;
    _threads=[NSMutableArray arrayWithCapacity:count];
    
    //创建多个线程用于填充图片
    for (int i=0; i<count; ++i) {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        [_threads addObject:thread];
    }
    //循环启动线程
    for (int i=0; i<count; ++i) {
        NSThread *thread= _threads[i];
        [thread start];
    }
}

#pragma mark 停止加载图片
-(void)stopLoadImage{
    for (int i=0; i<ROW_COUNT*COLUMN_COUNT; i++) {
        NSThread *thread= _threads[i];
        //判断线程是否完成，如果没有完成则设置为取消状态
        //注意设置为取消状态仅仅是改变了线程状态而言，并不能终止线程
        if (!thread.isFinished) {
            [thread cancel];
            
        }
    }
}
@end
