//
//  FunctionSwichView.m
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "FunctionSwichView.h"

@implementation FunctionSwichView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        NSArray *array = @[@"- 使用流量时提醒我 -", @"- Wi-Fi下自动缓存每日日报 -", @"- 自动缓存已收藏的视频 -"];
        self.backgroundColor = [UIColor whiteColor];
        
        float interval = kScreenHeight / 5;
        for (int i = 0; i < 3; i++)
        {
            
            UILabel *functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 100) / 5 + i * interval, kScreenWidth, 30)];
            functionLabel.textAlignment = NSTextAlignmentCenter;
            functionLabel.text = array[i];
            functionLabel.font = [UIFont systemFontOfSize:15];
            functionLabel.textColor = [UIColor blackColor];
            [self addSubview:functionLabel];
            
            NSArray *array = @[@"打开", @"关闭"];
            SwichView *swich = [[SwichView alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, (kScreenHeight - 100) /  5 + 30 + i * interval, 200, 40) btnNum:[array count] array:array];
            [(UIButton *)[swich viewWithTag:1100] setTag:1000 + 10 * i];
            [(UIButton *)[swich viewWithTag:1101] setTag:1000 + 10 * i + 1];
            [self addSubview:swich];
        }
        
        UIButton *cleanCacheBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        cleanCacheBtn.frame = CGRectMake((kScreenWidth - 150) / 2, (kScreenHeight - 100) /  5 + 3 * interval, 150, 30);
        cleanCacheBtn.backgroundColor = [UIColor clearColor];
        [cleanCacheBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [cleanCacheBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
        [cleanCacheBtn setTitle:@"清除所有缓存" forState:(UIControlStateNormal)];
        [self addSubview:cleanCacheBtn];
        
    }
    return self;
}

@end
