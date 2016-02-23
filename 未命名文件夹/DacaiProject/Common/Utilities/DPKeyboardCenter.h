//
//  DPKeyboardCenter.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DPKeyboardListenerEvent) {
    DPKeyboardListenerEventDidShow   = 0x1,
    DPKeyboardListenerEventDidHide   = 0x2,
    DPKeyboardListenerEventWillShow  = 0x4,
    DPKeyboardListenerEventWillHide  = 0x8,
};

@protocol DPKeyboardCenterDelegate;
@interface DPKeyboardCenter : NSObject

@property (nonatomic, assign, readonly, getter = isKeyboardAppear) BOOL keyboardAppear;
@property (nonatomic, assign, readonly) CGRect keyboardFrame;

+ (instancetype)defaultCenter;
- (void)addListener:(id<DPKeyboardCenterDelegate>)listener type:(NSInteger)typeBit;
- (void)removeListener:(id)listener;

@end

@protocol DPKeyboardCenterDelegate <NSObject>
@optional
- (void)keyboardEvent:(DPKeyboardListenerEvent)event info:(NSDictionary *)info;
- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd;
@end