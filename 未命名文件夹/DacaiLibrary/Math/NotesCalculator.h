//
//  NotesCalculator.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__NotesCalculator__
#define __DacaiProject__NotesCalculator__

#include <iostream>
#include <map>
#include <vector>

typedef void( *MIXED_CALLBACK)(int * options, int length, void * parameter);
typedef void( *BUILD_CALLBACK)(int * options, int length, void * parameter);

template <typename T>
class Tree;
template <typename T>
class TreeNode;
template <typename T>
class List;

class NotesCalculator {
public:
    int *m_passModes;
    int  m_passCount;
    
    int *m_options;      //
    int *m_counts;       //
    int  m_length;       // 赛事场数
    int  m_markCount;
    
private:
    std::map<int, Tree<int> *>    m_treeMapTable;
    
public:
    NotesCalculator();
    ~NotesCalculator();
    
    int Calculate();
private:
    
//    void CalculateFreedom(unsigned int passModeTag);
    void CalculateAndBuildTree(unsigned int passModeTag);
    
    void MixedSplit(int * options, int * lengths, int count, int splitLen, MIXED_CALLBACK callback, void * parameter);
    void CombinationTree(int * options, int length, int count, int multiple);
    
    int SumTreeNode(TreeNode<int> * node);
    
    // callback
    static void MixedSplitCallBack(int * options, int length, void * parameter);
//    static void BuildTreeCallBack(int * options, int length, void * parameter);
};

#endif /* defined(__DacaiProject__NotesCalculator__) */
