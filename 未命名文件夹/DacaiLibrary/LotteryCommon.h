//
//  LotteryCommon.h
//  DacaiLibrary
//
//  Created by WUFAN on 14-9-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiLibrary__HomeBuy__
#define __DacaiLibrary__HomeBuy__

#include <iostream>
#include <vector>
#include <string>
#include <string.h>
#include "include/json/json.h"
#include "ModuleBase.h"
#include "NetLevel.h"
#include "ModuleNotify.h"

#define APP_ACTIVE  20
#define SET_PUSH_CONFIG 21
#define GET_PUSH_CONFIG 22
#define APP_UPDATE  23
#define DEVICE_REG  25

using namespace std;

struct HomeBuyItem;

class CLotteryCommon : public CModuleBase, public CNotify {
protected:
    struct {
        HomeBuyItem *Ssq;
        HomeBuyItem *Dlt;
        HomeBuyItem *Qlc;
        HomeBuyItem *Qxc;
        HomeBuyItem *Ps;
        HomeBuyItem *Pw;
        HomeBuyItem *Sd;
        HomeBuyItem *Jxsyxw;
        HomeBuyItem *Nmgks;
        HomeBuyItem *Sdpks;
        HomeBuyItem *Zc14;
        HomeBuyItem *Zc9;
        HomeBuyItem *Jczq;
        HomeBuyItem *Jclq;
        HomeBuyItem *Bd;
        
        string WebURL;
        vector<string> ImageURLs;
        vector<string> ActionURLs;
        vector<string> RecentWin;
    } mHomeBuy;
    
    struct {
        string Guid;
        int UpdateType;  // 0:无新版本, 1:有新版本, 无需提示升级, 2:普通升级, 3:强制升级
        vector<string> Contents;
        string Download;
        string ImageURL;
        string Event;
        
        string LoginAds;
        string LoginEvent;
    } mAppInit;
    
    struct {
//        unsigned int ApplicationInit;
//        unsigned int DeviceRegister;
        string LastDeviceToken;
    } mRequestLog;
    
public:
    CLotteryCommon();
    /**
     *  应用启动
     *
     *  @param type [in]激活状态  0:无, 1:激活, 2:升级
     *
     *  @note callback ret:0, userToken未过期, ret:1, userToken已过期
     *
     *  @return <0表示失败, >=0表示成功, 即cmdId
     */
    int ApplicationInit(int type = 0);
    int GetAdsImage(string &imageURL, string &event);   // 广告图片
    int GetAdsLogin(string &advertise, string &event);
    
    /**
     *  注册激活
     *
     *  @return <0表示失败, >=0表示成功, 即cmdId
     */
    int DeviceRegister();
    int GetGuid(string &guid);  // 激活or升级时需要调用改接口, 并保存到本地和framework中
    
    /**
     *  获取更新信息
     *
     *  @param updateType [out]更新类型, 0:无新版本, 1:有新版本, 无需提示, 2:普通升级, 3:强制升级
     *  @param contents   [out]更新内容
     *  @param download   [out]下载地址
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetUpdateInfo(int &updateType, vector<string> &contents, string &download); // 升级信息
    
    /**
     *  首页接口
     */
    int HomeBuyRefresh();
    int GetHomeImages(vector<string> &imageURLs, vector<string> &actionURLs, string &webURL);
    /**
     *  获取指定彩种宣传内容
     *
     *  @param gameType   [in]彩种
     *  @param title      [out]宣传标题
     *  @param isTonight  [out]是否今晚开奖
     *  @param surplus    [out]奖池
     *  @param isJiaJiang [out]是否加奖
     *  @param isStop     [out]是否停售
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeEntryInfo(int gameType, string &title, bool &isTonight, string &surplus, bool &isJiaJiang, bool &isStop);
    int GetHomeRecentWin(vector<string> &recentWin);
    
    // 设置推送
    int SetPushConfig(vector<int> gameTypes, bool winActive);
    // 获取推送
    int RefPushConfig();
    int GetPushConfig(vector<int> &gameTypes, bool &winActive);
    // 获取更新信息
    int RefreshUpdateInfo();
    
    // 刷新服务器时间
    int RefreshServerTime();
    int GetServerTime(string &time);
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    
    int _dealNotifyHomeRefresh(DCHttpRes &res);
    int _dealNotifyActive(DCHttpRes &res);
    int _dealNotifySetPush(DCHttpRes &res);
    int _dealNotifyGetPush(DCHttpRes &res);
    int _dealNotifyUpdateInfo(DCHttpRes &res);
    int _dealNotifyServerTime(DCHttpRes &data);
    int _dealNotifyDeviceReg(DCHttpRes &data);
    
    int _parserHomeBuy(const char *json);
    
    struct {
        int pushType;
        bool isActivate;
        vector<int> gameTypes;
    } mResultPushConfig;
    
    string mServerTime;
};

#endif /* defined(__DacaiLibrary__HomeBuy__) */
