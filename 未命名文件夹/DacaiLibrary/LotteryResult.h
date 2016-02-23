//
//  LotteryResult.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__LotteryResult__
#define __DacaiProject__LotteryResult__

#include <iostream>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "GameTypeDefine.h"
#include "CommonMacro.h"

#define DRAW_REFRESH_HOME           0
#define DRAW_REFRESH_LIST           1
#define DRAW_REFRESH_MATCHES        2
//#define LOTTERY_

#define LOTTERY_RESULT_MAX          200
#define LOTTERY_RESULT_PAGE_SIZE    20

// 历史期号
class CResultGameTarget {
public:
    CResultGameTarget() : mGameId(0), mGameName(0) { }
    
public:
    int mGameId;
    int mGameName;
};

// 开奖结果
class CResultTarget {
public:
    CResultTarget() : mGameType(0) {}
    
    virtual ~CResultTarget() {}
public:
    int mGameType;
};

// 数字彩开奖结果
class CNumberResultTarget : public CResultTarget {
public:
    CNumberResultTarget() : mGameId(0), mGameName(0) {
        memset(mResult, 0, sizeof(mResult));
        memset(mGlobalAmount, 0, sizeof(mGlobalAmount));
        memset(mGlobalSurplus, 0, sizeof(mGlobalSurplus));
        memset(mWinCount, 0, sizeof(mWinCount));
        memset(mWinAmt, 0, sizeof(mWinAmt));
    }
    virtual ~CNumberResultTarget() {}
    
public:
    int mGameId;        // 497721,
    int mGameName;      // "14082546",
    string mDrawTime;   // "2014-08-25 16:32:00",
    int mResult[15];    // "R,D,S|03,03,05"
    
    int mGlobalAmount[2];
    int mGlobalSurplus[2];
    int mWinCount[15];
    int mWinAmt[15];
};

// 竞技彩开奖结果
class CSportsResultTarget : public CResultTarget {
public:
    CSportsResultTarget() : mHomeScore(0), mAwayScore(0) {}
    virtual ~CSportsResultTarget() {}
public:
    string mCompetitionName;    // "J2联赛",
    string mOrderNumber;        // "002",
    string mStartTime;          // "2014-08-24 17:00:00",
    string mRqs;                // "0",
    string mHomeTeamName;       // "水户蜀葵",
    string mAwayTeamName;       // "爱媛FC",
    int mHomeScore;             // 0,
    int mAwayScore;             // 0,
    string mResult;             // "1",
};

class CSportsMatchTarget {
public:
    string mHomeTeam;
    string mAwayTeam;
    string mResult;
};

class CLotteryResult : public CModuleBase, public CNotify  {
public:
    CLotteryResult();
    ~CLotteryResult();
public:
    int RefreshHome();
    int CleanupHome();
    
    int SetGameType(int gameType);
    int RefreshList(int gameId = 0, int reload = false);
    int CleanupList();
    
