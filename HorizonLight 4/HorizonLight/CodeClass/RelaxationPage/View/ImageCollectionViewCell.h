//
//  ImageCollectionViewCell.h
//  HorizonLight
//
//  Created by lanou on 15/9/26.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelaxationModel.h"
@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *providerLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIImageView *timerImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *backView;

-(void)setRelaxationModel:(RelaxationModel *)model;
@end
