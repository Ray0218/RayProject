//
//  DPJczqTransferViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAppParser.h"
#import <MDHTMLLabel/MDHTMLLabel.h>

@interface DPJczqTransferViewController : UIViewController

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong) TTTAttributedLabel *bottomLabel;
@property (nonatomic, strong) MDHTMLLabel *bottomBoundLabel;

@end
