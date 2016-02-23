//
//  UIView+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DPAdditions)

@property(nonatomic, strong, readonly) UIViewController *dp_viewController;

+ (instancetype)dp_viewWithColor:(UIColor *)color;

@property (nonatomic, assign) CGSize dp_size;
@property (nonatomic, assign) CGPoint dp_origin;
@property (nonatomic, assign) CGFloat dp_x;
@property (nonatomic, assign) CGFloat dp_y;
@property (nonatomic, assign) CGFloat dp_width;
@property (nonatomic, assign) CGFloat dp_height;

@property (nonatomic, assign, readonly) CGFloat dp_intrinsicWidth;
@property (nonatomic, assign, readonly) CGFloat dp_intrinsicHeight;
@property (nonatomic, assign, readonly) CGFloat dp_minX;
@property (nonatomic, assign, readonly) CGFloat dp_midX;
@property (nonatomic, assign, readonly) CGFloat dp_maxX;
@property (nonatomic, assign, readonly) CGFloat dp_minY;
@property (nonatomic, assign, readonly) CGFloat dp_midY;
@property (nonatomic, assign, readonly) CGFloat dp_maxY;

@end
