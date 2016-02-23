//
//  DProjectDetailMyOrderHeaderCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DProjectDetailMyOrderHeaderCell.h"

@interface DProjectDetailMyOrderHeaderCell () {
@private
    TTTAttributedLabel *_myOrderLabel;
    TTTAttributedLabel *_myBonusLabel;
    UIImageView *_arrowView;
}
@property (nonatomic, strong, readonly) TTTAttributedLabel *myOrderLabel;
@property (nonatomic, strong, readonly) TTTAttributedLabel *myBonusLabel;
@property (nonatomic, strong, readonly) UIImageView *arrowView;

@end

@implementation DProjectDetailMyOrderHeaderCell
@dynamic myBonusLabel, myOrderLabel, arrowView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidLayout];
    }
    return self;
}
- (void)bulidLayout {
    UIView *contentView = self.contentView;
    contentView.backgroundColor = UIColorFromRGB(0xffffff);
    [contentView addSubview:self.myOrderLabel];
    [contentView addSubview:self.myBonusLabel];
    [contentView addSubview:self.arrowView];

    [self.myOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@(contentView.frame.size.width/2-20));
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];

    [self.myBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myOrderLabel.mas_right);
        make.width.equalTo(@(contentView.frame.size.width/2-30));
        make.top.equalTo(contentView).offset(3);
        make.bottom.equalTo(contentView).offset(-2);
    }];

    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-10);
        make.width.equalTo(@14.5);
        make.centerY.equalTo(contentView);
        make.height.equalTo(@14.5);
    }];

    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    [contentView addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(contentView).offset(0.5);
    }];

    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onHandleTap)]];
}
- (void)_onHandleTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapOrderHeaderCell:)]) {
        [self.delegate tapOrderHeaderCell:self];
    }
}

