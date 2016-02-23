//
//  LotteryStruct.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__LotteryStruct__
#define __DacaiProject__LotteryStruct__

#include <iostream>
#include <vector>

template <typename T>
class TreeNode;

template <typename T>
class Tree {
public:
    TreeNode<T>        * topNode;
    int                  deep;      // 深度
    
public:
    Tree(int deep);
    ~Tree();
};

template <typename T>
class TreeNode {
public:
    T   data;       // 数据
    int weight;     // 权重
    
    std::vector<TreeNode<T> *>        childNodes;
    
public:
    TreeNode(T data);
    ~TreeNode();
};

template <typename T>
class List {
public:
    T   * data;
    int   count;
    int   multiple;
    
public:
    List(T * data, int count);
    List(T * data, int count, int multiple);
    ~List();
};

#endif /* defined(__DacaiProject__LotteryStruct__) */
