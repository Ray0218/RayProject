//
//  CommonMacro.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-19.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef DacaiProject_CommonMacro_h
#define DacaiProject_CommonMacro_h

#include <string>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef __GNUC__
#define DEPRECATED __attribute__((deprecated))
#elif defined(_MSC_VER)
#define DEPRECATED __declspec(deprecated)
#else
#pragma message("WARNING: You need to implement DEPRECATED for this compiler")
#define DEPRECATED
#endif
#include <assert.h>
// 结构体偏移量
#define OFFSETOF(type, field) ((size_t)&(((type *)0)->field))

#ifdef __DEBUG

#ifdef TARGET_IDE_XCODE             // iOS

#define DbgPrint(format, ...)       printf("DacaiLibrary => " format "\n", ##__VA_ARGS__)

//#include <objc/runtime.h>
//#include <objc/message.h>
//#include <Foundation/Foundation.h>
//inline void DbgPrint(std::string format, ...) {
//    format.insert(0, "DacaiLibrary ==> ");
//    va_list ap;
//    va_start(ap, format);
//    NSString *ocFormat = [NSString stringWithUTF8String:format.c_str()];
//    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    objc_msgSend(objc_getClass("iConsole"), @selector(log:args:), ocFormat, ap);
//#pragma clang diagnostic pop
//}

#else   /* TARGET_IDE_XCODE */      // Android
#ifndef DbgPrint
#include <android/log.h>
#define DbgPrint(format, ...)       __android_log_print(ANDROID_LOG_INFO, "Lib", format, ##__VA_ARGS__)
#endif  /* DbgPrint */
#endif  /* TARGET_IDE_XCODE */

#define DbgAssert(condition)        assert(condition)


#else   /* __DEBUG */
#ifndef DbgPrint
#define DbgPrint(format, ...)       {}
#endif
#define DbgAssert(condition)        {}
#endif  /* __DEBUG */

#endif
