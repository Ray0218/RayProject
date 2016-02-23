//
//  DrawerTableViewController.h
//  HorizonLight
//
//  Created by lanou on 15/9/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawerTVCDelegate <NSObject>

- (void)pushCtrlerWithNumber:(NSUInteger)number;

@end

@interface DrawerTableViewController : UITableViewController

//设置代理属性
@property (nonatomic, strong) id<DrawerTVCDelegate>drawerDelegate;

@end
