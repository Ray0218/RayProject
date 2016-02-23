//
//  DPProjectDetailontentZCCell.m
//  DacaiProject
//
//  Created by sxf on 14-9-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailontentZCCell.h"

@implementation DPProjectDetailontentZCCell
@synthesize changLabel = _changLabel;
@synthesize homeLabel = _homeLabel, awaylabel = _awaylabel;
@synthesize optionLabel = _optionLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize resultlabel = _resultlabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [UIView dp_viewWithColor:[UIColor whiteColor]];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@25);
        }];
        [view addSubview:self.changLabel];
        [view addSubview:self.homeLabel];
        [view addSubview:self.awaylabel];
        [view addSubview:self.scoreLabel];
        [view addSubview:self.resultlabel];
        [view addSubview:self.optionLabel];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"VS";
        label.font = [UIFont dp_regularArialOfSize:12.0];
        label.textColor = [UIColor dp_flatRedColor];
        [view addSubview:label];

        [self.changLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.width.equalTo(@30);
            make.top.equalTo(view);
            make.height.equalTo(@25);
        }];
        [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.changLabel.mas_right);
            make.width.equalTo(@55);
            make.top.equalTo(view);
            make.height.equalTo(@25);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.homeLabel.mas_right);
            make.width.equalTo(@20);
            make.top.equalTo(view);
            make.height.equalTo(@25);
        }];
        [self.awaylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.width.equalTo(@55);
            make.top.equalTo(view);
            make.height.equalTo(@25);
        }];
        [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.awaylabel.mas_right);
            make.width.equalTo(@65);
            make.top.equalTo(view);
            make.height.equalTo(@25);
        }];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.optionLabel.mas_right);
            make.width.equalTo(@45);
            make.top.equalTo(view);
            make.height.equalTo(@25);
        }];
        [self.resultlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scoreLabel.mas_right);
            make.right.equalTo(view).offset(-5);
            make.top.equalTo(view);
            make.height.equalTo(@25);
        }];
        UIView *hline = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
        [self.contentView addSubview:hline];
        UIView *vline1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
        [self.contentView addSubview:vline1];
        UIView *vline2 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
        [self.contentView addSubview:vline2];
        UIView *vline3 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
        [self.contentView addSubview:vline3];
        UIView *vline4 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
        [self.contentView addSubview:vline4];
        UIView *vline5 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
        [self.contentView addSubview:vline5];
        UIView *vline6 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
        [self.contentView addSubview:vline6];

        [hline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.right.equalTo(view);
            make.height.equalTo(@0.5);
            make.top.equalTo(view);
        }];

        [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.width.equalTo(@0.5);
            make.bottom.equalTo(view);
            make.top.equalTo(view);
        }];
        [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.homeLabel);
            make.width.equalTo(@0.5);
            make.bottom.equalTo(view);
            make.top.equalTo(view);
        }];
        [vline3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.optionLabel);
            make.width.equalTo(@0.5);
            make.bottom.equalTo(view);
            make.top.equalTo(view);
        }];
        [vline4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scoreLabel);
            make.width.equalTo(@0.5);
            make.bottom.equalTo(view);
            make.top.equalTo(view);
        }];
        [vline5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.resultlabel);
            make.width.equalTo(@0.5);
            make.bottom.equalTo(view);
            make.top.equalTo(view);
        }];
        [vline6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view);
            make.width.equalTo(@0.5);
            make.bottom.equalTo(view);
            make.top.equalTo(view);
        }];
    }
    return self;
}

- (UILabel *)changLabel {
    if (_changLabel == nil) {
        _changLabel = [[UILabel alloc] init];
        _changLabel.backgroundColor = [UIColor clearColor];
        _changLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _changLabel.text = @"--";
        _changLabel.textColor = UIColorFromRGB(0x333333);
        _changLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changLabel;
}
- (UILabel *)homeLabel {
    if (_homeLabel == nil) {
        _homeLabel = [[UILabel alloc] init];
        _homeLabel.backgroundColor = [UIColor clearColor];
        _homeLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _homeLabel.text = @"--";
        _homeLabel.textColor = UIColorFromRGB(0x333333);
        _homeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _homeLabel;
}
- (UILabel *)awaylabel {
    if (_awaylabel == nil) {
        _awaylabel = [[UILabel alloc] init];
        _awaylabel.backgroundColor = [UIColor clearColor];
        _awaylabel.font = [UIFont dp_regularArialOfSize:12.0];
        _awaylabel.text = @"--";
        _awaylabel.textColor = UIColorFromRGB(0x333333);
        _awaylabel.textAlignment = NSTextAlignmentCenter;
    }
    return _awaylabel;
}
- (UILabel *)scoreLabel {
    if (_scoreLabel == nil) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.font = [UIFont dp_regularArialOfSize:12.0];
        _scoreLabel.text = @"--";
        _scoreLabel.textColor = UIColorFromRGB(0x333333);
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLabel;
}
- (UILabel *)resultlabel {
    if (_resultlabel == nil) {
        _resultlabel = [[UILabel alloc] init];
        _resultlabel.backgroundColor = [UIColor clearColor];
        _resultlabel.font = [UIFont dp_regularArialOfSize:12.0];
        _resultlabel.text = @"--";
        _resultlabel.textColor = [UIColor dp_flatRedColor];
        _resultlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultlabel;
}
- (TTTAttributedLabel *)optionLabel {
    if (_optionLabel == nil) {
        _optionLabel = [[TTTAttributedLabel alloc] init];
        _optionLabel.backgroundColor = [UIColor clearColor];
        _optionLabel.font = [UIFont dp_regularArialOfSize:14];
        _optionLabel.textAlignment = NSTextAlignmentCenter;
        _optionLabel.textColor = [UIColor dp_flatRedColor];
        _optionLabel.userInteractionEnabled=NO;
    }
    return _optionLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
