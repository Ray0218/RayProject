//
//  SwichView.m
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "SwichView.h"

@implementation SwichView

- (instancetype)initWithFrame:(CGRect)frame btnNum:(NSUInteger)btnNum array:(NSArray *)array
{
    if (self = [super initWithFrame:frame])
    {
        for (int i = 1; i < btnNum; i++)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.width / btnNum * i - 1, 8, 1, 24)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:lineView];
        }
        for (int i = 0; i < btnNum; i++)
        {
            [self setAndAddButtonWithString:array[i] btnNum:i count:[array count]];
        }
    }
    return self;
}

- (void)setAndAddButtonWithString:(NSString *)string btnNum:(NSUInteger)btnNum count:(NSUInteger)count
{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(20 + btnNum * (self.width - 40) / count, 0, (self.width - 40) / count, self.height);
    [button setTitle:string forState:(UIControlStateNormal)];
//        [button setTitle:title forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
    button.tag = 1100 + btnNum;
    [self addSubview:button];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
