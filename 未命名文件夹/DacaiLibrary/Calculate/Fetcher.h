// Fetcher.h: interface for the Fetcher class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_FETCHER_H__96CE2147_DBE8_4CA7_8972_279BC8B83AAA__INCLUDED_)
#define AFX_FETCHER_H__96CE2147_DBE8_4CA7_8972_279BC8B83AAA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "List.h"

class Fetcher  
{
public:
	Fetcher(unsigned char* fieldsLenCountArray, int arrayLen, int numbers);
	virtual ~Fetcher();

	List<unsigned char*> Calculate();
private:
	unsigned char* fieldsLenCountArray;
	int numbers;
	int arrayLen;
};

#endif // !defined(AFX_FETCHER_H__96CE2147_DBE8_4CA7_8972_279BC8B83AAA__INCLUDED_)
