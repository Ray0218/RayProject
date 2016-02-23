//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#ifndef MODULEPROTOCOL
#define MODULEPROTOCOL
#import <Foundation/Foundation.h>

#ifdef TARGET_IDE_XCODE
@protocol ModuleNotify <NSObject>
@required
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype;
@end
#endif

#endif
