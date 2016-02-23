//
//  MultiSelectWithAnimationView.m
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "MultiSelectWithAnimationView.h"

@implementation MultiSelectWithAnimationView

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.5;
        
        float btnWidth = (self.width - 40) / [array count];
        for (int i = 0; i < [array count]; i++)
        {
            [self setAndAddButtonWithArray:array btnNum:i];
        }
        self.upLineView = [[UIView alloc] initWithFrame:CGRectMake(20 + btnWidth / 4, 4, btnWidth / 2, 1)];
        _upLineView.backgroundColor = [UIColor blackColor];
        [self addSubview:_upLineView];
        
        self.downLineView = [[UIView alloc] initWithFrame:CGRectMake(20 + btnWidth / 4, self.height - 4, btnWidth / 2, 1)];
        _downLineView.backgroundColor = [UIColor blackColor];
        [self addSubview:_downLineView];
    }
    return self;
}

- (void)setAndAddButtonWithArray:(NSArray *)array btnNum:(NSUInteger)btnNum
{
    float btnWidth = (self.width - 40) / [array count];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(20 + btnWidth * btnNum, 0, btnWidth, self.height);
    [button setTitle:array[btnNum] forState:(UIControlStateNormal)];
    //    [button setTitle:title forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
    
    button.tag = 1100 + btnNum;
    [self addSubview:button];
}

@end
