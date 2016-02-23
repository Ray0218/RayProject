//
//  GameTypeEnum.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DACAIPROJECT_GAMETYPEENUM_H__
#define __DACAIPROJECT_GAMETYPEENUM_H__

#ifndef __GameTypeId__
#define __GameTypeId__
typedef NS_ENUM(NSInteger, GameTypeId)
{
    GameTypeNone    = 0,
    
    // 数字彩
    GameTypeSd      = 1,    // 福彩3D
    GameTypeSsq     = 2,    // 双色球
    GameTypeQlc     = 3,    // 七乐彩
    GameTypeDlt     = 4,    // 大乐透
    GameTypePs      = 5,    // 排三
    GameTypePw      = 6,    // 排五
    GameTypeQxc     = 7,    // 七星彩
    GameTypeHdsyxw  = 8,    // 华东十一选五
    GameTypeDfljy   = 9,    // 东方六加一
    GameTypeZjtcljy = 10,   // 浙江体彩6+1
    GameTypeTc22x5  = 11,   // 22选5
    
    // 足彩
    GameTypeZcNone  = 100,  //
    GameTypeZc14    = 101,  // 胜负彩
    GameTypeZc9     = 102,  // 任选九
    GameTypeZc4     = 104,  // 进球彩
    GameTypeZc6     = 103,  // 半全场
    
    // 北京单场
    GameTypeBdNone  = 110,  // 合买
    GameTypeBdRqspf = 111,  // 让球胜平负
    GameTypeBdSxds  = 112,  // 上下单双
    GameTypeBdZjq   = 113,  // 总进球
    GameTypeBdBf    = 114,  // 比分
    GameTypeBdBqc   = 115,  // 半全场
    GameTypeBdSf    = 116,  // 胜负
    
    // 竞彩足球
    GameTypeJcNone  = 120,  // 合买
    GameTypeJcRqspf = 121,  // 让球胜平负
    GameTypeJcBf    = 122,  // 比分
    GameTypeJcZjq   = 123,  // 总进球
    GameTypeJcBqc   = 124,  // 半全场
    GameTypeJcGJ    = 125,  // 竞彩冠军
    GameTypeJcGYJ   = 126,  // 竞彩冠亚军
    GameTypeJcHt    = 127,  // 混投
    GameTypeJcSpf   = 128,  // 胜平负
    
    // 竞彩篮球
    GameTypeLcNone  = 130,  // 合买
    GameTypeLcSf    = 131,  // 胜负
    GameTypeLcRfsf  = 132,  // 让分胜负
    GameTypeLcSfc   = 133,  // 胜分差
    GameTypeLcDxf   = 134,  // 大小分
    GameTypeLcHt    = 135,  // 混投
    
    // 高频彩
    GameTypeSyydj   = 201,  // 十一运夺金
    GameTypeJxssc   = 202,  // 江西时时彩
    GameTypeKlsf    = 203,  // 重庆快乐十分
    GameTypeJxsyxw  = 204,  // 江西十一选五
    GameTypeNmgks   = 205,  // 内蒙古快三
    GameTypeHljsyxw = 206,  // 黑龙江十一选五
    GameTypeSdpks   = 207,  // 快乐扑克三
    
};
#endif

inline static BOOL IsGameTypeJc(GameTypeId gameType) {
    return (gameType == GameTypeJcNone ||
            gameType == GameTypeJcRqspf ||
            gameType == GameTypeJcBf ||
            gameType == GameTypeJcZjq ||
            gameType == GameTypeJcBqc ||
            gameType == GameTypeJcGJ ||
            gameType == GameTypeJcGYJ ||
            gameType == GameTypeJcHt ||
            gameType == GameTypeJcSpf );
}

inline static BOOL IsGameTypeLc(GameTypeId gameType) {
    return (gameType == GameTypeLcNone ||
            gameType == GameTypeLcSf ||
            gameType == GameTypeLcRfsf ||
            gameType == GameTypeLcSfc ||
            gameType == GameTypeLcDxf ||
            gameType == GameTypeLcHt );
}

