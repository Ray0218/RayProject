//
//  TheDrawerSwitch.m
//  SunnyLife
//
//  Created by 漫步人生路 on 15/9/23.
//  Copyright (c) 2015年 漫步人生路. All rights reserved.
//

#import "TheDrawerSwitch.h"

@implementation TheDrawerSwitch
static TheDrawerSwitch *switchDrawer;
+ (TheDrawerSwitch *)shareSwitchDrawer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        switchDrawer = [[TheDrawerSwitch alloc]init];
    });
    return switchDrawer;
}

- (void)openOrCloseTheDrawer
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [SVProgressHUD dismiss];

    if (tempAppDelegate.sunnyLeftVC.closed)
    {
        [tempAppDelegate.sunnyLeftVC openLeftView];
    }
    else
    {
        [tempAppDelegate.sunnyLeftVC closeLeftView];
    }
}
@end
