//
//  ViewController.m
//  Example
//
//  Created by Jonathan Tribouharet
//

#import "ViewController.h"
#import "CustomerScrollerView.h"

@interface ViewController ()

@property(nonatomic,strong)UIView *containerView ;


@end

@implementation ViewController

#pragma mark- 画一个背景
-(void)createBackGround{
    
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor =[UIColor blueColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius =5.0;
    sublayer.shadowColor =[UIColor redColor].CGColor;
    sublayer.shadowOpacity =0.8;
    sublayer.frame = CGRectMake(30, 250, 128, 192);
    sublayer.borderColor =[UIColor blackColor].CGColor;
    sublayer.borderWidth =6.0;
    sublayer.cornerRadius =10.0;
    [self.view.layer addSublayer:sublayer];
    
    CALayer *imageLayer =[CALayer layer];
    imageLayer.frame = sublayer.bounds;
    imageLayer.cornerRadius =10.0;
    imageLayer.contents =(id)[UIImage imageNamed:@"img.png"].CGImage;
    imageLayer.masksToBounds =YES;
    [sublayer addSublayer:imageLayer];
    
    
    CIFilter *filter = [CIFilter filterWithName:@""] ;
}

#pragma mark- 画一个简单图形
-(void)createMan{

    //define path parameters
    CGRect rect = CGRectMake(50, 50, 100, 100);
    CGSize radii = CGSizeMake(25, 20);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    //create path
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 150)] ;
    [path addCurveToPoint:CGPointMake(250, 150) controlPoint1:CGPointMake(150, 0) controlPoint2:CGPointMake(200, 75)];

    
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:CGPointMake(175, 100)];
//    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
//    [path moveToPoint:CGPointMake(150, 125)];
//    [path addLineToPoint:CGPointMake(150, 175)];
//    [path addLineToPoint:CGPointMake(125, 225)];
//    [path moveToPoint:CGPointMake(150, 175)];
//    [path addLineToPoint:CGPointMake(175, 225)];
//    [path moveToPoint:CGPointMake(100, 150)];
//    [path addLineToPoint:CGPointMake(200, 150)];
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor greenColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinBevel;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.strokeStart = 0 ;
    shapeLayer.strokeEnd = 1 ;
    shapeLayer.path = path.CGPath;
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
}

#pragma mark-绘图

-(void)addArcWithPAth:(UIBezierPath*)path radius:(float)radius startAngel:(float)startangel{

    [path addArcWithCenter:CGPointMake(50, 50) radius:radius startAngle:startangel endAngle:startangel+M_PI/20 clockwise:YES];

}
-(void)pvt_reateFace{

    
    
    //开始图像绘图
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    //创建UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    //左眼
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)]];
    //右眼
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(80, 0, 20, 20)]];
    //笑
    [path moveToPoint:CGPointMake(100, 50)];
    //注意这里clockwise参数是YES而不是NO，因为这里不知Quartz，不需要考虑Y轴翻转的问题
    [path addArcWithCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:M_PI/20 clockwise:YES];
//    [path moveToPoint:CGPointMake(0, 50)];

    float startAngel = M_PI/20 ;

    for (int i=0; i<200; i++) {
        [self addArcWithPAth:path radius:(49.75-i*0.25) startAngel:startAngel];
        startAngel+=M_PI/20 ;
    }
    
//    [path addArcWithCenter:CGPointMake(50, 50) radius:49 startAngle:M_PI endAngle:2*M_PI clockwise:YES];
//    [path addClip];
    //使用applyTransform函数来转移坐标的Transform，这样我们不用按照实际显示做坐标计算
    [path applyTransform:CGAffineTransformMakeTranslation(50, 50)];
    //设置绘画属性
    [[UIColor blueColor] setStroke];
    [path setLineWidth:2];
    //执行绘画
    [path stroke];
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
    
    /*

    //开始图像绘图
    UIGraphicsBeginImageContext(self.view.bounds.size);
    //获取当前CGContextRef
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
    CGAffineTransform transform = CGAffineTransformMakeTranslation(150, 100);
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    //左眼
    CGPathAddEllipseInRect(path, &transform, CGRectMake(0, 0, 20, 20));
    //右眼
    CGPathAddEllipseInRect(path, &transform, CGRectMake(80, 0, 20, 20));
    //笑
    CGPathMoveToPoint(path, &transform, 100, 50);
    CGPathAddArc(path, &transform, 50, 50, 50, 0, M_PI, NO);
    //将CGMutablePathRef添加到当前Context内
    CGContextAddPath(gc, path);
    //设置绘图属性
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(gc, 2);
    //执行绘画
    CGContextStrokePath(gc);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
    */
    
    

}


