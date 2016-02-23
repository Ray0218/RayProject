//
//  TopTableViewCell.m
//  HorizonLight
//
//  Created by lanou on 15/9/22.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "TopTableViewCell.h"

@implementation TopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = NO;
        
        //图片
        self.view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5 * 2)];
        [self.contentView addSubview:self.view];
        
        //大标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, 30)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:self.titleLabel];
        
        //分类,总时间
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, 30)];
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.view addSubview:self.infoLabel];
        
        self.rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, 30)];
        
        _rankingLabel.textColor = [UIColor whiteColor];
        _rankingLabel.textAlignment = NSTextAlignmentCenter;
        _rankingLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:18];
        [self.view addSubview:_rankingLabel];
        
        for (int i = 0; i < 2; i++)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 50) / 2, 150 + i * 30, 50, 1)];
            lineView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:lineView];
        }
    }
    return self;
}
- (void)setValueWithModel:(VideoListModel *)model
{
    //图片,时间,title赋值
    [self.view sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail]];
    self.titleLabel.text = model.title;
    self.infoLabel.text = [NSString stringWithFormat:@"#%@ / %02ld'%02ld\"", model.category, [model.duration integerValue] / 60, [model.duration integerValue] % 60];
    self.rankingLabel.text = [NSString stringWithFormat:@"%ld.", self.ranking + 1];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
