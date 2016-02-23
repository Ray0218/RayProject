//
//  Account.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__Account__
#define __DacaiProject__Account__

#include <iostream>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "NetLevel.h"
#include "include/json/json.h"
#include "Error.h"
#include "Account/PersonalRecord.h"
#include "Account/FundFlow.h"
#include "Account/SecurityCenter.h"

class DrawBankInfo {
public:
    int BankId;
    string BankName;
    string BankAccountNo;
    string BankShortName;
};

class ProvinceInfo //城市信息
    {
public:
    string name;
    int provinceId;
};
class CityInfo //城市信息
    {
public:
    string name;
    int cityId;
};

class CAccount : public CPersonalRecord, public CFundFlow, public CSecurityCenter, public CNotify {
public:
    CAccount();
    /**
     *  异步登录
     *
     *  @param userName [in]用户名
     *  @param password [in]密码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Login(const char *userName, const char *password) {
        return Net_Login(userName, password);
    }
    /**
     *  异步注册
     *
     *  @param userName [in]用户名
     *  @param password [in]密码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Reg(const char *userName, const char *password) {
        return Net_Reg(userName, password);
    }
    
    /**
     *  注销
     *
     *  @return <0表示失败, >=0表示成功
     */
    int Logout();
    
    /**
     *  刷新提款信息(支付宝, 银行卡号)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int RefreshDrawInfo();
    
    /**
     *  绑定身份证
     *
     *  @param identifier [in]身份证
     *  @param actualName [in]姓名
     *
     *  @return <0表示失败, >=0表示成功
     */
    int BindIdentifierCard(string identifier, string actualName);
    /**
     *  验证已经绑定手机号(解除绑定用)
     *
     *  @param phoneNumber [in]已绑定的手机号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int CheckMobilePhone(string phoneNumber);
    /**
     *  获取验证码
     *
     *  @param phoneNumber [in]手机号码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SendBindSMS(string phoneNumber);
    
    /**
     *  修改手机号码
     *
     *  @param oldPhone [in]旧手机
     *  @param newPhone [in]新手机
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ModifyBindPhone(string oldPhone, string newPhone);
    /**
     *  绑定手机号
     *
     *  @param verifyCode  [in]验证码
     *  @param phoneNumber [in]手机号码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int BindMobilePhone(string verifyCode, string phoneNumber);

    /**
     *  重置登录密码
     *
     *  @param oldPwd [in]老密码
     *  @param newPwd [in]新密码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ResetLoginPwd(string oldPwd, string newPwd);
    /**
     *  重置提款密码
     *
     *  @param oldDrawPwd [in]老提款密码
     *  @param newDrawPwd [in]新提款密码
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ResetDrawPwd(string oldDrawPwd, string newDrawPwd);
    

    
    
    
    //////////////////////提款
    /**
	*  设置提款密码
	
	*  @param loginPwd   [in]登陆密码
	*  @param pwd   [in] 提款密码
	*  @return <0表示失败, >=0表示成功
	*/
    int SetDrawPwd(string loginPwd, string pwd); //设置提款密码
    //////////////////////目前不需要
    int RefreshProvince(); //目前不需要

