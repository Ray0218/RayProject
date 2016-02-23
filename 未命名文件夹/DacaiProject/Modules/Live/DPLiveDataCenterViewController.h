//
//  DPLiveDataCenterViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "AXStretchableHeaderTabViewController.h"


@interface DPLiveDataCenterViewController : AXStretchableHeaderTabViewController

/**
 *  初始化数据中心页面
 *
 *  @param type       彩种类型，足球传入GameTypeZcNone 篮球传入GameTypeLcNone
 *  @param  index    进入页面的默认位置（足球0~4，篮球 0~3）
 * @param  matchId    赛事ID
 */

-(instancetype)initWithGameType:(GameTypeId)type withDefaultIndex:(NSInteger)index withMatchId:(NSInteger)matchId;


@end


