//
//  BetOrderSerializer.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject__BetOrderSerializer__
#define __DacaiProject__BetOrderSerializer__

#include <iostream>
#include <string>

using namespace std;

class CBetOrder {
public:
    int     m_GameTypeId;                   // 彩种ID
    string  m_UserToken;                    // 发单人token
    int     m_Quantity;                     // 注数
    int     m_Multiple;                     // 倍数
    int     m_SingleAmount;                 // 单注金额
    int     m_TotalAmount;                  // 总金额
    int     m_CommisionRate;                // 佣金比例, 1-10
    int     m_FirstBuyAmount;               // 发起认购金额
    int     m_FollowRightId;                // 用户跟单权限
    int     m_InitFillAmount;               // 初始保底金额
    bool    m_IsAllowCancelProjectBuy;      // false,  boolean 是否允许撤资
    int     m_ProjectAccessTypeId;          // 方案访问权限. 1:公开, 2:保密, 3:截止后公开, 4:跟单着公开
    int     m_ProjectBuyTypeId;             // 方案购买类型. 1:代购, 2:合买, 4:追号
    int     m_GameId;                       // 期号ID
    int     m_UserRedElpId;                 // 红包id
    string  m_GameName;                     // 期号名
    string  m_Ggtype;                       // 过关方式，逗号分隔. "1-1,2-1",
    string  m_ProjectBetTypeName;           // 方案投注方式名称，主要用于过关统计和合买大厅显示用
    string  m_BetDescription;               // 投注内容json字符串
    string  m_BetOrderNumbers;              // 投注场次  ",129362,129363,129365,"  各数字代表所选对阵的主键ID  注:前后要带','号
    string  m_PassTypeDescription;          // 投注过关描述, "2串1, 3串1"
    bool    m_IsFollow;                     // true,   boolean 是否追号
    int     m_FollowCount;                  // 追号几期 (追号即IsFollow=true情况下有效，未追号可不传)
    bool    m_IsWinedStop;                  // 是否中奖后停止 (追号即IsFollow=true情况下有效，未追号可不传)
    int     m_StopMoney;                    // 中N元后停止(追号即IsFollow=true情况下有效，未追号可不传)
    string  m_FollowMultiple;               // 智能追号倍数(追号即IsFollow=true情况下有效，未追号可不传). e.g."1,2,4,8"
    
protected:
    bool    m_IsUserCoin;                   // boolean 是否优先使用大彩币
    
public:
    CBetOrder();
    ~CBetOrder();
    
    string JSONStream();
};

#endif /* defined(__DacaiProject__BetOrderSerializer__) */
