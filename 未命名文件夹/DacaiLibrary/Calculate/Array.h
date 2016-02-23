// Array.h: interface for the Array class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ARRAY_H__1591CF1C_1652_4579_8E7D_A1321A4DE031__INCLUDED_)
#define AFX_ARRAY_H__1591CF1C_1652_4579_8E7D_A1321A4DE031__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <typeinfo>



template <typename T>
class Array
{
public:
	Array();

	//适用范围值和指针 不支持结构和类对象
	Array(const int& value);

	Array(const Array<T> &source);
	Array(const T* array,int arrayLen);
	virtual ~Array();
	int GetLength();

	int IndexOf(T item);

	//适用范围值类型 不支持结构和类对象、指针
	T Sum();
	T* operator [](int index);

	T* GetArray();

	void Set(T* array,int arrayLen);
private:
	T* array;
	int arrayLen;
};

template <typename T>
Array<T>::Array(const T* array,int arrayLen)
{
	if(array==0)
	{
		this->array=0;
		this->arrayLen=0;
	}else
	{
    this->array=new T[arrayLen];
	for(int i=0;i<arrayLen;i++)
	{
	    this->array[i]=array[i];
	}
	this->arrayLen=arrayLen;
	}
}

template <typename T>
Array<T>::Array()
{
    this->array=0;
	this->arrayLen=0;
}
template <typename T>
	Array<T>::Array(const int& value)
	{
	   if(value<1)
	   {
	     this->array=0;
	     this->arrayLen=0;
	   }else
	   {
	      this->array=new T[value];
          this->arrayLen=value;
		  for(int i=0;i<arrayLen;i++)
		  {
		      array[i]=0;
		  }
	   }
	}

template <typename T>
Array<T>::Array(const Array<T> &source)
{
	if(source.array!=0)
	{
		this->arrayLen=source.arrayLen;
	   this->array=new T[arrayLen];
	   for(int i=0;i<arrayLen;i++)
	   {
	      array[i]=source.array[i];
	   }
	}
	else
	{
	   this->array=0;
	   this->arrayLen=0;
	}
}

template <typename T>
Array<T>::~Array()
{
   if(this->array!=0)
   {
      delete[] this->array;
   }
}

template <typename T>
int Array<T>::GetLength()
{
   return arrayLen;
}

template <typename T>
T* Array<T>::operator [](int index)
{
   if(index>=arrayLen)
   {
       return 0;
   }
   return &array[index];
}

template <typename T>
void Array<T>::Set(T* array,int arrayLen)
{
   if(array==0)
   {
      this->array=0;
	  this->arrayLen=0;
   }else
   {
      this->array=array;
	  this->arrayLen=arrayLen;
   }
}
template <typename T>
int  Array<T>::IndexOf(T item)
{
   if(array==0)
   {
      return -1;
   }
   for(int i=0;i<arrayLen;i++)
   {
      if(array[i]==item)
	  {
	     return i;
	  }
   }
   return -1;
}

template <typename T>
T Array<T>::Sum()
{

      T sum=0;
	  for(int i=0;i<arrayLen;i++)
	  {
	     sum=sum+array[i];
	  }
	  return sum;
}

template <typename T>
T* Array<T>::GetArray()
{
   return array;
}
#endif // !defined(AFX_ARRAY_H__1591CF1C_1652_4579_8E7D_A1321A4DE031__INCLUDED_)
