//
//  ViewController.m
//  MutilPhotos
//
//  Created by Ray on 15/11/26.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "DPImageSelectVC.h"
#import "UIImage+cetgory.h"

@interface ViewController ()<UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *originImages;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;


@end

@implementation ViewController


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.originImages = [NSMutableArray array];
    
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pvtBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor blueColor] ;
    btn.frame = CGRectMake(20, 250, 200, 30) ;
    [self.view addSubview:btn];
    
}

-(void)pvtBtn{

    
    [self setUpPicker];


}


- (void)setUpPicker {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问照片的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        return;
    }
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] &&
         [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])) {
        __weak typeof(self) weakSelf = self;
        [self loadAssetsGroup:^(NSArray *assetsGroups) {
            
            DPImageSelectVC *imagePickerController = [[DPImageSelectVC alloc] init];
            imagePickerController.assertsGroupArray = assetsGroups;
             
            [imagePickerController setSelectFinishHandle:^(BOOL isCanceled, BOOL isCamera, NSArray *assets) {
                if (!isCanceled) {
                    if (!isCamera) {
                        [weakSelf dealWithAssets:assets];
                    } else {
                        if (assets) {
                            [weakSelf.originImages addObject:[assets lastObject]];
                            //                        [weakSelf setUpAddedImageView:assets];
                         }
                    }
                }
            }];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            
            [weakSelf presentViewController:navigationController animated:YES completion:NULL];
            
        }];
    }
}


#pragma mark - 将ALAsset转换成image
- (void)dealWithAssets:(NSArray *)assets {
}
- (UIImage *)compressImage:(UIImage *)image {
    UIImage *resultImage = image;
    if (resultImage.CGImage) {
        NSData *tempImageData = UIImageJPEGRepresentation(resultImage, 0.05);
        if (tempImageData) {
            resultImage = [UIImage imageWithData:tempImageData];
        }
    }
    return resultImage;
}

#pragma mark- 选中的图片
- (void)setUpAddedImageView:(NSArray *)images
{
    
    NSLog( @" images ===== %@",images) ;
}


#pragma mark - 获取相册数据
- (void)loadAssetsGroup:(void (^)(NSArray *assetsGroups))completion {
    NSArray *groupTypes = @[ @(ALAssetsGroupSavedPhotos),
                             @(ALAssetsGroupPhotoStream),
                             @(ALAssetsGroupAlbum) ];
    
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in groupTypes) {
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                                                  
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              } else {
                                                  numberOfFinishedTypes++;
                                              }
                                              
                                              // Check if the loading finished
                                              if (numberOfFinishedTypes == groupTypes.count) {
                                                  // Sort assets groups
                                                  NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:groupTypes];
                                                  
                                                  // Call completion block
                                                  if (completion) {
                                                      completion(sortedAssetsGroups);
                                                  }
                                              }
                                          }
                                        failureBlock:^(NSError *error) {
                                            NSLog(@"Error: %@", [error localizedDescription]);
                                        }];
    }
}

#pragma mark - 对相册进行排序
- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder {
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = sortedAssetsGroups[i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    
    return [sortedAssetsGroups copy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
