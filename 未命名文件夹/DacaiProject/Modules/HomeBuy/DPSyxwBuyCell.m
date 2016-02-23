//
//  DPSyxwBuyCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-6.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSyxwBuyCell.h"
#import "../../Common/View/DPTouchBall.h"
typedef enum _TouchBallStatus {
    TouchBallStatusDown,
    TouchBallStatusMove,
    TouchBallStatusUp,
} TouchBallStatus;


@interface DPSyxwBuyCell () {
@private
    UILabel *_commentLabel;
    UIView *_ballView;
    
    NSArray *_balls;
    NSArray *_misses;
    UIView  *_footLine;
    TouchBallStatus _touchStatus;
}
@property (nonatomic, strong, readonly) UIView *ballView;

@end

@implementation DPSyxwBuyCell
@dynamic balls;
@dynamic misses;
@dynamic ballView;
@dynamic commentLabel;
@dynamic footLine;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _touchStatus = TouchBallStatusUp;
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self.contentView;
    
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_DigitLotteryImage(@"right_arrow.png")];
        imageView;
    });
    
    [contentView addSubview:self.commentLabel];
    [contentView addSubview:self.ballView];
    [contentView addSubview:imageView];
    [contentView addSubview:self.footLine];
    self.footLine.hidden = YES;
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@40);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(0.5);
    }];
    
    [self.ballView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel.mas_right).offset(-0.5);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(0.5);
    }];
    
    [self.footLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(contentView);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel.mas_right).offset(-0.5);
        make.centerY.equalTo(self.commentLabel);
    }];
    
    //
    NSMutableArray *balls = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 12; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor colorWithRed:0.4 green:0.33 blue:0.27 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:dp_DigitLotteryImage(@"ballNormal001_0.png") forState:UIControlStateNormal];
        [button setBackgroundImage:dp_DigitLotteryImage(@"ballSelectedRed001_07.png") forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@"%02d", i+1] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%02d", i+1] forState:UIControlStateSelected];
        [button setTag:i];
        [button setUserInteractionEnabled:NO];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];
        [self.ballView addSubview:button];
        [balls addObject:button];
        if (i==11) {
            [button setTitle:@"全" forState:UIControlStateNormal];
            [button setTitle:@"全" forState:UIControlStateSelected];
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
    }
   
    [balls[3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ballView.mas_centerX).offset(22);
    }];
    [balls[9] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ballView.mas_centerX).offset(22);
    }];
    
    NSMutableArray *misses = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 12; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:10];
        
        [self.ballView addSubview:label];
        [misses addObject:label];
    }
    
    for (int i = 0; i < 12; i++) {
        UIButton *ball = balls[i];
        UILabel *label = misses[i];
        if (i < 6) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(contentView.mas_centerY).offset(-2);
                make.centerX.equalTo(ball);
            }];
            [ball mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(label.mas_top);
            }];
        } else {
            [ball mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(contentView.mas_centerY).offset(2);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ball.mas_bottom);
                make.centerX.equalTo(ball);
            }];
        }
        
        if ((i >= 0 && i < 5) || (i >= 6 && i < 11)) {
            UIButton *ball1 = balls[i];
            UIButton *ball2 = balls[i + 1];
            
            [ball2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(ball1.mas_right).offset(7);
            }];
        }
    }
    
    _balls = balls;
    _misses = misses;
}
#pragma mark - 点击事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    //点击后取得在 cell 上的坐标点
    CGPoint locationCell = [touch locationInView:self.ballView];
    
    for (NSInteger i = 0 ; i < self.balls.count; i++) {
        UIButton *button = self.balls[i];
        
        if (CGRectContainsPoint(button.frame, locationCell)) {
            //
            _touchStatus = TouchBallStatusDown;
            
            // 拖动开始
            if(self.delegate && [self.delegate respondsToSelector:@selector(buyCell:touchDown:)]) {
                [self.delegate buyCell:self touchDown:button];
            }
            
            CGRect ballFrame = [self.ballView convertRect:button.frame toView:self.window];
            
            //所选号码
            DPTouchBall *touchBall = [DPTouchBall redBall];
            touchBall.titleText = [NSString stringWithFormat:@"%02d", button.tag+1];
            if (button.tag==11) {
                touchBall.titleText =@"全";
            }
            touchBall.frame = CGRectMake(CGRectGetMidX(ballFrame) - dp_TouchBallWidth / 2,
                                         CGRectGetMinY(ballFrame) - (dp_TouchBallHegiht - CGRectGetHeight(ballFrame)) + 2,
                                         dp_TouchBallWidth,
                                         dp_TouchBallHegiht);
            [self.window addSubview:touchBall];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_touchStatus != TouchBallStatusDown) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    //点击后取得在 cell 上的坐标点
    CGPoint locationCell = [touch locationInView:self.ballView];
    int i = 0;
    for (i = 0 ; i < self.balls.count; i++) {
        UIButton *button = self.balls[i];
        
        if (CGRectContainsPoint(button.frame, locationCell)) {
            CGRect ballFrame = [self.ballView convertRect:button.frame toView:self.window];
            
            //所选号码
            DPTouchBall *touchBall = [DPTouchBall redBall];
            touchBall.titleText = [NSString stringWithFormat:@"%02d", button.tag+1];
            if (button.tag==11) {
                touchBall.titleText =@"全";
            }
            touchBall.frame = CGRectMake(CGRectGetMidX(ballFrame) - dp_TouchBallWidth / 2,
                                         CGRectGetMinY(ballFrame) - (dp_TouchBallHegiht - CGRectGetHeight(ballFrame)) + 2,
                                         dp_TouchBallWidth,
                                         dp_TouchBallHegiht);
            [self.window addSubview:touchBall];
            break;
        }
    }
    if (i == self.balls.count) {
        [[DPTouchBall redBall] removeFromSuperview];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    //点击后取得在 cell 上的坐标点
    CGPoint locationCell = [touch locationInView:self.ballView];
    int i = 0;
    for (i = 0 ; i < self.balls.count; i++) {
        UIButton *button = self.balls[i];
        
        if (CGRectContainsPoint(button.frame, locationCell)) {
            // 结束拖动
            if(self.delegate && [self.delegate respondsToSelector:@selector(buyCell:touchUp:)]) {
                [self.delegate buyCell:self touchUp:button];
            }
            
            break;
        }
    }
    
    if (i == self.balls.count) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(buyCell:touchUp:)]) {
            [self.delegate buyCell:self touchUp:nil];
        }
    }
    
    [[DPTouchBall redBall] removeFromSuperview];
    
    _touchStatus = TouchBallStatusUp;
}

#pragma mark -
- (UILabel *)commentLabel {
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.94 alpha:1];
        _commentLabel.textColor = [UIColor colorWithRed:0.4 green:0.33 blue:0.27 alpha:1];
        _commentLabel.textAlignment = NSTextAlignmentCenter;
        _commentLabel.font = [UIFont dp_systemFontOfSize:13];
        _commentLabel.layer.borderColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.87 alpha:1].CGColor;
        _commentLabel.layer.borderWidth = 0.5;
    }
    return _commentLabel;
}

- (UIView *)ballView {
    if (_ballView == nil) {
        _ballView = [[UIView alloc] init];
        _ballView.backgroundColor = [UIColor clearColor];
        _ballView.layer.borderColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.87 alpha:1].CGColor;
        _ballView.layer.borderWidth = 0.5;
    }
    return _ballView;
}
- (UIView *)footLine
{
    if (_footLine == nil) {
        _footLine = [[UIView alloc]init];
        _footLine.backgroundColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.87 alpha:1];
    }
    return _footLine;
}
- (NSArray *)balls {
    return _balls;
}

- (NSArray *)misses {
    return _misses;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
