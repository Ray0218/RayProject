//
//  Pick5.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __PICK5_H__
#define __PICK5_H__

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

#define PWPosWan 0
#define PWPosQian 10
#define PWPosBai 20
#define PWPosShi 30
#define PWPosGe 40

#define PWNum 10

class CPick5 : public CModuleBase, public CNotify, public CProjectInfo {
	class Data{//用于拷贝数据 存储数据
	public:
		Data(){
			int i;

			for (i = 0; i < PWNum; i++)
			{

				wan[i] = qian[i] = bai[i] = shi[i] = ge[i] = 0;
			}

		}
		int wan[PWNum];
		int qian[PWNum];
		int bai[PWNum];
		int shi[PWNum];
		int ge[PWNum];

	};
	class PlayCell{
	public:
		PlayCell(){
			int i;
			type = 0;
			m_dataList.clear();
		}
		 
		int count;
		string name;
		int type;
		vector<Data *> m_dataList;
	};
public:
    int Refresh();
    int GetGameStatus(int &lastGameName, int &currGameName, string &drawTime);
    int GetMiss(int mis[5 * PWNum]);
    int GetHistory(int index, int result[5], int &gameName);
    int GetInfo(int &gameName, string &endTime, int &globalSurplus);
    int SetOrderInfo(int multiple, int followCount, bool winedStop);
    int AddTarget(int wan[PWNum], int qian[PWNum], int bai[PWNum], int shi[PWNum], int ge[PWNum]);
    int ModifyTarget(int index, int wan[PWNum], int qian[PWNum], int bai[PWNum], int shi[PWNum], int ge[PWNum]);
    int GetTarget(int index, int wan[PWNum], int qian[PWNum], int bai[PWNum], int shi[PWNum], int ge[PWNum], int &note);
    int DelTarget(int index);
    int GetTargetNum();
    int GetTotalNote();
    void ClearGameInfo();
    void ClearTarget();

    int NotesCalculate(int wan[PWNum], int qian[PWNum], int bai[PWNum], int shi[PWNum], int ge[PWNum]);
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

    DEPRECATED int GetTarget(int index, int wan[PWNum], int qian[PWNum], int bai[PWNum], int shi[PWNum], int ge[PWNum]);
    DEPRECATED int GetInfo(int result[5], string &name, int mis[5 * PWNum]);

public:
    CPick5();
    ~CPick5() {
        if (mSmartCell)
            delete mSmartCell;
    }

	/////////////////////////////////////////////方案详情
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int GetPSubTarget(int index, int subindex, int wan[PWNum], int qian[PWNum], int bai[PWNum], int shi[PWNum], int ge[PWNum]);
	int GetPTargetNum();
	int GetPTarget(int index, string &name, int &subNum, int &count, int &type);
	int PSave();
	int ProjectInfoClear();
protected:
	vector< PlayCell *> m_playList;
	vector<Data *> m_SaveList;//用于保存数据
	//////////////////////////////////////////////
protected:
    int _projectInfoClear();
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
	int _dealProjectInfo2(DCHttpRes &res);
    int _dealNotifyRefresh(DCHttpRes &data);
    int _dealNotifyGoPay(DCHttpRes &data);
    
protected:
    int mMissValue[5 * PWNum];
    CSmartDigitalLotteryCell *mSmartCell;
};

#endif