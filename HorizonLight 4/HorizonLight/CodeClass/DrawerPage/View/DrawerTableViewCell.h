//
//  DrawerTableViewCell.h
//  HorizonLight
//
//  Created by lanou on 15/9/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *lineView;

- (void)setTitle:(NSString *)title image:(NSString *)image;

@end
