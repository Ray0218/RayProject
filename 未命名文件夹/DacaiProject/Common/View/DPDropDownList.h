//
//  DPDropDownList.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPDropDownListDelegate;

@interface DPDropDownList : UIView
@property (nonatomic, weak) id<DPDropDownListDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *items;

- (instancetype)initWithItems:(NSArray *)items;

@end

@protocol DPDropDownListDelegate <NSObject>
- (void)dropDownList:(DPDropDownList *)dropDownList selectedAtIndex:(NSInteger)index;
@end