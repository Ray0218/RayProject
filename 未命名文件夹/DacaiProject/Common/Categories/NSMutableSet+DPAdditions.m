//
//  NSMutableSet+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSMutableSet+DPAdditions.h"

@implementation NSMutableSet (DPAdditions)

- (BOOL)dp_turnObject:(id)object {
    if ([self containsObject:object]) {
        [self removeObject:object];
        return NO;
    } else {
        [self addObject:object];
        return YES;
    }
}

@end
