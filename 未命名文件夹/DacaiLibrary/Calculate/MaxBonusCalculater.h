// MaxBonusCalculater.h: interface for the MaxBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MAXBONUSCALCULATER_H__3AEF9176_A152_4FF1_80FC_E5576538B4B0__INCLUDED_)
#define AFX_MAXBONUSCALCULATER_H__3AEF9176_A152_4FF1_80FC_E5576538B4B0__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "Array.h"
#include "PassMode.h"

class MaxBonusCalculater  
{
public:
	MaxBonusCalculater(Array<PassMode*>* passModes,Array<double>* spArray,Array<int>* gallIndexArray,Array<int>* dragIndexArray,Array<int>* gallRangeArray);
	virtual ~MaxBonusCalculater();
	double Calculate();
private:
	double CalculateByGall(PassMode* passMode,int gallCount,int* giaArray,int giaLen,int* diaArray,int diaLen);
	Array<PassMode*>* passModes;
	Array<double>* spArray;
	Array<int>* gallIndexArray;
	Array<int>* dragIndexArray;
	Array<int>* gallRangeArray;
};

#endif // !defined(AFX_MAXBONUSCALCULATER_H__3AEF9176_A152_4FF1_80FC_E5576538B4B0__INCLUDED_)
