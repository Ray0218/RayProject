//
//  DrawerTableViewCell.m
//  HorizonLight
//
//  Created by lanou on 15/9/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "DrawerTableViewCell.h"

@implementation DrawerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 45, 45)];
        [self.contentView addSubview:self.iconView];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(40 + self.iconView.bounds.size.width, 0, 100, 70)];
        self.title.font = [UIFont boldSystemFontOfSize:15.0];
        self.title.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.title];
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 15 + self.iconView.bounds.size.height, 250, 1)];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (void)setTitle:(NSString *)title image:(NSString *)image
{
    self.title.text = title;
    self.iconView.image = [UIImage imageNamed:image];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
