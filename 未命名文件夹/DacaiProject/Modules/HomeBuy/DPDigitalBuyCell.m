//
//  DPDigitalBuyCell.m
//  DacaiProject
//
//  Created by sxf on 14-7-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalBuyCell.h"

@implementation DPDigitalBuyCell
@synthesize infoLabel, zhushuLabel;
@synthesize dbackView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
         [self bulidLayout];
        
    }
    return self;
}
-(void)bulidLayout{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.allView=view;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    UIView *backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor dp_flatWhiteColor];
    self.dbackView=backView;
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view).offset(10);
        make.bottom.equalTo(view);
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"deleteTransfer001_03.png")] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 17.5, 0, 0)];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(backView.mas_centerY);
        make.bottom.equalTo(view);
        make.left.equalTo(view);
        make.width.equalTo(@40);
    }];
    
    TTTAttributedLabel *hintLabel1 = [[TTTAttributedLabel alloc] init];
    [hintLabel1 setNumberOfLines:0];
    hintLabel1.userInteractionEnabled=NO;
    [hintLabel1 setTextColor:[UIColor dp_flatRedColor]];
    [hintLabel1 setFont:[UIFont systemFontOfSize:14.0f]];
    [hintLabel1 setBackgroundColor:[UIColor clearColor]];
    [hintLabel1 setTextAlignment:NSTextAlignmentLeft];
    [hintLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
    self.infoLabel = hintLabel1;
    [backView addSubview:hintLabel1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont dp_systemFontOfSize:13.0];
    label2.textColor=[UIColor colorWithRed:134.0/255 green:125.0/255 blue:110.0/255 alpha:1];
    self.zhushuLabel = label2;
    [backView addSubview:label2];
    
    [hintLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(6);
        //            make.height.equalTo(@30);
        make.bottom.equalTo(label2.mas_top);
        make.left.equalTo(button.mas_right).offset(2);
        make.right.equalTo(backView).offset(-12);
    }];
    
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.infoLabel.mas_bottom);
        make.bottom.equalTo(backView).offset(-8);
        make.height.equalTo(@20);
        make.left.equalTo(hintLabel1);
        make.right.equalTo(hintLabel1);
    }];
    
    
    UIView *bottomTopLine=[[UIView alloc]init];
    UIView *bottomLine=[[UIView alloc]init];
    UIView *leftLine=[[UIView alloc]init];
    UIView *rightLine=[[UIView alloc]init];
    
    bottomTopLine.backgroundColor=[UIColor colorWithRed:218.0/255 green:206.0/255 blue:185.0/255 alpha:1.0];
    bottomLine.backgroundColor=[UIColor colorWithRed:239.0/255 green:235.0/255 blue:224.0/255 alpha:1.0];
    leftLine.backgroundColor=[UIColor colorWithRed:239.0/255 green:235.0/255 blue:224.0/255 alpha:1.0];
    rightLine.backgroundColor=[UIColor colorWithRed:239.0/255 green:235.0/255 blue:224.0/255 alpha:1.0];
    [backView addSubview:bottomTopLine];
    [backView addSubview:bottomLine];
    [backView addSubview:leftLine];
    [backView addSubview:rightLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView);
        make.height.equalTo(@0.5);
        make.left.equalTo(backView);
        make.right.equalTo(backView);
    }];
    [bottomTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLine.mas_top);
        make.height.equalTo(@0.5);
        make.left.equalTo(backView);
        make.right.equalTo(backView);
    }];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-0.5);
        make.top.equalTo(backView);
        make.left.equalTo(backView);
        make.width.equalTo(@0.5);
    }];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-0.5);
        make.top.equalTo(backView);
        make.right.equalTo(backView);
        make.width.equalTo(@0.5);
    }];
    
    UIImageView *imagview=[[UIImageView alloc]init];
    imagview.backgroundColor=[UIColor clearColor];
    imagview.image=dp_CommonImage(@"right_arrow.png");
    [backView addSubview:imagview];
    [imagview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.height.equalTo(@10);
        make.right.equalTo(backView).offset(-10);
        make.width.equalTo(@6);
    }];

}
-(void)changeCurrentViewHeight:(float)height{
    CGRect rt=self.allView.frame;
    rt.size.height=height;
    self.allView.frame=rt;
}
- (void)deleteBtnClick:(id)sender {
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(DPDigitalBuyDelegate:)]) {
        [self.delegate DPDigitalBuyDelegate:self];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated

{
    if( highlighted == YES )
        
        self.dbackView.backgroundColor = UIColorFromRGB(0xefefe2);
    
    else
        
        self.dbackView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    
    
    [super setHighlighted:highlighted animated:animated];
    
}
@end

@implementation DP3DDigitalBuyCell

-(void)bulidLayout{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    UIView *backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor dp_flatWhiteColor];
    self.dbackView=backView;
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(10);
        make.bottom.equalTo(view);
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"deleteTransfer001_03.png")] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 17.5, 0, 0)];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.bottom.equalTo(view);
        make.left.equalTo(view);
        make.width.equalTo(@40);
    }];
    
    TTTAttributedLabel *hintLabel1 = [[TTTAttributedLabel alloc] init];
    [hintLabel1 setNumberOfLines:0];
    hintLabel1.userInteractionEnabled=NO;
    hintLabel1.userInteractionEnabled=NO;
    [hintLabel1 setTextColor:[UIColor dp_flatRedColor]];
    [hintLabel1 setFont:[UIFont systemFontOfSize:12.0f]];
    [hintLabel1 setBackgroundColor:[UIColor clearColor]];
    [hintLabel1 setTextAlignment:NSTextAlignmentLeft];
    [hintLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
    self.infoLabel = hintLabel1;
    [backView addSubview:hintLabel1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor dp_flatRedColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont dp_systemFontOfSize:13.0];
    label2.textColor=[UIColor dp_flatWhiteColor];
    self.buyTypelabel = label2;
    [backView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = [UIFont dp_systemFontOfSize:13.0];
    label3.textColor=[UIColor colorWithRed:134.0/255 green:125.0/255 blue:110.0/255 alpha:1];
    self.zhushuLabel = label3;
    [backView addSubview:label3];
    [hintLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.bottom.equalTo(label2.mas_top);
        make.left.equalTo(button.mas_right).offset(5);
        make.right.equalTo(backView).offset(-16);
    }];
    
    [self.buyTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.bottom.equalTo(backView).offset(-4);
        make.left.equalTo(hintLabel1);
        make.width.equalTo(@30);
    }];
    [self.zhushuLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2);
        make.bottom.equalTo(label2);
        make.left.equalTo(label2.mas_right).offset(5);
        make.right.equalTo(hintLabel1);
    }];
    
    UIView *bottomTopLine=[[UIView alloc]init];
    UIView *bottomLine=[[UIView alloc]init];
    UIView *leftLine=[[UIView alloc]init];
    UIView *rightLine=[[UIView alloc]init];
    
    bottomTopLine.backgroundColor=[UIColor colorWithRed:218.0/255 green:206.0/255 blue:185.0/255 alpha:1.0];
    bottomLine.backgroundColor=[UIColor colorWithRed:239.0/255 green:235.0/255 blue:224.0/255 alpha:1.0];
    leftLine.backgroundColor=[UIColor colorWithRed:239.0/255 green:235.0/255 blue:224.0/255 alpha:1.0];
    rightLine.backgroundColor=[UIColor colorWithRed:239.0/255 green:235.0/255 blue:224.0/255 alpha:1.0];
    [backView addSubview:bottomTopLine];
    [backView addSubview:bottomLine];
    [backView addSubview:leftLine];
    [backView addSubview:rightLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView);
        make.height.equalTo(@0.5);
        make.left.equalTo(backView);
        make.right.equalTo(backView);
    }];
    [bottomTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLine.mas_top);
        make.height.equalTo(@0.5);
        make.left.equalTo(backView);
        make.right.equalTo(backView);
    }];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-0.5);
        make.top.equalTo(backView);
        make.left.equalTo(backView);
        make.width.equalTo(@0.5);
    }];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-0.5);
        make.top.equalTo(backView);
        make.right.equalTo(backView);
        make.width.equalTo(@0.5);
    }];
    
    UIImageView *imagview=[[UIImageView alloc]init];
    imagview.backgroundColor=[UIColor clearColor];
     imagview.image=dp_CommonImage(@"right_arrow.png");
    [backView addSubview:imagview];
    [imagview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.height.equalTo(@10);
        make.right.equalTo(backView).offset(-10);
        make.width.equalTo(@6);
    }];

}

