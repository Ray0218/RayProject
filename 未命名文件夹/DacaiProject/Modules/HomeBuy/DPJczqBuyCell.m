//
//  DPJczqBuyCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJczqBuyCell.h"
#import "DPBetToggleControl.h"

@interface DPJczqBuyCell () {
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
    
    UILabel*_stopCellLabel ;
    UILabel *_stopCellspf ;
    
    UIButton *_moreButton;
    UILabel *_spfLabel;
    UILabel *_rqspfLabel;
    
    UIImageView *_htSpfDGView;
    UIImageView *_htRqDGView;
    UIImageView *_otherDGView;
    UIImageView *_hotView;
}

@property (nonatomic, strong, readonly) UIView *infoView;
@property (nonatomic, strong, readonly) UIView *titleView;
@property (nonatomic, strong, readonly) UIView *optionView;

- (void)infoBuildLayout;
- (void)titleBuildLayout;

@end

@implementation DPJczqBuyCell
@dynamic infoView;
@dynamic titleView;
@dynamic optionView;
@dynamic competitionLabel;
@dynamic orderNameLabel;
@dynamic matchDateLabel;
@dynamic analysisView;
@dynamic homeNameLabel;
@dynamic awayNameLabel;
@dynamic homeRankLabel;
@dynamic awayRankLabel;
@dynamic middleLabel;
@dynamic moreButton;
@dynamic spfLabel;
@dynamic rqspfLabel;
@synthesize stopCellLabel ;
@synthesize stopCellspf ;
@dynamic htSpfDGView;
@dynamic htRqDGView;
@dynamic hotView;
- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = self.contentView;
    [self.contentView addSubview:self.hotView];
    [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@41.5);
        make.height.equalTo(@23);
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
    }];
    self.hotView.hidden=YES;
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
    if((self.gameType==GameTypeJcSpf)||(self.gameType==GameTypeJcRqspf)||(self.gameType==GameTypeJcBf)||(self.gameType==GameTypeJcBqc)){
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
        case GameTypeJcHt:
            [self optionHtBuildLayout];
            break;
        case GameTypeJcSpf:
            [self optionSpfBuildLayout];
            break;
        case GameTypeJcRqspf:
            [self optionRqspfBuildLayout];
            break;
        case GameTypeJcBf:
            [self optionBfBuildLayout];
            break;
        case GameTypeJcZjq:
            [self optionZjqBuildLayout];
            break;
        case GameTypeJcBqc:
            [self optionBqcBuildLayout];
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
//        make.width.equalTo(@10);
//        make.height.equalTo(@10);
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
        make.bottom.equalTo(contentView);
    }];
    [self.awayRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayNameLabel.mas_right);
        make.bottom.equalTo(contentView);
    }];
    if (self.gameType!=GameTypeJcHt) {
        [contentView addSubview:self.otherDGView];
        [self.otherDGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@18.5);
            make.height.equalTo(@18.5);
            make.left.equalTo(self.infoView.mas_right).offset(-3);
            make.centerY.equalTo(self.homeNameLabel);
            
        }];
        self.otherDGView.hidden=YES;

    }
}

/**
 *  混合投注视图
 */
