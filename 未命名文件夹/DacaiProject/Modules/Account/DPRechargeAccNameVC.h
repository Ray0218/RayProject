//
//  DPRechargeAccNameVC.h
//  DacaiProject
//
//  Created by sxf on 14-9-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPRechargeAccNameVC : UIViewController

@property (nonatomic, strong, readonly) UILabel *bankName, *bankNumber;
@property (nonatomic, strong, readonly) UIImageView *bankView;

@property(nonatomic,assign)NSInteger amt;
@end
