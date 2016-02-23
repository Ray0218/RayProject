//
//  DPSecurityAccNameVC.h
//  DacaiProject
//
//  Created by sxf on 14-8-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleProtocol.h"
#import "DPVerifyUtilities.h"
#import <MSWeakTimer/MSWeakTimer.h>
#import "DPAccountViewControllers.h"
//实名认证
@interface DPSecurityAccNameVC : UIViewController

@end

//手机认证
@interface DPSecurityPhoneVC : UIViewController
@property(nonatomic,assign)NSInteger timeSpace;
@property (nonatomic, strong) MSWeakTimer *timer;
@end
//修改手机
@interface DPSecurityChangePhoneVC : UIViewController
@property(nonatomic,assign)NSInteger timeSpace;
@property (nonatomic, strong) MSWeakTimer *timer;
@end

//忘记密码
typedef enum {
    kForgetTypeDefault = 0,     //默认为三个textfield
    kForgetTypeLoginPSW,        //忘记密码(首页进入)
    kForgetTypeScenterPSW,      //忘记密码（安全中心进入）
    kForgetTypeTakeMoneyPSW    //忘记提款密码
} kForgetType;

@interface DPForegetPassWordVC : UIViewController
@property (nonatomic, assign) kForgetType forgetType; // 界面类型
@property(nonatomic,assign)NSInteger timeSpace;
@property (nonatomic, strong) MSWeakTimer *timer;
@end

@interface DPSetPassWordVC : UIViewController

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *code;
@property(nonatomic, assign) BOOL isMoneyPassword; // 是否为提款密码

@end

@interface DPSetPassWordSuccessVC : DPSuccessDoneVC

@end