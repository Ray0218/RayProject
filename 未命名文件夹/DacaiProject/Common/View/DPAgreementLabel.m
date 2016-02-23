//
//  DPAgreementLabel.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-20.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAgreementLabel.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface DPAgreementLabel () {
@private
    UIButton *_agreeButton;
    TTTAttributedLabel *_attrLabel;
    __weak id _target;
    NSString *_actionName;
}

@property (nonatomic, strong, readonly) UIButton *agreeButton;
@property (nonatomic, strong, readonly) TTTAttributedLabel *attrLabel;

@end

@implementation DPAgreementLabel

+ (DPAgreementLabel *)purchaseLabelWithTarget:(id)target action:(SEL)action {
    DPAgreementLabel *purchaseLabel = [[DPAgreementLabel alloc] init];
    purchaseLabel.selected = YES;
    purchaseLabel.text = @"我同意《用户合买代购协议》其中条款";
    [purchaseLabel setTarget:target action:action];
    return purchaseLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.agreeButton];
        [self addSubview:self.attrLabel];
        
        [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self);
        }];
        [self.attrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.agreeButton.mas_right).offset(2);
        }];
        
        [self.agreeButton addTarget:self action:@selector(pvt_onClick) forControlEvents:UIControlEventTouchUpInside];
        [self.attrLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHandleTap)]];
    }
    return self;
}

- (BOOL)isSelected {
    return self.agreeButton.isSelected;
}

- (void)setSelected:(BOOL)selected {
    self.agreeButton.selected = selected;
}

- (void)setText:(NSString *)text {
    self.attrLabel.text = text;
//    [self invalidateIntrinsicContentSize];
}

- (NSString *)text {
    return self.attrLabel.text;
}

- (void)setTarget:(id)target action:(SEL)action {
    _target = target;
    _actionName = NSStringFromSelector(action);
}

- (void)pvt_onHandleTap {
    if (_target && _actionName) {
        SEL action = NSSelectorFromString(_actionName);
        if ([_target respondsToSelector:action]) {
            DPSuppressPerformSelectorLeakWarning([_target performSelector:action]);
        }
    }
}

- (void)pvt_onClick {
    self.selected = !self.selected;
}

- (UIButton *)agreeButton {
    if (_agreeButton == nil) {
        _agreeButton = [[UIButton alloc] init];
        [_agreeButton setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
        [_agreeButton setImage:dp_CommonImage(@"check.png") forState:UIControlStateSelected];
    }
    return _agreeButton;
}

- (TTTAttributedLabel *)attrLabel {
    if (_attrLabel == nil) {
        _attrLabel = [[TTTAttributedLabel alloc] init];
        _attrLabel.textColor = [UIColor colorWithRed:0.73 green:0.7 blue:0.65 alpha:1];
        _attrLabel.font = [UIFont dp_systemFontOfSize:11];
        _attrLabel.backgroundColor = [UIColor clearColor];
    }
    return _attrLabel;
}

- (CGSize)intrinsicContentSize {
    CGSize buttonSize = self.agreeButton.intrinsicContentSize;
    CGSize labelSize = self.attrLabel.intrinsicContentSize;
    
    return CGSizeMake(buttonSize.width + labelSize.width + 2, 15);
}

@end
