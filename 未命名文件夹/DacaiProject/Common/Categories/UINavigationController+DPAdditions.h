//
//  UINavigationController+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (DPAdditions)

+ (instancetype)dp_controllerWithRootViewController:(UIViewController *)viewController;

- (void)dp_applyGlobalTheme;

@end
