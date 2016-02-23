//
//  HomeTableViewCell.m
//  HorizonLight
//
//  Created by BaQi on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "HomeTableViewCell.h"
//设置Label的边框样式的框架头文件
#import <QuartzCore/QuartzCore.h>
@implementation HomeTableViewCell
 


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //去掉点击cell的效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        //创建类型Label
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 5, 15)];
        //创建类型文本Label
        self.typeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 8, 80, 20)];
        
        //创建ImageView
        self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.typeNameLabel.bottom + 10, 100, 80)];
        //创建Label
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentImageView.right + 10, self.typeNameLabel.bottom + 10, kScreenWidth - self.contentImageView.bottom - 20, 80)];
        
        [self setUptypeNameLabel:self.label];
        [self setUptypeNameLabel:self.typeNameLabel];
        [self setUptitleLabel:self.titleLabel];
        [self.contentView addSubview:self.contentImageView];
        
        
    }
    return self;
}

#pragma mark------设置titleLabel
- (void)setUptitleLabel:(UILabel *)label
{
    //设置文本的颜色
    label.textColor = [UIColor blackColor];
    //设置文本居左
    label.textAlignment = NSTextAlignmentLeft;
    //设置文本显示
    label.numberOfLines = 3;
    //设置字体的大小
    label.font = [UIFont boldSystemFontOfSize:16];
    //设置文本为高亮
    label.highlighted = YES;
    [self.contentView addSubview:label];
}

#pragma mark-----设置typeNameLabel
- (void)setUptypeNameLabel:(UILabel *)label
{    //设置文本的颜色
    UIColor *color = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
    self.label.backgroundColor = color;
    self.typeNameLabel.textColor = color;
    //设置文本居左
    label.textAlignment = NSTextAlignmentLeft;
    //设置文本显示
    label.numberOfLines = 0;
    //设置字体的大小
    label.font = [UIFont systemFontOfSize:13];
    //设置文本为高亮
    label.highlighted = YES;
    [self.contentView addSubview:label];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
