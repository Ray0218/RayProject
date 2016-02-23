//
//  TouchImageView.h
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchImageView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action;

@end
