//
//  DPNotifyCapturer.h
//  DacaiProject
//
//  Created by WUFAN on 14-10-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPNotifyCapturer : NSObject

+ (DPNotifyCapturer *)defaultCapturer;

@property (nonatomic, weak) id delegate;

- (void)startNetListener;
- (void)checkServerDate;




//


@end
