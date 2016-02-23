//
//  RootViewController.m
//  本地视频
//
//  Created by Ray on 15/6/18.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "RootViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


#import <MediaPlayer/MediaPlayer.h>


// 照片原图路径
#define KOriginalPhotoImagePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

// 视频URL路径
#define KVideoUrlPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface RootViewController (){
    
    NSURL *_mediaPath ;
}

@property (nonatomic,strong) NSMutableArray        *groupArrays;
@property (nonatomic,strong) NSMutableArray        *photoArrays;

@property (nonatomic,strong) UIImageView           *litimgView;


@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"测试" ;
    
    
    // 测试BarItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"获取视频路径" style:UIBarButtonItemStylePlain target:self action:@selector(testRun)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"播放" style:UIBarButtonItemStylePlain target:self action:@selector(testMediaPlayer)];
    
    
    self.groupArrays = [NSMutableArray array];
    self.photoArrays = [NSMutableArray array] ;
    // 图片或者视频的缩略图显示
    self.litimgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 250, 120, 120)];
    [self.view addSubview:_litimgView];
    
}
-(void)testMediaPlayer{
    
    
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:_mediaPath];
    //    vc.view.frame = CGRectMake(10, -44, 300, 400) ;
    
    vc.moviePlayer.controlStyle =  MPMovieControlStyleFullscreen ;
    vc.moviePlayer.repeatMode =  MPMovieRepeatModeOne ;
    
    //    [self.view addSubview:vc.view];
    
    vc.moviePlayer.fullscreen = YES ;
    NSLog(@"isFullscreen == %d",vc.moviePlayer.isFullscreen) ;
    
    [self presentMoviePlayerViewControllerAnimated:vc];
    
    NSLog(@"isFullscreen == %d",vc.moviePlayer.isFullscreen) ;
}

- (void)testRun
{
    
    __weak RootViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            //             [group setAssetsFilter:[ALAssetsFilter allVideos]];
            if (group != nil) {
                //添加相册列表
                [weakSelf.groupArrays addObject:group];
            } else {
                [weakSelf.groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if ([result thumbnail] != nil) {
                            // 照片
                            
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                                
                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                
                                [self.photoArrays addObject:image];
                                
                                NSDate *date= [result valueForProperty:ALAssetPropertyDate];
                                NSString *fileName = [[result defaultRepresentation] filename];
                                NSURL *url = [[result defaultRepresentation] url];
                                int64_t fileSize = [[result defaultRepresentation] size];
                                
                                
                                NSLog(@"date = %@",date);
                                NSLog(@"fileName = %@",fileName);
                                NSLog(@"url = %@",url);
                                NSLog(@"fileSize = %lld",fileSize);
                                
                                
                                // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    self.litimgView.image = image;
                                });
                            } 
                            // 视频
                            else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                                // 和图片方法类似
                                NSDate *date= [result valueForProperty:ALAssetPropertyDate];
                                NSString *fileName = [[result defaultRepresentation] filename];
                                NSURL *url = [[result defaultRepresentation] url];
                                
                                _mediaPath = url ;
                                int64_t fileSize = [[result defaultRepresentation] size];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    NSLog(@"播放视频");
                                    //录制完之后自动播放
                                    AVPlayer*   _player=[AVPlayer playerWithURL:url];
                                    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
                                    playerLayer.frame=CGRectMake(10,300, 300 , 300);
                                    [self.view.layer addSublayer:playerLayer];
                                    [_player play];
                                    
                                });
                                
                                
                                
                                
                                
                            }
                        }
                    }];
                }];
                
                NSLog(@"photoArrays === %@",self.photoArrays) ;
                
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                    
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            });
        };
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
    
    
}


// 将原始图片的URL转化为NSData数据,写入沙盒

- (void)imageWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 进这个方法的时候也应该加判断,如果已经转化了的就不要调用这个方法了
    // 如何判断已经转化了,通过是否存在文件路径
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    // 创建存放原始图的文件夹--->OriginalPhotoImages
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:KOriginalPhotoImagePath]) {
        
        [fileManager createDirectoryAtPath:KOriginalPhotoImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (url) {
            
            // 主要方法
            
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                
                Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                
                NSString * imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:fileName];
                
                [data writeToFile:imagePath atomically:YES];
                
            } failureBlock:nil];
            
        }
        
    });
    
}

// 将原始视频的URL转化为NSData数据,写入沙盒

- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (url) {
            
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                
                NSString * videoPath = [KCachesPath stringByAppendingPathComponent:fileName];
                
                char const *cvideoPath = [videoPath UTF8String];
                
                FILE *file = fopen(cvideoPath, "a+");
                
                if (file) {
                    
                    const int bufferSize = 1024 * 1024;
                    
                    // 初始化一个1M的buffer
                    
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    
                    NSUInteger read = 0, offset = 0, written = 0;
                    
                    NSError* err = nil;
                    
                    if (rep.size != 0)
                    {
                        
                        do {
                            
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            
                            written = fwrite(buffer, sizeof(char), read, file);
                            
                            offset += read;
                            
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    
                    free(buffer);
                    buffer = NULL;
                    
                    fclose(file);
                    
                    file = NULL;
                }
                
            } failureBlock:nil];
        }
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
