//
//  DPToast.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern UIColor *DPToastColorRed;
extern UIColor *DPToastColorGreen;
extern UIColor *DPToastColorBlue;
extern UIColor *DPToastColorGray;
extern UIColor *DPToastColorYellow;

typedef NS_ENUM(NSInteger, DPToastStyle) {
    DPToastStyleDefault,
    DPToastStyleCorrect,
    DPToastStyleError,
    DPToastStyleWarning,
};

@interface DPToast : UIView

+ (instancetype)sharedToast;
+ (instancetype)makeText:(NSString *)text;
+ (instancetype)makeText:(NSString *)text color:(UIColor *)color;
+ (instancetype)makeText:(NSString *)text color:(UIColor *)color style:(DPToastStyle)stype;

- (void)dismiss;
- (void)show;

@end
