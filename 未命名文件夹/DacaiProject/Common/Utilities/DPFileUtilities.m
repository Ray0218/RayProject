//
//  DPFileUtilities.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPFileUtilities.h"

@interface DPFileUtilities () {
@private
    NSString *_rootDocumentPath;
    NSString *_appPath;
    NSString *_docPath;
    NSString *_libPath;
    NSString *_libPrefPath;
    NSString *_libCachePath;
    NSString *_tmpPath;
}

@property (nonatomic, strong, readonly) NSString *rootDocumentPath;

@property (nonatomic, strong, readonly) NSString *appPath;
@property (nonatomic, strong, readonly) NSString *docPath;
@property (nonatomic, strong, readonly) NSString *libPath;
@property (nonatomic, strong, readonly) NSString *libPrefPath;
@property (nonatomic, strong, readonly) NSString *libCachePath;
@property (nonatomic, strong, readonly) NSString *tmpPath;

+ (instancetype)sharedInstance;

- (BOOL)fileExistsAtPath:(NSString *)path;
- (BOOL)directoryExistsAtPath:(NSString *)path;
- (BOOL)mkDir:(NSString *)path;
- (BOOL)touch:(NSString *)file;

@end

@implementation DPFileUtilities

+ (instancetype)sharedInstance {
    static DPFileUtilities *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - by BeeFrame

- (NSString *)appPath {
	if (_appPath == nil) {
		NSError * error = nil;
		NSArray * paths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:NSHomeDirectory() error:&error];
        
		for (NSString * path in paths) {
			if ([path hasSuffix:@".app"]) {
				_appPath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), path];
				break;
			}
		}
	}
    
	return _appPath;
}

- (NSString *)docPath {
	if (_docPath == nil) {
        _docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
	}
	return _docPath;
}

- (NSString *)libPath {
    if (_libPath == nil) {
		_libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    }
    return _libPath;
}

- (NSString *)libPrefPath {
	if (_libPrefPath == nil) {
		_libPrefPath = [self.libPath stringByAppendingPathComponent:@"Preferences"];
		[self mkDir:_libPrefPath];
	}
	return _libPrefPath;
}

- (NSString *)libCachePath {
	if (_libCachePath == nil) {
		_libCachePath = [self.libPath stringByAppendingPathComponent:@"Caches"];
		[self mkDir:_libCachePath];
	}
	return _libCachePath;
}

- (NSString *)tmpPath {
	if (_tmpPath == nil) {
		_tmpPath = [self.libPath stringByAppendingPathComponent:@"tmp"];
		[self mkDir:_tmpPath];
	}
	return _tmpPath;
}

- (BOOL)touch:(NSString *)file {
	if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
		return [[NSFileManager defaultManager] createFileAtPath:file
													   contents:[NSData data]
													 attributes:nil];
	}
    
	return YES;
}

- (BOOL)mkDir:(NSString *)path {
	if (![[NSFileManager defaultManager] fileExistsAtPath:path] ) {
		return [[NSFileManager defaultManager] createDirectoryAtPath:path
										 withIntermediateDirectories:YES
														  attributes:nil
															   error:NULL];
	}
    
	return YES;
}

#pragma mark - other
- (NSString *)rootDocumentPath {
    if (_rootDocumentPath == nil) {
        _rootDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return _rootDocumentPath;
}

- (BOOL)fileExistsAtPath:(NSString *)path {
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        return (!isDir);
    }
    return NO;
}

- (BOOL)directoryExistsAtPath:(NSString *)path {
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        return isDir;
    }
    return NO;
}

#pragma mark - public interface

+ (NSString *)appPath {
    return [[self sharedInstance] appPath];
}

+ (NSString *)docPath {
    return [[self sharedInstance] docPath];
}

+ (NSString *)libPrefPath {
    return [[self sharedInstance] libPrefPath];
}

+ (NSString *)libCachePath {
    return [[self sharedInstance] libCachePath];
}

+ (NSString *)tmpPath {
    return [[self sharedInstance] tmpPath];
}

+ (BOOL)mkDir:(NSString *)path {
    return [[self sharedInstance] mkDir:path];
}

+ (BOOL)touch:(NSString *)file {
    return [[self sharedInstance] touch:file];
}

+ (NSString *)rootDocumentPath {
    return [[self sharedInstance] rootDocumentPath];
}

+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[self sharedInstance] fileExistsAtPath:path];
}

+ (BOOL)directoryExistsAtPath:(NSString *)path {
    return [[self sharedInstance] directoryExistsAtPath:path];
}

@end
