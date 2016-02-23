//
//  DPJclqTransferVC.h
//  DacaiProject
//
//  Created by sxf on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAppParser.h"

@interface DPJclqTransferVC : UIViewController
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) int cmdId;
@property (nonatomic, strong) TTTAttributedLabel *bottomLabel;
@property (nonatomic, strong) TTTAttributedLabel *bottomBoundLabel;
@end
