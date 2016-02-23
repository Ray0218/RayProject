//
//  DPImageModel.h
//  JCZJ
//
//  Created by sunny_ios on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface ALAsset (selectType)

@property (nonatomic, assign) BOOL isSelected;

+ (void)getorignalImage:(ALAsset *)assert completion:(void (^)(UIImage *))returnImage;

@end