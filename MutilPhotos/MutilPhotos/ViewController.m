//
//  ViewController.m
//  MutilPhotos
//
//  Created by Ray on 15/11/26.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import "ViewController.h"
#import "DPComAddedImgView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "UMImagePickerController.h"

@interface ViewController ()<UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *originImages;

@property (strong, nonatomic) DPComAddedImgView *addedImageView;


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
    [self setUpAddedImageView:nil];

 
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pvtBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor blueColor] ;
    btn.frame = CGRectMake(20, 250, 200, 30) ;
    [self.view addSubview:btn];
    
    
    
    // 初始化UIDatePicker
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, 0, 0)];
    // 设置时区
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    // 设置当前显示时间
    [datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    // 当值发生改变的时候调用的方法
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
     
   }
-(void)datePickerValueChanged:(UIDatePicker*)picker{

}

-(void)pvtBtn{

    if(self.originImages.count >= kMaxCount){
        [[[UIAlertView alloc] initWithTitle:@"Sorry 抱歉" message:@"图片最多只能选kMaxCount张" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    [self setUpPicker];


}


- (void)creatAddImageViewWithImages:(NSArray *)images
{
    __weak typeof(self) weakSelf = self;
    self.addedImageView = [[DPComAddedImgView alloc] initWithUIImages:nil screenWidth:CGRectGetWidth([[UIScreen mainScreen] bounds])];
    self.addedImageView.backgroundColor = [UIColor purpleColor];
    self.addedImageView.frame = CGRectMake(0, 80, CGRectGetWidth([[UIScreen mainScreen] bounds]), (CGRectGetWidth([[UIScreen mainScreen] bounds])-25)/4.0 +10);

    [self.addedImageView setPickerAction:^{
        [weakSelf setUpPicker];
    }];
    self.addedImageView.imagesChangeFinish = ^(){
 
    };
    self.addedImageView.imagesDeleteFinish = ^(NSInteger index){
        [weakSelf.originImages removeObjectAtIndex:index];
     };
    [self.addedImageView addImages:images];
    self.addedImageView.actionWithTapImages = ^(){
    
    };
    [self.view addSubview:self.addedImageView];
}





- (void)setUpPicker
{
    
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问照片的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        return;
    }
    if([UMImagePickerController isAccessible])
    {
        UMImagePickerController *imagePickerController = [[UMImagePickerController alloc] init];
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 9 - [self.addedImageView.arrayImages count];
        
        [imagePickerController setFinishHandle:^(BOOL isCanceled,BOOL isCamera,NSArray *assets){
            if(!isCanceled)
            {
                if (!isCamera) {
                    [self dealWithAssets:   assets];
                }else{
                
                    [self.originImages addObject:[assets lastObject]];
                    [self setUpAddedImageView:assets];


                }
            }
        }];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}
- (void)dealWithAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *array = [NSMutableArray array];
        for(ALAsset *asset in assets)
        {
            UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
            if (image) {
                [array addObject:image];
            }
            if ([asset defaultRepresentation]) {
                //这里把图片压缩成fullScreenImage分辨率上传，可以修改为fullResolutionImage使用原图上传
                UIImage *originImage = [UIImage
                                        imageWithCGImage:[asset.defaultRepresentation fullScreenImage]
                                        scale:[asset.defaultRepresentation scale]
                                        orientation:UIImageOrientationUp];
                if (originImage) {
                    [self.originImages addObject:originImage];
                }
            } else {
                UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
                image = [self compressImage:image];
                if (image) {
                    [self.originImages addObject:image];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpAddedImageView:array];
        });
    });
}
- (UIImage *)compressImage:(UIImage *)image
{
    UIImage *resultImage  = image;
    if (resultImage.CGImage) {
        NSData *tempImageData = UIImageJPEGRepresentation(resultImage,0.9);
        if (tempImageData) {
            resultImage = [UIImage imageWithData:tempImageData];
        }
    }
    return image;
}

- (void)setUpAddedImageView:(NSArray *)images
{
    if(!self.addedImageView)
    {
        [self creatAddImageViewWithImages:images];
    }
    else
    {
        [self.addedImageView setScreemWidth:CGRectGetWidth([[UIScreen mainScreen] bounds])];
        [self.addedImageView addImages:images];
    }
    
          self.addedImageView.contentSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), self.addedImageView.contentSize.height);
    self.addedImageView.hidden = NO ;
 }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
