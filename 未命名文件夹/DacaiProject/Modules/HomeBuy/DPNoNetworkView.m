//
//  DPNoNetworkView.m
//  DacaiProject
//
//  Created by jacknathan on 14-12-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPNoNetworkView.h"
@interface DPNoNetworkView ()
//{
//    DPNoNetViewClickBlock _tapBlock;
//}
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@end
@implementation DPNoNetworkView
- (instancetype)initWithTapBlock:(DPNoNetViewClickBlock)tapBlock
{
    if (self = [super init]) {
//        _tapBlock = tapBlock;
        self.tapBlock = tapBlock;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dp_commonUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dp_commonUI];
    }
    return self;
}
- (void)dp_commonUI
{
    NSString *string = @"当前网络不可用, 马上设置";
    self.backgroundColor = [UIColor dp_colorFromHexString:@"#fffde6"];
    self.layer.cornerRadius = 5;
    _imageView = [[UIImageView alloc]initWithImage:dp_CommonImage(@"noNetShow_.png")];
    _titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = string;
        label.font = [UIFont dp_systemFontOfSize:15];
        label.textColor = [UIColor dp_colorFromHexString:@"#35352B"];
        label;
    });
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = NSMakeRange(string.length - 2, 2);
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor dp_colorFromHexString:@"#2f57ab"] range:range];
    [attrStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    if (IOS_VERSION_7_OR_ABOVE) {
        [attrStr addAttribute:NSUnderlineColorAttributeName value:[UIColor dp_colorFromHexString:@"#2f57ab"] range:range];
    }
    self.titleLabel.attributedText = attrStr;
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_singleTap)];
    [self addGestureRecognizer:tap];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = CGRectMake(0, 0, 230, 30);
    self.bounds = bounds;
    self.imageView.center = CGPointMake(10 + self.imageView.bounds.size.width * 0.5, CGRectGetHeight(bounds) * 0.5);
//    self.titleLabel.frame = CGRectMake(70, 10, 220, 30);
    self.titleLabel.bounds = CGRectMake(0, 0, 180, 30);
    self.titleLabel.center = CGPointMake(self.bounds.size.width / 2+15, self.bounds.size.height / 2);
}
- (void)pvt_singleTap
{
    DPLog(@"new work view tap");
//    _tapBlock();
    if (self.tapBlock) {
        self.tapBlock();
    }
}
@end
