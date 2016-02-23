//
//  ParabolaViewController.m
//  Parabola
//
//  Created by danfort on 14-2-20.
//  Copyright (c) 2014年 danfort. All rights reserved.
//

#import "ParabolaViewController.h"

#define kCoinCountKey   300     //金币总数
@interface ParabolaViewController ()
{
    UIImageView * _imgView ;
}
@end

@implementation ParabolaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


static int cointCount = 0 ;

-(void)pvt_createIcons{
    
    
    UIImageView * img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_coin_2"]] ;
    img2.frame = CGRectMake(200, 80, 40, 40) ;
    [self.view addSubview:img2];
    
    
    for (int i=0; i<50; i++) {
        [self performSelector:@selector(createCoint:) withObject:[NSNumber numberWithInt:i] afterDelay:i*0.01];
    }
    

//    UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_coin_2"]] ;
//    img.frame = CGRectMake(20, 300, 40, 40) ;
//    [self.view addSubview:img];
//    
//    
//    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"transform"] ;
//    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2*0.8, 1, 0, 0)] ;
//    anim.fillMode = kCAFillModeForwards ;
//    anim.removedOnCompletion = NO ;
//    [img.layer addAnimation:anim forKey:nil];
    
}

-(void)createCoint:(NSNumber*)i{
    
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_coin_2"]] ;
    img.frame = CGRectMake(arc4random()%40, 300, 40, 40);
    img.center = CGPointMake(arc4random()%40, 300) ;
    img.tag = [i intValue]+1 ;
    _imgView = nil ;
    _imgView = img ;
    [_coinTagsArr addObject:[NSNumber numberWithInt:img.tag]];
    [self.view addSubview:img];
    
    [self addAnimationWithLayer:img] ;

}
-(void)addAnimationWithLayer:(UIView*)img{

    CGFloat duration = 0.6f ;
    
    

    
//    //出现效果
//    //关键帧动画
    CAKeyframeAnimation *opAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    opAnim.duration = 0.2;
    opAnim.values =[NSArray arrayWithObjects:
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:1.0],
                    nil];
    opAnim.keyTimes = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:0.1],
                       [NSNumber numberWithFloat:0.2], nil];
    
    [img.layer addAnimation:opAnim forKey:@"animateOpacity"];

    
    
   
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(20, 300-40*img.tag);
    CABasicAnimation *moveAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    //    moveAnim.duration = duration-0.2;
    moveAnim.fillMode = kCAFillModeForwards ;
    moveAnim.removedOnCompletion = NO;//代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards .
    moveAnim.toValue= [NSValue valueWithCATransform3D:
                       CATransform3DMakeAffineTransform(moveTransform)];
    [moveAnim setValue:[NSValue valueWithCATransform3D:
                        CATransform3DMakeAffineTransform(moveTransform)] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
//    [img.layer addAnimation:moveAnim forKey:@"animateTransform"];
    
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"transform"] ;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2*0.8, 1, 0, 0)] ;
    anim.fillMode = kCAFillModeForwards ;
    anim.removedOnCompletion = NO ;
    [anim  setValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2*0.8, 1, 0, 0)] forKey:@"KCBasicAnimationProperty_ToValue"];
//    [img.layer addAnimation:anim forKey:@"animateOpacity"];
    


    //动画组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    group.delegate = self;
    group.duration = 0.6;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[moveAnim,anim];
    
    [img.layer addAnimation:group forKey:@"position and transform"];

}

//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    
//    CAAnimationGroup *group = (CAAnimationGroup*)anim ;
//    CABasicAnimation *basicAni = group.animations[1] ;
//    CAKeyframeAnimation * keyAni =group.animations[0] ;
//    
//    CGPoint endPoint = [[keyAni valueForKey:@"KCKeyframeAnimationProperty_EndPosition"]CGPointValue] ;
//    
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    _imgView.layer.position = endPoint ;
//    
//    [CATransaction commit];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"红包福利";
    
    
    
    [self pvt_createIcons];
    
    _coinTagsArr = [NSMutableArray new];
    
    //主福袋层
    _bagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hongbao_bags"]];
    _bagView.center = CGPointMake(CGRectGetMidX(self.view.frame) + 10, CGRectGetMidY(self.view.frame) - 20);
    
    _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getBtn setTitle:@"立即打开" forState:UIControlStateNormal];
    [_getBtn setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    [_getBtn setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2]];
    [_getBtn setFrame:CGRectMake(90, self.view.frame.size.height - 100, 137, 25)];
    [_getBtn addTarget:self action:@selector(getCoinAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bagView];
    [self.view addSubview:_getBtn];
}

