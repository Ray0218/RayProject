//
//  DPShareView.h
//  DacaiProject
//
//  Created by jacknathan on 14-12-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPThirdCallCenter.h"
@protocol DPShareViewDelegate <NSObject>
@required
- (void)shareViewCancel;
@optional
- (void)shareWithThirdType:(kThirdShareType)type;
@end

@interface DPShareView : UIView
@property (nonatomic, weak) id <DPShareViewDelegate> delegate;
@end
