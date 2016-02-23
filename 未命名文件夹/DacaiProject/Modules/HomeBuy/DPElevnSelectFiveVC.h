//
//  DPElevnSelectFiveVC.h
//  DacaiProject
//
//  Created by sxf on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalTicketsBaseVC.h"
#import "ModuleProtocol.h"
#import <MSWeakTimer/MSWeakTimer.h>
@interface DPElevnSelectFiveVC : UIViewController<ModuleNotify>

@property (nonatomic, assign) NSInteger targetIndex;
@property(nonatomic,strong)    UILabel *zhushuLabel;//注数
@property (nonatomic, assign) NSInteger timeSpace;                 //当前投注期的截止时间（秒）
@property(nonatomic,assign)BOOL isTransfer;//从中转页面进
@property(nonatomic,assign)NSInteger gameIndex;


//自选，修改
-(void)jumpToSelectPage:(int)row  gameType:(int)gameTypes;

@end
 