#pragma mark- 绘制简单的文字
-(CATextLayer*)createTexts{
    
    
//    UIView *labelView= [[UIView alloc]initWithFrame:CGRectMake(20, 200, 280, 100) ];
//    labelView.backgroundColor = [UIColor greenColor ] ;
//    [self.view addSubview:labelView];

    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.frame = self.containerView.bounds;
    textLayer.frame = CGRectMake(0, 0, 320, 108);
    [self.containerView.layer addSublayer:textLayer];
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
    //set layer text
    textLayer.string = text;
    
    //contentScale属性，用来决定图层内容应该以怎样的分辨率来渲染。
    textLayer.contentsScale =  [UIScreen mainScreen].scale;
    
    return textLayer ;

}

#pragma mark- 创建粒子效果
-(void)createEmitter{


    //create particle emitter layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:emitter];
    //configure emitter
    emitter.renderMode = kCAEmitterLayerAdditive;//控制着在视觉上粒子图片是如何混合的
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);// 出现位置坐标
//    emitter.emitterSize = CGSizeMake(0, 0);//产生点的大小
    
    
    
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"star1.png"].CGImage;
    cell.birthRate = 150;//产生频率
    cell.lifetime = 5.0; //生命周期
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;//透明度每过一秒就是减少0.4
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;//属性的值是2π，这意味着例子可以从360度任意位置反射出来
    //add particle template to emitter
    emitter.emitterCells = @[cell];

}


#pragma mark- 创建3D图像

- (CALayer *)faceWithTransform:(CATransform3D)transform text:(NSString*)text{


    CATextLayer *textLayer = [CATextLayer layer];
    //    textLayer.frame = self.containerView.bounds;
    textLayer.frame = CGRectMake(-25, -25, 50, 50);
    //set text attributes
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    textLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter ;
    textLayer.wrapped = YES;
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:10];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    //choose some text
   
    //set layer text
    textLayer.string = text;
    
    //contentScale属性，用来决定图层内容应该以怎样的分辨率来渲染。
    textLayer.contentsScale =  [UIScreen mainScreen].scale;
    textLayer.transform = transform ;
    
    return textLayer ;

}

- (CALayer *)faceWithTransform:(CATransform3D)transform
{
    //create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-25, -25, 50, 50);
    //apply a random color
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    //apply the transform and return
    face.transform = transform;
    return face;
}
- (CALayer *)cubeWithTransform:(CATransform3D)transform
{
    //create cube layer
    CATransformLayer *cube = [CATransformLayer layer];
    //add cube face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 25);
    [cube addSublayer:[self faceWithTransform:ct text:@"1"]];
    //add cube face 2
    ct = CATransform3DMakeTranslation(25, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct text:@"2"]];
    //add cube face 3
    ct = CATransform3DMakeTranslation(0, -25, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct text:@"3"]];
    //add cube face 4
    ct = CATransform3DMakeTranslation(0, 25, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct text:@"4"]];
    //add cube face 5
    ct = CATransform3DMakeTranslation(-25, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct text:@"5"]];
    //add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -25);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct text:@"6"]];
    //center the cube layer within the container
    CGSize containerSize = self.containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    //apply the transform and return
    cube.transform = transform;
    return cube;
}


-(void)create3Dimg{
    
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
//    pt.m33 = -1.0/100.0 ;
//    pt.m31 = 0.75 ;
    
    self.containerView.layer.sublayerTransform = pt;
    //set up the transform for cube 1 and add it
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -50, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.containerView.layer addSublayer:cube1];
//    set up the transform for cube 2 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 50, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube2];

}


