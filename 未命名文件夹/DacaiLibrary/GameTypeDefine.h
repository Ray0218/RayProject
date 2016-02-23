//
//  GameTypeDefine.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef DacaiProject_GameTypeDefine_h
#define DacaiProject_GameTypeDefine_h

#ifndef __GameTypeId__
#define __GameTypeId__

typedef enum _GameTypeId {
    GameTypeNone    = 0,
    
    // 数字彩
    GameTypeSd      = 1,    // 福彩3D,        DacaiLibrary/Lottery3D.h
    GameTypeSsq     = 2,    // 双色球,        DacaiLibrary/DoubleChromosphere.h
    GameTypeQlc     = 3,    // 七乐彩,        DacaiLibrary/SevenLuck.h
    GameTypeDlt     = 4,    // 大乐透,        DacaiLibrary/SuperLotto.h
    GameTypePs      = 5,    // 排三,          DacaiLibrary/Pick3.h
    GameTypePw      = 6,    // 排五,          DacaiLibrary/Pick5.h
    GameTypeQxc     = 7,    // 七星彩,        DacaiLibrary/SevenStar.h
    GameTypeHdsyxw  = 8,    // 华东十一选五
    GameTypeDfljy   = 9,    // 东方六加一
    GameTypeZjtcljy = 10,   // 浙江体彩6+1
    GameTypeTc22x5  = 11,   // 22选5
    
    // 足彩
    GameTypeZcNone  = 100,  //
    GameTypeZc14    = 101,  // 胜负彩, DacaiLibrary/LotteryZc14.h
    GameTypeZc9     = 102,  // 任选九, DacaiLibrary/LotteryZc9.h
    GameTypeZc4     = 104,  // 进球彩
    GameTypeZc6     = 103,  // 半全场
    
    // 北京单场
    GameTypeBdNone  = 110,  // DacaiLibrary/LotteryBd.h
    GameTypeBdRqspf = 111,  // 让球胜平负
    GameTypeBdSxds  = 112,  // 上下单双
    GameTypeBdZjq   = 113,  // 总进球
    GameTypeBdBf    = 114,  // 比分
    GameTypeBdBqc   = 115,  // 半全场
    GameTypeBdSf    = 116,  // 胜负
    
    // 竞彩足球
    GameTypeJcNone  = 120,  // DacaiLibrary/LotteryJczq.h
    GameTypeJcRqspf = 121,  // 让球胜平负
    GameTypeJcBf    = 122,  // 比分
    GameTypeJcZjq   = 123,  // 总进球
    GameTypeJcBqc   = 124,  // 半全场
    GameTypeJcGJ    = 125,  // 竞彩冠军
    GameTypeJcGYJ   = 126,  // 竞彩冠亚军
    GameTypeJcHt    = 127,  // 混投
    GameTypeJcSpf   = 128,  // 胜平负
    
    // 竞彩篮球
    GameTypeLcNone  = 130,  // DacaiLibrary/LotteryJclq.h
    GameTypeLcSf    = 131,  // 胜负
    GameTypeLcRfsf  = 132,  // 让分胜负
    GameTypeLcSfc   = 133,  // 胜分差
    GameTypeLcDxf   = 134,  // 大小分
    GameTypeLcHt    = 135,  // 混投
    
    // 高频彩
    GameTypeSyydj   = 201,  // 十一运夺金
    GameTypeJxssc   = 202,  // 江西时时彩
    GameTypeKlsf    = 203,  // 重庆快乐十分
    GameTypeJxsyxw  = 204,  // 江西十一选五,      DacaiLibrary/Jxsyxw.h
    GameTypeNmgks   = 205,  // 内蒙古快三,       DacaiLibrary/QuickThree.h
    GameTypeHljsyxw = 206,  // 黑龙江十一选五
    GameTypeSdpks   = 207,  // 快乐扑克三,       DacaiLibrary/PokerThree.h
    
} GameTypeId;

#endif

