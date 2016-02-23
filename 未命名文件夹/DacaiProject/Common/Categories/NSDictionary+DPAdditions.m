//
//  NSDictionary+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSDictionary+DPAdditions.h"

@implementation NSDictionary (DPAdditions)

- (id)dp_safeObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    return obj == [NSNull null] ? nil : obj;
}

@end
