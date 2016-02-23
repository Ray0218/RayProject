//
//  DPZcTransferCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPZcTransferCell.h"
#import "DPBetToggleControl.h"
@interface DPZcTransferCell () {
@private
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_middleLabel;
    UILabel *_orderNumberLabel;
    UIButton *_markButton;
    UIButton *_deleteButton;
    
    UILabel *_contentLabel;
    
    NSArray *_betOption9;
    NSArray *_betOption14;
}
@property (nonatomic, strong, readonly) UIButton *deleteButton;
@end
@implementation DPZcTransferCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    
   
    [contentView addSubview:self.homeNameLabel];
    [contentView addSubview:self.awayNameLabel];
    [contentView addSubview:self.middleLabel];
    
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-53);
        make.height.equalTo(@14);
        make.width.equalTo(@70);
        make.right.equalTo(self.middleLabel.mas_left).offset(-10);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-53);
        make.height.equalTo(@14);;
        make.width.equalTo(@70);
        make.left.equalTo(self.middleLabel.mas_right).offset(10);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-53);
        make.height.equalTo(@14);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@30);
    }];
   

    switch (self.gameType) {
        case GameTypeZc14:
        {
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.backgroundColor=[UIColor clearColor];
            imageView.image=dp_SportLotteryImage(@"sfctransferNumber.png");
            [contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView).offset(-5);
                make.left.equalTo(contentView).offset(12);
                make.width.equalTo(@16.5);
                make.height.equalTo(@16.5);
            }];
            [imageView addSubview:self.orderNumberLabel];
            [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            [self zc14BuildLayout];
        }
            break;
        case GameTypeZc9:
        {
            [contentView addSubview:self.markButton];
            [contentView addSubview:self.deleteButton];
            [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(contentView).offset(-8.5);
                make.right.equalTo(contentView).offset(-5);
                make.width.equalTo(@45);
                make.height.equalTo(@55);
            }];
            
            [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView);
                make.height.equalTo(@80);
                make.left.equalTo(contentView);
                make.width.equalTo(@50);
            }];

            [self zc9BuildLayout];
        }
            break;
        
        default:
            break;
    }
}

- (void)zc14BuildLayout {
    UIView *contentView = self.contentView;
    UIView *assistView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    [self.contentView addSubview:assistView];
    
    [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumberLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    DPBetToggleControl *winControl = [DPBetToggleControl horizontalControl2];
    [winControl setTitleText:@"3 "];
    [winControl setTag:self.gameType << 16 | 0];
    [winControl setNormalImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferLeftNormal.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [winControl setSelectedImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferLeftSel.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [winControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    
    DPBetToggleControl *tieControl = [DPBetToggleControl horizontalControl];
    [tieControl setTitleText:@"1 "];
    [tieControl setTag:self.gameType << 16 | 1];
    [tieControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    [tieControl setNormalBgColor:UIColorFromRGB(0xf4f3ef)];//[UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1]];
    
    DPBetToggleControl *loseControl = [DPBetToggleControl horizontalControl2];
    [loseControl setTitleText:@"0 "];
    [loseControl setTag:self.gameType << 16 | 2];
    [loseControl setNormalImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferRightNormal.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [loseControl setSelectedImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferRightSel.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [loseControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:winControl];
    [contentView addSubview:tieControl];
    [contentView addSubview:loseControl];
    
    [tieControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(assistView).multipliedBy(0.33);
        make.centerX.equalTo(assistView);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    [winControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(tieControl);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.right.equalTo(tieControl.mas_left);
    }];
    [loseControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(tieControl);
         make.bottom.equalTo(self.contentView).offset(-12);
        make.left.equalTo(tieControl.mas_right);
    }];
    
    UIView *line1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        view;
    });
    UIView *line2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        view;
    });
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tieControl);
        make.bottom.equalTo(tieControl);
        make.left.equalTo(tieControl);
        make.width.equalTo(@1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tieControl);
        make.bottom.equalTo(tieControl);
        make.right.equalTo(tieControl);
        make.width.equalTo(@1);
    }];
    
    _betOption14 = @[winControl, tieControl, loseControl];
}

- (void)zc9BuildLayout {
    UIView *contentView = self.contentView;
    UIView *assistView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    [self.contentView addSubview:assistView];
    
    [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteButton.mas_right).offset(10);
        make.right.equalTo(self.markButton.mas_left).offset(-10);
    }];
    
    DPBetToggleControl *winControl = [DPBetToggleControl horizontalControl2];
    [winControl setTitleText:@"3 "];
    [winControl setTag:self.gameType << 16 | 0];
    [winControl setNormalImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferLeftNormal.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [winControl setSelectedImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferLeftSel.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [winControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    
    DPBetToggleControl *tieControl = [DPBetToggleControl horizontalControl];
    [tieControl setTitleText:@"1 "];
    [tieControl setTag:self.gameType << 16 | 1];
    [tieControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    [tieControl setNormalBgColor:UIColorFromRGB(0xf4f3ef)];//[UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1]];
    
    DPBetToggleControl *loseControl = [DPBetToggleControl horizontalControl2];
    [loseControl setTitleText:@"0 "];
    [loseControl setTag:self.gameType << 16 | 2];
    [loseControl setNormalImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferRightNormal.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [loseControl setSelectedImage:[UIImage dp_customImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, @"transferRightSel.png") customBlock:^UIImage *(UIImage *image) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 15) resizingMode:UIImageResizingModeStretch];
        return image;
    } tag:@"resize"]];
    [loseControl addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:winControl];
    [contentView addSubview:tieControl];
    [contentView addSubview:loseControl];
    
    [tieControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(assistView).multipliedBy(0.33);
        make.centerX.equalTo(assistView);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    [winControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(tieControl);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.right.equalTo(tieControl.mas_left);
    }];
    [loseControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(tieControl);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.left.equalTo(tieControl.mas_right);
    }];
    
    UIView *line1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        view;
    });
    UIView *line2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        view;
    });
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tieControl);
        make.bottom.equalTo(tieControl);
        make.left.equalTo(tieControl);
        make.width.equalTo(@1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tieControl);
        make.bottom.equalTo(tieControl);
        make.right.equalTo(tieControl);
        make.width.equalTo(@1);
    }];
    
    _betOption9 = @[winControl, tieControl, loseControl];
}
- (void)pvt_onDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteZcTransferCell:)]) {
        [self.delegate deleteZcTransferCell:self];
    }
}

- (void)pvt_onMark {
    
    self.markButton.selected = !self.markButton.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zcTransferCell:mark:)]) {
        [self.delegate zcTransferCell:self mark:self.markButton.isSelected];
    }
}

- (void)pvt_onBet:(DPBetToggleControl *)control {
    control.selected = !control.isSelected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zcTransferCell:index:selected:)]) {
        [self.delegate zcTransferCell:self index:control.tag & 0x0000FFFF selected:control.isSelected];
    }
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
        _homeNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _homeNameLabel;
}

- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _awayNameLabel.textColor = [UIColor dp_flatBlackColor];
        _awayNameLabel.textAlignment = NSTextAlignmentLeft;
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
        _middleLabel.text = @"VS";
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

- (NSArray *)betOption14 {
    return _betOption14;
}

- (NSArray *)betOption9 {
    return _betOption9;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
