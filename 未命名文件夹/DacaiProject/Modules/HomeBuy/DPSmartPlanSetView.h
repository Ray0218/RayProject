//
//  DPSmartPlanSetView.h
//  DacaiProject
//
//  Created by jacknathan on 14-9-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPSmartPlanSetView;
@protocol DPSmartPlanSetViewDelegate <NSObject>

- (void)userPreferSetdown:(DPSmartPlanSetView *)setView;

@end

@interface DPSmartPlanSetView : UIScrollView

@property(weak, nonatomic)id <DPSmartPlanSetViewDelegate> myDelegate;

@property(assign, nonatomic, readonly)int issue;
@property(assign, nonatomic, readonly)int times;
@property(assign, nonatomic, readonly)int selectedLine;
@property(assign, nonatomic, readonly)int minGain;
@property(assign, nonatomic, readonly)int minGainScale;
@property(assign, nonatomic, readonly)int period;
@property(assign, nonatomic, readonly)int foreScale;
@property(assign, nonatomic, readonly)int nextScale;
@property(assign, nonatomic)int originIssue;
@property(assign, nonatomic)int originTimes;
@property(strong, nonatomic)NSMutableArray *textFieldsDatas;
@property(assign, nonatomic, getter = isShowWarning)BOOL showWarning;
@end

//typedef void(^sureViewConfirm)(void);
@interface DPSmartCountSureView : UIView

@property (nonatomic, strong)NSString *alertText;  // 里面提示框文本
// 设置结束期和下个开始期号
//- (void)setCurIssue:(NSString *)curIssue NextIssue:(NSString *)nextIssue;
//- (id)initWithSureViewConfirm:(sureViewConfirm)sureViewConfirm;
@end
