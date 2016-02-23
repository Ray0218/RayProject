//
//  DProjectDetailOptimizeHeaderCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DProjectDetailOptimizeHeaderCell.h"

@interface DProjectDetailOptimizeHeaderCell () {
@private
    UILabel *_titleLabel;
    UIImageView *_arrowView;
}
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *arrowView;

@end

@implementation DProjectDetailOptimizeHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = self.contentView;
        [view addSubview:self.titleLabel];
        [view addSubview:self.arrowView];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.width.equalTo(@9.5);
            make.centerY.equalTo(view);
            make.height.equalTo(@6.5);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.arrowView.mas_right).offset(2);
            make.width.equalTo(@140);
            make.top.equalTo(view);
            make.bottom.equalTo(view);
        }];
        UIView *line = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.right.equalTo(view);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(view);
        }];

        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onHandleTap)]];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x3f3f3f);
        _titleLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"优化详情";
    }
    return _titleLabel;
}
- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowView.image = dp_ProjectImage(@"content_down.png");
    }
    return _arrowView;
}
- (void)_onHandleTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapOptimizeHeaderCell:)]) {
        [self.delegate tapOptimizeHeaderCell:self];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];

    if (_expand) {
        self.arrowView.transform = CGAffineTransformIdentity;
    } else {
        self.arrowView.transform = CGAffineTransformMakeRotation(M_PI * -0.5);
    }
}

@end

@implementation DProjectDetailOptimizeTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidlayout];
    }
    return self;
}
- (void)bulidlayout {

    UIView *view = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor clearColor];

    UILabel *label1 = [self createlable:@"单注" titleColor:UIColorFromRGB(0x797979) titleFont:[UIFont dp_systemFontOfSize:10.0] alignment:NSTextAlignmentLeft];
    UILabel *label2 = [self createlable:@"注数" titleColor:UIColorFromRGB(0x797979) titleFont:[UIFont dp_systemFontOfSize:10.0] alignment:NSTextAlignmentCenter];
    UILabel *label3 = [self createlable:@"理论奖金" titleColor:UIColorFromRGB(0x797979) titleFont:[UIFont dp_systemFontOfSize:10.0] alignment:NSTextAlignmentRight];
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(40);
        make.right.equalTo(label2.mas_left);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label3.mas_left);
        make.width.equalTo(@65);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.width.equalTo(@65);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [view addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(view);
    }];
}

- (UILabel *)createlable:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *lable = [[UILabel alloc] init];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = color;
    lable.font = titleFont;
    lable.text = title;
    lable.textAlignment = alignment;
    return lable;
}

@end
@implementation DProjectDetailOptimizeListCell

//+ (CGFloat)heightWithLineCount:(NSUInteger)count
//{
//    return count * [@" " sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(1000, 1000)].height + 20;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidlayout];
    }
    return self;
}
- (void)bulidlayout {

    UIView *view = self.contentView;
    self.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor clearColor];

    self.infoLabel = [self createlable:@"" titleColor:UIColorFromRGB(0x635d54) titleFont:[UIFont dp_systemFontOfSize:10.0] alignment:NSTextAlignmentLeft];
    self.infoLabel.numberOfLines = 0;
    self.zhushuLabel = [self createlable:@"" titleColor:UIColorFromRGB(0x635d54) titleFont:[UIFont dp_systemFontOfSize:10.0] alignment:NSTextAlignmentCenter];
    self.bonusLabel = [self createlable:@"" titleColor:UIColorFromRGB(0x635d54) titleFont:[UIFont dp_systemFontOfSize:10.0] alignment:NSTextAlignmentCenter];
    [view addSubview:self.infoLabel];
    [view addSubview:self.zhushuLabel];
    [view addSubview:self.bonusLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.width.equalTo(@170);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [self.zhushuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bonusLabel.mas_left);
        make.width.equalTo(@65);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.width.equalTo(@65);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [view addSubview:vLine1];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(view);
    }];
}

- (UILabel *)createlable:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *lable = [[UILabel alloc] init];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = color;
    lable.font = titleFont;
    lable.numberOfLines = 0;
    lable.text = title;
    lable.textAlignment = alignment;
    return lable;
}

@end
