//
//  PlayerDataBase.m
//  WXMusic
//
//  Created by 漫步人生路 on 15/9/9.
//  Copyright (c) 2015年 漫步人生路. All rights reserved.
//

#import "NewsDataBase.h"

@implementation NewsDataBase

static NewsDataBase *newsDataBase;

+ (NewsDataBase *)shareDataBase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        newsDataBase = [[NewsDataBase alloc]init];
    });
    return newsDataBase;
}

//指定数据库路径
- (NSString *)sqlitePaths:(NSString *)sqlitePaths
{
    NSString *str = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:sqlitePaths];
    NSLog(@"%@",str);
    return str;
}

//打开数据库
- (void)openSqliteWithPaths:(NSString *)paths
{
    if (_dataBase == nil) {
        self.dataBase = [FMDatabase databaseWithPath:[self sqlitePaths:paths]];
    }
    // 创建1张表
    if ([_dataBase open]) {
        [self createNewsTableWithName:@"myCollectionDB"];
    }
}

//关闭数据
- (void)closeSqlite
{
    [self.dataBase close];
}

//创建数据库表
- (void)createNewsTableWithName:(NSString *)name
{
    BOOL executeUpdate = NO;
    NSString* sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@(title TEXT PRIMARY KEY, link INTEGER UNIQUE, time TEXT, commits TEXT)", name];
    
    executeUpdate = [_dataBase executeUpdate:sqlStr];
    
    if (executeUpdate) {
        NSLog(@"建%@表成功", name);
    }else
    {
        NSLog(@"建%@表失败", name);
    }
}

- (void)insertNewsOfDBTable:(NSString*)DBTable WithModel:(VideoListModel *)model
{
    if (!model) {
        NSLog(@"model为空");
        return;
    }
    
    if (!_dataBase) {
        [self openSqliteWithPaths:@"News.sqlite"];
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@(title, idx, coverForDetail) values(?,?,?)", DBTable];
    BOOL insertModel = [_dataBase executeUpdate:sql,model.title,model.idx,model.coverForDetail];
    
    if (insertModel) {
        NSLog(@"插入成功");
    }else {
        NSLog(@"插入失败");
    }
}

- (NSMutableArray*)allNewsOfDBTable:(NSString*)DBTable
{
    NSMutableArray *modelMArray = [[NSMutableArray alloc]init];
    if (!_dataBase) {
        [self openSqliteWithPaths:@"News.sqlite"];
    }

    NSString* sql = [NSString stringWithFormat:@"select * from %@", DBTable];
    FMResultSet *rs = [_dataBase executeQuery:sql];
    while ([rs next]) {
        VideoListModel *model = [[VideoListModel alloc]init];
        model.title = [rs stringForColumn:@"title"];
        model.videoListID = [rs stringForColumn:@"idx"];
        model.coverForDetail = [rs stringForColumn:@"coverForDetail"];
        [modelMArray addObject:model];
    }
    return modelMArray;
}

- (void)deleteNewsOfDBTable:(NSString*)DBTable ByNewsTitle:(NSString*)title
{
    if (!_dataBase) {
        [self openSqliteWithPaths:@"News.sqlite"];
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where title = ?", DBTable];
    BOOL b = [_dataBase executeUpdate:sql,title];
    if (b) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

@end
