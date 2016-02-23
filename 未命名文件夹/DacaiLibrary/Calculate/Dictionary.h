// Dictionary.h: interface for the Dictionary class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DICTIONARY_H__58074A23_241D_4DFA_A8E6_DC4210F20CF5__INCLUDED_)
#define AFX_DICTIONARY_H__58074A23_241D_4DFA_A8E6_DC4210F20CF5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "DicNode.h"
#include <typeinfo>
#include <String.h>


template <class K,class T>
class Dictionary
{
public:
	Dictionary();
	~Dictionary();
	bool Add(K key,T value);
	bool ContainsKey(K key);
	bool Remove(K key);
	int GetDataLen();
	int GetKeys(K* keys,int kLen);
	int GetValues(T* datas,int dLen);
    T* operator [](K key);
private:
	int dataLen;
    int nc;
	DicNode<T>* root;

	void getKeysByStep(DicNode<T>* child,char* prefixStr,int pLen,K* keys,int kLen,int &index);
	void getValuesByStep(DicNode<T>* child,T* values,int vLen,int &index);
	void destroy(DicNode<T>* node);


};




template <class K,class T>
Dictionary<K,T>::Dictionary()
{
	dataLen=0;
	nc=0;
    root=new DicNode<T>();
}

template <class K,class T>
Dictionary<K,T>::~Dictionary()
{
   if(root!=0)
   {
      destroy(root);
   }
}


template <class K,class T>
void Dictionary<K,T>::destroy(DicNode<T>* node)
{
   if(node==0)
   {
      return;
   }

   DicNode<T>* c=node->Child;
   DicNode<T>* p=0;
   while(c!=0)
   {
      p=c->Suffix;
      destroy(c);
      c=p;
   }

   if(node->Parent!=0)
   {
       if(node->Prefix!=0||node->Suffix!=0)
	   {
           if(node->Prefix==0)
		   {
		        node->Parent->Child=node->Suffix;
			}

		    if(node->Suffix==0)
			{
		         node->Parent->Child=node->Prefix;
			}
	   }else
	   {
	       node->Parent->Child=0;
	   }
   }

   delete node;
}



template <class K,class T>
	bool Dictionary<K,T>::Add(K key,T value)
{

	int keyLen=0;
 
	{
       keyLen=sizeof(K);
	}
	char* keyStr=(char*)(&key);
	DicNode<T>* parent=root;
	for(int i=0;i<keyLen;i++)
	{
	    DicNode<T>* c=parent->Child;
		DicNode<T>* find=0;
		DicNode<T>* p=0;
		 while(c!=0)
		 {
		    p=c;
		    if(c->Key==keyStr[i])
			{
			     find=c;
				 break;
			}
		     c=c->Suffix;
		}
		if(find==0)
		{
		   DicNode<T>* n=new DicNode<T>();
		   nc++;
           n->Key=keyStr[i];

		   if(p==0)
		   {
		       parent->Child=n;
			   n->Parent=parent;

		   }else
		   {
		      p->Suffix=n;
			  n->Prefix=p;
		   }
		    parent=n;
		   if(i==keyLen-1)
		   {
		      n->HadData=true;
			  n->Value=value;
			  dataLen++;
			  return true;
		   }
		}
		else{

		   if(i==keyLen-1)
		   {
		       return false;
		   }
		   if(p!=0)
		   {
		      parent=p;
		   }else
		   {
		      return false;
		   }
		}
	}
	return true;
}

template <class K,class T>
	bool Dictionary<K,T>::ContainsKey(K key)
{
    bool isString=false;
	int keyLen=0;
	 
	{
       keyLen=sizeof(K);
	}
	char* keyStr=(char*)(&key);

   	DicNode<T>* parent=root;
	for(int i=0;i<keyLen;i++)
	{
	    DicNode<T>* c=parent->Child;
		DicNode<T>* find=0;
        while(c!=0)
		 {
		    if(c->Key==keyStr[i])
			{
			     find=c;
				 break;
			}
		     c=c->Suffix;
		}
		if(find==0)
		{
		   return false;
		}else
		{
		    if(i==keyLen-1)
			{
				return true;
			}
			 parent=find;
		}
	}
	return false;
}

