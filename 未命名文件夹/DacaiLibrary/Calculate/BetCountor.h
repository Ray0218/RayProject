// BetCountor.h: interface for the BetCountor class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_BETCOUNTOR_H__C9C70278_42E2_4345_9533_BCFF8C020536__INCLUDED_)
#define AFX_BETCOUNTOR_H__C9C70278_42E2_4345_9533_BCFF8C020536__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "PassMode.h"
#include "Dictionary.h"
#include "List.h"
#include "Fetcher.h"

class BetCountor  
{
public:
    BetCountor(PassMode* mode,Array<int>*  gallOptionLenArray, Array<int>*  dragOptionLenArray, Array<int>*  gallRangeArray);
	virtual ~BetCountor();
    Int64 Calculate();
	static Int64 Calculate(Array<PassMode*>* passModes, Array<int>*  gallOptionLenArray, Array<int>*  dragOptionLenArray,Array<int>*  gallRangeArray);
private:
 Array<int>* gallOptionLenArray;

 Array<int>* dragOptionLenArray;

 Array<int>* gallRangeArray;

 PassMode* mode;
int GetSameCount(Array<int>* optionLenArray,int* &sameLenArray,unsigned char* &sameCountArray);
};

#endif // !defined(AFX_BETCOUNTOR_H__C9C70278_42E2_4345_9533_BCFF8C020536__INCLUDED_)
