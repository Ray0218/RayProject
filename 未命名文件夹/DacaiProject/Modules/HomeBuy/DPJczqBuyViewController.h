//
//  DPJczqBuyViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleProtocol.h"
#import "DPSportFilterView.h"

@interface DPJczqBuyViewController : UIViewController

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong) DPSportFilterView *filterView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSMutableDictionary *commands;
@property (nonatomic, assign) NSInteger isProject;
@property (nonatomic, assign) NSInteger gameIndex;

@end
