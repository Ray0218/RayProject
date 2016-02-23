//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef MODULENOTIFYINCLUDE
#define MODULENOTIFYINCLUDE

#ifdef TARGET_IDE_XCODE
#import "ModuleProtocol.h"
#else
#include "JniModule.h"
#endif

#define MODULE_LOTTERY_SSQ      1
#define MODULE_LOTTERY_DLT      2
#define MODULE_LOTTERY_QLC      3
#define MODULE_LOTTERY_QXC      4
#define MODULE_LOTTERY_SD       5
#define MODULE_LOTTERY_PS       6
#define MODULE_LOTTERY_PW       7
#define MODULE_LOTTERY_JXSYXW   8
#define MODULE_LOTTERY_NMGKS    9
#define MODULE_LOTTERY_SDPKS    10

#define MODULE_ACCOUNT          20
#define MODULE_SCORE_LIVE       21
#define MODULE_DATA_CENTER      22

class CNotify {
protected:
#ifdef TARGET_IDE_XCODE
    __weak id<ModuleNotify> master;
#else
    void *master;
#endif
    
public:
#ifdef TARGET_IDE_XCODE
    bool HasDelegate(id mas) {
        return mas != nil && master == mas;
    }
    int SetDelegate(id mas)
#else
    int SetDelegate(void *mas)
#endif
    {
        master = mas;
        return 0;
    }
    
#ifdef TARGET_IDE_XCODE
    int Notify(int cmdId, int result, int cmdType = 0, int module = 0);
#else
    int Notify(int cmdId, int result, int cmdType = 0, int module = 0) {
        return JNI_Notify(cmdId, result, cmdType);
    }
#endif
    
    virtual ~CNotify() {}
};

#endif
