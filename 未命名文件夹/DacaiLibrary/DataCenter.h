//
//  DataCenter.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  数据中心
//

#ifndef __DacaiProject__DataCenter__
#define __DacaiProject__DataCenter__

#include <iostream>
#include <vector>
#include <string>
#include <string.h>
#include "include/json/json.h"
#include "ModuleBase.h"
#include "NetLevel.h"
#include "ModuleNotify.h"
#include "tool.h"

#define FOOTBALLCENTER_MATCHINFO        7
#define FOOTBALLCENTER_COMPETITION      1
#define FOOTBALLCENTER_ANALYSIS         2
#define FOOTBALLCENTER_STANDINGS        3
#define FOOTBALLCENTER_ODDSHANDICAP     4
#define FOOTBALLCENTER_PROFITANDLOSS    5
#define FOOTBALLCENTER_ODDSDETAIL       6

#define BASKETBALL_MATCHIFO     10
#define BASKETBALL_COMPETITION  11
#define BASKETBALL_AGAINST      12
#define BASKETBALL_SOCREBOARD   13
#define BASKETBALL_ODDSHANDICAP 14
#define BASKETBALL_ODDSDETAIL   15

using namespace std;

#pragma mark - 足球数据中心

class CFootballCenter : public CModuleBase, public CNotify {
public:
    CFootballCenter() {}
    ~CFootballCenter() {
        mCompetition.clear();
    }
    
public:
    /**
     *  刷新数据中心数据
     *
     *  @param matchId [in]比赛id
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshMatchInfo(int matchId);
    int RefreshComeptition(int matchId);
    int RefreshAnalysis(int matchId);
    int RefreshStandings(int matchId);
    int RefreshOddsHandicap(int matchId, int type);
    int RefreshBreakeven(int matchId);
    
    /**
     *  指数接口
     *
     *  @param matchId    [in]比赛id
     *  @param companyIdx [in]公司索引
     *  @param type       [in]类型,  1:欧赔, 2:亚盘, 3:大小球
     *
     *  @return cmdId
     */
    int Net_RefreshOdds(int matchId, int companyIdx, int type);
    
