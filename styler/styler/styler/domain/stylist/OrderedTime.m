//
//  OrderedTime.m
//  styler
//
//  Created by System Administrator on 14-8-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderedTime.h"

@implementation OrderedTime

//判断当前时间是否可以预约
//-(BOOL) canOrder:(NSDate *)day hour:(float)hour serviceIntention:(NSString *)serviceIntention{
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:theDay];
//    
//    NSDate *dayDate = [NSDate dateWithTimeIntervalSince1970:self.day/1000];
//    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
//    
//    comps2 = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dayDate];
//    if ([comps year] == [comps2 year]
//        && [comps month] == [comps2 month]
//        && [comps day] == [comps2 day]
//        && hour == self.hour) {
//        return YES;
//    }
//    
//    return NO;
//}

/**
 判断当前时间是否可以预约，遍历已经预约的时间，
 将已经预约的时间‘区间化’，比较当前时间是否在此区间，
 如果在则不能预约
**/
+(BOOL) canOrder:(NSDate *)day
            hour:(float)hour
serviceIntention:(NSString *)serviceIntention
    orderedTimes:(NSArray *)orderedTimes{
    
    if (orderedTimes == nil || orderedTimes.count == 0) {
        return YES;
    }
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    BOOL result = YES;
    for (OrderedTime *orderedTime in orderedTimes) {
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:orderedTime.scheduleTime/1000];
        NSDateComponents *comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:startTime];
        NSDateComponents *comps2 = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:day];

        if ([comps year] == [comps2 year] && [comps month] == [comps2 month] && [comps day] == [comps2 day]) {
            //计算区间化的起始时间
            int startHour = [comps hour];
            int startMinute = [comps minute];
            
            if (startMinute < 30) {
                startMinute = 0;
            }else{
                startMinute = 30;
            }
            float startHourF = startHour+(startMinute==30?0.5:0);
        
            float endHour = startHourF + 0.5;
            if ([orderedTime.serviceIntention isEqualToString:@"剪发"]) {
                endHour = startHourF + 1.0;
            }
            NSLog(@">>>>>> check hour:%.1f, %@:%.1f-%.1f", hour, orderedTime.serviceIntention, startHourF, endHour);
            float delta = [serviceIntention isEqualToString:@"剪发"]?1.0:0.5;
            if ((hour >= startHourF && (hour+delta) <= endHour)
                || (hour < startHourF && (hour + delta) > startHourF  && (hour +delta) < endHour)
                || (hour > startHourF && hour < endHour &&  (hour+delta) > endHour)) {
                NSLog(@">>>>>> check hour:%.1f, NO", hour);
                return NO;
            }
        }
        
        
    }
    
    return result;
}

@end
