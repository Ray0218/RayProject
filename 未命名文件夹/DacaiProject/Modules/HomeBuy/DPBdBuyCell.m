//
//  DPBdBuyCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBdBuyCell.h"
#import "DPBetToggleControl.h"

@interface DPBdBuyCell () {
@private
    UIView *_infoView;
    UIView *_titleView;
    UIView *_optionView;
    
    UILabel *_competitionLabel;
    UILabel *_orderNameLabel;
    UILabel *_matchDateLabel;
    UIImageView *_analysisView;
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_homeRankLabel;
    UILabel *_awayRankLabel;
    UILabel *_middleLabel;
    
    UILabel *_optionLabel;
    
    NSArray *_optionButtonRqspf;
    NSArray *_optionButtonSxds;
    NSArray *_optionButtonZjq;
}

@property (nonatomic, strong, readonly) UIView *infoView;
@property (nonatomic, strong, readonly) UIView *titleView;
@property (nonatomic, strong, readonly) UIView *optionView;

- (void)infoBuildLayout;
- (void)titleBuildLayout;

- (void)rqspfBuildLayout;
- (void)sxdsBuildLayout;
- (void)zjqBuildLayout;
- (void)bfBuildLayout;
- (void)bqcBuildLayout;

@end

@implementation DPBdBuyCell

- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = self.contentView;
    UIView *line = [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.88 alpha:1]];
    
    [contentView addSubview:self.infoView];
    [contentView addSubview:self.titleView];
    [contentView addSubview:self.optionView];
    [contentView addSubview:line];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(contentView).multipliedBy(0.20);
    }];
    if(self.gameType!=GameTypeBdZjq){
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView.mas_right);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView).offset(13);
            make.height.equalTo(@15);
        }];
    }else{
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView.mas_right);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.height.equalTo(@23);
        }];
    }
    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView.mas_right);
        make.right.equalTo(contentView);
        make.top.equalTo(self.titleView.mas_bottom).offset(1);
        make.bottom.equalTo(contentView).offset(-3);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self infoBuildLayout];
    [self titleBuildLayout];
    
    switch (self.gameType) {
        case GameTypeBdRqspf:
            [self rqspfBuildLayout];
            break;
        case GameTypeBdSxds:
            [self sxdsBuildLayout];
            break;
        case GameTypeBdZjq:
            [self zjqBuildLayout];
            break;
        case GameTypeBdBf:
            [self bfBuildLayout];
            break;
        case GameTypeBdBqc:
            [self bqcBuildLayout];
            break;
        default:
            break;
    }
    
    [self.infoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMatchInfo)]];
}

/**
 *  左侧视图
 */
- (void)infoBuildLayout {
    UIView *contentView = self.infoView;
    
    [contentView addSubview:self.competitionLabel];
    [contentView addSubview:self.orderNameLabel];
    [contentView addSubview:self.matchDateLabel];
    [contentView addSubview:self.analysisView];
    
    [self.competitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderNameLabel.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_centerY);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.matchDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.analysisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.matchDateLabel.mas_bottom).offset(5);
    }];
}

/**
 *  顶部视图
 */
- (void)titleBuildLayout {
    UIView *contentView = self.titleView;
    
    [contentView addSubview:self.middleLabel];
    [contentView addSubview:self.homeNameLabel];
    [contentView addSubview:self.awayNameLabel];
    [contentView addSubview:self.homeRankLabel];
    [contentView addSubview:self.awayRankLabel];
    
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView).offset(-10);
        make.bottom.equalTo(contentView);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.middleLabel.mas_left).offset(-15);
        make.bottom.equalTo(contentView);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleLabel.mas_right).offset(15);
        make.bottom.equalTo(contentView);
    }];
    
    
    [self.homeRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.homeNameLabel.mas_left);
        make.bottom.equalTo(contentView).offset(-1.5);
    }];
    [self.awayRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayNameLabel.mas_right);
        make.bottom.equalTo(contentView).offset(-1.5);
    }];
}

/**
 *  让球胜平负布局
 */
- (void)rqspfBuildLayout {
    UIView *contentView = self.optionView;
    
    DPBetToggleControl *winButton = [DPBetToggleControl horizontalControl];
    DPBetToggleControl *tieButton = [DPBetToggleControl horizontalControl];
    DPBetToggleControl *loseButton = [DPBetToggleControl horizontalControl];
    [winButton setShowBorderWhenSelected:YES];
    [winButton setTitleText:@"胜"];
    [winButton setTag:self.gameType << 16 | 0];
    [winButton addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    [tieButton setShowBorderWhenSelected:YES];
    [tieButton setTitleText:@"平"];
    [tieButton setTag:self.gameType << 16 | 1];
    [tieButton addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    [loseButton setShowBorderWhenSelected:YES];
    [loseButton setTitleText:@"负"];
    [loseButton setTag:self.gameType << 16 | 2];
    [loseButton addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:winButton];
    [contentView addSubview:tieButton];
    [contentView addSubview:loseButton];
    
    [tieButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contentView);
        make.height.equalTo(@32);
        make.width.equalTo(contentView).multipliedBy(0.3);
    }];
    [winButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.height.equalTo(@32);
        make.width.equalTo(tieButton);
        make.right.equalTo(tieButton.mas_left).offset(1);
    }];
    [loseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.height.equalTo(@32);
        make.width.equalTo(tieButton);
        make.left.equalTo(tieButton.mas_right).offset(-1);
    }];
    
    _optionButtonRqspf = @[winButton, tieButton, loseButton];
}

