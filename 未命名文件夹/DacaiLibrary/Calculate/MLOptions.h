// MLOptions.h: interface for the MLOptions class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MLOPTIONS_H__497DDE57_677E_4B79_BD42_39CE1E5818AD__INCLUDED_)
#define AFX_MLOPTIONS_H__497DDE57_677E_4B79_BD42_39CE1E5818AD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "Array.h"
#include "PassMode.h"
#include "Bet.h"
#include "List.h"
#include "Dictionary.h"
#include "BetCountor.h"
#include "Dictionary.h"

class MLOptions
{
public:

	MLOptions(Array<Array<int>*>* gameTypeOptionsLenArray,Array<int>* hadAllIndexArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<PassMode*>* passModes,Array<double>* maxSps,Array<double>* minSps);

	//MLOptions(Array<int>* gameTypeLenArray,Array<int>* hadAllIndexArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<PassMode*>* passModes,Array<double>* maxSps,Array<double>* minSps);

	virtual ~MLOptions();

	Array<Bet*>* GetBets();

    bool IsAllSinglePassModes();

	bool IsAllSingleTypeForField();

	bool IsInvalidData();

	Array<Array<int>*>* GetGameTypeOptionsLenArray();

	Array<int>* GetGameTypeOptionsLen();

	Array<int>* GetHadAllIndexArray();

	Array<int>* GetGallIndexArray();

	Array<int>* GetGallRangeArray();

	Array<PassMode*>* GetPassModes();

	Array<double>* GetMaxSps();

	Array<double>* GetMinSps();

	//拖索引数组
	Array<int>* GetDragIndexArray();

	//
	Array<int>* GetGallTotalLenArray();

	//
	Array<int>* GetDragTotalLenArray();

	//多过关方式集合体
	List<PassMode*>* GetComplexPassModeList();

	//单过关方式集合体
	List<PassMode*>* GetSinglePassModeList();

	Int64 GetHadAllIndexCode();


private:


    Array<Array<int>*>* gameTypeOptionsLenArray;

	Array<int>* gameTypeOptionsLen;

	Array<int>* hadAllIndexArray;

	Int64 hadAllIndexCode;

	Array<int>* gallIndexArray;

	Array<int>* gallRangeArray;

	Array<PassMode*>* passModes;

	Array<double>* maxSps;

	Array<double>* minSps;

	//是否是所有过关方式为单一过关方式
	bool isAllSinglePassModes;

	//是否每场都是单一过关方式
	bool isSingleTypeForField;

	//拖索引数组
	Array<int>* dragIndexArray;

	//
	Array<int>* gallTotalLenArray;

	//
	Array<int>* dragTotalLenArray;

	//多过关方式集合体
	List<PassMode*> complexPassModeList;

	//单过关方式集合体
	List<PassMode*> singlePassModeList;

	//是否无效数据
	bool isInvalidData;

	Array<Bet*>* bets;

	void Init();

	int GetMinBets();

	void FillSamePassMode(Dictionary<int, List<PassMode*>*>* dic);

	void GetBetsForSubPass(Dictionary<int,Bet*>* dic,int* indexArray,int iaLen,Array<PassMode*>* passModes);

	void GetBetsByGall(Dictionary<int,Bet*>* dic,Dictionary<int, List<PassMode*>*>* samePassModeDic,int gallCount,int pass, int* ncIndexArray);
};



#endif // !defined(AFX_MLOPTIONS_H__497DDE57_677E_4B79_BD42_39CE1E5818AD__INCLUDED_)
