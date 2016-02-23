//
//  DPJczqOptimizeViewControl.h
//  DacaiProject
//
//  Created by Ray on 14/11/10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDHTMLLabel/MDHTMLLabel.h>

@interface DPJczqOptimizeViewControl : UIViewController

@property (nonatomic, strong) MDHTMLLabel *bottomLabel; //实际金额
@property (nonatomic, strong) MDHTMLLabel *bottomBoundLabel; //奖金范围
@property (nonatomic, strong, readonly) UITextField *moneyTextField; //预算金额field
@property (nonatomic, strong, readonly) UITextField *multipleField;//倍数

@property (nonatomic, strong, readonly) UILabel *passModeLabel; //过关方式

@property (nonatomic, assign) GameTypeId gameType;
@property(nonatomic,copy)NSString *gameTypeText;
@end
