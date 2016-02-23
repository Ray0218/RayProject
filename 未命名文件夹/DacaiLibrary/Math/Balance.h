//
//  Balance.h
//  DacaiLibrary
//
//  Created by WUFAN on 14/11/12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef DacaiLibrary_Balance_h
#define DacaiLibrary_Balance_h

#include <iostream>
#include <vector>

namespace dc_arithmetic {
    /**
     *  平衡算法
     *
     *  @param bc  [in out]计算所得倍数
     *  @param spm [in]对阵奖金
     *  @param n   [in]对阵数
     *  @param c   [in]预算注数
     */
    void balance(int *bc, float *spm, int n, int c = 0);

//    /**
//     *  拆分算法
//     *
//     *  @param original [in]原始内容
//     *  @param need     [in]单注需要的场次
//     *  @param result   [out]结果
//     */
//    template <typename T>
//    void gen_split(std::vector<std::vector<T>> original, int need, std::vector<std::vector<T> *> &result);
//    
//    /**
//     *  拆分算法
//     *
//     *  @param original [in]原始内容
//     *  @param need     [in]单注需要的场次
//     *  @param result   [out]结果
//     */
//    template <typename T>
//    void gen_split(std::vector<std::vector<T> *> original, int need, std::vector<std::vector<T> *> &result);
//    
//    template <typename T>
//    void del_split(std::vector<std::vector<T> *> &result);
    
    
    
    // 拆分算法
//    template <typename T>
//    void gen_split(std::vector<std::vector<T>> origs, int n, std::vector<std::vector<T> *> &result) {
//        int  count = origs.size();
//        int *lens = new int[count];
//        for (int i = 0; i < count; i++) {
//            lens[i] = origs[i].size();
//        }
//        
//        int *idxs = new int[n];
//        int *opts = new int[n];
//        for (int i = 0; i < n; i++) {
//            idxs[i] = i; opts[i] = 0;
//        }
//        
//        bool idx_carry = true;
//        bool opt_carry = true;
//        do {
//            memset(opts, 0, sizeof(int) * n);
//            do {
//                // 组织数据
//                std::vector<T> *tmp = new std::vector<T>;
//                for (int i = 0; i < n; i++) {
//                    tmp->push_back(origs[idxs[i]][opts[i]]);
//                }
//                result.push_back(tmp);
//                
//                opt_carry = true;   // 需要进位
//                for (int i = n - 1; opt_carry && i >= 0; i--) {
//                    if ((opt_carry = (opts[i] >= lens[idxs[i]] - 1))) {   // 进位
//                        opts[i] = 0;
//                    } else {
//                        opts[i]++;
//                    }
//                }
//            } while (!opt_carry);
//            
//            idx_carry = true;
//            for (int i = n - 1; idx_carry && i >= 0; i--) {
//                idx_carry = idxs[i] >= (count - n + i);//opts[i] >= lens[i];
//                if (!idx_carry) {
//                    idxs[i]++;
//                    for (int j = 1; j < n - i; j++) {
//                        idxs[i + j] = idxs[i] + j;
//                    }
//                }
//            }
//        } while (!idx_carry);
//    }
    
    // 拆分算法
    template <typename T>
    void gen_split(std::vector<std::vector<T> *> origs, int n, std::vector<std::vector<T> *> &result) {
        int  count = origs.size();
        int *lens = new int[count];
        for (int i = 0; i < count; i++) {
            lens[i] = origs[i]->size();
        }
        
        int *idxs = new int[n];
        int *opts = new int[n];
        for (int i = 0; i < n; i++) {
            idxs[i] = i; opts[i] = 0;
        }
        
        bool idx_carry = true;
        bool opt_carry = true;
        do {
            memset(opts, 0, sizeof(int) * n);
            do {
                // 组织数据
                std::vector<T> *tmp = new std::vector<T>;
                for (int i = 0; i < n; i++) {
                    //                    char ch = origs[idxs[i]][opts[i]];
                    //                    printf("%c ", ch);
                    
                    std::vector<T> * ts = origs[idxs[i]];
                    T t = ts->at(opts[i]);
                    tmp->push_back(t);
                    //                    tmp->push_back(origs[idxs[i]][opts[i]]);
                }
                //                printf("\n");
                result.push_back(tmp);
                
                opt_carry = true;   // 需要进位
                for (int i = n - 1; opt_carry && i >= 0; i--) {
                    if ((opt_carry = (opts[i] >= lens[idxs[i]] - 1))) {   // 进位
                        opts[i] = 0;
                    } else {
                        opts[i]++;
                    }
                }
            } while (!opt_carry);
            
            idx_carry = true;
            for (int i = n - 1; idx_carry && i >= 0; i--) {
                idx_carry = idxs[i] >= (count - n + i);//opts[i] >= lens[i];
                if (!idx_carry) {
                    idxs[i]++;
                    for (int j = 1; j < n - i; j++) {
                        idxs[i + j] = idxs[i] + j;
                    }
                }
            }
        } while (!idx_carry);
    }
    
    template <typename T>
    void del_split(std::vector<std::vector<T> *> &result) {
        for (int i = 0; i < result.size(); i++) {
            if (result[i]) {
                result[i]->clear();
                delete result[i];
                result[i] = NULL;
            }
        }
        result.clear();
    }
}

#endif
