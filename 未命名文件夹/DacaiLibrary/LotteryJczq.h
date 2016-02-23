//
//  LotteryJczq.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__LotteryJczq__
#define __DacaiProject__LotteryJczq__

#include <iostream>
#include <vector>
#include <string>
#include <string.h>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "ProjectInfo.h"

using namespace std;

#define JCZQ_Balance    40
#define JCZQ_SingleList 41

class CJczqBalanceContent;

typedef struct _JczqBetOption {
    int betOptionRqspf[3];
    int betOptionBf[31];
    int betOptionZjq[8];
    int betOptionBqc[9];
    int betOptionSpf[3];
    
    int betOptionCqy[9]; // 单关, 猜赢球
} JczqBetOption;

class CLotteryJczqTarget {
public:
    CLotteryJczqTarget() {
        memset(mSpListRqspf, 0, sizeof(mSpListRqspf));
        memset(mSpListBf, 0, sizeof(mSpListBf));
        memset(mSpListZjq, 0, sizeof(mSpListZjq));
        memset(mSpListBqc, 0, sizeof(mSpListBqc));
        memset(mSpListSpf, 0, sizeof(mSpListSpf));
        memset(&mMixupBetOption, 0, sizeof(mMixupBetOption));
        memset(&mNormalBetOption, 0, sizeof(mNormalBetOption));
        mBetOptionCyq = NULL;
        mIsMark = false;
    }
    ~CLotteryJczqTarget() {
        if (mBetOptionCyq) {
            delete [] mBetOptionCyq;
            mBetOptionCyq = NULL;
        }
    }

    int mGroupId;
    int mTargetId;
    int mGameVisible;
    int mSingleVisible;

public:
    int mDMatchId;
    int mGameMatchIdHt;
    int mGameMatchIdRqspf;
    int mGameMatchIdBf;
    int mGameMatchIdZjq;
    int mGameMatchIdBqc;
    int mGameMatchIdSpf;

    int mOrderNumber;
    string mOrderNumberName;
    string mHomeTeamName;
    string mAwayTeamName;
    string mHomeTeamRank;
    string mAwayTeamRank;
    bool mIsHot;
    bool mIsMark;
    string mCompetitionName;
    string mStartTime;
    string mEndTime;
    int mRqs;

    int mSpListRqspf[3];
    int mSpListBf[31];
    int mSpListZjq[8];
    int mSpListBqc[9];
    int mSpListSpf[3];

    bool mVisibledRqspf;
    bool mVisibledBf;
    bool mVisibledZjq;
    bool mVisibledBqc;
    bool mVisibledSpf;

    JczqBetOption mMixupBetOption;
    JczqBetOption mNormalBetOption;
    int *mBetOptionCyq; // 单关, 猜赢球
    string mDescribtion;
    string mHomeTeamLogo;
    string mAwayTeamLogo;
    
    struct {
        string BetProportion[6]; // 投注比例
        string PastMatches[3];   // 历史交锋
        string RecentRecord[6];  // 近期战绩
        string AverageOdds[3];   // 平均赔率
        
        int PastMatchesCount;
    } mAnalyze;
    
    void Parser(Json::Value &value);
};

class CLotteryJczqGroup {
public:
    int mGameIdHt;
    int mGameIdRqspf;
    int mGameIdBf;
    int mGameIdZjq;
    int mGameIdBqc;
    int mGameIdSpf;
    string mGameName;
    vector<CLotteryJczqTarget *> mTargets;
};

class CLotteryJczq : public CModuleBase, public CNotify, public CProjectInfo {
    class JjyhInfo {
    public:
        string Ggfs;
        int Quantity;
        string Bonus;
        vector<string> Bets;
    };
    class Content {
    public:
        Content() {
        }
        string name;
        string odd;
        int ischeck;
        int win;
    };
    class Option {
    public:
        Option() {
        }
        int GameTypeId;
        string ResultSp;
        string Result;
        vector<Content *> m_content;
    };
    class PlayCell {
    public:
        PlayCell() {

            IsDan = 0;
        }
        string OrderNumberName;
        string HomeTeam;
        string AwayTeam;
        string HomeRank;
        string AwayRank;
        string Score;
        int Rqs;
        int IsDan;

