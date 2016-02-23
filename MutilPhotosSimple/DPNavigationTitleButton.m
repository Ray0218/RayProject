//
//  DPNavigationTitleButton.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPNavigationTitleButton.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "Masonry.h"

@interface DPNavigationTitleButton () {
@private
    UILabel *_titleLabel;
    UIImageView *_arrowView;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *arrowView;

@end

@implementation DPNavigationTitleButton
@dynamic titleLabel;
@dynamic titleText;
@dynamic arrowView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.arrowView];
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(-6);
        }];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@9.5);
            make.height.equalTo(@6);
            make.centerY.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(2);
        }];
    }
    return self;
}

- (void)turnArrow {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.arrowView.transform = CGAffineTransformMakeRotation(180 * (M_PI / 180.0f));
    [UIView commitAnimations];
}

- (void)restoreArrow {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.arrowView.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:@"arrow_down.png"];
    }
    return _arrowView;
}

- (NSString *)titleText {
    return self.titleLabel.text;
}

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.titleLabel.textColor = titleColor;
 }

- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

@end
