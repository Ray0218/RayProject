//
//  SevenLuck.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __SEVENLUCK_H__
#define __SEVENLUCK_H__

#include <iostream>
#include <string>
#include <vector>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "SmartDigitalLotteryCell.h"
#include "LotteryType.h"
#include "CommonMacro.h"
#include "ProjectInfo.h"
using namespace std;

#define QLCNUM 30
#define QLCPos 0

class CSevenLuck : public CModuleBase, public CNotify, public CProjectInfo {
	class Data{//用于拷贝数据 存储数据
	public:
		Data(){
			for (int i = 0; i < QLCNUM; i++)
			{
				 num[i] = 0;

			}

		}
		int num[QLCNUM];

	};
	class PlayCell{
	public:
		PlayCell(){}

		int count;

		vector<Data *> m_dataList;
		string name;
		int type;
	};
public:
    int Refresh();
    int GetGameStatus(int &lastGameName, int &currGameName, string &drawTime);
    int GetMiss(int mis[QLCNUM]);
    int GetHistory(int index, int &gameName, int result[8]);
    int GetInfo(int &gameName, string &endTime, int &globalSurplus);
    int SetOrderInfo(int multiple, int followCount, bool winedStop);
    int NotesCalculate(int num[QLCNUM]);
    int AddTarget(int num[QLCNUM]);
    int MotifyTarget(int index, int num[QLCNUM]);
    int DelTarget(int index);
    int GetTargetNum();
    int GetTarget(int index, int num[QLCNUM], int &note);
    int GetTotalNote();
    void ClearTarget();
    void ClearGameInfo();
    int SetTogetherInfo(int accessType, int commission, int buyAmt, int fillAmt);
    int SetTogetherType(bool isTogetherBuy);
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

    DEPRECATED int GetHistory(int results[80], int names[10]);
    DEPRECATED int GetInfo(int result[8], string &name, int mis[QLCNUM]);
    DEPRECATED int GetTarget(int index, int num[QLCNUM]);

public:
    CSevenLuck();
    ~CSevenLuck() {
        if (mSmartCell)
            delete mSmartCell;
    }

    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
	/////////////////////////////////////////////方案详情（标准模式）
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int ProjectInfoClear();//清除所有数据
	int GetPTargetNum();
	int GetPTarget(int index, string &name, int &subTargetNum,int &count, int & type);
	int GetPSubTarget(int index, int subindex, int num[QLCNUM]);
	int PSave();
protected:
	vector< PlayCell *> m_playList;//方案中所有玩法
	vector<Data *> m_SaveList;//用于保存数据

protected:
    int _projectInfoClear();
    int _dealNotifyRefresh(DCHttpRes &res);
    int _dealNotifyGoPay(DCHttpRes &data);
	int _dealProjectInfo2(DCHttpRes &res);
protected:
    int mMissValue[QLCNUM];
    CSmartDigitalLotteryCell *mSmartCell;
};

#endif