        vector<Option *> m_options;
    };

public:
    CLotteryJczq() : mSelectedCountHt(0), mSelectedCountRqspf(0), mSelectedCountBf(0), mSelectedCountZjq(0), mSelectedCountBqc(0), mSelectedCountSpf(0), mTogetherBuy(-1), mProjectBuyType(-1) {};
    /**
     *  刷新数据
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Refresh();
    /**
     *  获取组的个数
     *
     *  @return <0表示失败, >=0为组的个数
     */
    size_t GetGroupCount();
    /**
     *  获取组的信息
     *
     *  @param groupId  [in]组编号
     *  @param gameName [out]时间 e.g. "2014-08-02"
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetGroupInfo(int groupId, string &gameName);
    /**
     *  获取指定组中比赛的场次数
     *
     *  @param groupId [in]组编号
     *
     *  @return <0表示失败, >=0为组中元素的个数
     */
    size_t GetTargetCount(int groupId);
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
     *  @param spListRqspf [out]让球胜平负玩法sp值(int值, 为实际sp*100), e.g. [479, 103, 231] ( [4.79, 1.03, 2.31] )
     *  @param spListBf    [out]比分玩法sp值
     *  @param spListZjq   [out]总进球玩法sp值
     *  @param spListBqc   [out]半全场玩法sp值
     *  @param spListSpf   [out]胜平负玩法sp值
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetSpList(int groupId, int targetId, int spListRqspf[3], int spListBf[31], int spListZjq[8], int spListBqc[9], int spListSpf[3]);
    /**
     *  获取投注选项
     *
     *  @param groupId        [in]组编号
     *  @param targetId       [in]比赛编号
     *  @param betOptionRqspf [out]让球胜平负玩法投注选项, e.g. [1, 0, 0] - 1 表示选中, 0 表示未选择
     *  @param betOptionBf    [out]比分玩法
     *  @param betOptionZjq   [out]总进球玩法
     *  @param betOptionBqc   [out]半全场玩法
     *  @param betOptionSpf   [out]胜平负玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetOption(int groupId, int targetId, int betOptionRqspf[3], int betOptionBf[31], int betOptionZjq[8], int betOptionBqc[9], int betOptionSpf[3]);
    /**
     *  赛事分析
     *
     *  @param groupId       [in]...
     *  @param targetId      [in]...
     *  @param status        [out]状态, 0:无数据, 1:请求中, 2:有数据
     *  @param betProportion [out]投注比例
     *  @param passMatches   [out]历史交锋
     *  @param recentRecord  [out]近期战绩
     *  @param averageOdds   [out]平均赔率
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetAnalysis(int groupId, int targetId, int &status, string betProportion[6], string passMatches[3], int &count, string recentRecord[6], string averageOdds[3]);
    /**
     *  设置投注选项
     *
     *  @param groupId  [in]组编号
     *  @param targetId [in]比赛编号
     *  @param gameType [in]指定的彩种
     *  @param index    [in]选择项在指定彩种中的索引
     *  @param selected [in]是否选择
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetTargetOption(int groupId, int targetId, int gameType, int index, int selected);
    /**
     *  设置彩种类型, 即档位
     *
     *  @param gameType [in]彩种类型
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetGameType(int gameType);
    /**
     *  是否是热门赛事
     *
     *  @param groupId  [in]组编号
     *  @param targetId [in]比赛编号
     *
     *  @return 
     */
    int IsHotMatch(int groupId, int targetId);
    /**
     *  玩法是否支持单关
     *
     *  @param groupId  [in]组编号
     *  @param targetId [in]比赛编号
     *  @param gameType [in]玩法
     *
     *  @return 是否支持单关
     */
    int IsSingleMatch(int groupId, int targetId, int gameType);
    /**
     *  是否选择的全是单关选项
     *
     *  @return <0表示失败, >=0表示成功
     */
    int IsSelectedAllSingle();
    /**
     *  混投专用, 指定比赛的指定玩法是否开售
     *
     *  @param groupId  [in]组编号
     *  @param targetId [in]比赛编号
     *  @param gameType [in]玩法
     *
     *  @return 是否开售
     */
    int LotteryTypeVisible(int groupId, int targetId, int gameType);
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
     *  获取当前选择的过关方式
     *
     *  @param passModes [out]当前选择的过关方式
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
    size_t GetSelectedTargetCount();
    /**
     *  @see GetTargetInfo
     */
    int GetSelectedTargetInfo(int targetId, string &homeTeamName, string &awayTeamName, string &homeTeamRank, string &awayTeamRank, string &orderNumberName, string &competitionName, string &endTime, int &rqs);
    /**
     *  @see GetTargetSpList
     */
    int GetSelectedTargetSpList(int targetId, int spListRqspf[3], int spListBf[31], int spListZjq[8], int spListBqc[9], int spListSpf[3]);
    /**
     *  @see GetTargetOption
     */
    int GetSelectedTargetOption(int targetId, int betOptionRqspf[3], int betOptionBf[31], int betOptionZjq[8], int betOptionBqc[9], int betOptionSpf[3]);
    /**
     *  @see SetTargetOption
     */
    int SetSelectedTargetOption(int targetId, int gameType, int index, int selected);

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
    
    
    
    
#pragma mark - 优化投注
    /**
     *  优化投注/平衡投注
     *
     *  @param amount [in]预算金额, 可以缺省为0
     *
     *  @note cmdType: JCZQ_Balance
     *
     *  @return >=0表示成功, <0表示失败, ERROR_NOT_LOGIN表示未登录
     */
    int NetBalance(int amount = 0);
    
