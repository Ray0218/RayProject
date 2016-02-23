//
//  DPBdBuyMoreView.mm
//  DacaiProject
//
//  Created by WUFAN on 14-8-6.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBdBuyMoreView.h"
#import "DPBetToggleControl.h"
#import "FrameWork.h"

@interface DPBdBuyMoreView () {
@private
    UIView *_coverView;
    UIView *_contentView;
    
    UIView *_titleView;
    UIView *_optionView;
    UIView *_submitView;
    
    NSArray *_betOptionBf;
    NSArray *_betOptionBqc;
    
    CLotteryBd *_bdInstance;
}

@property (nonatomic, strong, readonly) UIView *titleView;
@property (nonatomic, strong, readonly) UIView *optionView;
@property (nonatomic, strong, readonly) UIView *submitView;;

@end

@implementation DPBdBuyMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _bdInstance = CFrameWork::GetInstance()->GetLotteryBd();
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self;
    
    [contentView addSubview:self.coverView];
    [contentView addSubview:self.contentView];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.centerY.equalTo(contentView);
        make.bottom.lessThanOrEqualTo(contentView).priorityHigh();
        make.bottom.greaterThanOrEqualTo(contentView).offset(64).priorityHigh();
    }];
    
    contentView = self.contentView;
    
    [contentView addSubview:self.titleView];
    [contentView addSubview:self.optionView];
    [contentView addSubview:self.submitView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.height.equalTo(@50);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.titleView.mas_bottom);
        if (self.gameType == GameTypeBdBf) {
            make.height.equalTo(@200);
        } else {
            make.height.equalTo(@130);
        }
    }];;
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.optionView.mas_bottom);
        make.height.equalTo(@45);
        make.bottom.equalTo(contentView);
    }];
    
    contentView = self.titleView;
    
    int rqs;
    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime;
    _bdInstance->GetTargetInfo(self.indexPath.section, self.indexPath.row, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank, orderNumberName, competitionName, endTime, rqs);
    
    UILabel *homeTeamLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithUTF8String:homeTeamName.c_str()];
        label;
    });
    UILabel *middleTeamLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"VS";
        label;
    });
    UILabel *awayTeamLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithUTF8String:awayTeamName.c_str()];
        label;
    });
    [contentView addSubview:homeTeamLabel];
    [contentView addSubview:middleTeamLabel];
    [contentView addSubview:awayTeamLabel];
    
    [homeTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView.mas_centerX).offset(-40);
    }];
    [middleTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contentView);
    }];
    [awayTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX).offset(40);
    }];
    
    contentView = self.submitView;
    
    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.69 green:0.68 blue:0.66 alpha:1];
        view;
    });
    UIButton *cancelButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:16]];
        [button addTarget:self action:@selector(pvt_onCancel) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *confirmButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:16]];
        [button addTarget:self action:@selector(pvt_onConfirm) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.submitView addSubview:line];
    [self.submitView addSubview:cancelButton];
    [self.submitView addSubview:confirmButton];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView.mas_centerX);
        make.bottom.equalTo(contentView);
        make.top.equalTo(contentView);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.top.equalTo(contentView);
    }];
    
    switch (self.gameType) {
        case GameTypeBdBf: {
            [self bfBuildLayout];
        }
            break;
        case GameTypeBdBqc: {
            [self bqcBuildLayout];
        }
            break;
        default:
            break;
    }
}