//统计金币数量的变量
static int coinCount = 0;
- (void)getCoinAction:(UIButton *)btn
{
    
    
    [self pvt_createIcons];
    return ;
    //"立即打开"按钮从视图上移除
    [btn removeFromSuperview];
    
    //初始化金币生成的数量
    coinCount = 0;
    for (int i = 0; i<kCoinCountKey; i++) {
        
        //延迟调用函数
        [self performSelector:@selector(initCoinViewWithInt:) withObject:[NSNumber numberWithInt:i] afterDelay:i * 0.01];
    }
}

- (void)initCoinViewWithInt:(NSNumber *)i
{
    UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_coin_%d",[i intValue] % 2 + 1]]];
    
    //初始化金币的最终位置
    coin.center = CGPointMake(CGRectGetMidX(self.view.frame) + arc4random()%40 * (arc4random() %3 - 1) - 20, CGRectGetMidY(self.view.frame) - 20);
    coin.tag = [i intValue] + 1;
    //每生产一个金币,就把该金币对应的tag加入到数组中,用于判断当金币结束动画时和福袋交换层次关系,并从视图上移除
    [_coinTagsArr addObject:[NSNumber numberWithInt:coin.tag]];
    
    [self.view addSubview:coin];
    
    [self setAnimationWithLayer:coin];
}

- (void)setAnimationWithLayer:(UIView *)coin
{
    CGFloat duration = 1.6f;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //绘制从底部到福袋口之间的抛物线
    CGFloat positionX   = coin.layer.position.x;    //终点x
    CGFloat positionY   = coin.layer.position.y;    //终点y
    CGMutablePathRef path = CGPathCreateMutable();
    int fromX       = arc4random() % 320;     //起始位置:x轴上随机生成一个位置
    int height      = [UIScreen mainScreen].bounds.size.height + coin.frame.size.height; //y轴以屏幕高度为准
    int fromY       = arc4random() % (int)positionY; //起始位置:生成位于福袋上方的随机一个y坐标
    
    CGFloat cpx = positionX + (fromX - positionX)/2;    //x控制点
    CGFloat cpy = fromY / 2 - positionY;                //y控制点,确保抛向的最大高度在屏幕内,并且在福袋上方(负数)
    
    //动画的起始位置
    CGPathMoveToPoint(path, NULL, fromX, height);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, positionX, positionY);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    CFRelease(path);
    path = nil;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //图像由大到小的变化动画
    CGFloat from3DScale = 1 + arc4random() % 10 *0.1;
    CGFloat to3DScale = from3DScale * 0.5;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //动画组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[scaleAnimation, animation];

    [coin.layer addAnimation:group forKey:@"position and transform"];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        //动画完成后把金币和数组对应位置上的tag移除
        UIView *coinView = (UIView *)[self.view viewWithTag:[[_coinTagsArr firstObject] intValue]];
        
        [coinView removeFromSuperview];
        [_coinTagsArr removeObjectAtIndex:0];
        
        //全部金币完成动画后执行的动作
        if (++coinCount == kCoinCountKey) {
            
            [self bagShakeAnimation];
            
            if (_getBtn) {
                
                [self.view addSubview:_getBtn];
                [_getBtn setTitle:@"再来一次" forState:UIControlStateNormal];
            }
        }
    }
}

//福袋晃动动画
- (void)bagShakeAnimation
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:- 0.4];
    shake.toValue   = [NSNumber numberWithFloat:+ 0.4];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
     
    [_bagView.layer addAnimation:shake forKey:@"bagShakeAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
