//
//  BaseMath.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__BaseMath__
#define __DacaiProject__BaseMath__

#include <iostream>
#include <vector>
#define uint32_t unsigned int 
using namespace std;

class CMathHelper {
  public:
    /**
     *  n个数中取m个数的组合个数
     *
     *  @param n [in]n
     *  @param m [in]m
     *
     *  @return 组合个数
     */
    static int GetCombinationInt(int n, int m);
    /**
     *  <#Description#>
     *
     *  @param source <#source description#>
     *  @param length <#length description#>
     *  @param count  <#count description#>
     *
     *  @return <#return value description#>
     */
    static vector<char *> GetCombinationGroup(const char *source, int length, int count);
    /**
     *  回收容器内存
     *
     *  @param groups [inout]目标容器
     */
    static void ClearGroup(vector<char *> groups);
    /**
     *  升序排序
     *
     *  @param array  [inout]数组
     *  @param length [in]数组长度
     */
    static void OrderIntAscending(int *array, int length);
    /**
     *  降序排序
     *
     *  @param array  [inout]数组
     *  @param length [in]数组长度
     */
    static void OrderIntDescending(int *array, int length);
    /**
     *  取两个int数组的交集
     *
     *  @param array1  [in]升序数组1,
     *  @param lenght1 [in]数组1的长度
     *  @param array2  [in]升序数组2
     *  @param length2 [in]数组2的长度
     *  @param array   [out]缓冲区, 生成的交集数组保存在其中
     *  @param length  [in]缓冲区的长度
     *  @param size    [out]交集大小
     *  @return 返回0表示成功, 否则为失败
     */
    static int IntersectIntSet(int *array1, int lenght1, int *array2, int length2, int *array, int length, int &size);
    /**
     *  拷贝内存区域
     *
     *  @param dst [out]目标内存地址
     *  @param src [in]源内存地址
     *  @param n   [in]内存区域大小
     */
    static void MemoryCopy(void *dst, const void *src, size_t n);
    /**
     *  内存区域清零
     *
     *  @param s   [inout]目标内存地址
     *  @param n   [in]内存区域大小
     */
    static void ZeroMemory(void *s, size_t n);
    /**
     *  判断内存区域是否全为0
     *
     *  @param mem [in]目标内存地址
     *  @param n   [in]内存区域大小
     */
    static bool IsZero(void *mem, size_t n);
};


#include "../zlib/zlib.h"

class RSAProvider;

namespace CryptUtilities {
    int encrypt(const unsigned char *plaintext, const int len, unsigned char *ciphertext, const int buffsize, const RSAProvider *pRSAProvider);
    int decrypt(const unsigned char *ciphertext, const int len, unsigned char *plaintext, const int buffsize);
    
    inline void tea_encipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
        unsigned int i;
        uint32_t v0 = v[0], v1 = v[1], sum = 0, delta = 0x9E3779B9;
        for (i = 0; i < num_rounds; i++) {
            v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
            sum += delta;
            v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum >> 11) & 3]);
        }
        v[0] = v0;
        v[1] = v1;
    }
    
    inline void tea_decipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
        unsigned int i;
        uint32_t v0 = v[0], v1 = v[1], delta = 0x9E3779B9, sum = delta * num_rounds;
        for (i = 0; i < num_rounds; i++) {
            v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum >> 11) & 3]);
            sum -= delta;
            v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
        }
        v[0] = v0;
        v[1] = v1;
    }

    int httpgzdecompress(Byte *zdata, uLong nzdata,
                         Byte *data, uLong *ndata);

}








#endif /* defined(__DacaiProject__BaseMath__) */
