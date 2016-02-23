//
//  CommonDefine.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject_CommonDefine_H__
#define __DacaiProject_CommonDefine_H__

#define FloatTextForIntDivHundred(value)  value>=0?([NSString stringWithFormat:@"%lld.%02lld", (long long)(value) / 100, (long long)(value) % 100]):@"?"  // e.g. 104 - > @"1.04"

#define kScreenWidth        (CGRectGetWidth(UIScreen.mainScreen.bounds))
#define kScreenHeight       (CGRectGetHeight(UIScreen.mainScreen.bounds) - (IOS_VERSION_7_OR_ABOVE ? 0 : 20))

// DPToastWarning
extern NSString *dp_moneyLimitWarning;
// URL
extern NSString *dp_AppIdentifier;
extern NSString *dp_URLIdentifier;
extern NSString *dp_URLScheme;

extern NSString *dp_WxAppId;
extern NSString *dp_QQAppId;
extern NSString *dp_sinaWeibo_appID;
// Keychain
extern NSString *dp_KeychainServiceName;
extern NSString *dp_KeychainSessionAccount;
extern NSString *dp_KeychainDeviceTokenAccount;
extern NSString *dp_keychainInstallVersion;

// UserDefaults
extern NSString *dp_LastStartupVersionKey;
extern NSString *dp_ActiveAppGuidKey;
extern NSString *dp_ActiveAppVersionKey;
extern NSString *dp_HomeBuyImagesKey;
extern NSString *dp_HomeBuyActionsKey;

// Notify
extern NSString *dp_ApplicationWillResignActive;
extern NSString *dp_ApplicationDidEnterBackground;
extern NSString *dp_ApplicationWillEnterForeground;
extern NSString *dp_ApplicationDidBecomeActive;
extern NSString *dp_ApplicationWillTerminate;
extern NSString *dp_ApplicationOpenURL;
extern NSString *dp_ActiveApplicationNotify;
extern NSString *dp_DigitalBetRefreshNofify;
extern NSString *dp_ThirdLoginSuccess;
extern NSString *dp_ThirdShareSuccess;
extern NSString *dp_ThirdOauthUserIDKey;
extern NSString *dp_ThirdOauthAccessToken;
extern NSString *dp_ThirdType;
extern NSString *dp_ThirdShareFinishKey;
extern NSString *dp_ThirdShareResultKey;
extern NSString *dp_NetworkStatusCheckKey;
extern NSString *dp_NetworkStatusInfoKey;

#define kAppDelegate                    ((DPAppDelegate *)[[UIApplication sharedApplication] delegate])
#define kRootController                 ([(DPAppDelegate *)[[UIApplication sharedApplication] delegate] rootController])
#define kIsUserLogin                    (CFrameWork::GetInstance()->IsUserLogin())

#pragma mark - 服务器地址
extern NSString *kServerBaseURL;
extern NSString *kServerWebSocket;
extern NSString *kServerURLPrefix;
extern NSString *kServerAddr;
extern NSInteger kServerPort;

#pragma mark - URL地址

// 帮助中心
#define kHelpCenterURL                  [kServerBaseURL stringByAppendingString:@"/web/help/list"]
// 提款注意事项
#define kDrawAttentionURL               [kServerBaseURL stringByAppendingString:@"/web/help/DrawAttention"]
// 提款注意事项
#define kDrawPoundageURL               [kServerBaseURL stringByAppendingString:@"/web/help/DrawFeeAttention"]
// 红包说明页面
#define kHongbaoIntroduceURL            [kServerBaseURL stringByAppendingString:@"/web/help/HongbaoIntroduce"]
// 认购协议
#define kPayAgreementURL                [kServerBaseURL stringByAppendingString:@"/web/help/Rgxy"]
// 注册服务协议
#define kRegisterAgreementURL           [kServerBaseURL stringByAppendingString:@"/web/help/Fuwuxy"]
// 支付宝网页充值
#define kAlipayTopupURL                 [kServerBaseURL stringByAppendingString:@"/account/AlipayTopup"]
// 优化投注说明页
#define kYhIntroduce                    [kServerBaseURL stringByAppendingString:@"/web/help/YhIntroduce"]

// 玩法说明
#define kPlayIntroduceURL(gameType_internal_)   [kServerBaseURL stringByAppendingFormat:@"/web/help/PlayIntroduce?gameTypeId=%d", gameType_internal_]
// 未支付订单
//#define kUnpaidURL(orderId_internal_, token_internal_)  [kServerBaseURL stringByAppendingFormat:@"/web/services/pay?purchaseOrderId=%d&userToken=%@", orderId_internal_, token_internal_]

// 未支付订单且余额够
#define kUnpaidURL(order_token_) [kServerBaseURL stringByAppendingFormat:@"/web/services/ActivateConfirmPay?token=%@", order_token_]

// 支付宝未支付地址
#define kAlipayTopupPayURL(token_) \
    [kServerBaseURL stringByAppendingFormat:@"/web/services/AlipayTopup?token=%@", (token_)]

// 确认支付
#define kConfirmPayURL(buyType_internal_, token_internal_)  [kServerBaseURL stringByAppendingFormat:@"/web/services/confirmpay?BuyType=%d&Token=%@", buyType_internal_, token_internal_]

#endif
