//
//  UIView+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIView+DPAdditions.h"

@implementation UIView (DPAdditions)

- (UIViewController *)dp_viewController {
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

+ (instancetype)dp_viewWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
//    view.userInteractionEnabled = NO;
    return view;
}

#pragma mark - getter
- (CGSize)dp_size {
    return self.frame.size;
}

- (CGPoint)dp_origin {
    return self.frame.origin;
}

- (CGFloat)dp_x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)dp_y {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)dp_width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)dp_height {
    return CGRectGetHeight(self.frame);
}

#pragma mark - setter
- (void)setDp_size:(CGSize)dp_size {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), dp_size.width, dp_size.height);
}

- (void)setDp_origin:(CGPoint)dp_origin {
    self.frame = CGRectMake(dp_origin.x, dp_origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)setDp_x:(CGFloat)dp_x {
    self.frame = CGRectMake(dp_x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)setDp_y:(CGFloat)dp_y {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), dp_y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)setDp_width:(CGFloat)dp_width {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), dp_width, CGRectGetHeight(self.frame));
}

- (void)setDp_height:(CGFloat)dp_height {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), dp_height);
}

#pragma mark - getter
- (CGFloat)dp_intrinsicWidth {
    return self.intrinsicContentSize.width;
}

- (CGFloat)dp_intrinsicHeight {
    return self.intrinsicContentSize.height;
}

- (CGFloat)dp_minX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)dp_midX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)dp_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)dp_minY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)dp_midY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)dp_maxY {
    return CGRectGetMaxY(self.frame);
}

@end
