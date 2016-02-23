//
//  DPStartupView.h
//  DacaiProject
//
//  Created by WUFAN on 14-10-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPStartupViewDelegate;
@interface DPStartupView : UIView
@property (nonatomic, weak) id<DPStartupViewDelegate> delegate;
@end

@protocol DPStartupViewDelegate <NSObject>
@optional
- (void)viewDidDestory:(DPStartupView *)view;
@end