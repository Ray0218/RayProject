//
//  CommonDefine.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "CommonDefine.h"

// DPToastWarning
NSString *dp_moneyLimitWarning = @"方案总金额不能超过2000000";
// URL
NSString *dp_AppIdentifier = @"com.dacai.main";
NSString *dp_URLIdentifier = @"com.dacai.ios";
NSString *dp_URLScheme = @"hzdacai";

NSString *dp_WxAppId = @"wx68e6ce83020c18e1";
NSString *dp_QQAppId = @"100776828";
NSString *dp_sinaWeibo_appID = @"2581853027";
// Keychain
NSString *dp_KeychainServiceName = @"com.dacai.www - 9F56B284-B3D2-9258-0D7A-61690B8B07D4";

NSString *dp_KeychainSessionAccount = @"SessionContent";
NSString *dp_KeychainDeviceTokenAccount = @"DeviceToken";
NSString *dp_keychainInstallVersion = @"InstallVersion";

// UserDefaults
NSString *dp_LastStartupVersionKey = @"LastStartupVersion";
NSString *dp_ActiveAppGuidKey = @"dp_ActiveAppGuidKey";
NSString *dp_ActiveAppVersionKey = @"dp_ActiveAppVersionKey";
NSString *dp_HomeBuyImagesKey = @"dp_HomeBuyImagesKey";
NSString *dp_HomeBuyActionsKey = @"dp_HomeBuyActionsKey";

// Notify
NSString *dp_ApplicationWillResignActive = @"dp_ApplicationWillResignActive";
NSString *dp_ApplicationDidEnterBackground = @"dp_ApplicationDidEnterBackground";
NSString *dp_ApplicationWillEnterForeground = @"dp_ApplicationWillEnterForeground";
NSString *dp_ApplicationDidBecomeActive = @"dp_ApplicationDidBecomeActive";
NSString *dp_ApplicationWillTerminate = @"dp_ApplicationWillTerminate";

NSString *dp_ApplicationOpenURL = @"dp_ApplicationOpenURL";
// 自定义通知
NSString *dp_ActiveApplicationNotify = @"dp_ActiveApplication";
NSString *dp_DigitalBetRefreshNofify = @"dp_DigitalBetRefreshNofify"; // 数字彩刷新通知
NSString *dp_ThirdLoginSuccess = @"dp_ThirdLoginSuccess"; // 第三方登录成功通知
NSString *dp_ThirdShareSuccess = @"dp_ThirdShareSuccess"; // 第三方登录成功通知
NSString *dp_ThirdOauthAccessToken = @"dp_ThirdOauthAccessToken";
NSString *dp_ThirdOauthUserIDKey = @"dp_ThirdOauthUserIdKey";
NSString *dp_ThirdType = @"dp_ThirdOauthType";
NSString *dp_ThirdShareFinishKey = @"dp_ThirdShareFinishKey";
NSString *dp_ThirdShareResultKey = @"dp_ThirdShareResultKey";
NSString *dp_NetworkStatusCheckKey = @"dp_NetworkStatusCheckKey";
NSString *dp_NetworkStatusInfoKey = @"dp_NetworkStatusInfoKey";

#pragma mark - 服务器地址

// 开发环境
NSString *kServerBaseURL = @"http://10.12.7.249:96/v3";
NSString *kServerWebSocket = @"10.12.7.249";
NSString *kServerURLPrefix = @"/v3";
NSString *kServerAddr = @"10.12.7.249";
NSInteger kServerPort   = 96;

//NSString *kServerBaseURL = @"http://10.12.2.33:100/v3";
//NSString *kServerWebSocket = @"10.12.2.33";
//NSString *kServerURLPrefix = @"/v3";
//NSString *kServerAddr = @"10.12.2.33";
//NSInteger kServerPort = 100;

//NSString *kServerBaseURL = @"http://10.12.2.34:100/v3";
//NSString *kServerWebSocket = @"10.12.2.34";
//NSString *kServerURLPrefix = @"/v3";
//NSString *kServerAddr = @"10.12.2.34";
//NSInteger kServerPort = 100;

// 生产环境
//NSString *kServerBaseURL = @"http://api.dacai.com/v5";
//NSString *kServerWebSocket = @"114.80.137.14";
//NSString *kServerURLPrefix = @"/v5";
//NSString *kServerAddr = @"api.dacai.com";
//NSInteger kServerPort = 80;

//NSString *kServerBaseURL = @"http://api.dacai.com/v3";
//NSString *kServerWebSocket = @"114.80.137.14";
//NSString *kServerURLPrefix = @"/v3";
//NSString *kServerAddr = @"114.80.137.14";
//NSInteger kServerPort = 80;
