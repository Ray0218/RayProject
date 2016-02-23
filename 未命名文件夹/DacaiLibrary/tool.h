//
//  DPAppDelegate.m
//  DacaiProject
//
//  Created by HaiboPan on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#include <string>
#include <vector>
#include <stdio.h>
#include <assert.h>

using  namespace  std;

#ifndef TOOLINCLUDE
#define TOOLINCLUDE

int Split(string &src,std::vector<std::string> &str_list, const char * sp);
int GetSpItem(string & src,std::vector<int  > &target);
int TipTime();
long long  GTime();
/**
 *  将字符串转化为数组(开奖号码字符串转换成数组)
 *
 *  @param str   [in]开奖号码 e.g. "01,02,03,04,05|06,07"
 *  @param nums  [out]数组 e.g. { 1, 2, 3, 4, 5, 6, 7 }
 *  @param size  [in]数组长度
 *
 *  @return 返回值为实际转化的元素个数, <0表示数组长度过小(只转化了一部分), >=0表示成功
 */
int StringSplitToInteger(string str, int *nums, size_t size);
/**
*  将字符串转化为数组(开奖号码字符串转换成数组)
*
*  @param str   [in]开奖号码 e.g. "123456"
*  @param nums  [out]数组 e.g. { 1, 2, 3, 4, 5, 6, 7 }
*  @param size  [in]数组长度
*
*  @return 返回值为实际转化的元素个数, <0表示数组长度过小(只转化了一部分), >=0表示成功
*/
int StringToInteger(string str, int *nums, size_t size);
/**
 *  将字符串转化为数组(开奖号码字符串转换成数组)
 *
 *  @param str   [in]开奖号码 e.g. "1234567"
 *  @param nums  [out]数组 e.g. { 1, 2, 3, 4, 5, 6, 7 }
 *  @param size  [in]数组长度
 *
 *  @return 返回值为实际转化的元素个数, <0表示数组长度过小(只转化了一部分), >=0表示成功
 */
int StringDivideToInteger(string str, int *nums, size_t size);

/**
 *  输出16进制
 *
 *  @param buff [in]16进制流
 *  @param len  [in]长度
 */
void PrintHexString(unsigned char *buff, int len);

/**
 *  将日期转换成int
 *
 *  @param date [in]日期  e.g. "2014-08-14 13:36:21"
 *
 *  @return e.g. 20140814
 */
int GetDateInt(string date);
int AnalyseError(int e);
int StringToDoubleInteger(string str, int *nums, size_t size);



template <typename T>
void destory_vector(vector<T *> &list) {
    for (int i = 0; i < list.size(); i++) {
        if (list[i]) {
            delete list[i];
            list[i] = NULL;
        }
    }
    list.clear();
}

#endif
