//
//  MainVideoInfoViewController.h
//  HorizonLight
//
//  Created by BaQi on 15/9/23.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
@interface MainVideoInfoViewController : UIViewController

//接收数据的可变数组
@property (nonatomic, strong) NSMutableArray* videoArray;
@property (nonatomic, strong) VideoListModel *videoListModel;
//接收数据的model
@property (nonatomic, assign) NSUInteger section;
@property (nonatomic, assign) NSUInteger row;

@end
