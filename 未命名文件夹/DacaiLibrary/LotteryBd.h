//
//  LotteryBd.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  北京单场
//

#ifndef __DacaiProject__LotteryBd__
#define __DacaiProject__LotteryBd__

#include <iostream>
#include <vector>
#include <string>
#include <string.h>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "ProjectInfo.h"

using namespace std;

class CLotteryBdTarget {
public:
    CLotteryBdTarget() : mIsMark(false) {
        memset(&mBetOptionRqspf, 0, sizeof(mBetOptionRqspf));
        memset(&mBetOptionSdxs, 0, sizeof(mBetOptionSdxs));
        memset(&mBetOptionZjq, 0, sizeof(mBetOptionZjq));
        memset(&mBetOptionBf, 0, sizeof(mBetOptionBf));
        memset(&mBetOptionBqc, 0, sizeof(mBetOptionBqc));
        memset(mSpListRqspf, 0, sizeof(mSpListRqspf));
        memset(mSpListSxds, 0, sizeof(mSpListSxds));
        memset(mSpListZjq, 0, sizeof(mSpListZjq));
        memset(mSpListBf, 0, sizeof(mSpListBf));
        memset(mSpListBqc, 0, sizeof(mSpListBqc));
    }
    
public:
    int mGroupId;
    int mTargetId;
    int mGameVisible;
    
public:
    int mDMatchId;
    int mOrderNumber;
    string mOrderNumberName;
    string mHomeTeamName;
    string mAwayTeamName;
    string mHomeTeamRank;
    string mAwayTeamRank;
    bool mIsHot;
    string mCompetitionName;
    string mStartTime;
    string mEndTime;
    int mRqs;
    bool mIsMark;
    
    int mSpListRqspf[3];    // 让球胜平负
    int mSpListSxds[4];     // 上下单双
    int mSpListZjq[8];      // 总进球
    int mSpListBf[25];      // 比分
    int mSpListBqc[9];      // 半全场
    
    int mBetOptionRqspf[3]; // 让球胜平负
    int mBetOptionSdxs[4];  // 上下单双
    int mBetOptionZjq[8];   // 总进球
    int mBetOptionBf[25];   // 比分
    int mBetOptionBqc[9];   // 半全场
    
    bool mVisibledRqspf;
    bool mVisibledSxds;
    bool mVisibledZjq;
    bool mVisibledBf;
    bool mVisibledBqc;
    
    struct {
        string BetProportion[3]; // 投注比例
        string PastMatches[3];   // 历史交锋
        string RecentRecord[6];  // 近期战绩
        string AverageOdds[3];   // 平均赔率
        int PastMatchesCount;
    } mAnalyze;
};

class CLotteryBdGroup {
public:
    CLotteryBdGroup() {}
    
public:
    string mGameTime;
    vector<CLotteryBdTarget *> mTargets;
};

