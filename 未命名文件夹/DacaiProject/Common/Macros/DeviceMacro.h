//
//  CommonMacro.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DACAIPROJECT_COMMONMACOR_H__
#define __DACAIPROJECT_COMMONMACOR_H__

//#if TARGET_OS_IPHONE
//#ifndef NSFoundationVersionNumber_iOS_7_0
//#define NSFoundationVersionNumber_iOS_7_0 1047.25
//#endif  /* NSFoundationVersionNumber_iOS_7_0 */
//#ifndef NSFoundationVersionNumber_iOS_7_1
//#define NSFoundationVersionNumber_iOS_7_1 1047.25
//#endif  /* NSFoundationVersionNumber_iOS_7_1 */
//#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
//#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
//#endif  /* kCFCoreFoundationVersionNumber_iOS_6_0 */
//#ifndef kCFCoreFoundationVersionNumber_iOS_7_1
//#define kCFCoreFoundationVersionNumber_iOS_7_1 847.24
//#endif  /* kCFCoreFoundationVersionNumber_iOS_6_1 */
//#endif

// iOS SDK版本
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_8_0) )
#define IOS_SUPPORT_8_OR_ABOVE  ( __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0 )
#else
#define IOS_SUPPORT_8_OR_ABOVE  NO
#endif

// iOS OS版本
#if TARGET_OS_IPHONE
#define IOS_VERSION_5_OR_ABOVE ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_4_3 )
#define IOS_VERSION_6_OR_ABOVE ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1 )
#define IOS_VERSION_7_OR_ABOVE ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )

#if IOS_SUPPORT_8_OR_ABOVE
#define IOS_VERSION_8_OR_ABOVE ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 )
#else
#define IOS_VERSION_8_OR_ABOVE NO
#endif

#else   /* TARGET_OS_IPHONE */
#define IOS_VERSION_5_OR_ABOVE NO
#define IOS_VERSION_6_OR_ABOVE NO
#define IOS_VERSION_7_OR_ABOVE NO
#define IOS_VERSION_8_OR_ABOVE NO
#endif  /* TARGET_OS_IPHONE */

#define TARGET_DEVICE_IPHONE    YES
#define TARGET_DEVICE_IPAD      YES
#define TARGET_DEVICE_ITOUCH    YES


#define DPSuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#endif  /* __DACAIPROJECT_COMMONMACOR_H__ */
