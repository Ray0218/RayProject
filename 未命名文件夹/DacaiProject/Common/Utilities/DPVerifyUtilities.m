//
//  DPVerifyUtilities.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPVerifyUtilities.h"

@implementation DPVerifyUtilities

+ (BOOL)isNumber:(NSString *)string {
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}

+ (BOOL)isEmail:(NSString *)string {
    return YES;
}

+ (BOOL)isPhoneNumber:(NSString *)string {
    //手机号以13，15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

+ (BOOL)isIdentifier:(NSString *)string {
    BOOL flag;
    if (string.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:string];
}

+ (BOOL)isHanZi:(NSString *)string {
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberTest evaluateWithObject:string];
}

+ (BOOL)isZiMu:(NSString *)string {
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberTest evaluateWithObject:string];
}

+ (BOOL)isUserName:(NSString *)string {
    NSString *regex = @"^[A-Za-z0-9\u4e00-\u9fa5]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberTest evaluateWithObject:string];
}

@end
