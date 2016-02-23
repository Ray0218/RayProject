//
//  DPProjectDetailWInNumberCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailWInNumberCell.h"
@implementation DPProjectDetailWInNumberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier lotteryType:(int)lotteryType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.gameType = lotteryType;
        // Initialization code
        [self bulidLayout];
    }
    return self;
}
- (void)bulidLayout {
    UIView *contentView = self.contentView;
    UILabel *label1 = [[UILabel alloc] init];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"开奖号码：";
    label1.font = [UIFont dp_systemFontOfSize:12.0];
    label1.textColor = UIColorFromRGB(0x282828);
    [contentView addSubview:label1];

    UILabel *label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"中奖情况：";
    label2.font = [UIFont dp_systemFontOfSize:12.0];
    label2.textColor = UIColorFromRGB(0x282828);
    [contentView addSubview:label2];

    UILabel *label3 = [[UILabel alloc] init];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"命中四注";
    self.bonusInfo = label3;
    label3.numberOfLines = 0;
    label3.font = [UIFont dp_systemFontOfSize:12.0];
    label3.textColor = UIColorFromRGB(0x282828);
    [contentView addSubview:label3];

    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@60);
        make.top.equalTo(contentView).offset(10);
        make.height.equalTo(@20);
    }];

    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@60);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];

    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(label2);
        make.bottom.equalTo(label2);
    }];

    self.resultView = [[DProjectDetailNumberResultView alloc] initWithGameTypeId:self.gameType];
    [contentView addSubview:self.resultView];
    self.resultView.backgroundColor = [UIColor clearColor];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(label1);
        make.bottom.equalTo(label1);
    }];
    UIView *vLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
    [self.contentView addSubview:vLine];

    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.top.equalTo(self.contentView);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
