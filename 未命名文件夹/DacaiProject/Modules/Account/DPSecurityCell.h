//
//  DPSecurityCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, securityIndex) {
    securityIndexName,// 实名立即认证
    securityIndexPhone,//手机立即认证
    securityIndexlogin,//登录提交
    securityIndexMoney,//提款提交
     securityIndexChangePhone,//修改手机
    securityIndexForgetPassword ,//忘记密码
    securityIndexForgetTakeMoneyPSW //忘记提款密码
};
@protocol DPsecurityCellDelegate;
@interface DPSecurityCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,assign)id<DPsecurityCellDelegate>delegate;


@property(nonatomic,strong)UILabel *passLabelOld,*passLabelNew,*passlabelSure;//密码，提款标题
@property(nonatomic,strong)UITextField *passTextfieldOld,*passTextFieldNew,*passTextFieldSure,*passTextfieldMoneyOld,*passTextFieldMoneyNew,*passTextFieldMoneySure;
@property(nonatomic,assign)BOOL moneyPass;
@property(nonatomic,strong)UILabel *usenameLabel,*accuNamelabel,*idCardlabel,*iphoneLabel;
@property(nonatomic,strong)UIView *fieldPassView;//修改密码背景
@property(nonatomic,assign)BOOL isdrawing;

-(void)createView:(BOOL)renzhengType indexPath:(NSIndexPath *)path;
-(void)upDateUIForDrawing;
@end

@protocol DPsecurityCellDelegate <NSObject>

//button事件
-(void)buttonResponerForCell:(DPSecurityCell *)cell  butttonIndex:(int)buttonIndex;
@end