    int GetProvinceNum();                                          //获取省份个数 目前不需要
    int GetProvinceInfo(int index, int &provinceId, string &name); //获取特定省份信息 目前不需要
    int RefreshCity(int provinceid);                               //刷新城市  目前不需要
    ////////////////////// 提款
    
    
    int RefreshDrawBanks();
    /**
	 *  获取提款银行列表信息
	 *  @param realAmt      [out] 可提款金额
	 *  @param IsIdCarBound [out]是否有实名认证
	 *  @param IsDrawPwd    [out]是否设置提款密码
	 *  @param BankNum      [out]提款绑定银行个数
	 *  @return <0表示失败, >=0表示成功
	**/
    int GetDrawBanksInfo(string &realAmt, int &IsIdCarBound, int &IsDrawPwd, int &BankNum);
    /**
	 *  获取提款银行信息
	 *  @param index         [in]
	 *  @param BankId        [out]
     *  @param BankName      [out]银行名
     *  @param BankAccountNo [out]卡号
     *  @param bankShortName [out]银行简称
	 *  @return <0表示失败, >=0表示成功
    **/
    int GetDrawBanks(int index, int &bankId, string &bankName, string &bankAccountNo, string &bankShortName);
    /**
	*  获取提款银行卡所属行
	*  @return <0表示失败, >=0表示成功
	*/
    int RefreshBankName(string cardId);
    int GetBankNameFromId(string &bankCode, string &bankName, string &bankJc);
    //////////////////////////////////////////
    /*
	*
	*
	*/
    /////////////////////////////////////////////获取手续费
    int RefreshCharge(int amt, string BankCardNo, int BankId);
    int GetCharge(int &charge);
    ////////////////////////////////////////////////提款动作
    /**
	*  提款
	* BankId   [in] 银行id
	*Amt  [in]  提款金额
	*DrawPwd  [in] 提款密码
	* 
	*  @return <0表示失败, >=0表示成功
	*/
    int SubmitDrawMoney1(int BankId, int Amt, string DrawPwd);
    //已经认证，已有提款密码，新增银行卡
    int SubmitDrawMoney2(string BackCode, string BankName, string BankCardNumber, int Amt, string DrawPwd);
    // 已经实名 新增卡 没有设置提款密码
    int SubmitDrawMoney4(string BankCode, string BankName, string BankCardNumber, int Amt, string DrawPwd);

    // 已经实名  已有提款账号 没有设置提款密码
    int SubmitDrawMoney3(int BankId, int Amt, string DrawPwd);
    //无实名 新增卡 没有设置提款密码
    int SubmitDrawMoney5(string BankCode, string BankName, string BankCardNumber, int Amt, string DrawPwd, string IdCard, string ActualName);
    /**
     *  获取提款后到账信息
     *
     *  @param amount     [out]提款金额
     *  @param handfee    [out]手续费
     *  @param balance    [out]用户余额
     *  @param arriveTime [out]到账时间
     *
     *  @return <0表示失败, >=表示成功
     */
    int GetDrawMoneyInfo(string &amount, string &handfee, string &balance, string &arriveTime);
    
    // 红包列表
    int RefreshActRedPacket();
    void ClearActRedPacket();
    int GetRedPacketUseableCount();
    int GetRedPacketSendingCount();
    int GetRedPacketTerminateCount();
    int GetRedPacketUseableTarget(int index, int &origAmt, int &currAmt, string &name, string &desc, string &date);
    int GetRedPacketSendingTarget(int index, int &amount, string &name, string &desc, string &date);
    int GetRedPacketTerminateTarget(int index, int &amount, string &name, string &desc, string &status);
    
    // 找回密码, 修改已绑定手机号码
    int GetCodeExpireTime(int &expireTime); // 获取验证码超时时间
    
    // 找回密码
    int SendFindPasswordCode(string userName, string mobileNumber, int tag = 0);
    int CheckFindPasswordCode(string userName, string code, string mobile, int tag = 0);
    int ResetFindPassword(string userName, string newPwd, string code, int tag = 0);
    
protected:
    typedef struct AccoundRedPacketItem {
        int ExpirationType;    // 1:永不过期, 2:某个时间点过期, 3:某些天后过期
        string ExpirationDesc; // "永不过期", "2014-12-12到期"

        int StatusId;      // 1:有效, 2:失效
        string StatusName; // 有效, 已用完, 已过期

        string Name;             // "数字彩通用红包"
        string Description;      // "仅限双色球, 大乐透"
        int CurrentAmount;       // 50
        int OriginalAmount;      // 150
        string ExpectedSendTime; // 派发时间, "2014-08-09"

        AccoundRedPacketItem(Json::Value value) {
            CurrentAmount = value["CurrentAmount"].asInt();
            OriginalAmount = value["OriginalAmount"].asInt();

            ExpirationType = value["ExpirationType"].asInt();
            ExpirationDesc = value["ExpirationDate"].asString();
            if (ExpirationDesc.length() == 0) {
                ExpirationDesc = "永不过期";
            }

            StatusId = value["StatusId"].asInt();
            switch (StatusId) {
                case 1:
                    StatusName = "有效";
                    break;
                case 2:
                    StatusName = CurrentAmount == 0 ? "已用完" : "已过期";
                    break;
                default:
                    break;
            }

            Description = value["Description"].asString();
            Name = value["Name"].asString();
            ExpectedSendTime = value["ExpectedSendTime"].asString();
        }

    } AccoundRedPacketItem;