class CLotteryBd : public CModuleBase, public CNotify, public CProjectInfo {
	class Content{
	public:
		Content(){

		}
		string name;
		string odd;
		int ischeck;
		int win;
	};
	class Option{
	public:
		Option(){

		}
		int GameTypeId;
		string ResultSp;
		string Result;
		vector<Content *> m_content;
	};
	class PlayCell{
	public:
		PlayCell(){

			IsDan = 0;
		}
		string OrderNumberName;
		string HomeTeam;
		string AwayTeam;
		int IsDan;
		string HomeRank;
		string AwayRank;
		string Score;
		int Rqs;
		vector<Option *> m_options;
	};
public:
    CLotteryBd() : mSelectedCountRqspf(0), mSelectedCountSxds(0), mSelectedCountZjq(0), mSelectedCountBf(0), mSelectedCountBqc(0) {};
    /**
     *  刷新数据
     *
     *  @param async [in]是否异步
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Refresh();
    /**
     *  获取组的个数
     *
     *  @return <0表示失败, >=0为组的个数
     */
    int GetGroupCount();
    /**
     *  获取组的信息
     *
     *  @param groupId  [in]组编号
     *  @param gameTime [out]时间 e.g. "2014-08-02"
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetGroupInfo(int groupId, string &gameTime);
    /**
     *  获取期号
     *
     *  @param gameName [out]期号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetInfo(int &gameName);
    /**
     *  获取指定组中比赛的场次数
     *
     *  @param groupId [in]组编号
     *
     *  @return <0表示失败, >=0为组中元素的个数
     */
    int GetTargetCount(int groupId);
    /**
     *  获取指定比赛的基本信息
     *
     *  @param groupId         [in]组编号
     *  @param targetId        [in]比赛编号
     *  @param homeTeamName    [out]主队队名
     *  @param awayTeamName    [out]客队队名
     *  @param homeTeamRank    [out]主队排名  e.g. "A3" or "12"
     *  @param awayTeamRank    [out]客队排名
     *  @param orderNumberName [out]编号名称
     *  @param competitionName [out]赛事名称
     *  @param endTime         [out]截止时间 e.g. "2014-08-02 16:49:00"
     *  @param rqs             [out]让球数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetInfo(int groupId, int targetId, string &homeTeamName, string &awayTeamName, string &homeTeamRank, string &awayTeamRank, string &orderNumberName, string &competitionName, string &endTime, int &rqs);
    /**
     *  获取数据中心信息
     *
     *  @param groupId     [in]组编号
     *  @param targetId    [in]比赛编号
     *  @param competition [out]赛事
     *  @param matchId     [out]赛事id
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetDataInfo(int groupId, int targetId, string &competition, int &matchId);
    /**
     *  获取指定比赛的sp值
     *
     *  @param groupId     [in]组编号
     *  @param targetId    [in]比赛编号
     *  @param spList      [out]sp值(int值, 为实际sp*100), e.g. [479, 103, 231] ( [4.79, 1.03, 2.31] )
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetSpList(int groupId, int targetId, int spList[25]);
    /**
     *  获取投注选项
     *
     *  @param groupId       [in]组编号
     *  @param targetId      [in]比赛编号
     *  @param betOption     [out]投注选项, e.g. [1, 0, 0] - 1 表示选中, 0 表示未选择
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetOption(int groupId, int targetId, int betOption[25]);
    int GetTargetAnalysis(int groupId, int targetId, string betProportion[3], string passMatches[3], int &count, string recentRecord[6], string averageOdds[3]);
    /**
     *  设置投注选项
     *
     *  @param groupId  [in]组编号
     *  @param targetId [in]比赛编号
     *  @param index    [in]选择项在指定彩种中的索引
     *  @param selected [in]是否选择
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetTargetOption(int groupId, int targetId, int index, int selected);
    /**
     *  设置彩种类型, 即档位
     *
     *  @param gameType [in]彩种类型
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetGameType(int gameType);
    /**
     *  获取筛选信息
     *
     *  @param competitions [out]赛事列表
     *  @param rqs          [out]让球列表, 非让球胜平负玩法忽略该参数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetFilterInfo(vector<string> &competitions, vector<int> &rqs);
    /**
     *  设置筛选条件
     *
     *  @param competitions [in]赛事是否选择数组 e.g. [0, 1, 1, 1, 1, 0, 0]
     *  @param comLen       [in]赛事数组长度
     *  @param rqs          [in]让球是否选择数组, 非让球胜平负玩法忽略该参数(可以为NULL)
     *  @param rqsLen       [in]让球数组长度, 非让球胜平负玩法忽略该参数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetFilterInfo(int *competitions, int comLen, int *rqs, int rqsLen);
    
    /**
     *  获取当前可选的过关方式
     *
     *  @param freedoms [out]自由过关
     *  @param combines [out]组合过关
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetEnablePassMode(vector<int> &freedoms, vector<int> &combines);
    /**
     *  设置过关方式
     *
     *  @param passModes [in]过关方式数组
     *  @param length    [in]数组长度
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetPassMode(int *passModes, int length);
    /**
     *  获取当前过关方式
     *
     *  @param passModes [out]过关方式数组
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetPassMode(vector<int> &passModes);
    /**
     *  设置倍数
     *
     *  @param multiple [in]倍数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetMultiple(int multiple);
    /**
     *  单倍最小奖金
     *
     *  @return float
     */
    float GetMinBonus();
    /**
     *  单倍最大奖金
     *
     *  @return float
     */
    float GetMaxBonus();
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
    
