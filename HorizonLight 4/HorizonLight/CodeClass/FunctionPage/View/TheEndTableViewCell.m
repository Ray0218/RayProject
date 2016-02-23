//
//  TheEndTableViewCell.m
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "TheEndTableViewCell.h"

@implementation TheEndTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5 * 2);
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = NO;
        
        self.endLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, (self.frame.size.height - 30) / 2, 200, 30)];
        self.endLabel.textColor = [UIColor blackColor];
        self.endLabel.textAlignment = NSTextAlignmentCenter;
        self.endLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:18];
        self.endLabel.text = @"- The End -";
        [self addSubview:self.endLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
