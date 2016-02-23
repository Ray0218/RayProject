//
//  CustomPresentationController.m
//  PresentationControlerDemo
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "CustomPresentationController.h"

@implementation CustomPresentationController

{ 
    UIView *dimmingView;
}

-(id) initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if(self){
        
        dimmingView = [[UIView alloc] init];
        dimmingView.backgroundColor =  [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        dimmingView.alpha = 0.0;
    }
    return self;
}


- (void)presentationTransitionWillBegin
{ 
    dimmingView.frame = self.containerView.bounds;
    [self.containerView addSubview:dimmingView];
    [self.containerView addSubview:self.presentedView];
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        dimmingView.alpha = 1;
    } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if(!completed){
        [dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        dimmingView.alpha = 0.0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if(completed){
        [dimmingView removeFromSuperview];
    }
}




- (CGRect)frameOfPresentedViewInContainerView
{
    
    CGRect frame = self.containerView.bounds ;
    frame = CGRectInset(frame, 50.0, 50.0);
    return frame;
}


#pragma mark- UIContentContainer protocol methods
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{


    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator] ;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        dimmingView.frame = self.containerView.bounds ;
    } completion:nil];
     
}


@end
