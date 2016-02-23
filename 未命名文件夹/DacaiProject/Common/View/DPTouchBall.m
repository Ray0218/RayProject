//
//  DPTouchBall.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPTouchBall.h"

const NSInteger dp_TouchBallWidth = 60;
const NSInteger dp_TouchBallHegiht = 100;

@interface DPTouchBall () {
@private
    UILabel *_titleLabel;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end

@implementation DPTouchBall
@dynamic titleText;
@dynamic titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(10);
        }];
    }
    return self;
}

#pragma mark - getter, setter

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

- (NSString *)titleText {
    return self.titleLabel.text;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont dp_boldSystemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

+ (instancetype)redBall {
    static DPTouchBall *ball;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ball = [[DPTouchBall alloc] init];
        ball.image = dp_DigitLotteryImage(@"ballRed001_01.png");
    });
    return ball;
}

+ (instancetype)blueBall {
    static DPTouchBall *ball;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ball = [[DPTouchBall alloc] init];
        ball.image = dp_DigitLotteryImage(@"ballBlue001_02.png");
    });
    return ball;
}

@end
