//
//  AFImageDiskCache.h
//  HorizonLight
//
//  Created by Ray on 15/10/9.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImageView+AFNetworking.h"

NSString *AFImageDiskCachePathFromURL(NSString *absoluteString);

@interface AFImageDiskCache : NSObject <AFImageCache>

+ (instancetype)sharedCache;

/**
 Returns a cached image for the specififed request, if available.
 
 @param url The image url.
 
 @return The cached image.
 */
- (UIImage *)cachedImageForURL:(NSString *)url;

/**
 Caches a particular image for the specified request.
 
 @param image The image to cache.
 @param url The url to be used as a cache key.
 */
- (void)cacheImage:(UIImage *)image forURL:(NSString *)url;

@end