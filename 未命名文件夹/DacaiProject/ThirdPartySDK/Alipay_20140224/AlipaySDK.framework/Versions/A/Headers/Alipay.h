//
//  Alipay.h
//  AlipayGateway
//
//  Created by 方彬 on 11/7/13.
//  Copyright (c) 2013 Alipay.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef void(^PaymentCallbackBlock)(NSString *resultStr);

typedef void(^CardManagerBlock) (UIViewController *viewController);

@interface Alipay : NSObject<UIAlertViewDelegate>


/**
 *  待支付的订单信息
 */
@property(nonatomic, copy) NSString *waitOrderStr;


/**
 *  执行处理的订单信息
 */
@property(nonatomic, copy) NSString *executeOrderStr;

/**
 *  调用方应用scheme
 */
@property(nonatomic, copy) NSString *scheme;


/**
 *  支付结果回调
 */
@property(nonatomic, copy) PaymentCallbackBlock paymentBlock;


/**
 *	PayService单例
 *
 *	@return	单例对象
 */
+ (Alipay *)defaultService;



/**
 *  调用支付宝支付接口
 *
 *  @param orderStr      订单信息字符串
 *  @param schemeStr     调用方应用scheme
 *  @param callbackBlock 支付结果信息回调
 */
- (void)pay:(NSString *)orderStr From:(NSString *)schemeStr CallbackBlock: (PaymentCallbackBlock)callbackBlock;


/**
 *  处理外调支付宝钱包支付完成回调结果回传（仅当支付不能通过极简收银台完成）
 *
 *  @param orderUrl 在UIApplicationDelegate中application:openURL:sourceApplication:annotation:将url传给SDK处理
 */
- (void)processPayResultFromAlipayclientWithOrder:(NSURL *)orderUrl;

/**
 *  当收银台存在则隐藏
 */
- (void)hideCashierIfExist;


/**
 *  当收银台存在则显示
 */
- (void)showCashierIfExist;


/**
 *  查询账号是否存在
 *
 *  @return 如果存在返回YES，反之
 */
- (void)checkAccountIfExist:(void(^)(BOOL isExist))checkResultBlock;


- (void)setUrl:(NSString *)url;


//二期

/**
 *  卡管理
 *
 *  @param infoStr          调用方信息
 *  @param cardManagerBlock 界面回调，由调用方处理显示问题
 */
- (void)cardManagerWithInfo:(NSString *)infoStr;

/**
 *  账单授权
 *
 *  @param infoStr            调用方请求授权信息
 *  @param authorizationBlock 授权结果回调
 */
- (void)authorizationBillWithInfo:(NSString *)infoStr Completion:(void(^)(NSString *token))authorizationBlock;



@end
