//
//  HomeModel.h
//  HorizonLight
//
//  Created by BaQi on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

//图片
@property (nonatomic, strong) NSString *feature_img;
//标题
@property (nonatomic, strong) NSString *title;
//类型
@property (nonatomic, strong) NSString *node_name;
//用于拼接的ID
@property (nonatomic, strong) NSString *feed_id;


+ (HomeModel *)shareJsonWithDictionary:(NSDictionary *)dictionary;
@end
