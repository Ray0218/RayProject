////
////  NSThread实现多线程
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
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/e2eb61a8c8a36abcf4ee6ea343a97811?fid=2637405421-250528-427976146823627&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-KgHau8gce7333G2VGI5iqlEaCyM%3D&rt=sh&expires=2h&r=648035830&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/de7e3817061146590684acc35981ed99?fid=2637405421-250528-457200000198194&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-PS%2Bw%2FsF4ohjshn9ZvcdWtJvNU9M%3D&rt=sh&expires=2h&r=553862312&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/cd435950f7f2ca3c99e842557d423004?fid=2637405421-250528-499114072296878&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-IpHh82SBIhSYECc0hs%2F1DUs9uWc%3D&rt=sh&expires=2h&r=633040698&sharesign=unknown&size=c140_u90&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/98c6f715496492d7482cecee2093bebf?fid=2637405421-250528-744557588153728&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-dmWYd8f2xlG82m9u9Vnio0zhFmg%3D&rt=sh&expires=2h&r=899973685&sharesign=unknown&size=c140_u90&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/fe744451b0d07a21671b488744acffea?fid=2637405421-250528-1041183547028500&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-fhxDWeN%2FeptZDmn79goIy0cNebA%3D&rt=sh&expires=2h&r=234434598&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/178167b69632108de56f0486041a938a?fid=2637405421-250528-792617735312884&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-0zusym3m1s%2F96SUCovQc9GLbVuw%3D&rt=sh&expires=2h&r=254417577&sharesign=unknown&size=c140_u90&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/915fac2807aefe74fe3b4003b0d499cd?fid=2637405421-250528-1125022926582204&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-wStMmYTURr%2BjsK3%2FA31IoamU5%2Fk%3D&rt=sh&expires=2h&r=498463290&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/28816ef2149269e6bab314458e187112?fid=2637405421-250528-358909248400619&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-Pd3Rs7l%2FBaWC8BWTnznLsJFQmvs%3D&rt=sh&expires=2h&r=295466179&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/445b8f6f0b387f6f744f33ad5b531b17?fid=2637405421-250528-849921016634467&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-VAyQgqoFkr6N3Ywoat4%2BCAaifAA%3D&rt=sh&expires=2h&r=478105469&sharesign=unknown&size=c140_u90&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/d4657836506fcbffdfcc3a05bf0ec861?fid=2637405421-250528-1070193473554196&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-Q5qdev0C6EsIQ0PJb4SJNekjQIc%3D&rt=sh&expires=2h&r=804915423&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/98bc0733c5836576e0538109d7b609f9?fid=2637405421-250528-527727066451971&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-PBtixf9wJXBYZGSS2htgpkvelkk%3D&rt=sh&expires=2h&r=466585918&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/d64301d47ce222ed2d16bd4e3cefe463?fid=2637405421-250528-729533307672651&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-te6OyYRBoO7oGzwbMeWi%2B7p26aQ%3D&rt=sh&expires=2h&r=461544495&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/6427b55749c5a0d8211fc7f39161f7d5?fid=2637405421-250528-713254084806501&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-wh2gZUZGeweqxkPdO%2B50zJAOHd0%3D&rt=sh&expires=2h&r=544541612&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/a3f163aa69cca84e28d31bba867c7aed?fid=2637405421-250528-312934263180853&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-G9gauzatmNyS6vIKLpsWbhbKKlQ%3D&rt=sh&expires=2h&r=887072095&sharesign=unknown&size=c850_u580&quality=100"];
//    [_imageNames addObject:@"http://d.pcs.baidu.com/thumbnail/b996e8b77a63b08f7c5494e440cc04c3?fid=2637405421-250528-612197976068180&time=1411005600&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-0RFQmmiiNZc1VPBJMjHQkjmxOtc%3D&rt=sh&expires=2h&r=644346323&sharesign=unknown&size=c140_u90&quality=100"];
//    
//}
//
//#pragma mark 将图片显示到界面
//-(void)updateImage:(KCImageData *)imageData{
//    UIImage *image=[UIImage imageWithData:imageData.data];
//    UIImageView *imageView= _imageViews[imageData.index];
//    imageView.image=image;
//}
//
//#pragma mark 请求图片数据
//-(NSData *)requestData:(int )index{
//    //对于多线程操作建议把线程操作放到@autoreleasepool中
//    @autoreleasepool {
//        NSURL *url=[NSURL URLWithString:_imageNames[index]];
//        NSData *data=[NSData dataWithContentsOfURL:url];
//
//        return data;
//    }
//}
//
//#pragma mark 加载图片
//-(void)loadImage:(NSNumber *)index{
//    //线程休眠2秒
////    [NSThread sleepForTimeInterval:2.0];
//
//    //    NSLog(@"%i",i);
//    //currentThread方法可以取得当前操作线程
////    NSLog(@"current thread:%@",[NSThread currentThread]);
//
//    int i=[index integerValue];
//
//    NSLog(@"%i",i);//未必按顺序输出
//
//    NSData *data= [self requestData:i];
//
//    KCImageData *imageData=[[KCImageData alloc]init];
//    imageData.index=i;
//    imageData.data=data;
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
//}
//
//#pragma mark 多线程下载图片
//-(void)loadImageWithMultiThread{
//    int count=ROW_COUNT*COLUMN_COUNT;
//    //创建多个线程用于填充图片
//    for (int i=0; i<count; ++i) {
//        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
//        thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
//        [thread start];
//    }
//}
//@end
