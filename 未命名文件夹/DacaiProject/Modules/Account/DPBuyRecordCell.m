//
//  DPBuyRecordCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBuyRecordCell.h"

@interface DPBuyRecordCell () {
@private
    UIView              *_colorLine;
    UIImageView         *_clockView;
    UILabel             *_monthLabel;
    UILabel             *_dayLabel;
    UILabel             *_timeLabel;
    UILabel             *_buyTypeLabel;
    UIImageView         *_sealView;
    TTTAttributedLabel  *_attrTitleLabel;
    TTTAttributedLabel  *_attrAmtLabel;
    TTTAttributedLabel  *_attrStatusLabel;
    TTTAttributedLabel  *_attrScheduleLabel; 
    UILabel             *_guaranteedLabel;
}

@end

@implementation DPBuyRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self.contentView;
    
    UIImageView *arrowView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"arrow_right_brown.png")];
        imageView;
    });
    UILabel *rmbLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"元";
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    
    [contentView addSubview:self.colorLine];
    [contentView addSubview:self.clockView];
    [contentView addSubview:self.monthLabel];
    [contentView addSubview:self.dayLabel];
    [contentView addSubview:self.timeLabel];
    [contentView addSubview:self.buyTypeLabel];
    [contentView addSubview:self.attrTitleLabel];
    [contentView addSubview:self.attrAmtLabel];
    [contentView addSubview:self.attrStatusLabel];
    [contentView addSubview:self.attrScheduleLabel];
    [contentView addSubview:self.guaranteedLabel];
    [contentView addSubview:arrowView];
    [contentView addSubview:rmbLabel];
    [contentView addSubview:self.sealView];
    
    [self.colorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@4);
    }];
    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.width.equalTo(@12);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorLine.mas_right);
        make.width.equalTo(@30);
        make.bottom.equalTo(contentView.mas_centerY);
        make.height.equalTo(@13);
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorLine.mas_right);
        make.width.equalTo(@29);
        make.top.equalTo(contentView.mas_centerY);
        make.height.equalTo(@20);
    }];
    [self.attrTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clockView.mas_right);
        make.centerY.equalTo(self.monthLabel);
    }];
    [self.attrAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(rmbLabel.mas_left);
    }];
    [self.attrStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(arrowView.mas_left).offset(-2);
    }];
    [self.attrScheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView).offset(-3);
        make.right.equalTo(arrowView.mas_left).offset(-2);
    }];
    [self.guaranteedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.attrScheduleLabel.mas_bottom).offset(-2);
        make.centerX.equalTo(self.attrScheduleLabel);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clockView.mas_right);
        make.centerY.equalTo(self.dayLabel);
        make.width.equalTo(@32);
    }];
    [self.buyTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.centerY.equalTo(self.timeLabel);
    }];
    [self.sealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.centerX.equalTo(contentView).offset(70);
    }];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-2);
    }];
    [rmbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX).offset(40);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
}

#pragma mark - getter
- (UIView *)colorLine {
    if (_colorLine == nil) {
        _colorLine = [[UIView alloc] init];
    }
    
    return _colorLine;
}

- (UIImageView *)clockView {
    if (_clockView == nil) {
        _clockView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"unwinclock.png") highlightedImage:dp_AccountImage(@"winclock.png")];
    }
    return _clockView;
}

- (UILabel *)monthLabel {
    if (_monthLabel == nil) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.backgroundColor = [UIColor clearColor];
        _monthLabel.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.37 alpha:1];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
//        _monthLabel.font = [UIFont dp_regularArialOfSize:10];
        _monthLabel.font = [UIFont dp_systemFontOfSize:10.5];
    }
    return _monthLabel;
}

- (UILabel *)dayLabel {
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.backgroundColor = [UIColor clearColor];
        _dayLabel.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.37 alpha:1];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont dp_regularArialOfSize:18];
        _dayLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _dayLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.37 alpha:1];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont dp_systemFontOfSize:10.5];
    }
    return _timeLabel;
}

- (UILabel *)buyTypeLabel {
    if (_buyTypeLabel == nil) {
        _buyTypeLabel = [[UILabel alloc] init];
        _buyTypeLabel.backgroundColor = [UIColor clearColor];
        _buyTypeLabel.textColor = [UIColor colorWithRed:0.43 green:0.36 blue:0.23 alpha:1];
        _buyTypeLabel.textAlignment = NSTextAlignmentLeft;
        _buyTypeLabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _buyTypeLabel;
}

- (UIImageView *)sealView {
    if (_sealView == nil) {
        _sealView = [[UIImageView alloc] initWithImage:dp_ProjectImage(@"unwinseal.png") highlightedImage:dp_ProjectImage(@"winseal.png")];
    }
    return _sealView;
}

- (TTTAttributedLabel *)attrTitleLabel {
    if (_attrTitleLabel == nil) {
        _attrTitleLabel = [[TTTAttributedLabel alloc] init];
        _attrTitleLabel.backgroundColor = [UIColor clearColor];
        _attrTitleLabel.textColor = [UIColor dp_flatBlackColor];
        _attrTitleLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _attrTitleLabel;
}

- (TTTAttributedLabel *)attrAmtLabel {
    if (_attrAmtLabel == nil) {
        _attrAmtLabel = [[TTTAttributedLabel alloc] init];
        _attrAmtLabel.backgroundColor = [UIColor clearColor];
        _attrAmtLabel.font = [UIFont dp_regularArialOfSize:14];
        _attrAmtLabel.textColor = [UIColor dp_flatRedColor];
    }
    return _attrAmtLabel;
}

- (TTTAttributedLabel *)attrStatusLabel {
    if (_attrStatusLabel == nil) {
        _attrStatusLabel = [[TTTAttributedLabel alloc] init];
        _attrStatusLabel.backgroundColor = [UIColor clearColor];
        _attrStatusLabel.font = [UIFont dp_systemFontOfSize:13];
        _attrStatusLabel.textColor = [UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1];
        _attrStatusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _attrStatusLabel;
}

- (TTTAttributedLabel *)attrScheduleLabel {
    if (_attrScheduleLabel == nil) {
        _attrScheduleLabel = [[TTTAttributedLabel alloc] init];
        _attrScheduleLabel.backgroundColor = [UIColor clearColor];
        _attrScheduleLabel.font = [UIFont dp_regularArialOfSize:25];
        _attrScheduleLabel.textColor = [UIColor dp_flatRedColor];
        _attrScheduleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _attrScheduleLabel;
}

- (UILabel *)guaranteedLabel {
    if (_guaranteedLabel == nil) {
        _guaranteedLabel = [[UILabel alloc] init];
        _guaranteedLabel.backgroundColor = [UIColor clearColor];
        _guaranteedLabel.textAlignment = NSTextAlignmentCenter;
        _guaranteedLabel.font = [UIFont dp_systemFontOfSize:8];
        _guaranteedLabel.textColor = [UIColor dp_flatRedColor];
    }
    return _guaranteedLabel;
}

@end
