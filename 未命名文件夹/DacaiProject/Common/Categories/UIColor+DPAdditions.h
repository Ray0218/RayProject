//
//  UIColor+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0x00FF0000) >> 16)) / 255.0     \
                                                 green:((float)((rgbValue & 0x0000FF00) >>  8)) / 255.0     \
                                                  blue:((float)((rgbValue & 0x000000FF) >>  0)) / 255.0     \
                                                 alpha:1.0]

@interface UIColor (DPAdditions)

+ (UIColor *)dp_colorWithUInt8Red:(UInt8)red green:(UInt8)green blue:(UInt8)blue alpha:(UInt8)alpha;
+ (UIColor *)dp_colorFromRGB:(NSUInteger)rgb;
+ (UIColor *)dp_colorFromRGBA:(NSUInteger)rgba;
+ (UIColor *)dp_colorFromHexString:(NSString *)hexString;
+ (UIColor *)dp_oppositeColorOf:(UIColor *)mainColor;

@property (nonatomic, assign, readonly) CGFloat dp_red;
@property (nonatomic, assign, readonly) CGFloat dp_green;
@property (nonatomic, assign, readonly) CGFloat dp_blue;
@property (nonatomic, assign, readonly) CGFloat dp_alpha;

+ (UIColor *)dp_coverColor;
// flat color
+ (UIColor *)dp_flatWhiteColor;
+ (UIColor *)dp_flatBackgroundColor;
+ (UIColor *)dp_flatBlackColor;
+ (UIColor *)dp_flatRedColor;
+ (UIColor *)dp_flatDarkRedColor;
+ (UIColor *)dp_flatBlueColor;
+ (UIColor *)dp_flatMediumElectricBlueColor;
+ (UIColor *)dp_flatGreenColor;

@end
