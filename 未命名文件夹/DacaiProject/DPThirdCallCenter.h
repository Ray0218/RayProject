//
//  DPThirdCallCenter.h
//  DacaiProject
//
//  Created by jacknathan on 14-12-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOpenSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
typedef enum {
    kThirdShareTypeUnknown = 0, // 未知
    kThirdShareTypeWXC,         // 微信朋友圈
    kThirdShareTypeWXF,         // 微信好友
    kThirdShareTypeSinaWB,      // 新浪微博
    kThirdShareTypeQQzone       // QQ空间
} kThirdShareType;

@interface DPThirdCallCenter : NSObject <WeiboSDKDelegate, WXApiDelegate, TencentSessionDelegate, QQApiInterfaceDelegate>
+ (instancetype)sharedInstance; 
- (void)dp_QQLogin; // qq登录
- (void)dp_QQLogout; // qq注销登录
- (void)dp_sinaWeiboLogin; // 新浪微博登录
- (void)dp_sinaWeiboLogout; // 新浪微博注销登录
- (void)dp_wxLogin; // 微信登陆
- (void)dp_aliPayLogin; // 支付宝登录
// 第三方分享
- (void)dp_shareWithType:(kThirdShareType)type title:(NSString *)title content:(NSString *)content image:(UIImage *)image urlString:(NSString *)urlString;
- (BOOL)dp_isInstalledAPPType:(kThirdShareType)type; // 是否安装相应APP客户端
@end
