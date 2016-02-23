//
//  DPSettingCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-30.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSettingCell.h"

@implementation DPSettingCell
@synthesize titleImageView = _titleImageView;
@synthesize titleLabel = _titleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = self.contentView;
        [view addSubview:self.titleImageView];
        [view addSubview:self.titleLabel];
        [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.width.equalTo(@24);
            make.centerY.equalTo(view);
            make.height.equalTo(@24);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleImageView.mas_right).offset(5);
            make.right.equalTo(view).offset(-70);
            make.top.equalTo(view).offset(5);
            make.centerY.equalTo(view);
        }];

        UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xe4e0d7)];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel).offset(-5);
            make.right.equalTo(view).offset(-10);
            make.bottom.equalTo(view);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)createRightImageView:(int)imageViewType {
    UIView *view = self.contentView;
    if (imageViewType == 0) {
        UIView *rightView = [UIView dp_viewWithColor:UIColorFromRGB(0xe67e22)];
        rightView.layer.cornerRadius = 12;
        [self.contentView addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.width.equalTo(@50);
            make.centerY.equalTo(view);
            make.height.equalTo(@25);
        }];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"设置";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor dp_flatWhiteColor];
        label.font = [UIFont dp_lightArialOfSize:13.0];
        [rightView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        return;
    }
    UIImageView *rightView = [[UIImageView alloc] initWithImage:dp_ResultImage(@"arrow_right.png")];
    rightView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.width.equalTo(@9);
        make.centerY.equalTo(view);
        make.height.equalTo(@13);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(0x5f5c48);
        _titleLabel.font = [UIFont dp_lightSystemFontOfSize:13];
    }
    return _titleLabel;
}
- (UIImageView *)titleImageView {
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.backgroundColor = [UIColor clearColor];
    }
    return _titleImageView;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
