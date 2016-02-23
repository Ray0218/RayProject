//
//  PassModeDefine.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__PassModeDefine__
#define __DacaiProject__PassModeDefine__

#define GetPassModeNamePrefix(passModeTag)  (((passModeTag) & 0xFF000000U) >> 24)
#define GetPassModeNameSuffix(passModeTag)  (((passModeTag) & 0x00FF0000U) >> 16)
#define GetPassModeMaxSingle(passModeTag)   (((passModeTag) & 0x0000FF00U) >> 8)
#define GetPassModeMinSingle(passModeTag)   (((passModeTag) & 0x000000FFU) >> 0)

extern const unsigned int PASSMODE_1_1;
extern const unsigned int PASSMODE_2_1;
extern const unsigned int PASSMODE_2_3;
extern const unsigned int PASSMODE_3_1;
extern const unsigned int PASSMODE_3_3;
extern const unsigned int PASSMODE_3_4;
extern const unsigned int PASSMODE_3_6;
extern const unsigned int PASSMODE_3_7;
extern const unsigned int PASSMODE_4_1;
extern const unsigned int PASSMODE_4_4;
extern const unsigned int PASSMODE_4_5;
extern const unsigned int PASSMODE_4_6;
extern const unsigned int PASSMODE_4_10;
extern const unsigned int PASSMODE_4_11;
extern const unsigned int PASSMODE_4_14;
extern const unsigned int PASSMODE_4_15;
extern const unsigned int PASSMODE_5_1;
extern const unsigned int PASSMODE_5_5;
extern const unsigned int PASSMODE_5_6;
extern const unsigned int PASSMODE_5_10;
extern const unsigned int PASSMODE_5_15;
extern const unsigned int PASSMODE_5_16;
extern const unsigned int PASSMODE_5_20;
extern const unsigned int PASSMODE_5_25;
extern const unsigned int PASSMODE_5_26;
extern const unsigned int PASSMODE_5_30;
extern const unsigned int PASSMODE_5_31;
extern const unsigned int PASSMODE_6_1;
extern const unsigned int PASSMODE_6_6;
extern const unsigned int PASSMODE_6_7;
extern const unsigned int PASSMODE_6_15;
extern const unsigned int PASSMODE_6_20;
extern const unsigned int PASSMODE_6_21;
extern const unsigned int PASSMODE_6_22;
extern const unsigned int PASSMODE_6_35;
extern const unsigned int PASSMODE_6_41;
extern const unsigned int PASSMODE_6_42;
extern const unsigned int PASSMODE_6_50;
extern const unsigned int PASSMODE_6_56;
extern const unsigned int PASSMODE_6_57;
extern const unsigned int PASSMODE_6_62;
extern const unsigned int PASSMODE_6_63;
extern const unsigned int PASSMODE_7_1;
extern const unsigned int PASSMODE_7_7;
extern const unsigned int PASSMODE_7_8;
extern const unsigned int PASSMODE_7_21;
extern const unsigned int PASSMODE_7_35;
extern const unsigned int PASSMODE_7_120;
extern const unsigned int PASSMODE_7_127;
extern const unsigned int PASSMODE_8_1;
extern const unsigned int PASSMODE_8_8;
extern const unsigned int PASSMODE_8_9;
extern const unsigned int PASSMODE_8_28;
extern const unsigned int PASSMODE_8_56;
extern const unsigned int PASSMODE_8_70;
extern const unsigned int PASSMODE_8_247;
extern const unsigned int PASSMODE_8_255;
extern const unsigned int PASSMODE_9_1;
extern const unsigned int PASSMODE_10_1;
extern const unsigned int PASSMODE_11_1;
extern const unsigned int PASSMODE_12_1;
extern const unsigned int PASSMODE_13_1;
extern const unsigned int PASSMODE_14_1;
extern const unsigned int PASSMODE_15_1;

//#define PASSMODE_ZC_14  PASSMODE_14_1
//#define PASSMODE_ZC_9   PASSMODE_9_1

extern const unsigned int FreedomTableSize1;
extern const unsigned int FreedomTableSize2;
extern const unsigned int FreedomTableSize3;
extern const unsigned int FreedomTableSize4;
extern const unsigned int FreedomTableSize5;
extern const unsigned int FreedomTableSize6;
extern const unsigned int FreedomTableSize7;

extern const unsigned int CombineTableSize1;
extern const unsigned int CombineTableSize2;
extern const unsigned int CombineTableSize3;
extern const unsigned int CombineTableSize4;
extern const unsigned int CombineTableSize5;

extern const unsigned int FreedomPassModeTable1[];
extern const unsigned int FreedomPassModeTable2[];
extern const unsigned int FreedomPassModeTable3[];
extern const unsigned int FreedomPassModeTable4[];
extern const unsigned int FreedomPassModeTable5[];
extern const unsigned int FreedomPassModeTable6[];
extern const unsigned int FreedomPassModeTable7[];

extern const unsigned int CombinePassModeTable1[];
extern const unsigned int CombinePassModeTable2[];
extern const unsigned int CombinePassModeTable3[];
extern const unsigned int CombinePassModeTable4[];
extern const unsigned int CombinePassModeTable5[];

extern const unsigned int PassModeTableSize;
extern const unsigned int FreedomTableSize;
extern const unsigned int CombineTableSize;

extern const unsigned int PassModeTable[];
extern const unsigned int FreedomPassModeTable[];
extern const unsigned int CombinePassModeTable[];

#endif /* defined(__DacaiProject__PassModeDefine__) */
