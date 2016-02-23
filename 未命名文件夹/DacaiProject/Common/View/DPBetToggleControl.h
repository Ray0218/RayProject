//
//  DPBetToggleControl.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  竞技彩投注按钮
//

#import <UIKit/UIKit.h>

@interface DPBetToggleControl : UIControl

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *oddsText;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *oddsColor;

@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *selectedBgColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *oddsFont;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) BOOL showBorderWhenSelected;

+ (instancetype)horizontalControl;
+ (instancetype)horizontalControl2; // 上下单双
+ (instancetype)verticalControl;

@end
