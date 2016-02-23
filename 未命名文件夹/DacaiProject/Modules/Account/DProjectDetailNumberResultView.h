//
//  DProjectDetailNumberResultView.h
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DProjectDetailNumberResultView : UIView
- (instancetype)initWithGameTypeId:(GameTypeId)gameType;
- (void)loadDrawResult:(NSString *)result;
@end
