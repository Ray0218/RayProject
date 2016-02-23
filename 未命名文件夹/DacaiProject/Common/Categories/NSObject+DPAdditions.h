//
//  NSObject+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DPAdditions)

- (id)dp_setStrongObject:(id)anObject forKey:(id)aKey;
- (id)dp_removeStrongObjectForKey:(id)aKey;
- (id)dp_strongObjectForKey:(id)aKey;

- (id)dp_setWeakObject:(id)anObject forKey:(id)aKey;
- (id)dp_removeWeakObjectForKey:(id)aKey;
- (id)dp_weakObjectForKey:(id)aKey;

@end