typedef enum _JcBdGameVisible {
    // 竞彩足球
    JczqGameVisibleRqspf    = 0x00000001,   // 0000 0000 0000 0000_0000 0000 0000 0001, 1
    JczqGameVisibleBf       = 0x00000002,   // 0000 0000 0000 0000_0000 0000 0000 0010, 2
    JczqGameVisibleZjq      = 0x00000004,   // 0000 0000 0000 0000_0000 0000 0000 0100, 4
    JczqGameVisibleBqc      = 0x00000008,   // 0000 0000 0000 0000_0000 0000 0000 1000, 8
    JczqGameVisibleSpf      = 0x00000100,   // 0000 0000 0000 0000_0000 0001 0000 0000, 256
    JczqGameVisibleAll      = 0x0000010F,   // 0000 0000 0000 0000_0000 0001 0000 1111, 271
    
    // 竞彩篮球
    JclqGameVisibleSf       = 0x00000010,   // 0000 0000 0000 0000_0000 0000 0001 0000, 16
    JclqGameVisibleRfsf     = 0x00000020,   // 0000 0000 0000 0000_0000 0000 0010 0000, 32
    JclqGameVisibleSfc      = 0x00000040,   // 0000 0000 0000 0000_0000 0000 0100 0000, 64
    JclqGameVisibleDxf      = 0x00000080,   // 0000 0000 0000 0000_0000 0000 1000 0000, 128
    JclqGameVisibleAll      = 0x000000F0,   // 0000 0000 0000 0000_0000 0000 1111 0000, 240
    
    JcGameVisibleAll        = 0x000001FF,   // 0000 0000 0000 0000_0000 0001 1111 1111, 511
    
    BdGameVisibleRqspf      = 0x00010000,   // 0000 0000 0000 0001_0000 0000 0000 0000
    BdGameVisibleSxds       = 0x00020000,   // 0000 0000 0000 0010_0000 0000 0000 0000
    BdGameVisibleZjq        = 0x00040000,   // 0000 0000 0000 0100_0000 0000 0000 0000
    BdGameVisibleBf         = 0x00080000,   // 0000 0000 0000 1000_0000 0000 0000 0000
    BdGameVisibleBqc        = 0x00100000,   // 0000 0000 0001 0000_0000 0000 0000 0000
    BdGameVisibleAll        = 0x001F0000,   // 0000 0000 0001 1111_0000 0000 0000 0000
    
    JcBdGameVisibleAll      = 0x001F01FF,   // 0000 0000 0001 1111_0000 0001 1111 1111
    
} JcBdGameVisible;

#define JcSpfEnable(gameVisible)        ((gameVisible & JczqGameVisibleSpf) != 0)
#define JcRqspfEnable(gameVisible)      ((gameVisible & JczqGameVisibleRqspf) != 0)
#define JcBfEnable(gameVisible)         ((gameVisible & JczqGameVisibleBf) != 0)
#define JcBqcEnable(gameVisible)        ((gameVisible & JczqGameVisibleBqc) != 0)
#define JcZjqEnable(gameVisible)        ((gameVisible & JczqGameVisibleZjq) != 0)

#define LcSfEnable(gameVisible)         ((gameVisible & JclqGameVisibleSf) != 0)
#define LcRfsfEnable(gameVisible)       ((gameVisible & JclqGameVisibleRfsf) != 0)
#define LcDxfEnable(gameVisible)        ((gameVisible & JclqGameVisibleDxf) != 0)
#define LcSfcEnable(gameVisible)        ((gameVisible & JclqGameVisibleSfc) != 0)

#define BdRqspfEnable(gameVisible)      ((gameVisible & BdGameVisibleRqspf) != 0)
#define BdSxdsEnable(gameVisible)       ((gameVisible & BdGameVisibleSxds) != 0)
#define BdZjqEnable(gameVisible)        ((gameVisible & BdGameVisibleZjq) != 0)
#define BdBfEnable(gameVisible)         ((gameVisible & BdGameVisibleBf) != 0)
#define BdBqcEnable(gameVisible)        ((gameVisible & BdGameVisibleBqc) != 0)

#endif
