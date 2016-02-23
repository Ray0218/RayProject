//
//  ImageCollectionViewCell.m
//  HorizonLight
//
//  Created by lanou on 15/9/26.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    //图片
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
    //分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    //用户图片
    self.userImageView = [[UIImageView alloc] init];
    self.userImageView.image = [UIImage imageNamed:@"FontAwesome_f097(0)_32.png"];
    //时间图片
    self.timerImageView = [[UIImageView alloc] init];
    self.timerImageView.image = [UIImage imageNamed:@"Material Icons_e192(0)_32.png"];
    //主题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    //用户
    self.providerLabel = [[UILabel alloc] init];
    self.providerLabel.font = [UIFont systemFontOfSize:12.0];
    self.providerLabel.textColor = [UIColor lightGrayColor];

    //时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    
    //添加边框
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 8;
    self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.4;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.timerImageView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.providerLabel];
    [self.contentView addSubview:self.timeLabel];
    
}
-(void)setRelaxationModel:(RelaxationModel *)model
{
    CGFloat picHeight;
    NSRange  range = [model.headline_img_tb rangeOfString:@"w/"];
    if (range.length != 0) {
        NSArray *rangOne = [model.headline_img_tb componentsSeparatedByString:@"w/"];
        NSArray *rangTwo = [[rangOne objectAtIndex:1] componentsSeparatedByString:@"/"];
        picHeight = [[rangTwo lastObject]floatValue];
    }else
    {
        picHeight = 250.0;
    }
    
    CGFloat width = self.bounds.size.width;
    self.imageView.frame = CGRectMake(3, 3, width - 6,  picHeight/ 1.7 - 3 );
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.headline_img_tb]];
    self.titleLabel.frame = CGRectMake(0, picHeight / 1.7, width, 40);
    self.lineView.frame = CGRectMake(0, 40 + picHeight / 1.7 , width, 1);
    self.userImageView.frame = CGRectMake(0, 40 + picHeight / 1.7, 20, 25);
    self.providerLabel.frame = CGRectMake(20,  40 + picHeight / 1.7 , width / 2, 25);
    self.timerImageView.frame = CGRectMake(width / 2 + 20,  40 + picHeight / 1.7, 20, 25);
    self.timeLabel.frame = CGRectMake(width / 2 + 40 ,  40 + picHeight / 1.7, width / 2 - 40, 25);
    
    self.titleLabel.text = model.title;
    self.providerLabel.text = model.source_name;
    NSTimeInterval time = model.date_picked;
    [self acquireCurrentTimeWithTime:time];


}
-(void)acquireCurrentTimeWithTime:(NSTimeInterval)time
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval now = (NSUInteger)[nowDate timeIntervalSince1970] - (NSUInteger)time;
    if (now < 60)
    {
        self.timeLabel.text = @"刚刚";
    }
    else if (now < 3600)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f分钟前", now / 60];
    }
    else if (now < 3600 * 24)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f小时前", now / 3600];
    }
    else
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f天前", now / 3600 / 24];
    }
}




@end
