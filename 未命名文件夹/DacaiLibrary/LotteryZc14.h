//
//  LotteryZc14.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-7.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__LotteryZc14__
#define __DacaiProject__LotteryZc14__

#include <iostream>
#include <vector>
#include <string>
#include <string.h>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "GameTypeDefine.h"
#include "ProjectInfo.h"
class CLotteryZc14Target {
public:
    CLotteryZc14Target() {
        memset(mBetOption, 0, sizeof(mBetOption));
    }

public:
    int mDMatchId;
    int mOrderNumber;
    string mOrderNumberName;
    string mHomeTeamName;
    string mAwayTeamName;
    string mHomeTeamRank;
    string mAwayTeamRank;
    string mCompetitionName;
    string mEndTime;

    int mSpList[3];
    int mBetOption[3];
    
    struct {
        string BetProportion[3]; // 投注比例
        string PastMatches[3];   // 历史交锋
        string RecentRecord[6];  // 近期战绩
        string AverageOdds[3];   // 平均赔率
        int PastMatchesCount;
    } mAnalyze;
};

class CLotteryZc14Group {
public:
    int mGameId;
    int mGameStatusId;
    int mGameName;
    string mCombinationBuyDeadline;
    int mGlobalSurplus;

    vector<CLotteryZc14Target *> mTargets;
};

class CLotteryZc14 : public CModuleBase, public CNotify, public CProjectInfo {
    class PlayCell {
    public:
        PlayCell() {
            Options[0] = Options[1] = Options[2] = 0;
            IsDan = 0;
        }
        int OrderNumber;
        int IsDan;
        int Options[3];
        string AwayTeam;
        string HomeTeam;
        int HomeScore;
        int AwayScore;
        string Result;
    };

public:
    CLotteryZc14() : mGroupId(-1) {}

