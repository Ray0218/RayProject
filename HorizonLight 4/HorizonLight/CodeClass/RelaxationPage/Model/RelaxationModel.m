//
//  RelaxationModel.m
//  HorizonLight
//
//  Created by lanou on 15/9/26.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "RelaxationModel.h"

@implementation RelaxationModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{


}
//-(void)setValue:(id)value forKey:(NSString *)key
//{
//    [super setValue:value forKey:key];
//    if ([key isEqualToString:@"width"])
//    {
//        self.width = [value floatValue];
//    }
//    if ([key isEqualToString:@"height"])
//    {
//        self.height = [value floatValue];
//    }
//
//}
+ (RelaxationModel *)shareJsonWithDictionary:(NSDictionary *)dictionary
{
    RelaxationModel *relaxationModel = [[RelaxationModel alloc] init];
    [relaxationModel setValuesForKeysWithDictionary:dictionary];
    return relaxationModel;

}

@end