template <class K,class T>
	bool Dictionary<K,T>::Remove(K key)
{

    bool isString=false;
	int keyLen=0;
	 
	{
       keyLen=sizeof(K);
	}
	char* keyStr=(char*)(&key);

   	DicNode<T>* parent=root;
	for(int i=0;i<keyLen;i++)
	{
	    DicNode<T>* c=parent->Child;
		DicNode<T>* find=0;
        while(c!=0)
		 {
		    if(c->Key==keyStr[i])
			{
			     find=c;
				 break;
			}
		     c=c->Suffix;
		}
		if(find==0)
		{
		   return false;
		}else
		{

		    if(i==keyLen-1)
			{
			   if(find->Child==0)
			   {
			       if(find->Prefix==0&&find->Suffix!=0)
				   {
				       find->Parent->Child=find->Suffix;
				   }
				   else if(find->Prefix==0&&find->Suffix==0)
				   {
					   find->Parent->Child=0;
				   }else
				   {
				       find->Prefix->Suffix=find->Suffix;
				   }
				   nc--;
				   delete find;
			   }else
			   {
			      find->HadData=false;
			   }
			    dataLen--;
				return true;
			}
			 parent=find;
		}
	}
	return false;
}


template <class K,class T>
int Dictionary<K,T>::GetDataLen()
{
   return this->dataLen;
}

template <class K,class T>
	int Dictionary<K,T>::GetKeys(K* keys,int kLen)
{

	int index=0;
   	getKeysByStep(root->Child,0,0,keys,kLen,index);
	return index;
}

template <class K,class T>
	int Dictionary<K,T>::GetValues(T* datas,int dLen)
{
	int index=0;
	getValuesByStep(root->Child,datas,dLen,index);
	return index;
}

template <class K,class T>
    T* Dictionary<K,T>:: operator [](K key)
{

	int keyLen=0;
	 
	{
       keyLen=sizeof(K);
	}
	char* keyStr=(char*)(&key);

   	DicNode<T>* parent=root;
	for(int i=0;i<keyLen;i++)
	{
	    DicNode<T>* c=parent->Child;
		DicNode<T>* find=0;
        while(c!=0)
		 {
		    if(c->Key==keyStr[i])
			{
			     find=c;
				 break;
			}
		     c=c->Suffix;
		}
		if(find==0)
		{
		   return 0;
		}else
		{
			if(i==(keyLen-1))
			{
			   if(find->HadData)
			   {
			       return &find->Value;
			   }else
			   {
			       return 0;
			   }
			}
			parent=find;
		}
	}

	return 0;
}

template <class K,class T>
void Dictionary<K,T>::getKeysByStep(DicNode<T>* child,char* prefixStr,int pLen,K* keys,int kLen,int &index)
{
    char* newPS=new char[pLen+2];
	int i=0;
	for(i=0;i<pLen;i++)
	{
	    newPS[i]=prefixStr[i];
	}
	newPS[i]=0;
	newPS[i+1]=0;

	DicNode<T>* c=child;

	while(c!=0)
	{
		newPS[pLen]=c->Key;
		if(c->HadData)
		{
		    keys[index++]=*((K*)newPS);
		}
		if(c->Child!=0)
		{
		   getKeysByStep(c->Child,newPS,pLen+1,keys,kLen,index);
		}
	    c=c->Suffix;
	}
	delete[] newPS;
}

template <class K,class T>
void Dictionary<K,T>::getValuesByStep(DicNode<T>* child,T* values,int vLen,int &index)
{
	DicNode<T>* c=child;
	while(c!=0)
	{
		if(c->HadData)
		{
		    values[index++]=c->Value;
		}
		if(c->Child!=0)
		{
		   getValuesByStep(c->Child,values,vLen,index);
		}
	    c=c->Suffix;
	}
}

#endif // !defined(AFX_DICTIONARY_H__58074A23_241D_4DFA_A8E6_DC4210F20CF5__INCLUDED_)
