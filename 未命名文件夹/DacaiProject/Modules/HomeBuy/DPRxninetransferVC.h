//
//  DPRxninetransferVC.h
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPAppParser.h"

@protocol DPRxninetransferVCDelegate ;


@interface DPRxninetransferVC : UIViewController
@property (nonatomic, assign) GameTypeId gameType;
@property(nonatomic,strong) NSMutableArray *selectedAry;
@property (nonatomic, weak) id<DPRxninetransferVCDelegate> delegate;
@end

@protocol DPRxninetransferVCDelegate <NSObject>

-(void)updateArrayWithIndex:(int)index withSelect:(NSString*)selectOrNot;

@end