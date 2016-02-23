//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAppDelegate.h"
#import "DPAppDeployer.h"
#import "DPAppParser.h"

#import "Common/Component/XTSideMenu/XTSideMenu.h"
#import "Modules/Account/DPPersonalCenterViewController.h"
#import "DPAppRootViewController.h"
#import "DPStartupView.h"
#import "WXApi.h"
#import "XGPush.h"
#import "FrameWork.h"
#import "DPNotifyCapturer.h"
#import "DPRechargeSuccessVC.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "DPThirdCallCenter.h"
#import "WeiboSDK.h"
#import <AFNetworking.h>

@interface DPAppDelegate () <DPStartupViewDelegate, WXApiDelegate, WeiboSDKDelegate>
@end

@implementation DPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DPAppDeployer deployFramework];
    [DPAppDeployer deployTheme];
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];    // 永不黑屏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navigationController = [UINavigationController dp_controllerWithRootViewController:[[DPPersonalCenterViewController alloc] init]];
    navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    navigationController.view.layer.shadowOffset = CGSizeMake(1, 0);
    navigationController.view.layer.shadowOpacity = 0.5;
    
    XTSideMenu *root = [[XTSideMenu alloc] initWithContentViewController:[[DPAppRootViewController alloc] init]
                                                  leftMenuViewController:navigationController
                                                 rightMenuViewController:nil];
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:root];
    [self.window makeKeyAndVisible];
    [self setRootController:root];
    [root setPanGestureEnabled:NO];
    [root.view addSubview:({
        DPStartupView *startupView = [[DPStartupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        startupView.delegate = self;
        startupView;
    })];
    
    [WXApi registerApp:dp_WxAppId];
    [WeiboSDK registerApp:dp_sinaWeibo_appID];
#ifndef __DEBUG
    BOOL weiboLogo = NO;
#else
    BOOL weiboLogo = YES;
#endif
    [WeiboSDK enableDebugMode:weiboLogo];
    
    [XGPush startApp:2200020116 appKey:@"IH11GGKE253V"];
    [self registerNofitication];
    //推送反馈(app不在前台运行时，点击推送激活时)
    [XGPush handleLaunching:launchOptions];
    
    NSDictionary *pushinfo=[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    // 推送反馈(app在前台运行时)
//    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSString *jsonString = [pushinfo objectForKey:@"Action"];
    if (jsonString.length) {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *obj = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [DPAppParser rootViewController:nil animated:YES userInfo:obj];
        }
    }

    // 开启网络状态监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BOOL hasNet = [AFNetworkReachabilityManager sharedManager].reachable;
        NSDictionary *infoDict = @{dp_NetworkStatusInfoKey : @(hasNet)};
        [[NSNotificationCenter defaultCenter] postNotificationName:dp_NetworkStatusCheckKey object:nil userInfo:infoDict];
    }];
    return YES;
}
#pragma mark - DPStartupViewdDelegate
- (void)viewDidDestory:(DPStartupView *)view {
    self.rootController.panGestureEnabled = YES;
    CFrameWork::GetInstance()->GetLotteryCommon()->HomeBuyRefresh();
}

#pragma mark - UIApplicationDelegate
- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_ApplicationWillResignActive object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_ApplicationDidEnterBackground object:nil];
    // 关闭网络状态监测
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_ApplicationWillEnterForeground object:nil];
    
    int updateType = 0; string download; vector<string> contents;
    CFrameWork::GetInstance()->GetLotteryCommon()->GetUpdateInfo(updateType, contents, download);
    if (updateType == 3) {
        NSMutableString *content = [NSMutableString string];
        for (int i = 0; i < contents.size(); i++) {
            [content appendString:[NSString stringWithUTF8String:contents[i].c_str()]];
            if (i < contents.size() - 1) {
                [content appendFormat:@"\n"];
            }
        }
        
        [UIAlertView bk_showAlertViewWithTitle:@"有新版本" message:content cancelButtonTitle:@"前往更新" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:download.c_str()]]];
        }];
    }
    // 开启网络状态监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_NetworkStatusCheckKey object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[DPNotifyCapturer defaultCapturer] checkServerDate];
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_ApplicationDidBecomeActive object:nil];
    application.applicationIconBadgeNumber = 0;
    if (self.gotoHomeBuy) {
        self.gotoHomeBuy = NO;
        [DPAppParser backToCenterRootViewController:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_ApplicationWillTerminate object:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[[url scheme] lowercaseString] isEqualToString:dp_URLScheme]) {
        NSString *resourceSpecifier = [url resourceSpecifier];
        if (resourceSpecifier.length > 9 && [[[resourceSpecifier substringToIndex:9] lowercaseString] hasPrefix:@"//action?"]) {
            resourceSpecifier = [resourceSpecifier substringFromIndex:9];
            
            resourceSpecifier = [DPCryptUtilities URLDecode:resourceSpecifier];
            resourceSpecifier = [[NSString alloc] initWithData:[DPCryptUtilities base64Decode:resourceSpecifier] encoding:NSUTF8StringEncoding];
            
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[resourceSpecifier dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            
            self.gotoHomeBuy = NO;
            
            if (!error && [dic isKindOfClass:[NSDictionary class]]) {
                [DPAppParser rootViewController:nil animated:NO userInfo:dic];
                return YES;
            }
        }else if ([resourceSpecifier hasPrefix:@"//app_buycenter"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayWeb" object:nil userInfo:@{@"URL" : url}];
        }
        return NO;
    }
       DPLog(@"url scheme = %@", [url scheme]);
    if ([[url scheme] isEqualToString:dp_WxAppId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiXinPay" object:nil userInfo:@{@"URL" : url}];
    }
 
    // QQ登录
    DPLog(@"application openURL =%@, sourceApplication=%@, annotation=%@", url, sourceApplication, annotation);
    
    return [WXApi handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]] || [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]] || [WeiboSDK handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]];

    return NO;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    DPLog(@"handle2  url = %@", url);
    return [WXApi handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]] || [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]] || [WeiboSDK handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]];

}
- (void)registerNofitication {
#if IOS_SUPPORT_8_OR_ABOVE
    if (IOS_VERSION_8_OR_ABOVE) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else
#endif
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
   
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    // 推送反馈(app在前台运行时)
    application.applicationIconBadgeNumber = 0;
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (application.applicationState == UIApplicationStateActive) {
        return;
    }
    NSString *jsonString = [userInfo objectForKey:@"Action"];
    if (jsonString.length) {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *obj = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [DPAppParser rootViewController:nil animated:YES userInfo:obj];
        }
    }
//    [XGPush handleReceiveNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 注册设备, 获取的deviceToken的字符串
    NSString *token = [XGPush registerDevice:deviceToken];
    CFrameWork::GetInstance()->SetDeviceToken(token.UTF8String);
    CFrameWork::GetInstance()->GetLotteryCommon()->DeviceRegister();
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    CFrameWork::GetInstance()->GetLotteryCommon()->DeviceRegister();
}
//#pragma weiboSDK delegate
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    DPLog(@"weibo----- did receive response=%@", response);
//    
//}
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    DPLog(@"weibo----- did receive request=%@", request);
//
//}
//#pragma mark 微信代理
//- (void)onResp:(BaseResp *)resp
//{
//    DPLog(@"微信--- appdelegate------resp = %@", resp);
//}
//- (void)onReq:(BaseReq *)req
//{
//    DPLog(@"微信--- appdelegate------req = %@", req);
//}

@end
