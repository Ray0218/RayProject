//
//  DPNotifyCapturer.m
//  DacaiProject
//
//  Created by WUFAN on 14-10-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import "DPNotifyCapturer.h"
#import "FrameWork.h"
#import "NotifyType.h"
#import "XTSideMenu.h"
#import "DPAccountViewControllers.h"
#import <AFNetworking/AFNetworking.h>

@interface DPNotifyCapturer () {
@private
}

@end

@implementation DPNotifyCapturer

+ (DPNotifyCapturer *)defaultCapturer {
    static dispatch_once_t onceToken;
    static DPNotifyCapturer *defaultCapturer;
    dispatch_once(&onceToken, ^{
        defaultCapturer = [[DPNotifyCapturer alloc] init];
    });
    return defaultCapturer;
}

- (void)startNetListener {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[[NSThread alloc] initWithTarget:self selector:@selector(_netStatusThread) object:nil] start];
    });
    
    
//    [AFNetworkReachabilityManager ]
    
}

- (void)checkServerDate {
    CFrameWork::GetInstance()->GetLotteryCommon()->RefreshServerTime();
}

- (void)_netStatusThread {
    while (true) {
        int isUsedNet;
        CFrameWork::GetInstance()->GetSysInfo(isUsedNet);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isUsedNet];
        });
        
        [NSThread sleepForTimeInterval:0.2];
    }
    
}

- (BOOL)holdup:(NSInteger)cmdId result:(NSInteger)result cmdType:(NSInteger)cmdType module:(NSInteger)module {
    DPLog(@"Notify=>>>  cmdId: %d, result: %d, cmdType: %d", cmdId, result, cmdType);
    
    if (result == ERROR_RELOGIN) {
        [SSKeychain deletePasswordForService:dp_KeychainServiceName account:dp_KeychainSessionAccount];
        if (kAppDelegate.rootController.visibleType == XTSideMenuVisibleTypeLeft) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UINavigationController *nav = (UINavigationController *)kAppDelegate.rootController.leftMenuViewController;
                if ([[nav.viewControllers lastObject] isKindOfClass:[DPLoginViewController class]] || [[nav.viewControllers lastObject] isKindOfClass:[DPRegisterViewController class]]) {
                    return;
                }
                UIViewController *personalController = [[nav viewControllers] firstObject];
                DPLoginViewController *loginController = [[DPLoginViewController alloc] init];
                loginController.homeEntry = YES;
                [nav setViewControllers:@[personalController, loginController] animated:YES];
            });
        }
    }
    
    if (cmdId == NOTIFY_SERVER_TIME) {
        if (result >= 0) {
            string time;
            CFrameWork::GetInstance()->GetLotteryCommon()->GetServerTime(time);
            NSDate *date = [NSDate dp_dateFromString:[NSString stringWithUTF8String:time.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
            [NSDate dp_correctWithDate:date];
            
            DPLog(@"date: %@", [NSDate date]);
            DPLog(@"dp_Date: %@", [NSDate dp_date]);
        } else {
            DPLog(@"请求服务器时间失败");
        }
        
        return YES;
    }
    
    if (cmdType == REFRESH || cmdId == NOTIFY_FINISH_LOTTERY || cmdId == NOTIFY_TIMEOUT_LOTTERY) {
        bool hasDelegate = NO;
        switch (module) {
            case MODULE_LOTTERY_SSQ:
                hasDelegate = CFrameWork::GetInstance()->GetDoubleChromosphere()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_DLT:
                hasDelegate = CFrameWork::GetInstance()->GetSuperLotto()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_QLC:
                hasDelegate = CFrameWork::GetInstance()->GetSevenLuck()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_QXC:
                hasDelegate = CFrameWork::GetInstance()->GetSevenStar()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_SD:
                hasDelegate = CFrameWork::GetInstance()->GetLottery3D()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_PS:
                hasDelegate = CFrameWork::GetInstance()->GetPick3()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_PW:
                hasDelegate = CFrameWork::GetInstance()->GetPick5()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_JXSYXW:
                hasDelegate = CFrameWork::GetInstance()->GetJxsyxw()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_NMGKS:
                hasDelegate = CFrameWork::GetInstance()->GetQuickThree()->HasDelegate(_delegate);
                break;
            case MODULE_LOTTERY_SDPKS:
                hasDelegate = CFrameWork::GetInstance()->GetPokerThree()->HasDelegate(_delegate);
                break;
            default:
                hasDelegate = YES;
                break;
        }
        if (!hasDelegate) {
            [_delegate Notify:cmdId result:result type:cmdType];
        }
    }
    
    return NO;
}

// 拦截返回YES, 否则返回NO
+ (BOOL)holdup:(NSInteger)cmdId result:(NSInteger)result cmdType:(NSInteger)cmdType module:(NSInteger)module {
    return [[DPNotifyCapturer defaultCapturer] holdup:cmdId result:result cmdType:cmdType module:module];
}

@end
