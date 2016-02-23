//
//  DPKeyboardCenter.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPKeyboardCenter.h"

@interface DPKeyboardListener : NSObject
@property (nonatomic, weak) id<DPKeyboardCenterDelegate> object;
@property (nonatomic, assign) NSInteger typeBit;
@end

@implementation DPKeyboardListener

@end

@interface DPKeyboardCenter () {
@private
    BOOL _keyboardAppear;
    CGRect _keyboardFrame;
    NSMutableArray *_listeners;
}

@end

@implementation DPKeyboardCenter
@synthesize keyboardAppear = _keyboardAppear;
@synthesize keyboardFrame = _keyboardFrame;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self defaultCenter];
    });
}

+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken;
    static DPKeyboardCenter *defaultCenter;
    dispatch_once(&onceToken, ^{
        defaultCenter = [[DPKeyboardCenter alloc] init];
    });
    return defaultCenter;
}

- (instancetype)init {
    if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
        
        _listeners = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)addListener:(id<DPKeyboardCenterDelegate>)obj type:(NSInteger)typeBit {
    @synchronized(_listeners) {
        if (obj == nil) {
            return;
        }
        
        for (DPKeyboardListener *listener in _listeners) {
            DPAssert(listener.object != nil);
            if (listener.object == obj) {
                return;
            }
        }
        
        DPKeyboardListener *listener = [[DPKeyboardListener alloc] init];
        listener.object = obj;
        listener.typeBit = typeBit;
        [_listeners addObject:listener];
    }
}

- (void)removeListener:(id)obj {
    @synchronized(_listeners) {
        DPKeyboardListener *removedObj = nil;
        for (DPKeyboardListener *listener in _listeners) {
            DPAssert(listener.object != nil);
            if (listener.object == obj) {
                removedObj = listener;
                break;
            }
        }
        if (removedObj) {
            [_listeners removeObject:removedObj];
        }
    }
}

- (void)sendEvent:(DPKeyboardListenerEvent)event info:(NSDictionary *)info {
    @synchronized(_listeners) {
        [_listeners enumerateObjectsUsingBlock:^(DPKeyboardListener *obj, NSUInteger idx, BOOL *stop) {
            if (obj.object && (obj.typeBit & event)) {
                if ([obj.object respondsToSelector:@selector(keyboardEvent:info:)]) {
                    [obj.object keyboardEvent:event info:info];
                }
                if ([obj.object respondsToSelector:@selector(keyboardEvent:curve:duration:frameBegin:frameEnd:)]) {
                    UIViewAnimationOptions curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
                    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
                    CGRect frameBegin = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
                    CGRect frameEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                    
                    [obj.object keyboardEvent:event curve:curve duration:duration frameBegin:frameBegin frameEnd:frameEnd];
                }
            }
        }];
    }
    
    _keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}



#pragma mark - notify
- (void)didShowKeyboard:(NSNotification *)notification {
    _keyboardAppear = YES;
    
    [self sendEvent:DPKeyboardListenerEventDidShow info:notification.userInfo];
}

- (void)didHideKeyboard:(NSNotification *)notification {
    _keyboardAppear = NO;
    
    [self sendEvent:DPKeyboardListenerEventDidHide info:notification.userInfo];
}

- (void)willShowKeyboard:(NSNotification *)notification {
    _keyboardAppear = YES;
    
    [self sendEvent:DPKeyboardListenerEventWillShow info:notification.userInfo];
}

- (void)willHideKeyboard:(NSNotification *)notification {
    _keyboardAppear = NO;
    
    [self sendEvent:DPKeyboardListenerEventWillHide info:notification.userInfo];
}

@end
