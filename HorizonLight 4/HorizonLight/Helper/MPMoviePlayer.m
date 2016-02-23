//
//  MPMoviePlayer.m
//  HorizonLight
//
//  Created by lanou on 15/9/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "MPMoviePlayer.h"

@implementation MPMoviePlayer

#pragma mark ----播放视频----

-(void)playVideo:(NSString *)filePath
{
 
    //获取视频播放的URL
    NSURL *videoUrl = [NSURL fileURLWithPath:filePath];
    NSLog(@"%@",videoUrl);
    //增加url创建视频变量
    self.video = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
    self.controlStyle = MPMovieControlStyleFullscreen;
    //设置视频frame
    self.video.view.frame = self.view.frame;
    [self.view addSubview:self.video.view];
    //注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.video];
    //注册一个正在播放的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (isPlayingMovie:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:self.video];
    //开启播放视频
    [self.video play];
    
}

-(void)myMovieFinishedCallback:(NSNotification *)notify
{
    //视频播放
    MPMoviePlayerController *playVideo = [notify object];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:playVideo];
    [playVideo.view removeFromSuperview];
    

}
-(void)isPlayingMovie:(NSNotification *)notify
{
    MPMoviePlayerController *playVideo = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:playVideo];
    

}
@end
