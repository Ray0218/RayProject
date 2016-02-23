//
//  UIWebView+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIWebView+DPAdditions.h"

@implementation UIWebView (DPAdditions)

- (void)dp_removeTapCSS {
//  *{
//       -webkit-tap-highlight-color: rgba(0,0,0,0);
//       -webkit-user-select: none;                /* disable text select */
//       -webkit-touch-callout: none;              /* disable callout, image save panel (popup) */
//       -webkit-tap-highlight-color: transparent; /* "turn off" link highlight */
//   }
//  a:focus{
//       outline:0; // Firefox (remove border on link click)
//   }
    
    [self stringByEvaluatingJavaScriptFromString:@"var styleNode = document.createElement('style');styleNode.type = 'text/css';var styleText = document.createTextNode('*{-webkit-tap-highlight-color: rgba(0,0,0,0);-webkit-user-select: none;-webkit-touch-callout: none;-webkit-tap-highlight-color: transparent;}');styleNode.appendChild(styleText);document.getElementsByTagName('head')[0].appendChild(styleNode);"];
}

- (void)dp_fitWidth {
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (NSInteger)CGRectGetWidth(self.bounds)]];
}

@end
