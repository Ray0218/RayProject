//
//  LYMovePathView.m
//  TestAnimation
//
//  Created by Liuyu on 14-6-19.
//  Copyright (c) 2014年 Liuyu. All rights reserved.
//

#import "LYMovePathView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation LYMovePathView

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame movePath:(CGPathRef)path;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self animationEmitter];
        
        [self animationMoveWithPath:path];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)animationEmitter
{
    CAEmitterLayer *emitterLayer = (CAEmitterLayer *)self.layer;         
    emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);    // 坐标
    emitterLayer.emitterSize = self.bounds.size;            // 粒子大小
    emitterLayer.renderMode = kCAEmitterLayerAdditive;      // 递增渲染模式
    emitterLayer.emitterMode = kCAEmitterLayerPoints;       // 粒子发射模式（面发射）
	emitterLayer.emitterShape = kCAEmitterLayerSphere;      // 粒子形状（球状）
    
    // 星星粒子
    CAEmitterCell *cell1 = [self productEmitterCellWithContents:(id)[[UIImage imageNamed:@"star1.png"] CGImage]];
    cell1.scale = 0.3;
    cell1.scaleRange = 0.1;
    
    // 圆粒子
    CAEmitterCell *cell2 = [self productEmitterCellWithContents:(id)[[UIImage imageNamed:@"cycle1.png"] CGImage]];
    cell2.scale = 0.05;
    cell2.scaleRange = 0.02;
    
    emitterLayer.emitterCells = @[cell1, cell2];
    

}

- (CAEmitterCell *)productEmitterCellWithContents:(id)contents
{
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 120;       // 每秒产生粒子数
    cell.lifetime = 1;          // 每个粒子的生命周期
    cell.lifetimeRange = 0.3;
    cell.contents = contents;   // cell内容，一般是一个CGImage
    cell.color = [[UIColor whiteColor] CGColor];
    cell.velocity = 50;         // 粒子的发射方向
    cell.emissionLongitude = M_PI*2;
    cell.emissionRange = M_PI*2;
    cell.velocityRange = 100;
    cell.spin = 10;
    
    return cell;
}


- (void)animationMoveWithPath:(CGPathRef)path
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    animation.path = path;
    animation.duration = 4;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
    

}


//- (CGPathRef)path
//{
//    CGMutablePathRef path = CGPathCreateMutable();
//
//    CGPathMoveToPoint(path, NULL, 50.0, 120.0);
//    CGPathAddCurveToPoint(path, NULL, 50.0, 275.0, 150.0, 275.0, 150.0, 120.0);
//
//    return path;
//}

@end
