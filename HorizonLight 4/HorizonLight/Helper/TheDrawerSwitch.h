//
//  TheDrawerSwitch.h
//  SunnyLife
//
//  Created by 漫步人生路 on 15/9/23.
//  Copyright (c) 2015年 漫步人生路. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface TheDrawerSwitch : NSObject

@property (nonatomic, strong) NSString *message;

+ (TheDrawerSwitch *)shareSwitchDrawer;

- (void)openOrCloseTheDrawer;
@end
