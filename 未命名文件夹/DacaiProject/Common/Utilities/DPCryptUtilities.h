//
//  DPCryptUtilities.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPCryptUtilities : NSObject

/**
 *  BASE64加码
 *
 *  @param data [in]原始二进制数据
 *
 *  @return 加码后的BASE64字符串
 */
+ (NSString *)base64Encode:(NSData *)data;

/**
 *  BASE64解码
 *
 *  @param base64String [in]加过码的BASE64字符串
 *
 *  @return 返回解码后的二进制数据
 */
+ (NSData *)base64Decode:(NSString *)base64String;

/**
 *  URL加码
 *
 *  @param string [in]原始URL字符串
 *
 *  @return 加码后的URL字符串
 */
+ (NSString *)URLEncode:(NSString *)string;

/**
 *  URL解码
 *
 *  @param string [in]加码过的URL字符串
 *
 *  @return 原始URL字符串
 */
+ (NSString *)URLDecode:(NSString *)string;

/**
 *  MD5
 *
 *  @param data [in]原始数据
 *
 *  @return HASH后的数据
 */
+ (NSData *)MD5:(NSData *)data;

/**
 *  将数据按16进制输出
 *
 *  @param data [in]数据
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexUpperString:(NSData *)data;

@end
