//
//  CustomerScrollerView.m
//  Example
//
//  Created by Ray on 15/3/5.
//  Copyright (c) 2015年 Jonathan Tribouharet. All rights reserved.
//

#import "CustomerScrollerView.h"

@implementation CustomerScrollerView


+(Class)layerClass{
    
    return  [CAScrollLayer class];
}
-(void)setUp{

    //enable clipping
    self.layer.masksToBounds = NO ;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];

    [self addGestureRecognizer:recognizer];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib{
    [self setUp];
}
-(void)pan:(UIPanGestureRecognizer*)recognizer{

    CGPoint offset  = self.bounds.origin ;
    offset.x -= [recognizer translationInView:self].x ;
    offset.y -=[recognizer translationInView:self].y ;
    
    //scroll the layer
    
    [(CAScrollLayer*)self.layer scrollPoint:offset];
    
    [recognizer setTranslation:CGPointZero inView:self];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
