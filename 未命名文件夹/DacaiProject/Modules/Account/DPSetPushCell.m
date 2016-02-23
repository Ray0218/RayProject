//
//  DPSetPushCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-30.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSetPushCell.h"

@implementation DPSetPushCell
@synthesize titleImageView = _titleImageView;
@synthesize topTitleLabel = _topTitleLabel;
@synthesize bottomTitleLabel = _bottomTitleLabel;
@synthesize sevSwitch = _sevSwitch;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexpath;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = self.contentView;
        [view addSubview:self.titleImageView];
        [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.width.equalTo(@24);
            make.centerY.equalTo(view);
            make.height.equalTo(@24);
        }];

        [view addSubview:self.topTitleLabel];
        [view addSubview:self.sevSwitch];
        [self.sevSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.width.equalTo(@51);
            make.centerY.equalTo(view);
            make.height.equalTo(@22);
        }];
        UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xe4e0d7)];
        [view addSubview:lineView];

        if (indexpath.section == 0) {
            view.backgroundColor = [UIColor clearColor];
            [view addSubview:self.bottomTitleLabel];
            [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleImageView.mas_right).offset(5);
                make.right.equalTo(view).offset(-70);
                make.top.equalTo(view).offset(8);
                make.height.equalTo(@20);
            }];
            [self.bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.topTitleLabel);
                make.right.equalTo(self.topTitleLabel);
                make.top.equalTo(self.topTitleLabel.mas_bottom).offset(-3);
                make.height.equalTo(@20);
            }];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(10);
                make.right.equalTo(view).offset(-10);
                make.bottom.equalTo(view);
                make.height.equalTo(@0.5);
            }];
            return self;
        }
        view.backgroundColor = UIColorFromRGB(0xffffff);
        [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleImageView.mas_right).offset(5);
            make.right.equalTo(view).offset(-70);
            make.top.equalTo(view);
            make.centerY.equalTo(view);
        }];
        self.bottomTitleLabel.hidden = YES;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topTitleLabel).offset(-5);
            make.right.equalTo(view).offset(-10);
            make.bottom.equalTo(view);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIImageView *)titleImageView {
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.backgroundColor = [UIColor clearColor];
    }
    return _titleImageView;
}

- (UILabel *)topTitleLabel {
    if (_topTitleLabel == nil) {
        _topTitleLabel = [[UILabel alloc] init];
        _topTitleLabel.backgroundColor = [UIColor clearColor];
        _topTitleLabel.textAlignment = NSTextAlignmentLeft;
        _topTitleLabel.textColor = UIColorFromRGB(0x5f5c48);
        _topTitleLabel.font = [UIFont dp_lightSystemFontOfSize:13];
    }
    return _topTitleLabel;
}

- (UILabel *)bottomTitleLabel {
    if (_bottomTitleLabel == nil) {
        _bottomTitleLabel = [[UILabel alloc] init];
        _bottomTitleLabel.backgroundColor = [UIColor clearColor];
        _bottomTitleLabel.textAlignment = NSTextAlignmentLeft;
        _bottomTitleLabel.textColor = UIColorFromRGB(0xbbb19e);
        _bottomTitleLabel.font = [UIFont dp_lightSystemFontOfSize:11];
    }
    return _bottomTitleLabel;
}

- (SevenSwitch *)sevSwitch {
    if (_sevSwitch == nil) {
        _sevSwitch = [[SevenSwitch alloc] init];
        _sevSwitch.inactiveColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _sevSwitch.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _sevSwitch.onTintColor = [UIColor dp_flatRedColor];
        _sevSwitch.onImage = [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"yilouOpen.png")];
        _sevSwitch.offImage = [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"yilouClose.png")];
        [_sevSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _sevSwitch;
}

- (void)switchAction:(SevenSwitch *)sevenSwitch {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(pushViewSwitchClick:)]) {
        [self.delegate pushViewSwitchClick:self];
    }
}

@end
