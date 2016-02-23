//
//  RubberBandView.m
//  RubberBandView
//
//  Created by JianYe on 14-7-1.
//  Copyright (c) 2014年 XiaoZi. All rights reserved.
//

#import "RubberBandView.h"
#import <QuartzCore/QuartzCore.h>

static CFTimeInterval defaultDuration = 0.3;

//加速度
static float acceleration(float time,float space) {
    return space*2/(time*time);
}

@interface RubberBandView () {
    CFTimeInterval _beginTime;
    CFTimeInterval _animationRegisteredTime;
    CADisplayLink *_link;
    RubberBandProperty _currentProperty;
    RubberBandProperty _beginProperty;
    
    BOOL  isHorizontal;
}
@property (nonatomic,strong)CAShapeLayer *drawLayer;
@end

@implementation RubberBandView

- (void)dealloc {
    if (_link) [_link invalidate];
}

#pragma mark -
#pragma mark init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _init];
}

- (id)initWithFrame:(CGRect)frame layerProperty:(RubberBandProperty)property {
    if (self = [super initWithFrame:frame]) {
        [self _init];
        self.property = property;
    }
    return self;
}

- (void)_init {
    self.drawLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_drawLayer];
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeUpdate:)];
    _link.paused = YES;
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark -
#pragma mark attributes
- (void)setProperty:(RubberBandProperty)property {
    _property = property;    
    [self resetDefault];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    if (_drawLayer) _drawLayer.fillColor = fillColor.CGColor;
    [self resetDefault];
}


- (void)resetDefault {
    _beginProperty = CopyRBProperty(_property);
    UIBezierPath *path = [self pullPathWithOffset:0 toOut:YES];
    [self redrawWithPath:path.CGPath];
}


#pragma mark -
#pragma mark action

- (void)pullWithOffSet:(CGFloat)offSet {
    UIBezierPath *path = [self pullPathWithOffset:offSet toOut:YES];
    [self redrawWithPath:path.CGPath];
}

