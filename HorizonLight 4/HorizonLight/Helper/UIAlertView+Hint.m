//
//  UIAlertView+Hint.m
//  HorizonLight
//
//  Created by lanou on 15/10/6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "UIAlertView+Hint.h"

@implementation UIAlertView (Hint)

- (void)alertHint:(NSString*)hintString delegate:(id)delegate
{
    self = [[UIAlertView alloc] initWithTitle:@"提示" message:hintString delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:delegate selector:@selector(dismissAlert) userInfo:nil repeats:NO];
}

- (void)dismissAlert
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
