//
//  DPDrawingNoCardCell.m
//  DacaiProject
//
//  Created by sxf on 14-9-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#import "DPWebViewController.h"
#import "DPDrawingNoCardCell.h"
#import "DPVerifyUtilities.h"
@implementation DPDrawingNoCardCell
@synthesize accNameTf = _accNameTf;
@synthesize cardIdTf = _cardIdTf;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        self.backgroundColor = [UIColor clearColor];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = dp_AccountImage(@"drawing01.png");
        imageView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:imageView];
        UILabel *label1 = [self createlabel:@"身份证和银行卡是领奖的重要凭证，请立即绑定" titleColor:UIColorFromRGB(0xb35b5b) titleFont:[UIFont dp_systemFontOfSize:11.0] alignment:NSTextAlignmentLeft];
        UILabel *label2 = [self createlabel:@"姓    名:" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        UILabel *label3 = [self createlabel:@"身 份 证:" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        [contentView addSubview:label1];
        [contentView addSubview:label2];
        [contentView addSubview:label3];
        UIView *backView1 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView1.layer.cornerRadius = 5;
        backView1.layer.borderWidth = 0.5;
        backView1.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView1];
        UIView *backView2 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView2.layer.cornerRadius = 5;
        backView2.layer.borderWidth = 0.5;
        backView2.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView2];
        [backView1 addSubview:self.accNameTf];
        [backView2 addSubview:self.cardIdTf];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(14);
             make.width.equalTo(@15.5);
            make.top.equalTo(contentView).offset(9);
            make.height.equalTo(@15.5);
        }];

        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(2);
             make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(contentView).offset(7);
            make.height.equalTo(@20);
        }];

        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@55);
            make.top.equalTo(label1.mas_bottom).offset(10);
            make.height.equalTo(@36);
        }];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2);
            make.width.equalTo(@55);
            make.top.equalTo(label2.mas_bottom).offset(8);
            make.height.equalTo(@36);
        }];
        [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label2);
            make.bottom.equalTo(label2);
        }];
        [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label3.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label3);
            make.bottom.equalTo(label3);
        }];
        [self.accNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView1).offset(10);
            make.right.equalTo(backView1).offset(-10);
            make.top.equalTo(label2);
            make.bottom.equalTo(label2);
        }];
        [self.cardIdTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView2).offset(10);
            make.right.equalTo(backView2).offset(-10);
            make.top.equalTo(label3);
            make.bottom.equalTo(label3);
        }];
    }
    return self;
}

- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}
- (UITextField *)accNameTf {
    if (_accNameTf == nil) {
        _accNameTf = [[UITextField alloc] init];
        _accNameTf.placeholder = @"请输入真实姓名";
        _accNameTf.backgroundColor = [UIColor clearColor];
        _accNameTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _accNameTf.font = [UIFont dp_systemFontOfSize:16];
        _accNameTf.delegate = self;
        _accNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _accNameTf;
}
- (UITextField *)cardIdTf {
    if (_cardIdTf == nil) {
        _cardIdTf = [[UITextField alloc] init];
        _cardIdTf.placeholder = @"请输入身份证";
        _cardIdTf.backgroundColor = [UIColor clearColor];
        _cardIdTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _cardIdTf.font = [UIFont dp_systemFontOfSize:16];
        _cardIdTf.delegate = self;
        _cardIdTf.keyboardType=UIKeyboardTypeNumberPad;
        _cardIdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _cardIdTf;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.delegate && ([self.delegate respondsToSelector:@selector(textFieldBeginCell:texfField: isScrollBottom:)])) {
        [self.delegate textFieldBeginCell:self texfField:textField isScrollBottom:NO];
    }


    return  YES ;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if (self.delegate && [self.delegate respondsToSelector:@selector(drawingNoCardIdCell:)]) {
        [self.delegate drawingNoCardIdCell:self];
    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DPDrawingCardCell
@synthesize acceNameLabel = _acceNameLabel;
@synthesize cardNameLabel = _cardNameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        self.backgroundColor = [UIColor clearColor];

        UIView *backView1 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView1.layer.borderWidth = 0.5;
        backView1.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView1];

        UILabel *label1 = [self createlabel:@"姓   名:" titleColor:UIColorFromRGB(0x8b825f) titleFont:[UIFont dp_systemFontOfSize:14.0] alignment:NSTextAlignmentRight];
        UILabel *label2 = [self createlabel:@"身份证:" titleColor:UIColorFromRGB(0x8b825f) titleFont:[UIFont dp_systemFontOfSize:14.0] alignment:NSTextAlignmentRight];

        [contentView addSubview:label1];
        [contentView addSubview:label2];
        [backView1 addSubview:self.acceNameLabel];
        [backView1 addSubview:self.cardNameLabel];
        [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView);
        }];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.left.equalTo(backView1).offset(14);
        make.top.equalTo(backView1).offset(5);
        make.height.equalTo(@25);
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1);
        make.right.equalTo(label1);
        make.top.equalTo(label1.mas_bottom);
        make.height.equalTo(@25);
        }];
        [self.acceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.right.equalTo(backView1).offset(-10);
        make.top.equalTo(label1);
        make.bottom.equalTo(label1);
        }];
        [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(5);
        make.right.equalTo(backView1).offset(-10);
        make.top.equalTo(label2);
        make.bottom.equalTo(label2);
        }];
    }
    return self;
}

