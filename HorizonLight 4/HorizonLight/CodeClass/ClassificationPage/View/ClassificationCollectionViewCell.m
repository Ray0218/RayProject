//
//  ClassificationCollectionViewCell.m
//  HorizonLight
//
//  Created by lanou on 15/9/17.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ClassificationCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ClassificationCollectionViewCell

#pragma mark ------初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        //获取当前cell的高度和宽度
        CGFloat width = frame.size.width;
        //创建imageView
        _classIficationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        //创建label
        _classIficationLabel = [[UILabel alloc]initWithFrame:CGRectMake((width - 100) / 2, (width - 30 ) / 2, 100, 30)];
                
        [self setImageView];
        [self setLabel];
        //把文字添加在图片上
        [_classIficationImageView addSubview:_classIficationLabel];
        //加载图片
        [self addSubview:_classIficationImageView];
        
    }
    return self;
}

#pragma mark ------设置Label的属性
- (void)setLabel
{
    //文本的颜色
    _classIficationLabel.textColor = [UIColor whiteColor];
    //文本居中
    _classIficationLabel.textAlignment = NSTextAlignmentCenter;
    //文本的字体和大小
    _classIficationLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
}

#pragma mark ------设置imageView的属性
- (void)setImageView
{
    //设置imageView的颜色
    //_classIficationImageView.backgroundColor = [UIColor orangeColor];
    //打开imageView的交互
    //[_classIficationImageView setUserInteractionEnabled:NO];
}

#pragma mark ------获取model的数据. 给需要的属性赋值
- (void)setValueWithModel:(ClassificationModel *)model
{
    //获取model里的图片
    [_classIficationImageView sd_setImageWithURL:[NSURL URLWithString:model.bgPicture]];
    //获取model里的名字
    _classIficationLabel.text = [NSString stringWithFormat:@"#%@", model.name];
    
}












@end
