//
//  DPProjectDetailContentUnknownCell.m
//  DacaiProject
//
//  Created by sxf on 14-9-17.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailContentUnknownCell.h"

@implementation DPProjectDetailContentUnknownCell
@synthesize unKnowView=_unKnowView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self buildLayout];

    }
    return self;
}
-(void)buildLayout{
    UIView *backView=[UIView dp_viewWithColor:[UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0]];
    [self.contentView addSubview:backView];
    [backView addSubview:self.unKnowView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.unKnowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(@120);
        make.height.equalTo(@41);
        }];
//    UIView *line=[UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
//    [backView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backView);
//        make.right.equalTo(backView);
//        make.bottom.equalTo(backView);
//        make.height.equalTo(@0.5);
//    }];


}
-(UIImageView *)unKnowView{
    if (_unKnowView==nil) {
        _unKnowView=[[UIImageView alloc]init];
        _unKnowView.backgroundColor=[UIColor clearColor];
    }
    return _unKnowView;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
