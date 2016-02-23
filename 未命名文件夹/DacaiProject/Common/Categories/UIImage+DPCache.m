//
//  UIImage+DPCache.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIImage+DPCache.h"

@interface dp_UIImage : NSObject {
@private
    NSCache *_imageCache;
}

+ (instancetype)sharedManager;

- (UIImage *)imageNamed:(NSString *)name customBlock:(dp_CustomImageBlock)block tag:(NSString *)tag;

- (UIImage *)imageForKey:(NSString *)key;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;

@end

@implementation dp_UIImage

+ (instancetype)sharedManager {
    static dp_UIImage *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[dp_UIImage alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (UIImage *)imageNamed:(NSString *)name customBlock:(dp_CustomImageBlock)block tag:(NSString *)tag {
    NSString *key = [NSString stringWithFormat:@"%@ %@", name, tag];
    UIImage *image = [_imageCache objectForKey:key];
    if (image == nil) {
        if (block) {
            image = [UIImage dp_retinaImageNamed:name];
        }
        if (image == nil) {
            image = [UIImage imageWithContentsOfFile:name];
        }
        if (image == nil) {
            return nil;
        }
        if (block) {
            image = block(image);
        }
        [_imageCache setObject:image forKey:key];
    }
    return image;
}

- (UIImage *)imageForKey:(NSString *)key {
    return [_imageCache objectForKey:key];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [_imageCache setObject:image forKey:key];
}

@end

@implementation UIImage (DPCache)

+ (UIImage *)dp_retinaImageNamed:(NSString *)named {
    return [[dp_UIImage sharedManager] imageNamed:named customBlock:nil tag:@"dp_retina"];
}

+ (UIImage *)dp_resizeImageNamed:(NSString *)named {
    return [[dp_UIImage sharedManager] imageNamed:named customBlock:^UIImage *(UIImage *image) {
        CGSize size = image.size;
        CGFloat x = ceilf(size.width * 0.5);
        CGFloat y = ceilf(size.height * 0.5);
        return [image resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y, x)];
    } tag:@"dp_resize"];
}

+ (UIImage *)dp_customImageNamed:(NSString *)named customBlock:(dp_CustomImageBlock)block tag:(NSString *)tag {
    return [[dp_UIImage sharedManager] imageNamed:named customBlock:block tag:tag];
}

+ (UIImage *)dp_globalImageNamed:(NSString *)named makeBlock:(dp_MakeImageBlock)block {
    static NSString *GlobalPrefix = @"GlobalPrefix ";
    NSString *key = [GlobalPrefix stringByAppendingString:named];
    UIImage *image = [[dp_UIImage sharedManager] imageForKey:key];
    if (image == nil) {
        image = block();
        
        if (image) {
            [[dp_UIImage sharedManager] setImage:image forKey:key];
        }
    }
    
    return image;
}

@end
