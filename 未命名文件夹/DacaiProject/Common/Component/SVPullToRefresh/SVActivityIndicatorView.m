//
//  SVActivityIndicatorView.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "SVActivityIndicatorView.h"

@interface SVActivityIndicatorView () {
@private
    CGFloat _rgbStrokeColor[4];
}

@end

@implementation SVActivityIndicatorView

- (id)initWithActivityIndicatorStyle:(SVActivityIndicatorViewStyle)style {
    if (self = [super initWithFrame:CGRectMake(0, 0, 20, 20)]) {
        self.backgroundColor = [UIColor clearColor];
        switch (style) {
            case SVActivityIndicatorViewStyleRed:
                self.color = [UIColor colorWithRed:0.91 green:0.14 blue:0.15 alpha:1];
                break;
            case SVActivityIndicatorViewStyleWhite:
                self.color = [UIColor whiteColor];
                break;
            case SVActivityIndicatorViewStyleGray:
                self.color = [UIColor grayColor];
                break;
            default:
                break;
        }
        _duration = 1;
        _animating = NO;
        _activityIndicatorViewStyle = style;
        _hidesWhenStopped = YES;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    
    CGFloat const *components = CGColorGetComponents(color.CGColor);
    
    _rgbStrokeColor[0] = components[0];
    _rgbStrokeColor[1] = components[1];
    _rgbStrokeColor[2] = components[2];
    _rgbStrokeColor[3] = components[3];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, _rgbStrokeColor[0], _rgbStrokeColor[1], _rgbStrokeColor[2], _rgbStrokeColor[3]);
    
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    
    CGContextAddArc(context, centerX, centerY, 9, 0, 5.5, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)startAnimating {
    if (!_animating || ![self.layer animationForKey:@"rotate-layer"]) {
        _animating = YES;
        
        [self setHidden:NO];
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        rotationAnimation.duration = _duration;
        rotationAnimation.repeatCount = HUGE_VALF;
        [self.layer addAnimation:rotationAnimation forKey:@"rotate-layer"];
    }
}

- (void)stopAnimating {
    if (_animating) {
        _animating = NO;
        
        [self setHidden:self.hidesWhenStopped];
        [self.layer removeAnimationForKey:@"rotate-layer"];
    }
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    
    if (_animating) {
        [self setHidden:NO];
    } else {
        [self setHidden:self.hidesWhenStopped];
    }
}

- (BOOL)isAnimating {
    return _animating;
}

@end
