//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  双色球模块
//

#ifndef DOUBLECHROMOSPHERE
#define DOUBLECHROMOSPHERE
#include <string>
#include <vector>
#include "ModuleNotify.h"
#include "ModuleBase.h"
#include "SmartDigitalLotteryCell.h"
#include "CommonMacro.h"
#include "ProjectInfo.h"
#define SSQREDNUM 33
#define SSQBLUENUM 16
#define SSQBluePos 33
#define SSQRedPos 0
using namespace std;

class CDoubleChromosphere : public CModuleBase,   public CProjectInfo, public CNotify{
	class Data{//用于拷贝数据 存储数据
	public:
		Data(){
			int i;
			 
			for (i = 0; i < SSQREDNUM; i++)
				red[i] = 0;
			for (i = 0; i < SSQBLUENUM; i++)
				blue[i] = 0;

		}
		int red[SSQREDNUM];
		int blue[SSQBLUENUM];
		 
	};
	class PlayCell{
	public:
		PlayCell(){
			type = 0;
		}
	
		int count;
		int bileTab;
		string name;
		int type;
		vector<Data *> m_dataList;
	};
  public:
    int Refresh();
    /**
     *  获取当前期号
     *
     *  @param lastGameName [out]上期期号, 仅在返回值为2时被赋值
     *  @param currGameName [out]当前期号, 仅在返回值为2时被赋值
     *  @param endTime      [out]当前期开奖时间
     *
     *  @return <0表示失败, >=0表示成功, 0:正常, 1:无期号, 2:跨期
     */
    int GetGameStatus(int &lastGameName, int &currGameName, string &drawTime);
    /**
     *  获取遗漏值
     *
     *  @param mis [out]遗漏值
     *
     *  @return >=0表示成功, <0表示失败
     */
    int GetMiss(int mis[SSQBLUENUM + SSQREDNUM]);
    /**
     *  获取历史开奖号码
     *
     *  @param index    [in]索引
     *  @param gameName [out]期号
     *  @param result   [out]开奖号码
     *
     *  @return <0表示失败, >=0表示成功, 1表示正在开奖
     */
    int GetHistory(int index, int &gameName, int result[7]);
    /**
     *  获取本期期号, 截止时间, 奖池
     *
     *  @param gameName      [out]本期期号
     *  @param endTime       [out]截止时间
     *  @param globalSurplus [out]奖池
     *
     *  @return >=0表示成功, <0表示失败
     */
    int GetInfo(int &gameName, string &endTime, int &globalSurplus);
    /**
     *  设置订单信息
     *
     *  @param multiple    [in]倍数
     *  @param followCount [in]追号期数
     *  @param winedStop   [in]中奖后停止
     *
     *  @return >=0表示成功, <0表示失败
     */
    int SetOrderInfo(int multiple, int followCount, bool winedStop);
    /**
     *  计算注数
     *
     *  @param blue  [in]蓝球的选中情况
     *  @param red   [in]红球的选中情况
     *  @param bile  [in]是否是胆拖玩法, 0表示普通, 其他表示胆拖
     *
     *  @return <0表示失败, >=0表示成功
     */
    int NotesCalculate(int blue[SSQBLUENUM], int red[SSQREDNUM], int bile = 0);
    /**
     *  添加一注投注内容
     *
     *  @param blue  [in]蓝球的选中情况
     *  @param red   [in]红球的选中情况
     *
     *  @return <0表示失败, >=0表示成功
     */
    int AddTarget(int blue[SSQBLUENUM], int red[SSQREDNUM]);
    /**
     *  修改投注内容
     *
     *  @param index [in]中转界面的索引
     *  @param blue  [in]蓝球的选中情况
     *  @param red   [in]红球的选中情况
     *
     *  @return <0表示失败, >=0表示成功
     */
    int ModifyTarget(int index, int blue[SSQBLUENUM], int red[SSQREDNUM]);
    /**
     *  删除一注投注内容
     *
     *  @param index [in]中转界面的索引
     *
     *  @return <0表示失败, >=0表示成功
     */
    int DelTarget(int index);
    /**
     *  获取投注内容数(实体个数)
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTargetNum();
    /**
     *  获取投注内容
     *
     *  @param index [in]中转界面的索引
     *  @param blue  [in]蓝球的选中情况
     *  @param red   [in]红球的选中情况
     *  @param note  [out]注数
     *  @param mark  [out]是否是胆拖玩法
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTarget(int index, int blue[SSQBLUENUM], int red[SSQREDNUM], int &note, int &mark);
    /**
     *  合买设置
     *
     *  @param accessType [in]公开类型, 1:公开, 2:保密, 3:截止后公开, 4:跟单者公开
     *  @param commission [in]佣金, 0~10
     *  @param buyAmt     [in]认购金额, >=1
     *  @param fillAmt    [in]保底金额, >=0
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetTogetherInfo(int accessType, int commission, int buyAmt, int fillAmt);
    /**
     *  设置是否合买
     *
     *  @param isTogetherBuy [in]是否是合买方案
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetTogetherType(bool isTogetherBuy);
    /**
     *  获取总注数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetTotalNote();
    /**
     *  清空所有内容
     */
    void ClearTarget();
    /**
     *  清空期号信息
     */
    void ClearGameInfo();

    int GoPay(int identifier = 0);
    
    /**
     *  只提供给iOS
     *
     *  @param url [out]url地址
     *
     *  @return <0表示失败, >=0表示成功
     */
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
    

    
    /**
     *  只提供给Andriod
     *
     *  @param type [in]生成的订单类型, 2:Android 未支付 3: Android 下单成功
     *  @param pid  [in]订单号
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetPayInfo(int &type, int &pid, string &drawTime, string &tagline,string &Event);
    int GetNonPayment(int &needAmt, string &realAmt);

    DEPRECATED int GetHistory(int results[70], int names[10]);
    DEPRECATED int GetTarget(int index, int blue[SSQBLUENUM], int red[SSQREDNUM]);
    DEPRECATED int getInfo(int result[7], string &name, int mis[49]);

    /////////////////////////////////////////////方案详情
	public:
	virtual	int RefreshProjectInfo(int projectid, int gameTypeId, int orderId = 0) ;
	int _dealProjectInfo2(DCHttpRes &res);
	int GetPTargetNum();
	int GetPTarget(int index, string &name,  int &SubNum, int &count, int &type);
	//int GetPTarget(int index,string &name, int blue[SSQBLUENUM], int red[SSQREDNUM], int &note, int &mark,int &type);
	int PSave();
	int GetPSubTarget(int index, int subindex, int blue[SSQBLUENUM], int red[SSQREDNUM]);
	int ProjectInfoClear();

	protected:
		vector< PlayCell *> m_playList;
		vector<Data *> m_SaveList;//用于保存数据
	//////////////////////////////////////////////
  public:
    CDoubleChromosphere();
    ~CDoubleChromosphere() {
        if (mSmartCell)
            delete mSmartCell;
    }
    
protected:
    virtual int Notify(int comId, int result, DCHttpRes &data, void *pd, int specailData, int tag);
    
    int _projectInfoClear();
    int _dealNotifyRefresh(DCHttpRes &data);
    int _dealNotifyGoPay(DCHttpRes &data);
    
  protected:
    int mMissValue[SSQBLUENUM + SSQREDNUM];
    CSmartDigitalLotteryCell *mSmartCell;
};

#endif