- (void)optionHtBuildLayout {
    UIView *contentView = self.optionView;
    
    [contentView addSubview:self.moreButton];
    [contentView addSubview:self.spfLabel];
    [contentView addSubview:self.rqspfLabel];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@38);
        make.right.equalTo(contentView).offset(-10);
        make.centerY.equalTo(contentView);
        make.height.equalTo(@55);
    }];
    [self.spfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.width.equalTo(@16);
        make.top.equalTo(self.moreButton);
        make.bottom.equalTo(self.moreButton.mas_centerY).offset(-1);
    }];
    [self.rqspfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.width.equalTo(@16);
        make.top.equalTo(self.moreButton.mas_centerY).offset(0.5);
        make.bottom.equalTo(self.moreButton);
    }];
    
    // 布局选项
    NSArray *titleNames = [NSArray arrayWithObjects:@"胜", @"平", @"负", nil];
    NSArray *optionButtonsSpf = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    for (int i = 0; i < optionButtonsSpf.count; i++) {
        DPBetToggleControl *control = optionButtonsSpf[i];
        [control setTag:GameTypeJcSpf << 16 | i];
        [control setTitleText:titleNames[i]];
        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [control setShowBorderWhenSelected:YES];
        [contentView addSubview:control];
    }
    [contentView addSubview:self.stopCellspf];
    [optionButtonsSpf[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton);
        make.bottom.equalTo(self.moreButton.mas_centerY).offset(-0.5);
        make.left.equalTo(self.spfLabel.mas_right).offset(2);
        make.width.equalTo(@64);
    }];
    [optionButtonsSpf[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton);
        make.bottom.equalTo(self.moreButton.mas_centerY).offset(-0.5);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsSpf[0]).mas_right).offset(-1);
        make.width.equalTo(@64);
    }];
    [optionButtonsSpf[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton);
        make.bottom.equalTo(self.moreButton.mas_centerY).offset(-0.5);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsSpf[1]).mas_right).offset(-1);
        make.width.equalTo(@63);
    }];
    
    [self.stopCellspf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton);
        make.bottom.equalTo(self.moreButton.mas_centerY).offset(-0.5);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsSpf[0]));
        make.right.equalTo(((DPBetToggleControl *)optionButtonsSpf[2]));

    }];
    
    NSArray *optionButtonsRqspf = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    for (int i = 0; i < optionButtonsRqspf.count; i++) {
        DPBetToggleControl *control = optionButtonsRqspf[i];
        [control setTag:GameTypeJcRqspf << 16 | i];
        [control setTitleText:titleNames[i]];
        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [control setShowBorderWhenSelected:YES];
        [contentView addSubview:control];
    }
    
    [contentView addSubview:self.stopCellLabel];
    
    [optionButtonsRqspf[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton.mas_centerY).offset(0.5);
        make.bottom.equalTo(self.moreButton);
        make.left.equalTo(self.spfLabel.mas_right).offset(2);
        make.width.equalTo(@64);
    }];
    [optionButtonsRqspf[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton.mas_centerY).offset(0.5);
        make.bottom.equalTo(self.moreButton);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsRqspf[0]).mas_right).offset(-1);
        make.width.equalTo(@64);
    }];
    [optionButtonsRqspf[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton.mas_centerY).offset(0.5);
        make.bottom.equalTo(self.moreButton);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsRqspf[1]).mas_right).offset(-1);
        make.width.equalTo(@63);
    }];
    
    [_stopCellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton.mas_centerY).offset(0.5);
        make.bottom.equalTo(self.moreButton);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsRqspf[0]));
        make.right.equalTo(((DPBetToggleControl *)optionButtonsRqspf[2]));
    }];
    _optionButtonsRqspf = optionButtonsRqspf;
    _optionButtonsSpf = optionButtonsSpf;
    
    [contentView addSubview:self.htSpfDGView];
    [contentView addSubview:self.htRqDGView];
    self.htRqDGView.hidden=YES;
    self.htSpfDGView.hidden=YES;
    [self.htSpfDGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30.5);
        make.height.equalTo(@14);
        make.left.equalTo(self.spfLabel).offset(7);
        make.top.equalTo(self.spfLabel);
    }];
    [self.htRqDGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30.5);
        make.height.equalTo(@14);
        make.left.equalTo(self.rqspfLabel).offset(7);
        make.top.equalTo(self.rqspfLabel);

    }];
    
}

/**
 *  胜平负投注视图
 */
- (void)optionSpfBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    // 布局选项
    NSArray *title128 = [NSArray arrayWithObjects:@"胜", @"平", @"负", nil];
    NSArray *optionButtonsSpf = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    [optionButtonsSpf enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
    }];
    
    for (int i = 0; i < optionButtonsSpf.count; i++) {
        DPBetToggleControl *obj = optionButtonsSpf[i];
        obj.tag = (GameTypeJcSpf << 16) | i;
        obj.titleText = [title128 objectAtIndex:i];
         [obj addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(assistedView1).multipliedBy(0.333);
            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
            
            if (i == 1) {
                make.centerX.equalTo(assistedView1);
            }
        }];
        
        if (i >= optionButtonsSpf.count - 1) {
            continue;
        }
        
        DPBetToggleControl *obj1 = optionButtonsSpf[i];
        DPBetToggleControl *obj2 = optionButtonsSpf[i + 1];
        
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj1.mas_right).offset(-1);
        }];
    }
    
    
    _optionButtonsSpf = optionButtonsSpf;
}

/**
 *  让球胜平负投注视图
 */
