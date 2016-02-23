//
//  DProjectDetailContentHeaderCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DProjectDetailContentHeaderCell.h"

@interface DProjectDetailContentHeaderCell () {
@private
    UILabel *_accessLabel;
    UILabel *_notesLabel;
    UIImageView *_arrowView;
}

@property (nonatomic, strong, readonly) UILabel *accessLabel;
@property (nonatomic, strong, readonly) UILabel *notesLabel;
@property (nonatomic, strong, readonly) UIImageView *arrowView;
@end

@implementation DProjectDetailContentHeaderCell
@dynamic accessLabel, arrowView, notesLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidLayout];
    }
    return self;
}
- (void)bulidLayout {
    UIView *view = self.contentView;
    view.backgroundColor = [UIColor clearColor];
    UIView *vLine1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.80 alpha:1.0]];
    UIView *vLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xe9e6df)];
    [view addSubview:self.arrowView];
    [view addSubview:self.accessLabel];
    [view addSubview:self.notesLabel];
    [view addSubview:vLine1];
    [view addSubview:vLine2];

    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.width.equalTo(@9.5);
        make.centerY.equalTo(view);
        make.height.equalTo(@6.5);
    }];
    [self.accessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowView.mas_right).offset(2);
        make.width.equalTo(@140);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [self.notesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accessLabel.mas_right);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    [vLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onHandleTap)]];
}

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = dp_ProjectImage(@"content_down.png");
        _arrowView.backgroundColor = [UIColor clearColor];
    }
    return _arrowView;
}
- (UILabel *)notesLabel {
    if (_notesLabel == nil) {
        _notesLabel = [[UILabel alloc] init];
        _notesLabel.backgroundColor = [UIColor clearColor];
        _notesLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _notesLabel.textAlignment = NSTextAlignmentRight;
        _notesLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _notesLabel;
}
- (UILabel *)accessLabel {
    if (_accessLabel == nil) {
        _accessLabel = [[UILabel alloc] init];
        _accessLabel.backgroundColor = [UIColor clearColor];
        _accessLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _accessLabel.textAlignment = NSTextAlignmentLeft;
        _accessLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _accessLabel;
}

- (void)setAccessText:(NSString *)accessText notesText:(NSString *)notesText {
    self.accessLabel.text = accessText;
    self.notesLabel.text = notesText;
}
- (void)_onHandleTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapContentHeaderCell:)]) {
        [self.delegate tapContentHeaderCell:self];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_expand) {
        self.arrowView.transform = CGAffineTransformMakeRotation(-M_PI * .5);
    } else {
        self.arrowView.transform = CGAffineTransformIdentity;
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DProjectDetailContentInvisibleCell

@end
