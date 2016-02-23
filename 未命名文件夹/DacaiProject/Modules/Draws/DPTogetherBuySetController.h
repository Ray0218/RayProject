//
//  DPTogetherBuySetController.h
//  DacaiProject
//
//  Created by jacknathan on 14-9-15.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  合买设置界面

#import <UIKit/UIKit.h>

@interface DPTogetherBuySetController : UIViewController

@property (nonatomic, assign)int sum; // 合计金额
@property(nonatomic,assign)GameTypeId  gameType;
//更新一下数据
- (void)refreshResData;
@end