- (UILabel *)acceNameLabel {
    if (_acceNameLabel == nil) {
        _acceNameLabel = [[UILabel alloc] init];
        _acceNameLabel.text = @"";
        _acceNameLabel.textColor = UIColorFromRGB(0x333333);
        _acceNameLabel.backgroundColor = [UIColor clearColor];
        _acceNameLabel.font = [UIFont dp_systemFontOfSize:14.0];
        _acceNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _acceNameLabel;
}
- (UILabel *)cardNameLabel {
    if (_cardNameLabel == nil) {
        _cardNameLabel = [[UILabel alloc] init];
        _cardNameLabel.text = @"";
        _cardNameLabel.textColor = UIColorFromRGB(0x333333);
        _cardNameLabel.backgroundColor = [UIColor clearColor];
        _cardNameLabel.font = [UIFont dp_systemFontOfSize:14.0];
        _cardNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cardNameLabel;
}
- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end

@implementation DPDrawingNoBankCell
@synthesize bankNumberTf = _bankNumberTf;
@synthesize bankNameLabel = _bankNameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.image = [dp_AccountImage(@"account_wave.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        UILabel *label1 = [self createlabel:@"银行卡号" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        UILabel *label2 = [self createlabel:@"开 户 行" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        [contentView addSubview:label1];
        [contentView addSubview:label2];
        UIView *backView1 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView1.layer.cornerRadius = 5;
        backView1.layer.borderWidth = 0.5;
        backView1.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView1];
        UIView *backView2 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView2.layer.cornerRadius = 5;
        backView2.layer.borderWidth = 0.5;
        backView2.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView2];
        [backView1 addSubview:self.bankNumberTf];
        [backView2 addSubview:self.bankNameLabel];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@55);
            make.top.equalTo(contentView).offset(8);
            make.height.equalTo(@36);
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1);
            make.width.equalTo(@55);
            make.top.equalTo(label1.mas_bottom).offset(10);
            make.height.equalTo(@36);
        }];
        [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label1);
            make.bottom.equalTo(label1);
        }];

        [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label2);
            make.bottom.equalTo(label2);
        }];
        [self.bankNumberTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView1).offset(10);
            make.right.equalTo(backView1).offset(-10);
            make.top.equalTo(backView1).offset(5);
            make.bottom.equalTo(backView1).offset(-5);
        }];
        [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView2).offset(10);
            make.right.equalTo(backView2).offset(-10);
            make.top.equalTo(backView2).offset(5);
            make.bottom.equalTo(backView2).offset(-5);
        }];
        UILabel *label4 = [self createlabel:@"可提款余额" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:15.0] alignment:NSTextAlignmentLeft];
        [contentView addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@90);
            make.top.equalTo(backView2.mas_bottom).offset(5);
            make.height.equalTo(@30);
        }];

        self.yueLabel = [self createlabel:@" " titleColor:[UIColor dp_flatRedColor] titleFont:[UIFont dp_systemFontOfSize:15.0] alignment:NSTextAlignmentRight];
        [backView1 addSubview:self.yueLabel];
        [self.yueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@140);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label4);
            make.height.equalTo(@30);
        }];
        
    }
    return self;
}
- (void)pvt_sure {
}
- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}
- (UITextField *)bankNumberTf {
    if (_bankNumberTf == nil) {
        _bankNumberTf = [[UITextField alloc] init];
        _bankNumberTf.placeholder = @"开户名必须与实名一致";
        _bankNumberTf.backgroundColor = [UIColor clearColor];
        _bankNumberTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _bankNumberTf.font = [UIFont dp_systemFontOfSize:16];
        _bankNumberTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankNumberTf.keyboardType=UIKeyboardTypeNumberPad;
        _bankNumberTf.delegate = self;
    }
    return _bankNumberTf;
}
- (UILabel *)bankNameLabel {
    if (_bankNameLabel == nil) {
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.text = @"";
        _bankNameLabel.textColor = UIColorFromRGB(0x333333);
        _bankNameLabel.backgroundColor = [UIColor clearColor];
        _bankNameLabel.font = [UIFont dp_systemFontOfSize:14.0];
        _bankNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankNameLabel;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(textFieldBeginCell:texfField: isScrollBottom:)])) {
        [self.delegate textFieldBeginCell:self texfField:textField isScrollBottom:NO];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(bankNameFromBankNumber:)])) {
        [self.delegate bankNameFromBankNumber:self];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //
}

