//
//  DPNavigationTitleButton.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  导航栏标题按钮
//

#import <UIKit/UIKit.h>

@interface DPNavigationTitleButton : UIView

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIColor *titleColor;

- (void)turnArrow;
- (void)restoreArrow;

@end