    /**
     *  本地计算优化投注/平衡投注
     *
     *  @param amount [in]预算金额, 可以缺省为0
     *
     *  @return >=0表示成功, <0表示失败
     */
    int CalcBalance(int amount = 0);
    
    /**
     *  获取优化投注后对阵数
     */
    size_t GetBalanceCount();
    /**
     *  获取方案金额
     */
    int GetBalanceCost();
    /**
     *  获取对阵内容
     *
     *  @param targetId [in]索引
     *  @param multiple [out]倍数
     *  @param quantity [out]注数
     *  @param bonus    [out]奖金 * 100
     */
    int GetBalanceContentOption(int targetId, int &multiple, int64_t &bonus);
    /**
     *  获取对阵比赛数
     *
     *  @param targetId [in]索引
     */
    size_t GetBalanceRowCount(int targetId);
    /**
     *  获取对阵比赛信息
     *
     *  @param targetId        [in]索引
     *  @param row             [in]行
     *  @param orderNumberName [out]序号
     *  @param homeTeamName    [out]主队
     *  @param awayTeamName    [out]客队
     *  @param gameType        [out]彩种
     *  @param betOption       [out]选项
     *  @param sp              [out]sp值 * 100
     */
    int GetBalanceRowInfo(int targetId, int row, string &orderNumberName, string &homeTeamName, string &awayTeamName, int &rqs, int &gameType, int &betIndex, int &sp);
    /**
     *  设置对阵倍数
     *
     *  @param targetId [in]索引
     *  @param multiple [in]倍数
     */
    int SetBalanceRowMultiple(int targetId, int multiple);
    
    /**
     *  获取优化投注方案信息
     *
     *  @param quantity [out]总注数
     *  @param minBonus [out]最小奖金 * 100
     *  @param maxBonus [out]最大奖金 * 100
     */
    int GetBalanceOrderInfo(int &quantity, int64_t &minBonus, int64_t &maxBonus);
    
#pragma mark - 单关
    /**
     *  请求单关数据
     *
     *  @note cmdType: JCZQ_SingleList
     *
     *  @return <0表示失败, 否则返回cmdId
     */
    int NSingleList();
    
