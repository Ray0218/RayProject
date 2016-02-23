//
//  FeedbackView.m
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "FeedbackView.h"

@implementation FeedbackView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *array = @[@"- 是否喜欢我们推荐的内容 -", @"- 是否喜欢我们这个App的设计 -"];
        float interval = kScreenHeight / 6;
        for (int i = 0; i < [array count]; i++)
        {
            UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 100) / 5 + i * interval, kScreenWidth, 30)];
            likeLabel.textAlignment = NSTextAlignmentCenter;
            likeLabel.text = array[i];
            likeLabel.font = [UIFont systemFontOfSize:15];
            likeLabel.textColor = [UIColor blackColor];
            [self addSubview:likeLabel];
            
            NSArray *likeArray = @[@"喜欢", @"还行", @"不喜欢"];
            SwichView *swich = [[SwichView alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2, (kScreenHeight - 100) /  5 + 30 + i * interval, 300, 40) btnNum:[likeArray count] array:likeArray];
            for (int j = 0; j < [likeArray count]; j++)
            {
                UIButton *btn = (UIButton *)[swich viewWithTag:1100 + j];
                [btn setTag:1000 + 10 * i + j];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            [self addSubview:swich];
        }
        
        self.feedbackTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, (kScreenHeight - 100) /  5 + 30 + 2 * interval, kScreenWidth - 40, 100)];
        _feedbackTextField.placeholder = @"请告诉我们你遇到的问题或向反馈的意见(必填)";
        _feedbackTextField.tag = 1000;
        _feedbackTextField.borderStyle = 3;//设置边框
        _feedbackTextField.textAlignment = NSTextAlignmentCenter;
        _feedbackTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_feedbackTextField];
        
        self.eMailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, (kScreenHeight - 100) /  5 + 30 + 3 * interval, kScreenWidth - 40, 40)];
        _eMailTextField.placeholder = @"邮箱(必填)";
        _eMailTextField.tag = 1001;
        _eMailTextField.borderStyle = 3;//设置边框
        _eMailTextField.textAlignment = NSTextAlignmentCenter;
        _eMailTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_eMailTextField];
    }
    return self;
}

-(void)buttonClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 1000:
        {
            UIButton *btn1 =  (UIButton *)[self viewWithTag:1001];
            UIButton *btn2 = (UIButton *)[self viewWithTag:1002];
            [self select:button deselect:btn1 deselect:btn2];
        }
            break;
            
            case 1001:
        {
            UIButton *btn1 =  (UIButton *)[self viewWithTag:1000];
            UIButton *btn2 = (UIButton *)[self viewWithTag:1002];
            [self select:button deselect:btn1 deselect:btn2];
        }
            break;
            
            case 1002:
        {
            UIButton *btn1 =  (UIButton *)[self viewWithTag:1000];
            UIButton *btn2 = (UIButton *)[self viewWithTag:1001];
            [self select:button deselect:btn1 deselect:btn2];
        }
            break;
            
            case 1010:
        {
            UIButton *btn1 =  (UIButton *)[self viewWithTag:1011];
            UIButton *btn2 = (UIButton *)[self viewWithTag:1012];
            [self select:button deselect:btn1 deselect:btn2];
        }
            break;
            
            case 1011:
        {
            UIButton *btn1 =  (UIButton *)[self viewWithTag:1010];
            UIButton *btn2 = (UIButton *)[self viewWithTag:1012];
            [self select:button deselect:btn1 deselect:btn2];
        }
            break;
            case 1012:
        {
            UIButton *btn1 =  (UIButton *)[self viewWithTag:1010];
            UIButton *btn2 = (UIButton *)[self viewWithTag:1011];
            [self select:button deselect:btn1 deselect:btn2];
        }
        default:
            break;
    }
}

- (void)select:(UIButton *)btn1 deselect:(UIButton *)btn2 deselect:(UIButton *)btn3
{
    btn1.selected = YES;
    btn1.userInteractionEnabled = NO;
    btn2.selected = NO;
    btn2.userInteractionEnabled = YES;
    btn3.selected = NO;
    btn3.userInteractionEnabled = YES;
}

@end
