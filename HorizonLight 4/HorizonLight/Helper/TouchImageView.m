//
//  TouchImageView.m
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "TouchImageView.h"

@implementation TouchImageView

//封装了一个图像的点击事件,
- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建一个点击事件
        //将我们初始化方法内部的参数填入该手势初始化方法内(taget和action), 我们将在外部调用应设置我们的点击事件
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:taget action:action];
        
        //把当前类的交互打开, 否则不能响应
        self.userInteractionEnabled = YES;
        
        //把该手势添加至当前类
        [self addGestureRecognizer:imageTap];
        
    }
    return self;
}

@end
