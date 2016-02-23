//
//  UIImage+DPCache.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIImage *(^dp_CustomImageBlock)(UIImage *image);
typedef UIImage *(^dp_MakeImageBlock)(void);

@interface UIImage (DPCache)

//- (UIImage *)dp_imageWithSize:(CGSize)size;
//- (UIImage *)dp_imageWithRect:(CGRect)rect;

+ (UIImage *)dp_retinaImageNamed:(NSString *)named;
+ (UIImage *)dp_resizeImageNamed:(NSString *)named;

/**
 *  对指定路径的图片进行自定义处理, 并得到处理后的图片
 *
 *  @param named [in]图片名
 *  @param block [  ]对图片进行处理
 *  @param tag   [in]标签
 *
 *  @return 返回处理完成后的图片
 */
+ (UIImage *)dp_customImageNamed:(NSString *)named customBlock:(dp_CustomImageBlock)block tag:(NSString *)tag;

/**
 *  缓存图片
 *
 *  @param named [in]名称
 *  @param block [  ]返回图片
 *
 *  @return
 */
+ (UIImage *)dp_globalImageNamed:(NSString *)named makeBlock:(dp_MakeImageBlock)block;

@end
