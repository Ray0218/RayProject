//
//  UIImage+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DPAdditions)

+ (UIImage *)dp_imageWithColor:(UIColor *)color;
- (UIImage *)dp_imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)dp_imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *)dp_croppedImage:(CGRect)bounds;
- (UIImage *)dp_resizedImageToSize:(CGSize)dstSize;
- (UIImage *)dp_resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

- (CGSize)dp_rize;
- (CGFloat)dp_width;
- (CGFloat)dp_height;

@end
