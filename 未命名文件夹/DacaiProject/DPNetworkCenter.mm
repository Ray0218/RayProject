//
//  DPNetworkCenter.m
//  DacaiProject
//
//  Created by WUFAN on 14-10-31.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

/*
#import <objc/runtime.h>
#import <objc/message.h>
#import "DPNetworkCenter.h"
#import "FrameWork.h"

static const NSString *kCmdId = @"CmdId";
static const NSString *kResult = @"Result";
static const NSString *kCmdType = @"CmdType";
static const NSString *kModule = @"Module";
static const char *NET_OBJECT_TAG = "DP_NET_OBJECT_TAG";

@interface DPNetworkCenter : NSObject

+ (instancetype)defaultCenter;
- (void)bindRequset:(NSInteger)cmdId object:(NSObject *)object;

@end

@interface NSObject ()
@property (nonatomic, strong, readonly) NSString *net_objectTag;
@end

@implementation DPNetworkCenter {
    NSMutableDictionary *_requsetMap;
}

+ (instancetype)defaultCenter {
    static DPNetworkCenter *networkCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkCenter = [[DPNetworkCenter alloc] init];
    });
    return networkCenter;
}

- (instancetype)init {
    if (self = [super init]) {
        _requsetMap = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    return self;
}

- (void)bindRequset:(NSInteger)cmdId object:(NSObject *)object {
//    if (cmdId < 200) {
//        // TODO
//    }
    
    @synchronized(_requsetMap) {
        [_requsetMap setObject:object.net_objectTag forKey:@(cmdId)];
    }
}

- (void)Notify:(NSInteger)cmdId result:(NSInteger)result cmdType:(NSInteger)cmdType module:(NSInteger)module {
//    if (cmdId < 200) {
//        // TODO
//    }
    
    NSString *objectTag = nil;
    @synchronized(_requsetMap) {
        objectTag = [_requsetMap objectForKey:@(cmdId)];
        [_requsetMap removeObjectForKey:@(cmdId)];
    }
    
    DPAssert(objectTag);
    
    if (objectTag) {
        NSDictionary *userInfo = @{ kCmdId : @(cmdId),
                                    kResult : @(result),
                                    kCmdType : @(cmdType),
                                    kModule : @(module) };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:objectTag object:nil userInfo:userInfo];
    }
}

@end

@implementation NSObject (DPNetworkCenter)

- (void)net_bindRequest:(NSInteger)cmdId {
    [[DPNetworkCenter defaultCenter] bindRequset:cmdId object:self];
}

- (void)net_load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(net_notify:) name:self.net_objectTag object:nil];
}

- (void)net_unload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.net_objectTag object:nil];
}

- (void)net_notify:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    NSInteger cmdId = [[userInfo objectForKey:kCmdId] integerValue];
    NSInteger result = [[userInfo objectForKey:kResult] integerValue];
    NSInteger cmdType = [[userInfo objectForKey:kCmdType] integerValue];
    NSInteger module = [[userInfo objectForKey:kModule] integerValue];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    objc_msgSend(self, @selector(Notify:result:cmdType:), cmdId, result, cmdType);
#pragma clang diagnostic pop
    
}

- (NSString *)net_objectTag {
    NSString *guid = objc_getAssociatedObject(self, NET_OBJECT_TAG);
    if (guid == nil) {
        guid = [NSString dp_uuidString];
        objc_setAssociatedObject(self, NET_OBJECT_TAG, guid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return guid;
}

@end
*/
