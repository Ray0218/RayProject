//
//  NSDate+DPMethodSwizzling.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSDate+DPMethodSwizzling.h"
#import <objc/runtime.h>

static NSTimeInterval dp_SecsToBeAdded = 0;

@interface NSDate (DPMethodSwizzling_Private)

+ (instancetype)date_;
+ (instancetype)dateWithTimeIntervalSinceNow_:(NSTimeInterval)seconds;
- (instancetype)initWithTimeIntervalSinceNow_:(NSTimeInterval)seconds;  // arc 模式下非 init、new、copy 命名开头将被添加 autorelease

- (NSTimeInterval)timeIntervalSinceNow_;
+ (NSTimeInterval)timeIntervalSinceReferenceDate_;

@end

@implementation NSDate (DPMethodSwizzling)

+ (void)dp_installMethodSwizzling {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method ori_Method = NULL;
        Method new_Method = NULL;
        
        // + (instancetype)date
        ori_Method = class_getClassMethod([NSDate class], @selector(date));
        new_Method = class_getClassMethod([NSDate class], @selector(date_));
        method_exchangeImplementations(ori_Method, new_Method);
        
        // + (instancetype)dateWithTimeIntervalSinceNow
        ori_Method = class_getClassMethod([NSDate class], @selector(dateWithTimeIntervalSinceNow:));
        new_Method = class_getClassMethod([NSDate class], @selector(dateWithTimeIntervalSinceNow_:));
        method_exchangeImplementations(ori_Method, new_Method);

        // - (instancetype)initWithTimeIntervalSinceNow:
        // hook 造成 scroll view 滚动异常 - scroll view 上的 UIControl 捕获 scroll view 的 touch 事件, 从而无法滚动
        ori_Method = class_getInstanceMethod([NSDate class], @selector(initWithTimeIntervalSinceNow:));
        new_Method = class_getInstanceMethod([NSDate class], @selector(initWithTimeIntervalSinceNow_:));
        method_exchangeImplementations(ori_Method, new_Method);
        
        // - (NSTimeInterval)timeIntervalSinceNow
        ori_Method = class_getInstanceMethod([NSDate class], @selector(timeIntervalSinceNow));
        new_Method = class_getInstanceMethod([NSDate class], @selector(timeIntervalSinceNow_));
        method_exchangeImplementations(ori_Method, new_Method);
        
        // + (NSTimeInterval)timeIntervalSinceReferenceDate
        ori_Method = class_getClassMethod([NSDate class], @selector(timeIntervalSinceReferenceDate));
        new_Method = class_getClassMethod([NSDate class], @selector(timeIntervalSinceReferenceDate_));
        method_exchangeImplementations(ori_Method, new_Method);
    });
}

+ (void)correctWithTimeInterval_:(NSTimeInterval)timeInterval {
    dp_SecsToBeAdded += timeInterval;
}

+ (void)correctWithDate_:(NSDate *)date {
    dp_SecsToBeAdded += [date timeIntervalSinceDate:[NSDate date]];
}

#pragma mark - private
+ (instancetype)date_ {
    return [NSDate dateWithTimeInterval:dp_SecsToBeAdded sinceDate:[NSDate date_]];
}

+ (instancetype)dateWithTimeIntervalSinceNow_:(NSTimeInterval)seconds {
    return [NSDate dateWithTimeInterval:seconds sinceDate:[NSDate date]];
}

- (instancetype)initWithTimeIntervalSinceNow_:(NSTimeInterval)seconds {
    return [self initWithTimeInterval:dp_SecsToBeAdded sinceDate:[NSDate date]];
}

- (NSTimeInterval)timeIntervalSinceNow_ {
    return [self timeIntervalSinceDate:[NSDate date]];
}

+ (NSTimeInterval)timeIntervalSinceReferenceDate_ {
    return [[NSDate date] timeIntervalSinceReferenceDate];
}

@end


@implementation NSDate (ServerTime)

+ (void)dp_correctWithTimeInterval:(NSTimeInterval)timeInterval {
    dp_SecsToBeAdded += timeInterval;
}

+ (void)dp_correctWithDate:(NSDate *)date {
    dp_SecsToBeAdded += [date timeIntervalSinceDate:[NSDate dp_date]];
}

#pragma mark - public
+ (instancetype)dp_date {
    return [NSDate dateWithTimeInterval:dp_SecsToBeAdded sinceDate:[NSDate date]];
}

+ (instancetype)dp_dateWithTimeIntervalSinceNow:(NSTimeInterval)seconds {
    return [NSDate dateWithTimeInterval:seconds sinceDate:[NSDate dp_date]];
}

- (NSTimeInterval)dp_timeIntervalSinceNow {
    return [self timeIntervalSinceDate:[NSDate dp_date]];
}

@end
