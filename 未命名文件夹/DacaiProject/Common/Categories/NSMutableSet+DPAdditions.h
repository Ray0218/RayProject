//
//  NSMutableSet+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (DPAdditions)

/**
 *  如果集合中包含指定对象, 则删除该对象, 否则添加该对象.
 *
 *  @param object [in]指定的对象
 *
 *  @return 向集合中添加了该对象则返回YES, 否者返回NO
 */
- (BOOL)dp_turnObject:(id)object;

@end
