//
//  DateUtils.h
//  styler
//
//  Created by aypc on 13-10-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

-(id)initWithDate:(NSDate *)date;

@property int year;
@property int month;
@property int week;
@property int day;
@property (nonatomic, strong) NSDate * date;
-(BOOL)isEqualToDateUtils:(DateUtils *)DU;

+(int)weekDayFromDate:(NSDate *)date;

+(NSString *)getDateByDate:(NSDate *)date;
+(NSString *)getFutureDateByDate:(NSDate *)date;
+(NSDate *)getDateByString:(NSString *)dateStr;
+(int)daysOfMonthWithDate:(NSDate *)date;
+(NSString *)weekDayStringWithWeek:(int)week;
+(NSString *)getDateStringByDateString:(NSString *)dateStr;
+(NSString *)stringFromDate:(NSDate *)date;
+(NSString *)stringFromLongLongInt:(long long int)date;
+(NSString *)stringFromNumber:(NSNumber *)date;
+(NSString *)dateStringFromLongLongInt:(long long int)date;
+(NSString *)stringFromDateAndFormat:(NSDate *)date dateFormat:(NSString *)dateFormat;
+(NSString *)stringFromLongLongIntAndFormat:(long long int)date dateFormat:(NSString *)dateFormat;
+(NSString *)stringFromNumberAndFormat:(NSNumber *)date dateFormat:(NSString *)dateFormat;

+(NSDate *)dateFromLongLongInt:(long long int)date;
+(long long int)longlongintFromDate:(NSDate *)date;

+(int) compare:(NSDate *)date1 date2:(NSDate *)date2;
@end
