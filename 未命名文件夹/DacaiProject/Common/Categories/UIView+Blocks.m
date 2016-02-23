//
//  UIView+Blocks.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIView+Blocks.h"
/*#import <objc/runtime.h>

static char *UIViewBlockTapKey = "UIViewTapBlockKey";
static char *UIViewBlockResponseSubviewKey = "UIViewTapBlockKey";

typedef void(^UIViewTapBlock)(UITapGestureRecognizer *tap);

@interface UIView () <UIGestureRecognizerDelegate>
@property (nonatomic, copy) UIViewTapBlock tapBlock;
@property (nonatomic, assign) UIView *responseSubview;  // must be subview
@end

@implementation UIView (Blocks)

- (void)dp_addTapBlocks:(void(^)(UITapGestureRecognizer *tap))block {
    [self setTapBlock:block];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap_UIView_Blocks:)]];
}

- (void)dp_addTapBlocks:(void(^)(UITapGestureRecognizer *tap))block responseSubview:(UIView *)view {
    DPAssert([view isDescendantOfView:self]);
    
    [self setTapBlock:block];
    [self setResponseSubview:view];
    [self addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap_UIView_Blocks:)];
        tap.delegate = self;
        tap;
    })];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.responseSubview]) {
        return NO;
    }
    return YES;
}

- (void)onTap_UIView_Blocks:(UITapGestureRecognizer *)tap {
    if (self.tapBlock) {
        self.tapBlock(tap);
    }
}

#pragma mark - getter, setter
- (void)setTapBlock:(UIViewTapBlock)tapBlock {
    objc_setAssociatedObject(self, UIViewBlockTapKey, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIViewTapBlock)tapBlock {
    return objc_getAssociatedObject(self, UIViewBlockTapKey);
}

- (void)setResponseSubview:(UIView *)responseSubview {
    objc_setAssociatedObject(self, UIViewBlockResponseSubviewKey, responseSubview, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)responseSubview {
    return objc_getAssociatedObject(self, UIViewBlockResponseSubviewKey);
}

@end*/
