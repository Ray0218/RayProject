//
//  DPRechargeToPayVC.h
//  DacaiProject
//
//  Created by sxf on 14/11/13.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPRechargeToPayVC : UIViewController

@property(nonatomic,assign)GameTypeId gameId;//彩种id
@property(nonatomic,assign) NSInteger gameName;//彩种期号
@property(nonatomic,copy)NSString *needAmt;//还要支付金额
@property(nonatomic,copy)NSString *realAmt;//账户余额
@property(nonatomic,assign)NSInteger pid;//订单号
@property(nonatomic,copy)NSString *purchaseOrderToken;//token
@property(nonatomic,assign)NSInteger projectId;
@end
