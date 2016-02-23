//
//  DPRedPacketView.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRedPacketView.h"

@interface DPRedPacketView ()
@property (nonatomic, strong, readonly) UIImageView *selectedView;
@end

@implementation DPRedPacketView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initialize];
        [self _buildLayout];
    }
    return self;
}

- (void)_initialize {
    _surplusLabel = [[MDHTMLLabel alloc] init];
    _surplusLabel.backgroundColor = [UIColor clearColor];
    _surplusLabel.textColor = [UIColor dp_flatBlackColor];
    _surplusLabel.font = [UIFont dp_systemFontOfSize:12];
    _surplusLabel.textAlignment = NSTextAlignmentCenter;
    
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.backgroundColor = [UIColor clearColor];
    _limitLabel.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
    _limitLabel.font = [UIFont dp_systemFontOfSize:9];
    _limitLabel.textAlignment = NSTextAlignmentCenter;
    
    _validityLabel = [[UILabel alloc] init];
    _validityLabel.backgroundColor = [UIColor clearColor];
    _validityLabel.textColor = [UIColor colorWithRed:0.53 green:0.49 blue:0.43 alpha:1];
    _validityLabel.font = [UIFont dp_systemFontOfSize:9];
    _validityLabel.textAlignment = NSTextAlignmentCenter;
    
    _signLabel = [[UILabel alloc] init];
    _signLabel.backgroundColor = [UIColor clearColor];
    _signLabel.font = [UIFont dp_systemFontOfSize:8];
    _signLabel.textColor = [UIColor colorWithRed:0.97 green:0.99 blue:0.7 alpha:1];
    _signLabel.text = @"￥";
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:0.97 green:0.99 blue:0.7 alpha:1];
    _nameLabel.font = [UIFont fontWithName:@"Impact" size:20];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    
    _selectedView = [[UIImageView alloc] initWithImage:dp_RedPacketImage(@"selected.png")];
    _selectedView.hidden = YES;
}

- (void)_buildLayout {
    UIView *view = ({
        UIImageView *view = [[UIImageView alloc] initWithImage:dp_RedPacketImage(@"bg.png")];
        view;
    });
    
    [self addSubview:self.surplusLabel];
    [self addSubview:self.limitLabel];
    [self addSubview:self.validityLabel];
    [self addSubview:view];
    [self addSubview:self.signLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.selectedView];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@50);
        make.width.equalTo(@66.5);
        make.bottom.equalTo(self.mas_centerY).offset(5);
    }];
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_right);
        make.centerY.equalTo(view.mas_top);
    }];
    [self.surplusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(8);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surplusLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.validityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.limitLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view.mas_bottom).offset(-16);
    }];
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel).offset(2);
        make.right.equalTo(self.nameLabel.mas_left);
    }];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.selectedView.hidden = !selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat MAX_WIDTH = 43;
    CGFloat offsetX = 0;
    if (self.nameLabel.dp_width > MAX_WIDTH) {
        CGFloat width = self.nameLabel.dp_width;
        
        self.nameLabel.font = [UIFont fontWithName:@"Impact" size:floorf(MAX_WIDTH / self.nameLabel.dp_width * 20)];
        
        [self.nameLabel sizeToFit];
        offsetX = (width - self.dp_width) / 2;
    }
    self.nameLabel.dp_x += self.signLabel.dp_intrinsicWidth / 2 + offsetX;
    self.nameLabel.center = CGPointMake(CGRectGetMidX(self.nameLabel.frame), CGRectGetMidY(self.signLabel.frame) - 2);
    self.signLabel.dp_x = self.nameLabel.dp_minX - self.signLabel.dp_width;
}

@end