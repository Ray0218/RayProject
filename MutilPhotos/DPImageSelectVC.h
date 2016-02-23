//
//  DPImageSelectVC.h
//  MutilPhotos
//
//  Created by Ray on 15/12/3.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


/**
 *  完成图片选择
 *
 *  @param assets 选中的ALAsset数组
 */
typedef void (^CollectionFinishHandle)(NSArray *assets);
/**
 *  使用相机拍摄完成
 *
 *  @param image 拍摄的图片
 */
typedef void (^CameraFinishHandle)(UIImage *image);

/**
 *  图片选择页面
 */
@interface DPImageSelectVC : UIViewController

@property (nonatomic,strong) ALAssetsGroup *assetsGroup;

/**
 *  图片选择完成
 */
@property(nonatomic,copy)CollectionFinishHandle finishHandle ;
/**
 *  相机拍摄完成
 */
@property(nonatomic,copy)CameraFinishHandle cameraFinish ;

@end