@end
@implementation DPDrawingMoneyCell
@synthesize drawMoneyTf = _drawMoneyTf;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        UILabel *label1 = [self createlabel:@"提款金额" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        [contentView addSubview:label1];
        UIView *backView1 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView1.layer.cornerRadius = 5;
        backView1.layer.borderWidth = 0.5;
        backView1.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView1];

        [backView1 addSubview:self.drawMoneyTf];
//        [contentView addSubview:self.moneyLabel];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@55);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@36);
        }];

        [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label1);
            make.bottom.equalTo(label1);
        }];

        [self.drawMoneyTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView1).offset(10);
            make.right.equalTo(backView1).offset(-10);
            make.top.equalTo(label1);
            make.bottom.equalTo(label1);
        }];

    }
    return self;
}

- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}
- (UITextField *)drawMoneyTf {
    if (_drawMoneyTf == nil) {
        _drawMoneyTf = [[UITextField alloc] init];
        _drawMoneyTf.placeholder = @"输入提款金额";
        _drawMoneyTf.backgroundColor = [UIColor clearColor];
        _drawMoneyTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _drawMoneyTf.font = [UIFont dp_systemFontOfSize:16];
        _drawMoneyTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _drawMoneyTf.keyboardType=UIKeyboardTypeNumberPad;
        _drawMoneyTf.delegate = self;
    }
    return _drawMoneyTf;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(textFieldBeginCell:texfField: isScrollBottom:)])) {
        [self.delegate textFieldBeginCell:self texfField:textField isScrollBottom:YES];
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(drawingMoneyCell:)])) {
        [self.delegate drawingMoneyCell:self];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    return YES;
}
@end
@implementation DPDrawingExMoneyCell
@synthesize moneyLabel = _moneyLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:self.moneyLabel];
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView).offset(-50);
            make.top.equalTo(contentView).offset(5);
            make.height.equalTo(@30);
        }];
        
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:dp_AccountImage(@"drawingMoney.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pvt_shouxu) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.right.equalTo(contentView).offset(-10);
            make.centerY.equalTo(self.moneyLabel);
            make.height.equalTo(@20);
        }];
    }
    return self;
}
- (void)pvt_shouxu {
    
    if ([self.delegate respondsToSelector:@selector(drawingMoneyButtonClick)]) {
        [self.delegate drawingMoneyButtonClick];
    }
//    DPWebViewController *web = [[DPWebViewController alloc]init];
//    web.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kDrawAttentionURL]];

}
- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}

- (TTTAttributedLabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[TTTAttributedLabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.textColor = [UIColor dp_flatBlackColor];
        _moneyLabel.font = [UIFont dp_systemFontOfSize:14];
        _moneyLabel.userInteractionEnabled=NO;
    }
    return _moneyLabel;
}

