//
//  Jxsyxw.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __JXSYXW_H__
#define __JXSYXW_H__

#include <iostream>
#include <string>
#include <vector>
#include "ModuleBase.h"
#include "ModuleNotify.h"
#include "SmartHighLotteryCell.h"
#include "CommonMacro.h"
#include "ProjectInfo.h"
#include "NetLevel.h"

using namespace std;

typedef enum _SyxwType {
    SyxwTypeRenxuan2,
    SyxwTypeRenxuan3,
    SyxwTypeRenxuan4,
    SyxwTypeRenxuan5,
    SyxwTypeRenxuan6,
    SyxwTypeRenxuan7,
    SyxwTypeRenxuan8,
    SyxwTypeZhixuan1,
    SyxwTypeZhixuan2,
    SyxwTypeZhixuan3,
    SyxwTypeZuxuan2,
    SyxwTypeZuxuan3,
	SyxwTypeUnknow=50,//扩展类型，用于web支持，但app不支持的采种
} SyxwType;

#define SYXWNUMCOUNT 11
#define SyxwPos1 0
#define SyxwPos2 11
#define SyxwPos3 22

#define SYXWNUMCOUNTMAX 33

class CJxsyxw : public CModuleBase, public CNotify, public CProjectInfo, public WorkSleave {
	class Data{//用于拷贝数据 存储数据
	public:
		Data(){
			for (int i = 0; i < SYXWNUMCOUNT; i++){
				num2[i]=num3[i]=num1[i] = 0;
			}

		}
		int num1[SYXWNUMCOUNT];
		int num2[SYXWNUMCOUNT];
		int num3[SYXWNUMCOUNT];
		SyxwType Type;
	};
	class PlayCell{
	public:
		PlayCell(){ }
		int count;
		string name;
		int type;//原始类型
		vector<Data *> m_dataList;
	};
public:
    int Refresh();
    int GetGameStatus(int &gameName, string &drawTime);
    int AddTarget(int num1[SYXWNUMCOUNT], int num2[SYXWNUMCOUNT], int num3[SYXWNUMCOUNT], SyxwType subType);
    int ModifyTarget(int index, int num1[SYXWNUMCOUNT], int num2[SYXWNUMCOUNT], int num3[SYXWNUMCOUNT], SyxwType subType);
    int DelTarget(int index);
    void ClearTarget();
    void ClearGameInfo();
    int NotesCalculate(int num1[SYXWNUMCOUNT], int num2[SYXWNUMCOUNT], int num3[SYXWNUMCOUNT], SyxwType subType);
    int SetOrderInfo(int multiple, int followCount, bool winedStop);
    int SetCapacityInfo(int *followMultiple, int followCount, bool winedStop);
    int GetHistory(int index, int results[5], int &names);
    int GetInfo(int &gameName, string &endTime);
    int GetMiss(int mis[SYXWNUMCOUNTMAX], SyxwType subType);
    int GetTotalNote();
    int GetTargetNum();
    int GetTarget(int index, int num1[SYXWNUMCOUNT], int num2[SYXWNUMCOUNT], int num3[SYXWNUMCOUNT], SyxwType &subType, int &note);
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

    DEPRECATED int GetTarget(int index, int num1[SYXWNUMCOUNT], int num2[SYXWNUMCOUNT], int num3[SYXWNUMCOUNT], SyxwType &subType);
    DEPRECATED int GetInfo(int result[5], string &name);
    
    // 智能追号
    int CapacityBonusRange(int &minBonus, int &maxBonus);
    
public:
    CJxsyxw();
    ~CJxsyxw() {
        if (mSmartCell) delete mSmartCell;
    }
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
	virtual int PrepareSend(string &head, string &body);
	virtual int SendDone(DCHttpRes &res, int tag);
    
    int _projectInfoClear();
    int _dealNotifyRefresh(DCHttpRes &data);
    int _dealNotifyGoPay(DCHttpRes &data);
    int _insertTarget(int index, int num1[SYXWNUMCOUNT], int num2[SYXWNUMCOUNT], int num3[SYXWNUMCOUNT], SyxwType subType);
	int _dealProjectInfo2(DCHttpRes &res);
	/////////////////////////////////////////////方案详情（标准模式）
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int GetPTargetNum();
	/*
	*type 3开头为胆拖玩法（通过GetPSubTarget  获取，保存在扩展类型里），4开头为单式上传
	*/
	 int GetPTarget(int index, string &name,   int &count, int &subTargetNum, int & type);
	 /*
	 * subType app类型
	 */
	 int GetPSubTarget(int index, int subindex, int num[SYXWNUMCOUNT], int num2[SYXWNUMCOUNT], int num3[SYXWNUMCOUNT], SyxwType &subType);
	int ProjectInfoClear();
	int PSave();
protected:
	vector< PlayCell *> m_playList;//方案中所有玩法
	vector<Data *> m_SaveList;//用于保存数据
protected:
    CSmartHighLotteryCell *mSmartCell;

    int mMissDirect[SYXWNUMCOUNT * 3];
    int mMissGroup2[SYXWNUMCOUNT];
    int mMissGroup3[SYXWNUMCOUNT];
    int mMissRenxuan[SYXWNUMCOUNT];
    int mStep;
};

#endif