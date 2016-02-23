//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#ifndef SMARTDIGITALLOTTERYCELL
#define SMARTDIGITALLOTTERYCELL
#define TYPEBIT 79    // 彩票类型
#define SUBTYPEBIT 78 // 子玩法
#define BILEBIT 77    // 是否胆
#define NOTEBIT 76    // 注数
#include <string>
#include <vector>
#include <string.h>
#include "ModuleBase.h"
using namespace std;

#define SMARTDIGITALLOTTERYMAXLEN 80

typedef struct _DigitalDrawInfo {
    int gameName;
    int result[10];
    int drawed; // 是否已开奖
    
    _DigitalDrawInfo() {
        gameName = 0;
        drawed = false;
        memset(result, 0, sizeof(result));
    }
    
} DigitalDrawInfo;

typedef struct _DigitalGameInfo {
    int gameId;
    int gameName;
    string beginBuyTime;
    string endBuyTime;
    string drawTime;
    
    _DigitalGameInfo() {
        gameId = gameName = 0;
    }
    void clear() {
        gameId = gameName = 0;
        beginBuyTime.clear();
        endBuyTime.clear();
        drawTime.clear();
    }
} DigitalGameInfo;

class CSmartDigitalLotteryCell {
    friend class CBetDescriptor;

public:
    CSmartDigitalLotteryCell(CModuleBase *base, int type);
    // int SetResult(int res[SMARTDIGITALLOTTERYMAXLEN]);
    int AddLottery(int target[SMARTDIGITALLOTTERYMAXLEN], int note, int subType = 0);
    int ModifyLottery(int index, int target[SMARTDIGITALLOTTERYMAXLEN], int note, int subType = 0);
    int DelLottery(int index);
    int GetLotteryNum();
    int GetLottery(int index, int lottery[SMARTDIGITALLOTTERYMAXLEN]);
    void ClearLotterys();
    void ClearGameInfo();
    static void ZeroLottery(int lottery[SMARTDIGITALLOTTERYMAXLEN]);
    int NotesCalculate(int target[SMARTDIGITALLOTTERYMAXLEN], int subType = 0);
    int NotesCalculate();
    int GoPay(int identifier);
    int DealNotifyGoPay(DCHttpRes &data);
    
    struct {
        int PayType;    // 1:iOS 2:Andriod 未支付 3:Andriod 成功 4:iOS 未支付 5:iOS 成功
        // iOS
        int BuyType;
        string Token;
        // Andriod
        int ProjectId;
        int OrderId;
        int NeedAmt;
        string RealAmt;
        string DrawTime;
        string Tagline;
        string Event;
    } mPayInfo;
    
    int error;

protected:
    int lotteryType;

    vector<int *> m_targets;
    CModuleBase *m_base;

public:
    int mSingleAmount;
    int mMultiple;
    int mFollowCount;
    bool mWinedStop;
    int mGlobalSurplus;
    DigitalGameInfo mOnsoldGame;
    DigitalGameInfo mEndGame;
    DigitalDrawInfo mDrawInfo[10];
    
    // 合买相关
    bool mTogetherBuy;
    int mAccessType;
    int mCommission;
    int mBuyAmt;
    int mFillAmt;
};

#endif