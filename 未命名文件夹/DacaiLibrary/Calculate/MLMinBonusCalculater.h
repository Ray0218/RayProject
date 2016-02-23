// MLMinBonusCalculater.h: interface for the MLMinBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MLMINBONUSCALCULATER_H__4844070D_D6E1_4A81_9726_4D17D3FF21DB__INCLUDED_)
#define AFX_MLMINBONUSCALCULATER_H__4844070D_D6E1_4A81_9726_4D17D3FF21DB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "MLOptions.h"
#include "MaxBonusCalculater.h"
#include "MinBonusCalculater.h"

//最大最小值
const int MLMinBonusCalculaterMaxMin=100000000;

class MLMinBonusCalculater
{
public:
	MLMinBonusCalculater(MLOptions* mlInfo);
	virtual ~MLMinBonusCalculater();
	double Calculate();
private:
	MLOptions* mlInfo;
    double CalculateHadAll(Int64 hadAllIndexCode);
};

#endif // !defined(AFX_MLMINBONUSCALCULATER_H__4844070D_D6E1_4A81_9726_4D17D3FF21DB__INCLUDED_)
