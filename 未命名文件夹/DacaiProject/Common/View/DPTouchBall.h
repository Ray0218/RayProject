//
//  DPTouchBall.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  数字彩投注界面小球点击效果
//

#import <UIKit/UIKit.h>

extern const NSInteger dp_TouchBallWidth;
extern const NSInteger dp_TouchBallHegiht;

@interface DPTouchBall : UIImageView

@property (nonatomic, strong) NSString *titleText;

+ (instancetype)redBall;
+ (instancetype)blueBall;

@end
