//
//  DPAppDelegate.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
extern   NSString *PUSH_DEVICE_TOKEN;//推送token
@class XTSideMenu;
@interface DPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) XTSideMenu *rootController;

@property (nonatomic, assign) BOOL gotoHomeBuy;

@end
