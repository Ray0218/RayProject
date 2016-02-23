//
//  DPAppParser.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-13.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPAppParser : NSObject

+ (void)rootViewController:(UIViewController *)rootController animated:(BOOL)animated userInfo:(NSDictionary *)userInfo;
+ (void)backToLeftRootViewController:(BOOL)animation;
+ (void)backToCenterRootViewController:(BOOL)animation;
+ (UIViewController *)visibleViewController;

+ (void)mutualWebView:(NSDictionary *)userInfo;

@end
