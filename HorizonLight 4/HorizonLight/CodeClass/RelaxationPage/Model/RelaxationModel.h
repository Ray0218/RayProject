//
//  RelaxationModel.h
//  HorizonLight
//
//  Created by lanou on 15/9/26.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface RelaxationModel : NSObject

@property (nonatomic,retain) NSString *thumbURL;



@property (nonatomic,retain) NSString *headline_img_tb;
//时间戳
@property (nonatomic,retain) NSString *since;
@property (nonatomic, assign) NSUInteger date_picked;
//页数
@property (nonatomic,assign) NSInteger ad;
//当前世界
@property (nonatomic,retain) NSString *now;
//用户名称
@property (nonatomic,retain) NSString *source_name;
//标题
@property (nonatomic,retain) NSString *title;
//详情数据
@property (nonatomic,retain) NSString *link_v2;
//放图片的数组
@property (nonatomic,retain) NSArray *images;


+ (RelaxationModel *)shareJsonWithDictionary:(NSDictionary *)dictionary;
@end
