//
//  IMPHeader.h
//  HorizonLight
//
//  Created by lanou on 15/9/17.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#ifndef HorizonLight_IMPHeader_h
#define HorizonLight_IMPHeader_h
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height
#define kScreenSize         [[UIScreen mainScreen] bounds].size
#define kBounds             [UIScreen mainScreen].bounds

#define kBlurImageView [[BlurImageView alloc] initWithFrame:kBounds]

#define kMonths @[@"Jan.", @"Feb.", @"Mar.", @"Apr.", @"May", @"Jun.", @"Jul.", @"Aug.", @"Sep.", @"Oct.", @"Nov.", @"Dec."]
#define kVersions @"1.0.0"
#define kMaker @"良辰"
#define kIconWidth 30
#define kIconHeight 30
#define kEdge 15

#endif
