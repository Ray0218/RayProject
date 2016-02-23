//
//  DPRechargeBankCell.h
//  DacaiProject
//
//  Created by sxf on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
@protocol DPRechargeCellDelegate;
@interface DPRechargeBankCell : UITableViewCell

@property(nonatomic,strong,readonly)TTTAttributedLabel *infoLabel;
-(void)setInfoLabelText:(NSString *)bankName  banktype:(NSString *)bankType  number:(NSString *)number;
@end

@interface DPRechargeAddCell : UITableViewCell

@end

@interface DPRechargeOtherCell : UITableViewCell

@property(nonatomic,strong,readonly)UIImageView *rechargeImageView;
@property(nonatomic,strong,readonly)UILabel *topLabel,*bottomLabel;

@end

@interface DPRechargeLLNoBankCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,assign)id<DPRechargeCellDelegate>delegate;
@property (nonatomic, strong, readonly) UITextField *bankTextfield;
@end

@protocol DPRechargeCellDelegate <NSObject>

@optional
-(void)rechargeLLNoBallCellNext:(DPRechargeLLNoBankCell *)cell;
-(void)bankInfoTextField:(UITextField *)textField;
@end