- (void)optionRqspfBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    // 布局选项
    NSArray *title121 = [NSArray arrayWithObjects:@"胜", @"平", @"负", nil];
    NSArray *optionButtonsRqspf = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    [optionButtonsRqspf enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
    }];
    
    for (int i = 0; i < optionButtonsRqspf.count; i++) {
        DPBetToggleControl *obj = optionButtonsRqspf[i];
        obj.tag = (GameTypeJcRqspf << 16) | i;
        obj.titleText = [title121 objectAtIndex:i];
         [obj addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(assistedView1).multipliedBy(0.333);
            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
            
            if (i == 1) {
                make.centerX.equalTo(assistedView1);
            }
        }];
        
        if (i >= optionButtonsRqspf.count - 1) {
            continue;
        }
        
        DPBetToggleControl *obj1 = optionButtonsRqspf[i];
        DPBetToggleControl *obj2 = optionButtonsRqspf[i + 1];
        
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj1.mas_right).offset(-1);
        }];
    }
    
    _optionButtonsRqspf = optionButtonsRqspf;
}
/**
 *  比分投注视图
 */
- (void)optionBfBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    assistedView1.backgroundColor=[UIColor redColor];
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    NSArray *option122 = @[[self createButton]];
    [option122 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [assistedView1 addSubview:obj];
    }];
    for (int i=0; i<option122.count; i++) {
        UIButton *obj=option122[i];
        obj.tag = (GameTypeJcBf << 16) | i;
        [obj setTitle:@"比分投注" forState:UIControlStateNormal];
         [obj addTarget:self action:@selector(pvt_onMore) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(assistedView1);
            make.right.equalTo(assistedView1);
            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
        }];
    }
    _optionButtonsBf = option122;
}
/**
 *  总进球投注视图
 */
- (void)optionZjqBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(3);
        make.height.equalTo(@52);
    }];
    
    // 布局选项
    NSArray *title123 = [NSArray arrayWithObjects:@"0", @"1", @"2",@"3", @"4", @"5",@"6", @"7+", nil];
    NSArray *optionButtonsZjq = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    [optionButtonsZjq enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
        [obj setShowBorderWhenSelected:YES];
    }];
    
    for (int i = 0; i < optionButtonsZjq.count; i++) {
        DPBetToggleControl *obj = optionButtonsZjq[i];
        obj.tag = (GameTypeJcZjq << 16) | i;
        obj.titleText = [title123 objectAtIndex:i];
        [obj addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(assistedView1).multipliedBy(0.248);
            make.top.equalTo(assistedView1).offset(27.0*(i/4));
            make.height.equalTo(@25);
            if (i%4  == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(assistedView1);
                }];
            }
//            if (i == 1) {
//                make.centerX.equalTo(assistedView1);
//            }
        }];
        
        if ((i + 1) % 4 == 0 ||(i >= optionButtonsZjq.count - 1)) { // 每行5个选项
            continue;
        }
        
        DPBetToggleControl *obj1 = optionButtonsZjq[i];
        DPBetToggleControl *obj2 = optionButtonsZjq[i + 1];
        
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj1.mas_right).offset(2);
        }];
    }
    
    
    _optionButtonsZjq = optionButtonsZjq;
}
/**
 *  半全场投注视图
 */
- (void)optionBqcBuildLayout {
    UIView *contentView = self.optionView;
    // 辅助view
    UIView *assistedView1 = [UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:assistedView1];
    assistedView1.backgroundColor=[UIColor redColor];
    [assistedView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView).offset(9.5);
        make.height.equalTo(@32);
    }];
    
    NSArray *option124 = @[[self createButton]];
    [option124 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
        [assistedView1 addSubview:obj];
    }];
    for (int i=0; i<option124.count; i++) {
        UIButton *obj=option124[i];
        obj.tag = (GameTypeJcBqc << 16) | i;
        [obj setTitle:@"半全场投注" forState:UIControlStateNormal];
       
        [obj addTarget:self action:@selector(pvt_onMore) forControlEvents:UIControlEventTouchUpInside];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(assistedView1);
            make.right.equalTo(assistedView1);
            make.top.equalTo(assistedView1);
            make.bottom.equalTo(assistedView1);
        }];
    }
    _optionButtonsBqc = option124;
}

#pragma mark - event
- (void)pvt_onMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreJczqBuyCell:)]) {
        [self.delegate moreJczqBuyCell:self];
    }
}
- (void)pvt_onBet:(DPBetToggleControl *)sender {
    sender.selected = !sender.isSelected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jczqBuyCell:gameType:index:selected:)]) {
        [self.delegate jczqBuyCell:self gameType:(sender.tag & 0xFFFF0000) >> 16 index:sender.tag & 0x0000FFFF selected:sender.isSelected];
    }
}

