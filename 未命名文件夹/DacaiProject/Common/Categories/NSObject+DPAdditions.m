//
//  NSObject+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSObject+DPAdditions.h"
#import <objc/runtime.h>

const char *WEAK_TABLE_KEY = "WeakTableKey";
const char *STRONG_TABLE_KEY = "StrongTableKey";

@implementation NSObject (DPAdditions)

- (NSMapTable *)weakMapTable {
    return objc_getAssociatedObject(self, WEAK_TABLE_KEY);
}

- (NSMapTable *)strongMapTable {
    return objc_getAssociatedObject(self, STRONG_TABLE_KEY);
}

- (id)dp_setStrongObject:(id)anObject forKey:(id)aKey {
    NSMapTable *strongMapTable = [self strongMapTable];
    if (strongMapTable == nil) {
        strongMapTable = [NSMapTable strongToStrongObjectsMapTable];
        objc_setAssociatedObject(self, STRONG_TABLE_KEY, strongMapTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [strongMapTable setObject:anObject forKey:aKey];
    
    return anObject;
}

- (id)dp_removeStrongObjectForKey:(id)aKey {
    id  object = [[self strongMapTable] objectForKey:aKey];
    if (object) {
        [[self strongMapTable] removeObjectForKey:aKey];
    }
    return object;
}

- (id)dp_strongObjectForKey:(id)aKey {
    return [[self strongMapTable] objectForKey:aKey];
}

- (id)dp_setWeakObject:(id)anObject forKey:(id)aKey {
    NSMapTable *weakMapTable = [self weakMapTable];
    if (weakMapTable == nil) {
        weakMapTable = [NSMapTable strongToWeakObjectsMapTable];
        objc_setAssociatedObject(self, WEAK_TABLE_KEY, weakMapTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [weakMapTable setObject:anObject forKey:aKey];
    
    return anObject;
}

- (id)dp_removeWeakObjectForKey:(id)aKey {
    id  object = [[self weakMapTable] objectForKey:aKey];
    if (object) {
        [[self weakMapTable] removeObjectForKey:aKey];
    }
    return object;
}

- (id)dp_weakObjectForKey:(id)aKey {
    return [[self weakMapTable] objectForKey:aKey];
}

@end
