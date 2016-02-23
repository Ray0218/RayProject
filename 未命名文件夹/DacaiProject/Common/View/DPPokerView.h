//
//  DPPokerView.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//

#import <UIKit/UIKit.h>

@interface DPPokerView : UIView

@property (nonatomic, assign) NSInteger type;   // 花色.  1:方块, 2:红桃, 3:梅花, 4:黑桃, 5:?(未开奖状态)
@property (nonatomic, assign) NSInteger number; // 奖号.  A~K

@end
