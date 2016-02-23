//
//  LYFireworksView.m
//  TestAnimation
//
//  Created by Liuyu on 14-6-21.
//  Copyright (c) 2014年 Liuyu. All rights reserved.
//

#import "LYFireworksView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation LYFireworksView

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self animationEmitter];
    }
    return self;
}

- (void)animationEmitter
{
    CAEmitterLayer *emitterLayer = (CAEmitterLayer *)self.layer;
//    emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);    // 坐标
    emitterLayer.emitterPosition = CGPointMake(160, 400);    // 粒子产生点得坐标

    emitterLayer.emitterSize = CGSizeMake(100, 0);               // 粒子产生点的大小
    emitterLayer.renderMode = kCAEmitterLayerAdditive;      // 递增渲染模式
    emitterLayer.emitterMode = kCAEmitterLayerOutline;      // 粒子发射模式（向线外发射）
	emitterLayer.emitterShape = kCAEmitterLayerLine;        // 粒子形状（线）
    emitterLayer.seed = (arc4random()%100) + 1;
   
    
    // 爆炸前的移动星星圆粒子
    CAEmitterCell *cycleCell = [CAEmitterCell emitterCell];
    cycleCell.birthRate = 1; //
    cycleCell.lifetime = 1.02;
    cycleCell.emissionLatitude = 0;
    cycleCell.emissionLongitude = 0;
    cycleCell.emissionRange = M_PI_4/2;    // 发射角度范围
    cycleCell.velocity = 200;//移动的距离
    cycleCell.contents = (id)[[UIImage imageNamed:@"cycle1.png"] CGImage];
    cycleCell.scale = 0.05;

    // 爆炸时的粒子
    CAEmitterCell *burstCell = [CAEmitterCell emitterCell];
	burstCell.birthRate	= cycleCell.birthRate;
    burstCell.scale = 2.5;
	burstCell.lifetime = 0.2;
    
    // 爆炸后的散射星星例子
    CAEmitterCell *starCell = [CAEmitterCell emitterCell];
    starCell.birthRate = 600;
    starCell.velocity = 250;
    starCell.lifetime = 1;
    starCell.lifetimeRange = 0.8;
    starCell.emissionRange = M_PI;    // 发射角度范围
    starCell.yAcceleration = 250;
    starCell.contents = (id)[[UIImage imageNamed:@"star1.png"] CGImage];
    starCell.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
    starCell.alphaSpeed = -0.8;
    starCell.scale = 2;
    starCell.scaleRange = 4;
    starCell.spin = 1*M_PI;;
    starCell.redRange = 0.5;
    starCell.greenRange = 0.5;
    starCell.blueRange = 0.5;
    
    
    emitterLayer.emitterCells = @[cycleCell];
    cycleCell.emitterCells = @[burstCell];
    burstCell.emitterCells = @[starCell];
    
}

@end