    /**
     *  获取列表元素个数
     *
     *  @return <0表示失败, >=0表示列表元素个数
     */
    size_t GetSingleTargetCount();
    /**
     *  @see GetTargetInfo
     */
    int GetSingleTargetInfo(int targetId, string &homeTeamName, string &awayTeamName, string &homeTeamRank, string &awayTeamRank, string &orderNumberName, string &competitionName, string &endTime, int &rqs);
    /**
     *  获取让球数
     *
     *  @param targetId [in]比赛编号
     *  @param rqs      [out]让球数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetSingleTargetRqs(int targetId, int &rqs);
    /**
     *  @see GetTargetSpList
     */
    int GetSingleTargetSpList(int targetId, int spListRqspf[3], int spListBf[31], int spListZjq[8], int spListBqc[9], int spListSpf[3]);
    /**
     *  @see GetTargetOption
     */
    int GetSingleTargetOption(int targetId, int gameType, int betOption[10]);
    /**
     *  获取投注比例
     *
     *  @param targetId      [in]
     *  @param betProportion [out]胜平负, 让球胜平负投注比例
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetSingleTargetAnalysis(int targetId, int betProportion[6]);
    /**
     *  获取logo图片
     *
     *  @param targetId     [in]索引
     *  @param homeImageURL [out]主队图片地址
     *  @param awayImageURL [out]客队图片地址
     *  @param desc         [out]宣传语
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetSingleTargetImages(int targetId, string &homeImageURL, string &awayImageURL, string &desc);
    /**
     *  @see SetTargetOption
     */
    int SetSingleTargetOption(int targetId, int gameType, int index, int selected);
    /**
     *  指定比赛的指定玩法是否开售
     *
     *  @param targetId [in]比赛编号
     *  @param gameType [in]玩法
     *
     *  @return 是否开售
     */
    int IsSingleGameVisible(int targetId, int gameType);
    
    /**
     *  是否选择指定比赛的指定玩法
     *
     *  @param targetId [in]比赛编号
     *  @param gameType [in]玩法
     *
     *  @return <0表示失败, =0表示未选择, >0表示选择
     */
    int IsSingleTargetSelected(int targetId, int gameType);
    
    /**
     *  获取金额、奖金信息
     *
     *  @param targetId [in]比赛编号
     *  @param gameType [in]彩种
     *  @param note     [out]注数
     *  @param minBonus [out]最小奖金
     *  @param maxBonus [out]最大奖金
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetSingleTargetAmount(int targetId, int gameType, int &note, int &minBonus, int &maxBonus);
    /**
     *  下单前调用, 设置选择的比赛以及玩法
     *
     *  @param targetId [in]比赛编号
     *  @param gameType [in]彩种
     *
     *  @return
     */
    int SetSingleSelectedTarget(int targetId, int gameType);
    
    
    
    
    /**
     *  设置购买类型
     *
     *  @param type [in]类型, 1:普通代购or合买, 2:优化投注代购or合买, 3:单关专题代购, 4:单关专题优化投注
     *
     *  @return
     */
    int SetProjectBuyType(int type);
    
    /**
     *  清空投注页面数据
     */
    int Clear();
    /**
     *  清空单关数据
     */
    int ClearSingleData();
    /**
     *  清空优化投注数据
     */
    int ClearBalanceData();

protected:
    virtual int Notify(int comId, int result, DCHttpRes &res, void *pd, int specialData, int tag);
    
