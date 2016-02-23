//
//  DPPksBuyViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleNotify.h"
#import "DPToast.h"


typedef NS_ENUM(NSInteger, PksGameIndex) {
    PksGameIndexBaoxuan,
    PksGameIndexDuizi,
    PksGameIndexBaozi,
    PksGameIndexTonghua,
    PksGameIndexShunzi,
    PksGameIndexTonghuashun,
    PksGameIndexRenxuan1,
    PksGameIndexRenxuan2,
    PksGameIndexRenxuan3,
    PksGameIndexRenxuan4,
    PksGameIndexRenxuan5,
    PksGameIndexRenxuan6,
};


@interface DPPksBuyViewController : UIViewController <ModuleNotify>

@property (nonatomic, assign) NSInteger targetIndex;
@property(nonatomic,assign)BOOL isTransfer;//从中转页面进
@property (nonatomic, assign) PksGameIndex gameIndex;



@end
