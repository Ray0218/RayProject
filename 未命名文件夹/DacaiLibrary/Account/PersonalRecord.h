//
//  PersonalRecord.h
//  DacaiProject
//
//  Created by WUFAN on 14/12/3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  个人购彩记录、资金明细模块
//

#ifndef __DacaiProject__PersonalRecord__
#define __DacaiProject__PersonalRecord__

#include <stdio.h>
#include <vector>
#include "../ModuleBase.h"
#include "../include/json/json.h"
#include "AccountCommon.h"

using namespace std;

class CBuyRecordTarget {
public:
    string mCreateDate;  // 参与时间  e.g. "2014-05-06 16:35:04"
    int mGameType;       // 彩种id   e.g. 205
    string mGameName;    // 数字彩有意义, 期号  e.g. "14088", "不定期"
    int mProjectAmount;  // 方案总金额  e.g. 4,
    int mActualAmount;   // 实际消费金额: 追号方案:为方案实际已花费总金额;代购/合买方案:为用户参与金额, e.g. 0
    int mBuyedAmount;    // 方案全部已认购金额, e.g. 0
    int mFilledAmount;   // 方案全部已保底金额, e.g. 0
    string mWinedAmount; // 中奖金额, e.g. "0.00"
    int mProjectId;      // 方案id, e.g. 2991927
    int mFollowCode;     // 追号方案状态; 0:默认值(无意义); 1:未满;      3:撤单;4:流标;5:未付款;6:进行中;7:已完成 e.g. 0
    int mPCode;          // 方案状态; 0:默认值(无意义);    1:未满;2:成功;3:撤单;4:流标;5:未付款;
    int mTCode;          // 出票状态; 0:默认值(无意义);    1:未出票;2:出票中;3:已出票;4:出票失败;
    int mIsDrawed;       // 是否已计算奖金完成;0:否;1:是;
    int mCurrentPeriod;  // 追号当前进度, e.g. 0
    int mTotalPeriod;    // 追号总进度, e.g. 0
    int mBuyType;        // 购买类型; 1:代购;2:合买;3:保存;4:追号  e.g. 1
    int mPurchaseOrderId; // 未支付订单id
    int mPurchaseOrderStatusId; // 1:等待付款, 2:成功, 3:已过期, 4:已撤销
    
    unsigned char mDayBegin; // 该天起始
    unsigned char mDayEnd;   // 该天截止
    short mDayIndex;         // 日期索引
};

class CFundRecordTarget {
public:
    unsigned char mDayBegin; // 该天起始
    unsigned char mDayEnd;   // 该天截止
    short mDayIndex;         // 日期索引
    string mCreateDate;      // 时间 - "2014-08-22 11:32:07",
    
    virtual ~CFundRecordTarget() {}
};

// 收支明细
class CIncomeExpensesTarget : public CFundRecordTarget {
public:
    // 收支明细
    int mTradeAccount;     // 账户 - 1:资金账户; 2:大彩币账户, 3:红包
    string mTradeTypeName; // 类型名 e.g. "代购"
    string mAmount;        // 金额 e.g. "50.00"
    int mIsProject;        // 是否是方案 e.g. 1
    int mOrderId;          // 订单id e.g. 3328836
    
    virtual ~CIncomeExpensesTarget() {}
};

// 充值明细
class CRechargeTarget : public CFundRecordTarget {
public:
    // 充值明细
    string mAmount;       // 金额 e.g. "50.00"
    string mActualAmount; // 实际到账金额 e.g. 0.01,
    string mTypeName;     // 类型 e.g. "在线充值"
    string mStatusName;   // 状态 e.g. "已处理"
    
    virtual ~CRechargeTarget() {}
};

// 提款明细
class CWithdrawTarget : public CFundRecordTarget {
public:
    // 提款明细
    string mAmount;      // 金额 e.g. "50.00"
    string mCharge;      // 手续费: "0.00"
    string mAccountNo;   //": "6210983310007804183",
    string mAccountType; //": "中国邮政储蓄银行",
    string mStatusName;  //": "未处理"
    
    virtual ~CWithdrawTarget() {}
};