- (void)bfBuildLayout {
    static NSString *bfNames[] =
    {
        @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"胜其他",
        @"0:0", @"1:1", @"2:2", @"3:3", @"平其他",
        @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"负其他",
    };
    
    int spList[25];
    int betOption[25];
    _bdInstance->GetTargetSpList(self.indexPath.section, self.indexPath.row, spList);
    _bdInstance->GetTargetOption(self.indexPath.section, self.indexPath.row, betOption);
    
    UIView *contentView = self.optionView;
    
    _betOptionBf = @[[DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],
                     [DPBetToggleControl verticalControl],];
    
    [_betOptionBf enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
    }];
    
    DPBetToggleControl *base = _betOptionBf[2];
    [base mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@58);
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(5);
    }];
    
    for (int i = 0; i < _betOptionBf.count; i++) {
        DPBetToggleControl *control = _betOptionBf[i];
        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [control setTag:self.gameType << 16 | i];
        [control setShowBorderWhenSelected:YES];
        [control setTitleText:bfNames[i]];
        [control setOddsText:FloatTextForIntDivHundred(spList[i])];
        [control setOddsColor:[UIColor colorWithRed:0.65 green:0.62 blue:0.56 alpha:1]];
        [control setSelected:betOption[i]];
        
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(base);
            make.height.equalTo(base);
        }];
    }
    
    for (int i = 0; i < 5; i++) {
        DPBetToggleControl *control1 = _betOptionBf[i * 5];
        DPBetToggleControl *control2 = _betOptionBf[i * 5 + 1];
        DPBetToggleControl *control3 = _betOptionBf[i * 5 + 2];
        DPBetToggleControl *control4 = _betOptionBf[i * 5 + 3];
        DPBetToggleControl *control5 = _betOptionBf[i * 5 + 4];
        
        [control2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(control3);
            make.right.equalTo(control3.mas_left).offset(1);
        }];
        [control1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(control2);
            make.right.equalTo(control2.mas_left).offset(1);
        }];
        
        [control4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(control3);
            make.left.equalTo(control3.mas_right).offset(-1);
        }];
        [control5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(control4);
            make.left.equalTo(control4.mas_right).offset(-1);
        }];
    }
    
    DPBetToggleControl *control1 = _betOptionBf[0 + 2];
    DPBetToggleControl *control2 = _betOptionBf[5 + 2];
    DPBetToggleControl *control3 = _betOptionBf[10 + 2];
    DPBetToggleControl *control4 = _betOptionBf[15 + 2];
    DPBetToggleControl *control5 = _betOptionBf[20 + 2];
    
    [control2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control1.mas_bottom).offset(-1);
        make.centerX.equalTo(control1);
    }];
    [control3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control2.mas_bottom).offset(3);
        make.centerX.equalTo(control1);
    }];
    [control4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control3.mas_bottom).offset(3);
        make.centerX.equalTo(control1);
    }];
    [control5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control4.mas_bottom).offset(-1);
        make.centerX.equalTo(control1);
    }];
}

- (void)bqcBuildLayout {
    static NSString *bqcNames[] = {@"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负"};
    
    int spList[25];
    int betOption[25];
    _bdInstance->GetTargetSpList(self.indexPath.section, self.indexPath.row, spList);
    _bdInstance->GetTargetOption(self.indexPath.section, self.indexPath.row, betOption);
    
    UIView *contentView = self.optionView;
    
    _betOptionBqc = @[[DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2],
                      [DPBetToggleControl horizontalControl2]];
    
    [_betOptionBqc enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:obj];
    }];
    
    DPBetToggleControl *base = _betOptionBqc[1];
    [base mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(contentView).multipliedBy(0.3);
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(5);
    }];
    
    for (int i = 0; i < _betOptionBqc.count; i++) {
        DPBetToggleControl *control = _betOptionBqc[i];
        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [control setTag:self.gameType << 16 | i];
        [control setTitleText:bqcNames[i]];
        [control setOddsText:FloatTextForIntDivHundred(spList[i])];
        [control setOddsColor:[UIColor colorWithRed:0.65 green:0.62 blue:0.56 alpha:1]];
        [control setSelected:betOption[i]];
        
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(base);
            make.height.equalTo(base);
        }];
    }
    
    for (int i = 0; i < 3; i++) {
        DPBetToggleControl *controlLeft = _betOptionBqc[i * 3];
        DPBetToggleControl *controlCenter = _betOptionBqc[i * 3 + 1];
        DPBetToggleControl *controlRight = _betOptionBqc[i * 3 + 2];
        
        [controlLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(controlCenter);
            make.right.equalTo(controlCenter.mas_left).offset(-2);
        }];
        [controlRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(controlCenter);
            make.left.equalTo(controlCenter.mas_right).offset(2);
        }];
    }
    for (int i = 0; i < 3; i++) {
        DPBetToggleControl *controlTop = _betOptionBqc[i];
        DPBetToggleControl *controlCenter = _betOptionBqc[i + 3];
        DPBetToggleControl *controlBottom = _betOptionBqc[i + 6];
        
        [controlCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(controlTop);
            make.top.equalTo(controlTop.mas_bottom).offset(5);
        }];
        [controlBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(controlCenter);
            make.top.equalTo(controlCenter.mas_bottom).offset(5);
        }];
    }
}

- (void)pvt_onBet:(DPBetToggleControl *)sender {
    sender.selected = !sender.selected;
}

- (void)pvt_onCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBuyMoreView:)]) {
        [self.delegate cancelBuyMoreView:self];
    }
}

- (void)pvt_onConfirm {
    switch (self.gameType) {
        case GameTypeBdBqc: {
            [_betOptionBqc enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
                _bdInstance->SetTargetOption(self.indexPath.section, self.indexPath.row, idx, obj.selected);
            }];
        }
            break;
        case GameTypeBdBf: {
            [_betOptionBf enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
                _bdInstance->SetTargetOption(self.indexPath.section, self.indexPath.row, idx, obj.selected);
            }];
        }
            break;
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBuyMoreView:)]) {
        [self.delegate confirmBuyMoreView:self];
    }
}

#pragma mark - getter

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.97 blue:0.95 alpha:1];
    }
    return _contentView;
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

- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor clearColor];
    }
    return _submitView;
}

@end
