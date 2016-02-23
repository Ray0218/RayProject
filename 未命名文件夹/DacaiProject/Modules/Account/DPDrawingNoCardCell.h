//
//  DPDrawingNoCardCell.h
//  DacaiProject
//
//  Created by sxf on 14-9-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<TTTAttributedLabel/TTTAttributedLabel.h>
@protocol DPDrawingCellDelegate;
//未实名认证
@interface DPDrawingNoCardCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong,readonly)UITextField *accNameTf,*cardIdTf;
@property(nonatomic,assign)id<DPDrawingCellDelegate>delegate;
@end
//实名认证过
@interface DPDrawingCardCell : UITableViewCell

@property(nonatomic,strong,readonly)UILabel *acceNameLabel,*cardNameLabel;
@end
//银行信息
@interface DPDrawingNoBankCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong,readonly)UITextField *bankNumberTf;
@property(nonatomic,strong,readonly)UILabel *bankNameLabel;
@property(nonatomic,strong)UILabel *yueLabel;
@property(nonatomic,assign)id<DPDrawingCellDelegate>delegate;
@end
//提款金额
@interface DPDrawingMoneyCell : UITableViewCell<UITextFieldDelegate>
//@property(nonatomic,strong,readonly)TTTAttributedLabel *moneyLabel;
@property(nonatomic,strong,readonly)UITextField *drawMoneyTf;
@property(nonatomic,assign)id<DPDrawingCellDelegate>delegate;

//-(void)setMoneyLabelText:(int)shouxuMoney totalMoney:(int)totalMoney;
@end

@interface DPDrawingExMoneyCell : UITableViewCell
@property(nonatomic,strong,readonly)TTTAttributedLabel *moneyLabel;
@property(nonatomic,assign)id<DPDrawingCellDelegate>delegate;
- (void)setMoneyLabelText:(int)shouxuMoney totalMoney:(int)totalMoney;
@end
//提款密码
@interface DPDrawingPassWordCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong,readonly)UITextField *drawPassWordTf;
@property(nonatomic,assign)id<DPDrawingCellDelegate>delegate;
@end
//提款密码修改
@interface DPDrawingChangePassWordCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong,readonly)UITextField*drawPassWordTf,*sureDrawPassWordTf;
@property(nonatomic,assign)id<DPDrawingCellDelegate>delegate;
@end

@interface DPDrawingBankCell : UITableViewCell
@property(nonatomic,strong,readonly)UIImageView *bankImageView;
@property(nonatomic,strong,readonly)UILabel *bankNameLabel;
@property(nonatomic,strong,readonly)UILabel *bankNumberLabel;
@end
@interface DPDrawingAddBankCell : UITableViewCell
@property(nonatomic,assign)id<DPDrawingCellDelegate>delegate;
@property(nonatomic,strong)UILabel *yueLabel;
@end


@protocol DPDrawingCellDelegate <NSObject>

@optional
-(void)bankNameFromBankNumber:(DPDrawingNoBankCell *)cell;//获得银行卡信息
-(void)drawingMoneyCell:(DPDrawingMoneyCell *)cell;//获得手续费
-(void)drawingPassWordCell:(DPDrawingPassWordCell *)cell;
-(void)drawingChangePassWordCell:(DPDrawingChangePassWordCell *)cell;
-(void)drawingNoCardIdCell:(DPDrawingNoCardCell *)cell;
-(void)textFieldBeginCell:(UITableViewCell *)cell
                texfField:(UITextField *)texfField
           isScrollBottom:(BOOL)scrollBottom;//是否滚动到底部
- (void)drawingMoneyButtonClick;
-(void)drawingAddBank:(DPDrawingAddBankCell *)cell;
@end