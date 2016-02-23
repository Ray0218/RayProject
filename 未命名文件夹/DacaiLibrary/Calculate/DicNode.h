// DicNode.h: interface for the DicNode class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DICNODE_H__60BE9F20_94ED_4107_B823_034025C6E2DE__INCLUDED_)
#define AFX_DICNODE_H__60BE9F20_94ED_4107_B823_034025C6E2DE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

template <class T>
class DicNode
{
public:
	DicNode();
	virtual ~DicNode();

  T Value;
  bool HadData;
  DicNode<T>* Parent;
  DicNode<T>* Child;
  DicNode<T>* Prefix;
  DicNode<T>* Suffix;
  char Key;
};

template <class T>
DicNode<T>::DicNode()
{
   Parent=0;
   Suffix=0;
   Prefix=0;
   Child=0;
   HadData=false;
   Key=0;
}

template <class T>	
DicNode<T>::~DicNode()
{
}

#endif // !defined(AFX_DICNODE_H__60BE9F20_94ED_4107_B823_034025C6E2DE__INCLUDED_)
