//
//  UIImage+cetgory.h
//  MutilPhotos
//
//  Created by Ray on 16/1/27.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (cetgory)
- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size  ;

@end
