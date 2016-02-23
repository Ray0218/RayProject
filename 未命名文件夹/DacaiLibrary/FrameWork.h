//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#include "DoubleChromosphere.h"
#include "SuperLotto.h"
#include "Lottery3D.h"
#include "Pick3.h"
#include "Pick5.h"
#include "SevenLuck.h"
#include "SevenStar.h"
#include "QuickThree.h"
#include "PokerThree.h"
#include "Jxsyxw.h"

#include "ScoreLive.h"
#include "DataCenter.h"
#include "LotteryJczq.h"
#include "LotteryJclq.h"
#include "LotteryBd.h"
#include "LotteryZc9.h"
#include "LotteryZc14.h"

#include "Account.h"
#include "LotteryResult.h"
#include "EntryList.h"
#include "LotteryCommon.h"

#include "Math/PassModeFactor.h"

class CFrameWork {
  public:
    CFrameWork();
    static CFrameWork *GetInstance();
    static CFrameWork *me;
    int Init(char *ip, int port, char *urlPrefix = NULL, char *ipAddr = NULL);
    int UnInit();
    int GetSysInfo(int &isUsedNet);
    
public:
    // 各个模块
    CDoubleChromosphere *GetDoubleChromosphere();
    CSuperLotto *GetSuperLotto();
    CLottery3D *GetLottery3D();
    CPick3 *GetPick3();
    CPick5 *GetPick5();
    CSevenLuck *GetSevenLuck();
    CSevenStar *GetSevenStar();
    CQuickThree *GetQuickThree();
    CPokerThree *GetPokerThree();
    CJxsyxw *GetJxsyxw();
    CScoreLive *GetScoreLive();
    CFootballCenter *GetFootballCenter();
    CBasketballCenter *GetBasketballCenter();
    CLotteryJczq *GetLotteryJczq();
    CLotteryJclq *GetLotteryJclq();
    CLotteryBd *GetLotteryBd();
    CLotteryZc9 *GetLotteryZc9();
    CLotteryZc14 *GetLotteryZc14();
    CPassModeFactor *GetPassModeFactor();
    CAccount *GetAccount();
    CLotteryResult *GetLotteryResult();
    CLotteryInfo *GetLotteryInfo();
    CTogetherBuyCenter *GetTogetherBuyCenter();
    CCapacityFactor *GetCapacityFactor();
    CLotteryCommon *GetLotteryCommon();
    
	int   CmdCancel(int cmdId);
public:
    // 错误信息
    int GetLastError(string &errorMsg);
    int SetLastError(string errorMsg);
    int GetTestInfo(string & info);
    /**
     *  设置渠道ID
     *
     *  @param channel [in]渠道ID
     */
    void SetChannelId(int channel) {
        mChannelId = channel;
        
        char temp[20];
        sprintf(temp, "%d", channel);
        mStrChannelId = temp;
    }
    /**
     *  设置设备UUID
     *
     *  @param deviceToken [in]设备UUID
     */
    void SetDeviceToken(string deviceToken);
    /**
     *  设置应用版本号
     *
     *  @param version [in]应用版本号
     */
    void SetAppVersion(string version) {
        mAppVersion = version;
    }
    
    /**
     *  设置激活GUID
     *
     *  @param activeGUID [in]激活id, 激活接口中返回
     */
    void SetActiveGUID(string activeGUID) {
        mActiveGUID = activeGUID;
    }
    
public:
    // 账号信息
    bool IsUserLogin();
    int GetUserName(string &userName);
    
    // 会话
    int SetSessionContent(string content);
    int GetSessionContent(string &content);
    int CloseSession();
    
    string GetUserToken();
    
    int GetChannelId() {
        return mChannelId;
    }
    string GetDeviceToken() {
        return mDeviceToken;
    }
    string GetAppVersion() {
        return mAppVersion;
    }
    string GetActiveGUID() {
        return mActiveGUID;
    }
    string GetStrChannelId() {
        return mStrChannelId;
    }
    string GetURLPrefix() {
        return mURLPrefix;
    }
    
    int GetHTTPField(int &channelId, string &deviceToken, string &userToken, string &appVersion, string &activeGUID);
    
protected:
    friend class CAccount;
    friend class CLotteryCommon;
    friend class DCHttpReq;
    friend class CSecurityCenter;
    
    int SetSessionInfo(string userName, string token, string expire, unsigned char *key, int len);
    
private:
    int mChannelId; // 渠道id
    string mDeviceToken;    // 设备Id
    string mAppVersion;     // 应用版本
    string mActiveGUID;     // 激活GUID
    string mStrChannelId;   // 渠道id
    
    string mUserToken;
    string mUserName;
    string mExpire;
    unsigned char mDESKey[80];
    int mDESKeyLen;
    
    string mURLPrefix;    // URL路径前缀
    
protected:
    CDoubleChromosphere *doubleChromosphere;
    CSuperLotto *m_SuperLotto;
    CLottery3D *m_Lottery3D;
    CPick3 *m_Pick3;
    CPick5 *m_Pick5;
    CSevenLuck *m_SevenLuck;
    CSevenStar *m_SevenStar;
    CQuickThree *m_QuickThree;
    CPokerThree *m_PokerThree;
    CJxsyxw *m_Jxsyxw;
    CScoreLive *m_ScoreLive;
    CFootballCenter *m_FootballCenter;
    CBasketballCenter *m_BasketballCenter;
    CLotteryJczq *m_LotteryJczq;
    CLotteryJclq *m_LotteryJclq;
    CLotteryBd *m_LotteryBd;
    CLotteryZc9 *m_LotteryZc9;
    CLotteryZc14 *m_LotteryZc14;
    CPassModeFactor *m_PassModeFactor;
    CAccount *m_Account;
    CLotteryResult *m_LotteryResult;
    CLotteryInfo *m_LotteryInfo;
    CTogetherBuyCenter *m_TogetherBuyCenter;
    CCapacityFactor *m_CapacityFactor;
    CLotteryCommon *m_LotteryCommon;
    
    int initTab;
    string mLastError;
};