    /**
     *  清空所有选项
     *
     *  @return <0表示失败, >=0表示成功
     */
    int CleanupAllOptions();
    /**
     *  获取选中的比赛场次数
     *
     *  @return <0表示失败, >=0选中的场次数
     */
    int GetSelectedCount();
    
    /////////////////////////// 中转界面使用
    /**
     *  生成中转界面数据
     *
     *  @return <0表示失败, >=0选中的场次数
     */
    int GenSelectedList();
    /**
     *  从列表中删除指定的比赛
     *
     *  @param targetId [in]比赛编号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int DelSelectedTarget(int targetId);
    /**
     *  获取列表元素个数
     *
     *  @return <0表示失败, >=0表示列表元素个数
     */
    int GetSelectedTargetCount();
    /**
     *  @see GetTargetInfo
     */
    int GetSelectedTargetInfo(int targetId, string &homeTeamName, string &awayTeamName, string &homeTeamRank, string &awayTeamRank, string &orderNumberName, string &competitionName, string &endTime, int &rqs);
    /**
     *  @see GetTargetSpList
     */
    int GetSelectedTargetSpList(int targetId, int spList[25]);
    /**
     *  @see GetTargetOption
     */
    int GetSelectedTargetOption(int targetId, int betOption[25]);
    /**
     *  @see SetTargetOption
     */
    int SetSelectedTargetOption(int targetId, int index, int selected);
    
    /**
     *  为指定比赛设胆
     *
     *  @param targetId  [in]赛事编号
     *  @param checkOrNo [in]是否选中
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetMarkResult(int targetId, int checkOrNo);
    /**
     *  获取指定比赛是否为胆
     *
     *  @param targetId [in]赛事编号
     *
     *  @return <0表示失败, 0表示未设胆, 1表示已设胆
     */
    int GetMarkResult(int targetId);
    
    /**
     *  清空投注页面数据
     *
     */
    void Clear();
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
    
