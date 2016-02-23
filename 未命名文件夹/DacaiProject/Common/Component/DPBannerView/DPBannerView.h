//
//  DPBannerView.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPBannerViewDelegate;
@interface DPBannerView : UIView

@property (nonatomic, weak) id<DPBannerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) CGFloat duration; // 轮播间隔, 默认为5.0f
@property (nonatomic, assign) NSInteger index;

@end

@protocol DPBannerViewDelegate <NSObject>
@optional
- (void)bannerView:(DPBannerView *)bannerView didSelectedAtIndex:(NSInteger)index;
@end