//
//  UIBarButtonItem+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DPAdditions)

+ (instancetype)dp_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (instancetype)dp_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)dp_itemWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)dp_itemWithImage:(UIImage *)image title:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action;

@end
