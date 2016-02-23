//
//  DPImageModel.m
//  JCZJ
//
//  Created by sunny_ios on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DPImageModel.h"
#import <objc/runtime.h>

static const char *select_key = "select_key";

@implementation ALAsset (selectType)

- (BOOL)isSelected {
    return [objc_getAssociatedObject(self, select_key) boolValue];
}

- (void)setIsSelected:(BOOL)isSelected {
    objc_setAssociatedObject(self, select_key, [NSNumber numberWithBool:isSelected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)getorignalImage:(ALAsset *)assert completion:(void (^)(UIImage *))returnImage {
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:assert.defaultRepresentation.url resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        CGImageRef imageRef = rep.fullResolutionImage;
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
        if (image) {
            returnImage(image);
        }
    }
        failureBlock:^(NSError *error){

        }];
}

@end