    /**
     *  获取指定比赛的基本信息
     *
     *  @param target          [in]指定的比赛
     *  @param homeTeamName    [out]主队队名
     *  @param awayTeamName    [out]客队队名
     *  @param orderNumberName [out]编号名称
     *  @param competitionName [out]赛事名称
     *  @param endTime         [out]截止时间 e.g. "2014-08-02 16:49:00"
     *  @param rqs             [out]让球数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _getTargetInfo(CLotteryBdTarget *target, string &homeTeamName, string &awayTeamName, string &homeTeamRank, string &awayTeamRank, string &orderNumberName, string &competitionName, string &endTime, int &rqs);
    /**
     *  获取指定比赛的sp值
     *
     *  @note 客胜索引为0, 主胜索引为1
     *
     *  @param target     [in]指定的比赛
     *  @param spListSf   [out]胜负玩法sp值(int值, 为实际sp*100), e.g. [479, 103] ( [4.79, 1.03] )
     *  @param spListRfsf [out]让分胜负玩法sp值
     *  @param spListSfc  [out]胜分差玩法sp值
     *  @param spListDxf  [out]大小分玩法sp值
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _getTargetSpList(CLotteryBdTarget *target, int spList[25]);
    /**
     *  获取投注选项
     *
     *  @note 客胜索引为0, 主胜索引为1
     *
     *  @param target        [in]指定的比赛
     *  @param betOptionSf   [out]胜负玩法投注选项, e.g. [1, 0] - 1 表示选中, 0 表示未选择
     *  @param betOptionRfsf [out]让分胜负玩法投注选项
     *  @param betOptionSfc  [out]胜分差玩法投注选项
     *  @param betOptionDxf  [out]大小分玩法投注选项
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _getTargetOption(CLotteryBdTarget *target, int betOption[25]);
    /**
     *  设置投注选项
     *
     *  @param target   [in]指定的比赛
     *  @param index    [in]选择项在指定彩种中的索引
     *  @param selected [in]是否选择
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _setTargetOption(CLotteryBdTarget *target, int index, int selected);
    
    /**
     *  刷新数据通知
     *
     *  @param res [in]HTTP响应数据
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _dealNotifyRefresh(DCHttpRes &res);
    /**
     *  下单通知
     *
     *  @param res [in]HTTP响应数据
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _dealNotifyGoPay(DCHttpRes &res);
    /**
     *  刷新数据源, 生成对应玩法, 筛选条件的组
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _refreshGroup();
    /**
     *  指定赛事在当前玩法中是否可选
     *
     *  @param target [in]指定赛事
     *
     *  @return bool值, true代表可选, false代表不可选
     */
    bool _gameVisible(CLotteryBdTarget *target);
    /**
     *  获取当前可选的过关方式
     *
     *  @param freedoms [out]自由过关
     *  @param combines [out]组合过关
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _getEnablePassMode(vector<int> &freedoms, vector<int> &combines);
    /**
     *  重新生成过关方式
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _reloadPassMode();
    /**
     *  生成彩种列表
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _genGameList();
    
    /**
     *  生成计算器
     *
     *  @return
     */
    int _calculate();
    
    /**
     *  清除指定赛事的选项
     *
     *  @param target [in]指定的赛事对象
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _cleanupOption(CLotteryBdTarget *target);
	/////////////////////////////////////////////方案详情
    int _projectInfoClear();
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int _dealProjectInfo2(DCHttpRes &res);
	int ProjectInfoClear();
	int GetPTargetNum(string &Ggfs);
	int GetPTarget(int index, int &subNum, string&  OrderNumberName, string& HomeTeam, string &AwayTeam, int &IsDan, string &HomeRank, string&  AwayRank, string &Score, int &Rqs);
	int GetPSubTarget(int index, int subindex, int &contentNum, int &GameTypeId, string& ResultSp, string &Result);
	int GetPContent(int index, int subindex, int contentNum, string &name, string &odd, int &ischeck, int& win);


protected:
    vector< PlayCell *> m_playList;
    string Ggfs;
protected:
    vector<CLotteryBdGroup *> mGroups;
    
    vector<CLotteryBdGroup *> mAllGroups;
    vector<CLotteryBdTarget *> mAllTargets;
    vector<int> mPassModes;
    
    string mGameName;
    int mGameIdRqspf;
    int mGameIdSxds;
    int mGameIdZjq;
    int mGameIdBf;
    int mGameIdBqc;
    
    vector<string> mCompetitionList;
    vector<int> mCompetitionTags;
    vector<int> mRqsList;
    vector<int> mRqsTags;
    int mGameType;
    int mMultiple;
    
    vector<int> mSelectedTargets;   // 在 mAllTargets 中的索引
    int mSelectedCountRqspf;
    int mSelectedCountSxds;
    int mSelectedCountZjq;
    int mSelectedCountBf;
    int mSelectedCountBqc;
    
    // 合买相关
    bool mTogetherBuy;
    int mAccessType;
    int mCommission;
    int mBuyAmt;
    int mFillAmt;
    
    // 保存的注数和奖金
    struct {
        bool NeedFigureUp;
        int Note;
        float MinBonus;
        float MaxBonus;
        
        void reset() {
            NeedFigureUp = true;
            Note = MinBonus = MaxBonus = 0;
        }
    } mCalculator;
    
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
};

#endif /* defined(__DacaiProject__LotteryBjdc__) */
