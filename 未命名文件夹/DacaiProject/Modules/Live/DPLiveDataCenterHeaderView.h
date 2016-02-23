//
//  DPLiveDataCenterHeaderView.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "AXStretchableHeaderView.h"

#define kDataCenterHeaderTabHeight      40.0f
#define kDataCenterHeaderMaxHeight      130.0f
#define kDataCenterHeaderMinHeight      45.0f

@interface DPLiveDataCenterHeaderView : AXStretchableHeaderView

-(instancetype)initWithGameType:(GameTypeId)gameType ;
@end