- (void)recoverStateAnimation {
    _beginProperty = CopyRBProperty(_currentProperty);
    if (_duration == 0) _duration = defaultDuration;
    _beginTime = 0;
    _animationRegisteredTime = [_drawLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    if (_link) _link.paused = NO;
}

#pragma mark -
#pragma mark path
- (UIBezierPath *)pullPathWithOffset:(CGFloat)currentOffset toOut:(BOOL)toOut{
    if (_beginProperty.width<=0||_beginProperty.height<=0) return nil;
    CGFloat width,orignX;
    if (toOut) {
        width = _beginProperty.width + fabs(currentOffset);
        orignX = _beginProperty.x + ((currentOffset<0)?currentOffset:0);
    }else {
        width = _property.width + currentOffset;
        orignX = _beginProperty.x;
    }
    CGFloat height = _beginProperty.height * fabs(_beginProperty.width/width);
    CGFloat orignY = _beginProperty.y + (_beginProperty.height - height);
    CGFloat radius = height/2;
    _currentProperty = MakeRBProperty(orignX, orignY, width, height, _beginProperty.maxOffSet);
    UIBezierPath *path;
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(orignX, orignY, width, height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    return path;
}

- (UIBezierPath *)bounceInPathWithOffset:(CGFloat)currentOffset {
    if (_beginProperty.width<=0||_beginProperty.height<=0||
        _property.width<=0||_property.height<=0) return nil;
    CGFloat width = _beginProperty.width - currentOffset;
    CGFloat x = fabs(_property.width/width);
    if (x>1.5) x = 1.2;
    CGFloat height = _property.height * x;
    CGFloat orignX = _beginProperty.x + currentOffset;
    CGFloat orignY = _property.y + (_property.height - height);
    CGFloat radius = height/2;
    _currentProperty = MakeRBProperty(orignX, orignY, width, height, _property.maxOffSet);
    CGRect rect = CGRectMake(orignX, orignY, width, height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    return path;
}

#pragma mark -
#pragma mark animation
- (void)render {
    CFTimeInterval time = [_drawLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    if (time - _animationRegisteredTime < _beginTime)return;
    float runtime = time - _beginTime - _animationRegisteredTime;
    
    if (runtime >= _duration) {
        _link.paused = YES;
        [self animationStop];
        return;
    }
    
    if (_startAction) _startAction();
    
    CGPathRef path;
    
    float partTime1 = _duration/2;
    float partTime2 = (_duration - partTime1)/2;
    float partTime3 = (_duration - partTime1 - partTime2);
    
    float partSpace1 = 0 , partSpace2 = 0 , partSpace3 = 0, partOrign = 0;
    float offSet = (_beginProperty.width - _property.width);//拉伸距离
    float offOrign = _beginProperty.x - _property.x;
    float x = offSet/_property.width;//内缩倍数
    if (x>1) x = 1;
    float inset = x * (_property.width/2);//对比正常内缩距离,系数 * 正常宽度的一半

    if ((offSet >= _property.maxOffSet && offOrign >= 0) ||
        (offSet < _property.maxOffSet && offOrign < 0)) {
        partSpace1 = _beginProperty.width - (_property.width - inset);//总回弹距离
        partSpace2 =  inset + x*(_property.width/3);//第二次弹出距离
        partSpace3 = x*(_property.width/3);//回到正常的距离
        partOrign = (_beginProperty.width - _property.width - partSpace3);

        if(runtime<=partTime1)//拉倒极限后反弹
        {
            float time = runtime;
            float a = acceleration(partTime1,partSpace1);
            float space = a*time*time/2;
            path = [self bounceInPathWithOffset:space].CGPath;
        }else if(runtime <= partTime1+partTime2)
        {
            float time = runtime-partTime1;
            float a = acceleration(partTime2,partSpace2);
            float space = a*time*time/2;
            path = [self bounceInPathWithOffset:partSpace1 - space].CGPath;
        }else
        {
            float time = runtime-partTime1-partTime2;
            float a = acceleration(partTime3,partSpace3);
            float space = a*time*time/2;
            path = [self bounceInPathWithOffset:partOrign + space].CGPath;
        }
    }else
    {
        partSpace1 = _beginProperty.width - _property.width + inset;//总回弹距离
        partSpace2 = inset + x*(_property.width/3);//第二次弹出距离
        partSpace3 = x*(_property.width/3);//回到正常的距离
        
        if(runtime<=partTime1)//拉倒极限后反弹
        {
            float time = runtime;
            float a = acceleration(partTime1,partSpace1);
            float space = a*time*time/2;
            path = [self pullPathWithOffset:offSet - space toOut:NO].CGPath;
        }else if(runtime <= partTime1+partTime2)
        {
            float time = runtime-partTime1;
            float a = acceleration(partTime2,partSpace2);
            float space = a*time*time/2;
            path = [self pullPathWithOffset:- inset + space toOut:NO].CGPath;
        }else
        {
            float time = runtime-partTime1-partTime2;
            float a = acceleration(partTime3,partSpace3);
            float space = a*time*time/2;
            path = [self pullPathWithOffset:partSpace3 - space toOut:NO].CGPath;
        }
    }
    
    
    [self redrawWithPath:path];
}

- (void)animationStop {
    _beginProperty = CopyRBProperty(_currentProperty);
    _property.x = _beginProperty.x;
    if(_stopAction) _stopAction();
}

#pragma mark -
#pragma mark redraw
- (void)redrawWithPath:(CGPathRef)path {
    _drawLayer.path = path;
}

#pragma mark -
#pragma mark animation transaction for ftp
- (void)timeUpdate:(CADisplayLink *)link {
    [self updateLayer];
}

- (void)updateLayer {
    [self render];
}


@end