/**
 *  上下单双布局
 */
- (void)sxdsBuildLayout {
    static NSString *const sxdsNames[] = {@"上单", @"上双", @"下单", @"下双"};
    
    UIView *contentView = self.optionView;
    
    _optionButtonSxds = @[[DPBetToggleControl horizontalControl2], [DPBetToggleControl horizontalControl2], [DPBetToggleControl horizontalControl2], [DPBetToggleControl horizontalControl2]];
    
    for (int i = 0; i < _optionButtonSxds.count; i++) {
        DPBetToggleControl *control = _optionButtonSxds[i];
        [control setShowBorderWhenSelected:YES];
        [control setTitleText:sxdsNames[i]];
        [control setTag:self.gameType << 16 | i];
        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:control];
        
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView);
            make.height.equalTo(@32);
            make.width.equalTo(contentView).multipliedBy(0.242);
            
            if (i == 0) {
                make.left.equalTo(contentView);
            }
        }];
    }
    
    [_optionButtonSxds dp_enumeratePairsUsingBlock:^(DPBetToggleControl *obj1, NSUInteger idx1, DPBetToggleControl *obj2, NSUInteger idx2, BOOL *stop) {
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj1.mas_right).offset(-1);
        }];
    }];
}

/**
 *  总进球布局
 */
- (void)zjqBuildLayout {
    static NSString *const zjqNames[] = {@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7+"};
    
    UIView *contentView = self.optionView;
    
    _optionButtonZjq = @[[DPBetToggleControl horizontalControl],
                         [DPBetToggleControl horizontalControl],
                         [DPBetToggleControl horizontalControl],
                         [DPBetToggleControl horizontalControl],
                         [DPBetToggleControl horizontalControl],
                         [DPBetToggleControl horizontalControl],
                         [DPBetToggleControl horizontalControl],
                         [DPBetToggleControl horizontalControl2]];
    
    for (int i = 0; i < _optionButtonZjq.count; i++) {
        DPBetToggleControl *control = _optionButtonZjq[i];
        
        [control setTitleText:zjqNames[i]];
        [control setTag:self.gameType << 16 | i];
        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:control];
        
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
        }];
    }
    
    for (int i = 0; i < 3; i++) {
        [_optionButtonZjq[i + 1] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((DPBetToggleControl *)_optionButtonZjq[i]).mas_right).offset(2);
            make.centerY.equalTo(_optionButtonZjq[i]);
            make.width.equalTo(_optionButtonZjq[0]);
        }];
        [_optionButtonZjq[i + 5] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((DPBetToggleControl *)_optionButtonZjq[i + 4]).mas_right).offset(2);
            make.centerY.equalTo(_optionButtonZjq[i + 4]);
            make.width.equalTo(_optionButtonZjq[0]);
        }];
    }
    
    [_optionButtonZjq[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(contentView).offset(3);
        make.width.equalTo(contentView).multipliedBy(0.24);
    }];
    [_optionButtonZjq[4] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(((DPBetToggleControl *)_optionButtonZjq[0]).mas_bottom).offset(2);
        make.width.equalTo(_optionButtonZjq[0]);
    }];
}

/**
 *  比分布局
 */
- (void)bfBuildLayout {
    UIView *contentView = self.optionView;
    [contentView addSubview:self.optionLabel];
    
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView).offset(7);
        make.width.equalTo(@235);
    }];
}

/**
 *  半全场布局
 */
- (void)bqcBuildLayout {
    UIView *contentView = self.optionView;
    [contentView addSubview:self.optionLabel];
    
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView).offset(7);
        make.width.equalTo(contentView).multipliedBy(0.9);
    }];
}

#pragma mark - event

- (void)pvt_onBet:(DPBetToggleControl *)sender {
    sender.selected = !sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bdBuyCell:gameType:index:selected:)]) {
        [self.delegate bdBuyCell:self gameType:((sender.tag & 0xFFFF0000) >> 16) index:(sender.tag & 0x0000FFFF) selected:sender.selected];
    }
}

- (void)pvt_onMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreBdBuyCell:)]) {
        [self.delegate moreBdBuyCell:self];
    }
}

