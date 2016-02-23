//
//  DPTestBottomLayerViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPBannerView;
@interface DPAppRootViewController : UIViewController

// 轮播图片
@property (atomic, assign) NSInteger requestCount;
@property (nonatomic, strong, readonly) DPBannerView *bannerView;

@end
