//
//  DPProjectDetailVC.h
//  DacaiProject
//
//  Created by sxf on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameWork.h"
#import "ModuleProtocol.h"
#import "DPProjectDetailSportTitleCell.h"
#import "DPprojectDetailSprotContentCell.h"
#import "DPProjectDetailContentUnknownCell.h"
typedef NS_ENUM(NSUInteger, DProjectSectionType) {
    DProjectSectionTypeHeader = 0,           // 头部
    DProjectSectionTypeMyOrder = 1,          // 我的订单
    DProjectSectionTypeWinningSituation = 2, // 过关情况
    DProjectSectionTypeProjectContent = 3,   // 方案内容
    DProjectSectionTypeFollowSchedule = 4,   // 追号进度
    DProjectSectionTypeOptimizeDetail = 5,   // 优化详情
};
@interface DPProjectDetailVC : UIViewController {
    CDoubleChromosphere *_CDInstance;
    CProjectInfo *_CpInstance;
    CSuperLotto *_CSLInstance;
    CLottery3D *_lottery3DInstance;
    CSevenLuck *_CSLLInstance;
    CPick3 *_Pl3Instance;
    CPick5 *_Pl5Instance;
    CSevenStar *_SsInstance;
    CJxsyxw *_CJXInstance;
    CQuickThree *_CQTInstance;
    CPokerThree *_CPTInstance;
    CLotteryJczq *_CJCzqInstance;
    CLotteryBd *_CJCBdInstance;
    CLotteryJclq *_CJCLcInstance;
    CLotteryZc9 *_CLZ9Instance;
    CLotteryZc14 *_CLZ14Instance;
}
- (void)projectDetailPriojectId:(int)projectId//方案id
                       gameType:(GameTypeId)lotteryGameType//彩种类型
                        pdBuyId:(int)pdBuyId //方案购买类型
                       gameName:(int)gameName; //期号

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) int gameName;       // 方案期号
@property (nonatomic, assign) int projectId;      // 方案id
@property (nonatomic, assign) int ticketStatusId; // 出票状态
@property (nonatomic, assign) BOOL isVisible;     // 方案状态
@property (nonatomic, assign) int contentType;    // 方案内容  0:普通 1:未补全 2:单式上传
@property (nonatomic, assign) int ProjectBuyId;
@property (nonatomic, assign) int ProjectStatusId;
@property (nonatomic, assign) int sysProcessStepId;
@property (nonatomic, strong) UILabel *kerengouLabel; // 可认购
@property (nonatomic, assign) int kerengouMoney;      // 可认购金钱
@property (nonatomic, assign) int responseCount;      // 数据请求响应次数
@property (nonatomic, assign) NSInteger purchaseOrderId;//方案id
@property (nonatomic, assign) BOOL backToRefresh;

@end
