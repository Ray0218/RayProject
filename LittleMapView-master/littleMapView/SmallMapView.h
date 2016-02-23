//
//  SmallMapView.h
//  littleMapView
//
//  Created by fuqiang on 13-7-2.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SmallMapView : UIView

//缩放比例
@property (nonatomic,assign,readonly)float scaling;

//标示窗口位置的浮动矩形
@property (nonatomic,retain,readonly)CALayer *rectangleLayer;

//内容
@property (nonatomic,retain,readonly)CALayer *contentLayer;

//被模拟的UIScrollView
@property (nonatomic,retain,readonly)UIScrollView *scrollView;

//init
- (id)initWithUIScrollView:(UIScrollView *)scrollView frame:(CGRect)frame;

//在UIScrollView的scrollViewDidScroll委托方法中调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

//重绘View内容(需要注意。如果在调用reloadSmallMapView 方法的时候，需要更新的内容内有动画。如按钮变色等)
//请用[self performSelector:@selector(reloadSmallMapView:) withObject:nil afterDelay:0.2];
- (void)reloadSmallMapView;
@end
