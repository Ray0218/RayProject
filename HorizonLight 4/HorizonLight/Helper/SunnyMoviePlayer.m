//
//  SunnyMoviePlayer.m
//  HorizonLight
//
//  Created by lanou on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "SunnyMoviePlayer.h"

@implementation SunnyMoviePlayer

{
    float videoProgress;
    NSTimer *timer;
    UIProgressView *progressView;
    float timep;

}
#pragma mark ----播放视频----
//根据视频的url来播放
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


//开始播放
- (void)starPlayVideo
{
    if (self.readyToPlay == YES)
    {
        [self.moviePlayer play];
        self.isPlaying = YES;
    }

}

//停止播放
-(void)stopPlayVideo
{
    [self.moviePlayer pause];
    self.isPlaying = NO;
    [timer invalidate];
    timer = nil;

}

//指定位置播放
-(void)seekToTime:(CGFloat)time
{
    if (self.isPlaying == YES)
    {
        //切换视频的时候视频可以从头开始播放
        [self stopPlayVideo];
    }

}

//暂停定时器
-(void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

//下一曲
-(void)nextVideo
{
    
}
//数据请求
- (void)reloadSong
{
    self.moviePlayer = [[SunnyMoviePlayer alloc] initWithContentURL:[NSURL URLWithString:self.mediaUrl]];
    [self.moviePlayer.view setFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    //适合的缩放比例
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    //取消自带的播放按钮
    self.moviePlayer.controlStyle = NO;
    [self.view addSubview:[self.moviePlayer view]];
    [self.moviePlayer play];
}
//缓冲进度
//-(NSTimeInterval)cushionDuration
//{
//    
//    NSArray *loadedTimeRanges = [[self.video currentPlaybackTime] loadedTimeRanges];
//    //获取缓冲区域
//    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
//    float startSeconds = CMTimeGetSeconds(timeRange.start);
//    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
//    //计算缓冲总进度
//    NSTimeInterval result = startSeconds + durationSeconds;
//    return result;
//}
- (void)sliderRum
{
    

}
@end
