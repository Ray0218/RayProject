//
//  NSArray+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSArray+DPAdditions.h"

@implementation NSArray (DPAdditions)

- (id)dp_safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void)dp_enumeratePairsUsingBlock:(void (^)(id obj1, NSUInteger idx1, id obj2, NSUInteger idx2, BOOL *stop))block {
    for (int i = 0; i < (int)self.count - 1; i++) {
        NSUInteger idx1 = i;
        NSUInteger idx2 = i + 1;
        id obj1 = self[idx1];
        id obj2 = self[idx2];
        BOOL stop = NO;

        block(obj1, idx1, obj2, idx2, &stop);

        if (stop) {
            break;
        }
    }
}

- (NSMutableArray *)dp_converObjectUsingBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))block {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.count; i++) {
        BOOL stop = NO;
        id converedObj = block(self[i], i, &stop);
        if (converedObj) {
            [array addObject:converedObj];
        }
        if (stop) {
            break;
        }
    }
    return array;
}

@end
