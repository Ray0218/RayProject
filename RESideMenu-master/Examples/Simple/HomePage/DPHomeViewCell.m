//
//  DPHomeViewCell.m
//  RESideMenuExample
//
//  Created by Ray on 15/12/4.
//  Copyright © 2015年 Roman Efimov. All rights reserved.
//

#import "DPHomeViewCell.h"

@implementation DPHomeViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor] ;
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.numLabel];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15) ;
            make.left.equalTo(self.contentView).offset(15) ;
            make.width.and.height.mas_equalTo(35) ;
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15) ;
            make.left.equalTo(self.iconView.mas_right).offset(15) ;
         }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(14) ;
            make.right.equalTo(self.contentView).offset(-10) ;
        }];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-10) ;
            make.left.equalTo(self.titleLabel) ;
            make.right.equalTo(self.contentView).offset(-50) ;
        }];
        
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-10) ;
            make.width.mas_greaterThanOrEqualTo(17) ;
            make.height.mas_equalTo(17) ;
        }];
        
    }
    return self;
}

-(UIImageView*)iconView{

    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]init] ;
        _iconView.backgroundColor = [UIColor greenColor] ;
     }
    
    return _iconView ;
}

-(UILabel*)titleLabel{
    if (_titleLabel == nil) {
       _titleLabel = [self createLabelWithFont:16.0 color:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] align:NSTextAlignmentLeft backColor:[UIColor clearColor]] ;
      }
    
    return _titleLabel ;
}

-(UILabel*)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [self createLabelWithFont:10.0 color:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] align:NSTextAlignmentCenter backColor:[UIColor clearColor]] ;
     }
    
    return _timeLabel ;
}

-(UILabel*)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [self createLabelWithFont:14.0 color:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] align:NSTextAlignmentCenter backColor:[UIColor clearColor]] ;
    }
    
    return _detailLabel ;
}

-(UILabel*)numLabel{
    if (_numLabel == nil) {
        _numLabel = [self createLabelWithFont:10.0 color:[UIColor whiteColor] align:NSTextAlignmentCenter backColor:[UIColor redColor]] ;
        _numLabel.layer.cornerRadius = 8.5 ;
        _numLabel.clipsToBounds = YES ;
    }
    
    return _numLabel ;
}


-(UILabel*)createLabelWithFont:(CGFloat)font color:(UIColor*)color align:(NSTextAlignment)align backColor:(UIColor*)backColor{

    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:font] ;
    lab.textColor = color ;
    lab.backgroundColor = backColor ;
    lab.textAlignment = align ;
         
    return lab ;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
