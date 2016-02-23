//
//  DPHistoryTendencyCell.m
//  DacaiProject
//
//  Created by sxf on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPHistoryTendencyCell.h"

@interface DPHistoryTendencyCell () {
@private
    UILabel *_gameNameLab;
    UIImageView *_ballView;
    UILabel *_gameInfoLab;
}

@end

@implementation DPHistoryTendencyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  digitalType:(int)digitalType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        self.lotteryType=digitalType;
        [self buildLayout];
    }
    return self;
}

- (UILabel *)gameInfoLab {
    if (_gameInfoLab == nil) {
        _gameInfoLab = [[UILabel alloc] init];
        _gameInfoLab.numberOfLines = 1;
        _gameInfoLab.textColor = [UIColor dp_flatRedColor];
        _gameInfoLab.font = [UIFont dp_systemFontOfSize:11];
//        _gameInfoLab.font=[UIFont fontWithName:@"_typewriter" size:11.0];
        _gameInfoLab.backgroundColor = [UIColor clearColor];
        _gameInfoLab.textAlignment = NSTextAlignmentLeft;
        _gameInfoLab.lineBreakMode = NSLineBreakByWordWrapping;
//        _gameInfoLab.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
         _gameInfoLab.userInteractionEnabled=NO;
    }
    return _gameInfoLab;
}

- (UILabel *)gameNameLab {
    if (_gameNameLab == nil) {
        _gameNameLab = [[UILabel alloc] init];
        _gameNameLab.backgroundColor = [UIColor clearColor];
        _gameNameLab.font = [UIFont dp_systemFontOfSize:11];
        _gameNameLab.textAlignment = NSTextAlignmentRight;
        _gameNameLab.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _gameNameLab.highlightedTextColor = [UIColor dp_flatRedColor];
    }
    return _gameNameLab;
}

- (UIImageView *)ballView {
    if (_ballView == nil) {
        _ballView = [[UIImageView alloc] initWithImage:dp_DigitLotteryImage(@"ballHistoryBonus_01.png") highlightedImage:dp_DigitLotteryImage(@"ballHistoryBonus_02.png")];
    }
    return _ballView;
}

- (void)buildLayout {
    [self.contentView addSubview:self.gameNameLab];
    [self.contentView addSubview:self.ballView];
    [self.contentView addSubview:self.gameInfoLab];
   
    [self.gameNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
//        if (self.lotteryType==GameTypeJxsyxw) {
//            make.width.equalTo(self.contentView).multipliedBy(0.25);
//        }else{
//        make.width.equalTo(self.contentView).multipliedBy(0.15);
//        }
        
        
        make.centerY.equalTo(self.contentView);
    }];
    [self.ballView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameNameLab.mas_right).offset(5);
        make.width.equalTo(@8);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];

    [self.gameInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ballView.mas_right).offset(5);
        make.centerY.equalTo(self.contentView).offset(-1);
    }];
}

@end

@implementation DPQuick3HistoryCell
@synthesize issueLabel=_issueLabel,infoLabel=_infoLabel;
@synthesize dic1=_dic1,dic2=_dic2,dic3=_dic3;
@synthesize ballView=_ballView;
@synthesize bonuslabel=_bonuslabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self buildLayout];
    }
    return self;
}
-(void)buildLayout{
    UIView *contentView=self.contentView;
    [contentView addSubview:self.issueLabel];
    [contentView addSubview:self.infoLabel];
    [contentView addSubview:self.dic1];
    [contentView addSubview:self.dic2];
    [contentView addSubview:self.dic3];
    [contentView addSubview:self.ballView];
    [contentView addSubview:self.bonuslabel];
    [self.ballView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.width.equalTo(@4);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [self.issueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(4);
        make.width.equalTo(@40);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [self.dic1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.issueLabel.mas_right).offset(5);
        make.width.equalTo(@12.5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@12.5);
    }];
    [self.dic2 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.dic1.mas_right).offset(1);
        make.width.equalTo(@12.5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@12.5);
    }];
    [self.dic3 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.dic2.mas_right).offset(1);
        make.width.equalTo(@12.5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@12.5);
    }];
    [self.bonuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dic1).offset(-7);
        make.right.equalTo(self.dic3).offset(7);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@12.5);
    }];
    self.bonuslabel.hidden=YES;
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.dic3.mas_right).offset(10);
        make.width.equalTo(@200);
         make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

- (UILabel *)issueLabel {
    if (_issueLabel == nil) {
        _issueLabel = [[UILabel alloc] init];
        _issueLabel.backgroundColor = [UIColor clearColor];
        _issueLabel.font = [UIFont dp_systemFontOfSize:11];
        _issueLabel.textAlignment = NSTextAlignmentRight;
        _issueLabel.textColor = UIColorFromRGB(0xd4ec75);
        _issueLabel.highlightedTextColor = [UIColor dp_flatRedColor];
    }
    return _issueLabel;
}
- (UILabel *)bonuslabel {
    if (_bonuslabel == nil) {
        _bonuslabel = [[UILabel alloc] init];
        _bonuslabel.backgroundColor = [UIColor clearColor];
        _bonuslabel.font = [UIFont dp_systemFontOfSize:11];
        _bonuslabel.textAlignment = NSTextAlignmentRight;
        _bonuslabel.textColor = UIColorFromRGB(0xd4ec75);
        _bonuslabel.text=@"正在开奖..";
        _bonuslabel.highlightedTextColor = [UIColor dp_flatRedColor];
    }
    return _bonuslabel;
}
- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = UIColorFromRGB(0xd4ec75);
        _infoLabel.highlightedTextColor = [UIColor dp_flatRedColor];
    }
    return _infoLabel;
}
- (UIImageView *)dic1 {
    if (_dic1 == nil) {
        _dic1 = [[UIImageView alloc] init];
        _dic1.backgroundColor = [UIColor clearColor];
    }
    return _dic1;
}
- (UIImageView *)dic2 {
    if (_dic2 == nil) {
        _dic2 = [[UIImageView alloc] init];
        _dic2.backgroundColor = [UIColor clearColor];
    }
    return _dic2;
}
- (UIImageView *)dic3 {
    if (_dic3 == nil) {
        _dic3 = [[UIImageView alloc] init];
        _dic3.backgroundColor = [UIColor clearColor];
    }
    return _dic3;
}
- (UIImageView *)ballView {
    if (_ballView == nil) {
        _ballView = [[UIImageView alloc] initWithImage:dp_QuickThreeImage(@"q3HistoryLine.png") highlightedImage:dp_QuickThreeImage(@"q3HistoryLine.png")];
    }
    return _ballView;
}
@end
