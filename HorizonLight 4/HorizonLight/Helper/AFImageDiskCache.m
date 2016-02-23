//
//  AFImageDiskCache.m
//  HorizonLight
//
//  Created by Ray on 15/10/9.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "AFImageDiskCache.h"

static NSString *kAFImageDiskCacheDir = @"Image";

NSString *AFImageDiskCachePathFromURL(NSString *absoluteString) {
  
    
    
    NSString *md5String = [KTMCrypto MD5String:[absoluteString dataUsingEncoding:NSUTF8StringEncoding]];
    
    md5String = [kAFImageDiskCacheDir stringByAppendingPathComponent:md5String];
    return [[KTMFileHelper libCachePath] stringByAppendingPathComponent:md5String];
}

static inline NSString * AFImageDiskCachePathFromURLRequest(NSURLRequest *request) {
    return AFImageDiskCachePathFromURL(request.URL.absoluteString);
}

@implementation AFImageDiskCache

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIImageView setSharedImageCache:[self sharedCache]];
    });
}

+ (instancetype)sharedCache {
    static dispatch_once_t onceToken;
    static AFImageDiskCache *cache;
    dispatch_once(&onceToken, ^{
        cache = [[AFImageDiskCache alloc] init];
    });
    return cache;
}

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:AFImageDiskCachePathFromURLRequest(request)];
    if (image) {
        image = [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    }
    
    return image;
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        NSString *dirPath = [[KTMFileHelper libCachePath] stringByAppendingPathComponent:kAFImageDiskCacheDir];
        NSString *imagePath = AFImageDiskCachePathFromURLRequest(request);
        NSData *data = UIImagePNGRepresentation(image);
        [KTMFileHelper mkDir:dirPath];
        [data writeToFile:imagePath options:NSDataWritingWithoutOverwriting error:nil];
    }
}

- (UIImage *)cachedImageForURL:(NSString *)url {
    UIImage *image = [UIImage imageWithContentsOfFile:AFImageDiskCachePathFromURL(url)];
    if (image) {
        image = [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    }
    
    return image;
}

- (void)cacheImage:(UIImage *)image forURL:(NSString *)url {
    if (image && url) {
        NSString *dirPath = [[KTMFileHelper libCachePath] stringByAppendingPathComponent:kAFImageDiskCacheDir];
        NSString *imagePath = AFImageDiskCachePathFromURL(url);
        NSData *data = UIImagePNGRepresentation(image);
        [KTMFileHelper mkDir:dirPath];
        [data writeToFile:imagePath options:NSDataWritingWithoutOverwriting error:nil];
    }
}

@end
