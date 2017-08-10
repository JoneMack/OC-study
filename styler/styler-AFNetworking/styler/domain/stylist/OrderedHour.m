//
//  OrderedHour.m
//  styler
//
//  Created by System Administrator on 14-4-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderedHour.h"

@implementation OrderedHour

-(BOOL) compareDayAndHour:(NSDate *)theDay hour:(int)hour{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:theDay];
    
    NSDate *dayDate = [NSDate dateWithTimeIntervalSince1970:self.day/1000];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    
    //NSLog(@">>>> day:%@ hour:%d", dayDate, self.hour);
    //NSLog(@">>>> the day:%@ the hour:%d", theDay, hour);
    comps2 = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dayDate];
    if ([comps year] == [comps2 year]
        && [comps month] == [comps2 month]
        && [comps day] == [comps2 day]
        && hour == self.hour) {
        return YES;
    }
    
    return NO;
}



@end
