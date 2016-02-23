// MLMaxBonusCalculater.h: interface for the MLMaxBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MLMAXBONUSCALCULATER_H__F7932C61_4B05_4C40_A1AE_4F466A29E5AE__INCLUDED_)
#define AFX_MLMAXBONUSCALCULATER_H__F7932C61_4B05_4C40_A1AE_4F466A29E5AE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "MLOptions.h"
#include "MaxBonusCalculater.h"

class MLMaxBonusCalculater  
{
public:
	MLMaxBonusCalculater(MLOptions* mlInfo);
	virtual ~MLMaxBonusCalculater();
    double Calculate();

private:
   MLOptions* mlInfo;
};

#endif // !defined(AFX_MLMAXBONUSCALCULATER_H__F7932C61_4B05_4C40_A1AE_4F466A29E5AE__INCLUDED_)
