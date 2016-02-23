//
//  SmallMapView.m
//  littleMapView
//
//  Created by fuqiang on 13-7-2.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "SmallMapView.h"

@implementation SmallMapView

- (id)initWithUIScrollView:(UIScrollView *)scrollView frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        
        //设置缩略图View尺寸
        [self setFrame:frame];
        
        //设置缩略图缩放比例
        [self setScaling:_scrollView];
        
        //设置罗略图内容
        _contentLayer = [self drawContentView:_scrollView frame:frame];
        [self.layer addSublayer:_contentLayer];
        
        //初始化缩略移动视口
        _rectangleLayer = [[CALayer alloc] init];
        _rectangleLayer.opacity = 0.5;
        _rectangleLayer.shadowOffset = CGSizeMake(0, 3);
        _rectangleLayer.shadowRadius = 5.0;
        _rectangleLayer.shadowColor = [UIColor blackColor].CGColor;
        _rectangleLayer.shadowOpacity = 0.8;
        _rectangleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _rectangleLayer.frame = CGRectMake(0, 0, scrollView.frame.size.width * _scaling, scrollView.frame.size.height * _scaling);
        [self.layer addSublayer:_rectangleLayer];
    }
    return self;
}

- (void)dealloc
{
    [_rectangleLayer release];
    [super dealloc];
}

//------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setScaling:scrollView];
    float x = scrollView.contentOffset.x;
    float y = scrollView.contentOffset.y;
    float h = scrollView.frame.size.height;
    float w = scrollView.frame.size.width;
    [self.rectangleLayer setFrame:CGRectMake(x * _scaling, y * _scaling, h * self.scaling, w * self.scaling)];
}

//重绘View内容
- (void)reloadSmallMapView
{
    [_contentLayer removeFromSuperlayer];
    _contentLayer = [self drawContentView:_scrollView frame:self.frame];
    [self.layer insertSublayer:_contentLayer atIndex:0];
}

//设置缩略图缩放比例
- (void)setScaling:(UIScrollView *)scrollView
{
    _scaling = self.frame.size.height / scrollView.contentSize.height;
}

//复制UIScrollView中内容
- (CALayer *)drawContentView:(UIScrollView *)scrollView frame:(CGRect)frame
{
    [self setScaling:scrollView];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    for (UIView *view in scrollView.subviews)
    {
        UIGraphicsBeginImageContext(view.bounds.size);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CALayer *copyLayer = [CALayer layer];
        copyLayer.contents = (id)image.CGImage;
        float x = view.frame.origin.x;
        float y = view.frame.origin.y;
        float h = view.frame.size.height;
        float w = view.frame.size.width;
        copyLayer.frame = CGRectMake(x * _scaling,y *_scaling,w * _scaling,h * _scaling);
        [layer addSublayer:copyLayer];
    }
    return [layer autorelease];
}
@end