- (void)pvt_onMatchInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jczqBuyCellInfo:)]) {
        [self.delegate jczqBuyCellInfo:self];
    }
}
-(void)analysisViewIsExpand:(BOOL)isExpand{
    if (isExpand) {
        self.analysisView.highlighted = NO ;;
    }else{
        self.analysisView.highlighted = YES ;
        
    }

//    if (isExpand) {
//       self.analysisView.image= dp_CommonImage(@"brown_smallarrow_down.png");
//    }else{
//         self.analysisView.image= dp_CommonImage(@"brown_smallarrow_up.png");
//    
//    }
}
#pragma mark - getter

- (UIButton *)moreButton {
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setTitle:@"更多\n玩法" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatWhiteColor]] forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
        [_moreButton setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateSelected];
        [_moreButton.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [_moreButton.titleLabel setNumberOfLines:0];
        [_moreButton.layer setBorderColor:[UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor];
        [_moreButton.layer setBorderWidth:1];
        [_moreButton addTarget:self action:@selector(pvt_onMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UILabel *)spfLabel {
    if (_spfLabel == nil) {
        _spfLabel = [[UILabel alloc] init];
        _spfLabel.backgroundColor = [UIColor colorWithRed:0 green:0.67 blue:0.51 alpha:1];
        _spfLabel.textColor = [UIColor dp_flatWhiteColor];
        _spfLabel.textAlignment = NSTextAlignmentCenter;
        _spfLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _spfLabel;
}

- (UILabel *)rqspfLabel {
    if (_rqspfLabel == nil) {
        _rqspfLabel = [[UILabel alloc] init];
        _rqspfLabel.backgroundColor = [UIColor colorWithRed:1 green:0.71 blue:0.15 alpha:1];
        _rqspfLabel.textAlignment = NSTextAlignmentCenter;
        _rqspfLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _rqspfLabel;
}


#pragma mark - getter
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
        _homeNameLabel.font = [UIFont dp_systemFontOfSize:15];
    }
    return _homeNameLabel;
}

- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        _awayNameLabel.textAlignment = NSTextAlignmentCenter;
        _awayNameLabel.font = [UIFont dp_systemFontOfSize:15];
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

-(UILabel*)stopCellLabel
{
    if (_stopCellLabel == nil) {
        _stopCellLabel = [[UILabel alloc]init];
        _stopCellLabel.text = @"未开售" ;
        _stopCellLabel.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
        _stopCellLabel.textAlignment = NSTextAlignmentCenter ;
        _stopCellLabel.font = [UIFont dp_systemFontOfSize:14];
        _stopCellLabel.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
        _stopCellLabel.layer.borderWidth=1;
        _stopCellLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
    }
    
    return _stopCellLabel ;
}

-(UILabel*)stopCellspf
{
    if (_stopCellspf == nil) {
        
        _stopCellspf = [[UILabel alloc]init];
        _stopCellspf.text = @"未开售" ;
        _stopCellspf.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
        _stopCellspf.textAlignment = NSTextAlignmentCenter ;
        _stopCellspf.font = [UIFont dp_systemFontOfSize:14];
        _stopCellspf.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
        _stopCellspf.layer.borderWidth=1;
        _stopCellspf.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
    }
    
    return _stopCellspf ;
}


- (UILabel *)middleLabel {
    if (_middleLabel == nil) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.backgroundColor = [UIColor clearColor];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = [UIFont dp_systemFontOfSize:14];
        _middleLabel.text = @"VS";
        _middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    }
    return _middleLabel;
}
-(UIImageView *)htSpfDGView{
    if (_htSpfDGView==nil) {
        _htSpfDGView=[[UIImageView alloc] init];
        _htSpfDGView.backgroundColor=[UIColor clearColor];
        [_htSpfDGView setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _htSpfDGView;
    
}
-(UIImageView *)htRqDGView{
    if (_htRqDGView==nil) {
        _htRqDGView=[[UIImageView alloc] init];
        _htRqDGView.backgroundColor=[UIColor clearColor];
        [_htRqDGView setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _htRqDGView;
    
}
-(UIImageView *)otherDGView{
    if (_otherDGView==nil) {
        _otherDGView=[[UIImageView alloc] init];
        _otherDGView.backgroundColor=[UIColor clearColor];
        [_otherDGView setImage:dp_SportLotteryImage(@"dan.png")];
    }
    return _otherDGView;
    
}
-(UIImageView *)hotView{
    if (_hotView==nil) {
        _hotView=[[UIImageView alloc] init];
        _hotView.backgroundColor=[UIColor clearColor];
        [_hotView setImage:dp_SportLotteryImage(@"re.png")];
    }
    return _hotView;
    
}
-(UIButton *)createButton{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatWhiteColor]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
    [button.layer setBorderColor:[UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor];
    [button.layer setBorderWidth:1];
    return button;
}

@end
