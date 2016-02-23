//
//  CustomPresentationAnimationController.h
//  PresentationControlerDemo
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  <UIKit/UIViewControllerTransitioning.h>


@interface CustomPresentationAnimationController : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)initWithPrestiong:(BOOL)presint ;

@end
