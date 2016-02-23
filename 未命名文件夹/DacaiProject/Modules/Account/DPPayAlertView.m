//
//  DPPayAlertView.m
//  DacaiProject
//
//  Created by sxf on 14/11/21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPPayAlertView.h"

@implementation DPPayAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)buildLayoutForEgLabelText:(NSString *)eglabelText
{
    
    self.backgroundColor=UIColorFromRGB(0xFFFFFF);
    
    UILabel* titleLabel =[self createLabelText:@"温馨提示" textFont:[UIFont dp_systemFontOfSize:14.0] textColor:[UIColor dp_flatRedColor] textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:titleLabel];
    UILabel* egLabel = [self createLabelText:@"由于微信支付方式必须为整数，故我们将对您的支付金额进位取整，多余的金额将会返还到您的大彩账户中" textFont:[UIFont dp_systemFontOfSize:12.0] textColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentLeft];
    egLabel.numberOfLines=0;
    [self addSubview:egLabel];
    [ titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@20);
        
    }];
    [egLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.9) ;
        make.centerX.equalTo(self.mas_centerX) ;
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@40);
    }];
    
    UIView *backView=[[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor] ;
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = UIColorFromRGB(0xDEDBD5).CGColor ;
    [self addSubview:backView];
    
    UILabel *payTitleLabel=[self createLabelText:@"支付金额" textFont:[UIFont dp_systemFontOfSize:14.0] textColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentCenter];
    [backView addSubview:payTitleLabel];
    [backView addSubview:self.payMoneyLabel];

    UILabel *backTitleLabel=[self createLabelText:@"返还金额" textFont:[UIFont dp_systemFontOfSize:14.0] textColor:[UIColor dp_flatBlackColor] textAlignment:NSTextAlignmentCenter];
    [backView addSubview:backTitleLabel];
    [backView addSubview:self.backMoneyLabel];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithRed:0.75 green:0.74 blue:0.72 alpha:1];
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:0.75 green:0.74 blue:0.72 alpha:1];
    [backView addSubview:line1];
    [backView addSubview:line2];

    [ backView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(40);
        make.top.equalTo(egLabel.mas_bottom).offset(10);
        make.height.equalTo(@60);
        
    }];

    [ payTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(backView);
        make.width.equalTo(@90);
        make.top.equalTo(backView);
        make.height.equalTo(@30);
        
    }];

    [ self.payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(payTitleLabel.mas_right).offset(10);
        make.right.equalTo(backView);
        make.top.equalTo(payTitleLabel);
        make.height.equalTo(@30);
        
    }];

    [ backTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(backView);
        make.width.equalTo(@90);
        make.top.equalTo(payTitleLabel.mas_bottom);
        make.height.equalTo(@30);
        
    }];
    [ self.backMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(backTitleLabel);
        make.bottom.equalTo(backTitleLabel);
        make.left.equalTo(self.payMoneyLabel);
        make.width.equalTo(self.payMoneyLabel);
        
    }];

    [ line1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.left.equalTo(backView);
        make.centerY.equalTo(backView);
        make.height.equalTo(@0.5);
        
    }];
    [ line2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(backTitleLabel.mas_right);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
        
    }];
    
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor dp_flatRedColor]];
    confirmButton.titleLabel.font =[UIFont dp_boldSystemFontOfSize:14.0];
//    [confirmButton setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pv_sure) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    cancleBtn.backgroundColor=[UIColor dp_flatRedColor];
    cancelButton.titleLabel.font =[UIFont dp_boldSystemFontOfSize:14.0];
    [cancelButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
//    [cancleBtn setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pv_cancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.75 green:0.74 blue:0.72 alpha:1];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(cancelButton.mas_top);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self.mas_centerX);
    }];

//    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10) ;
//        make.width.equalTo(@120);
//        make.top.equalTo(backView.mas_bottom).offset(12) ;
//         make.height.equalTo(@30);
//    }];
//    
//    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-10) ;
//        make.width.equalTo(@120);
//        make.top.equalTo(confirmButton);
//        make.height.equalTo(@30);
//    }];
    
    
}
-(UILabel *)payMoneyLabel{
    if (_payMoneyLabel==nil) {
        _payMoneyLabel=[[UILabel alloc] init];
        _payMoneyLabel.backgroundColor=[UIColor clearColor];
        _payMoneyLabel.textColor=[UIColor dp_flatBlackColor];
        _payMoneyLabel.textAlignment=NSTextAlignmentLeft;
        _payMoneyLabel.font=[UIFont dp_regularArialOfSize:14.0];
    }
    return _payMoneyLabel;

}
-(UILabel *)backMoneyLabel{
    if (_backMoneyLabel==nil) {
        _backMoneyLabel=[[UILabel alloc] init];
        _backMoneyLabel.backgroundColor=[UIColor clearColor];
        _backMoneyLabel.textColor=[UIColor dp_flatBlackColor];
        _backMoneyLabel.textAlignment=NSTextAlignmentLeft;
        _backMoneyLabel.font=[UIFont dp_regularArialOfSize:14.0];
    }
    return _backMoneyLabel;
    
}
-(UILabel *)createLabelText:(NSString *)text  textFont:(UIFont *)textFont  textColor:(UIColor *)textColor  textAlignment:(NSTextAlignment )textAlignment{
    UILabel *label=[[UILabel alloc] init];
    label.text = text ;
    label.font=textFont;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=textAlignment;
    label.textColor=textColor;
    return label;
}
- (void)pv_cancle {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(payAlertViewCancle:)]) {
        [self.delegate payAlertViewCancle:self];
    }
}
- (void)pv_sure {
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(payAlertViewSure:)]) {
            [self.delegate payAlertViewSure:self];
        }
}
@end
