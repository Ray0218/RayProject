//
//  DPJclqBuyViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleProtocol.h"
#import "DPSportFilterView.h"

@interface DPJclqBuyViewController : UIViewController
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong) UIView          * coverView;
@property(nonatomic,strong)NSMutableDictionary *commands;
@property(nonatomic,assign)BOOL  isProject;//0:首页  1:方案详情
@property (nonatomic, assign) NSInteger gameIndex;

@end
