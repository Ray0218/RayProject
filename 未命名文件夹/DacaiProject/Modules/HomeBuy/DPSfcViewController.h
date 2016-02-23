//
//  DPSfcViewController.h
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAppParser.h"
@class DPSportFilterView;
@interface DPSfcViewController : UIViewController

@property (nonatomic, assign) GameTypeId         gameType;
@property(nonatomic,strong)NSMutableArray *indexPathAry;
@end
