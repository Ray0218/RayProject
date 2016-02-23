//
//  SettingView.m
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 4; i++)
        {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            button.frame = CGRectMake((kScreenWidth - 100) / 2, 130 + i * 70, 100, 30);
            button.tag = 1000 + i;
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            [self addSubview:button];
        }
        self.version = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2, (kScreenHeight / 2 + 150) + 30, 300, 20)];
        [self setAndAddLabel:self.version];
        
        self.maker = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2, (kScreenHeight / 2 + 150) + 60, 300, 20)];
        [self setAndAddLabel:self.maker];
    }
    return self;
}

- (void)setAndAddLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
}

@end
