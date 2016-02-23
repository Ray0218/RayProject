//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#ifndef SMARTQUICKLOTTERYCELL
#define SMARTQUICKLOTTERYCELL

#include <string>
#include <vector>
#include <string.h>
#include "ModuleBase.h"

using namespace std;

#define QTYPEBIT     9   // 彩票类型
#define QSUBTYPEBIT  8   // 子玩法
#define QNOTEBIT     7   // 注数
#define QPOSBIT      6   // 位置

#define SMARTQUICKLOTTERYMAXLEN 10
//---------|2元筹码个数|10元筹码个数|50元筹码个数|预留|预留|预留|position|总注数|玩法类型|彩票类型|-------------

typedef struct _QuickDrawInfo {
    int gameName;
    int result[10];
    int drawed; // 是否已开奖
    
    _QuickDrawInfo() {
        memset(this, 0, sizeof(_QuickDrawInfo));
    }
} QuickDrawInfo;

typedef struct _QuickGameInfo {
    int gameId;
    int gameName;
    string beginBuyTime;
    string endBuyTime;
    string drawTime;
    _QuickGameInfo() {
        gameId = gameName = 0;
    }
    void clear() {
        gameId = gameName = 0;
        beginBuyTime.clear();
        endBuyTime.clear();
        drawTime.clear();
    }
} QuickGameInfo;

class CSmartQuickLotteryCell {
    friend class CBetDescriptor;
    
  public:
    CSmartQuickLotteryCell(CModuleBase *base, int type);
    int AddLottery(int target[SMARTQUICKLOTTERYMAXLEN], int note, int subType = 0);
    int InsertLottery(int index, int target[SMARTQUICKLOTTERYMAXLEN], int note, int subType = 0);
    int DelLottery(int index);
    int GetLotteryNum();
    int GetLottery(int index, int lottery[SMARTQUICKLOTTERYMAXLEN]);
    void ClearLotterys();
    void ClearGameInfo();
    static void ZeroLottery(int lottery[SMARTQUICKLOTTERYMAXLEN]);
    int NotesCalculate(int target[SMARTQUICKLOTTERYMAXLEN], int subType = 0);
    int NotesCalculate();
    int GoPay(int identifier);
    int DealNotifyGoPay(DCHttpRes & res);

  protected:
    int lotteryType;

    vector<int *> m_targets;
    CModuleBase * m_base;
    
public:
    int mFollowType;  // 0:普通代购, 1:智能追号
    int mMultiple;
    vector<int> mCapacityMultiple;  // 智能追号打倍数
    int mFollowCount;
    bool mWinedStop;
    int mGlobalSurplus;
    
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
    
    QuickGameInfo mOnsoldGame;
    QuickGameInfo mEndGame;
    QuickDrawInfo mDrawInfo[10];
};

#endif