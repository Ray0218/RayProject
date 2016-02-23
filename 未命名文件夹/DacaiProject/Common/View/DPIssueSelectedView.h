//
//  DPIssueSelectedView.h
//  DacaiProject
//
//  Created by sxf on 14/12/12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DPIssueSelectedDelegate;
@interface DPIssueSelectedView : UIView

{
    UIImageView *_backgroundView;

}
@property (nonatomic, weak) id<DPIssueSelectedDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong, readonly) UIImageView *backgroundView;
@property(nonatomic,assign)NSInteger selectIndex;
- (instancetype)initWithItems:(NSArray *)items selectIndex:(NSInteger)index;

@end

@protocol DPIssueSelectedDelegate <NSObject>
- (void)dropDownList:(DPIssueSelectedView *)dropDownList selectedAtIndex:(NSInteger)index;
@end