//
//  DPLotteryInfoTableViewCell.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-19.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLotteryInfoTableViewCell.h"

@interface DPLotteryInfoTableViewCell ()
{
    UIView              *_leftLine; // 左边彩条
    NSString            *_title;
    NSString            *_subTitle;
    NSString            *_urlString;
    NSIndexPath         *_indexPath;
    NSArray             *_colorArray;
    UILabel             *_headLabel;
    UILabel             *_bottomLabel;
}
@property (nonatomic, strong, readonly)UILabel *headLabel;
@property (nonatomic, strong, readonly)UILabel *bottomLabel;
@property (nonatomic, strong, readonly)UIView  *leftLine;

@end

@implementation DPLotteryInfoTableViewCell
@dynamic title;
@dynamic subTitle;
@dynamic urlString;
@dynamic indexPath;
@dynamic headLabel;
@dynamic bottomLabel;
@dynamic leftLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self buildUI];
        
    }
    return self;
}
- (void)buildUI
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#FAF9F2"];
//    self.contentView.backgroundColor = [UIColor clearColor];
    
//    UIView *bgView = [[UIView alloc]init];
//    bgView.backgroundColor = [UIColor dp_colorFromHexString:@"#DDDBD4"];
//    [self setSelectedBackgroundView:bgView];
//    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    [self.contentView addSubview:self.bottomLabel];
    [self.contentView addSubview:self.headLabel];
    [self.contentView addSubview:self.leftLine];
    
    UIView *superView = self.contentView;
    
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superView).offset(8);
        make.left.equalTo(superView).offset(10);
        make.right.equalTo(superView).offset(-10);
//        make.centerY.equalTo(superView);
        make.top.equalTo(superView).offset(15);

    }];
    
    self.headLabel.preferredMaxLayoutWidth = 300;
    
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(10);
        make.right.equalTo(superView).offset(- 10);
        make.bottom.equalTo(superView).offset(- 5);
        //        make.height.equalTo(@20);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.left.equalTo(superView);
        make.bottom.equalTo(superView).offset(- 0.5);
        make.width.equalTo(@3);
    }];
}
//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    if (selected) {
//        self.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#DDDBD4"];
//    }else{
//        self.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#FAF9F2"];
//    }
//}
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle urlString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath
{
    self.title = title;
    self.subTitle = subTitle;
    self.indexPath = indexPath;
    self.urlString = urlString;
}
- (UIColor *)getColorWithIndexPath:(NSIndexPath *)indexPath
{
    static NSInteger COLOR_HEX[] = {0x16A085, 0xF39C12, 0x2980B9, 0xC0392B, 0x8E44AD, 0x2C3E50, 0x7F8C8D};
    return UIColorFromRGB(COLOR_HEX[indexPath.row % (sizeof(COLOR_HEX) / sizeof(NSInteger))]);
    
//    if (_colorArray == nil) {
//        
//        _colorArray = @[[UIColor dp_colorFromHexString:@"#546b05"], [UIColor dp_colorFromHexString:@"#00849c"], [UIColor dp_colorFromHexString:@"#ff3000"], [UIColor dp_colorFromHexString:@"ff8a00"]];
//    }
//    int index = indexPath.row % _colorArray.count;
//    return _colorArray[index];
}

#pragma mark - setter和getter
- (UILabel *)headLabel
{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc]init];
        _headLabel.font = [UIFont dp_systemFontOfSize:kInfoTableViewCellTitleFont];
        _headLabel.numberOfLines = 2;
        _headLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        _headLabel.backgroundColor = [UIColor clearColor];
        //        _headLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _headLabel;
}

- (UILabel *)bottomLabel
{
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.textColor = [UIColor dp_colorFromHexString:@"#998f70"];
        _bottomLabel.font = [UIFont dp_systemFontOfSize:11];
        _bottomLabel.backgroundColor = [UIColor clearColor];
    }
    return _bottomLabel;
}

- (UIView *)leftLine
{
    if (_leftLine == nil) {
        _leftLine = [[UIView alloc]init];
        _leftLine.backgroundColor = [UIColor clearColor];
    }
    return _leftLine;
}

- (NSString *)title
{
    return _title;
}

- (void)setTitle:(NSString *)title
{
    self.headLabel.text = title;
    _title = title;
}

- (NSString *)subTitle
{
    return _subTitle;
}

- (void)setSubTitle:(NSString *)subTitle
{
    if (subTitle != nil && subTitle.length >0) {
        self.bottomLabel.text = subTitle;
    }
    _subTitle = subTitle;
}

- (NSString *)urlString
{
    return _urlString;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}
- (NSIndexPath *)indexPath
{
    return _indexPath;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        _leftLine.backgroundColor = [self getColorWithIndexPath:indexPath];
    }
    
    _indexPath = indexPath;
}
- (void)setShowSel:(BOOL)showSel
{
    if (showSel) {
        self.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#DDDBD4"];
    }else{
        self.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#FAF9F2"];
    }
}
@end

