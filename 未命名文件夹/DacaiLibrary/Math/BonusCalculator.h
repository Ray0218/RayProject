//
//  BonusCalculator.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__BonusCalculator__
#define __DacaiProject__BonusCalculator__

#include <iostream>
#include <vector>
#include <map>

using namespace std;

class CIntTreeNode {
public:
    int m_data;     // 数据
    int m_weight;   // 权重
    vector<CIntTreeNode *> m_subNodes;
    
    void Cleanup(); // 删除所有子节点
};

class CIntTree {
public:
    CIntTreeNode *m_top;
    int m_deep;
    
    CIntTree(int deep);
    ~CIntTree() {}
    
    void Destory();
};

class CNotesCalculator {
private:
    map<int, CIntTree *>    *mTreeMap;      // 树 - 字典
    vector<vector<int> *>    mBetOptions;   // 二维数组
    unsigned int             mPassMode;     // 过关方式
    int                      mMarkCount;    // 胆的个数
    
private:
    CNotesCalculator(map<int, CIntTree *> *treeMap, int matchCount, int *options, int *lengths, unsigned int passMode, int markCount);
    ~CNotesCalculator() {}
    
    void _buildTree();
    
    static int CountTree(map<int, CIntTree *> *treeMap);
    
public:
    /**
     *  计算注数竞技彩
     *
     *  @param matchCount [in]比赛场次数
     *  @param options    [in]选项个数
     *  @param lengths    [in]每场比赛选择的玩法个数数组
     *  @param passCount  [in]过关方式个数
     *  @param passModes  [in]过关方式数组
     *  @param markCount  [in]胆的个数
     *
     *  @return 返回注数(int类型)
     */
    static int Calculate(int matchCount, int *options, int *lengths, int passCount, int *passModes, int markCount = 0);
};






class CBonusCalculator {
private:
    int  m_matchCount;  // 比赛场数
    int *m_options;     // 所有选项数组(一维)
    int *m_lengths;     // 选项长多数组(一维)
    
    int  m_passCount;   // 过关方式个数
    int *m_passModes;   // 过关方式数组
    
    int  m_markCount;   // 胆的个数
    
private:
    int *m_danOptions;
    int *m_danLengths;
    int  m_danCount;
    
    int *m_tuoOptions;
    int *m_tuoLengths;
    int  m_tuoCount;
    
    map<int, CIntTree *> m_map;
    
private:
    CBonusCalculator(int matchCount, int *options, int *lengths, int passCount, int *passModes, int markCount);
    ~CBonusCalculator();
    
//    void BuildTree(int *, int , int deep);
    
    int Calculate();
//    int CalculateNote(int matchCount, int *options, int *lengths, int passMode, int markCount);
    
    
    
    vector<vector<int> *> mOptions; // 二维数组
    
    
public:
    
    /**
     *  计算注数竞技彩
     *
     *  @param matchCount [in]比赛场次数
     *  @param options    [in]选项个数
     *  @param lengths    [in]每场比赛选择的玩法个数数组
     *  @param passCount  [in]过关方式个数
     *  @param passModes  [in]过关方式数组
     *  @param markCount  [in]胆的个数
     *
     *  @return 返回最终数组(int类型)
     */
    static int Calculate(int matchCount, int *options, int *lengths, int passCount, int *passModes, int markCount = 0);
};

class CBonusAnalyzer {
public:
    // 真实sp值*100
    
    void JczqAnalysis(int spListRqspf[3], int spListBf[31], int spListZjq[8], int spListBqc[9], int spListSpf[3], int balance);
    
    
    
    int JczqGetOptionIndex(int gameType, int home, int away, int balance);
    
    
    
    
    void JclqAnalysis(int spListSf[2], int spListRfsf[2], int spListSfc[12], int spListDxf[2], int balance);
    
    
    
    int JclqGetOptionIndex(int gameType, int home, int away, int balance);
};






#endif /* defined(__DacaiProject__BonusCalculator__) */
