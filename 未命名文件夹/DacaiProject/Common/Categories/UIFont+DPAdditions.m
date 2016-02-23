//
//  UIFont+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIFont+DPAdditions.h"
#import <CoreText/CoreText.h>

BOOL dp_isSystemFontLoaded = NO;
BOOL dp_isBoldSystemFontLoaded = NO;
BOOL dp_isLightSystemFontLoaded = NO;

NSString *dp_systemFontName = @"Microsoft YaHei";
NSString *dp_boldSystemFontName = @"Microsoft YaHei Bold";
NSString *dp_lightSystemFontName = @"Microsoft YaHei Light";

@implementation UIFont (DPAdditions)

+ (BOOL)dp_registerFontWithURL:(NSString *)fontURL {
    // 下载字体
    NSData *dynamicFontData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fontURL]];
    if (!dynamicFontData) {
        return NO;
    }
    CFErrorRef error;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)dynamicFontData);
    CGFontRef font = CGFontCreateWithDataProvider(providerRef);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        //如果注册失败，则不使用
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        DPLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
        CFRelease(font);
        CFRelease(providerRef);
        return NO;
    } else {
        CFStringRef fontName = CGFontCopyFullName(font);
        DPLog(@"Successed to load font: %@", fontName);
        CFRelease(fontName);
        CFRelease(font);
        CFRelease(providerRef);
        return YES;
    }
}

+ (BOOL)dp_registerFontWithPath:(NSString *)fontPath {
    // 下载字体
    NSData *dynamicFontData = [NSData dataWithContentsOfFile:fontPath];
    if (!dynamicFontData) {
        return NO;
    }
    CFErrorRef error;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)dynamicFontData);
    CGFontRef font = CGFontCreateWithDataProvider(providerRef);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        //如果注册失败，则不使用
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        DPLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
        CFRelease(font);
        CFRelease(providerRef);
        return NO;
    } else {
        CFStringRef fontName = CGFontCopyFullName(font);
        DPLog(@"Successed to load font: %@", fontName);
        CFRelease(fontName);
        CFRelease(font);
        CFRelease(providerRef);
        return YES;
    }
}

// 默认
+ (UIFont *)dp_systemFontOfSize:(CGFloat)size {
    if (dp_isSystemFontLoaded) {
        return [UIFont fontWithName:dp_systemFontName size:size];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)dp_boldSystemFontOfSize:(CGFloat)size {
    if (dp_isBoldSystemFontLoaded) {
        return [UIFont fontWithName:dp_boldSystemFontName size:size];
    } else {
        return [UIFont boldSystemFontOfSize:size];
    }
}

+ (UIFont *)dp_lightSystemFontOfSize:(CGFloat)size {
    if (dp_isLightSystemFontLoaded) {
        return [UIFont fontWithName:dp_lightSystemFontName size:size];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)dp_regularArialOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Arial" size:size];
}

+ (UIFont *)dp_boldArialOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Arial" size:size];
}

+ (UIFont *)dp_lightArialOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Arial" size:size];
}

@end