inline static BOOL IsGameTypeBd(GameTypeId gameType) {
    return (gameType == GameTypeBdNone ||
            gameType == GameTypeBdRqspf ||
            gameType == GameTypeBdSxds ||
            gameType == GameTypeBdZjq ||
            gameType == GameTypeBdBf ||
            gameType == GameTypeBdBqc ||
            gameType == GameTypeBdSf );
}

inline static BOOL IsGameTypeZc(GameTypeId gameType) {
    return (gameType == GameTypeZcNone ||
            gameType == GameTypeZc14 ||
            gameType == GameTypeZc9 ||
            gameType == GameTypeZc4 ||
            gameType == GameTypeZc6 );
}

inline static BOOL IsGameTypeSport(GameTypeId gameType) {
    return (gameType >= 100 & gameType < 200);
}

inline static NSString *dp_GameTypeFirstName(GameTypeId gameType) {
    switch (gameType) {
            // 数字彩
        case GameTypeSd:
            return @"福彩3D";
        case GameTypeSsq:
            return @"双色球";
        case GameTypeQlc:
            return @"七乐彩";
        case GameTypeDlt:
            return @"大乐透";
        case GameTypePs:
            return @"排列三";
        case GameTypePw:
            return @"排列五";
        case GameTypeQxc:
            return @"七星彩";
        case GameTypeHdsyxw:
            return @"华东11选5";
        case GameTypeDfljy:
            return @"东方6+1";
        case GameTypeZjtcljy:
            return @"浙江体彩6+1";
        case GameTypeTc22x5:
            return @"22选5";
            // 足彩
        case GameTypeZcNone:
            return @"足彩";
        case GameTypeZc14:
            return @"胜负彩";
        case GameTypeZc9:
            return @"任选九";
        case GameTypeZc4:
            return @"进球彩";
        case GameTypeZc6:
            return @"半全场";
            // 北京单场
        case GameTypeBdNone:
        case GameTypeBdRqspf:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            return @"北京单场";
            // 竞彩足球
        case GameTypeJcNone:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcGJ:
        case GameTypeJcGYJ:
        case GameTypeJcHt:
        case GameTypeJcSpf:
            return @"竞彩足球";
            // 竞彩篮球
        case GameTypeLcNone:
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            return @"竞彩篮球";
            
            // 高频彩
        case GameTypeSyydj:
            return @"十一运夺金";
        case GameTypeJxssc:
            return @"时时彩";
        case GameTypeKlsf:
            return @"快乐十分";
        case GameTypeJxsyxw:
            return @"11选5";
        case GameTypeNmgks:
            return @"快3";
        case GameTypeHljsyxw:
            return @"新11选5";
        case GameTypeSdpks:
            return @"扑克3";
        default:
            return @"其他彩种";
    }
}

inline static NSString *dp_GameTypeLastName(GameTypeId gameType) {
    return @"";
}

