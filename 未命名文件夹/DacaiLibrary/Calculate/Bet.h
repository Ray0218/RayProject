// Bet.h: interface for the Bet class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_BET_H__232E669B_5852_4267_BC1A_B0CC9880EB02__INCLUDED_)
#define AFX_BET_H__232E669B_5852_4267_BC1A_B0CC9880EB02__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "PassMode.h"
#include "aculateType.h"


class Bet
{
public:

	Bet();

	virtual ~Bet();

	//索引数据
	unsigned char* IndexArray;

	//数组长度
	int Length;

	//过关方式
	PassMode* passMode;

	//重复次数
	int Repeat;

	Int64 GetCode();

};

#endif // !defined(AFX_BET_H__232E669B_5852_4267_BC1A_B0CC9880EB02__INCLUDED_)
