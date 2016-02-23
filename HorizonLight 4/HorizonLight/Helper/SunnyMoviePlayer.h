//
//  SunnyMoviePlayer.h
//  HorizonLight
//
//  Created by lanou on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@class SunnyMoviePlayer;
@protocol SunnyPlayerDelegate <NSObject>

- (void)audioManagerStreamer:(SunnyMoviePlayer *)streamer VideoProress:(CGFloat)videoProress;

@end

@interface SunnyMoviePlayer : MPMoviePlayerController

@property (nonatomic, strong) SunnyMoviePlayer* moviePlayer;
//数据请求网址
@property (nonatomic, strong) NSString *mediaUrl;
@property (nonatomic, strong) MPMoviePlayerController *video;
@property (nonatomic, strong) id<SunnyPlayerDelegate>delegate;

//缓冲成功
@property (nonatomic) BOOL readyToPlay;
//正在播放
@property (nonatomic) BOOL isPlaying;

//开始播放
- (void)starPlayVideo;

//停止播放
-(void)stopPlayVideo;

//指定位置播放
-(void)seekToTime:(CGFloat)time;


//暂停定时器
-(void)stopTimer;
//下一曲
-(void)nextVideo;

//数据请求
- (void)reloadSong;
//缓冲进度
-(NSTimeInterval)cushionDuration;
@end
