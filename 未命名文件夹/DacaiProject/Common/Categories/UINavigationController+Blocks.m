//
//  UINavigationController+Blocks.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UINavigationController+Blocks.h"
#import <objc/runtime.h>

typedef void (^POPCompletionBlock)(void);

static char *POPCompletionBlockKey = "POPCompletionBlockKey";

@interface UINavigationController () <UINavigationControllerDelegate>
@property (nonatomic, copy) POPCompletionBlock completion;
@end

@implementation UINavigationController (Blocks)

- (UIViewController *)dp_popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion {
    self.delegate = self;
    self.completion = completion;
    return [self popViewControllerAnimated:animated];
}

- (NSArray *)dp_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)())completion {
    self.delegate = self;
    self.completion = completion;
    return [self popToRootViewControllerAnimated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.completion) {
        self.completion();
        self.delegate = nil;
        self.completion = nil;
    }
}

#pragma mark - getter, setter
- (POPCompletionBlock)completion {
    return objc_getAssociatedObject(self, POPCompletionBlockKey);
}

- (void)setCompletion:(POPCompletionBlock)completion {
    objc_setAssociatedObject(self, POPCompletionBlockKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
