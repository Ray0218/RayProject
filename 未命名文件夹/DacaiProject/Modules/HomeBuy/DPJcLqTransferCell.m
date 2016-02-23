//
//  DPJcLqTransferCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJcLqTransferCell.h"
#import "DPDragView.h"

@interface DPJcLqTransferCell () {
@private
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_middleLabel;
    UILabel *_orderNumberLabel;
    UIButton *_markButton;
    UIButton *_deleteButton;
    
    UILabel *_contentLabel;
}

@property (nonatomic, strong, readonly) UIButton *deleteButton;

@end
@implementation DPJcLqTransferCell
@dynamic homeNameLabel;
@dynamic awayNameLabel;
@dynamic middleLabel;
@dynamic orderNumberLabel;
@dynamic markButton;
@dynamic deleteButton;
@dynamic contentLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return self;
}

- (void)buildLayout {
    UIView *bottomLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.95 green:0.94 blue:0.93 alpha:1]];
    UIView *leftLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.86 green:0.83 blue:0.77 alpha:1]];
    UIView *rightLine = [UIView dp_viewWithColor:[UIColor colorWithRed:0.86 green:0.83 blue:0.77 alpha:1]];
    
    UIView *contentView = self.contentView;
    
    [contentView addSubview:bottomLine];
    [contentView addSubview:leftLine];
    [contentView addSubview:rightLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@0.5);
    }];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.right.equalTo(contentView);
        make.width.equalTo(@0.5);
    }];
    
    [contentView addSubview:self.orderNumberLabel];
    [contentView addSubview:self.homeNameLabel];
    [contentView addSubview:self.awayNameLabel];
    [contentView addSubview:self.middleLabel];
    [contentView addSubview:self.deleteButton];
    [contentView addSubview:self.markButton];
    
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.height.equalTo(@16);
        make.left.equalTo(contentView);
        make.width.equalTo(@50);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-50);
        make.height.equalTo(@14);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@50);

    }];

    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-50);
        make.height.equalTo(@14);
        make.width.equalTo(@70);
        make.right.equalTo(self.middleLabel.mas_left);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-50);
        make.height.equalTo(@14);
        make.width.equalTo(@70);
        make.left.equalTo(self.middleLabel.mas_right);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(contentView.mas_left).offset(25);
           make.bottom.equalTo(contentView).offset(-12);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView).offset(1);
        make.right.equalTo(contentView).offset(-5);
        make.width.equalTo(@45);
        make.height.equalTo(@55);
    }];
}

- (void)loadDragView {
    UIView *contentView = self.contentView;
    DPDragView *dragLabel = [[DPDragView alloc] init];
    dragLabel.image = dp_CommonResizeImage(@"scroll_bg.png");
    dragLabel.customView = self.contentLabel;
    [contentView addSubview:dragLabel];
    
    [dragLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(@30);
        make.bottom.equalTo(contentView).offset(-12);
        make.left.equalTo(self.deleteButton.mas_right).offset(5);
        make.right.equalTo(self.markButton.mas_left).offset(-5);
    }];
}

- (void)loadRfDragView {
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.left.equalTo(self.deleteButton.mas_right).offset(15);
        make.right.equalTo(self.markButton.mas_left).offset(-10);
    }];
    UIView *middleLine = ({
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        line;
    });
    [view addSubview:middleLine];
    
    UIButton *leftButton=[[UIButton alloc]init];
    leftButton.backgroundColor=[UIColor clearColor];
    [leftButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
    leftButton.titleLabel.font=[UIFont dp_systemFontOfSize:12.0];
    [leftButton setBackgroundImage:[dp_SportLotteryImage(@"transferLeftNormal.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[dp_SportLotteryImage(@"transferLeftSel.png")resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag=2000;
    self.jclqtleftBtn=leftButton;
    [view addSubview:leftButton];
    
    UIButton *rightButton=[[UIButton alloc]init];
    rightButton.backgroundColor=[UIColor clearColor];
    [rightButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
    rightButton.titleLabel.font=[UIFont dp_systemFontOfSize:12.0];
    [rightButton setBackgroundImage:[dp_SportLotteryImage(@"transferRightNormal.png")resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15)] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[dp_SportLotteryImage(@"transferRightSel.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15)]forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag=2001;
    self.jclqtRightBtn=rightButton;
    [view addSubview:rightButton];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(middleLine.mas_left);
        make.bottom.equalTo(view);
        make.top.equalTo(view);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
//        make.width.equalTo();
        make.bottom.equalTo(view);
        make.top.equalTo(view);
        make.left.equalTo(middleLine.mas_right);
    }];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
        make.width.equalTo(@1);
    }];

}
-(void)buttonSelected:(UIButton *)button{

    button.selected=!button.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jclqTranCell:selectedIndex: isSelected:)]) {
        [self.delegate jclqTranCell:self selectedIndex:button.tag-2000 isSelected:button.selected];
    }
}
#pragma mark - private 

- (void)pvt_onDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jclqTransferCell:event:)]) {
        [self.delegate jclqTransferCell:self event:DPJclqTransferCellEventDelete];
    }
}

- (void)pvt_onMark {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldMarkJclqTransferCell:)] && [self.delegate respondsToSelector:@selector(jclqTransferCell:event:)]) {
        if ([self.delegate shouldMarkJclqTransferCell:self]) {
            [self.markButton setSelected:!self.markButton.isSelected];
            [self.delegate jclqTransferCell:self event:DPJclqTransferCellEventMark];
        }
    }
}

- (void)pvt_onClick:(UIControl *)sender {
    
}

#pragma mark - getter, setter

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont dp_systemFontOfSize:12];
        _contentLabel.textColor = [UIColor dp_flatRedColor];
    }
    return _contentLabel;
}

- (UILabel *)homeNameLabel {
    if (_homeNameLabel == nil) {
        _homeNameLabel = [[UILabel alloc] init];
        _homeNameLabel.backgroundColor = [UIColor clearColor];
        _homeNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _homeNameLabel.textColor = [UIColor dp_flatBlackColor];
        _homeNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _homeNameLabel;
}

- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _awayNameLabel.textColor = [UIColor dp_flatBlackColor];
        _awayNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _awayNameLabel;
}

- (UILabel *)middleLabel {
    if (_middleLabel == nil) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.backgroundColor = [UIColor clearColor];
        _middleLabel.font = [UIFont dp_systemFontOfSize:13];
        _middleLabel.textColor = [UIColor colorWithRed:0.79 green:0.74 blue:0.62 alpha:1];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _middleLabel;
}

- (UILabel *)orderNumberLabel {
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        _orderNumberLabel.font = [UIFont dp_systemFontOfSize:11];
        _orderNumberLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _orderNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _orderNumberLabel;
}

- (UIButton *)markButton {
    if (_markButton == nil) {
        _markButton = [[UIButton alloc] init];
        _markButton.backgroundColor = [UIColor clearColor] ;
        [_markButton setImage:dp_SportLotteryImage(@"normalDan.png") forState:UIControlStateNormal];
        [_markButton setImage:dp_SportLotteryImage(@"selectDan.png") forState:UIControlStateSelected];
        [_markButton setImage:dp_SportLotteryImage(@"disableDan.png") forState:UIControlStateDisabled];
        [_markButton setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [_markButton addTarget:self action:@selector(pvt_onMark) forControlEvents:UIControlEventTouchUpInside];
    }
    return _markButton;
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:dp_SportLotteryImage(@"close.png") forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(pvt_onDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}


@end
