//
//  MultiSelectWithAnimationView.h
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiSelectWithAnimationView : UIView

@property (nonatomic, assign) NSUInteger btnNumber;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *downLineView;

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

@end