    /**
     *  刷新数据通知
     *
     *  @param res [in]HTTP响应数据
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _dealNotifyRefresh(DCHttpRes &res);
    
    /**
     *  奖金优化通知
     *
     *  @param res [in]HTTP响应数据
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _dealNotifyBalance(DCHttpRes &res);
    /**
     *  单关专题通知
     *
     *  @param res [in]HTTP响应数据
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _dealNotifySingle(DCHttpRes &res);
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
     *  生成对外数据源
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _genGameList();
    /**
     *  是否选择的全是单关选项
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _isSelectedAllSingle();
    /**
     *  指定赛事在当前玩法中是否可选
     *
     *  @param target [in]指定赛事
     *
     *  @return bool值, true代表可选, false代表不可选
     */
    bool _gameVisible(CLotteryJczqTarget *target);

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
    int _getTargetInfo(CLotteryJczqTarget *target, string &homeTeamName, string &awayTeamName, string &homeTeamRank, string &awayTeamRank, string &orderNumberName, string &competitionName, string &endTime, int &rqs);
    /**
     *  获取指定比赛的sp值
     *
     *  @note 客胜索引为0, 主胜索引为1
     *
     *  @param target      [in]指定的比赛
     *  @param spListRqspf [out]让球胜平负玩法sp值(int值, 为实际sp*100), e.g. [479, 103, 231] ( [4.79, 1.03, 2.31] )
     *  @param spListBf    [out]比分玩法sp值
     *  @param spListZjq   [out]总进球玩法sp值
     *  @param spListBqc   [out]半全场玩法sp值
     *  @param spListSpf   [out]胜平负玩法sp值
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _getTargetSpList(CLotteryJczqTarget *target, int spListRqspf[3], int spListBf[31], int spListZjq[8], int spListBqc[9], int spListSpf[3]);
    /**
     *  获取投注选项
     *
     *  @param target         [in]指定的比赛
     *  @param betOptionRqspf [out]让球胜平负玩法投注选项, e.g. [1, 0, 0] - 1 表示选中, 0 表示未选择
     *  @param betOptionBf    [out]比分玩法
     *  @param betOptionZjq   [out]总进球玩法
     *  @param betOptionBqc   [out]半全场玩法
     *  @param betOptionSpf   [out]胜平负玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _getTargetOption(CLotteryJczqTarget *target, int betOptionRqspf[3], int betOptionBf[31], int betOptionZjq[8], int betOptionBqc[9], int betOptionSpf[3]);
    /**
     *  设置投注选项
     *
     *  @param target   [in]指定的比赛
     *  @param gameType [in]指定的彩种
     *  @param index    [in]选择项在指定彩种中的索引
     *  @param selected [in]是否选择
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _setTargetOption(CLotteryJczqTarget *target, int gameType, int index, int selected);
    /**
     *  清除指定赛事的选项
     *
     *  @param target [in]指定的赛事对象
     *
     *  @return <0表示失败, >=0表示成功
     */
    int _cleanupOption(CLotteryJczqTarget *target);
    
    
    int _calculate();
    
    int _coverIndex(int const localOption[31], int const localSp[31], int serverOption[31], int serverSp[31]);
    
    
    
    /**
     *  普通模式优化投注
     *
     */
    int _normalCalcBalance(int amount);
    /**
     *  单关专题优化投注
     *
     */
    int _singleCalcBalance(int amount);
    
    /**
     *  普通投注下单
     *
     *  @param identifier [in]红包id
     *
     *  @return cmdId
     */
    int _normalGoPay(int identifier);
    /**
     *  优化投注下单
     *
     *  @param identifier [in]红包id
     *
     *  @return cmdId
     */
    int _balanceGoPay(int identifier);
    /**
     *  单关投注下单
     *
     *  @param identifier [in]红包id
     *
     *  @return cmdId
     */
    int _singleGoPay(int identifier);
    
    /**
     *  单关优化投注下单
     *
     *  @param identifier [in]红包id
     *
     *  @return cmdId
     */
    int _sin_balGoPay(int identifier);
    
