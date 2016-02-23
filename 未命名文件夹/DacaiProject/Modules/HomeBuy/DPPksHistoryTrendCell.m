//
//  DPPksHistoryTrendCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPPksHistoryTrendCell.h"

@interface DPPksHistoryTrendCell () {
@private
    UILabel *_nameLabel;
    UILabel *_infoLabel;
    UILabel *_waitLabel;

    
    UILabel *_pokerLabel1;
    UILabel *_pokerLabel2;
    UILabel *_pokerLabel3;
}

@end

@implementation DPPksHistoryTrendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildLayout {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_PokerThreeImage(@"trendline.png")];
    
    UIView *contentView = self.contentView;
    
    [contentView addSubview:imageView];
    [contentView addSubview:self.nameLabel];
    [contentView addSubview:self.infoLabel];
    [contentView addSubview:self.pokerLabel1];
    [contentView addSubview:self.pokerLabel2];
    [contentView addSubview:self.pokerLabel3];
    [contentView addSubview:self.waitLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(contentView).offset(1);
        make.bottom.equalTo(contentView).offset(1);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.centerY.equalTo(contentView);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(170);
        make.centerY.equalTo(contentView);
    }];
    [self.pokerLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(65);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
        make.centerY.equalTo(contentView);
    }];
    [self.pokerLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pokerLabel1.mas_right).offset(6);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
        make.centerY.equalTo(contentView);
    }];
    [self.pokerLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pokerLabel2.mas_right).offset(6);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
        make.centerY.equalTo(contentView);
    }];
    
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(65);
        make.right.equalTo(self.pokerLabel3) ;
        make.height.equalTo(@15);
        make.centerY.equalTo(contentView);
    }];

}

#pragma mark - getter
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithRed:0.47 green:0.85 blue:1 alpha:1];
        _nameLabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _nameLabel;
}

- (UILabel *)waitLabel {
    if (_waitLabel == nil) {
        _waitLabel = [[UILabel alloc] init];
        _waitLabel.text = @"正在开奖..." ;
        _waitLabel.textAlignment = NSTextAlignmentLeft ;
        _waitLabel.backgroundColor = [UIColor clearColor];
        _waitLabel.textColor = [UIColor colorWithRed:0.47 green:0.85 blue:1 alpha:1];
        _waitLabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _waitLabel;
}


- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = [UIColor colorWithRed:0.47 green:0.85 blue:1 alpha:1];
        _infoLabel.font = [UIFont dp_systemFontOfSize:11.5];
    }
    return _infoLabel;
}

- (UILabel *)pokerLabel1 {
    if (_pokerLabel1 == nil) {
        _pokerLabel1 = [[UILabel alloc] init];
        _pokerLabel1.backgroundColor = [UIColor dp_flatWhiteColor];//[UIColor colorWithRed:0.98 green:0.96 blue:0.91 alpha:1];
        _pokerLabel1.clipsToBounds = YES;
        _pokerLabel1.layer.cornerRadius = 2;
        _pokerLabel1.font = [UIFont fontWithName:@"Times New Roman" size:11.5];
    }
    return _pokerLabel1;
}

- (UILabel *)pokerLabel2 {
    if (_pokerLabel2 == nil) {
        _pokerLabel2 = [[UILabel alloc] init];
        _pokerLabel2.backgroundColor = [UIColor dp_flatWhiteColor];//[UIColor colorWithRed:0.98 green:0.96 blue:0.91 alpha:1];
        _pokerLabel2.clipsToBounds = YES;
        _pokerLabel2.layer.cornerRadius = 2;
        _pokerLabel2.font = [UIFont fontWithName:@"Times New Roman" size:11.5];
    }
    return _pokerLabel2;
}

- (UILabel *)pokerLabel3 {
    if (_pokerLabel3 == nil) {
        _pokerLabel3 = [[UILabel alloc] init];
        _pokerLabel3.backgroundColor = [UIColor dp_flatWhiteColor];//[UIColor colorWithRed:0.98 green:0.96 blue:0.91 alpha:1];
        _pokerLabel3.clipsToBounds = YES;
        _pokerLabel3.layer.cornerRadius = 2;
        _pokerLabel3.font = [UIFont fontWithName:@"Times New Roman" size:11.5];
    }
    return _pokerLabel3;
}

@end
