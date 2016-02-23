//
//  ClassificationModel.h
//  HorizonLight
//
//  Created by lanou on 15/9/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassificationModel : NSObject
//空的
@property (nonatomic, strong) NSString *alias;
//空的
@property (nonatomic, strong) NSString *bgColor;
//照片
@property (nonatomic, strong) NSString *bgPicture;
//名字
@property (nonatomic, strong) NSString *name;

//声明model, 外界调用
+ (ClassificationModel *)shareJsonWithDictionary:(NSDictionary *)dictionary;

@end
