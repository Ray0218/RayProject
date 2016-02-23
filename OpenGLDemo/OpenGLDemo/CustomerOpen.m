//
//  CustomerOpen.m
//  OpenGLDemo
//
//  Created by Ray on 15/4/1.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "CustomerOpen.h"

@implementation CustomerOpen{

    EAGLContext *_context ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createOPen];
    }
    return self;
}

-(void)createOPen{
    
    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
    _context = context ;
    
    [EAGLContext setCurrentContext:context];
    

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
