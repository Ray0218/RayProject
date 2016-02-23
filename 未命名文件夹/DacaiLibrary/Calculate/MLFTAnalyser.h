// MLFTAnalyser.h: interface for the MLFTAnalyser class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MLFTANALYSER_H__DC359640_7F69_469D_8AD8_C171C0244B6D__INCLUDED_)
#define AFX_MLFTANALYSER_H__DC359640_7F69_469D_8AD8_C171C0244B6D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "Array.h"
#include "List.h"
#include "MLAnalyser.h"





//
//128,122,123,124,121
class MLFTAnalyser:public MLAnalyser
{
public:
	MLFTAnalyser(Array<Array<int>*>* optionsIndexArray,Array<Array<double>*>* optionsSpArray,double coefficient);

	virtual ~MLFTAnalyser();

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

	Array<int>* setRQSPFIndexArray();

	Array<Array<double>*>* initMaxMinData(bool isMax);

};

#endif // !defined(AFX_MLFTANALYSER_H__DC359640_7F69_469D_8AD8_C171C0244B6D__INCLUDED_)
