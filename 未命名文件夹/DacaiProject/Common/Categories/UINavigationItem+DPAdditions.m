//
//  UINavigationItem+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UINavigationItem+DPAdditions.h"

@implementation UINavigationItem (DPAdditions)

/*- (void)dp_setLeftItemsWithImages:(NSArray *)images target:(id)target action:(SEL)action {
    CGFloat itemWidth = images.count <= 2 ? 45 : 28;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, images.count * itemWidth, 44)];
    for (int i = 0; i < images.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, 44)];
        [button setImage:images[i] forState:UIControlStateNormal];
        [button setTag:i];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_VERSION_7_OR_ABOVE) {
        fixItem.width = -10;
    }
    self.leftBarButtonItems = @[fixItem, item];
}

- (void)dp_setRightItemsWithImages:(NSArray *)images target:(id)target action:(SEL)action {
    CGFloat itemWidth = images.count <= 2 ? 45 : 30;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, images.count * itemWidth, 44)];
    for (int i = 0; i < images.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, 44)];
        [button setImage:images[i] forState:UIControlStateNormal];
        [button setTag:i];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_VERSION_7_OR_ABOVE) {
        fixItem.width = -10;
    }
    self.rightBarButtonItems = @[fixItem, item];
}

- (void)dp_setRightItemsWithImagesAndTitle:(NSArray *)images titles:(NSArray *)titles titleColors:(NSArray *)colors target:(id)target action:(SEL)action {
    CGFloat itemWidth = images.count == 1 ? 75 : 42;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, images.count * itemWidth, 44)];
    for (int i = 0; i < images.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, 44)];
        [button setImage:images[i] forState:UIControlStateNormal];
        [button setTag:i];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        
        if (i<titles.count) {
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[colors objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
            button.titleLabel.font=[UIFont dp_systemFontOfSize:12];
        }
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_VERSION_7_OR_ABOVE) {
        fixItem.width = -10;
    }
    self.rightBarButtonItems = @[fixItem, item];
}*/

@end
