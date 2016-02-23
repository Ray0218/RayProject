//
//  NewsDataBase.h
//  WXMusic
//
//  Created by 漫步人生路 on 15/9/9.
//  Copyright (c) 2015年 漫步人生路. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "VideoListModel.h"
@interface NewsDataBase : NSObject
@property (nonatomic, strong) FMDatabase *dataBase;

+ (NewsDataBase *)shareDataBase;
- (void)insertNewsOfDBTable:(NSString*)DBTable WithModel:(VideoListModel*)model;
- (NSMutableArray*)allNewsOfDBTable:(NSString*)DBTable;
- (void)deleteNewsOfDBTable:(NSString*)DBTable ByNewsTitle:(NSString*)title;
@end
