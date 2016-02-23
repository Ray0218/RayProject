//
//  QuickThree.h
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//


#ifndef __QUICKTHREE_H__
#define __QUICKTHREE_H__


#include <iostream>
#include <string>
#include <vector>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "SmartQuickLotteryCell.h"
#include "LotteryType.h"
#include "CommonMacro.h"
#include "ProjectInfo.h"
#include "NetLevel.h"

using namespace std;

#define KSNUMMAX   108

typedef enum _KSType {
    KSTypeHezhi = 0,
    KSTypeDuizi,
    KSTypeBaozi,
    KSTypeShunzi,
    KSTypeErbutong,
    KSTypeSanbutong,
    
} KSType;

// 91,内蒙古快三和值,NmgksHz
// 92,内蒙古快三三同号通选,NmgksSthtx
// 93,内蒙古快三三同号单选,NmgksSthdx
// 94,内蒙古快三三不同号,NmgksSbth
// 95,内蒙古快三三连号通选,NmgksSlhtx
// 96,内蒙古快三二同号复选,NmgksEthfx
// 97,内蒙古快三二同号单选,NmgksEthdx
// 98,内蒙古快三二不同号,NmgksEbth

#define KSCountHezhi        16
#define KSCountDuizi        36
#define KSCountBaozi        7
#define KSCountShunzi       5
#define KSCountErbutong     15
#define KSCountSanbutong    21

#define KSCountMax          36

#define KSChip2Amount       2
#define KSChip10Amount      10
#define KSChip50Amount      50

class CQuickThree : public CModuleBase, public CNotify, public WorkSleave, public CProjectInfo {
    class Data { //用于拷贝数据 存储数据
    public:
        Data() {
            for (int i = 0; i < KSNUMMAX; i++) num[i] = 0;
        }
        int num[KSNUMMAX];
        KSType Type;
    };
    class PlayCell {
    public:
        PlayCell() {}
        int count;
        string name;
        int type;
        int SelfMultiple;
        string Dan;
        string number;
    };
public:
    int Refresh();
    int GetGameStatus(int &gameName, string &drawTime);
    /**
     *  添加投注内容
     *
     *  @param num     [in]一维数组, 每个格子有3种筹码, 将一格扩充为3格.    0.0.0|0.0.0|...|0.0.0
     *  @param subType [in]子玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int AddTarget(int num[KSNUMMAX], KSType subType);
    /**
     *  修改投注内容
     *
     *  @param index   [in]在中转界面的索引
     *  @param num     [in]一维数组, 每个格子有3种筹码, 将一格扩充为3格.    0.0.0|0.0.0|...|0.0.0
     *  @param subType [in]子玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ModifyTarget(int index, int num[KSNUMMAX], KSType subType);
    /**
     *  删除一注内容
     *
     *  @param index [in]在中转界面的索引
     *
     *  @return <0表示失败, >=0表示成功
     */
    int DelTarget(int index);
    /**
     *  获取当前期信息
     *
     *  @param name    [out]期号
     *  @param endTime [out]截止时间
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetInfo(int &name, string &endTime);
    /**
     *  获取历史开奖号码
     *
     *  @param index  [in]索引
     *  @param result [out]开奖号码
     *  @param name   [out]期号
     *
     *  @return <0表示失败, >=0表示成功, 1表示等待开奖, 0表示已开奖号
     */
    int GetHistory(int index, int result[3], int &name);
    /**
     *  获取遗漏值
     *
     *  @param mis     [out]遗漏值
     *  @param subType [in]子玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetMiss(int mis[KSCountMax], KSType subType);
    /**
     *  获取已选注数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetNum();
    /**
     *  返回投注内容
     *
     *  @param index   [in]索引
     *  @param content [out]0: 2元筹码个数, 1:10元筹码个数, 2:50元筹码个数
     *  @param note    [out]注数
     *  @param subType [out]子玩法
     *  @param pos     [out]在该玩法中的索引
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTarget(int index, int content[3], int &note, KSType &subType, int &pos);
    /**
     *  获取总注数
     *
     *  @return <0表示失败, >=0为总注数
     */
    int GetTotalNote();
    /**
     *  计算注数
     *
     *  @param num [in]用户投注内容
     *
     *  @return <0表示失败, 0表示不是有效的内容, >0为计算所得的注数
     */
    int NotesCalculate(int num[KSNUMMAX]);
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
    int BonusCalculate(int num[KSNUMMAX], KSType subType, int &minBonus, int &maxBonus, int &minProfit, int &maxProfit);
    /**
     *  清空所有数据
     */
    void ClearTarget();
    /**
     *  清空期号信息
     */
    void ClearGameInfo();
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
     *  @param asyc 异步
     *
     *  @return <0表示失败, >=0表示成功, 为cmdId
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
    
    int TimeOut();
    
    /**
     *  返回投注内容
     *
     *  @param index   [in]索引
     *  @param content [out]0: 2元筹码个数, 1:10元筹码个数, 2:50元筹码个数
     *  @param subType [out]子玩法
     *  @param pos     [out]在该玩法中的索引
     *
     *  @return <0表示失败, >=0表示成功
     */
    DEPRECATED int GetTarget(int index, int content[3], KSType &subType, int &pos);
    
public: // 智能追号相关
    int CapacityBonusRange(int &minBonus, int &maxBonus);
    
public:
    CQuickThree();
    ~CQuickThree() ;
    
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd,int specialData, int tag);
    virtual int PrepareSend(string &head,string &body);
    virtual int SendDone(DCHttpRes &res, int tag);
    
	/////////////////////////////////////////////方案详情（标准模式）
    int _projectInfoClear();
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int _dealProjectInfo2(DCHttpRes &res);
	int ProjectInfoClear();

	int GetPTargetNum();
	int GetPTarget(int index, string &name,string &FirstNum,string &SecondNum, int &count ,int & SelfMultiple, int & type);
	//int GetPSubTarget(int index, int subindex, int num[QLCNUM]);
	int PSave();

	protected:
		vector<PlayCell *> m_playList;//方案中所有玩法
		vector<Data *> m_SaveList;//用于保存数据

		
protected:
    int _dealNotifyRefresh(DCHttpRes &res);
    int _dealNotifyGoPay(DCHttpRes & data);
    int _insertTarget(int index, int num[KSNUMMAX], KSType subType);
	int __GetDiffThreePos(int a, int b, int c);
	int __GetShunziPos(int a, int b);
	int __GetDiffTwoPos(int a, int b);
    int mMissHezhi[KSCountHezhi];
    int mMissDuizi[KSCountDuizi];
    int mMissBaozi[KSCountBaozi];
    int mMissShunzi[KSCountShunzi];
    int mMissErbutong[KSCountErbutong];
    int mMissSanbutong[KSCountSanbutong];
    
    CSmartQuickLotteryCell *mSmartCell;
    int mStep;
};

#endif