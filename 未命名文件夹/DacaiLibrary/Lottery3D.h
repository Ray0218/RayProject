//
//  SuperLotto.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __LOTTERY3D_H__
#define __LOTTERY3D_H__

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

#define SDPos1 0
#define SDPos2 10
#define SDPos3 20

#define SDNum 10

typedef enum _SDType {
    SDTypeDirect,
    SDTypeGroup3,
    SDTypeGroup6,
} SDType;

class CLottery3D : public CModuleBase, public CNotify, public CProjectInfo{
	class Data{//用于详细数据
	public:
		Data(){ type = 0; a = b = c = 0; }
		int type;
		int a, b, c;
	};
	class SaveData{//用于拷贝数据
	public:
		SaveData(){ 
			for (int i = 0; i < SDNum; i++)
			{
				num1[i] = num2[i] = num3[i] = 0;

			}
			type = SDTypeDirect;
		}
		int num1[SDNum];
		int num2[SDNum];
		int num3[SDNum];
		SDType type;
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
    int GetMiss(int misDirect[3 * SDNum], int misGroup[SDNum]);
    /**
     *  获取历史走势
     *
     *  @param index   [in]从0开始, 0表示上一期, 1表示上上期, 以此类推.
     *  @param results [out]开奖号码
     *  @param test    [out]试机号
     *  @param names   [out]期号名
     *
     *  @return >=0表示成功, <0表示失败
     */
    int GetHistory(int index, int result[3], int test[3], int &gameName);
    int GetInfo(int &gameName, string &endTime, int &globalSurplus);
    int SetOrderInfo(int multiple, int followCount, bool winedStop);
    int NotesCalculate(int num1[SDNum], int num2[SDNum], int num3[SDNum], int subType); // subType 0：直选 1：组三 2：组六
    int AddTarget(int num1[SDNum], int num2[SDNum], int num3[SDNum], SDType subType);
    int ModifyTarget(int index, int num1[SDNum], int num2[SDNum], int num3[SDNum], SDType subType);
    int DelTarget(int index);
    int GetTargetNum();
    int GetTarget(int index, int &subType, int &note, int num1[SDNum], int num2[SDNum], int num3[SDNum]);
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

    DEPRECATED int GetInfo(int result[3], string &name, int misDirect[3 * SDNum], int misGroup3[SDNum], int misGroup6[SDNum]);
    DEPRECATED int GetTarget(int index, int &subType, int num1[SDNum], int num2[SDNum], int num3[SDNum]);
    DEPRECATED int AddTargetByDirect(int num1[SDNum], int num2[SDNum], int num3[SDNum]);
    DEPRECATED int AddTargetByGroup3(int num[SDNum]);
    DEPRECATED int AddTargetByGroup6(int num[SDNum]);
    DEPRECATED int GetMiss(int misDirect[3 * SDNum], int misGroup3[SDNum], int misGroup6[SDNum]);

public:
    CLottery3D();
    ~CLottery3D() {
        if (mSmartCell)
            delete mSmartCell;
    }

    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specialData, int tag);
	/////////////////////////////////////////////方案详情
public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0);
	int ProjectInfoClear();//清除所有数据
	int GetPTargetNum();
	int GetPTarget(int index, string &name, int &subTargetNum,int & type);
	int GetPSubTarget(int index, int subindex, int &a, int &b, int &c);
	int PSave();
protected:
	vector< ProjectBet_t *> m_projectBet;//方案中所有玩法
	vector<SaveData *> m_dataForSave;//用于保存数据
	
	//////////////////////////////////////////////
protected:
    int _projectInfoClear();
    int _dealNotifyRefresh(DCHttpRes &data);
    int _dealNotifyGoPay(DCHttpRes &data);
	int _dealProjectInfo2(DCHttpRes &res);
    int mMissDirect[SDNum * 3];
    int mMissGroup[SDNum];
    CSmartDigitalLotteryCell *mSmartCell;
};

#endif /* __LOTTERY3D_H__ */