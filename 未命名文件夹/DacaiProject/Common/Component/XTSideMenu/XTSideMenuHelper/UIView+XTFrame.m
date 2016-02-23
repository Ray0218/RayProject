//
//  UIView+Frame.m
//  LocalImageEdit
//
//  Created by XT on 14-6-17.
//  Copyright (c) 2014年 XT. All rights reserved.
//

#import "UIView+XTFrame.h"

@implementation UIView (XTFrame)

- (CGFloat)xt_top
{
    return self.frame.origin.y;
}

- (void)setXt_top:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)xt_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXt_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)xt_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXt_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)xt_left
{
    return self.frame.origin.x;
}

- (void)setXt_left:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)xt_width
{
    return self.frame.size.width;
}

- (void)setXt_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)xt_height
{
    return self.frame.size.height;
}

- (void)setXt_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end