- (void)setMoneyLabelText:(int)shouxuMoney totalMoney:(int)totalMoney {
    NSString *money1 = [NSString stringWithFormat:@"%.2f", shouxuMoney / 100.0];
    NSString *money2 = [NSString stringWithFormat:@"%.2f", totalMoney - shouxuMoney / 100.0];
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手 续 费 : %@元，到账金额 : %@元", money1, money2]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x333333) CGColor] range:NSMakeRange(0, 8)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(8, money1.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x333333) CGColor] range:NSMakeRange(8 + money1.length, 10)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(8 + money1.length + 9, money2.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x333333) CGColor] range:NSMakeRange(8 + money1.length + 9 + money2.length, 1)];
    [self.moneyLabel setText:hintString1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    //
}

@end
@implementation DPDrawingPassWordCell
@synthesize drawPassWordTf = _drawPassWordTf;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        UILabel *label1 = [self createlabel:@"提款密码" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        [contentView addSubview:label1];
        UIView *backView1 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView1.layer.cornerRadius = 5;
        backView1.layer.borderWidth = 0.5;
        backView1.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView1];

        [backView1 addSubview:self.drawPassWordTf];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@55);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@36);
        }];

        [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label1);
            make.bottom.equalTo(label1);
        }];

        [self.drawPassWordTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView1).offset(10);
            make.right.equalTo(backView1).offset(-10);
            make.top.equalTo(label1);
            make.bottom.equalTo(label1);
        }];
    }
    return self;
}

- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}

- (UITextField *)drawPassWordTf {
    if (_drawPassWordTf == nil) {
        _drawPassWordTf = [[UITextField alloc] init];
        _drawPassWordTf.placeholder = @"输入提款密码";
        _drawPassWordTf.backgroundColor = [UIColor clearColor];
        _drawPassWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _drawPassWordTf.font = [UIFont dp_systemFontOfSize:16];
        _drawPassWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _drawPassWordTf.delegate = self;
//        _drawPassWordTf.keyboardType=UIKeyboardTypeNumberPad;
        _drawPassWordTf.secureTextEntry=YES;
    }
    return _drawPassWordTf;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(textFieldBeginCell:texfField: isScrollBottom:)])) {
        [self.delegate textFieldBeginCell:self texfField:textField isScrollBottom:YES];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(drawingPassWordCell:)])) {
        [self.delegate drawingPassWordCell:self];
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //
}
@end

@implementation DPDrawingChangePassWordCell
@synthesize drawPassWordTf = _drawPassWordTf;
@synthesize sureDrawPassWordTf = _sureDrawPassWordTf;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        UILabel *label2 = [self createlabel:@"提款密码" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        UILabel *label3 = [self createlabel:@"确认密码" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:13.0] alignment:NSTextAlignmentRight];
        [contentView addSubview:label2];
        [contentView addSubview:label3];

        UIView *backView2 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView2.layer.cornerRadius = 5;
        backView2.layer.borderWidth = 0.5;
        backView2.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView2];
        UIView *backView3 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView3.layer.cornerRadius = 5;
        backView3.layer.borderWidth = 0.5;
        backView3.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView3];

        [backView2 addSubview:self.drawPassWordTf];
        [backView3 addSubview:self.sureDrawPassWordTf];

        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@55);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@36);
        }];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2);
            make.width.equalTo(@55);
            make.top.equalTo(label2.mas_bottom).offset(5);
            make.height.equalTo(@36);
        }];

        [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label2);
            make.bottom.equalTo(label2);
        }];
        [backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label3.mas_right).offset(5);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label3);
            make.bottom.equalTo(label3);
        }];

        [self.drawPassWordTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView2).offset(10);
            make.right.equalTo(backView2).offset(-10);
            make.top.equalTo(label2);
            make.bottom.equalTo(label2);
        }];
        [self.sureDrawPassWordTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView3).offset(10);
            make.right.equalTo(backView3).offset(-10);
            make.top.equalTo(label3);
            make.bottom.equalTo(label3);
        }];
    }
    return self;
}

- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}