    ///////////////////////////////////////////// 方案详情
    int _projectInfoClear();

public:
    virtual int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
    int _dealProjectInfo2(DCHttpRes &res);
    int ProjectInfoClear();
    int GetPTargetNum(string &Ggfs);
    int GetPTarget(int index, int &subNum, string &OrderNumberName, string &HomeTeam, string &AwayTeam, int &IsDan, string &HomeRank, string &AwayRank, string &Score, int &Rqs);
    int GetPSubTarget(int index, int subindex, int &contentNum, int &GameTypeId, string &ResultSp, string &Result);
    int GetPContent(int index, int subindex, int contentIndex, string &name, string &odd, int &ischeck, int &win);

    ////////////////////优化投注
    int GetPYhNum();
    int GetPYhInfo(int index, string &Ggfs, string &Bonus, int &Quantity, int &BeysNum);
    int GetPYhBet(int index, int subindex, string &bet);

protected:
    vector<PlayCell *> m_playList;
    vector<JjyhInfo *> m_yhInfoList;
    string Ggfs;

protected:
    vector<CLotteryJczqGroup *> mGroups;
    vector<CLotteryJczqGroup *> mAllGroups;
    vector<CLotteryJczqTarget *> mAllTargets;
    vector<CLotteryJczqGroup *> mSingleGroups;
    vector<CLotteryJczqTarget *> mSingleTargets;
    vector<CJczqBalanceContent *> mBalanceContents;
    int mBalanceCost;

    vector<int> mSelectedTargets; // 在 mAllTargets 中的索引

    vector<string> mCompetitionList;
    vector<int> mCompetitionTags;
    vector<int> mRqsList;
    vector<int> mRqsTags;

    vector<int> mPassModes;
    int mGameType;
    int mMultiple;

    int mSelectedCountHt;
    int mSelectedCountRqspf;
    int mSelectedCountBf;
    int mSelectedCountZjq;
    int mSelectedCountBqc;
    int mSelectedCountSpf;

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

    // 合买相关
    int mTogetherBuy;
    int mAccessType;
    int mCommission;
    int mBuyAmt;
    int mFillAmt;

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
    
    struct {
        int TargetIndex;
        int TargetGameType;
    } mSingleInfo;
    
    int mProjectBuyType;    // 1:普通代购or合买, 2:优化投注代购or合买, 3:单关专题代购, 4:单关专题优化投注
    
    static int JczqRqspfBetOption[3];
    static int JczqBfBetOption[31];
    static int JczqZjqBetOption[8];
    static int JczqBqcBetOption[9];
    static int JczqSpfBetOption[3];
};

// 选中的选项, 计算优化投注拆分时用
typedef struct BalanceBetOption {
    int Index;
    int GameType;
    int BetIndex;
    int BetSP;
    string BetOption;
    
    BalanceBetOption(int index, int gameType, int betIndex, float betSP, string betOption) : Index(index), GameType(gameType), BetIndex(betIndex), BetSP(betSP), BetOption(betOption) {}
} BalanceBetOption_t;

// 平衡投注赛事
class CJczqBalanceTarget {
public:
    int     OrderNumber;
    string  OrderNumberName;// 周二001
    string  HomeTeamName;   // 主队
    string  AwayTeamName;   // 客队
    string  BetOption;      // 选项
    int     GameType;       // 子玩法. 121, 122, 123, 124, 128
    int     BetIndex;       // 选中项索引
    int     BetSP;          // sp值 * 100
    int     Rqs;            // 让球数
    bool    IsMark;
};

// 平衡投注单注对阵
class CJczqBalanceContent {
public:
    int     Quantity;   // 注数
    int     Multiple;   // 倍数
    int64_t Bonus;      // 单注奖金 * 100
    vector<CJczqBalanceTarget *> Targets;
    
    ~CJczqBalanceContent() {
        for (int i = 0; i < Targets.size(); i++) {
            if (Targets[i]) {
                delete Targets[i];
                Targets[i] = NULL;
            }
        }
        Targets.clear();
    }
};

#endif /* defined(__DacaiProject__LotteryJczq__) */
