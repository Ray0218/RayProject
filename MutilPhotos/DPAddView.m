//
//  DPAddView.m
//  MutilPhotos
//
//  Created by Ray on 15/12/3.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import "DPAddView.h"

@implementation DPAddView

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //rect
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 0.7);
    CGContextSetLineWidth(context, 1.2);
    CGContextAddRect(context, CGRectMake(0.6, 0.6, CGRectGetWidth(self.bounds)-1.2, CGRectGetHeight(self.bounds)-1.2));
    
    
    //+
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 0.7);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextMoveToPoint(context, center.x- self.bounds.size.width/4,center.y);
    CGContextAddLineToPoint(context, center.x + self.bounds.size.width/4,center.y);
    
    CGContextMoveToPoint(context, center.x,center.y - self.bounds.size.height/4);
    CGContextAddLineToPoint(context, center.x,center.y + self.bounds.size.height/4);
    
    
    //draw
    CGContextStrokePath(context);
}


@end
