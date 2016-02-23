//
//  VideoTableViewCell.h
//  HorizonLight
//
//  Created by lanou on 15/9/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
@interface VideoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *view;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, assign) NSUInteger viewStyle;
@property (nonatomic, assign) NSUInteger ranking;

- (void)setValueWithModel:(VideoListModel *)model;


@end
