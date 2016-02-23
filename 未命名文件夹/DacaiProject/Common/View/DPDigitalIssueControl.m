//
//  DPDigitalIssueControl.m
//  DacaiProject
//
//  Created by sxf on 14-7-31.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalIssueControl.h"
typedef NS_ENUM(NSInteger, DPIssueControlStyle) {
    DPIssueControlStyleOneRow,
    DPIssueControlStyleTwoRow,
};
@interface DPDigitalIssueControl () {
@private
    UILabel *_titleLabel;
    UILabel *_oddsLabel;
}
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *oddsLabel;

@property (nonatomic, assign) DPIssueControlStyle style;

@end
@implementation DPDigitalIssueControl
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
- (id)initWithStyle:(DPIssueControlStyle)style {
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
    
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.oddsLabel];
    [contentView addSubview:self.selectView];
    self.selectView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"selectedIssue001_11.png")];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-10);
        make.height.equalTo(@14);
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@14);
    }];
    self.selectView.hidden=YES;
    switch (self.style) {
        case DPIssueControlStyleOneRow: {
            self.oddsLabel.hidden=YES;
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView);
                make.centerX.equalTo(contentView);
                make.left.equalTo(contentView);
                make.top.equalTo(contentView);
            }];
        }
            break;
        case DPIssueControlStyleTwoRow: {
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
            self.titleColor = [UIColor dp_flatBlackColor];
            self.oddsColor = [UIColor dp_flatBlackColor];
        }
            break;
        default:
            DPAssert(NO);
            break;
    }
    
    [self addTarget:self action:@selector(pvt_onToggle) forControlEvents:UIControlEventTouchUpInside];
    
   [self pvt_applyStyle];
}
- (void)pvt_applyStyle {
    if (self.selected) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.oddsLabel.textColor = [UIColor dp_flatRedColor];
        self.titleLabel.textColor = [UIColor dp_flatRedColor];
        self.selectView.hidden = NO ;
        
    } else {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.oddsLabel.textColor = self.oddsColor;
        self.titleLabel.textColor = self.titleColor;
        self.selectView.hidden = YES ;
    }
}

- (void)pvt_onToggle {
    self.selected = !self.selected;
}
+ (instancetype)oneRowControl {
    return [[DPDigitalIssueControl alloc] initWithStyle:DPIssueControlStyleOneRow];
}

+ (instancetype)twoRowControl {
    return [[DPDigitalIssueControl alloc] initWithStyle:DPIssueControlStyleTwoRow];
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
    
    }
    return _titleLabel;
}

- (UILabel *)oddsLabel {
    if (_oddsLabel == nil) {
        _oddsLabel = [[UILabel alloc] init];
        _oddsLabel.backgroundColor = [UIColor clearColor];
//        _oddsLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return _oddsLabel;
}
- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
}
-(UIImageView *)selectView{
    if (_selectView== nil) {
        _selectView = [[UIImageView alloc] init];
        _selectView.backgroundColor = [UIColor clearColor];
        
    }
    return _selectView;
}
- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

- (void)setOddsFont:(UIFont *)oddsFont {
    self.oddsLabel.font = oddsFont;
}

- (void)setOddsText:(NSString *)oddsText {
    self.oddsLabel.text = oddsText;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
