//
//  ContributeView.m
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ContributeView.h"

@implementation ContributeView

- (instancetype)initWithFrame:(CGRect)frame 
{
    self.backgroundColor = [UIColor whiteColor];
    
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64 + 20, kScreenWidth - 40, 40)];
        _nickNameTextField.placeholder = @"昵称";
        _nickNameTextField.tag = 1000;
        _nickNameTextField.borderStyle = 3;//设置边框
        _nickNameTextField.textAlignment = NSTextAlignmentCenter;
        _nickNameTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_nickNameTextField];
        
        self.eMailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64 + 80, kScreenWidth - 40, 40)];
        _eMailTextField.placeholder = @"邮箱(必填)";
        _eMailTextField.tag = 1001;
        _eMailTextField.borderStyle = 3;//设置边框
        _eMailTextField.textAlignment = NSTextAlignmentCenter;
        _eMailTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_eMailTextField];
        
        self.videoNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64 + 140, kScreenWidth - 40, 100)];
        _videoNameTextField.placeholder = @"视频名称 & 视频播放链接(必填)";
        _videoNameTextField.tag = 1002;
        _videoNameTextField.borderStyle = 3;//设置边框
        _videoNameTextField.textAlignment = NSTextAlignmentCenter;
        _videoNameTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_videoNameTextField];
    }
    return self;
}

@end
