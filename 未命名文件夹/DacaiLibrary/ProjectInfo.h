
#ifndef __PROJECTINFO_H__
#define __PROJECTINFO_H__

#include <iostream>
#include <string>
#include <vector>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "CommonMacro.h"

using namespace std;
typedef struct ProjectInfo_t {
    int ProjectId;
    int GameTypeId, ProjectBuyTypeId, ContentType;
    int SysProcessStepId, ProjectStatusId, TicketStatusId;
    int IsCanVisit, Quantity, Multiple, TotalAmount, BuyedAmount, FilledAmount, JoinCount, CommisionRate, Commision;
    int FilledAmountRate;
    string GameName, AccessName, WapUrl, ShareUrl, InsertTime, EndTime, PName, TName, WinedAmt, Result, WinDescription;
    int IsGlfa;
} ProjectInfo_t;

typedef struct CreaterInfo_t {
    string UserName, Scores;
    int WinedAmount, WinedCount;
} CreaterInfo_t;

typedef struct JoinInfo_t {
    string Time;
    int IsUserRed;
    int Type, Amount, WinedAmount;
} JoinInfo_t;

typedef struct FollowCell_t {
    int Multiple;
    int StatusId;
    int WinedAmount;
    string GameName;
    string StatusName;
    string Result;
} FollowCell_t;

typedef struct FollowInfo_t {
    int IsFollow, StatusId, StopTypeId, StopMoney, TotalPeriod, CurrentPeriod;
    vector<FollowCell_t *> m_FollowCell;
} FollowInfo_t;

class CProjectInfo {
public:
    /**
     *  刷新方案详情数据
     *
     *  @param projectid   方案id
     *  @param gameTypeId 彩种id
     *  @param orderId    订单编号
     *
     *
     *  @return >=0表示成功, <0表示失败
     */
    virtual int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0) = 0;

    /**
     *  得到基本信息
     *
     *  @param ProjectId           方案id
     *  @param GameTypeId          彩种id
     *  @param ProjectBuyTypeId    购买类型  2:合买  其他:代购
     *  @param ContentType         方案内容  0:普通 1:未补全 2:单式上传
     *  @param SysProcessStepId    开奖步骤  0:无任务 1:已经开奖号  2:正在计算过关  3:计算过关完成  4:已经开奖金  5:正在计算奖金  6:计算奖金完成  7:需要返奖  23:正在返奖  24:返奖完成
     *  @param ProjectStatusId     订单状态 1:未满  2:成功  3:撤单  4:流标  5:未付款
     *  @param TicketStatusId      出票状态 1:未出票  2:出票中  3:已出票  4:出错
     
     *  @param IsCanVisit          方案内容显示或隐藏 1：可见  0:不可见
     *  @param Quantity            注数
     *  @param Multiple            倍数
     *  @param TotalAmount         方案总额
     *  @param BuyedAmount         认购金额
     *  @param FilledAmount        保底金额
     *  @param JoinCount           参与次数
     *  @param CommisionRate       佣金比例
     *  @param Commision           佣金
     
     *  @param GameName            期号
     *  @param AccessName          方案内容状态
     *  @param WapUrl
     *  @param ShareUrl            分享地址
     
     *  @param InsertTime          发起时间
     *  @param EndTime             截止时间
     *  @param PName               订单状态
     *  @param TName               出票状态
     *  @param WinedAmt            中奖金额
     *  @param Result              开奖号码
     *  @param WinDescription      命中情况
     
     *  @param FilledAmountRate    （暂且没用）
     *  @param CanBuy              继续购买  1:可以   0:不能
     *  @param IsGlfa              是否过滤  1:过滤   0:不是过滤
     
     *  @param UserName            发起人
     *  @param Scores              发起人战绩
     *  @param WinedAmount         中奖次数
     *  @param WinedCount          中奖总额
     
     *  @param num                 我的认购总次数
     *  @param Time                认购时间
     *  @param Type                认购类型
     *  @param Amount              认购金额
     *  @param WinedAmount         认购奖金
     *  @param IsUserRed           是否用红包
     
     *  @param IsFollow            是否追号方案
     *  @param StatusId            追号状态
     *  @param StopTypeId          停止追号类型
     *  @param StopMoney           停止追号金额
     *  @param TotalPeriod         总期数
     *  @param CurrentPeriod       当前期数
     
     *  @param Multiple            追号倍数
     *  @param StatusId            追号状态
     *  @param WinedAmount         中奖金额
     *  @param GameName            追号期数
     *  @param StatusName          追号状态（文字）
     *  @param Result              每期开奖结果
     *  未支付
     *  @param orderId              订单号
     *  @param needAmt              应付金额
     *
     *  @return >=0表示成功, <0表示失败
     */
    int GetPBaseInfo(int &ProjectId, int &GameTypeId, int &ProjectBuyTypeId, int &ContentType, int &SysProcessStepId, int &ProjectStatusId, int &TicketStatusId);
    int GetPBaseInfo2(int &IsCanVisit, int &Quantity, int &Multiple, int &TotalAmount, int &BuyedAmount, int &FilledAmount, int &JoinCount, int &CommisionRate, int &Commision);
    int GetPBaseInfo3(string &GameName, string &AccessName, string &WapUrl, string &ShareUrl);
    int GetPBaseInfo4(string &InsertTime, string &EndTime, string &PName, string &TName, string &WinedAmt, string &Result, string &WinDescription);
    int GetPBaseInfo5(int &FilledAmountRate, int &CanBuy, int &IsGlfa);
    int GetPCreaterInfo(string &UserName, string &Scores, int &WinedAmount, int &WinedCount);
    int GetPjoinNum(int &num);
    int GetPJoinInfo(int index, string &Time, int &Type, int &Amount, int &WinedAmount, int &IsUserRed);
    int GetPFollowInfo(int &IsFollow, int &StatusId, int &StopTypeId, int &StopMoney, int &TotalPeriod, int &CurrentPeriod);
    int GetPFollowCell(int index, int &Multiple, int &StatusId, int &WinedAmount, string &GameName, string &StatusName, string &Result);

    /**
     *  获取M版地址
     *
     *  @param url [out]url地址
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetProjectURL(string &url);
    /////////////////////////
    int GetPurchaseOrderInfo(int &orderId, int &needAmt);

public:
    CProjectInfo();
    static ProjectInfo_t *m_projectInfo;
    static CreaterInfo_t *m_createrInfo;

    vector<JoinInfo_t *> m_joinInfoList;
    FollowInfo_t m_follow;
    int CanBuy;
    int mPurchaseOrderId;
    int mNeedAmt;
    string mProjectURL;
protected:
    int _clear();
    //	virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData);
    int _dealProjectInfo(DCHttpRes &res);
};
#endif
