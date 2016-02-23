//
//  RubberBandView.h
//  RubberBandView
//
//  Created by JianYe on 14-7-1.
//  Copyright (c) 2014年 XiaoZi. All rights reserved.
//

#import <UIKit/UIKit.h>

struct  _RubberBandProperty{
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    CGFloat maxOffSet;
};

typedef struct _RubberBandProperty RubberBandProperty;

static inline RubberBandProperty
MakeRBProperty(CGFloat x,CGFloat y, CGFloat width,CGFloat height,CGFloat maxOffSet) {
    RubberBandProperty property;
    property.x = x;
    property.y = y;
    property.width = width;
    property.height = height;
    property.maxOffSet = maxOffSet;//最大偏移量
    return property;
}

static inline RubberBandProperty
CopyRBProperty(RubberBandProperty property) {
    return MakeRBProperty(property.x,property.y,property.width,property.height,property.maxOffSet);
}

typedef void(^RBAnimationAction)(void);

@interface RubberBandView : UIView
@property (nonatomic,strong)UIColor *fillColor;
@property (nonatomic,readonly)CAShapeLayer *drawLayer;
@property (nonatomic,assign)CFTimeInterval duration;
@property (nonatomic,assign)RubberBandProperty property;
@property (nonatomic,copy)RBAnimationAction startAction;
@property (nonatomic,copy)RBAnimationAction stopAction;
- (id)initWithFrame:(CGRect)frame layerProperty:(RubberBandProperty)property;
- (void)pullWithOffSet:(CGFloat)offSet;
- (void)recoverStateAnimation;
- (void)resetDefault;
@end
