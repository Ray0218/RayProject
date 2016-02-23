//
//  VideoListHeaderView.m
//  HorizonLight
//
//  Created by lanou on 15/9/23.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "VideoListHeaderView.h"

@implementation VideoListHeaderView

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.7;
        
//        float btnWidth = (self.width - 40) / [array count];
        self.backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.x, self.y, self.width, self.height)];
        self.backImgView.image = [UIImage imageNamed:@"headerView1.jpg"];
        self.backImgView.alpha = 0.2;
        [self addSubview:_backImgView];
        
        self.timebtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.sharebtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self setAndAddButtonWithArray:array btnNum:0 btn:self.timebtn];
        [self setAndAddButtonWithArray:array btnNum:1 btn:self.sharebtn];
        self.timebtn.selected = YES;
        self.timebtn.userInteractionEnabled = NO;
        
        //上下两根线
//        self.upLineView = [[UIView alloc] initWithFrame:CGRectMake(20 + btnWidth / 4, 4, btnWidth / 2, 1)];
//        _upLineView.backgroundColor = [UIColor blackColor];
//        [self addSubview:_upLineView];
//        
//        self.downLineView = [[UIView alloc] initWithFrame:CGRectMake(20 + btnWidth / 4, self.height - 4, btnWidth / 2, 1)];
//        _downLineView.backgroundColor = [UIColor blackColor];
//        [self addSubview:_downLineView];
    }
    return self;
}

- (void)setAndAddButtonWithArray:(NSArray *)array btnNum:(NSUInteger)btnNum btn:(UIButton *)btn
{
    float btnWidth = (self.width - 40) / [array count];
    btn.frame = CGRectMake(20 + btnWidth * btnNum, 0, btnWidth, self.height);
    [btn setTitle:array[btnNum] forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
    btn.tag = 1100 + btnNum;
    [self addSubview:btn];
}

@end
