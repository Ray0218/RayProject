//
//  VideoInfoView.m
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "VideoInfoView.h"
#import "UIImageView+WebCache.h"

@implementation VideoInfoView

#pragma mark----- 初始化
- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action array:(NSArray *)array indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpViewtaget:taget action:action array:array];
        [self setUpScrollViewWithArray:array indexPath:indexPath];
        //设置Label的属性
        [self setUpTitle:self.titleLabel];
        [self setUpLabel:self.classLabel];
        [self setUpLabel:self.contentLabel];
        [self setUpLabel:self.clickPraiseLabel];
        [self setUpLabel:self.shareLabel];
        [self setUpLabel:self.cacheLabel];
        //添加在imageView上
        [self.contentImageView addSubview:self.titleLabel];
        [self.contentImageView addSubview:self.classLabel];
        [self.contentImageView addSubview:self.contentLabel];
        [self.contentImageView addSubview:self.clickPraiseLabel];
        [self.contentImageView addSubview:self.shareLabel];
        [self.contentImageView addSubview:self.cacheLabel];
        [self.contentImageView addSubview:self.clickPraiseButton];
        [self.contentImageView addSubview:self.shareButton];
        [self.contentImageView addSubview:self.cacheButton];
        //添加scrollView
        //[self.scrollView addSubview:self.settingImageView];
        [self addSubview:self.scrollView];
        [self addSubview:self.contentImageView];
        [self addSubview:self.playImageView];
    }
    return self;
}

#pragma mark-----创建页面的内容
- (void)setUpViewtaget:taget action:(SEL)action array:(NSArray *)array
{
    
     self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,  kScreenHeight / 2 - 32)];
    //播放背景图片
    for (int i = 0; i < [array count]; i++)
    {
        TouchImageView *touchImageView = [[TouchImageView alloc]initWithFrame:CGRectMake(0, kScreenWidth * i,  kScreenWidth , kScreenHeight / 2 - 32) taget:taget action:action];
        touchImageView.backgroundColor = [UIColor cyanColor];
        touchImageView.tag = 1000 + i;
        [self.scrollView addSubview:touchImageView];
    }
//    self.settingImageView = [[TouchImageView alloc]initWithFrame:CGRectMake(0, 0,  kScreenWidth , kScreenHight / 2 - 32) taget:taget action:action];
    //播放按钮图片
    self.playImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 80) / 2, (kScreenHeight - (kScreenHeight / 2) - 80) / 2, 80, 80)];
    self.playImageView.image = [UIImage imageNamed:@"player_play@2x"];
    //播放内容图片
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight / 2 - 32, kScreenWidth, kScreenHeight / 2)];
    self.contentImageView.userInteractionEnabled = YES;
    CGFloat width = self.contentImageView.frame.size.width;
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, width - 30, 25)];
    //分类和时间
    self.classLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 55, 150, 20)];
    //内容简介
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 75, width - 20, 100)];
    //加入收藏
    self.clickPraiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 190, 40, 20)];
    //分享数量
    self.shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 190, 40, 20)];
    //缓存速度
    self.cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 190, 40, 20)];
    self.cacheLabel.text = @"缓存";
    //收藏按钮
    self.clickPraiseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //分享按钮
    self.shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //缓存按钮
    self.cacheButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.clickPraiseButton.frame = CGRectMake(20, 180, 30, 30);
    self.shareButton.frame = CGRectMake(120, 180, 30, 30);
    self.cacheButton.frame = CGRectMake(220, 180, 30, 30);
    [self.clickPraiseButton setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f08a(0)_48"] forState:(UIControlStateNormal)];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"Entypo_e73c(0)_48"] forState:(UIControlStateNormal)];
    [self.cacheButton setBackgroundImage:[UIImage imageNamed:@"Entypo_e778(0)_48"] forState:(UIControlStateNormal)];
}

#pragma mark-----设置滑动
- (void)setUpScrollViewWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath
{
    //设置允许滑动
    self.scrollView.scrollEnabled = YES;
    //左右滑动
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * [array count], 0);
    //边界回弹
    self.scrollView.bounces = YES;
    //时候显示水平指示器
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentOffset = CGPointMake(kScreenWidth * indexPath.row, 0);
}

#pragma mark - 设置Label的属性 -
- (void)setUpLabel:(UILabel *)label
{
    //文本颜色
    label.textColor = [UIColor whiteColor];
    //文本居左
    label.textAlignment = NSTextAlignmentLeft;
    //文本字体和大小
    label.font = [UIFont systemFontOfSize:13];
    //文本全部输出
    label.numberOfLines = 0;
}
- (void)setUpTitle:(UILabel *)label
{
    //文本颜色
    label.textColor = [UIColor whiteColor];
    //文本居左
    label.textAlignment = NSTextAlignmentLeft;
    //文本字体和大小
    label.font = [UIFont boldSystemFontOfSize:16];
    //文本全部输出
    label.numberOfLines = 0;
}

#pragma mark-----Model赋值
- (void)setValueWithModel:(VideoListModel *)model array:(NSArray *)array
{
    //播放图片
    for (int i = 0; i < [array count]; i++)
    {
        TouchImageView *touchImgView = (TouchImageView *)[self viewWithTag:1000 + i];
        VideoListModel *mod = array[i];
        [touchImgView sd_setImageWithURL:[NSURL URLWithString:mod.coverForDetail]];
    }
//    [self.settingImageView sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail]];
    //模糊图片
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.coverBlurred]];
    //标题
    self.titleLabel.text = model.title;
    //分割线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 45, [self.titleLabel.text length] * 10, 0.5)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentImageView addSubview:view];
    //类别和时间
    self.classLabel.text =  [NSString stringWithFormat:@"#%@ / %02ld'%02ld\"",model.category, [model.duration integerValue] / 60, [model.duration integerValue] % 60];
    //内容简介
    self.contentLabel.text = model.videoListDescription;
    //点赞数
    self.clickPraiseLabel.text = [NSString stringWithFormat:@"%ld", model.collectionCount];
    //分享
    self.shareLabel.text = [NSString stringWithFormat:@"%ld", model.shareCount];
}

@end
