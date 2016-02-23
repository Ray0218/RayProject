//
//  DPLotteryInfoDockView.h
//  资讯详情页面
//
//  Created by jacknathan on 14-9-11.
//  Copyright (c) 2014年 jacknathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPLotteryInfoDockViewDelegate <NSObject>

@optional
- (void)dockItemChangedtoTag:(int)tag;

@end

@interface DPLotteryInfoDockView : UIView

@property(weak, nonatomic)id <DPLotteryInfoDockViewDelegate> delegate;

- (void)selectedItemChangeTo:(int)tag isDelegateSend:(BOOL)isDelegate;

@end
