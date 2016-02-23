//
//  DPAppDeployer.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAppDeployer.h"
#import "FrameWork.h"
#import <CoreText/CoreText.h>
#import <SSKeychain/SSKeychain.h>
#import "DPNotifyCapturer.h"

@implementation DPAppDeployer

+ (void)deployFramework {
    CFrameWork *framework = CFrameWork::GetInstance();
    NSString *appVersion = [DPSystemUtilities appVersion];
    
    framework->SetAppVersion(appVersion.UTF8String);
    framework->SetChannelId(4);
    
    framework->Init((char *)kServerAddr.UTF8String, kServerPort, (char *)kServerURLPrefix.UTF8String, (char *)kServerWebSocket.UTF8String);
    
    if ([DPSystemUtilities isFirstActive]) {
        [SSKeychain deletePasswordForService:dp_KeychainServiceName account:dp_KeychainSessionAccount];
    }
    // 设置会话
    NSString *session = [SSKeychain passwordForService:(NSString *)dp_KeychainServiceName account:(NSString *)dp_KeychainSessionAccount];
    if (session) {
        framework->SetSessionContent(session.UTF8String);
    }
    
    [[DPNotifyCapturer defaultCapturer] startNetListener];
}

+ (void)deployTheme {
    // 加载字体
//    [self dynamicLoadFont];
    
    // 校正时间
    
    // 导航栏颜色
    if (IOS_VERSION_7_OR_ABOVE) {
        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor],
                                                               UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    } else {
        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor],
                                                               UITextAttributeTextShadowOffset : [NSValue valueWithCGPoint:CGPointZero],
                                                               UITextAttributeFont : [UIFont dp_systemFontOfSize:15]}];
    }
    
    // 状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


+ (void)dynamicLoadFont {
    NSString *fontDirPath = [[DPFileUtilities docPath] stringByAppendingPathComponent:@"font"];
    NSString *systemFontFile = [fontDirPath stringByAppendingPathComponent:@"system1.ttf"];
    NSString *boldSystemFontFile = [fontDirPath stringByAppendingPathComponent:@"boldsystem.ttf"];
    NSString *lightSystemFontFile = [fontDirPath stringByAppendingPathComponent:@"lightsystem.ttf"];
    
    
    if (![DPFileUtilities directoryExistsAtPath:fontDirPath]) {
        [DPFileUtilities mkDir:fontDirPath];
    }
    
    
    if (![DPFileUtilities fileExistsAtPath:systemFontFile]) {
        NSData *fontData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://10.12.2.31:8000/Microsoft_YaHei.ttf"]];
        
        do {
            if (!fontData) {
                break;
            }
            if (![fontData writeToFile:systemFontFile atomically:YES]) {
                break;
            }
            if (![UIFont dp_registerFontWithPath:systemFontFile]) {
                break;
            }
            
            dp_systemFontName = @"Microsoft YaHei";
            if ([UIFont fontWithName:dp_systemFontName size:10]) {
                dp_isSystemFontLoaded = YES;
            }
        } while (NO);
    } else {
        if ([UIFont dp_registerFontWithPath:systemFontFile]) {
            dp_systemFontName = @"Microsoft YaHei";
            if ([UIFont fontWithName:dp_systemFontName size:10]) {
                dp_isSystemFontLoaded = YES;
            }
        }
    }
}

@end
