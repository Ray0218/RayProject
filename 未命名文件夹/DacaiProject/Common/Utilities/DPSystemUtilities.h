//
//  DPSystemUtilities.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPSystemUtilities : NSObject

/**
 *  当前系统版本
 */
+ (NSString *)systemVersion;

/**
 *  应用程序正式版本号
 */
+ (NSString *)appVersion;

/**
 *  应用程序内部版本号
 */
+ (NSString *)devVersion;

/**
 *  设备唯一标识
 */
+ (NSString *)deviceUUID;

/**
 *  是否是第一次启动该应用(首次安装, 已经未安装过)
 */
+ (BOOL)isFirstActive;

/**
 *  是否是第一次启动当前版本
 */
+ (BOOL)isFirstBootup;

@end
