//
//  ClassificationVideoInfoView.h
//  HorizonLight
//
//  Created by lanou on 15/9/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
//播放图标宽高
#define kPlayImgViewWidth 100
#define kPlayImgViewheight 100
#define kLabelHeight 30

@interface ClassificationVideoInfoView : UIView

//播放背景图片
@property (nonatomic, strong) UIImageView *blurbackImgView;
//播放按钮
@property (nonatomic, strong) UIImageView *playImageView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//类别/播放时间
@property (nonatomic, strong) UILabel *classLabel;
//内容简介
@property (nonatomic, strong) UILabel *contentLabel;
//收藏总数
@property (nonatomic, strong) UILabel *collectLabel;
//分享总数
@property (nonatomic, strong) UILabel *shareLabel;
//缓存时间
@property (nonatomic, strong) UILabel *cacheLabel;
//收藏
@property (nonatomic, strong) UIButton *collectButton;
//分享
@property (nonatomic, strong) UIButton *shareButton;
//缓存
@property (nonatomic, strong) UIButton *cacheButton;
//当前页数
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray *imageMArray;
@property (nonatomic, strong) TouchImageView *loadImgView;


- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action row:(NSUInteger)row array:(NSArray *)array ;

- (void)setValueWithModel:(VideoListModel *)model  row:(NSUInteger)row array:(NSArray *)array;

- (void)changeContentValueWithModel:(VideoListModel *)model;

@end
