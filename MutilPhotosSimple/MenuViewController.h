//
//  MenuViewController.h
//  MutilPhotos
//
//  Created by Ray on 15/12/18.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MenuViewController : UIViewController


@property (nonatomic, copy, readwrite) NSArray<ALAssetsGroup*> *assetsGroups;

@end