- (void)pvt_onMatchInfo {
    if ([self.delegate respondsToSelector:@selector(bdBuyCellInfo:)]) {
        [self.delegate bdBuyCellInfo:self];
    }
}
-(void)analysisViewIsExpand:(BOOL)isExpand{
    self.analysisView.highlighted=!isExpand;
}
#pragma mark - getter

- (UILabel *)optionLabel {
    if (_optionLabel == nil) {
        _optionLabel = [[UILabel alloc] init];
        _optionLabel.backgroundColor = [UIColor whiteColor];
        _optionLabel.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;
        _optionLabel.layer.borderWidth = 1;
        _optionLabel.textColor = [UIColor dp_flatBlackColor];
        _optionLabel.font = [UIFont dp_systemFontOfSize:14];
        _optionLabel.textAlignment = NSTextAlignmentCenter;
        _optionLabel.userInteractionEnabled = YES;
        _optionLabel.highlightedTextColor = [UIColor dp_flatRedColor];
        _optionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [_optionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMore)]];
    }
    return _optionLabel;
}

- (UIView *)infoView {
    if (_infoView == nil) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = [UIColor clearColor];
    }
    return _infoView;
}

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}

- (UIView *)optionView {
    if (_optionView == nil) {
        _optionView = [[UIView alloc] init];
        _optionView.backgroundColor = [UIColor clearColor];
    }
    return _optionView;
}

- (UILabel *)competitionLabel {
    if (_competitionLabel == nil) {
        _competitionLabel = [[UILabel alloc] init];
        _competitionLabel.backgroundColor = [UIColor clearColor];
        _competitionLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _competitionLabel.textAlignment = NSTextAlignmentCenter;
        _competitionLabel.font = [UIFont dp_systemFontOfSize:11];
    }
    return _competitionLabel;
}

- (UILabel *)orderNameLabel {
    if (_orderNameLabel == nil) {
        _orderNameLabel = [[UILabel alloc] init];
        _orderNameLabel.backgroundColor = [UIColor clearColor];
        _orderNameLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _orderNameLabel.textAlignment = NSTextAlignmentCenter;
        _orderNameLabel.font = [UIFont dp_systemFontOfSize:11];
    }
    return _orderNameLabel;
}

- (UILabel *)matchDateLabel {
    if (_matchDateLabel == nil) {
        _matchDateLabel = [[UILabel alloc] init];
        _matchDateLabel.backgroundColor = [UIColor clearColor];
        _matchDateLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _matchDateLabel.textAlignment = NSTextAlignmentCenter;
        _matchDateLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _matchDateLabel;
}

- (UIImageView *)analysisView {
    if (_analysisView == nil) {
        _analysisView = [[UIImageView alloc] init];
        _analysisView.image = dp_CommonImage(@"brown_smallarrow_down.png");
        _analysisView.highlightedImage = dp_CommonImage(@"brown_smallarrow_up.png");
    }
    return _analysisView;
}

- (UILabel *)homeNameLabel {
    if (_homeNameLabel == nil) {
        _homeNameLabel = [[UILabel alloc] init];
        _homeNameLabel.backgroundColor = [UIColor clearColor];
        _homeNameLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        _homeNameLabel.textAlignment = NSTextAlignmentCenter;
        _homeNameLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _homeNameLabel;
}

- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        _awayNameLabel.textAlignment = NSTextAlignmentCenter;
        _awayNameLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _awayNameLabel;
}

- (UILabel *)homeRankLabel {
    if (_homeRankLabel == nil) {
        _homeRankLabel = [[UILabel alloc] init];
        _homeRankLabel.backgroundColor = [UIColor clearColor];
        _homeRankLabel.textColor = [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];
        _homeRankLabel.textAlignment = NSTextAlignmentCenter;
        _homeRankLabel.font = [UIFont dp_systemFontOfSize:8];
    }
    return _homeRankLabel;
}

- (UILabel *)awayRankLabel {
    if (_awayRankLabel == nil) {
        _awayRankLabel = [[UILabel alloc] init];
        _awayRankLabel.backgroundColor = [UIColor clearColor];
        _awayRankLabel.textColor = [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];
        _awayRankLabel.textAlignment = NSTextAlignmentCenter;
        _awayRankLabel.font = [UIFont dp_systemFontOfSize:8];
    }
    return _awayRankLabel;
}

- (UILabel *)middleLabel {
    if (_middleLabel == nil) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.backgroundColor = [UIColor clearColor];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = [UIFont dp_systemFontOfSize:12];
        _middleLabel.text = @"VS";
        _middleLabel.textColor = [UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];
    }
    return _middleLabel;
}

- (NSArray *)optionButtonRqspf {
    return _optionButtonRqspf;
}

- (NSArray *)optionButtonZjq {
    return _optionButtonZjq;
}

- (NSArray *)optionButtonSxds {
    return _optionButtonSxds;
}

@end
