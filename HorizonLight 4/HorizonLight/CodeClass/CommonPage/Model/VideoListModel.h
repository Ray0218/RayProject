//
//  VideoListModel.h
//  HorizonLight
//
//  Created by lanou on 15/9/17.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListModel : NSObject

//每日精选
@property (nonatomic, strong) NSString *nextPageUrl;
@property (nonatomic, strong) NSString *nextPublishTime;
//dailyList视频日期列表
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *total;
//videoList视频列表
@property (nonatomic, strong) NSString *category;//视频类型
@property (nonatomic, strong) NSString *coverBlurred;//模糊视图图片
@property (nonatomic, strong) NSString *coverForDetail;//视频清单图片
@property (nonatomic, strong) NSString *coverForFeed;//反馈图片
@property (nonatomic, strong) NSString *coverForSharing;//分享图片
@property (nonatomic, strong) NSString *videoListDescription;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *videoListID;
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *title;
//consumption收藏/分享数量
@property (nonatomic, assign) NSUInteger collectionCount;
@property (nonatomic, assign) NSUInteger shareCount;
//playInfo播放信息
@property (nonatomic, strong) NSString *normalUrl;
@property (nonatomic, strong) NSString *highUrl;
//provider视频提供者
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;

+ (VideoListModel *)shareJsonWithDic1:(NSDictionary *)dic1 dic2:(NSDictionary *)dic2 dic3:(NSDictionary *)dic3 dic4:(NSDictionary *)dic4 arr:(NSArray *)array;
+ (VideoListModel *)shareJsonWithDic2:(NSDictionary *)dic2 dic3:(NSDictionary *)dic3 dic4:(NSDictionary *)dic4 arr:(NSArray *)array;

@end
