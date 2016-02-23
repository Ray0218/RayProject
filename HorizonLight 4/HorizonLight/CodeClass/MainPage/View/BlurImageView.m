//
//  BlurImageView.m
//  HorizonLight
//
//  Created by lanou on 15/9/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "BlurImageView.h"

@implementation BlurImageView

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSString *)imageURL{
    self = [super initWithFrame:frame];
    if (self) {
        if (imageURL == nil) {
            self.userInteractionEnabled = YES;
            //  设置图片
            self.image = [UIImage imageNamed:@"147.png"];
        } else
        {
            self.image = [UIImage imageNamed:imageURL];
//            [self sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.image];
        }
        //  创建模糊视图
        UIVisualEffectView *backVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        //  将模糊视图的大小等同于自身
        backVisual.frame = self.frame;
        //  设置模糊视图的透明度
        backVisual.alpha = 0.8;
        [self addSubview:backVisual];
    }
    return  self;
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
