//
//  UIViewController+HUD.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHUD;
- (void)showHUDWithText:(NSString *)text;
- (void)dismissHUD;

- (void)showDarkHUD;
- (void)showDarkHUDWithText:(NSString *)text;
- (void)dismissDarkHUD;

- (BOOL)isHUDAppear;

- (void)showLoadingView;
- (void)dismissLoadingView;

@end
