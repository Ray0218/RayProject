//
//  DPErrorParser.h
//  DacaiProject
//
//  Created by WUFAN on 14-10-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"

#define DPAccountErrorMsg(code_internal_) ({DbgAssert(code_internal_ < 0); NSString *msg = @"系统繁忙, 请稍后再试"; if (ret < 0 && ret > -800) msg = [DPErrorParser CommonErrorMsg:code_internal_]; else if (ret <= -800) msg = [DPErrorParser AccountErrorMsg:code_internal_]; msg;})

#define DPPaymentErrorMsg(code_internal_) ({DbgAssert(code_internal_ < 0); NSString *msg = @"系统繁忙, 请稍后再试"; if (ret < 0 && ret > -800) msg = [DPErrorParser CommonErrorMsg:code_internal_]; msg;})

#define DPGoPayErrorMsg(code_internal_) ({DbgAssert(code_internal_ < 0); NSString *msg = @"下单失败, 请稍后再试"; if (ret == ERROR_PAY_NO_GAMEID) msg = @"未获取到期号"; else if (ret == ERROR_PAY_CONTENT) msg = @"投注内容无效"; msg;})

#define DPCommonErrorMsg(code_internal_) ({DbgAssert(code_internal_ < 0); NSString *msg = @"系统繁忙, 请稍后再试"; if (ret < 0 && ret > -800) msg = [DPErrorParser CommonErrorMsg:code_internal_]; msg;})

@interface DPErrorParser : NSObject

/**
 *  Account模块错误码
 */
+ (NSString *)AccountErrorMsg:(NSInteger)code;

/**
 *  公共错误信息
 */
+ (NSString *)CommonErrorMsg:(NSInteger)code;

@end



