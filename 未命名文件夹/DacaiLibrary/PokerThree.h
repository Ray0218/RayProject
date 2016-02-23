//
//  PokerThree.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __POKERTHREE_H__
#define __POKERTHREE_H__

#include <vector>
#include <string>
#include <iostream>
#include "SmartHighLotteryCell.h"
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "LotteryType.h"
#include "CommonMacro.h"
#include "NetLevel.h"
#include "ProjectInfo.h"
typedef enum _PKType {
    PKTypeBaoxuan,
    PKTypeDuizi,
    PKTypeBaozi,
    PKTypeTonghua,
    PKTypeShunzi,
    PKTypeTonghuashun,
    PKTypeRenxuan1,
    PKTypeRenxuan2,
    PKTypeRenxuan3,
    PKTypeRenxuan4,
    PKTypeRenxuan5,
    PKTypeRenxuan6,
} PKType;

#define PKNUMMAX 13

#define PKCountBaoxuan 5
#define PKCountBaozi 13
#define PKCountShunzi 12
#define PKCountTonghuashun 4
#define PKCountDuizi 13
#define PKCountTonghua 4
#define PKCountRenxuan 13

class CPokerThree : public CModuleBase, public WorkSleave, public CNotify, public CProjectInfo {
    class Data { //用于拷贝数据 存储数据
    public:
        Data() {
            for (int i = 0; i < PKNUMMAX; i++) num[i] = 0;
        }
        int num[PKNUMMAX];
        PKType Type;
    };
    class PlayCell {
    public:
        PlayCell() {}
        int count;
        string name;
        int type;
        int SelfMultiple;
        string number;
        vector<Data *> m_dataList;
    };
public:
    CPokerThree();
    ~CPokerThree() {
        if (mSmartCell)
            delete mSmartCell;
    }

    int Refresh();
    int GetGameStatus(int &gameName, string &drawTime);
    /**
     *  获取当前期信息
     *
     *  @param name    [out]期号
     *  @param endTime [out]截止事件
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetInfo(int &gameName, string &endTime);
    /**
     *  获取历史期开奖号码
     *
     *  @param index  [in]索引
     *  @param name   [out]期号
     *  @param type   [out]花色, 1: 方块 2:红桃 3:梅花 4:黑桃 (d方块 r红桃 p梅花 s黑桃)
     *  @param result [out]开奖号码
     *
     *  @return <0表示失败, >=0表示成功, 0表示已开奖号, 1表示正在开奖
     */
    int GetHistory(int index, int &name, int type[3], int result[3]);
    /**
     *  获取遗漏值
     *
     *  @param subType [in]玩法
     *  @param mis     [out]遗漏值
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMiss(PKType subType, int mis[PKNUMMAX]);
    /**
     *  添加投注内容
     *
     *  @param num     [in]投注内容 e.g. 同花玩法, { 1, 0, 0, 1 }表示选中黑桃, 方块
     *  @param subType [in]玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int AddTarget(int num[PKNUMMAX], PKType subType);
    /**
     *  获取投注内容数(中转界面行数)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetNum();
    /**
     *  获取指定的投注内容
     *
     *  @param index   [in]在中转界面的索引
     *  @param num     [out]投注内容
     *  @param subType [out]玩法
     *  @param note    [out]注数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTarget(int index, int num[PKNUMMAX], PKType &subType, int &note);
    /**
     *  修改指定的投注内容
     * 
     *  @param index   [in]在中转界面的索引
     *  @param num     [in]投注内容 e.g. 同花玩法, { 1, 0, 0, 1 }表示选中黑桃, 方块
     *  @param subType [in]玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ModifyTarget(int index, int num[PKNUMMAX], PKType subType);
    /**
     *  删除投注内容
     *
     *  @param index [in]在中转界面的索引
     *
     *  @return <0表示失败, >=0表示成功
     */
    int DelTarget(int index);
    /**
     *  清空所有扑克三的数据
     */
    void ClearTarget();
    /**
     *  清空期号信息
     */
    void ClearGameInfo();
    /**
     *  计算注数
     *
     *  @param num     [in]投注内容 e.g. 同花玩法, { 1, 0, 0, 1 }表示选中黑桃, 方块
     *  @param subType [in]玩法
     *
     *  @return <0表示失败, >=0表示成功, 即注数
     */
    int NotesCalculate(int num[PKNUMMAX], PKType subType);
    /**
     *  计算奖金
     *
     *  @param num       [in]用户投注内容
     *  @param subType   [in]子玩法
     *  @param minBonus  [out]最小奖金
     *  @param maxBonus  [out]最大奖金
     *  @param minProfit [out]最小盈利
     *  @param maxProfit [out]最大盈利
     *
     *  @return <0表示失败, >=0表示成功
     */
    int BonusCalculate(int num[PKNUMMAX], PKType subType, int &minBonus, int &maxBonus, int &minProfit, int &maxProfit);
    /**
     *  获取总注数
     *
     *  @return <0表示失败, >=0表示成功, 即注数
     */
    int GetTotalNote();
    /**
     *  普通代购
     *
     *  @param multiple    [in]倍数
     *  @param followCount [in]追号期数
     *  @param winedStop   [in]中奖后是否停止追号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetOrderInfo(int multiple, int followCount, bool winedStop);
    /**
     *  智能追号
     *
     *  @param multiple  [in]各期倍数
     *  @param winedStop [in]中奖后是否停止追号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetCapacityInfo(int *followMultiple, int followCount, bool winedStop);
    /**
     *  下单
     *
     *  @return <0表示失败, >=0表示成功, 即cmdId
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
    // for Andriod
    int GetNonPayment(int &needAmt, string &realAmt);
    
	int TimeOut();
    bool TimeOutLived();
    
    DEPRECATED int GetInfo(int result[3], string &name);
    DEPRECATED int GetTarget(int index, int num[PKNUMMAX], PKType &subType);
    
    // 智能追号
    int CapacityBonusRange(int &minBonus, int &maxBonus);
    
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
	virtual int PrepareSend(string &head, string &body);
	virtual int SendDone(DCHttpRes &res, int tag);
    int _dealNotifyRefresh(DCHttpRes &data);
    int _dealNotifyGoPay(DCHttpRes &data);
    int _insertTarget(int index, int num[PKNUMMAX], PKType subType);
	int _dealProjectInfo2(DCHttpRes &res);
    
    
	/////////////////////////////////////////////方案详情（标准模式）
    int _projectInfoClear();
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int GetPTargetNum();  
	int GetPTarget(int index, string &name, string &FirstNum, int &count,int &subTargetNum, int & type);
	int GetPSubTarget(int index, int subindex, int num[PKNUMMAX], PKType &subType);
	int ProjectInfoClear();
	int PSave();
		protected:
			vector< PlayCell *> m_playList;//方案中所有玩法
			vector<Data *> m_SaveList;//用于保存数据
protected:
    CSmartHighLotteryCell *mSmartCell;

    int mMissBaoxuan[PKCountBaoxuan];
    int mMissBaozi[PKCountBaozi];
    int mMissShunzi[PKCountShunzi];
    int mMissTonghuashun[PKCountTonghuashun];
    int mMissDuizi[PKCountDuizi];
    int mMissTonghua[PKCountTonghua];
    int mMissRenxuan[PKCountRenxuan];
    
    int mStep;  
};

#endif
