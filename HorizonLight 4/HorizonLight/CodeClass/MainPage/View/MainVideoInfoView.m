//
//  MainVideoInfoView.m
//  HorizonLight
//
//  Created by BaQi on 15/9/23.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "MainVideoInfoView.h"

@implementation MainVideoInfoView

- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action  section:(NSInteger)section row:(NSInteger)row array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建一个scrollView
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2 - 32)];
        //设置允许滑动
        self.scrollView.scrollEnabled = YES;
        self.scrollView.pagingEnabled = YES;
        //左右滑动
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * ([array[section] count] + 2), 0);
        //边界回弹
        self.scrollView.bounces = YES;
        //时候显示水平指示器
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake(kScreenWidth * (row + 1), 0);
        for (int i = 0; i < [array[section] count] + 2; i++)
        {
            self.settingImageView = [[TouchImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight / 2 - 32) taget:taget action:action];
            self.settingImageView.backgroundColor = [UIColor redColor];
            self.settingImageView.tag = 1000 + i;
            [self.scrollView addSubview:self.settingImageView];
        }
        //播放按钮的图片
        self.playImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 80) / 2, (kScreenHeight - (kScreenHeight / 2) - 80) / 2, 80, 80)];
        self.playImageView.image = [UIImage imageNamed:@"player_play@2x"];
        //内容背景
        self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.scrollView.bottom,  kScreenWidth, kScreenHeight / 2 - 32)];
        //打开背景图片的交互
        self.contentImageView.userInteractionEnabled = YES;
        
        //标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 25)];
        //分类和时间
        self.classLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 10, 150, 20)];
        //内容简介
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.classLabel.left, self.classLabel.bottom + 10, kScreenWidth - 30, 100)];
        //加入收藏按钮
        self.clickPraiseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.clickPraiseButton.frame = CGRectMake(self.contentLabel.left + 55, self.contentLabel.bottom + 30, 30, 30);
        [self.clickPraiseButton setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f08a(0)_48"] forState:(UIControlStateNormal)];
        [self.clickPraiseButton setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f004(0)_48"] forState:(UIControlStateSelected)];
        //收藏次数
        self.clickPraiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.clickPraiseButton.right, self.clickPraiseButton.top + 5, 50, 20)];
        
        //分享按钮
        self.shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.shareButton.frame = CGRectMake(self.clickPraiseButton.right + 125, self.clickPraiseButton.top, 30, 30);
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"FontAwesome_f0ac(0)_48"] forState:(UIControlStateNormal)];
        //分享次数
        self.shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.shareButton.right, self.shareButton.top + 5, 50, 20)];
        
        //label的方法调用
        [self setUpTitleLabel:self.titleLabel];
        [self setUpLabel:self.classLabel];
        [self setUpLabel:self.contentLabel];
        [self setUpLabel:self.clickPraiseLabel];
        [self setUpLabel:self.shareLabel];
        [self.contentImageView addSubview:self.clickPraiseButton];
        [self.contentImageView addSubview:self.shareButton];
        [self addSubview:self.scrollView];
        [self addSubview:self.playImageView];
        [self addSubview:self.contentImageView];
    }
    return self;
}

#pragma mark ------Label的属性
- (void)setUpLabel:(UILabel *)label
{
    //颜色
    label.textColor = [UIColor whiteColor];
    //居左
    label.textAlignment = NSTextAlignmentLeft;
    //字体和大小
    label.font = [UIFont systemFontOfSize:13];
    //全部显示
    label.numberOfLines = 0;
    [self.contentImageView addSubview:label];
}
#pragma mark ------标题Laebl
- (void)setUpTitleLabel:(UILabel *)label
{
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0;
    [self.contentImageView addSubview:label];
}

- (void)setUpViewWithModel:(VideoListModel*)model section:(NSInteger)section array:(NSMutableArray *)array
{
    for (int i = 0; i <= [array[section] count] + 1; i++)
    {
        TouchImageView *touchImgView = (TouchImageView *)[self viewWithTag:1000 + i];
        if (i == [array[section] count] + 1 || i == 0)
        {
            touchImgView.image = [UIImage imageNamed:@"yun.gif"];
        }
        else
        {
            VideoListModel *model = array[section][i - 1];
            [touchImgView sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail]];
        }
    }
    
    [self changeContentValueWithModel:model];
}

- (void)changeContentValueWithModel:(VideoListModel *)model
{
    NSMutableArray* mArray = [[NewsDataBase shareDataBase] allNewsOfDBTable:@"myCollectionDB"];
    if ([mArray count] > 0)
    {
        for (VideoListModel* m in mArray) {
            if ([m.title isEqualToString:model.title]) {
                self.clickPraiseButton.selected = YES;
            }
        }
    }
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.coverBlurred] placeholderImage:[UIImage imageNamed:@"yun.gif"]];
    self.titleLabel.text = model.title;
    self.classLabel.text = [NSString stringWithFormat:@"#%@ / %02ld'%02ld\"", model.category, [model.duration integerValue] / 60, [model.duration integerValue] % 60];
    self.contentLabel.text = model.videoListDescription;
    self.clickPraiseLabel.text = [NSString stringWithFormat:@"%ld", model.collectionCount];
    self.shareLabel.text = [NSString stringWithFormat:@"%ld", model.shareCount];
}

@end
