//
//  UIBarButtonItem+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIBarButtonItem+DPAdditions.h"

@implementation UIBarButtonItem (DPAdditions)

+ (instancetype)dp_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self dp_itemWithImage:image title:nil tintColor:[UIColor dp_flatWhiteColor] target:target action:action];
}

+ (instancetype)dp_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self dp_itemWithImage:nil title:title tintColor:[UIColor dp_flatWhiteColor] target:target action:action];
}

+ (instancetype)dp_itemWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action {
    return [self dp_itemWithImage:image title:title tintColor:[UIColor dp_flatWhiteColor] target:target action:action];
}

+ (instancetype)dp_itemWithImage:(UIImage *)image title:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action {
    UIColor *highlightedColor = [UIColor colorWithRed:tintColor.dp_red green:tintColor.dp_green blue:tintColor.dp_blue alpha:0.4];
    
    if (image == nil) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
        if (!IOS_VERSION_7_OR_ABOVE) {  // iOS7以下去掉按钮边框
            [item setBackgroundImage:[UIImage dp_globalImageNamed:@"clear" makeBlock:^UIImage *{
                return [UIImage dp_imageWithColor:[UIColor clearColor]];
            }] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        
        [item setTintColor:tintColor];
        // 设置字体颜色
        [item setTitleTextAttributes:@{UITextAttributeTextColor : tintColor,
                                       UITextAttributeFont : [UIFont dp_systemFontOfSize:14],
                                       UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeZero]}
                            forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{UITextAttributeTextColor : highlightedColor,
                                       UITextAttributeFont : [UIFont dp_systemFontOfSize:14],
                                       UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeZero]}
                            forState:UIControlStateHighlighted];
        
        return item;
    }
    if (title == nil) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
        if (!IOS_VERSION_7_OR_ABOVE) {  // iOS7以下去掉按钮边框
            [item setBackgroundImage:[UIImage dp_globalImageNamed:@"clear" makeBlock:^UIImage *{
                return [UIImage dp_imageWithColor:[UIColor clearColor]];
            }] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        [item setTintColor:tintColor];
        return item;
    }
    
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:tintColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button setImage:[image dp_imageWithTintColor:tintColor] forState:UIControlStateNormal];
    [button setImage:[image dp_imageWithTintColor:highlightedColor] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, button.dp_intrinsicWidth + 3, button.dp_intrinsicHeight)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    item.style = UIBarButtonItemStylePlain;
    item.tintColor = tintColor;
    return item;
}

@end
