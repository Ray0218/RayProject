//
//  ClassificationModel.m
//  HorizonLight
//
//  Created by lanou on 15/9/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ClassificationModel.h"

@implementation ClassificationModel
//空实现, 来处理异常
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//实现方法
+ (ClassificationModel *)shareJsonWithDictionary:(NSDictionary *)dictionary
{
    ClassificationModel *classIficationModel = [[ClassificationModel alloc]init];
    [classIficationModel setValuesForKeysWithDictionary:dictionary];
    return classIficationModel;
}
@end
