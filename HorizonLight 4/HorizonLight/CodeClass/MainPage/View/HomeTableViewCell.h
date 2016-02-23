//
//  HomeTableViewCell.h
//  HorizonLight
//
//  Created by BaQi on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

//图片
@property (nonatomic, strong) UIImageView *contentImageView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//类型
@property (nonatomic, strong) UILabel *typeNameLabel;

@property (nonatomic, strong) UILabel *label;
@end
