//
//  DPNoNetworkView.h
//  DacaiProject
//
//  Created by jacknathan on 14-12-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DPNoNetViewClickBlock)(void);

@interface DPNoNetworkView : UIView
@property (nonatomic, copy) DPNoNetViewClickBlock tapBlock;
- (instancetype)initWithTapBlock:(DPNoNetViewClickBlock)tapBlock;
@end
