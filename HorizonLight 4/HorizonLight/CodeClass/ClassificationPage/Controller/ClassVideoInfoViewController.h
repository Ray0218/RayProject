//
//  ClassVideoInfoViewController.h
//  HorizonLight
//
//  Created by lanou on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"

@interface ClassVideoInfoViewController : UIViewController

//接收数据的可变数组
@property (nonatomic, strong) NSMutableArray* videoArray;
@property (nonatomic, strong) VideoListModel *model;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger section;
@property (nonatomic, strong) NSString *nextPageUrl;

@end
