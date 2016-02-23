//
//  DPRechargeBankCell.m
//  DacaiProject
//
//  Created by sxf on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRechargeBankCell.h"
#import "DPImageLabel.h"
#import "DPVerifyUtilities.h"
@implementation DPRechargeBankCell
@synthesize infoLabel = _infoLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self buildLayout];
    }
    return self;
}
- (void)buildLayout {
    UIView *contentView = self.contentView;
    UIView *backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    backView.layer.borderColor = UIColorFromRGB(0xdad69c).CGColor;
    backView.layer.borderWidth = 0.5;
    [contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@33);
    }];
    [contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(8);
        make.right.equalTo(backView).offset(-8);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    UIImageView *arrowView=[[UIImageView alloc] init];
    arrowView.image=dp_ResultImage(@"arrow_right.png");
    arrowView.backgroundColor=[UIColor clearColor];
    [backView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-8);
        make.centerY.equalTo(backView);
        
    }];
}
- (TTTAttributedLabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[TTTAttributedLabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = [UIColor dp_flatBlackColor];
        _infoLabel.font = [UIFont dp_systemFontOfSize:14];
        _infoLabel.userInteractionEnabled=NO;
    }
    return _infoLabel;
}
- (void)setInfoLabelText:(NSString *)bankName  banktype:(NSString *)bankType number:(NSString *)number {
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（ %@ ）尾号：%@", bankName, bankType,number]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x333333) CGColor] range:NSMakeRange(0, bankName.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xb2afa8) CGColor] range:NSMakeRange(bankName.length, hintString1.length - bankName.length)];
    [self.infoLabel setText:hintString1];
}

@end

@implementation DPRechargeAddCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self.contentView;
    UIView *backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    backView.layer.borderColor = UIColorFromRGB(0xdad69c).CGColor;
    backView.layer.borderWidth = 0.5;
    [contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(10);
        make.height.equalTo(@33);
    }];
    DPImageLabel *_rengouLabel = [[DPImageLabel alloc] init];
    _rengouLabel.imagePosition = DPImagePositionLeft;
    _rengouLabel.font = [UIFont dp_systemFontOfSize:13.0];
    _rengouLabel.backgroundColor = [UIColor clearColor];
    _rengouLabel.textColor = UIColorFromRGB(0x333333);
    _rengouLabel.text = @"使用新的银行卡号";
    _rengouLabel.image = dp_AccountImage(@"addbank.png");
    [contentView addSubview:_rengouLabel];
    [_rengouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(8);
        make.right.equalTo(backView).offset(-8);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
}

@end

@implementation DPRechargeOtherCell
@synthesize rechargeImageView = _rechargeImageView;
@synthesize topLabel = _topLabel;
@synthesize bottomLabel = _bottomLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self buildLayout];
    }
    return self;
}
- (void)buildLayout {
    UIView *contentView = self.contentView;
    UIView *backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    //    backView.layer.borderColor=UIColorFromRGB(0xdad69c).CGColor;
    //    backView.layer.borderWidth=0.5;
    [contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [backView addSubview:self.rechargeImageView];
    [backView addSubview:self.topLabel];
    [backView addSubview:self.bottomLabel];
    [self.rechargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(15);
        make.width.equalTo(@70);
        make.centerY.equalTo(backView);
        make.height.equalTo(@33.5);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rechargeImageView.mas_right).offset(5);
        make.right.equalTo(backView).offset(-5);
        make.top.equalTo(backView).offset(10);
        make.height.equalTo(@20);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel);
        make.width.equalTo(self.topLabel);
        make.top.equalTo(self.topLabel.mas_bottom).offset(-2);
        make.height.equalTo(@20);
    }];

    UIView *leftLine = [UIView dp_viewWithColor:UIColorFromRGB(0xdad6c9)];
    UIView *rightLine = [UIView dp_viewWithColor:UIColorFromRGB(0xdad6c9)];
    UIView *bottomLine = [UIView dp_viewWithColor:UIColorFromRGB(0xdad6c9)];
    [backView addSubview:leftLine];
    [backView addSubview:rightLine];
    [backView addSubview:bottomLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(backView);
    }];
    
    UIImageView *arrowView=[[UIImageView alloc] init];
    arrowView.image=dp_ResultImage(@"arrow_right.png");
    arrowView.backgroundColor=[UIColor clearColor];
    [backView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-8);
        make.centerY.equalTo(backView);
      
    }];
}

