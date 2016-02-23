// PassMode.h: interface for the PassMode class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PASSMODE_H__3864ACAC_71E7_4A33_87E4_EBDB9818DA04__INCLUDED_)
#define AFX_PASSMODE_H__3864ACAC_71E7_4A33_87E4_EBDB9818DA04__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "ombination.h"
#include "Array.h"

const int PassModeMaxPass=15;
const int PassModeMaxSubPass=8;


class PassMode
{
public:
	PassMode();
	PassMode(int pass, int mode);
	//PassMode(const PassMode& passMode);
	virtual ~PassMode();

    int GetSubPassModes(PassMode* subPassModes,int pmLen);
	int GetSubPassModesCout();
	PassMode* GetMinPassMode();
	PassMode GetSubPassMode(int* subPasses,int len);
	Array<Array<unsigned char>*>* GetIndexes();
	int GetPass();
	int GetMode();
private:

	int pass;
	int mode;
	char subPasses[PassModeMaxPass];
	PassMode* parent;
	PassMode* minPM;
	Array<Array<unsigned char>*>* indexes;
    int subPassesCount;

	void init();
	static int GetActPass(int pass,int mode,char* actPass,const int alen);

};

#endif // !defined(AFX_PASSMODE_H__3864ACAC_71E7_4A33_87E4_EBDB9818DA04__INCLUDED_)
