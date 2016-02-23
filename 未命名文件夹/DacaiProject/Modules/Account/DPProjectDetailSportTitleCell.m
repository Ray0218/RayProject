//
//  DPProjectDetailSportTitleCell.m
//  DacaiProject
//
//  Created by sxf on 14-9-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailSportTitleCell.h"

@implementation DPProjectDetailSportTitleCell

+ (CGFloat)heightWithPassMode:(NSString *)passMode {
    CGFloat height = 25 - 13 + [passMode sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(245, 10000) lineBreakMode:NSLineBreakByWordWrapping].height;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self buildLayout];
    }
    return self;
}
- (void)buildLayout {
    UIView *contentView = self.contentView;

    UILabel *label = [[UILabel alloc] init];
    label.text = @"过关方式:";
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB(0x948f89);
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];

    UILabel *passModeLabel = [[UILabel alloc] init];
    passModeLabel.backgroundColor = [UIColor clearColor];
    passModeLabel.textColor = UIColorFromRGB(0x282828);
    passModeLabel.font = [UIFont systemFontOfSize:12];
    passModeLabel.numberOfLines = 0;
    passModeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [contentView addSubview:passModeLabel];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.width.equalTo(@65);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [passModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];

    self.passModeLabel = passModeLabel;
}

- (void)setPassMode:(NSString *)passMode {
    self.passModeLabel.text = passMode;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
