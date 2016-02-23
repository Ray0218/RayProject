//
//  CustomPresentationAnimationController.m
//  PresentationControlerDemo
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "CustomPresentationAnimationController.h"

@interface CustomPresentationAnimationController (){

    BOOL isPresenting ;
    
    NSTimeInterval duration  ;
}

@end

@implementation CustomPresentationAnimationController

- (instancetype)initWithPrestiong:(BOOL)presint
{
    self = [super init];
    if (self) {
        isPresenting = presint ;
        duration = 0.5 ;
    }
    return self;
}

#pragma mark -UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
{


    return  duration ;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{


    if (isPresenting) {
        [self animatePresentationWithTransitionContext:transitionContext];
     
    }else
        [self animateDismissalWithTransitionContext:transitionContext];

}

-(void)animatePresentationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView* presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView* containerView = [transitionContext containerView];
    
    // Position the presented view off the top of the container view
    presentedController.view.frame = [transitionContext finalFrameForViewController:presentedController] ;
    
    CGPoint point =
    presentedController.view.center;
    point.y -= containerView.bounds.size.height ;
    presentedController.view.center = point ;
    
    
    [containerView addSubview:presentedControllerView];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGPoint point = presentedController.view.center ;
        point.y += containerView.bounds.size.height ;
        presentedController.view.center = point ;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }] ;
    
    // Animate the presented view to it's final position
    
}

-(void)animateDismissalWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView * presentedControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView * containerView = [transitionContext containerView];
    
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGPoint point = presentedControllerView.center ;
        point.y += containerView.bounds.size.height ;
        presentedControllerView.center = point ;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }] ;
    

    
    
}



@end
