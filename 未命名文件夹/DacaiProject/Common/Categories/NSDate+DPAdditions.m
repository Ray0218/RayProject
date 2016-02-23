//
//  NSDate+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSDate+DPAdditions.h"

// EEEE - weekday
const NSString *dp_DateFormatter_YYYY_MM_dd_HH_mm_ss = @"yyyy-MM-dd HH:mm:ss";
const NSString *dp_DateFormatter_YYYY_MM_dd_HH_mm = @"yyyy-MM-dd HH:mm";
const NSString *dp_DateFormatter_YYYY_MM_dd = @"yyyy-MM-dd";
const NSString *dp_DateFormatter_MM_dd_HH_mm = @"MM-dd HH:mm";
const NSString *dp_DateFormatter_MM_dd = @"MM-dd";
const NSString *dp_DateFormatter_HH_mm = @"HH:mm";

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@implementation NSDate (DPAdditions)

+ (NSDate *)dp_dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSString *)dp_coverDateString:(NSString *)string fromFormat:(NSString *)srcFormat toFormat:(NSString *)destFormat {
    return [[NSDate dp_dateFromString:string withFormat:srcFormat] dp_stringWithFormat:destFormat];
}

- (NSString *)dp_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSInteger)dp_nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate * newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents * components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger)dp_hour
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger)dp_minute
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger)dp_seconds
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger)dp_day
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger)dp_month
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger)dp_week
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSInteger)dp_weekday
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSString *)dp_weekdayName {
    static NSString *names[] = {@"", @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"};
    return names[self.dp_weekday];
}
- (NSString *)dp_weekdayNameSimple {
    static NSString *names[] = {@"", @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"};
    return names[self.dp_weekday];
}

- (NSInteger)dp_nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger)dp_year
{
	NSDateComponents * components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}

@end
