//
//  DPSystemUtil.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSystemUtilities.h"
#import <SSKeychain/SSKeychain.h>

typedef NS_ENUM(NSInteger, DPStartupState) {
    DPStartupStateNone = 0, // 未初始化
    DPStartupStateActive,   // 首次安装激活
    DPStartupStateUpdate,   // 升级
    DPStartupStateNormal,   // 正常使用
};

@interface DPSystemUtilities () {
@private
    NSString *_deviceUUID;
    NSString *_appVersion;
    NSString *_devVersion;
    NSString *_systemVersion;
    
    DPStartupState _startupState;
}

- (NSString *)deviceUUID;
- (NSString *)appVersion;
- (NSString *)devVersion;
- (NSString *)systemVersion;
- (BOOL)isFirstBootup;
- (BOOL)isFirstActive;

+ (instancetype)sharedUtilities;

@end

@implementation DPSystemUtilities

+ (void)load {
    [self sharedUtilities];
}

+ (instancetype)sharedUtilities {
    static DPSystemUtilities *sharedUtilities = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtilities = [[self alloc] init];
    });
    
    return sharedUtilities;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _genStartupState];
    }
    return self;
}

- (void)_genStartupState {
    NSString *lastStarupVersion = [[NSUserDefaults standardUserDefaults] objectForKey:dp_LastStartupVersionKey];
    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if ([lastStarupVersion floatValue] < [currentAppVersion floatValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:dp_LastStartupVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (lastStarupVersion == nil) {
            _startupState = DPStartupStateActive;
        } else {
            _startupState = DPStartupStateUpdate;
        }
    } else {
        _startupState = DPStartupStateNormal;
    }
}

- (NSString *)appVersion {
    if (_appVersion == nil) {
        _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _appVersion;
}

- (NSString *)devVersion {
    if (_devVersion == nil) {
        _devVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _devVersion;
}

- (NSString *)systemVersion {
    if (_systemVersion == nil) {
    }
    return _systemVersion;
}

- (NSString *)deviceUUID {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceUUID = [SSKeychain passwordForService:dp_KeychainServiceName account:dp_KeychainDeviceTokenAccount];
        
        if (_deviceUUID == nil) {
            _deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            
            [SSKeychain setPassword:_deviceUUID forService:dp_KeychainServiceName account:dp_KeychainDeviceTokenAccount];
        }
    });
    
    return _deviceUUID;
}

// 该应用是否是第一次启动
- (BOOL)isFirstActive {
    return _startupState == DPStartupStateActive;
}

// 当前版本是否是第一次启动
- (BOOL)isFirstBootup {
    return _startupState == DPStartupStateActive || _startupState == DPStartupStateUpdate;
}

//// UIKit在iOS各个版本中的版本号
//#define kUIKitVersionNumber_iOS_2_0       0x0E5
//#define kUIKitVersionNumber_iOS_2_1       0x2EB
//#define kUIKitVersionNumber_iOS_2_2       0x2F0
//#define kUIKitVersionNumber_iOS_2_2_1     0x2F1
//#define kUIKitVersionNumber_iOS_3_0       0x333
//#define kUIKitVersionNumber_iOS_3_1       0x3E8
//#define kUIKitVersionNumber_iOS_3_2       0x44C
//#define kUIKitVersionNumber_iOS_4_0       0x4B0
//#define kUIKitVersionNumber_iOS_4_1       0x514
//#define kUIKitVersionNumber_iOS_4_2_1     0x578
//#define kUIKitVersionNumber_iOS_4_2_6     0x582
//#define kUIKitVersionNumber_iOS_4_3       0x5DC
//#define kUIKitVersionNumber_iOS_5_0       0x640
//#define kUIKitVersionNumber_iOS_5_1       0x6A4
//#define kUIKitVersionNumber_iOS_6_0       0x944
//#define kUIKitVersionNumber_iOS_6_1       0x94C
//#define kUIKitVersionNumber_iOS_7_0       0xB57
//#define kUIKitVersionNumber_iOS_7_1       0xB77
//#import <mach-o/dyld.h>
//- (int32_t)UIKitVersionNumber {
//    if (_UIKitVersionNumber == 0) {
//        _UIKitVersionNumber = (NSVersionOfLinkTimeLibrary("UIKit") >> 16);
//    }
//    return _UIKitVersionNumber;
//}

#pragma mark - public interface
+ (NSString *)systemVersion {
    return [[DPSystemUtilities sharedUtilities] systemVersion];
}

+ (NSString *)deviceUUID {
    return [[DPSystemUtilities sharedUtilities] deviceUUID];
}

+ (NSString *)appVersion {
    return [[DPSystemUtilities sharedUtilities] appVersion];
}

+ (NSString *)devVersion {
    return [[DPSystemUtilities sharedUtilities] devVersion];
}

+ (BOOL)isFirstActive {
    return [[DPSystemUtilities sharedUtilities] isFirstActive];
}

+ (BOOL)isFirstBootup {
    return [[DPSystemUtilities sharedUtilities] isFirstBootup];
}

@end
