//
//  DPFileUtilities.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPFileUtilities : NSObject

/**
 *  返回应用程序的根路径
 *
 *  @return NSString
 */
+ (NSString *)rootDocumentPath;

/**
 *  判断指定路径上是否存在文件(不包括目录)
 *
 *  @param path 指定的路径
 *
 *  @return BOOL
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

/**
 *  判断指定路径上是否存在目录(不包括文件)
 *
 *  @param path 指定的路径
 *
 *  @return BOOL
 */
+ (BOOL)directoryExistsAtPath:(NSString *)path;


#pragma mark - Copy From BeeFrame

/**
 *  程序目录，不能存任何东西
 *
 *  @return NSString
 */
+ (NSString *)appPath;

/**
 *  文档目录，需要ITUNES同步备份的数据存这里
 *
 *  @return NSString
 */
+ (NSString *)docPath;

/**
 *  配置目录，配置文件存这里
 *
 *  @return
 */
+ (NSString *)libPrefPath;

/**
 *  缓存目录，系统永远不会删除这里的文件，ITUNES会删除
 *
 *  @return
 */
+ (NSString *)libCachePath;

/**
 *  临时目录，APP退出后，系统可能会删除这里的内容
 *
 *  @return
 */
+ (NSString *)tmpPath;

/**
 *  创建目录
 *
 *  @param path [in]目录路径
 *
 *  @return
 */
+ (BOOL)mkDir:(NSString *)path;

/**
 *  创建文件
 *
 *  @param file [in]文件路径
 *
 *  @return
 */
+ (BOOL)touch:(NSString *)file;

@end
