//
//  VideoListModel.m
//  HorizonLight
//
//  Created by lanou on 15/9/17.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //命名规范原因重设description和id赋值方式
    if ([key isEqualToString:@"description"])
    {
        self.videoListDescription = value;
    }
    if ([key isEqualToString:@"id"])
    {
        self.videoListID = value;
    }
}

+ (VideoListModel *)shareJsonWithDic1:(NSDictionary *)dic1 dic2:(NSDictionary *)dic2 dic3:(NSDictionary *)dic3 dic4:(NSDictionary *)dic4 arr:(NSArray *)array
{
    VideoListModel *model = [[VideoListModel alloc] init];
    [model setValuesForKeysWithDictionary:dic1];
    [model setValuesForKeysWithDictionary:dic2];
    [model setValuesForKeysWithDictionary:dic3];
    [model setValuesForKeysWithDictionary:dic4];
    //视频网址 高清/普通
    if (array.count == 2)
    {
        model.normalUrl = array[0][@"url"];
        model.highUrl = array[1][@"url"];
    }
    else
    {
        model.normalUrl = array[0][@"url"];
    }
    return model;
}

+ (VideoListModel *)shareJsonWithDic2:(NSDictionary *)dic2 dic3:(NSDictionary *)dic3 dic4:(NSDictionary *)dic4 arr:(NSArray *)array
{
    VideoListModel *model = [[VideoListModel alloc] init];
    [model setValuesForKeysWithDictionary:dic2];
    [model setValuesForKeysWithDictionary:dic3];
    [model setValuesForKeysWithDictionary:dic4];
    //视频网址 高清/普通
    if (array.count == 2)
    {
        model.normalUrl = array[0][@"url"];
        model.highUrl = array[1][@"url"];
    }
    else
    {
        model.normalUrl = array[0][@"url"];
    }
    return model;
}

@end
