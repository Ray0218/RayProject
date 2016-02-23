//
//  DPDeviceUtilities.h
//  DacaiProject
//
//  Created by WUFAN on 14-10-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  https://github.com/sebyddd/SDiPhoneVersion
//

#import <Foundation/Foundation.h>

@interface DPDeviceUtilities : NSObject

#define iOSVersionEqualTo(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define iOSVersionGreaterThan(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define iOSVersionGreaterThanOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOSVersionLessThan(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define iOSVersionLessThanOrEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

typedef NS_ENUM(NSInteger, DeviceVersion){
    iPhone4 = 3,
    iPhone4S = 4,
    iPhone5 = 5,
    iPhone5C = 5,
    iPhone5S = 6,
    iPhone6 = 7,
    iPhone6Plus = 8,
    
    iPad1 = 9,
    iPad2 = 10,
    iPadMini = 11,
    iPad3 = 12,
    iPad4 = 13,
    iPadAir = 15,
    iPadMiniRetina = 16,
    Simulator = 0
};

typedef NS_ENUM(NSInteger, DeviceSize){
    iPhone35inch = 1,
    iPhone4inch = 2,
    iPhone47inch = 3,
    iPhone55inch = 4
};

+ (DeviceVersion)deviceVersion;
+ (DeviceSize)deviceSize;
+ (NSString *)deviceName;

@end