class CPersonalRecord : virtual public CModuleBase {
public:
    CPersonalRecord() {
        mCoinAmt = 0;
        mRealAmt = "0.00";
        mUserRedElpCount = 0;
        mIsCanEditName = 0;
        mDrawPwdBounded = mMobileBounded = mIdentityBounded = false;
        
        for (int i = 0; i < 5; i++) {
            mBuyRecordTotal[i] = INT_MAX;
            mBuyRecordReload[i] = 0;
        }
        for (int i = 0; i < 3; i++) {
            mFundRecordTotal[i] = INT_MAX;
        }
    }
    ~CPersonalRecord() {}
    
public:
    /**
     *  刷新用户基本信息(用户名, 余额...)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshUserInfo();
    /**
     *  刷新绑定信息(生份证, 手机号, 提款密码)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshBindInfo();
    
    /**
     *  刷新购彩记录
     *
     *  @param type   [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *  @param reload [in]是否是重新加载, true 会清空所有记录并重新请求, false 则继续请求下20条
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshBuyRecord(int type, bool reload = false);
    /**
     *  资金明细
     *
     *  @param type   [in]类型 0:收支明细, 1:充值明细, 2:提款明细
     *  @param reload [in]是否是重新加载, true 会清空所有记录并重新请求, false 则继续请求下20条
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshFundRecord(int type, int reload = false);
    
public:
    /**
     *  获取用户基本信息
     *
     *  @param userName      [out]用户名
     *  @param realAmt       [out]余额
     *  @param coinAmt       [out]大彩币
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetUserInfo(string &userName, string &realAmt, int &coinAmt, int &redElpCount);
    /**
     *  获取是否绑定信息
     *
     *  @param drawPwdBound  [out]是否已设置提款密码
     *  @param mobileBound   [out]是否已绑定手机号
     *  @param identityBound [out]是否已绑定手机号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int IsUserBound(int &drawPwdBound, int &mobileBound, int &identityBound);
    /**
     *  获取是否能够修改用户名
     *
     *  @return 0:不可修改, 1:修改用户名和设置密码, 2:只能修改用户名
     */
    int CanEditUserName();
    /**
     *  获取绑定信息
     *
     *  @param phoneNumber  [out]手机号码
     *  @param actualName   [out]真实姓名
     *  @param idCardNumber [out]身份证号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetBindInfo(string &phoneNumber, string &actualName, string &idCardNumber);
    
public:
    /**
     *  获取购彩记录数
     *
     *  @param type [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetBuyRecordCount(int type, int &moreData);
    
    /**
     *  获取购彩记录基本信息
     *
     *  @param type          [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *  @param index         [in]在该类型中的索引
     *  @param gameType      [out]彩种
     *  @param time          [out]下单时间
     *  @param buyType       [out]购买类型(1:代购, 2:合买, 3:保存, 4:追号(不显示文字), 6:追号进行中, 7:追号已结束)
     *  @param projectStatus [out]方案状态(1:未满,        3:撤单, 4:流标, 5:未付款, 6:暂未中奖, 7:未中奖, 8:等待开奖,9:出票失败, 10:真实中奖(显示金额), 11:等待付款, 12:已过期, 13:已撤销)
     *  @param isWined       [out]是否中奖, 0:未中奖, 1:中奖
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetBuyRecord(int type, int index, int &gameType, string &time, int &buyType, int &projectStatus, int &isWined, string &winAmt);
    
    /**
     *  获取非追号方案信息
     *
     *  @param type     [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *  @param index    [in]在该类型中的索引
     *  @param gameName [out]期号
     *  @param amount   [out]金额
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetRecordUnfollow(int type, int index, int &gameName, int &amount);
    /**
     *  获取追号方案信息
     *
     *  @param type         [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *  @param index        [in]在该类型中的索引
     *  @param currPeriod   [out]已追期数
     *  @param totalPeriod  [out]方案总期数
     *  @param currAmt      [out]已追金额
     *  @param totalAmt     [out]方案总金额
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetRecordFollow(int type, int index, int &currPeriod, int &totalPeriod, int &currAmt, int &totalAmt);
    
    /**
     *  获取未满方案进度
     *
     *  @param type          [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *  @param index         [in]在该类型中的索引
     *  @param schedule      [out]方案进度 (0~100)
     *  @param hasGuaranteed [out]是否有保底
     *  @param guaranteed    [out]保底进度 (0~100)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetRecordSchedule(int type, int index, int &schedule, int &hasGuaranteed, int &guaranteed);
    
    /**
     *  获取购彩记录方案id
     *
     *  @param type             [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *  @param index            [in]在该类型中的索引
     *  @param projectId        [out]方案id
     *  @param gameType         [out]彩种
     *  @param purchaseOrderId  [out]未支付
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetRecordProjectId(int type, int index, int &projectId, int &gameType, int &purchaseOrderId);
    /**
     *  获取购彩记录天信息
     *
     *  @param type     [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖)
     *  @param index    [in]在该类型中的索引
     *  @param dayIndex [out]同一天的dayIndex相同, 从0开始
     *  @param dayBegin [out]是否是该天的第一条记录
     *  @param dayEnd   [out]是否是该天的最后一条记录
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetRecordDayInfo(int type, int index, int &dayIndex, int &dayBegin, int &dayEnd);
    
public:
    /**
     *  获取资金明细记录数
     *
     *  @param type    [in]类型 (0:收支, 1:充值, 2:提款)
     *  @param hasMore [out]是否有更多数据
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetFundRecordCount(int type, int &hasMore);
    /**
     *  获取资金明细记录基本信息
     *
     *  @param type     [in]类型 (0:收支, 1:充值, 2:提款)
     *  @param index    [in]索引
     *  @param time     [out]记录产生时间
     *  @param dayIndex [out]同一天的dayIndex相同, 从0开始
     *  @param dayBegin [out]是否是该天的第一条记录
     *  @param dayEnd   [out]是否是该天的最后一条记录
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetFundRecordBaseInfo(int type, int index, string &time, int &dayIndex, int &dayBegin, int &dayEnd);
    /**
     *  获取收支明细信息
     *
     *  @param type        [in]类型 (0:收支, 1:充值, 2:提款)
     *  @param index       [in]索引
     *  @param typeName    [out]收支类型
     *  @param isProject   [out]是否是购买方案产生的记录
     *  @param orderId     [out]订单id
     *  @param amount      [out]金额
     *  @param accountType [out]账户类型 (1:资金 2:大彩币 3:红包)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetFundRecordIncomeExpenses(int type, int index, string &typeName, int &isProject, int &orderId, string &amount, int &accountType);
    /**
     *  获取充值明细信息
     *
     *  @param type     [in]类型 (0:收支, 1:充值, 2:提款)
     *  @param index    [in]索引
     *  @param typeName [out]充值类型
     *  @param status   [out]状态 e.g. "已处理"
     *  @param amount   [out]金额 e.g. "20.00"
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetFundRecordRecharge(int type, int index, string &typeName, string &status, string &amount);
    /**
     *  获取提款明细信息
     *
     *  @param type     [in]类型 (0:收支, 1:充值, 2:提款)
     *  @param index    [in]索引
     *  @param cardName [out]提款账户
     *  @param cardNo   [out]提款卡号
     *  @param status   [out]状态
     *  @param amount   [out]金额
     *  @param charge   [out]手续费 e.g.
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetFundRecordWithdraw(int type, int index, string &cardName, string &cardNo, string &status, string &amount, string &charge);
    
public:
    /**
     *  清空已经请求的购彩记录
     *
     *  @param type [in]类型(0:全部, 1:待支付 2:待开奖, 3:追号, 4:中奖, >=5:所有tab全清空)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ClearBuyRecord(int type);
    /**
     *  清空已经请求的资金明细
     *
     *  @param type [in]类型(0:收支, 1:充值, 2:提款)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ClearFundRecord(int type);
    
protected:
    int _dealNotifyUserInfo(DCHttpRes &data);
    int _dealNotifyBuyRecord(DCHttpRes &data, bool reload);
    int _dealNotifyFundRecord(DCHttpRes &data, int reload);
    int _dealNotifyBindInfo(DCHttpRes &data);
    
    int _parserUserInfo(Json::Value &value);
    
protected:
    // 购彩记录
    int mBuyRecordReload[5];
    int mBuyRecordTotal[5];
    vector<CBuyRecordTarget *> mBuyRecords[5]; // 全部
    
    // 资金明细
    int mFundRecordTotal[3];
    vector<CFundRecordTarget *> mFundRecords[3];
    
    // 实名相关
    bool mDrawPwdBounded;
    bool mMobileBounded;
    bool mIdentityBounded;
    string mActualName;   // 真实姓名
    string mIdCardNumber; // 身份证号
    string mPhoneNumber;  // 手机号
    
    // 余额
    string mRealAmt; // 真实金额
    int mCoinAmt;    // 大彩币
    int mUserRedElpCount;   // 红包个数
    int mIsCanEditName; // 是否可以修改用户名  0:不可修改, 1:修改用户名和设置密码, 2:只能修改用户名
};


#endif /* defined(__DacaiProject__PersonalRecord__) */
