//
//  UIViewController+HUD.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>
#import "DPLoadingView.h"

const char *VIEW_CONTROLLER_HUD_KEY = "ProgressHUDKey";

@interface UIViewController ()

@property (nonatomic, strong, readonly) MBProgressHUD *progressHUD;
@property (nonatomic, assign, readonly, getter = isHUDLoaded) BOOL HUDLoaded;

@end

@implementation UIViewController (HUD)

- (void)pvt_showHUD {
    if (self.progressHUD.superview == nil) {
        [self.view addSubview:self.progressHUD];
    }
    
    [self.view bringSubviewToFront:self.progressHUD];
    [self.progressHUD show:YES];
}

- (void)showHUD {
    [self.progressHUD setLabelText:nil];
    [self.progressHUD setDimBackground:NO];
    [self pvt_showHUD];
}

- (void)showHUDWithText:(NSString *)text {
    [self.progressHUD setLabelText:text];
    [self.progressHUD setDimBackground:NO];
    [self pvt_showHUD];
}

- (void)dismissHUD {
    if (self.isHUDLoaded) {
        [self.progressHUD hide:YES];
    }
}

- (BOOL)isHUDAppear {
    return self.isHUDLoaded && self.progressHUD.superview != nil;
}

- (MBProgressHUD *)progressHUD {
    MBProgressHUD *progressHUD = objc_getAssociatedObject(self, VIEW_CONTROLLER_HUD_KEY);
    if (progressHUD == nil) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.color = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1];
        progressHUD.minSize = CGSizeMake(90, 70);
        
        for (UIActivityIndicatorView *indicatorView in progressHUD.subviews) {
            if ([indicatorView isKindOfClass:[UIActivityIndicatorView class]]) {
                [indicatorView setColor:[UIColor colorWithRed:0.53 green:0.45 blue:0.39 alpha:1]];
                break;
            }
        }
        
        objc_setAssociatedObject(self, VIEW_CONTROLLER_HUD_KEY, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return progressHUD;
}

- (BOOL)isHUDLoaded {
    return (objc_getAssociatedObject(self, VIEW_CONTROLLER_HUD_KEY) != nil);
}

#pragma mark - dark

- (void)showDarkHUD {
    [self.view.window showDarkHUD];
}

- (void)showDarkHUDWithText:(NSString *)text {
    [self.view.window showDarkHUDWithText:text];
}

- (void)dismissDarkHUD {
    [self.view.window dismissHUD];
}

#pragma mark - loading view

- (void)showLoadingView {
    DPLoadingView *view = [[DPLoadingView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)dismissLoadingView {
    DPLoadingView *view = (id)[self.view viewWithTag:kLoadingViewTag];
    if ([view isKindOfClass:[DPLoadingView class]]) {
        [view removeFromSuperview];
    }
}

@end