    /**
     *  清空数据中心数据
     */
    void Clear();
    
public:
    /**
     *  对阵基本信息
     *
     *  @param homeImage     [out]主队队标  e.g. "http://cdn.dacai.cn/footballimages/TeamImg/551/Team.gif"
     *  @param awayImage     [out]客队队标  e.g. "http://cdn.dacai.cn/footballimages/TeamImg/444/Team.gif"
     *  @param homeName      [out]主队对名  e.g. "埃弗顿"
     *  @param awayName      [out]客队队名  e.g. "切尔西"
     *  @param homeRank      [out]主队排名  e.g. "13"
     *  @param awayRank      [out]客队排名  e.g. "3"
     *  @param startTime     [out]比赛开始时间    e.g. "2014-08-31 00:30:00"
     *  @param matchStatusId [out]比赛状态. 0:未开始, 无比分, 11:上半场进行中, 21:上半场结束, 31:下半场进行中, 41:下半场结束, 95:中断, 96:待定, 无比分, 97:夭折, 98:推迟, 无比分, 99:已取消, 无比分
     *  @param homeScore     [out]主队全场得分
     *  @param awayScore     [out]客队全场得分
     *  @param homeHalfScore [out]主队半场得分
     *  @param awayHalfScore [out]客队半场得分
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchInfo(string &homeImage, string &awayImage, string &homeName, string &awayName, string &homeRank, string &awayRank, string &startTime, string &halfStartTime, int &matchStatusId, int &homeScore, int &awayScore, int &homeHalfScore, int &awayHalfScore);
    
#pragma mark - 赛事实况
    /**
     *  获取比赛事件数
     *
     *  @return <0表示失败, >=0表示成功, 即比赛事件数
     */
    int GetEventCount();
    /**
     *  获取比赛事件信息
     *
     *  @param index  [in]索引
     *  @param code   [out]事件ID  1:进球, 2:红牌, 3:黄牌, 6:进球不算, 7:点球, 8:乌龙, 9:红牌(2黄牌->红牌)
     *  @param player [out]球员 e.g. "迭戈.科斯塔"
     *  @param time   [out]时间 e.g. 56
     *  @param isHome [out]是否是主队事件, 0:客队事件, 1:主队事件
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetEventItem(int index, int &code, string &player, int &time, int &isHome);
    
#pragma mark - 技术统计
    /**
     *  获取技术统计数
     *
     *  @return <0表示失败, >=0表示成功, 即技术统计数
     */
    int GetStatisticsCount();
    /**
     *  获取技术统计信息
     *
     *  @param index     [in]索引
     *  @param name      [out]统计类型名称  e.g. 射门次数
     *  @param homeCount [out]主队所占比(0~100)  e.g. 40
     *  @param awayCount [out]客队所占比(0~100)  e.g. 60
     *  @param homeText  [out]主队显示文字  e.g. "2"
     *  @param awayText  [out]客队显示文字  e.g. "3"
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetStatisticsItem(int index, string &name, int &homeCount, int &awayCount, string &homeText, string &awayText);
    
#pragma mark - 首发阵容
    /**
     *  获取比赛阵型
     *
     *  @param homeFormation [out]主队阵型  e.g. "4-4-3"
     *  @param awayFormation [out]客队阵型  e.g. "2-4-5"
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetFormation(string &homeFormation, string &awayFormation);
    /**
     *  获取首发球员数
     *
     *  @param home [in]是否是主队, 0:客队, 1:主队
     *
     *  @return <0表示失败, >=0表示成功, 即球员数
     */
    int GetStartPlayerCount(bool home);
    /**
     *  获取首发球员信息
     *
     *  @param index  [in]索引
     *  @param home   [in]是否是主队, 0:客队, 1:主队
     *  @param number [out]球员号码
     *  @param player [out]球员名
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetStartPlayerItem(int index, bool home, int &number, string &player);
    
#pragma mark - 替补阵容
    /**
     *  获取替补球员数
     *
     *  @param home [in]是否是主队, 0:客队, 1:主队
     *
     *  @return <0表示失败, >=0表示成功, 即球员数
     */
    int GetBenchPlayerCount(bool home);
    /**
     *  获取替补球员信息
     *
     *  @param index  [in]索引
     *  @param home   [in]是否是主队, 0:客队, 1:主队
     *  @param number [out]球员号码
     *  @param player [out]球员名
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetBenchPlayerItem(int index, bool home, int &number, string &player);
    
#pragma mark - 近期交锋
    /**
     *  获取指定对阵类型数目
     *
     *  @param type [in]对阵类型, 0:历史交锋, 1:主队近期战绩, 2:客队近期战绩, 3:主队未来对阵, 4:客队未来对阵
     *
     *  @return <0表示失败, >=0表示成功, 即数目
     */
    int GetAgainstCount(int type);
    /**
     *  获取对阵信息
     *
     *  @param type        [in]对阵类型, 0:历史交锋, 1:主队近期战绩, 2:客队近期战绩, 3:主队未来对阵, 4:客队未来对阵
     *  @param index       [in]类型
     *  @param competition [out]赛事名
     *  @param startTime   [out]开赛时间
     *  @param homeName    [out]主队名
     *  @param awayName    [out]客队名
     *  @param homeScore   [out]主队得分
     *  @param awayScore   [out]客队得分
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetAgainstInfo(int type, int index, string &competition, string &startTime, string &homeName, string &awayName, int &homeScore, int &awayScore);
    /**
     *  获取对阵统计信息
     *
     *  @param type      [in]对阵类型, 0:历史交锋, 1:主队近期战绩, 2:客队近期战绩, 3:主队未来对阵, 4:客队未来对阵
     *  @param teamName  [out]球队名
     *  @param totalWin  [out]主客场胜场数
     *  @param totalTie  [out]主客场平场数
     *  @param totalLose [out]主客场负场数
     *  @param homeWin   [out]主场胜场数
     *  @param homeTie   [out]主场平场数
     *  @param homeLose  [out]主场负场数
     *
     *  @return <0表示失败, >=0表示成功, 1表示胜平负无统计数据
     */
    int GetAgainstStatistics(int type, string &teamName, int &totalWin, int &totalTie, int &totalLose, int &homeWin, int &homeTie, int &homeLose);
    
#pragma mark - 积分榜
    /**
     *  获取积分榜标题
     *
     *  @param title [out]积分榜标题
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetStandingsTitle(string &title);
    /**
     *  获取积分榜球队数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetStandingsCount();
    /**
     *  获取积分榜的球队积分信息
     *
     *  @param index       [in]索引
     *  @param orderNumber [out]排名
     *  @param teamName    [out]球队名
     *  @param total       [out]比赛总场数
     *  @param win         [out]赢球次数
     *  @param tie         [out]平局次数
     *  @param lose        [out]输球次数
     *  @param point       [out]积分
     *  @param color       [out]RGB HEX值
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetStandingsItem(int index, int &orderNumber, string &teamName, int &total, int &win, int &tie, int &lose, int &point, int &color);
    /**
     *  获取积分榜升降级区域信息
     *
     *  @param areaName  [out]区域名数组
     *  @param areaColor [out]区域色值数组
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetStandingsAreas(vector<string> &areaName, vector<int> &areaColor);
    
#pragma mark - 赔盘
    
    /**
     *  获取赔盘记录数
     *
     *  @param type [in]类型,  1:欧赔, 2:亚盘, 3:大小球
     *
     *  @return <0表示失败, >=0表示成功, 即记录条数
     */
    int GetOddsHandicapCount(int type);
    /**
     *  获取赔盘信息
     *
     *  @param type         [in]类型,  1:欧赔, 2:亚盘, 3:大小球
     *  @param index        [in]索引
     *  @param companyName  [out]公司名
     *  @param initOdds     [out]初赔
     *  @param currOdds     [out]最新盘口
     *  @param trends       [out]趋势
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsHandicapItem(int type, int index, string &companyName, string initOdds[3], string currOdds[3], int trends[3]);
    
    /**
     *  获取所有公司名
     *
     *  @param type     [in]类型,  1:欧赔, 2:亚盘, 3:大小球
     *  @param companys [out]公司名数组
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsCompanys(int type, vector<string> &companys);
    /**
     *  获取赔率数
     *
     *  @param type       [in]类型,  1:欧赔, 2:亚盘, 3:大小球
     *  @param companyIdx [in]公司索引
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsDetailCount(int type, int companyIdx);
    /**
     *  获取盘赔
     *
     *  @param type       [in]类型,  1:欧赔, 2:亚盘, 3:大小球
     *  @param companyIdx [in]公司索引
     *  @param rowIndex   [in]行号
     *  @param odds       [out]赔率
     *  @param trend      [out]走势
     *  @param updateTime [out]更新时间
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsDetailItem(int type, int companyIdx, int rowIndex, string odds[3], int trend[3], string &updateTime);
    
#pragma mark - 交易盈亏
    /**
     *  获取交易盈亏记录数
     *
     *  @return <0表示失败, >=0表示成功, 即记录数
     */
    int GetBreakevenCount();
    /**
     *  获取交易盈亏内容
     *
     *  @param index     [in]索引
     *  @param title     [out]项目
     *  @param amount    [out]金额
     *  @param odds      [out]赔率
     *  @param ratio     [out]比例
     *  @param breakeven [out]庄家盈亏
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetBreakevenItem(int index, string &title, string &amount, string &odds, string &ratio, string &breakeven);
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    
    int _dealNotifyMatchInfo(DCHttpRes &resp);
    int _dealNotifyCompetition(DCHttpRes &resp);
    int _dealNotifyAnalysis(DCHttpRes &resp);
    int _dealNotifyStandings(DCHttpRes &resp);
    int _dealNotifyOddsHandicap(DCHttpRes &resp, int type);
    int _dealNotifyOddsDetail(DCHttpRes &resp, int index);
    int _dealNotifyBreakeven(DCHttpRes &resp);
    
private:
    typedef struct _EventItem {
        int     EventCode;  // 1:进球, 2:红牌, 3:黄牌, 6:进球不算, 7:点球, 8:乌龙, 9:红牌(2黄牌->红牌)
        string  Player;
        int     Time;
        int     IsHome;
        
        _EventItem(Json::Value value) {
            EventCode   = value["EventCode"].asInt();
            Player      = value["Player"].asString();
            Time        = value["Time"].asInt();
            IsHome      = value["IsHome"].asInt();
        }
    } EventItem;
    typedef struct _StatisticItem {
        string  Name;
        int     HomeCount;
        int     AwayCount;
        string  HomeText;
        string  AwayText;
        
        _StatisticItem(Json::Value value) {
            Name        = value["Name"].asString();
            HomeCount   = value["HomeCount"].asInt();
            AwayCount   = value["AwayCount"].asInt();
            HomeText    = value["HomeText"].asString();
            AwayText    = value["AwayText"].asString();
        }
    } StatisticsItem;
    typedef struct _PlayerItem {
        int     Number;
        string  PlayerName;
        
        _PlayerItem(Json::Value value) {
            Number      = value["Number"].asInt();
            PlayerName  = value["PlayerName"].asString();
        }
    } PlayerItem;
    typedef struct _AgainstItem {
        string  CompetitionName;    // "英超",
        string  StartTime;          // "2010-02-11 04:00:00",
        string  HomeTeamName;       // "埃弗顿",
        string  AwayTeamName;       // "切尔西",
        int     HomeScore;          // 2,
        int     AwayScore;          // 1,
        
        _AgainstItem(Json::Value value) {
            CompetitionName = value["DCompetitionName"].asString();
            StartTime       = value["DStartTime"].asString();
            HomeTeamName    = value["DHomeTeamName"].asString();
            AwayTeamName    = value["DAwayTeamName"].asString();
            HomeScore       = value["DHomeScore"].asInt();
            AwayScore       = value["DAwayScore"].asInt();
        }
    } AgainstItem;
    typedef struct _RankItem {
        int     OrderNumber;    // 1,
        string  TeamName;       // "斯旺西",
        int     Point;          // 9,
        int     TotalMatchs;    // 3,
        int     WinMatchs;      // 3,
        int     TieMatchs;      // 0,
        int     LoseMatchs;     // 0,
        int     Color;
        _RankItem(Json::Value value) {
            OrderNumber = value["OrderNumber"].asInt();
            TeamName    = value["TeamName"].asString();
            Point       = value["Point"].asInt();
            TotalMatchs = value["TotalMatchs"].asInt();
            WinMatchs   = value["WinMatchs"].asInt();
            TieMatchs   = value["DrawMatchs"].asInt();
            LoseMatchs  = value["LoseMatchs"].asInt();
            Color       = 0xFFFFFF;
        }
    } RankItem;
    typedef struct _RankArea {
        string  Name;
        int     Color;
    } RankArea;
    
    struct SOddsItem {
        string Odds[3];
        int Trend[3];
        string UpdateTime;
    };
    
    typedef struct _HandicapItem {
        
        string  CompanyName;
        string  InitOdds[3];
        string  CurrOdds[3];
        int     Trends[3];
        int     CompanyId;
        vector<SOddsItem *> OddsList;
        
        ~_HandicapItem() {
            for (int i = 0; i < OddsList.size(); i++) {
                if (OddsList[i]) {
                    delete OddsList[i];
                    OddsList[i] = NULL;
                }
            }
            OddsList.clear();
        }
    } HandicapItem;
    typedef struct _BreakevenItem {
        string  Title;
        string  Amount;
        string  Odds;
        string  Ratio;
        string  Breakeven;
        _BreakevenItem(Json::Value value) {
            Title       = value["Name"].asString();
            Amount      = value["CJE"].asString();
            Odds        = value["PL"].asString();
            Ratio       = value["BL"].asString();
            Breakeven   = value["ZJYK"].asString();
        }
    } BreakevenItem;
    
    struct _MatchInfo {
        int     MatchId;
        int     HomeTeamId;
        string  HomeTeamName;
        int     AwayTeamId;
        string  AwayTeamName;
        string  HomeRank;
        string  AwayRank;
        string  HomeImg;
        string  AwayImg;
        string  StartTime;
        string  HalfStartTime;  
        int     MatchStatusId;  // 0:未开始, 无比分, 11:上半场进行中, 21:上半场结束, 31:下半场进行中, 41:下半场结束, 95:中断, 96:待定, 无比分, 97:夭折, 98:推迟, 无比分, 99:已取消, 无比分
        int     HomeHalfScore;
        int     HomeScore;
        int     AwayHalfScore;
        int     AwayScore;
        
        void parse(const Json::Value &value) {
            MatchId         = value["DMatchId"].asInt();
            HomeTeamId      = value["DHomeTeamId"].asInt();
            HomeTeamName    = value["DHomeTeamName"].asString();
            AwayTeamId      = value["DAwayTeamId"].asInt();
            AwayTeamName    = value["DAwayTeamName"].asString();
            HomeRank        = value["DHomeRank"].asString();
            AwayRank        = value["DAwayRank"].asString();
            HomeImg         = value["DHomeImg"].asString();
            AwayImg         = value["DAwayImg"].asString();
            StartTime       = value["DStartTime"].asString();
            HalfStartTime   = value["DHalfStartTime"].asString();
            MatchStatusId   = value["DMatchStatusId"].asInt();
            HomeHalfScore   = value["DHomeHalfScore"].asInt();
            HomeScore       = value["DHomeScore"].asInt();
            AwayHalfScore   = value["DAwayHalfScore"].asInt();
            AwayScore       = value["DAwayScore"].asInt();
        }
        
        void clear() {
            HomeTeamName.clear();
            AwayTeamName.clear();
            HomeRank.clear();
            AwayRank.clear();
            HomeImg.clear();
            AwayImg.clear();
            StartTime.clear();
            MatchId = HomeTeamId = AwayTeamId = MatchStatusId = HomeHalfScore = HomeScore = AwayHalfScore = AwayScore = 0;
        }
    } mMatchInfo;
    struct _Competition {
        vector<CFootballCenter::EventItem *>        EventItems;
        vector<CFootballCenter::StatisticsItem *>   StatisticsItems;
        string                                  HomeFormation;  // 主队阵型
        string                                  AwayFormation;  // 客队阵型
        vector<CFootballCenter::PlayerItem *>       HomeStartPlayers;
        vector<CFootballCenter::PlayerItem *>       HomeBenchPlayers;
        vector<CFootballCenter::PlayerItem *>       AwayStartPlayers;
        vector<CFootballCenter::PlayerItem *>       AwayBenchPlayers;
        
        void clear() {
            for (int i = 0; i < EventItems.size(); i++) {
                if (EventItems[i]) {
                    delete EventItems[i];
                    EventItems[i] = NULL;
                }
            }
            EventItems.clear();
            for (int i = 0; i < StatisticsItems.size(); i++) {
                if (StatisticsItems[i]) {
                    delete StatisticsItems[i];
                    StatisticsItems[i] = NULL;
                }
            }
            StatisticsItems.clear();
            for (int i = 0; i < HomeStartPlayers.size(); i++) {
                if (HomeStartPlayers[i]) {
                    delete HomeStartPlayers[i];
                    HomeStartPlayers[i] = NULL;
                }
            }
            HomeStartPlayers.clear();
            for (int i = 0; i < HomeBenchPlayers.size(); i++) {
                if (HomeBenchPlayers[i]) {
                    delete HomeBenchPlayers[i];
                    HomeBenchPlayers[i] = NULL;
                }
            }
            HomeBenchPlayers.clear();
            for (int i = 0; i < AwayStartPlayers.size(); i++) {
                if (AwayStartPlayers[i]) {
                    delete AwayStartPlayers[i];
                    AwayStartPlayers[i] = NULL;
                }
            }
            AwayStartPlayers.clear();
            for (int i = 0; i < AwayBenchPlayers.size(); i++) {
                if (AwayBenchPlayers[i]) {
                    delete AwayBenchPlayers[i];
                    AwayBenchPlayers[i] = NULL;
                }
            }
            AwayBenchPlayers.clear();
        }
    } mCompetition; // 赛事
    struct _Analysis {
        vector<CFootballCenter::AgainstItem *> PastMatches;             // 历史交锋
        vector<CFootballCenter::AgainstItem *> HomeRecentAgainsts;      // 主队近期战绩
        vector<CFootballCenter::AgainstItem *> AwayRecentAgainsts;      // 客队近期战绩
        vector<CFootballCenter::AgainstItem *> HomeFutureAgainsts;      // 主队未来对阵
        vector<CFootballCenter::AgainstItem *> AwayFutureAgainsts;      // 客队未来对阵
        
        int TotalWin[3], TotalTie[3], TotalLose[3];
        int HomeWin[3], HomeTie[3], HomeLose[3];
        
        _Analysis() {
            memset(TotalWin, 0, sizeof(TotalWin));
            memset(TotalTie, 0, sizeof(TotalTie));
            memset(TotalLose, 0, sizeof(TotalLose));
            memset(HomeWin, 0, sizeof(HomeWin));
            memset(HomeTie, 0, sizeof(HomeTie));
            memset(HomeLose, 0, sizeof(HomeLose));
        }
        void clear() {
            memset(TotalWin, 0, sizeof(TotalWin));
            memset(TotalTie, 0, sizeof(TotalTie));
            memset(TotalLose, 0, sizeof(TotalLose));
            memset(HomeWin, 0, sizeof(HomeWin));
            memset(HomeTie, 0, sizeof(HomeTie));
            memset(HomeLose, 0, sizeof(HomeLose));
            
            for (int i = 0; i < PastMatches.size(); i++) {
                if (PastMatches[i]) {
                    delete PastMatches[i];
                    PastMatches[i] = NULL;
                }
            }
            for (int i = 0; i < HomeRecentAgainsts.size(); i++) {
                if (HomeRecentAgainsts[i]) {
                    delete HomeRecentAgainsts[i];
                    HomeRecentAgainsts[i] = NULL;
                }
            }
            for (int i = 0; i < AwayRecentAgainsts.size(); i++) {
                if (AwayRecentAgainsts[i]) {
                    delete AwayRecentAgainsts[i];
                    AwayRecentAgainsts[i] = NULL;
                }
            }
            for (int i = 0; i < HomeFutureAgainsts.size(); i++) {
                if (HomeFutureAgainsts[i]) {
                    delete HomeFutureAgainsts[i];
                    HomeFutureAgainsts[i] = NULL;
                }
            }
            for (int i = 0; i < AwayFutureAgainsts.size(); i++) {
                if (AwayFutureAgainsts[i]) {
                    delete AwayFutureAgainsts[i];
                    AwayFutureAgainsts[i] = NULL;
                }
            }
            PastMatches.clear();
            HomeRecentAgainsts.clear();
            AwayRecentAgainsts.clear();
            HomeFutureAgainsts.clear();
            AwayFutureAgainsts.clear();
        }
    } mAnalysis;    // 分析
    struct _Standings {
        string  Title;
        vector<CFootballCenter::RankItem *> Items;
        vector<CFootballCenter::RankArea *> Areas;
        
        void clear() {
            for (int i = 0; i < Items.size(); i++) {
                if (Items[i]) {
                    delete Items[i];
                    Items[i] = NULL;
                }
            }
            for (int i = 0; i < Areas.size(); i++) {
                if (Areas[i]) {
                    delete Areas[i];
                    Areas[i] = NULL;
                }
            }
            Items.clear();
            Areas.clear();
        }
    } mStandings;    // 积分
    struct _OddsHandicap {
        vector<HandicapItem *> EuropeOdds;
        vector<HandicapItem *> AsianHandicap;
        vector<HandicapItem *> BigSmallPoint;
        
        void clear() {
            for (int i = 0; i < EuropeOdds.size(); i++) {
                if (EuropeOdds[i]) {
                    delete EuropeOdds[i];
                    EuropeOdds[i] = NULL;
                }
            }
            for (int i = 0; i < AsianHandicap.size(); i++) {
                if (AsianHandicap[i]) {
                    delete AsianHandicap[i];
                    AsianHandicap[i] = NULL;
                }
            }
            for (int i = 0; i < BigSmallPoint.size(); i++) {
                if (BigSmallPoint[i]) {
                    delete BigSmallPoint[i];
                    BigSmallPoint[i] = NULL;
                }
            }
            EuropeOdds.clear();
            AsianHandicap.clear();
            BigSmallPoint.clear();
        }
    } mOddsHandicap; // 赔盘
    struct _ProfitAndLoss {
        vector<CFootballCenter::BreakevenItem *> Items;
        
        void clear() {
            for (int i = 0; i < Items.size(); i++) {
                if (Items[i]) {
                    delete Items[i];
                    Items[i] = NULL;
                }
            }
            Items.clear();
        }
    } mProfitAndLoss;   // 交易盈亏
    
};

#pragma mark - 篮球数据中心

class CBasketballCenter : public CModuleBase, public CNotify {
public:
    CBasketballCenter() {
        mMatchInfo._hasData = false;
        mStatInfo._hasData = false;
        mScoreboard._hasData = false;
        mAgainstInfo._hasData = false;
        mOddsHandicap._hasData = false;
        memset(mAgainstInfo.AnainstStat, 0, sizeof(mAgainstInfo.AnainstStat));
    }
    
    int Net_RefreshMatchInfo(int matchId);
    int Net_RefreshCompetition(int matchId);
    int Net_RefreshAgainstList(int matchId);
    int Net_RefreshScoreboard(int matchId);
    int Net_RefreshOddsHandicap(int matchId);
    
    /**
     *  指数接口
     *
     *  @param matchId    [in]比赛id
     *  @param companyIdx [in]公司索引
     *  @param type       [in]类型,  1:胜负, 2:让分, 3:大小
     *
     *  @return cmdId
     */
    int Net_RefreshOdds(int matchId, int companyIdx, int type);
    
public:
    int Clear();
    
