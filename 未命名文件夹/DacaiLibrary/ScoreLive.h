//
//  ScoreLive.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__ScoreLive__
#define __DacaiProject__ScoreLive__

#include <iostream>
#include <vector>
#include <deque>
#include <string>
#include <set>
#include "include/json/json.h"
#include "ModuleBase.h"
#include "NetLevel.h"
#include "ModuleNotify.h"

#define LIVE_REFHRES        1
#define LIVE_REF_ATTENTION  2
#define LIVE_ATTENTION      3

using namespace std;

class CLiveGameGroup;
class CLiveBaseTarget;
class CLiveEventNotify;
class CScoreLive : public CModuleBase, public CNotify, public WorkSleave {
public:
    CScoreLive() {}
    ~CScoreLive() {}
    
public:
    /**
     *  刷新比分直播列表数据
     *
     *  @param gameName [in]期号, 可以缺省传0, 北单、竞彩、篮彩格式:20140202, 足彩格式:14053
     *
     *  @return cmdId
     */
    int Net_Refresh();
    /**
     *  刷新比分直播关注列表
     *
     *  @return cmdId
     */
    int Net_RefreshAttention();
    /**
     *  关注
     *
     *  @param matchId   [in]赛事id
     *  @param attention [in]是否关注
     *  @param reamtime  [in]指明当取消关注时, 是否要直接从列表中删除改场比赛
     *
     *  @return cmdId
     */
    int Net_Attention(const int matchId, const bool attention, const bool realtime = false);
    
    int Clear();
public:
    /**
     *  启动服务(轮询比分直播数据更新)
     */
    int StartServices();
    /**
     *  停止服务(轮询比分直播数据更新)
     */
    int StopServices();
    
    /**
     *  设置彩种
     *
     *  @param gameType [in]彩种
     *
     *  @return <0表示失败, >=表示成功
     */
    int SetGameType(int gameType);
    
    /**
     *  设置期号
     *
     *  @param gameIndex [in]期号索引
     *
     *  @return <0表示失败, >=表示成功
     */
    int SetGameIndex(int gameIndex);
    int GetGameIndex() {
        return mGameIndex;
    }
    int GetGameNames(vector<string> &gameNames);
    
    /**
     *  获取比赛场数
     *
     *  @param tab [in]标签, 1:比赛中, 2:已结束, 3:未开始, 4:关注
     *
     *  @return <0表示失败, >=0表示比赛场数
     */
    int GetMatchCount(int tab);
    /**
     *  获取比赛id
     *
     *  @param tab     [in]标签, 1:比赛中, 2:已结束, 3:未开始, 4:关注
     *  @param index   [in]索引
     *  @param matchId [out]比赛id
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchId(int tab, int index, int &matchId);
    /**
     *  获取比赛基本信息(足球, 篮球通用)
     *
     *  @param tab             [in]标签, 1:比赛中, 2:已结束, 3:未开始, 4:关注
     *  @param index           [in]索引
     *  @param attention       [out]是否关注
     *  @param orderNumberName [out]序号
     *  @param competitionName [out]赛事名称
     *  @param startTime       [out]开始时间
     *  @param homeName        [out]主队队名
     *  @param awayName        [out]客队队名
     *  @param homeRank        [out]主队排名
     *  @param awayRank        [out]客队排名
     *  @param homeLogo        [out]主队图标
     *  @param awayLogo        [out]客队图标
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchBaseInfo(int tab, int index, bool &attention, string &orderNumberName, string &competitionName, string &startTime, string &homeName, string &awayName, string &homeRank, string &awayRank, string &homeLogo, string &awayLogo);
    /**
     *  获取足球
     *
     *  @param tab           [in]标签, 1:比赛中, 2:已结束, 3:未开始, 4:关注
     *  @param index         [in]索引
     *  @param matchStatus   [out]赛事状态  0:未开始, 11:上半场正在进行, 21:上半场已经结束, 31:下半场正在进行, 41:下半场已经结束, 95:中断, 96:待定, 97:腰折, 98:推迟, 99:已取消
     *  @param homeScore     [out]主队得分
     *  @param awayScore     [out]客队得分
     *  @param homeHalfScore [out]主队半场得分
     *  @param awayHalfScore [out]客队半场得分
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchFootballInfo(int tab, int index, string &startTime, string &halfStartTime, int &matchStatus, int &homeScore, int &awayScore, int &homeHalfScore, int &awayHalfScore);
    
    int GetMatchFootballOnTime(int tab, int index, string &startTime, string &halfStartTime, int &matchStatus);
    
    /**
     *  获取足球赛事事件
     *
     *  @param tab    [in]标签, 1:比赛中, 2:已结束, 3:未开始, 4:关注
     *  @param index  [in]索引
     *  @param time   [out]发生时间
     *  @param player [out]球员
     *  @param event  [out]事件  1:进球, 2:红牌, 3:黄牌, 6:进球不算, 7:点球, 8:乌龙, 9:红牌(2黄牌→红牌)
     *  @param isHome [out]是否是主队时间
     *
     *  @return <0表示失败, >=0表示成功, 即事件数
     */
    int GetMatchFootballEvent(int tab, int index, vector<int> &time, vector<string> &player, vector<int> &event, vector<int> &isHome);
    
