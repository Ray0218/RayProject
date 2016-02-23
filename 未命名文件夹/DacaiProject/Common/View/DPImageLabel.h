//
//  DPImageLabel.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPImagePosition) {
    DPImagePositionBackground,
    DPImagePositionTop,
    DPImagePositionLeft,
    DPImagePositionBottom,
    DPImagePositionRight,
};

@interface DPImageLabel : UIView

@property (nonatomic, strong) UIFont    *font;
@property (nonatomic, strong) NSString  *text;
@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) UIColor   *highlightedTextColor;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, strong) UIImage   *highlightedImage;

@property (nonatomic, assign, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, assign) DPImagePosition imagePosition;
@property (nonatomic, assign) CGFloat spacing;  // space between image and text, default is 0.0f.
@property (nonatomic, assign) CGFloat offset;   // default is 0.0f
@property (nonatomic, strong) NSAttributedString  *attrString;

@end
