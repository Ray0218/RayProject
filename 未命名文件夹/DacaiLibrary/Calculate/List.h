// List.h: interface for the List class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_LIST_H__A0ACE6AC_5FCB_4291_998D_B8E329A6AA9B__INCLUDED_)
#define AFX_LIST_H__A0ACE6AC_5FCB_4291_998D_B8E329A6AA9B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include <typeinfo>
#include "Array.h"

const int ListMinLen=100;
const int ListExtendLen=50;

template <typename T>
class List
{
public:
	List();
	List(const List<T>& list);
	virtual ~List();
	int Count();
	void Add(T item);
	bool RemoveAt(int index);
	void Clear();
    T* operator [](int index);
	int ToArray(T* array,int arrayLen);

	Array<T>* ToArray();

private:
    T* array;
    int len;
	int index;
	void init();
	void extend();

};



template <typename T>
List<T>::List()
{
    init();
}



template <typename T>
List<T>::~List()
{
   if(array!=0)
   {
      delete[] array;
   }
}
template <typename T>
List<T>::List(const List<T>& list)
{
    this->len=list.len;
	this->index=list.index;
    array=new T[len];
	for(int i=0;i<len;i++)
	{
	    array[i]=list.array[i];
	}
}

template <typename T>
void List<T>:: init()
{
	len=0;
	index=0;

    array=new T[ListMinLen];
	for(int i=0;i<ListMinLen;i++)
	{
	   array[i]=0;
	}
	len=ListMinLen;
}

template <typename T>
void List<T>::extend()
{
    T* tempArray=new T[len+ListExtendLen];
	for(int i=0;i<index;i++)
	{
	    tempArray[i]=array[i];
	}
	delete[] array;
	array=tempArray;
	len=len+ListExtendLen;
}
template <typename T>
	int List<T>::Count()
{
    return index;
}

template <typename T>
	void List<T>::Add(T item)
{
    if(index>len)
	{
	   extend();
	}

	if(index<=len)
	{
	    array[index]=item;
		index++;
	}
}

template <typename T>
	bool List<T>::RemoveAt(int index)
{
    if(index<0||index>=this->index)
	{
	    return false;
	}

	if(index>0)
	{
	    int last=this->index-1;

		for(int i=index;i<last;i++)
		{
		    array[i]=array[i+1];
		}

		array[last]=0;
		this->index--;
	}
}

template <typename T>
	void List<T>::Clear()
{
    for(int i=0;i<index;i++)
	{
	   array[i]=0;
	}
	index=0;
}


template <typename T>
T* List<T>::operator [](int index)
{
	if(index<0||index>=this->index)
	{
	    return 0;
	}
	return &array[index];
}

template <typename T>
int List<T>::ToArray(T* array,int arrayLen)
{
    int copyLen=arrayLen;
	if(index<arrayLen)
	{
	   copyLen=index;
	}
	for(int i=0;i<copyLen;i++)
	{
	   array[i]=this->array[i];
	}
	return copyLen;
}

template <typename T>
Array<T>* List<T>::ToArray()
{
    if(index<1)
	{
	   return 0;
	}
	Array<T>* reArray=new Array<T>();
	T* re=new T[index];
	for(int i=0;i<index;i++)
	{
	    re[i]=array[i];
	}
	reArray->Set(re,index);
	return reArray;
}

#endif // !defined(AFX_LIST_H__A0ACE6AC_5FCB_4291_998D_B8E329A6AA9B__INCLUDED_)
