//
//  UIWebView+DPAdditions.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (DPAdditions)

/**
 *  remove tap/click highlight/border with CSS
 */
- (void)dp_removeTapCSS;

/**
 *  fit width
 */
- (void)dp_fitWidth;

@end