    struct {
        vector<AccoundRedPacketItem *> UseableList;
        vector<AccoundRedPacketItem *> SendingList;
        vector<AccoundRedPacketItem *> TerminateList;

        void Clear() {
            for (int i = 0; i < UseableList.size(); i++) {
                if (UseableList[i]) {
                    delete UseableList[i];
                    UseableList[i] = NULL;
                }
            }
            for (int i = 0; i < SendingList.size(); i++) {
                if (SendingList[i]) {
                    delete SendingList[i];
                    SendingList[i] = NULL;
                }
            }
            for (int i = 0; i < TerminateList.size(); i++) {
                if (TerminateList[i]) {
                    delete TerminateList[i];
                    TerminateList[i] = NULL;
                }
            }
            UseableList.clear();
            SendingList.clear();
            TerminateList.clear();
        }
    } mAccoundRedPacket;

public:
    #pragma mark - 充值
    // 微信在线
    int RefreshWeChatTopup(int Amt, int PurchaseOrderId = 0);
    int GetWeChatTopup(string &signature, string &noncestr, string &package, string &partnerid, string &prepayid, string &timestamp);
    // 银联充值
    int ReChargeByUnionPay(int Amt, int PurchaseOrderId = 0);
    int GetUnionPayInfo(string &MerchantId, string &MerchantOrderId, string &MerchantOrderTime, string &Sign);
    // 财付通
    int ReChargeByTencent(int Amt, int PurchaseOrderId = 0);
	int GetToken(string & tok);
    // 支付宝sdk
    int ReChargeByPayAlipay(int Amt, int PurchaseOrderId = 0);
    int ReChargeByPayAlipay(string amt, int PurchaseOrderId);
    int GetPayAlipayInfo(string &content, string &sign);
    // 连连
    int ReLianLianBanks();
    int GetLLUserInfo(bool &isBind, string &userName, string &userIdCard);
    int GetLianLianBanks(vector<string> &bankGUIDs, vector<string> &bankNames, vector<string> &bankTypes, vector<string> &bankCards);
    int ClearLianLianBank();
    // 未实名, 新增卡
    int BindLianLianBank(string bankNo, string userName, string userIdCard, int amt, int PurchaseOrderId = 0);
    int BindLianLianBank(string bankNo, string userName, string userIdCard, string amt, int PurchaseOrderId = 0);
    // 已经实名, 新增银行卡
    int AddLianLianBank(string bankNo, int amt, int PurchaseOrderId = 0);
    int AddLianLianBank(string bankNo, string amt, int PurchaseOrderId = 0);
    // 已经实名, 选择已有银行卡
    int UseBoundBankGUID(string bankGUID, int amt, int PurchaseOrderId = 0);
    int UseBoundBankGUID(string bankGUID, string amt, int PurchaseOrderId = 0);
    // 获取连连字典串
    int GetBindLianLianInfo(string &tokenJSON);
    // U付
    int ReUMPay(int amt, int PurchaseOrderId = 0);
    int GetUMPayTrade(string &tradeNo, string &idCard, string &actualName);
    
    

    //////////////////////////////////////////////////////////////
    
#pragma mark - 只提供给iOS
    
    
    /**
     *  兑换码接口
     *
     *  @param exchangeCode [in]兑换码
     *
     *  @return cmdId
     */
    int ExchangeRedPackage(string exchangeCode);
    