    /**
     *  获取球队名
     *
     *  @param homeName [out]主队名
     *  @param awayName [out]客队名
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchTeamName(string &homeName, string &awayName);
    /**
     *  获取赛事基本信息
     *
     *  @param competition [out]赛事
     *  @param startTime   [out]开始时间
     *  @param matchStatus [out]比赛状态
     *  @param onTime      [out]进行时间
     *  @param homeName    [out]主队名
     *  @param awayName    [out]客队名
     *  @param homeRank    [out]主队排名
     *  @param awayRank    [out]客队排名
     *  @param homeLogo    [out]主队图标
     *  @param awayLogo    [out]客队图标
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchInfo(string &competition, string &startTime, int &matchStatus, int &onTime, string &homeName, string &awayName, int &homeScore, int &awayScore, string &homeRank, string &awayRank, string &homeLogo, string &awayLogo);
    
#pragma mark - 赛事
    /**
     *  获取比赛得分
     *
     *  @param homeScore [out]主队得分
     *  @param awayScore [out]客队得分
     *
     *  @return <0表示失败, >=0表示成功, 同时表示比赛节数
     */
    int GetMatchPoint(int homeScore[5], int awayScore[5]);
    
    /**
     *  获取比赛各项最高数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchTopCount();
    /**
     *  获取比赛各项最高
     *
     *  @param index      [in]索引
     *  @param title      [out]最高项目名
     *  @param homePlayer [out]主队最高球员
     *  @param awayPlayer [out]客队最高球员
     *  @param homeTop    [out]主队最高
     *  @param awayTop    [out]客队最高
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMatchTopItem(int index, string &title, string &homePlayer, string &awayPlayer, string &homeTop, string &awayTop);
    
    /**
     *  获取技术统计数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHustleScoreCount();
    /**
     *  获取技术统计内容
     *
     *  @param index     [in]索引
     *  @param title     [out]统计项目名
     *  @param homeStat  [out]主队统计值(显示用)
     *  @param awayStat  [out]客队统计值(显示用)
     *  @param homeRatio [out]主队统计值(计算百分比用)
     *  @param awayRatio [out]客队统计值(计算百分比用)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHustleScoreItem(int index, string &title, string &homeStat, string &awayStat, int &homeRatio, int &awayRatio);
    
    /**
     *  获取球员数
     *
     *  @param type [in]类型,  1:正选, 2:后备
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetPlayerCount(int type);
    /**
     *  获取球员
     *
     *  @param type       [in]类型,  1:正选, 2:后备, 3:伤停
     *  @param index      [in]索引
     *  @param homePlayer [out]主队球员名
     *  @param awayPlayer [out]客队球员名
     *  @param homePos    [out]主队球员位置
     *  @param awayPos    [out]客队球员位置
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetPlayerItem(int type, int index, string &homePlayer, string &awayPlayer, string &homePos, string &awayPos);
    
#pragma mark - 分析
    
    /**
     *  获取历史交锋数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHistoryAgainstCount();
    /**
     *  获取历史交锋信息
     *
     *  @param totalWin   [out]总胜场数
     *  @param totalLoss  [out]总负场数
     *  @param homeWin    [out]主胜场数
     *  @param homeLoss   [out]主负场数
     *  @param bigPoint   [out]大分
     *  @param smallPoint [out]小分
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHistoryAgainstInfo(string &teamName, int &totalWin, int &totalLoss, int &homeWin, int &homeLoss, int &bigPoint, int &smallPoint);
    /**
     *  获取历史交锋内容
     *
     *  @param index           [in]索引
     *  @param competitionName [out]赛事名
     *  @param time            [out]时间
     *  @param homeName        [out]主队名
     *  @param awayName        [out]客队名
     *  @param homeScore       [out]主队得分
     *  @param awayScore       [out]客队得分
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHistoryAgainstItem(int index, string &competitionName, string &time, string &homeName, string &awayName, int &homeScore, int &awayScore);
    
    /**
     *  获取主队近期战绩数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeAgainstCount();
    /**
     *  获取主队近期战绩
     *
     *  @see GetHistoryAgainstInfo
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeAgainstInfo(string &teamName, int &totalWin, int &totalLoss, int &homeWin, int &homeLoss, int &bigPoint, int &smallPoint);
    /**
     *  获取主队近期战绩内容
     *
     *  @see GetHistoryAgainstItem
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeAgainstItem(int index, string &competitionName, string &time, string &homeName, string &awayName, int &homeScore, int &awayScore);
    
    /**
     *  获取客队近期战绩数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetAwayAgainstCount();
    /**
     *  获取客队近期战绩
     *
     *  @see GetHistoryAgainstInfo
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetAwayAgainstInfo(string &teamName, int &totalWin, int &totalLoss, int &homeWin, int &homeLoss, int &bigPoint, int &smallPoint);
    /**
     *  获取客队近期战绩内容
     *
     *  @see GetHistoryAgainstItem
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetAwayAgainstItem(int index, string &competitionName, string &time, string &homeName, string &awayName, int &homeScore, int &awayScore);
    
    /**
     *  获取主队队未来对阵数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeFutureAgainstCount();
    /**
     *  获取主队信息
     *
     *  @param teamName [out]球队名
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeFutureAgainstInfo(string &teamName);
    /**
     *  获取主队队未来对阵内容
     *
     *  @see GetHistoryAgainstItem
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetHomeFutureAgainstItem(int index, string &competitionName, string &time, string &homeName, string &awayName);
    
    /**
     *  获取客队队未来对阵数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetAwayFutureAgainstCount();
    /**
     *  获取客队信息
     *
     *  @param teamName [out]球队名
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetAwayFutureAgainstInfo(string &teamName);
    /**
     *  获取客队队未来对阵内容
     *
     *  @see GetHistoryAgainstItem
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetAwayFutureAgainstItem(int index, string &competitionName, string &time, string &homeName, string &awayName);
    
#pragma mark - 积分
    /**
     *  获取积分榜名
     *
     *  @param titles [out]积分榜名  e.g. ["东部", "西部"]
     *
     *  @return <0表示失败, >=0表示成功, 同时表示积分榜数, e.g. 2
     */
    int GetScoreboardTitles(vector<string> &titles);
    