#pragma mark - 颜色渐变
-(void)createColorChange{

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:gradientLayer];
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor brownColor].CGColor,(__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
  
    //set locations
    gradientLayer.locations = @[@0.0,@0.25,@0.5,@0.75] ;
    
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);

}

#pragma mark- 用CAReplicatorLayer重复图层
-(void)createRepeatImage{
 
    //create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:replicator];
    //configure the replicator
    replicator.instanceCount = 10;
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 25, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -12.5, 0);
    replicator.instanceTransform = transform;
    //apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    //create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(25.0f, 25.0f, 25.0f, 25.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];

}

#pragma mark- 绘制路径

-(void)createPath{

    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.view.layer.position.x, self.view.layer.position.y);//移动到起始点
    CGPathAddCurveToPoint(path, NULL, 20, 320, 300, 390, 160, 450);//绘制二次贝塞尔曲线
    
    
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    
    
    //draw the path using a CAShapeLayer
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    
    pathLayer.path = path ;//设置path属性
    CGPathRelease(path) ;//释放路径对象
//    pathLayer.path = bezierPath.CGPath;
    
    
    
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
}


#pragma mark- 滤镜
-(void)pvt_testFilterAnimation{
    
    UIImageView * view2 = [[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 80, 80)];
    view2.image  =[UIImage  imageNamed:@"img"] ;
    view2.backgroundColor = [UIColor orangeColor] ;
    [self.view addSubview:view2];
    
    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 80, 80)];
    view.image  =[UIImage  imageNamed:@"img"] ;
    view.backgroundColor = [UIColor orangeColor] ;
    [self.view addSubview:view];
    
    
    CALayer *selectionLayer = view.layer ;
    [CATransaction setValue:@"2.2" forKey:kCATransactionAnimationDuration] ;
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
    
    // name the filter so we can use the keypath to animate the inputIntensity
    
    // attribute of the filter
    
    
//    [filter setValue:@"pulseFilter" forKeyPath:@"name"];
//    [filter setName:@"pulseFilter"];
    
    
    // set the filter to the selection layer's filters
    
    [selectionLayer setFilters:[NSArray arrayWithObject:filter]];
    

    // create the animation that will handle the pulsing.
    
    CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
    
    pulseAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
    
    pulseAnimation.toValue = [NSNumber numberWithFloat: 5.5];
    pulseAnimation.duration = 1.0;
    
    pulseAnimation.repeatCount = HUGE_VALF;
    
    
    // we want it to fade on, and fade off, so it needs to
    
    // automatically autoreverse.. this causes the intensity
    
    // input to go from 0 to 1 to 0
    
    pulseAnimation.autoreverses = YES;
    
    
    // use a timing curve of easy in, easy out..
    
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    
    
    // add the animation to the selection layer. This causes
    
    // it to begin animating. We'll use pulseAnimation as the
    
    // animation key name
    [selectionLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor] ;
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(120, 280, 100, 100)];
    self.containerView.backgroundColor = [UIColor grayColor] ;
    [self.view addSubview:self.containerView];


    self.animatedView.textColor = [UIColor whiteColor];
    self.animatedView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    
    self.animatedView.minLength = 3;
    
    [self createBackGround];
//    [self createMan];
//    [self createTexts];
//    
//    
//    [self createEmitter];
//    [self create3Dimg];
//    
//    [self createColorChange];
    
//    [self createRepeatImage];
//    
//    [self pvt_reateFace];
//    
//    CustomerScrollerView * cusView = [[CustomerScrollerView alloc]initWithFrame:CGRectMake(20, 300, 100, 100)];
//    cusView.backgroundColor = [UIColor greenColor] ;
//    [cusView.layer addSublayer:[self createTexts]] ;
//    [self.view addSubview:cusView];
//    
//    
//    [self createPath];
//    
//    [self pvt_testFilterAnimation] ;
//    
    
}

- (IBAction)didStartAnimationTouch:(id)sender
{
    [self.animatedView setValue:[NSNumber numberWithInt:(rand() % 5000)]];
    [self.animatedView startAnimation];
    
    
   
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