    //////////////////////////////跟单
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);

    int _dealNotifyBindId(DCHttpRes &data);
    int _dealNotifyChkMb(DCHttpRes &data);
    int _dealNotifySendSMS(DCHttpRes &data);
    int _dealNotifyModifyMB(DCHttpRes &data);
    int _dealNotifyModifyPwd(DCHttpRes &data);
    int _dealNotifyModifyDrawPwd(DCHttpRes &data);
    int _dealNotifyBindMb(DCHttpRes &data);

    int _dealSetDrawPwd(DCHttpRes &data);
    int _dealGetCity(DCHttpRes &data);
    int _dealGetProvince(DCHttpRes &data);
    int _dealDrawBank(DCHttpRes &data);
    int _dealBankName(DCHttpRes &data);
    int _dealCharge(DCHttpRes &data);
    int _dealDrawMoney1(DCHttpRes &data);
    int _dealDrawMoney2(DCHttpRes &data);
    int _dealDrawMoney3(DCHttpRes &data);
    int _dealDrawMoney4(DCHttpRes &data);
    int _dealWeChatTopup(DCHttpRes &data);
    int _dealPlayUnionPay(DCHttpRes &data);
    int _dealPlayTencent(DCHttpRes &data);
    int _dealPayAlipay(DCHttpRes &data);
    int _dealActPacketList(DCHttpRes &data);
    
    int _dealLLBankList(DCHttpRes &data);
    int _dealLLTopup(DCHttpRes &data);
    int _dealUMPayTopup(DCHttpRes &data);
    
    // 红包
    int _dealExchange(DCHttpRes &data);
    
    // 找回密码
    int _dealFindPwdGetCode(DCHttpRes &data);
    int _dealFindPwdChkCode(DCHttpRes &data);
    int _dealFindPwdSetPwd(DCHttpRes &res);
    int mExpireTime;
    int mValidationId;
    
protected:
    vector<ProvinceInfo> mProvinceList;
    int mProvinceIdOfCity; //保存的城市所在省信息
    vector<CityInfo> mCityList;
    ////////////////////////////////////

    ///////////////////提款信息
    vector<DrawBankInfo> mDrawBankList;
    int IsIdCarBound;
    int IsDrawPwd;
//    string WebUrl;
//    int ActualUsableBalance;
    /////////////////////////////校对银行卡
    string BankCode;
    string BankName;
    string BankJc;
    /////////手续费
    int Charge;
    ////////////微信在线充值
    struct {
        string Signature; // "67d4184166e4854ce8044ab55aeef577f647773b",
        string Noncestr;  // "00000000000000000000001639367810",
        string Package;   // "Sign=WXpay",
        string Partnerid; // "1218967601",
        string Prepayid;  // "11010000001409190668cdfeccc99fe9",
        string Timestamp; // "1411112146",
    } mWeChatTopup;
    

    string Token_id;
    //////////银联充值
    string MerchantId;
    string MerchantOrderId;
    string MerchantOrderTime;
    ///////////////
    // 跟单
    
    //////////////////////////
    ////////////////////////////////////支付红包
    
    
    typedef struct BankItem {
        string BankId;   // "23231212366223",
        string BankName; // "第三方第三方地方发单",
        string BankCard; // "6923",
        string BankType; // "储蓄卡"
    } BankItem;
    
    // 提款信息
    struct {
        string balance;     // 用户余额
        string arriveTime;  // 到账时间
        string handFee;     // 手续费
        string amount;      // 提款金额
        string actualAmount;// 真实到账金额
        
        void parser(Json::Value &value) {
            balance = value["Balance"].asString();
            arriveTime = value["ArriveTime"].asString();
            handFee = value["HandFee"].asString();
            amount = value["Amount"].asString();
            actualAmount = value["ActualAmount"].asString();
        }
    } mDrawInfo;
    
    struct {
        vector<BankItem *> Items;
        
        bool UserIdBound;
        string UserName;
        string UserIdCard;
        
        void clear() {
            for (int i = 0; i < Items.size(); i++) {
                if (Items[i]) {
                    delete Items[i];
                    Items[i] = NULL;
                }
            }
            Items.clear();
        }
        
        string JSONStream;
        
    } mLianLianBankList;
    
    struct {
        string TradeNo;
        string IdCard;
        string ActualName;
    } mUMPay;
};

#endif /* defined(__DacaiProject__Account__) */
