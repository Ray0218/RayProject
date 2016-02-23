//
//  DPQuick3SectionView.m
//  DacaiProject
//
//  Created by sxf on 14-8-15.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPQuick3SectionView.h"

@implementation DPQuick3SectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(13, 6, 35, 18)];
        UILabel *label=[[UILabel alloc]init];

        label.textColor=UIColorFromRGB(0x58c854);
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont dp_systemFontOfSize:12.0];
        self.titleLabel=label;
        label.backgroundColor=[UIColor colorWithRed:0.07 green:0.37 blue:0.13 alpha:1.0];
        label.layer.cornerRadius = 9;//设置那个圆角的有多圆
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        
        
        UILabel* awLabel = ({
        
            UILabel *label=[[UILabel alloc]init];
            label.textColor=UIColorFromRGB(0x58c854);
            label.textAlignment=NSTextAlignmentRight;
            label.font=[UIFont dp_systemFontOfSize:12.0];
            label.backgroundColor=[UIColor colorWithRed:0.07 green:0.37 blue:0.13 alpha:1.0];
            label.layer.cornerRadius = 9;//设置那个圆角的有多圆
            label.layer.masksToBounds = YES;
            label ;
        });
        [self addSubview:awLabel];
        self.awardLabel = awLabel ;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13) ;
            make.height.equalTo(@18) ;
            make.bottom.equalTo(self).offset(-5) ;

        }] ;
        
        [awLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15) ;
            make.bottom.equalTo(self).offset(-5) ;
            make.height.equalTo(@18) ;
        }];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
