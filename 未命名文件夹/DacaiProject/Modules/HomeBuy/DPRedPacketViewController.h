//
//  DPRedPacketViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kEntryTypeDefault = 0,  // 合买设置 or 中转界面
    kEntryTypeTogetherBuy,  // 合买大厅
    kEntryTypeProject,      // 方案详情
    kEntryTypeFollow        // 智能追号
} kEntryType;

@protocol DPRedPacketViewControllerDelegate;
@interface DPRedPacketViewController : UIViewController
@property (nonatomic, weak) id<DPRedPacketViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *gameTypeText;  // 彩种名
@property (nonatomic, strong) NSString *gameNameText;  // 期号
@property (nonatomic, assign) NSInteger projectAmount; // 方案金额
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) int buyType;    //代购：1    合买：2
@property (nonatomic, assign) int rengouType; //1 认购 2：保底
@property (nonatomic, assign) int projectid;
@property (nonatomic, assign) kEntryType entryType;
@property (nonatomic, assign) BOOL isredPacket; //判断当前是否有红包

@end

@protocol DPRedPacketViewControllerDelegate <NSObject>
@required
- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType;
@end