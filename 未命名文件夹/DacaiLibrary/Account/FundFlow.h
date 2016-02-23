//
//  FundFlow.h
//  DacaiProject
//
//  Created by WUFAN on 14/12/4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  支付模块
//

#ifndef __DacaiProject__FundFlow__
#define __DacaiProject__FundFlow__

#include <stdio.h>
#include "../ModuleBase.h"
#include "../include/json/json.h"
#include "AccountCommon.h"

class CFundFlow : virtual public CModuleBase {
public:
    
public: // 充值
    
    
public: // 提款
    
    
#pragma mark - 支付
public:
    /**
     *  合买跟单
     *
     *  @param type         [in]购买类型. 1:认购 2:保底
     *  @param projectId    [in]订单号
     *  @param amount       [in]金额
     *  @param gameType     [in]彩种Id
     *  @param redElpId     [in]红包id
     *
     *  @return <0表示失败, >=0表示成功
     */
    int JoinBuy(int type, int projectId, int amount, int gameType, int redElpId = 0);
    
public:
    /**
     *  获取支付信息, GoPay回调
     *
     *  @param type    [out]1:iOS钱够跳web, 2:Android未支付, 3:Android支付成功, 4:iOS未支付, 5:iOS支付成功
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetJoinBuyPayInfo(int &type);
    /**
     *  未支付流程
     *
     *  @param orderId [out]未支付订单id
     *  @param needAmt [out]需要的金额
     *  @param realAmt [out]用户实际金额
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetJoinBuyNonPayment(int &orderId, int &needAmt, string &realAmt);
    /**
     *  web支付流程
     *
     *  @param buyType [out]get请求参数
     *  @param token   [out]get请求参数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetJoinBuyWebPayment(int &buyType, string &token);
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
    int GetJoinBuySucPayment(int &pid, string &drawTime, string &tagline,string &event);
    
public:
    /**
     *  请求未支付订单信息
     *
     *  @param orderId [in]订单id
     *
     *  @return <0表示失败, >=0表示成功
     */
    int NotHandlePay(int orderId);
    
    /**
     *  iOS请求未支付订单在Safari上使用的token, 在Safari上进行充值操作(支付宝)
     *
     *  @param amt     [in]支付金额
     *  @param orderId [in]订单id
     *
     *  @return cmdId
     */
    int NGenNotPayRedis(string amt, int orderId);
    
    /**
     *  Android未支付余额够情况下激活订单
     *
     *  @param orderId [in]订单id
     *
     *  @note ACCOUNT_ACTIVE_CONFIRMPAY
     *
     *  @return cmdId
     */
    int ActivateConfirmPay(int orderId);
    
public:
    /**
     *  获取未支付订单信息
     *
     *  @param orderId  [out]订单id
     *  @param realAmt  [out]用户账户余额
     *  @param needAmt  [out]还要支付的金额
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetNotPayInfo(int &orderId, string &realAmt, int &needAmt);
    
    /**
     *  iOS余额足够时, 获取Safari上直接支付该订单的token
     *
     *  @param purchaseOrderToken  [out]未支付订单token, 余额够使用
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetNotPayOrderToken(string &token);
    
    /**
     *  iOS获取未支付充值, Safari上的token
     *
     *  @param token [out]
     *
     */
    int GetNotPayTopupToken(string &token);
    
    /**
     *  Android未支付钱够, 成功支付后获取信息
     *
     *  @param pid      [out]方案id
     *  @param drawTime [out]开奖时间
     *  @param tagline  [out]宣传语
     *  @param event    [out]宣传链接
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetActivePayment(int &projectId, string &drawTime, string &tagline,string &event);
    
public:
    /**
     *  刷新红包信息
     *
     *  @param gameType  [in]彩种
     *  @param buyType   [in]购买类型, 1:发起代购 2:发起合买 3:跟单认购 4:跟单保底
     *  @param buyAmt    [in]认购金额
     *  @param fillAmt   [in]保底金额
     *  @param projectId [in]方案id, 跟单时用来判断方案是否已满
     *
     *  @note 回调, ret 错误 ERROR_REDPKT_PRO_PASS, 方案已满或流标, 不能继续购买
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshRedPacket(int gameType, int buyType, int buyAmt, int fillAmt, int projectId = 0);
    
    /**
     *  获取支付红包数
     *
     *  @return <0表示失败, >=0表示成功, 即红包个数
     */
    int GetPayRedPacketCount();
    /**
     *  获取支付信息
     *
     *  @param realAmt    [out]账户余额
     *  @param identifier [out]红包id数组
     *  @param name       [out]红包名称数组
     *  @param date       [out]红包过期时间数组
     *  @param curAmt     [out]红包余额数组
     *  @param origAmt    [out]红包原始金额数组
     *
     *  @return <0表示失败, >=0表示成功, 即红包个数
     */
    int GetPayRedPacketInfo(string &realAmt, vector<int> &identifier, vector<string> &scope, vector<string> &date, vector<int> &curAmt, vector<int> &origAmt);
    
protected:
    int _dealJoinBuy(DCHttpRes &data);
    int _dealNotHandlePay(DCHttpRes &data);
    int _dealGenRedis(DCHttpRes &data);
    int _dealActiveConfirmPay(DCHttpRes &data);
    int _dealRedPacket(DCHttpRes &data);
    
protected:
    struct {
        int PayType; // 1:iOS 2:Andriod 未支付 3:Andriod 成功 4:iOS 未支付 5:iOS 成功
        int BuyType;    // 该参数在Safari上使用, 标识
        string Token;
        int OrderId;
        int ProjectId;
        int NeedAmt;
        string RealAmt;
        string DrawTime;
        string Tagline;
        string Event;
    } mPayInfo;
    
    struct {
        // Android
        int PurchaseOrderId;    // 未支付订单id
        string ActualUsableBalance; // 用户余额
        int NeedAmt;    // 需要支付
        string PurchaseOrderToken;    // 未支付token
        string RedisToken;
    } mNotHandlePay;
    
    
    typedef struct RedPacketItem {
        string Name;           // 红包名称, "通用无次数红包"
        string ExpirationDate; // 有效时间, "2014年8月前有效",
        string Scope;          // 范围, "北单通用普通",
        int CurrentAmount;     // 100,
        int OriginalAmount;    // 50
        int Identifier;        // 红包id
        
        RedPacketItem(Json::Value value) {
            ExpirationDate = value["InDate"].asString();
            Name = value["RedEnvelopesTypeName"].asString();
            Scope = value["Description"].asString();
            CurrentAmount = value["CurrentAmount"].asInt();
            OriginalAmount = value["OriginalAmount"].asInt();
            Identifier = value["LotteryUserRedElpId"].asInt();
        }
    } RedPacketItem;
    
    struct {
        string RealAmt;
        vector<CFundFlow::RedPacketItem *> List;
        
        void clear() {
            for (int i = 0; i < List.size(); i++) {
                if (List[i]) {
                    delete List[i];
                    List[i] = NULL;
                }
            }
            List.clear();
        }
    } mPayRedPacket;
};

#endif /* defined(__DacaiProject__FundFlow__) */