@end

@implementation DPQuick3DigitalBuyCell

-(void)bulidLayout{
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    // Initialization code
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    UIImageView *backView=[[UIImageView alloc]init];
    backView.backgroundColor=[UIColor clearColor];
    backView.image=[dp_QuickThreeImage(@"q3transCellback.png") resizableImageWithCapInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
    self.backImageView=backView;
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view).offset(8);
        make.bottom.equalTo(view).offset(-2);
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor=[UIColor clearColor];
    [button setImage:dp_SportLotteryImage( @"deleteTransfer001_03.png") forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 17.5, 0, 0)];
    [view addSubview:button];
    [button addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(backView.mas_centerY);
        make.bottom.equalTo(view);
        make.left.equalTo(view);
        make.width.equalTo(@40);
    }];
    
    TTTAttributedLabel *hintLabel1 = [[TTTAttributedLabel alloc] init];
    [hintLabel1 setTextColor:[UIColor dp_flatRedColor]];
    [hintLabel1 setFont:[UIFont systemFontOfSize:14.0f]];
    [hintLabel1 setBackgroundColor:[UIColor clearColor]];
    [hintLabel1 setTextAlignment:NSTextAlignmentLeft];
    [hintLabel1 setNumberOfLines:0];
    [hintLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
    hintLabel1.userInteractionEnabled=NO;
    self.infoLabel = hintLabel1;
    [backView addSubview:hintLabel1];
    
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor dp_flatRedColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont dp_systemFontOfSize:13.0];
    label2.textColor=[UIColor dp_flatWhiteColor];
    self.buyTypelabel = label2;
    [self.contentView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = [UIFont dp_systemFontOfSize:13.0];
    label3.textColor=[UIColor colorWithRed:134.0/255 green:125.0/255 blue:110.0/255 alpha:1];
    self.zhushuLabel = label3;
    [view addSubview:label3];
    
    [self.buyTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.bottom.equalTo(backView).offset(-5);
        make.left.equalTo(button.mas_right).offset(8);
        make.width.equalTo(@35);
    }];
    [self.zhushuLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(@20);
        make.bottom.equalTo(backView).offset(-5);
        make.left.equalTo(label2.mas_right).offset(5);
        make.right.equalTo(backView).offset(-10);
    }];
    [hintLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(5);
//        make.bottom.equalTo(self.buyTypelabel.mas_top).offset(-5);
        make.left.equalTo(button.mas_right).offset(8);
        make.right.equalTo(backView).offset(-10);
    }];
    
    UIImageView *imagview=[[UIImageView alloc]init];
    imagview.backgroundColor=[UIColor clearColor];
    imagview.image=dp_CommonImage(@"right_arrow.png");
    [backView addSubview:imagview];
    [imagview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.height.equalTo(@10);
        make.right.equalTo(backView).offset(-10);
        make.width.equalTo(@6);
    }];
 
}
-(void)upDateBuyLabelContstrant:(NSString *)title{
    int index=title.length;
    if (index<2) {
        return;
    }
    int width=30+(index-2)*15;
    [self.buyTypelabel.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.buyTypelabel && obj.firstAttribute == NSLayoutAttributeWidth) {
            
            obj.constant = width;
            
            [self.contentView setNeedsUpdateConstraints];
            [self.contentView setNeedsLayout];
//            [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
//                [self.view layoutIfNeeded];
//            } completion:nil];
//            
            *stop = YES;
        }
    }];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated

{
    if( highlighted == YES )
        
         self.backImageView.image=[dp_QuickThreeImage(@"q3bg_pressed.png") resizableImageWithCapInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
    
    else
        
         self.backImageView.image=[dp_QuickThreeImage(@"q3transCellback.png") resizableImageWithCapInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
    
    
    
    [super setHighlighted:highlighted animated:animated];
    
}
@end

