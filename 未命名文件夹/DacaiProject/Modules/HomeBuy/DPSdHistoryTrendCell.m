//
//  DPSdHistoryTrendCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSdHistoryTrendCell.h"

@interface DPSdHistoryTrendCell () {
@private
    UILabel *_issueLabel;
    UIImageView *_pointView;
    UILabel *_drawedLabel;
    UILabel *_shapeLabel;
    UILabel *_tryLabel;
}

@end
@implementation DPSdHistoryTrendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildLayout];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.issueLabel];
    [contentView addSubview:self.pointView];
    [contentView addSubview:self.drawedLabel];
    [contentView addSubview:self.shapeLabel];
    [contentView addSubview:self.tryLabel];
    
    [self.issueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@50);
    }];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(self.issueLabel.mas_right);
        make.width.equalTo(@8);
        make.height.equalTo(@25);
    }];
    [self.drawedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(self.pointView.mas_right).offset(10);
    }];
    [self.shapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX);
    }];
    [self.tryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX).offset(40);
    }];
}

#pragma mark - getter
- (UILabel *)issueLabel {
    if (_issueLabel == nil) {
        _issueLabel = [[UILabel alloc] init];
        _issueLabel.backgroundColor = [UIColor clearColor];
        _issueLabel.font = [UIFont dp_systemFontOfSize:11];
        _issueLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _issueLabel.highlightedTextColor = [UIColor dp_flatRedColor];
        _issueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _issueLabel;
}

- (UIImageView *)pointView {
    if (_pointView == nil) {
        _pointView = [[UIImageView alloc] initWithImage:dp_DigitLotteryImage(@"ballHistoryBonus_01.png") highlightedImage:dp_DigitLotteryImage(@"ballHistoryBonus_02.png")];
    }
    return _pointView;
}

- (UILabel *)drawedLabel {
    if (_drawedLabel == nil) {
        _drawedLabel = [[UILabel alloc] init];
        _drawedLabel.backgroundColor = [UIColor clearColor];
        _drawedLabel.font = [UIFont dp_systemFontOfSize:11];
        _drawedLabel.textColor = [UIColor dp_flatRedColor];
    }
    return _drawedLabel;
}

- (UILabel *)shapeLabel {
    if (_shapeLabel == nil) {
        _shapeLabel = [[UILabel alloc] init];
        _shapeLabel.backgroundColor = [UIColor clearColor];
        _shapeLabel.font = [UIFont dp_systemFontOfSize:11];
        _shapeLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    }
    return _shapeLabel;
}

- (UILabel *)tryLabel {
    if (_tryLabel == nil) {
        _tryLabel = [[UILabel alloc] init];
        _tryLabel.backgroundColor = [UIColor clearColor];
        _tryLabel.font = [UIFont dp_systemFontOfSize:11];
        _tryLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    }
    return _tryLabel;
}

@end