    /**
     *  获取篮球比分、赛事状态
     *
     *  @param tab         [in]标签, 1:比赛中, 2:已结束, 3:未开始, 4:关注
     *  @param index       [in]索引
     *  @param matchStatus [out]赛事状态  0:未开赛, 1:第一节, -1:第一节中场休息, 2:第二节, -2:第二节中场休息, 3:第三节, -3:第三节中场休息, 4:第四节, -4:第四节中场休息, 5:加时赛, 9:比赛结束(完场), 11:包含加时的完场比赛
     *  @param homeScore   [out]主队当前得分
     *  @param awayScore   [out]客队当前得分
     *  @param onTime      [out]进行时间
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchBasketInfo(int tab, int index, int &matchStatus, int &homeScore, int &awayScore, int &onTime);
    
    /**
     *  获取篮球比分信息
     *
     *  @param tab         [in]标签, 1:比赛中, 2:已结束, 3:未开始, 4:关注
     *  @param index       [in]索引
     *  @param matchStatus [out]赛事状态  0:未开赛, 1:第一节, -1:第一节中场休息, 2:第二节, -2:第二节中场休息, 3:第三节, -3:第三节中场休息, 4:第四节, -4:第四节中场休息, 5:加时赛, 9:比赛结束(完场), 11:包含加时的完场比赛
     *  @param homeName    [out]主队名
     *  @param awayName    [out]客队名
     *  @param homeScore   [out]主队各节得分
     *  @param awayScore   [out]客队各节得分
     *  @param scoreDiff   [out]分差
     *  @param scoreTotal  [out]总分
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchBasketScore(int tab, int index, int &matchStatus, string &homeName, string &awayName, int homeScore[5], int awayScore[5], int &scoreDiff, int &scoreTotal);
    
    /**
     *  获取过滤器
     *
     *  @param origCompetition [out]所有的赛事
     *  @param currCompetition [out]选中的赛事
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetCompetitionFilter(vector<string> &origCompetition, vector<string> &currCompetition);
    /**
     *  设置过滤条件
     *
     *  @param currCompetition [in]选中的赛事
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetCompetitionFilter(vector<string> currCompetition);
    /**
     *  获取用户关注的比赛数
     *
     *  @return <0表示失败, >=0表示成功, 即比赛数
     */
    size_t GetAttentionCount() const;
    /**
     *  获取事件总数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetEventCount();
    /**
     *  从队列中取出事件
     *
     *  @param matchId     [out]赛事id
     *  @param homeOrAway  [out]是否是主队事件
     *  @param homeScore   [out]主队得分
     *  @param awayScore   [out]客队得分
     *  @param time        [out]发生时间
     *  @param homeName    [out]主队名
     *  @param awayName    [out]客队名
     *  @param orderName   [out]序列号
     *  @param competition [out]赛事名
     *
     *  @return <0表示无事件, >=0表示成功
     */
    int PopEventNotify(int &matchId, int &homeOrAway, int &homeScore, int &awayScore, int &time, string &omeName, string &awayName, string &orderName, string &competition);
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    
    int _dealNotifyRefresh(DCHttpRes &res, int gameType);
    int _dealNotifyRefAttention(DCHttpRes &res);
    int _dealNotifyAttention(DCHttpRes &res);
    
    virtual int PrepareSend(string &head, string &body);
    virtual int SendDone(DCHttpRes &res, int tag);
    
    int _parserFootball(const Json::Value &jMatches, vector<CLiveBaseTarget *> &matches);
    int _parserBasketball(const Json::Value &jMatches, vector<CLiveBaseTarget *> &matches);
    
    // 返回值表示是否通知上层该事件
    bool _parserFootballEvent(const Json::Value &jItem, CLiveBaseTarget *base_target);
    bool _parserBasketballEvent(const Json::Value &jItem, CLiveBaseTarget *base_target);
    
    // 清除所有数据
    void _clear();
    /**
     *  生成赛事列表
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _genCompetitionList();
    /**
     *  根据赛事筛选条件生成比赛列表
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _genMatches();
    /**
     *  生成关注列表
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _genAttentionMatches();
    /**
     *  获取比赛进行状态(篮球)
     *
     *  @param matchState [in]比赛状态(服务端返回)
     *
     *  @return 0:未开始, 1:进行中, 2:已结束, 3:其他
     */
    int _getMatchProcState(int matchState);
    /**
     *  将比赛插入到指定状态的列表
     *
     *  @param target   [in]赛事对象
     *  @param proState [in]指定状态
     *
     *  @return 返回是否插入(调整列表)成功
     */
    bool _insertMatch(CLiveBaseTarget *target, CLiveGameGroup *group, int proState);
    
    vector<CLiveBaseTarget *> &_matches(int tab);
    
protected:
    int mGameType;
    int mGameIndex;
    
    // 仅仅引用mAllGroups
    vector<CLiveBaseTarget *> mNotStartMatches;
    vector<CLiveBaseTarget *> mEndedMatches;
    vector<CLiveBaseTarget *> mOngoingMatches;
    // 需要管理内存
    vector<CLiveBaseTarget *> mAttentionMatches;
    vector<CLiveGameGroup *> mAllGroups;
    vector<string> mGameNames;
    
    vector<string> mCurrCompetition;    // 当前赛事
    vector<string> mOrigCompetition;    // 所有赛事
    
    set<int> mAttentionSet;   // 关注的比赛id集合
    
    deque<CLiveEventNotify *> mEventQueue;
    string mTicks;
};


#endif /* defined(__DacaiProject__ScoreLive__) */
