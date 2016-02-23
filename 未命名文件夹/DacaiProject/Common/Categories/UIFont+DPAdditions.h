//
//  UIFont+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern BOOL dp_isSystemFontLoaded;
extern BOOL dp_isBoldSystemFontLoaded;
extern BOOL dp_isLightSystemFontLoaded;

extern NSString *dp_systemFontName;
extern NSString *dp_boldSystemFontName;
extern NSString *dp_lightSystemFontName;

@interface UIFont (DPAdditions)

+ (BOOL)dp_registerFontWithURL:(NSString *)fontURL;
+ (BOOL)dp_registerFontWithPath:(NSString *)fontPath;

+ (UIFont *)dp_systemFontOfSize:(CGFloat)size;
+ (UIFont *)dp_boldSystemFontOfSize:(CGFloat)size;
+ (UIFont *)dp_lightSystemFontOfSize:(CGFloat)size;

+ (UIFont *)dp_regularArialOfSize:(CGFloat)size;
+ (UIFont *)dp_boldArialOfSize:(CGFloat)size;
+ (UIFont *)dp_lightArialOfSize:(CGFloat)size;

@end
