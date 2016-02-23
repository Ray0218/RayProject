//
//  LYBgImageView.m
//  TestAnimation
//
//  Created by Liuyu on 14-6-19.
//  Copyright (c) 2014年 Liuyu. All rights reserved.
//

#import "LYBgImageView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation LYBgImageView

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"bg1.png"];
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        
        // 无限自动旋转的光晕
        [self animationHalo];
        
        // 自动生产的星星和点点
        [self animationAutoProductStarAndPoint];
    }
    return self;
}

// 无限自动旋转的光晕
- (void)animationHalo
{
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg2.png"]];
    imageView2.frame = self.bounds;
    imageView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView2.clipsToBounds = YES;
    [self addSubview:imageView2];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 200;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = [NSNumber numberWithDouble:0];
    animation.toValue = [NSNumber numberWithDouble:M_PI*2];
    [imageView2.layer addAnimation:animation forKey:@"transform"];
}

// 自动生产的星星和点点的动画
- (void)animationAutoProductStarAndPoint
{
    CAEmitterLayer *emitterLayer = (CAEmitterLayer *)self.layer;
    emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);    // 坐标
    emitterLayer.emitterSize = self.bounds.size;            // 粒子大小
    emitterLayer.renderMode = kCAEmitterLayerOldestLast;     // 递增渲染模式
    emitterLayer.emitterMode = kCAEmitterLayerSurface;      // 粒子发射模式（面发射）
	emitterLayer.emitterShape = kCAEmitterLayerSphere;      // 粒子形状（球状）
    emitterLayer.seed = (arc4random()%100)+1;   // 用于初始化随机数产生的种子

    // 点点粒子
    CAEmitterCell *cycleCell = [CAEmitterCell emitterCell];
    cycleCell.birthRate = 1;
    cycleCell.lifetime = MAXFLOAT;
    cycleCell.contents = (id)[[UIImage imageNamed:@"bgAnimationPoint1.png"] CGImage]; // cell内容，一般是一个CGImage
    cycleCell.color = [[UIColor whiteColor] CGColor];
    cycleCell.velocity = 50;        // 粒子发射速度
    cycleCell.velocityRange = 2;
    cycleCell.alphaRange = 0.5;
    cycleCell.alphaSpeed = 2;
    cycleCell.scale = 0.1;
    cycleCell.scaleRange = 0.1;
    [cycleCell setName:@"starPoint"];
    
    // 星星粒子
    CAEmitterCell *starCell = [CAEmitterCell emitterCell];
    starCell.birthRate = 2;
    starCell.lifetime = 2.02;
    
    CAEmitterCell *starCell0 = [CAEmitterCell emitterCell];
    starCell0.birthRate = 3;
    starCell0.lifetime = 2.02;
    starCell0.velocity = 0;
    starCell0.emissionRange = 2*M_PI;    // 发射角度范围
    starCell0.contents = (id)[[UIImage imageNamed:@"bgAnimationStar.png"] CGImage];
    starCell0.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0] CGColor];
    starCell0.alphaSpeed = 0.6;
    starCell0.scale = 0.4;
    [starCell0 setName:@"star"];
    
    CAEmitterCell *starCell1 = [CAEmitterCell emitterCell];
    starCell1.birthRate = 0.5;
    starCell1.lifetime = 2.02;
    starCell1.velocity = 0;
    starCell1.emissionRange = 2*M_PI;    // 发射角度范围
    
    CAEmitterCell *starCell2 = [CAEmitterCell emitterCell];
    starCell2.birthRate = 3;
    starCell2.lifetime = 2;
    starCell2.velocity = 0;
    starCell2.emissionRange = 2*M_PI;    // 发射角度范围
    starCell2.contents = (id)[[UIImage imageNamed:@"bgAnimationStar.png"] CGImage];
    starCell2.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    starCell2.alphaSpeed = -0.5;
    starCell2.scale = starCell0.scale;
    
    
    emitterLayer.emitterCells = @[cycleCell,starCell,starCell1];
    starCell.emitterCells = @[starCell0,starCell1];
    starCell1.emitterCells = @[starCell2];
}

@end
