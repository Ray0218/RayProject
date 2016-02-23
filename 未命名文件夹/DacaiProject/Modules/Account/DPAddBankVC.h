//
//  DPAddBankVC.h
//  DacaiProject
//
//  Created by sxf on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPAddBankVC : UIViewController

@property(nonatomic,strong)NSString   *moneyString;

-(void)setNameText:(NSString*)nameText   cardIdText:(NSString *)cardIdText;
@end
