//
//  BetDescriptor.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__BetDescriptor__
#define __DacaiProject__BetDescriptor__

#include <iostream>
#include <string>

class CSmartDigitalLotteryCell;
class CSmartQuickLotteryCell;
class CSmartHighLotteryCell;

class CBetDescriptor {
public:
    static std::string Digital2JSON(CSmartDigitalLotteryCell *lotteryCell);
    static std::string Quick2JSON(CSmartQuickLotteryCell *lotteryCell);
    static std::string High2JSON(CSmartHighLotteryCell *lotteryCell);
private:
    static std::string SSQ2JSON(CSmartDigitalLotteryCell *lotteryCell);
    static std::string DLT2JSON(CSmartDigitalLotteryCell *lotteryCell);
    static std::string QLC2JSON(CSmartDigitalLotteryCell *lotteryCell);
    static std::string QXC2JSON(CSmartDigitalLotteryCell *lotteryCell);
    static std::string PW2JSON(CSmartDigitalLotteryCell *lotteryCell);
    static std::string PS2JSON(CSmartDigitalLotteryCell *lotteryCell);
    static std::string SD2JSON(CSmartDigitalLotteryCell *lotteryCell);
    
    static std::string NMGKS2JSON(CSmartQuickLotteryCell *lotteryCell);
    
    static std::string PKS2JSON(CSmartHighLotteryCell *lotteryCell);
    static std::string JXSYXW2JSON(CSmartHighLotteryCell *lotteryCell);
    
public:
    static std::string HighBetType(CSmartHighLotteryCell *cell);
    static std::string QuickBetType(CSmartQuickLotteryCell *cell);
    
private:
    static std::string PKSBetType(CSmartHighLotteryCell *cell);
    static std::string JXSYXWBetType(CSmartHighLotteryCell *cell);
    
    static std::string NMGKSBetType(CSmartQuickLotteryCell *cell);
};

#endif /* defined(__DacaiProject__BetDescriptor__) */
