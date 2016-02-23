//
//  DPCalendarView.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPCalendarViewDelegate;
@interface DPCalendarView : UIView
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, weak) id<DPCalendarViewDelegate> delegate;
@property (nonatomic, assign, readonly) CGSize contentSize;
/**
 *  重置日历, 显示当前选中的月份
 */
- (void)resetCalendar;
/**
 *  显示上一个月
 */
- (void)appearLastMonth;
/**
 *  显示下一个月
 */
- (void)appearNextMonth;

@end

@protocol DPCalendarViewDelegate <NSObject>
@optional
- (BOOL)calendarView:(DPCalendarView *)calendarView shouldSelectedDate:(NSDate *)date;
- (void)calendarView:(DPCalendarView *)calendarView didSelectedDate:(NSDate *)date;
@end