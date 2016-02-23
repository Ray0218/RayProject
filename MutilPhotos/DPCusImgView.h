//
//  DPCusImgView.h
//  MutilPhotos
//
//  Created by Ray on 15/12/3.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPCusImgView ;

typedef void (^DeleteHandle)(DPCusImgView *deleView);

@interface DPCusImgView : UIImageView

@property (nonatomic) NSUInteger curIndex;
@property (nonatomic,copy) DeleteHandle deleteHandle;

- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad;

- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad imageWidth:(CGFloat)imageWidth;

@end

