//
//  NSString+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSString+DPAdditions.h"

@implementation NSString (DPAdditions)

+ (NSString *)dp_uuidString {
    return [[NSUUID UUID] UUIDString];
}

- (NSString *)dp_joinSeparateString:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString string];
    for (int i = 0; i < string.length; i++) {
        [mutableString appendFormat:@"%c%@", [string characterAtIndex:i], i == string.length - 1 ? @"" : string];
    }
    return mutableString;
}

@end
