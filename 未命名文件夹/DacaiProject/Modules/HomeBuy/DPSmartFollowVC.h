//
//  DPSmartFollowVC.h
//  DacaiProject
//
//  Created by jacknathan on 14-9-28.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    smartZhGameTypePKS,
    smartZhGameTypeK3,
    smartZhGameType11X5
    
} smartZhGameType;

@interface DPSmartFollowVC : UIViewController

@property (assign, nonatomic) smartZhGameType gameType;
-(void)createDataObject;
@end

