//
//  ClassificationCollectionViewCell.h
//  HorizonLight
//
//  Created by lanou on 15/9/17.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassificationModel.h"
@interface ClassificationCollectionViewCell : UICollectionViewCell

//分类文本
@property (nonatomic, strong) UILabel *classIficationLabel;
//分类图片
@property (nonatomic, strong) UIImageView *classIficationImageView;

- (void)setValueWithModel:(ClassificationModel *)model;

@end