inline static NSString *dp_GameTypeFullName(GameTypeId gameType) {
    switch (gameType) {
        // 数字彩
        case GameTypeSd:
            return @"福彩3D";
        case GameTypeSsq:
            return @"双色球";
        case GameTypeQlc:
            return @"七乐彩";
        case GameTypeDlt:
            return @"大乐透";
        case GameTypePs:
            return @"排列三";
        case GameTypePw:
            return @"排列五";
        case GameTypeQxc:
            return @"七星彩";
        case GameTypeHdsyxw:
            return @"华东11选5";
        case GameTypeDfljy:
            return @"东方6+1";
        case GameTypeZjtcljy:
            return @"浙江体彩6+1";
        case GameTypeTc22x5:
            return @"22选5";
        // 足彩
        case GameTypeZcNone:
            return @"足彩";
        case GameTypeZc14:
            return @"胜负彩";
        case GameTypeZc9:
            return @"任选九";
        case GameTypeZc4:
            return @"进球彩";
        case GameTypeZc6:
            return @"半全场";
        // 北京单场
        case GameTypeBdNone:
            return @"单场";
        case GameTypeBdRqspf:
            return @"单场胜平负";
        case GameTypeBdSxds:
            return @"单场上下单双";
        case GameTypeBdZjq:
            return @"单场总进球";
        case GameTypeBdBf:
            return @"单场比分";
        case GameTypeBdBqc:
            return @"单场半全场";
        case GameTypeBdSf:
            return @"单场胜负";
        // 竞彩足球
        case GameTypeJcNone:
            return @"竞彩";
        case GameTypeJcRqspf:
            return @"竞彩让球胜平负";
        case GameTypeJcBf:
            return @"竞彩比分";
        case GameTypeJcZjq:
            return @"竞彩总进球";
        case GameTypeJcBqc:
            return @"竞彩半全场";
        case GameTypeJcGJ:
            return @"竞彩冠军";
        case GameTypeJcGYJ:
            return @"竞彩冠亚军";
        case GameTypeJcHt:
            return @"竞彩混投";
        case GameTypeJcSpf:
            return @"竞彩胜平负";
        // 竞彩篮球
        case GameTypeLcNone:
            return @"篮彩";
        case GameTypeLcSf:
            return @"篮彩胜负";
        case GameTypeLcRfsf:
            return @"篮彩让分胜负";
        case GameTypeLcSfc:
            return @"篮彩胜分差";
        case GameTypeLcDxf:
            return @"篮彩大小分";
        case GameTypeLcHt:
            return @"篮彩混投";
        // 高频彩
        case GameTypeSyydj:
            return @"十一运夺金";
        case GameTypeJxssc:
            return @"时时彩";
        case GameTypeKlsf:
            return @"快乐十分";
        case GameTypeJxsyxw:
            return @"11选5";
        case GameTypeNmgks:
            return @"快3";
        case GameTypeHljsyxw:
            return @"新11选5";
        case GameTypeSdpks:
            return @"扑克3";
        default:
            return @"其他彩种";
    }
}

#pragma mark -

// 竞彩足球
static const NSString *dp_TransferOptionNameJcSpf[] =
{
    @"胜",
    @"平",
    @"负",
};
static const NSString *dp_TransferOptionNameJcZjq[] =
{
    @"0球",
    @"1球",
    @"2球",
    @"3球",
    @"4球",
    @"5球",
    @"6球",
    @"7+球",
};
static const NSString *dp_TransferOptionNameJcRqspf[] =
{
    @"让球胜",
    @"让球平",
    @"让球负",
};
static const NSString *dp_TransferOptionNameJcBqc[] =
{
    @"胜胜",
    @"胜平",
    @"胜负",
    @"平胜",
    @"平平",
    @"平负",
    @"负胜",
    @"负平",
    @"负负",
};
static const NSString *dp_TransferOptionNameJcBf[] =
{
    @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
    @"0:0", @"1:1", @"2:2", @"3:3", @"平其他",
    @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"0:5", @"1:5", @"2:5", @"负其他",
};

// 篮球竞彩
static const NSString *dp_TransferOptionNameLcSf[] =
{
    @"主负",
    @"主胜",
};
static const NSString *dp_TransferOptionNameLcRqsf[] =
{
    @"让分主负",
    @"让分主胜",
};
static const NSString *dp_TransferOptionNameLcSfc[] =
{
    @"客胜1-5", @"客胜6-10", @"客胜11-15", @"客胜16-20", @"客胜21-25", @"客胜26+",
    @"主胜1-5", @"主胜6-10", @"主胜11-15", @"主胜16-20", @"主胜21-25", @"主胜26+",
};
static const NSString *dp_TransferOptionNameLcDxf[] =
{
    @"大分",
    @"小分",
};

#endif  /* __DACAIPROJECT_GAMETYPEENUM_H__ */
