//
//  AFImageDiskCache.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "AFImageDiskCache.h"

static NSString *kAFImageDiskCacheDir = @"Image";

static inline NSString * AFImageDiskCachePathFromURLRequest(NSURLRequest *request) {
//    // 文件名不能包含任何以下字符：
//    // \ / : * ? " < > |
//    NSString *absoluteString = [[request URL] absoluteString];
//    NSArray *components = [absoluteString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/:*?\"<>|\\"]];
//    return [components componentsJoinedByString:@"_"];
    
    NSString *absoluteString = [[request URL] absoluteString];
    NSData *md5Data = [DPCryptUtilities MD5:[absoluteString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *md5String = [DPCryptUtilities hexUpperString:md5Data];
    md5String = [kAFImageDiskCacheDir stringByAppendingPathComponent:md5String];
    return [[DPFileUtilities libCachePath] stringByAppendingPathComponent:md5String];
}

@implementation AFImageDiskCache

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIImageView setSharedImageCache:[[AFImageDiskCache alloc] init]];
    });
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
        image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:UIImageOrientationUp];
    }
    
    return image;
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        NSString *dirPath = [[DPFileUtilities libCachePath] stringByAppendingPathComponent:kAFImageDiskCacheDir];
        NSString *imagePath = AFImageDiskCachePathFromURLRequest(request);
        NSData *data = UIImagePNGRepresentation(image);
        [DPFileUtilities mkDir:dirPath];
        [data writeToFile:imagePath options:NSDataWritingWithoutOverwriting error:nil];
    }
}

@end
