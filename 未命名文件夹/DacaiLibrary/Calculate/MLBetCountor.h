// MLBetCountor.h: interface for the MLBetCountor class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MLBETCOUNTOR_H__8DBA9E30_FF09_45F6_AB48_9B152F8806CE__INCLUDED_)
#define AFX_MLBETCOUNTOR_H__8DBA9E30_FF09_45F6_AB48_9B152F8806CE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "Array.h"
#include "PassMode.h"
#include "List.h"
#include "BetCountor.h"
#include "MLOptions.h"

//不计算注数
const int MLBetCountorNoCalculateNumber=100000000;

class MLBetCountor
{
public:

	//
	MLBetCountor(MLOptions* mlInfos);

	//
	MLBetCountor(Array<PassMode*>* passModes,Array<Array<int>*>* fieldLenArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray);

	//
	virtual ~MLBetCountor();

	//
    Int64 Calculate();

private:


	MLOptions* mlInfos;

	bool isSelfCreateInfos;
	//
	Int64 CalculateComplex();

	//
	int CalculateSubPass(int* indexArray,int indexLen, Array<PassMode*>* passModeList);

	void FillSamePassMode(List<PassMode*>* passModeList,Dictionary<int, List<PassMode*>*>* dic);

	//
	//void Init();
    /*
	//过关方式
    Array<PassMode*>* passModes;

	//每场选择长度信息
	//记录每场各彩种为有指定长度,每场int[]
	Array<Array<int>*>* fieldLenArray;

	Array<int>* gallTotalLenArray;

	Array<int>* dragTotalLenArray;

	//胆索引数组
	Array<int>* gallIndexArray;

	//拖索引数组
	Array<int>* drageIndexArray;

	//定胆范围
	Array<int>* gallRangeArray;

	//是否是所有过关方式为单一过关方式
	bool isAllSinglePassModes;

	//是否每场都是单一过关方式
	bool isSingleTypeForField;

	//多过关方式集合体
	List<PassMode*> complexPassModeList;

	//单过关方式集合体
	List<PassMode*> singlePassModeList;

	//是否无效数据
	bool isInvalidData;*/
};

#endif // !defined(AFX_MLBETCOUNTOR_H__8DBA9E30_FF09_45F6_AB48_9B152F8806CE__INCLUDED_)