    int RefreshMatches(int gameId);
    int CleanupMatches();
    
public:
    /**
     *  获得开奖公告首页记录数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeCount();
    /**
     *  获取指定开奖信息的彩种类型
     *
     *  @param index    [in]开奖信息索引
     *  @param gameType [out]彩种类型
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeTarget(int index, int &gameType);
    /**
     *  获取指定开奖信息的内容(双色球、大乐透、七乐彩、七星彩、排五、排三、3D、足彩、11选5、快三、排三)
     *
     *  @param index    [in]开奖信息索引
     *  @param result   [out]彩果, 3D: 0~2为开奖号(仅有试机号时该值为-1), 3~5为试机号;  快3: 0~2为开奖号, 3~5为形态(1:方块 2:红桃 3:梅花 4:黑桃)
     *  @param gameName [out]期号
     *  @param drawTime [out]开奖时间
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeTarget(int index, int result[15], int &gameName, string &drawTime);
    /**
     *  获取指定开奖信息的内容(竞彩、篮彩、北单)
     *
     *  @param index     [in]开奖信息索引
     *  @param homeTeam  [out]主队名
     *  @param awayTeam  [out]客队名
     *  @param homeScore [out]主队得分
     *  @param awayScore [out]客队得分
     *  @param gameName  [out]期号  1:竞彩、篮彩 e.g. "2014-08-24"   2:北单 e.g. "140811"
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeTarget(int index, string &homeTeam, string &awayTeam, int &homeScore, int &awayScore, string &gameName);
    
    /**
     *  开奖信息条数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetListCount();
    /**
     *  获取指定开奖信息的内容(双色球、大乐透、七乐彩、七星彩、排五、排三、3D、足彩、11选5、快三、排三)
     *
     *  @param index    [in]开奖信息索引
     *  @param result   [out]彩果, 3D: 0~2为开奖号, 3~5为试机号;  快3: 0~2为开奖号, 3~5为形态(1:方块 2:红桃 3:梅花 4:黑桃)
     *  @param gameName [out]期号
     *  @param gameId   [out]期号id
     *  @param drawTime [out]开奖时间
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetListTarget(int index, int result[15], int &gameName, int &gameId, string &drawTime);
    /**
     *  获取指定开奖信息的内容(竞彩, 北单, 篮彩)
     *
     *  @param index          [in]开奖信息索引
     *  @param competition    [out]赛事
     *  @param orderNumber    [out]序号
     *  @param startTime      [out]开始时间
     *  @param homeTeam       [out]主队名
     *  @param awayTeam       [out]客队名
     *  @param homeScore      [out]主队得分
     *  @param awayScore      [out]客队得分
     *  @param result         [out]彩果
     *  @param regulatedValue [out]让球数、让分、总分
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetListTarget(int index, string &competition, string &orderNumber, string &startTime, string &homeTeam, string &awayTeam, int &homeScore, int &awayScore, string &result, string &regulatedValue);
    
    /**
     *  数字彩销量信息
     *
     *  @param index         [in]索引
     *  @param globalAmount  [out]总销量
     *  @param globalSurplus [out]奖池
     *  @param winCount      [out]各奖项中奖注数
     *  @param winAmt        [out]各奖项每注金额
     *  @param type          [in]当前彩种为足彩时, 0表示胜负彩, 1表示任选九, 其他彩种忽略该参数
     *
     *  @return @return <0表示失败, >=0表示成功
     */
    int GetListTargetInfo(int index, int &globalAmount, int &globalSurplus, int winCount[15], int winAmt[15], int type = 0);
    /**
     *  获取当前期期号(竞彩, 北单, 篮彩)
     *
     *  @param gameName [out]期号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetListCurrentGameName(string &gameName);
    /**
     *  北单期号数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetListGameCount();
    /**
     *  获取北单期号内容
     *
     *  @param index    [in]索引
     *  @param gameId   [out]期号id
     *  @param gameName [out]期号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetListGameId(int index, int &gameId, int &gameName);
    
    /**
     *  获取足彩对阵
     *
     *  @param index    [in]对阵序号 (0~13)
     *  @param homeName [out]主队名
     *  @param awayName [out]客队名
     *  @param result   [out]彩果
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchTarget(int index, string &homeName, string &awayName, string &result);
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    
    int _dealNotifyRefreshHome(DCHttpRes &data);
    int _dealNotifyRefreshList(DCHttpRes &data, int reload);
    int _dealNotifyRefreshMatches(DCHttpRes &data);
    
    int _loadRefreshHomeData(char *p);
    
    static CResultTarget *_serializeHome(Json::Value &value);
    static CResultTarget *_serializeList(Json::Value &value, int gameType);
    
protected:
    vector<CResultTarget *> mHomeTargets;       // 开奖公告首页
    
    int mGameType;
    int mListTotal;
    string mGameName;  // 当前期号 (北单, 竞彩, 篮彩)
    int mGameId;        // 当前期号id (北单, 竞彩, 篮彩)
    vector<CResultTarget *> mListTargets;
    vector<CResultGameTarget *> mGameTargets;   // 历史期号列表
    
    vector<CSportsMatchTarget *> mMatchTargets;   // 足彩对阵
};

#endif /* defined(__DacaiProject__LotteryResult__) */
