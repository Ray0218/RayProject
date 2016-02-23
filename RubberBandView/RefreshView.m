//
//  RefreshView.m
//  CBHazeTransitionViewController
//
//  Created by coolbeet on 4/5/14.
//  Copyright (c) 2014 suyu zhang. All rights reserved.
//

#import "RefreshView.h"
#import <math.h>

#define kRadius 15.f
#define kSkipedHeight 60.f

@interface RefreshView ()
{
    CGFloat _offsetY;
    RefreshViewDirection moveDirection;
}

@property (nonatomic, assign) UIScrollView *scrollView;

@end

@implementation RefreshView
@synthesize offsetY = _offsetY ;


static inline CGFloat lerp(CGFloat a, CGFloat b, CGFloat p)
{
    return a + (b - a) * p;
}

- (id)initWithFrame:(CGRect)frame inScrollView:(UIScrollView *)scrollView withDirection:(RefreshViewDirection)direction;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = scrollView;
        moveDirection = direction;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    

    _offsetY = [[change objectForKey:@"new"] CGPointValue].y;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
   
        [[UIColor purpleColor] setFill];
        
        [path moveToPoint:CGPointMake(0, 40)]; ;
        [path addQuadCurveToPoint:CGPointMake(320, 40) controlPoint:CGPointMake(160, -_offsetY+40)]; ;
        
        
//        [path closePath];
        [path fill];

}

@end