    /**
     *  刷新数据
     *
     *  @param async [in]是否异步
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Refresh();
    /**
     *  获取当前期数
     *
     *  @return <0表示失败, >=0为组的个数
     */
    int GetGameCount();
    /**
     *  设置选择的组
     *
     *  @param gameIndex [in]期号索引, 范围:0~1
     *
     *  @return <0表示失败, >=0表示成功, ERROR_InvalidTarget表示对应groupId无数据
     */
    int SetGameIndex(int gameIndex);
    /**
     *  获取组的信息
     *
     *  @param gameName                 [out]期号
     *  @param onSale                   [out]是否在售  e.g. 0:不可售, 1:在售
     *  @param combinationBuyDeadline   [out]截止时间  e.g. "2015-07-29 14:30:39"
     *  @param globalSurplus            [out]奖池
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetGameInfo(int &gameName, int &onSale, string &combinationBuyDeadline, int &globalSurplus);
    /**
     *  获取指定组中比赛的场次数
     *
     *  @return <0表示失败, >=0为组中元素的个数
     */
    int GetTargetCount();
    /**
     *  获取指定比赛的基本信息
     *
     *  @param targetId        [in]比赛编号
     *  @param homeTeamName    [out]主队队名
     *  @param awayTeamName    [out]客队队名
     *  @param homeTeamRank    [out]主队排名  e.g. "A3" or "12"
     *  @param awayTeamRank    [out]客队排名
     *  @param orderNumberName [out]编号名称
     *  @param competitionName [out]赛事名称
     *  @param endTime         [out]截止时间 e.g. "2014-08-02 16:49:00"
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetInfo(int targetId, string &homeTeamName, string &awayTeamName, string &homeTeamRank, string &awayTeamRank, string &orderNumberName, string &competitionName, string &endTime);
    /**
     *  获取数据中心信息
     *
     *  @param targetId    [in]比赛编号
     *  @param competition [out]赛事
     *  @param matchId     [out]赛事id
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetDataInfo(int targetId, string &competition, int &matchId);
    /**
     *  获取指定比赛的sp值
     *
     *  @param targetId    [in]比赛编号
     *  @param spList      [out]sp值(int值, 为实际sp*100), e.g. [479, 103, 231] ( [4.79, 1.03, 2.31] )
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetSpList(int targetId, int spList[3]);
    /**
     *  获取投注选项
     *
     *  @param targetId      [in]比赛编号
     *  @param betOption     [out]投注选项, e.g. [1, 0, 0] - 1 表示选中, 0 表示未选择
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetOption(int targetId, int betOption[3]);
    int GetTargetAnalysis(int targetId, string betProportion[3], string passMatches[3], int &count, string recentRecord[6], string averageOdds[3]);
    /**
     *  设置投注选项
     *
     *  @param targetId [in]比赛编号
     *  @param index    [in]选择项在指定彩种中的索引
     *  @param selected [in]是否选择
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetTargetOption(int targetId, int index, int selected);
    /**
     *  设置倍数
     *
     *  @param multiple [in]倍数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetMultiple(int multiple);
    /**
     *  计算注数
     *
     *  @return int
     */
    int GetNotes();
    /**
     *  合买设置
     *
     *  @param accessType [in]公开类型, 1:公开, 2:保密, 3:截止后公开, 4:跟单者公开
     *  @param commission [in]佣金, 0~10
     *  @param buyAmt     [in]认购金额, >=1
     *  @param fillAmt    [in]保底金额, >=0
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetTogetherInfo(int accessType, int commission, int buyAmt, int fillAmt);
    /**
     *  设置是否合买
     *
     *  @param isTogetherBuy [in]是否是合买方案
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetTogetherType(bool isTogetherBuy);
    /**
     *  下单
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GoPay(int identifier = 0);
    // iOS
    DEPRECATED int GetPayInfo(int &buyType, string &token);
    
#pragma mark - 只提供给iOS
    /**
     *  获取支付信息, GoPay回调
     *
     *  @param type    [out]1:iOS钱够跳web, 4:iOS未支付, 5:iOS下单成功
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetPayInfo(int &type);
    /**
     *  未支付流程
     *
     *  @param pid     [out]未支付订单id
     *  @param needAmt [out]需要的金额
     *  @param realAmt [out]用户实际金额
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetNonPayment(int &orderId, int &projectId, int &needAmt, string &realAmt);
    /**
     *  web支付流程
     *
     *  @param buyType [out]get请求参数
     *  @param token   [out]get请求参数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetWebPayment(int &buyType, string &token);
    /**
     *  支付成功
     *
     *  @param pid      [out]方案id
     *  @param drawTime [out]开奖时间
     *  @param tagline  [out]宣传语
     *  @param event    [out]宣传链接
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetSucPayment(int &projectId, string &drawTime, string &tagline,string &event);
    
    // Android
    int GetPayInfo(int &type, int &pid, string &drawTime, string &tagline,string &Event);
    int GetNonPayment(int &needAmt, string &realAmt);

    void Clear();
    /////////////////////////////////////////////方案详情
    int _projectInfoClear();

public:
    virtual int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
    int _dealProjectInfo2(DCHttpRes &res);
    int ProjectInfoClear();
    int GetPTargetNum();
    /*
	*Options  0  负 1 平 2  胜
	*/
    int GetPTarget(int index, int &OrderNumber, int &IsDan, int Options[3], string &HomeTeam, string &AwayTeam, int &AwayScore, int &HomeScore, string &Result);

protected:
    vector<PlayCell *> m_playList;

protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);

    int _dealNotifyRefresh(DCHttpRes &res);
    int _dealNotifyGoPay(DCHttpRes &res);
    
    int _calculate();
    
protected:
    vector<CLotteryZc14Group *> mGroups;
    int mGroupId;
    int mMultiple;

    // 合买相关
    bool mTogetherBuy;
    int mAccessType;
    int mCommission;
    int mBuyAmt;
    int mFillAmt;
    
    struct {
        bool NeedFigureUp;
        int Note;
        
        void reset() {
            NeedFigureUp = true;
            Note = 0;
        }
    } mCalculator;
    
    struct {
        int PayType; // 1:iOS 2:Andriod 未支付 3:Andriod 成功 4:iOS 未支付 5:iOS 成功
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
};

#endif /* defined(__DacaiProject__LotteryZc14__) */
