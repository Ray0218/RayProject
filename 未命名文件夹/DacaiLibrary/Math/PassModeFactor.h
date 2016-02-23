//
//  PassModeFactor.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__PassModeTable__
#define __DacaiProject__PassModeTable__

#include <iostream>
#include <vector>

using namespace std;

class CPassModeFactor {
protected:
    typedef struct _PassModeGroup {
        int freedomCount;
        int combineCount;
        
        int freedomTags[16];
        int combineTags[32];
    } PassModeGroup;
    
public:
    CPassModeFactor();
    
    /**
     *  获取可用的过关方式
     *
     *  @param gameTypes   [in]玩法类型数组
     *  @param typeCount   [in]数组长度
     *  @param markCount   [in]胆的个数
     *  @param matchCount  [in]比赛场数
     *  @param freedomTags [out]自由过关
     *  @param combineTags [out]组合过关
     *
     *  @return <0表示失败, >=0表示成功
     */
    int GetPassModes(int *gameTypes, int typeCount, int markCount, int matchCount, vector<int> &freedomTags, vector<int> &combineTags);
    
private:
    CPassModeFactor::PassModeGroup _passModeTable(int gameType);
    
private:
    CPassModeFactor::PassModeGroup mJcSpf;
    CPassModeFactor::PassModeGroup mJcRqspf;
    CPassModeFactor::PassModeGroup mJcBf;
    CPassModeFactor::PassModeGroup mJcBqc;
    CPassModeFactor::PassModeGroup mJcZjq;
    
    CPassModeFactor::PassModeGroup mBdRqspf;
    CPassModeFactor::PassModeGroup mBdBf;
    CPassModeFactor::PassModeGroup mBdBqc;
    CPassModeFactor::PassModeGroup mBdZjq;
    CPassModeFactor::PassModeGroup mBdSxds;
    
    CPassModeFactor::PassModeGroup mLcSf;
    CPassModeFactor::PassModeGroup mLcRfsf;
    CPassModeFactor::PassModeGroup mLcDxf;
    CPassModeFactor::PassModeGroup mLcSfc;
};



#define ERROR_CANNOT_PROFIX         -801        // 方案无法盈利
#define ERROR_OVERLARGE_EXPECT      -802        // 盈利率设置过大，无法达到预期

class CCapacityFactor {
public:
    CCapacityFactor() {}
    
    /**
     *  设置方案信息
     *
     *  @param amount       [in]方案金额
     *  @param minBonus     [in]中奖最小金额
     *  @param maxBonus     [in]中奖最大金额
     *  @param periods      [in]追号期数
     *  @param initMultiple [in]初始倍数
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetProjectInfo(int amount, int minBonus, int maxBonus, int periods, int initMultiple) {
        mAmount = amount;
        mMinBonus = minBonus;
        mMaxBonus = maxBonus;
        mPeriods = periods;
        mInitMultiple = initMultiple;
        return 0;
    }
    
    /**
     *  设置最小盈利金额
     *
     *  @param amount [in]预期最小盈利金额
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetProfitAmount(int amount) {
        mType = 0;
        mProfitAmount = amount;
        return 0;
    }
    
    /**
     *  设置最小盈利率
     *
     *  @param rate [in]预期最小盈利率
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetProfitRate(int rate) {
        mType = 1;
        
        mProfitRate = rate / 100.0;
        return 0;
    }
    
    /**
     *  设置条件
     *
     *  @param periods   [in]见earlyRate说明
     *  @param earlyRate [in]前periods期预期最小盈利率
     *  @param lastRate  [in]periods期之后预期最小盈利率
     *
     *  @return <0表示失败, >=0表示成功
     */
    int SetCondition(int periods, int earlyRate, int lastRate) {
        mType = 2;
        
        mEarlyPeriods = periods;
        mEarlyRate = earlyRate / 100.0;
        mLastRate = lastRate / 100.0;
        return 0;
    }
    
    /**
     *  生成智能追号条件
     *
     *  @param multiple    [out]每期倍数数组
     *  @param totalAmount [out]每期累加金额数据
     *  @param minProfit   [out]最小盈利金额数据
     *  @param maxProfit   [out]最大盈利金额数据
     *  @param rate        [out]每期盈利率数组
     *
     *  @return <0表示失败, >=0表示成功, 即生成的期号数
     */
    int Generate(vector<int> &multiple, vector<int> &totalAmount, vector<int> &minProfit, vector<int> &maxProfit, vector<int> &rate) {
        switch (mType) {
            case 0:
                return _generateAmt(multiple, totalAmount, minProfit, maxProfit, rate);
            case 1:
                return _generateRate(multiple, totalAmount, minProfit, maxProfit, rate);
            case 2:
                return _generateCommon(multiple, totalAmount, minProfit, maxProfit, rate);
            default:
                return -10;
        }
    }
    
protected:
    int _generateAmt(vector<int> &multiple, vector<int> &totalAmount, vector<int> &minProfit, vector<int> &maxProfit, vector<int> &rate);
    int _generateRate(vector<int> &multiple, vector<int> &totalAmount, vector<int> &minProfit, vector<int> &maxProfit, vector<int> &rate);
    int _generateCommon(vector<int> &multiple, vector<int> &totalAmount, vector<int> &minProfit, vector<int> &maxProfit, vector<int> &rate);
    
protected:
    int mAmount;
    int mMinBonus;
    int mMaxBonus;
    int mPeriods;
    int mInitMultiple;
    
    int mType;
    int mProfitAmount;
    float mProfitRate;
    int mEarlyPeriods;
    float mEarlyRate;
    float mLastRate;
};


#endif /* defined(__DacaiProject__PassModeTable__) */
