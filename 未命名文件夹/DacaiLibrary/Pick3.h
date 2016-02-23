//
//  Pick3.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __PICK3_H__
#define __PICK3_H__

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

#define PSPos1 0
#define PSPos2 10
#define PSPos3 20

#define PSNum 10

typedef enum _PSType {
    PSTypeDirect,
    PSTypeGroup3,
    PSTypeGroup6,
} PSType;

class CPick3 : public CModuleBase, public CNotify, public CProjectInfo {
	class Data{//用于详细数据
	public:
		Data(){ type = 0; a = b = c = 0; }
		int type;
		int a, b, c;
	};
	class SaveData{//用于拷贝数据
	public:
		SaveData(){
			for (int i = 0; i < PSNum; i++)
			{
				num1[i] = num2[i] = num3[i] = 0;

			}
			type = PSTypeDirect;
		}
		int num1[PSNum];
		int num2[PSNum];
		int num3[PSNum];
		PSType type;
	};
	class ProjectBet_t{
	public:
		ProjectBet_t(){}

		int count;

		vector<Data *> m_dataInfo;
		string name;
		int type;
	};

public:
    int Refresh();
    int GetGameStatus(int &lastGameName, int &currGameName, string &drawTime);
    int GetMiss(int misDirect[3 * PSNum], int misGroup[PSNum]);
    int GetHistory(int index, int result[3], int &gameName);
    int GetInfo(int &gameName, string &endTime, int &globalSurplus);
    int SetOrderInfo(int multiple, int followCount, bool winedStop);
    int AddTarget(int num1[PSNum], int num2[PSNum], int num3[PSNum], PSType subType);
    int ModifyTarget(int index, int num1[PSNum], int num2[PSNum], int num3[PSNum], PSType subType);
    int DelTarget(int index);
    int GetTargetNum();
    int GetTarget(int index, int &subType, int &note, int num1[PSNum], int num2[PSNum], int num3[PSNum]);
    void ClearTarget();
    void ClearGameInfo();
    int GetTotalNote();
    int NotesCalculate(int num1[PSNum], int num2[PSNum], int num3[PSNum], int subType); // subType 0：直选 1：组三 2：组六
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
    
    DEPRECATED int GetMiss(int misDirect[3 * PSNum], int misGroup3[PSNum], int misGroup6[PSNum]);
    DEPRECATED int AddTargetByDirect(int num1[PSNum], int num2[PSNum], int num3[PSNum]);
    DEPRECATED int AddTargetByGroup3(int num[PSNum]);
    DEPRECATED int AddTargetByGroup6(int num[PSNum]);
    DEPRECATED int GetTarget(int index, int &subType, int num1[PSNum], int num2[PSNum], int num3[PSNum]);
    DEPRECATED int GetInfo(int result[3], string &name, int misDirect[3 * PSNum], int misGroup3[PSNum], int misGroup6[PSNum]);
    
public:
    CPick3();
    ~CPick3() {if(mSmartCell) delete mSmartCell;}
	/////////////////////////////////////////////方案详情
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int ProjectInfoClear();//清除所有数据
	int GetPTargetNum();
	int GetPTarget(int index, string &name, int &subTargetNum, int & type);
	int GetPSubTarget(int index, int subindex, int &a, int &b, int &c);
	int PSave();
    
protected:
	vector< ProjectBet_t *> m_projectBet;//方案中所有玩法
	vector<SaveData *> m_dataForSave;//用于保存数据

protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd,int specialData, int tag);
    
    int _projectInfoClear();
    int _dealNotifyRefresh(DCHttpRes &data);
    int _dealNotifyGoPay(DCHttpRes & data);
	int _dealProjectInfo2(DCHttpRes &res);
protected:
    int mMissDirect[PSNum * 3];
    int mMissGroup[PSNum];
    CSmartDigitalLotteryCell *mSmartCell;
};

#endif /* __PICK3_H__ */