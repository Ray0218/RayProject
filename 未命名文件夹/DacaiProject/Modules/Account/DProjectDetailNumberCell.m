//
//  DProjectDetailNumberCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DProjectDetailNumberCell.h"

@implementation DProjectDetailNumberCell
@synthesize titleLabel = _titleLabel;
@synthesize infoLabel = _infoLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = self.contentView;
        [view addSubview:self.titleLabel];
        [view addSubview:self.infoLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.right.equalTo(view).offset(-10);
            make.top.equalTo(view);
            make.height.equalTo(@20);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.right.equalTo(view).offset(-10);
            make.bottom.equalTo(view);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(-5);
        }];

        UIImageView *waveLine = [[UIImageView alloc] init];
        waveLine.backgroundColor = [UIColor clearColor];
        waveLine.image = dp_ProjectImage(@"maginaryline.png");
        self.waveView = waveLine;
//        self.waveView.hidden = YES;
        [view addSubview:waveLine];

        [waveLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.right.equalTo(view);
            make.bottom.equalTo(view).offset(-2);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)changeWaveViewBottom:(float)bottomHeight {
    [self.contentView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.waveView && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = bottomHeight;
            *stop = YES;
        }
    }];
}
#pragma mark--getter,setter
- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _infoLabel.textColor = UIColorFromRGB(0x8c8172);
        _infoLabel.numberOfLines = 9999;
//        _infoLabel.lineSpacing = 5;
        _infoLabel.textAlignment = NSTextAlignmentLeft;
         _infoLabel.userInteractionEnabled=NO;
    }
    return _infoLabel;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x948f89);
        _titleLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
