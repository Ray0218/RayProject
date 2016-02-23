//
//  DebugMacro.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef _DACAIPROJECT_DEBUGMACRO_H__
#define _DACAIPROJECT_DEBUGMACRO_H__

#ifdef __DEBUG
#define DPLog(format, ...)      NSLog(@"DacaiProject ==> " format, ##__VA_ARGS__)
#define DPAssert(condition)     NSCAssert(condition, @"DacaiProject ==> assert fail!")
#define DPAssertMsg(condition, msg)     NSCAssert(condition, msg)
#define DPException(output)     @throw [NSException exceptionWithName:NSGenericException reason:output userInfo:nil]
#else   /* __DEBUG */
#define DPLog(...)              {}
#define DPAssert(condition)     {}
#define DPAssertMsg(condition, msg) {}
#define DPException(output)     @throw [NSException exceptionWithName:NSGenericException reason:output userInfo:nil]
#endif  /* __DEBUG */

#endif  /* _DACAIPROJECT_DEBUGMACRO_H__ */
