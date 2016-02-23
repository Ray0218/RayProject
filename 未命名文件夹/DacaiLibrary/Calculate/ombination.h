// ombination.h: interface for the Combination class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_OMBINATION_H__E72AEB61_225F_4CF7_AC16_084FA7A8E72C__INCLUDED_)
#define AFX_OMBINATION_H__E72AEB61_225F_4CF7_AC16_084FA7A8E72C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "Array.h"
#include "aculateType.h"

class Combination
{
public:
	Combination();
	virtual ~Combination();
    static  int GetInt32(int n,int m);
    static	Int64 GetInt64(int n,int m);

	static  int GetInt32(unsigned char n,unsigned char m);
    static	Int64 GetInt64(unsigned char n,unsigned char m);

	static Array<Array<unsigned char>*>* GetIndexes(unsigned char n,unsigned char m);
	static Array<Array<int>*>* GetIndexes(int n,int m);

	static Array<Array<unsigned char>*>* GetMultiCombineIndexes(int* countArray,int caLen);


};

#endif // !defined(AFX_OMBINATION_H__E72AEB61_225F_4CF7_AC16_084FA7A8E72C__INCLUDED_)
