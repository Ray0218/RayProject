//
//  VideoInfoView.h
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"

@interface VideoInfoView : UIView
//播放背景图片
@property (nonatomic, strong) TouchImageView *settingImageView;
//播放按钮
@property (nonatomic, strong) UIImageView *playImageView;
//内容图片
@property (nonatomic, strong) UIImageView *contentImageView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//类别/播放时间
@property (nonatomic, strong) UILabel *classLabel;
//内容简介
@property (nonatomic, strong) UILabel *contentLabel;
//收藏总数
@property (nonatomic, strong) UILabel *clickPraiseLabel;
//分享总数
@property (nonatomic, strong) UILabel *shareLabel;
//缓存时间
@property (nonatomic, strong) UILabel *cacheLabel;
//收藏
@property (nonatomic, strong) UIButton *clickPraiseButton;
//分享
@property (nonatomic, strong) UIButton *shareButton;
//缓存
@property (nonatomic, strong) UIButton *cacheButton;

//当前页数
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray* videoArray;


- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action array:(NSArray *)array indexPath:(NSIndexPath *)indexPath;

- (void)setValueWithModel:(VideoListModel *)model array:(NSArray *)array;

@end
