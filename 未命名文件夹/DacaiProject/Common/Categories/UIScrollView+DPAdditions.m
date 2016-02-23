//
//  UIScrollView+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIScrollView+DPAdditions.h"

@implementation UIScrollView (DPAdditions)

- (void)dp_scrollToTop {
    [self dp_scrollToTopAnimated:NO];
}

- (void)dp_scrollToTopAnimated:(BOOL)animated {
    [self setContentOffset:CGPointZero animated:animated];
}

@end
