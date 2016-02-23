//
//  DPBetToggleControl.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBetToggleControl.h"

typedef NS_ENUM(NSInteger, DPBetToggleControlStyle) {
    DPBetToggleControlStyleHorizontal,
    DPBetToggleControlStyleVertical,
    DPBetToggleControlStyleHorizontal2,
};

@interface DPBetToggleControl () {
@private
    UILabel *_titleLabel;
    UILabel *_oddsLabel;
    UIImageView *_backgroundView;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *oddsLabel;
@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, assign) DPBetToggleControlStyle style;

@end

@implementation DPBetToggleControl
@dynamic titleLabel;
@dynamic oddsLabel;
@dynamic titleText;
@dynamic oddsText;
@dynamic titleFont;
@dynamic oddsFont;

- (id)init {
    DPException(@"use +horizontalControl or +verticalControl instead.");
}

- (id)initWithFrame:(CGRect)frame {
    DPException(@"use +horizontalControl or +verticalControl instead.");
}

- (id)initWithStyle:(DPBetToggleControlStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.style = style;
        
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self;
    [contentView addSubview:self.backgroundView];
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.oddsLabel];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    switch (self.style) {
        case DPBetToggleControlStyleHorizontal: {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView);
                make.right.equalTo(contentView.mas_centerX).offset(-5);
            }];
            [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView);
//                make.bottom.equalTo(self.titleLabel);
                make.left.equalTo(contentView.mas_centerX).offset(-2);
            }];
            
            
            self.titleFont = [UIFont dp_systemFontOfSize:13];
            self.oddsFont = [UIFont dp_systemFontOfSize:10];
            self.titleColor = [UIColor dp_flatBlackColor];
            self.oddsColor = [UIColor dp_flatBlackColor];
        }
            break;
        case DPBetToggleControlStyleHorizontal2: {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView);
                make.right.equalTo(contentView.mas_centerX).offset(-1);
            }];
            [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView);
//                make.bottom.equalTo(self.titleLabel);
                make.left.equalTo(self.titleLabel.mas_right).offset(1);
            }];
           
            
            self.titleFont = [UIFont dp_systemFontOfSize:12];
            self.oddsFont = [UIFont dp_systemFontOfSize:10];
            self.titleColor = [UIColor dp_flatBlackColor];
            self.oddsColor = [UIColor dp_flatBlackColor];
        }
            break;
        case DPBetToggleControlStyleVertical: {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView);
                make.bottom.equalTo(contentView.mas_centerY).offset(2);
            }];
            [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView);
                make.top.equalTo(contentView.mas_centerY).offset(1);
            }];
            
            self.titleFont = [UIFont dp_systemFontOfSize:13];
            self.oddsFont = [UIFont dp_systemFontOfSize:10];
            self.titleColor = [UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1];
            self.oddsColor = [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];
        }
            break;
        default:
            DPAssert(NO);
            break;
    }
    
    self.normalBgColor = [UIColor whiteColor];
    self.selectedBgColor = [UIColor dp_flatRedColor];
    self.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
    
    [self pvt_applyStyle];
}

+ (instancetype)horizontalControl {
    return [[DPBetToggleControl alloc] initWithStyle:DPBetToggleControlStyleHorizontal];
}

+ (instancetype)horizontalControl2 {
    return [[DPBetToggleControl alloc] initWithStyle:DPBetToggleControlStyleHorizontal2];
}

+ (instancetype)verticalControl {
    return [[DPBetToggleControl alloc] initWithStyle:DPBetToggleControlStyleVertical];
}

- (void)pvt_applyStyle {
    if (self.selected) {
        if (self.selectedImage) {
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderWidth = 0;
        } else {
            self.backgroundColor = self.selectedBgColor;
            
            if (self.showBorderWhenSelected) {
                self.layer.borderWidth = 1;
                self.layer.masksToBounds = YES;
            } else {
                self.layer.borderWidth = 0;
            }
        }
        self.backgroundView.image = self.selectedImage;
        self.oddsLabel.textColor = [UIColor dp_flatWhiteColor];
        self.titleLabel.textColor = [UIColor dp_flatWhiteColor];
        
    } else {
        if (self.normalImage) {
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderWidth = 0;
        } else {
            self.backgroundColor = self.normalBgColor;
            self.layer.borderWidth = 1;
        }
        self.backgroundView.image = self.normalImage;
        self.oddsLabel.textColor = self.oddsColor;
        self.titleLabel.textColor = self.titleColor;
    }
}

#pragma mark - getter, setter

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self pvt_applyStyle];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)oddsLabel {
    if (_oddsLabel == nil) {
        _oddsLabel = [[UILabel alloc] init];
        _oddsLabel.backgroundColor = [UIColor clearColor];
        _oddsLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return _oddsLabel;
}

- (UIImageView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.userInteractionEnabled = NO;
    }
    return _backgroundView;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
}

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self pvt_applyStyle];
}

- (void)setOddsFont:(UIFont *)oddsFont {
    self.oddsLabel.font = oddsFont;
}

- (void)setOddsText:(NSString *)oddsText {
    self.oddsLabel.text = oddsText;
}

- (void)setOddsColor:(UIColor *)oddsColor {
    _oddsColor = oddsColor;
    [self pvt_applyStyle];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    [self pvt_applyStyle];
}

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    [self pvt_applyStyle];
}

- (void)setSelectedBgColor:(UIColor *)selectedBgColor {
    _selectedBgColor = selectedBgColor;
    [self pvt_applyStyle];
}

- (void)setNormalBgColor:(UIColor *)normalBgColor {
    _normalBgColor = normalBgColor;
    [self pvt_applyStyle];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (NSString *)titleText {
    return self.titleLabel.text;
}

- (UIFont *)oddsFont {
    return self.oddsLabel.font;
}

- (NSString *)oddsText {
    return self.oddsLabel.text;
}

- (UIColor *)borderColor:(UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