- (UITextField *)drawPassWordTf {
    if (_drawPassWordTf == nil) {
        _drawPassWordTf = [[UITextField alloc] init];
        _drawPassWordTf.placeholder = @"输入提款密码";
        _drawPassWordTf.backgroundColor = [UIColor clearColor];
        _drawPassWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _drawPassWordTf.font = [UIFont dp_systemFontOfSize:16];
        _drawPassWordTf.delegate = self;
        _drawPassWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _drawPassWordTf.keyboardType=UIKeyboardTypeNumberPad;
        _drawPassWordTf.secureTextEntry=YES;
    }
    return _drawPassWordTf;
}
- (UITextField *)sureDrawPassWordTf {
    if (_sureDrawPassWordTf == nil) {
        _sureDrawPassWordTf = [[UITextField alloc] init];
        _sureDrawPassWordTf.placeholder = @"输入提款密码";
        _sureDrawPassWordTf.backgroundColor = [UIColor clearColor];
        _sureDrawPassWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _sureDrawPassWordTf.font = [UIFont dp_systemFontOfSize:16];
        _sureDrawPassWordTf.delegate = self;
        _sureDrawPassWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _sureDrawPassWordTf.keyboardType=UIKeyboardTypeNumberPad;
        _sureDrawPassWordTf.secureTextEntry=YES;
    }
    return _sureDrawPassWordTf;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(textFieldBeginCell:texfField: isScrollBottom:)])) {
        [self.delegate textFieldBeginCell:self texfField:textField isScrollBottom:YES];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawingChangePassWordCell:)]) {
        [self.delegate drawingChangePassWordCell:self];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //
}
@end

@implementation DPDrawingBankCell
@synthesize bankImageView = _bankImageView;
@synthesize bankNameLabel = _bankNameLabel;
@synthesize bankNumberLabel = _bankNumberLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView1 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        backView1.layer.borderWidth = 0.5;
        backView1.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [contentView addSubview:backView1];
        [backView1 addSubview:self.bankImageView];
        [backView1 addSubview:self.bankNameLabel];
        [backView1 addSubview:self.bankNumberLabel];
        [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(contentView).offset(5);
            make.bottom.equalTo(contentView).offset(-0.5);
        }];
        [self.bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView1).offset(5);
            make.width.equalTo(@40);
            make.centerY.equalTo(backView1);
            make.height.equalTo(@40);
        }];

        [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bankImageView.mas_right).offset(5);
            make.right.equalTo(backView1).offset(-10);
            make.top.equalTo(self.bankImageView);
            make.height.equalTo(@20);
        }];
        [self.bankNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bankNameLabel);
            make.right.equalTo(self.bankNameLabel);
            make.top.equalTo(self.bankNameLabel.mas_bottom);
            make.bottom.equalTo(backView1).offset(-5);
        }];
    }
    return self;
}
- (UIImageView *)bankImageView {
    if (_bankImageView == nil) {
        _bankImageView = [[UIImageView alloc] init];
        _bankImageView.backgroundColor = [UIColor clearColor];
        _bankImageView.image = dp_BankIconImage(@"default.png") ;
    }
    return _bankImageView;
}
- (UILabel *)bankNameLabel {
    if (_bankNameLabel == nil) {
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.text = @"";
        _bankNameLabel.textColor = UIColorFromRGB(0x333333);
        _bankNameLabel.backgroundColor = [UIColor clearColor];
        _bankNameLabel.font = [UIFont dp_systemFontOfSize:15.0];
        _bankNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankNameLabel;
}
- (UILabel *)bankNumberLabel {
    if (_bankNumberLabel == nil) {
        _bankNumberLabel = [[UILabel alloc] init];
        _bankNumberLabel.text = @"";
        _bankNumberLabel.textColor = UIColorFromRGB(0x333333);
        _bankNumberLabel.backgroundColor = [UIColor clearColor];
        _bankNumberLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _bankNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankNumberLabel;
}
- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DPDrawingAddBankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];

        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.image = [dp_AccountImage(@"account_wave.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor clearColor];
        [button setBackgroundImage:dp_AccountImage(@"drawingAdd.png") forState:UIControlStateNormal];
        [button setTitle:@"+ 使用新的银行卡" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont dp_systemFontOfSize:15.0];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addBank) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(contentView).offset(5);
            make.height.equalTo(@50);
        }];

        UILabel *label2 = [self createlabel:@"可提款余额" titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:15.0] alignment:NSTextAlignmentLeft];
        [view addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@90);
            make.top.equalTo(button.mas_bottom).offset(5);
            make.height.equalTo(@30);
        }];

        self.yueLabel = [self createlabel:@" " titleColor:[UIColor dp_flatRedColor] titleFont:[UIFont dp_systemFontOfSize:15.0] alignment:NSTextAlignmentRight];
        [view addSubview:self.yueLabel];
        [self.yueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@140);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(label2);
            make.height.equalTo(@30);
        }];

    }
    return self;
}
-(void)addBank{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(drawingAddBank:)]) {
        [self.delegate drawingAddBank:self];
    }
}
- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}

@end