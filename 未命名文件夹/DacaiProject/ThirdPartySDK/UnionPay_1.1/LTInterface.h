//
//  LTInterface.h
//  UnionPayLib
//
//  Created by huajian on 11-7-18.
//  Copyright 2011 联通华健网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  银联插件借口文件
 * @file    LTInterface.h  
 * @author  [clx](http://clx.org)
 * @version 1.1
 * @data    2013-08-04
 *
 * # update (更新错误提示语)
 *
 * [2013-08-05] <clx>  1.1版
 *
 *  + 1.1 版本
 * #类内容介绍
 * 调起银联插件借口类
 */

@protocol LTInterfaceDelegate;
@interface LTInterface:NSObject

/**
 * @brief 获得插件主页，调用者负责释放
 *
 * @param nType     生产测试  0 生产 1 测试
 * @param strOrder    调用报文字符串
 * @param andDelegate	支付插件代理，插件退出时会将交易结果通知商户客户端。
 *
 * @return (UIViewController *)  返回插件的ViewController实例，由调用者用naviongation 的 push 进入银联插件
 *
 */
+ (UIViewController *) getHomeViewControllerWithType:(NSInteger) nType
                                            strOrder:(NSString *)strOrder
                                         andDelegate:(id<LTInterfaceDelegate>)delegate;

@end

@protocol LTInterfaceDelegate<NSObject>
/**
 * @brief 交易插件退出回调方法，需要商户客户端实现
 *
 * @param strResult 交易结果，若为空则用户未进行交易，数据格式xml
 *
 * @return  nil
 *
 */
- (void) returnWithResult:(NSString *)strResult;

@end
