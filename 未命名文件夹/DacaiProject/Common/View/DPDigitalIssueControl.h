//
//  DPDigitalIssueControl.h
//  DacaiProject
//
//  Created by sxf on 14-7-31.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPDigitalIssueControl : UIControl

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *oddsText;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *oddsColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *oddsFont;
@property(nonatomic,strong) UIImageView *selectView;
+ (instancetype)oneRowControl;
+ (instancetype)twoRowControl;
@end
