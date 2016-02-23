//
//  TopTableViewCell.h
//  HorizonLight
//
//  Created by lanou on 15/9/22.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"

@interface TopTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *view;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, assign) NSUInteger ranking;

- (void)setValueWithModel:(VideoListModel *)model;

@end
