//
//  UINavigationController+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UINavigationController+DPAdditions.h"

@implementation UINavigationController (DPAdditions)

+ (instancetype)dp_controllerWithRootViewController:(UIViewController *)viewController {
    UIImage *image = [UIImage dp_globalImageNamed:@"red" makeBlock:^UIImage *{
        return [UIImage dp_imageWithColor:[UIColor dp_flatDarkRedColor]];
    }];
    
    UINavigationController *navigationController = viewController ? [[UINavigationController alloc] initWithRootViewController:viewController] : [[UINavigationController alloc] init];
    [navigationController.navigationBar setTranslucent:NO];
    [navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    return navigationController;
}

- (void)dp_applyGlobalTheme {
    UIImage *image = [UIImage dp_globalImageNamed:@"red" makeBlock:^UIImage *{
        return [UIImage dp_imageWithColor:[UIColor dp_flatDarkRedColor]];
    }];
    
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // 导航栏颜色
    if (IOS_VERSION_7_OR_ABOVE) {
        [self.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor],
                                                     UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    } else {
        [self.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor],
                                                     UITextAttributeTextShadowOffset : [NSValue valueWithCGPoint:CGPointZero],
                                                     UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    }
}

@end
