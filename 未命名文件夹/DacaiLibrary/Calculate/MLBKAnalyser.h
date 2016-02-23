// MLBKAnalyser.h: interface for the MLBKAnalyser class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MLBKANALYSER_H__80D85E8A_82CF_4CE1_B700_3121A074A2B7__INCLUDED_)
#define AFX_MLBKANALYSER_H__80D85E8A_82CF_4CE1_B700_3121A074A2B7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "Array.h"
#include "List.h"
#include "MLAnalyser.h"

// 131, 133, 134, 132
class MLBKAnalyser:public MLAnalyser
{
public:
	MLBKAnalyser(Array<Array<int>*>* optionsIndexArray,Array<Array<double>*>* optionsSpArray,double coefficient);

	virtual ~MLBKAnalyser();

	bool IsHadAllOption();

	int GetGameTypeLen();

	Array<int>* GetGameTypeOptionLenArray();

	double GetMaxComSp();

	double GetMinComSp();

private:

	Array<Array<int>*>* codeArray;

	Array<int>* fcArray;

	Array<char>* fullOptionLenArray;

	double coefficient;

	int codeLen;

	Array<int>* gameTypeOptionLenArray;

	Array<Array<int>*>* optionsIndexArray;

    Array<Array<double>*>* optionsSpArray;

	void init();

	Array<int>* setRFSFIndexArray();

	Array<Array<double>*>* initMaxMinData(bool isMax);
};
#endif // !defined(AFX_MLBKANALYSER_H__80D85E8A_82CF_4CE1_B700_3121A074A2B7__INCLUDED_)
