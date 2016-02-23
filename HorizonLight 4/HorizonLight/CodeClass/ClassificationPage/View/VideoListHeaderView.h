//
//  VideoListHeaderView.h
//  HorizonLight
//
//  Created by lanou on 15/9/23.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListHeaderView : UIView

@property (nonatomic, assign) NSUInteger btnNumber;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *downLineView;
@property (nonatomic, strong) UIButton *timebtn;
@property (nonatomic, strong) UIButton *sharebtn;

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

@end