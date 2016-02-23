//
//  SmartHighLotteryCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-7.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __SMARTHIGHLOTTERYCELL_H__
#define __SMARTHIGHLOTTERYCELL_H__

#include <iostream>
#include <string>
#include <vector>
#include "ModuleBase.h"

using namespace std;

#define SMARTHIGHLOTTERYMAXLEN 40

#define HTYPEBIT     39   // 彩票类型
#define HSUBTYPEBIT  38   // 子玩法
#define HNOTEBIT     37   // 注数

typedef struct _HighDrawInfo {
    int gameName;
    int result[10];
    int drawed; // 是否已开奖
    
    _HighDrawInfo() {
        gameName = drawed = 0;
        memset(result, 0, sizeof(result));
    }
} HighDrawInfo;

typedef struct _HighGameInfo {
    int gameId;
    int gameName;
    string beginBuyTime;
    string endBuyTime;
    string drawTime;
    _HighGameInfo() {
        gameId = gameName = 0;
    }
    void clear() {
        gameId = gameName = 0;
        beginBuyTime.clear();
        endBuyTime.clear();
        drawTime.clear();
    }
} HighGameInfo;

class CSmartHighLotteryCell {
    friend class CBetDescriptor;
    
public:
    CSmartHighLotteryCell(CModuleBase *base, int type);
    int AddLottery(int target[SMARTHIGHLOTTERYMAXLEN], int note, int subType = 0);
    int InsertLottery(int index, int target[SMARTHIGHLOTTERYMAXLEN], int note, int subType = 0);
    int DelLottery(int index);
    int GetLotteryNum();
    int GetLottery(int index, int lottery[SMARTHIGHLOTTERYMAXLEN]);
    void ClearLotterys();
    void ClearGameInfo();
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
    
    HighGameInfo mOnsoldGame;
    HighGameInfo mEndGame;
    HighDrawInfo mDrawInfo[10];
};

#endif