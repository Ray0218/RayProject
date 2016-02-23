//
//  ClassificationVideoInfoView.m
//  HorizonLight
//
//  Created by lanou on 15/9/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ClassificationVideoInfoView.h"

@implementation ClassificationVideoInfoView

- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action row:(NSUInteger)row array:(NSArray *)array
{
    if (self = [super initWithFrame:frame])
    {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5 * 2)];
        //设置允许滑动
        self.scrollView.scrollEnabled = YES;
        //左右滑动
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * ([array count] + 2), 0);
        //边界回弹
        self.scrollView.bounces = YES;
        self.scrollView.pagingEnabled = YES;
        //时候显示水平指示器
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake(kScreenWidth * (row + 1), 0);
        
        //把拖进去的图片放进一个数组中
        self.imageMArray = [NSMutableArray array];
        for (int i = 1; i < 10; i++)
        {
            //拼接图片名字
            NSString *name = [NSString stringWithFormat:@"yun－%d.jpg", i];
            //用名字初始化图片
            UIImage *image = [UIImage imageNamed:name];
            //添加进数组
            [self.imageMArray addObject:image];
        }
        self.loadImgView = [[TouchImageView alloc] init];
        //添加播放数组
        self.loadImgView.animationImages = self.imageMArray;
        //设置每一张图片给的播放时间
        self.loadImgView.animationDuration = 0.1 * self.imageMArray.count;
        //设置重复播放几次
        self.loadImgView.animationRepeatCount = 0;
        //开启播放
        [self.loadImgView startAnimating];
        _loadImgView.frame = CGRectMake(0, 0, kScreenWidth, _scrollView.height);
        [_scrollView addSubview:_loadImgView];
        
        //播放图片
        for (int i = 1; i < [array count] + 1; i++)
        {
            TouchImageView *touchImgView = [[TouchImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, _scrollView.height) taget:taget action:action];
            touchImgView.tag = 1000 + i;
            [_scrollView addSubview:touchImgView];
        }
        [self addSubview:self.scrollView];
        
        //播放按钮的图片
        self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kPlayImgViewWidth) / 2, (_scrollView.height - kPlayImgViewheight) / 2, kPlayImgViewWidth, kPlayImgViewheight)];
        self.playImageView.image = [UIImage imageNamed:@"player_play@2x"];
        [self addSubview:self.playImageView];
        
        //内容背景
        self.blurbackImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _scrollView.bottom, kScreenWidth, self.height - _scrollView.bottom)];
        _blurbackImgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.blurbackImgView];
        self.blurbackImgView.userInteractionEnabled = YES;
        
        //标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kEdge, kEdge, _blurbackImgView.width - 2 * kEdge, kLabelHeight)];
        [self setUpLabel:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:19];
        
        //分类和时间
        self.classLabel = [[UILabel alloc]initWithFrame:CGRectMake(kEdge, _titleLabel.bottom, kScreenWidth - 2 * kEdge, kLabelHeight)];
        [self setUpLabel:_classLabel];
        [self.blurbackImgView addSubview:self.classLabel];
        
        //内容简介
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kEdge, _classLabel.bottom + kEdge, kScreenWidth - 2 * kEdge, 4 * kLabelHeight)];
        [self setUpLabel:_contentLabel];
        
        //收藏按钮
        self.collectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //分享按钮
        self.shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.collectButton.frame = CGRectMake(kEdge, _contentLabel.bottom + 3 * kEdge, kIconWidth , kIconHeight);
        self.shareButton.frame = CGRectMake(kScreenWidth / 2, _collectButton.top, kIconWidth, kIconHeight);
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f08a(0)_48"] forState:(UIControlStateNormal)];
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f0ac(0)_48"] forState:(UIControlStateNormal)];
        [_blurbackImgView addSubview:_collectButton];
        [_blurbackImgView addSubview:_shareButton];
        //加入收藏
        self.collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(kEdge + kIconWidth, _collectButton.top, (kScreenWidth - _collectButton.right), kLabelHeight)];
        [self setUpLabel:_collectLabel];
        //分享数量
        self.shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + kIconWidth, _collectButton.top, _collectLabel.width, kLabelHeight)];
        [self setUpLabel:_shareLabel];
        
        //分割线
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 45, [self.titleLabel.text length] * 13, 1)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 2000;
        [self.blurbackImgView addSubview:view];
    }
    return self;
}

#pragma mark-----设置Label的属性
- (void)setUpLabel:(UILabel *)label
{
    //文本颜色
    label.textColor = [UIColor whiteColor];
    //文本居左
    label.textAlignment = NSTextAlignmentLeft;
    //文本字体和大小
    label.font = [UIFont systemFontOfSize:16];
    //文本全部输出
    label.numberOfLines = 0;
    [self.blurbackImgView addSubview:label];
}

#pragma mark-----Model赋值
- (void)setValueWithModel:(VideoListModel *)model row:(NSUInteger)row array:(NSArray *)array
{
    for (int i = 0; i < [array count] + 2; i++)
    {
        UIImageView *touchImgView = (UIImageView *)[self viewWithTag:1000 + i];
        if (i == 0 || i == [array count] + 1)
        {
            //添加播放数组
            touchImgView.animationImages = self.imageMArray;
            //设置每一张图片给的播放时间
            touchImgView.animationDuration = 0.1 * self.imageMArray.count;
            //设置重复播放几次
            touchImgView.animationRepeatCount = 0;
            //开启播放
            [touchImgView startAnimating];
        }
        else
        {
            VideoListModel *mod = array[i - 1];
            [touchImgView sd_setImageWithURL:[NSURL URLWithString:mod.coverForDetail]];
        }
    }
    //模糊图片
    [self.blurbackImgView sd_setImageWithURL:[NSURL URLWithString:model.coverBlurred]];
    //标题
    self.titleLabel.text = model.title;
    //分割线
    UIView *view = (UIView *)[self viewWithTag:2000];
    view.frame = CGRectMake(15, 45, [self.titleLabel.text length] * 13, 1);
    //类别和时间
    self.classLabel.text =  [NSString stringWithFormat:@"#%@ / %02ld'%02ld\"",model.category, [model.duration integerValue] / 60, [model.duration integerValue] % 60];
    //内容简介
    self.contentLabel.text = model.videoListDescription;
    //点赞数
    self.collectLabel.text = [NSString stringWithFormat:@"%ld", model.collectionCount];
    //分享
    self.shareLabel.text = [NSString stringWithFormat:@"%ld", model.shareCount];
}

- (void)changeContentValueWithModel:(VideoListModel *)model
{
    [self.blurbackImgView sd_setImageWithURL:[NSURL URLWithString:model.coverBlurred]];
    self.titleLabel.text = model.title;
    self.classLabel.text = [NSString stringWithFormat:@"#%@ / %02ld'%02ld\"", model.category, [model.duration integerValue] / 60, [model.duration integerValue] % 60];
    self.contentLabel.text = model.videoListDescription;
    self.collectLabel.text = [NSString stringWithFormat:@"%ld", model.collectionCount];
    self.shareLabel.text = [NSString stringWithFormat:@"%ld", model.shareCount];
}

@end
