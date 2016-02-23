//
//  UIWindow+DPAdditions_MBProgressHUD.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIWindow+HUD.h"
#import <objc/runtime.h>

const char *WINDOW_HUD_KEY = "ProgressHUDKey";

@interface UIWindow ()

@property (nonatomic, strong, readonly) MBProgressHUD *progressHUD;

@end

@implementation UIWindow (HUD)

- (void)pvt_showHUD {
    if (self.progressHUD.superview == nil) {
        [self addSubview:self.progressHUD];
    }
    
    [self.window bringSubviewToFront:self.progressHUD];
    [self.progressHUD show:YES];
}

- (void)showDarkHUD {
    [self.progressHUD setLabelText:nil];
    [self.progressHUD setDimBackground:YES];
    [self pvt_showHUD];
}

- (void)showDarkHUDWithText:(NSString *)text {
    [self.progressHUD setLabelText:text];
    [self.progressHUD setDimBackground:YES];
    [self pvt_showHUD];
}

- (void)dismissHUD {
    [self.progressHUD hide:YES];
}

- (MBProgressHUD *)progressHUD {
    MBProgressHUD *progressHUD = objc_getAssociatedObject(self, WINDOW_HUD_KEY);
    if (progressHUD == nil) {
        progressHUD = [[MBProgressHUD alloc] initWithWindow:self];
        progressHUD.removeFromSuperViewOnHide = YES;
        
        objc_setAssociatedObject(self, WINDOW_HUD_KEY, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return progressHUD;
}

@end
