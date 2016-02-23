//
//  DPAccountViewControllers.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleProtocol.h"

@interface DPLoginViewController : UIViewController

@property (nonatomic, copy) void(^finishBlock)(void);
@property (nonatomic, assign) BOOL homeEntry;

- (void)willPanHide;

@end

@interface DPRegisterViewController : UIViewController

@end

@interface DPRecoverPwdViewController : UIViewController

@end

@interface DPCompleteDataVC : UIViewController
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, assign) int authoType;
@end

@interface DPModifyNameVC : UIViewController
@property (nonatomic, assign)BOOL canModifyPassword;
@end


// 操作成功提示页面的基类
@interface DPSuccessDoneVC : UIViewController
@property (nonatomic, strong) UILabel     *promptLabel; // 提示语
@property (nonatomic, strong) UIButton    *commitBtn; // 下一步按钮文字
- (void)leftNavItemClick; // 回退
- (void)dp_commitBtnClick; // 下一步按钮方法

@end
