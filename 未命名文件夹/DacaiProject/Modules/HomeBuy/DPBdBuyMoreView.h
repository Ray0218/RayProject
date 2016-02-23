//
//  DPBdBuyMoreView.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-6.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPBdBuyMoreViewDelegate;
@interface DPBdBuyMoreView : UIView

@property (nonatomic, weak) id<DPBdBuyMoreViewDelegate> delegate;
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong, readonly) UIView *coverView;
@property (nonatomic, strong, readonly) UIView *contentView;

- (void)buildLayout;

@end

@protocol DPBdBuyMoreViewDelegate <NSObject>
@required
- (void)cancelBuyMoreView:(DPBdBuyMoreView *)view;
- (void)confirmBuyMoreView:(DPBdBuyMoreView *)view;
@end