- (UIImageView *)rechargeImageView {
    if (_rechargeImageView == nil) {
        _rechargeImageView = [[UIImageView alloc] init];
        _rechargeImageView.backgroundColor = [UIColor clearColor];
    }
    return _rechargeImageView;
}
- (UILabel *)topLabel {
    if (_topLabel == nil) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.textAlignment = NSTextAlignmentLeft;
        _topLabel.textColor = UIColorFromRGB(0x333333);
        _topLabel.font = [UIFont dp_lightSystemFontOfSize:15];
    }
    return _topLabel;
}
- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.textColor = UIColorFromRGB(0x999999);
        _bottomLabel.font = [UIFont dp_lightSystemFontOfSize:12];
    }
    return _bottomLabel;
}

@end


@implementation DPRechargeLLNoBankCell
@synthesize bankTextfield=_bankTextfield;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self buildLayout];
    }
    return self;
}
- (void)buildLayout {
    UIView *contentView=self.contentView;
       
        UILabel *label2 = [[UILabel alloc] init];
        label2.backgroundColor = [UIColor clearColor];
        label2.text = @"银行卡快捷支付";
        label2.textColor = UIColorFromRGB(0x333333);
        label2.font = [UIFont dp_systemFontOfSize:14.0];
        [contentView addSubview:label2];
    
        UIView *bankBackView = [UIView dp_viewWithColor:[UIColor whiteColor]];
        bankBackView.layer.cornerRadius = 3;
        bankBackView.layer.borderColor = UIColorFromRGB(0xc8c3b0).CGColor;
        bankBackView.layer.borderWidth = 0.5;
        [contentView addSubview:bankBackView];
        [contentView addSubview:self.bankTextfield];
    
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@20);
        }];
        [bankBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label2.mas_bottom).offset(5);
            make.height.equalTo(@40);
        }];
        [self.bankTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bankBackView).offset(10);
            make.right.equalTo(bankBackView).offset(-10);
            make.top.equalTo(bankBackView).offset(5);
            make.height.equalTo(@30);
        }];
        UIButton *loginButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
            [button addTarget:self action:@selector(pvt_onNext) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"下一步" forState:UIControlStateNormal];
            button.layer.cornerRadius=2;
            [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
            button;
        });
        [contentView addSubview:loginButton];
       [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankBackView.mas_bottom).offset(10);
            make.left.equalTo(bankBackView);
            make.right.equalTo(bankBackView);
            make.height.equalTo(@40);
        }];
}
- (UITextField *)bankTextfield {
    if (_bankTextfield == nil) {
        _bankTextfield = [[UITextField alloc] init];
        _bankTextfield.placeholder = @"请输入银行卡号";
        _bankTextfield.backgroundColor = [UIColor clearColor];
        _bankTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _bankTextfield.font = [UIFont dp_systemFontOfSize:16];
        _bankTextfield.delegate=self;
        _bankTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankTextfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _bankTextfield;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 
    if (self.delegate&&[self.delegate respondsToSelector:@selector(bankInfoTextField:)]) {
        [self.delegate bankInfoTextField:textField];
    }
    return YES;

}
-(void)pvt_onNext{
    
    if (self.delegate&&([self.delegate respondsToSelector:@selector(rechargeLLNoBallCellNext:)])) {
        [self.delegate rechargeLLNoBallCellNext:self];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    return YES;
}
@end

