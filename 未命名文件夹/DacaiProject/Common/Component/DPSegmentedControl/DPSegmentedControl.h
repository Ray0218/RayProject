//
//  DPSegmentedControl.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DPSegmentedContainer : UIView

- (instancetype)initWithItems:(NSArray *)items;

@property (nonatomic, strong, readonly) NSArray *labels; // UILabel
@property (nonatomic, strong, readonly) NSArray *layers;
@property (nonatomic, strong, readonly) UIView *indicator;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *items;
@end


@interface DPSegmentedControl : UIControl

@property (nonatomic, strong, readonly) UIColor *tintColor;

- (instancetype)initWithItems:(NSArray *)items;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) DPSegmentedContainer *containerView;


@end
