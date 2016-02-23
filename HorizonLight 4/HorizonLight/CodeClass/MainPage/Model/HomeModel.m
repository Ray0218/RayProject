//
//  HomeModel.m
//  HorizonLight
//
//  Created by BaQi on 15/9/25.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (HomeModel *)shareJsonWithDictionary:(NSDictionary *)dictionary
{
    HomeModel *homeModel = [[HomeModel alloc]init];
    [homeModel setValuesForKeysWithDictionary:dictionary];
    return homeModel;
}
@end
