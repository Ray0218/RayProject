//
//  KCMainViewController.h
//  MultiThread
//
//  Created by Kenshin Cui on 14-3-22.
//  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCMainViewController : UIViewController

#pragma mark 图片资源存储容器
@property (atomic,strong) NSMutableArray *imageNames;

#pragma mark 当前加载的图片索引（图片链接地址连续）
@property (atomic,assign) int currentIndex;

@end
