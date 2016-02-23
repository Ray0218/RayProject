// MinBonusCalculater.h: interface for the MinBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MINBONUSCALCULATER_H__9BD0628D_9EDA_4DD1_8F66_C564091D820D__INCLUDED_)
#define AFX_MINBONUSCALCULATER_H__9BD0628D_9EDA_4DD1_8F66_C564091D820D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "Array.h"
#include "PassMode.h"
#include "MLOptions.h"

class MinBonusCalculater
{
public:
	MinBonusCalculater(Array<PassMode*>* passModes,Array<double>* spArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<int>* hadAllIndexArray);
	virtual ~MinBonusCalculater();
    double Calculate();
private:
	Array<PassMode*>* passModes;
	Array<double>* spArray;
	Array<int>* gallIndexArray;
	Array<int>* dragIndexArray;
	Array<int>* gallRangeArray;
	Array<int>* hadAllIndexArray;
	void Init();
};

#endif // !defined(AFX_MINBONUSCALCULATER_H__9BD0628D_9EDA_4DD1_8F66_C564091D820D__INCLUDED_)
