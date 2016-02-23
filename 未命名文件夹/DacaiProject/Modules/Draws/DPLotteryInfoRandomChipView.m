//
//  DPLotteryInfoRandomChipView.m
//  DPLotteryInfoRandomChipView
//
//  Created by jacknathan on 14-9-22.
//  Copyright (c) 2014年 jacknathan. All rights reserved.
//

#import "DPLotteryInfoRandomChipView.h"
#import "Masonry.h"

#define kBallBetweenEdge 7
#define kBallCommonEdge 13
#define kBallCommonSize 22

@interface DPLotteryInfoRandomChipView ()
{
    KRandomChipViewType         _viewType;
    UILabel                     *_label6;
    NSArray                     *_balls;
}
@end

@implementation DPLotteryInfoRandomChipView
@dynamic viewType;

- (id)initWithViewType:(KRandomChipViewType)viewType;
{
    if (self = [self init]) {
        
        self.viewType = viewType;
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor yellowColor];
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    
    UIColor *color6 = [UIColor redColor];
    if (self.viewType == KRandomChipViewTypeDlt) {
        color6 = [UIColor blueColor];
    }
    UILabel *label1 = [self createLabelBallWithTitle:@"06" color:[UIColor redColor]];
    UILabel *label2 = [self createLabelBallWithTitle:@"09" color:[UIColor redColor]];
    UILabel *label3 = [self createLabelBallWithTitle:@"19" color:[UIColor redColor]];
    UILabel *label4 = [self createLabelBallWithTitle:@"09" color:[UIColor redColor]];
    UILabel *label5 = [self createLabelBallWithTitle:@"02" color:[UIColor redColor]];
    UILabel *label6 = [self createLabelBallWithTitle:@"19" color:color6];
    UILabel *label7 = [self createLabelBallWithTitle:@"29" color:[UIColor blueColor]];

    _label6 = label6;
    _balls = @[label1, label2, label3, label4, label5, label6, label7];
    UIView *superView = self;
    for (int i = 0; i < _balls.count; i++) {
        
        [self addSubview:_balls[i]];
    }
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(kBallCommonEdge);
        make.centerY.equalTo(superView);
        make.width.equalTo(@kBallCommonSize);
        make.height.equalTo(@kBallCommonSize);
    }];
    
    // 第2到第7个
    for (int i = 1; i < _balls.count; i++) {
        [self ballLabel:_balls[i] makeConstraintsWithNeibLabel:_balls[i - 1]];
    }
    
    // 随机按钮
    UIButton *randomBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"旋转.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(randomBtnClick) forControlEvents:UIControlEventTouchDown];
        button;
    });

    // 提交按钮
    UIButton *commitBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"去投注" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchDown];
        button;
    });
    
    [superView addSubview:randomBtn];
    [superView addSubview:commitBtn];
    
    [randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label7);
        make.left.equalTo(label7.mas_right).offset(kBallBetweenEdge);
        make.width.equalTo(@kBallCommonSize);
        make.height.equalTo(@kBallCommonSize);
    }];
    
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(8);
        make.right.equalTo(superView).offset(- 10);
        make.bottom.equalTo(superView).offset(- 8);
        make.left.equalTo(randomBtn.mas_right).offset(kBallBetweenEdge + 5);
    }];
}
- (void)ballLabel:(UILabel *)ball makeConstraintsWithNeibLabel:(UILabel *)neibLabel
{
    [ball mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(neibLabel.mas_right).offset(kBallBetweenEdge);
        make.centerY.equalTo(neibLabel);
        make.width.equalTo(@kBallCommonSize);
        make.height.equalTo(@kBallCommonSize);
    }];
}

- (UILabel *)createLabelBallWithTitle:(NSString *)title color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc]init];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 11;
    label.backgroundColor = color;
    label.text = title;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.clipsToBounds = YES;
   
    return label;
}

#pragma mark 产生指定数量和范围的随机数
- (NSArray *)randomNumberWithMax:(int)max count:(int)count
{
    NSMutableArray * numberArray = [NSMutableArray arrayWithCapacity:max];
    
    for (int i = 0; i < max; i++){
        
         NSString * numberStr = [NSString stringWithFormat:@"%02d", i + 1];
        [numberArray addObject:numberStr];
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        
        int j = arc4random_uniform(max - i);
        [resultArray addObject:[numberArray objectAtIndex:j]];
        [numberArray removeObjectAtIndex:j];
    }
    [numberArray removeAllObjects];
    
    return resultArray;

}
#pragma mark - 按钮点击事件
- (void)randomBtnClick
{
    int redMax = 33;
    int redCount = 6;
    int blueMax = 16;
    int blueCount = 1;
    
    if (self.viewType == KRandomChipViewTypeDlt) {
        redMax = 35;
        redCount = 5;
        blueMax = 12;
        blueCount = 2;
    }
    
    NSArray *redNumbers = [self randomNumberWithMax:redMax count:redCount];
    NSArray *blueNumbers = [self randomNumberWithMax:blueMax count:blueCount];
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:7];
    [arrayM addObjectsFromArray:redNumbers];
    [arrayM addObjectsFromArray:blueNumbers];

    // 可不可以用断言
    if (_balls == nil || _balls.count != arrayM.count) {
        return;
    }
    
    for (int i = 0; i < _balls.count; i++) {
        UILabel *ball = _balls[i];
        ball.text = arrayM[i];
    }
    
}
- (void)commitBtnClick
{
    
    
}

#pragma mark - setter && getter
- (KRandomChipViewType)viewType
{
    return _viewType;
}

- (void)setViewType:(KRandomChipViewType)viewType
{
    UIColor *color6 = [UIColor redColor];
    switch (viewType) {
        case KRandomChipViewTypeDlt:
            color6 = [UIColor blueColor];
            break;
        default:
            break;
    }
    
    [_label6 setBackgroundColor:color6];
    
    _viewType = viewType;
}

@end
