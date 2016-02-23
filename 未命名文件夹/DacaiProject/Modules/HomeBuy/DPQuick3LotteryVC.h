//
//  DPQuick3LotteryVC.h
//  DacaiProject
//
//  Created by sxf on 14-7-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalTicketsBaseVC.h"
#import "ModuleProtocol.h"
#import "DPToast.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "FLAnimatedImageView.h"
@interface DPQuick3LotteryVC : UIViewController <ModuleNotify>
{
    FLAnimatedImageView *_flImageview1;
    FLAnimatedImageView *_flImageview2;
    FLAnimatedImageView *_flImageview3;
}
@property(nonatomic,assign)NSInteger indexpathRow;
@property(nonatomic,strong)UISegmentedControl *segcontrol;
@property(nonatomic,assign)NSInteger chouMaType;
@property (nonatomic, strong, readonly) NSLayoutConstraint *tableConstraint;
@property (nonatomic, assign) BOOL showHistory;
@property(nonatomic,strong,readonly)FLAnimatedImageView *flImageview1,*flImageview2,*flImageview3;
@property(nonatomic,assign)BOOL isTransfer;
@property (nonatomic, assign) KSType gameType;

@property(nonatomic,assign)NSInteger gameName;
//自选，修改
-(void)jumpToSelectPage:(NSInteger)row  gameType:(NSInteger)gameTypes;
@end;
