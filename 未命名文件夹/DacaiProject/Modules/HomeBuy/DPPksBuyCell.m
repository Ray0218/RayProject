//
//  DPPksBuyCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPPksBuyCell.h"

@interface DPPksBuyCell () {
@private
    UIImageView *_pokerView;
    UIImageView *_circleView;
    UIImageView *_chipView;
    UILabel *_missLabel;
}

@end

@implementation DPPksBuyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.missLabel];
    [contentView addSubview:self.circleView];
    [contentView addSubview:self.pokerView];
    [contentView addSubview:self.chipView];
    
    [self.pokerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(5);
        make.centerX.equalTo(contentView);
    }];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pokerView);
    }];
    [self.chipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pokerView);
        make.bottom.equalTo(self.pokerView);
    }];
    [self.missLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.pokerView.mas_bottom).offset(5);
    }];
}

- (UIImageView *)pokerView {
    if (_pokerView == nil) {
        _pokerView = [[UIImageView alloc] init];
    }
    return _pokerView;
}

- (UIImageView *)circleView {
    if (_circleView == nil) {
        _circleView = [[UIImageView alloc] init];
    }
    return _circleView;
}

- (UIImageView *)chipView {
    if (_chipView == nil) {
        _chipView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"chip.png")];
    }
    return _chipView;
}

- (UILabel *)missLabel {
    if (_missLabel == nil) {
        _missLabel = [[UILabel alloc] init];
        _missLabel.text = @"-" ;
        _missLabel.backgroundColor = [UIColor clearColor];
        _missLabel.font = [UIFont dp_regularArialOfSize:11];
        _missLabel.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:1 alpha:1];
        _missLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _missLabel;
}

@end

#pragma mark - DPPksBuyHeaderReusableView

@interface DPPksBuyHeaderReusableView () {
@private
    UILabel *_bonusLabel;
    UIButton *_shakeButton;
}

@end

@implementation DPPksBuyHeaderReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self;
    
    [contentView addSubview:self.bonusLabel];
    [contentView addSubview:self.shakeButton];
    
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(12);
        make.height.equalTo(@18);
        make.centerY.equalTo(contentView.mas_bottom).offset(-20);
    }];
    
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_bottom).offset(-20);
        make.right.equalTo(contentView);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bonusLabel.frame = CGRectMake(CGRectGetMinX(self.bonusLabel.frame),
                                       CGRectGetMinY(self.bonusLabel.frame),
                                       CGRectGetWidth(self.bonusLabel.frame) + 15,
                                       CGRectGetHeight(self.bonusLabel.frame));
}

- (UILabel *)bonusLabel {
    if (_bonusLabel == nil) {
        _bonusLabel = [[UILabel alloc] init];
        _bonusLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _bonusLabel.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:1 alpha:1];
        _bonusLabel.textAlignment = NSTextAlignmentCenter;
        _bonusLabel.font = [UIFont dp_systemFontOfSize:12];
        _bonusLabel.clipsToBounds = YES;
        _bonusLabel.layer.cornerRadius = 9;
    }
    return _bonusLabel;
}

- (UIButton *)shakeButton {
    if (_shakeButton == nil) {
        _shakeButton = [[UIButton alloc] init];
        [_shakeButton setImage:dp_PokerThreeImage(@"shake.png") forState:UIControlStateNormal];
    }
    return _shakeButton;
}

@end

#pragma mark - DPPksBuyDrawView

@interface DPPksBuyDrawView () {
@private
    UILabel *_textLabel;
}

@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

@implementation DPPksBuyDrawView
@dynamic text;

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(3);
            make.height.equalTo(@12);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont fontWithName:@"Times New Roman" size:11];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _textLabel;
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
}

- (NSString *)text {
    return self.textLabel.text;
}

- (void)setType:(NSInteger)type {
    // 1: 方块 2:红桃 3:梅花 4:黑桃
    switch (type) {
        case 1:
            self.image = dp_PokerThreeImage(@"draw/1.png");
            self.textLabel.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
            break;
        case 2:
            self.image = dp_PokerThreeImage(@"draw/2.png");
            self.textLabel.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
            break;
        case 3:
            self.image = dp_PokerThreeImage(@"draw/3.png");
            self.textLabel.textColor = [UIColor dp_flatBlackColor];
            break;
        case 4:
            self.image = dp_PokerThreeImage(@"draw/4.png");
            self.textLabel.textColor = [UIColor dp_flatBlackColor];
            break;
        default:
            self.image = dp_PokerThreeImage(@"draw/undraw.png");
            self.textLabel.textColor = [UIColor clearColor];
            break;
    }
}

@end