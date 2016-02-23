//
//  DPVerifyUtilities.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPVerifyUtilities : NSObject

/**
 *  验证是否是纯数字
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isNumber:(NSString *)string;

/**
 *  验证是否是邮箱地址
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isEmail:(NSString *)string;

/**
 *  验证是否是手机号码
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isPhoneNumber:(NSString *)string;

/**
 *  验证是否是身份证号
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isIdentifier:(NSString *)string;

/**
 *  验证是否是纯汉字
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isHanZi:(NSString *)string;

/**
 *  验证是否是纯字母(不区分大小写)
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isZiMu:(NSString *)string;

/**
 *  验证是否由字母、数字、文字组成
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isUserName:(NSString *)string;

@end