    /**
     *  获取指定积分榜记录条数
     *
     *  @param part [in]指定第几个积分榜
     *
     *  @return <0表示失败, >=0表示成功, 即积分榜记录数
     */
    int GetScoreboardRecordCount(int part);
    /**
     *  获取积分榜内容
     *
     *  @param part        [in]指定第几个积分榜, 从0开始
     *  @param index       [in]索引, 从0开始
     *  @param order       [out]排名
     *  @param teamName    [out]球队名
     *  @param win         [out]胜场次数
     *  @param loss        [out]负场次数
     *  @param percentage  [out]胜率
     *  @param recentState [out]近期状态, <0表示连负数, >0表示连胜数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetScoreboardRecordItem(int part, int index, int &order, string &teamName, int &win, int &loss, int &percentage, string &recentState);
    
#pragma mark - OddsHandicap
    /**
     *  获取赔盘记录数
     *
     *  @param type [in]类型  1:胜负, 2:让分, 3:大小
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsHandicapCount(int type);
    /**
     *  获取赔盘记录
     *
     *  @param type    [in]类型  1:胜负, 2:让分, 3:大小
     *  @param index   [in]索引
     *  @param company [out]公司
     *  @param odds    [out]赔率
     *  @param trend   [out]走势
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsHandicapItem(int type, int index, string &company, string odds[3], int trend[3]);
    /**
     *  获取所有公司名
     *
     *  @param type     [in]类型,  1:胜负, 2:让分, 3:大小
     *  @param companys [out]公司名数组
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsCompanys(int type, vector<string> &companys);
    /**
     *  获取赔率数
     *
     *  @param type       [in]类型,  1:胜负, 2:让分, 3:大小
     *  @param companyIdx [in]公司索引
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsDetailCount(int type, int companyIdx);
    /**
     *  获取盘赔
     *
     *  @param type       [in]类型,  1:胜负, 2:让分, 3:大小
     *  @param companyIdx [in]公司索引
     *  @param rowIndex   [in]行号
     *  @param odds       [out]赔率
     *  @param trend      [out]走势
     *  @param updateTime [out]更新时间
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetOddsDetailItem(int type, int companyIdx, int rowIndex, string odds[3], int trend[3], string &updateTime);
    
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    
    int _dealNotifyMatchInfo(DCHttpRes &res);
    int _dealNotifyCompetition(DCHttpRes &res);
    int _dealNotifyAgainstList(DCHttpRes &res);
    int _dealNotifyScoreboard(DCHttpRes &res);
    int _dealNotifyOddsHandicap(DCHttpRes &res);
    int _dealNotifyOddsDetail(DCHttpRes &res, int index);
    
private:
    struct STopItem {
        string TopTitle;
        string HomePlayer;
        string AwayPlayer;
        string HomeTop;
        string AwayTop;
    };
    
    struct SStatItem {
        string StatTitle;
        string HomeStat;
        string AwayStat;
        int HomeRatio;
        int AwayRatio;
    };
    
    struct SPlayer {
        string PlayerName;
        string PlayerPos;
    };
    
    struct SAgainstItem {
        string Competition;
        string DateTime;
        string HomeTeam;
        string AwayTeam;
        int HomeScore;
        int AwayScore;
    };
    
    struct SScoreboardItem {
        int OrderNumber;
        string TeamName;
        int WinedCount;
        int LoseCount;
        string RecentState;
    };
    
    struct SOddsDetailItem {
        int Trend[3];
        string Odds[3];
        string UpdateTime;
    };
    
    struct SOddsHandicapItem {
        string CompanyName;
        string Odds[3];
        int Trend[3];
        int CompanyId;
        
        vector<SOddsDetailItem *> OddsList;
        
        ~SOddsHandicapItem() {
            for (int i = 0; i < OddsList.size(); i++) {
                if (OddsList[i]) {
                    delete OddsList[i];
                    OddsList[i] = NULL;
                }
            }
            OddsList.clear();
        }
    };
    
private:
    struct {
        string Competition;
        string StartTime;
        int MatchStatus;
        int OnTime;
        int HomeScore;
        int AwayScore;
        string HomeName;
        string AwayName;
        string HomeRank;
        string AwayRank;
        string HomeLogo;
        string AwayLogo;
        
        bool _hasData;
        void clear() {
            _hasData = false;
        }
    } mMatchInfo;       // 赛事信息
    
    struct {
        int ScoreCount;
        int HomeScore[5];
        int AwayScore[5];
        
        vector<STopItem *> TopList;
        vector<SStatItem *> StatList;
        vector<SPlayer *> HomePlayers[2];
        vector<SPlayer *> AwayPlayers[2];
        
        bool _hasData;
        void clear() {
            ScoreCount = 0; memset(HomeScore, 0, sizeof(HomeScore)); memset(AwayScore, 0, sizeof(AwayScore));
            destory_vector(TopList);
            destory_vector(StatList);
            destory_vector(HomePlayers[0]);
            destory_vector(HomePlayers[1]);
            destory_vector(AwayPlayers[0]);
            destory_vector(AwayPlayers[1]);
        }
        
    } mStatInfo;        // 统计信息
    
    struct {
        vector<SAgainstItem *> HistoryList;
        vector<SAgainstItem *> HomeRecentList;
        vector<SAgainstItem *> AwayRecentList;
        vector<SAgainstItem *> HomeFutureList;
        vector<SAgainstItem *> AwayFutureList;
        string HomeTeam;
        string AwayTeam;
        
        bool _hasData;
        struct {
            int TotalWin;
            int TotalLoss;
            int HomeWin;
            int HomeLoss;
            int BigPoint;
            int SmallPoint;
        } AnainstStat[3];
        
        void clear() {
            _hasData = false;
            destory_vector(HistoryList);
            destory_vector(HomeRecentList);
            destory_vector(AwayRecentList);
            destory_vector(HomeFutureList);
            destory_vector(AwayFutureList);
            memset(AnainstStat, 0, sizeof(AnainstStat));
        }
    } mAgainstInfo;     // 对阵信息
    
    struct {
        vector<string> BoardTitles;
        vector<vector<SScoreboardItem *> *> BoardList;
        
        bool _hasData;
        void clear() {
            _hasData = false;
            BoardTitles.clear();
            for (int i = 0; i < BoardList.size(); i++) {
                if (BoardList[i]) {
                    for (int j = 0; j < BoardList[i]->size(); j++) {
                        if ((*BoardList[i])[j]) {
                            delete (*BoardList[i])[j];
                            (*BoardList[i])[j] = NULL;
                        }
                    }
                    BoardList[i]->clear();
                    delete BoardList[i];
                    BoardList[i] = NULL;
                }
            }
            BoardList.clear();
        }
    } mScoreboard;      // 积分榜
    
    struct {
        vector<SOddsHandicapItem *> WinOrLose;
        vector<SOddsHandicapItem *> Humility;
        vector<SOddsHandicapItem *> BigOrSmall;
        
        bool _hasData;
        void clear() {
            _hasData = false;
            destory_vector(WinOrLose);
            destory_vector(Humility);
            destory_vector(BigOrSmall);
        }
    } mOddsHandicap;    // 赔盘
};

#endif /* defined(__DacaiProject__DataCenter__) */