- (TTTAttributedLabel *)myOrderLabel {
    if (_myOrderLabel == nil) {
        _myOrderLabel = [[TTTAttributedLabel alloc] init];
        _myOrderLabel.backgroundColor = [UIColor clearColor];
        _myOrderLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _myOrderLabel.textColor = [UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1];
        _myOrderLabel.textAlignment = NSTextAlignmentLeft;
        _myOrderLabel.userInteractionEnabled=NO;
    }
    return _myOrderLabel;
}
- (TTTAttributedLabel *)myBonusLabel {
    if (_myBonusLabel == nil) {
        _myBonusLabel = [[TTTAttributedLabel alloc] init];
        _myBonusLabel.backgroundColor = [UIColor clearColor];
        _myBonusLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _myBonusLabel.textColor = [UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1];
        _myBonusLabel.textAlignment = NSTextAlignmentLeft;
        _myBonusLabel.userInteractionEnabled=NO;
    }
    return _myBonusLabel;
}
- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowView.image = dp_ProjectImage(@"rengou_up.png");
    }
    return _arrowView;
}
- (void)setBuyAmount:(NSString *)buyAmount bonus:(NSString *)bonus {
    UIFont *font = [UIFont dp_systemFontOfSize:13.0];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的认购:%@元", buyAmount]];
    [buyString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x948f89) CGColor] range:NSMakeRange(0, 5)];
    [buyString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(5, buyAmount.length)];
    [buyString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatBlackColor] CGColor] range:NSMakeRange(buyString.length - 1, 1)];
    [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(5, buyAmount.length)];
    [self.myOrderLabel setText:buyString];

    NSMutableAttributedString *bonusString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的奖金:%@元", bonus]];
    [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x948f89) CGColor] range:NSMakeRange(0, 5)];
    [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(5, bonus.length)];
    [bonusString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatBlackColor] CGColor] range:NSMakeRange(bonusString.length - 1, 1)];
    [bonusString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(5, bonus.length)];
    [self.myBonusLabel setText:bonusString];
    CFRelease(fontRef);
}
- (void)layoutSubviews {
    [super layoutSubviews];

    if (_expand) {
        self.arrowView.transform = CGAffineTransformIdentity;
    } else {
        self.arrowView.transform = CGAffineTransformMakeRotation(M_PI * 1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DProjectDetailMyOrderTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidLayout];
    }
    return self;
}
- (void)bulidLayout {
    UIView *contentView = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    contentView.backgroundColor = [UIColor clearColor];
    UIView *backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    [contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView);
    }];
    UILabel *timer = [self createlable:@"时间" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *rengou = [self createlable:@"认购金额" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *bonus = [self createlable:@"奖金" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:12.0]];
    [backView addSubview:timer];
    [backView addSubview:rengou];
    [backView addSubview:bonus];
    [timer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.width.equalTo(@((contentView.frame.size.width-20)/3));
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [rengou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timer.mas_right);
        make.width.equalTo(@((contentView.frame.size.width-20)/3));
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [bonus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rengou.mas_right);
        make.width.equalTo(@((contentView.frame.size.width-20)/3));
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    UIView *hLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *hLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *hLine3 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *hLine4 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *vLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [backView addSubview:hLine1];
    [backView addSubview:hLine2];
    [backView addSubview:hLine3];
    [backView addSubview:hLine4];
    [backView addSubview:vLine1];
    [backView addSubview:vLine2];
    [hLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
         make.bottom.equalTo(backView);
    }];
    [hLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rengou);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [hLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bonus);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [hLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.height.equalTo(@0.5);
        make.top.equalTo(backView);
    }];
    [vLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(backView);
    }];
}
- (UILabel *)createlable:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont {
    UILabel *lable = [[UILabel alloc] init];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = color;
    lable.font = titleFont;
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@interface DProjectDetailMyOrderInfoCell () {
@private
    UILabel *_timeLabel;
    DPImageLabel *_rengouLabel;
    TTTAttributedLabel *_bonusLabel;
}

@end
@implementation DProjectDetailMyOrderInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidLayout];
    }
    return self;
}
- (void)bulidLayout {
    UIView *contentView = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    contentView.backgroundColor = [UIColor clearColor];
    UIView *backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    [contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView);
        make.height.equalTo(@25);
//        make.bottom.equalTo(contentView);
    }];
    [backView addSubview:self.timeLabel];
    [backView addSubview:self.rengouLabel];
    [backView addSubview:self.bonusLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.width.equalTo(@((contentView.frame.size.width-20)/3));
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [self.rengouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.width.equalTo(@((contentView.frame.size.width-20)/3));
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rengouLabel.mas_right);
        make.width.equalTo(@((contentView.frame.size.width-20)/3));
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    UIView *hLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *hLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *hLine3 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *hLine4 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [backView addSubview:hLine1];
    [backView addSubview:hLine2];
    [backView addSubview:hLine3];
    [backView addSubview:hLine4];
    [backView addSubview:vLine1];
    [hLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [hLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rengouLabel);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [hLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bonusLabel);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [hLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.width.equalTo(@0.5);
        make.top.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(backView);
//        make.bottom.equalTo(backView).offset(0.5);
    }];
}
- (void)createLine {
    UIView *vLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
    [self.contentView addSubview:vLine];

    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.contentView).offset(0.5);
    }];
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = UIColorFromRGB(0x948f89);
        _timeLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
- (TTTAttributedLabel *)bonusLabel {
    if (_bonusLabel == nil) {
        _bonusLabel = [[TTTAttributedLabel alloc] init];
        _bonusLabel.backgroundColor = [UIColor clearColor];
        _bonusLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _bonusLabel.textColor = UIColorFromRGB(0x948f89);
        _bonusLabel.textAlignment = NSTextAlignmentCenter;
        _bonusLabel.userInteractionEnabled=NO;
    }
    return _bonusLabel;
}
- (DPImageLabel *)rengouLabel {
    if (_rengouLabel == nil) {
        _rengouLabel = [[DPImageLabel alloc] init];
        _rengouLabel.imagePosition = DPImagePositionLeft;
        _rengouLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _rengouLabel.backgroundColor = [UIColor clearColor];
        _rengouLabel.textColor = UIColorFromRGB(0x948f89);
    }

    return _rengouLabel;
}
- (void)setBonusLabelTitle:(NSString *)string {
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", string]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, string.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x666666) CGColor] range:NSMakeRange(string.length, 1)];
    [self.bonusLabel setText:hintString1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
