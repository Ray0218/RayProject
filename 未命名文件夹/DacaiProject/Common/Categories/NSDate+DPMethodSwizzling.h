//
//  NSDate+DPMethodSwizzling.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DPMethodSwizzling)
//+ (void)dp_installMethodSwizzling;
@end

@interface NSDate (ServerTime)

+ (void)dp_correctWithTimeInterval:(NSTimeInterval)timeInterval;
+ (void)dp_correctWithDate:(NSDate *)date;

+ (instancetype)dp_date;
+ (instancetype)dp_dateWithTimeIntervalSinceNow:(NSTimeInterval)seconds;
- (NSTimeInterval)dp_timeIntervalSinceNow;

@end