//
//  OrderedTimeRange.m
//  styler
//
//  Created by System Administrator on 13-6-14.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "OrderedTimeRange.h"

@implementation OrderedTimeRange

+(NSArray *) getOrderedTimeRangeFromArray:(NSArray *) orderedTimeRanges date:(NSDate *)date{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    for(int i = 0; i < [orderedTimeRanges count]; i++){
        OrderedTimeRange *range = [orderedTimeRanges objectAtIndex:i];
        NSDateComponents *components1 = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:range.day];
        NSDateComponents *components2 = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        if([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
           && [components1 day] == [components2 day]){
            [result addObject:[range copy]];
        }
    }
    return result;
}

- (void) readFromJSONDictionary:(NSDictionary *)jsonDict{
    long long int startTimeL = [[jsonDict objectForKey:@"day"] longLongValue];
    self.day = [NSDate dateWithTimeIntervalSince1970:(int)(startTimeL/1000) ];
    self.startHour = [[jsonDict objectForKey:@"hour"] intValue];
    self.orderCount = [[jsonDict objectForKey:@"orderCount"] intValue];
}


+(NSArray *) readOrderedTimeRangesFromJsonDictionayArray:(NSArray *)jsonDictArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i = 0; i < [jsonDictArray count]; i++){
        OrderedTimeRange *timeRange = [[OrderedTimeRange alloc] init];
        [timeRange readFromJSONDictionary:[jsonDictArray objectAtIndex:i]];
        [result addObject:timeRange];
    }
    return result;
}

- (OrderedTimeRange *) copyWithZone:(NSZone *)zone{
    OrderedTimeRange *range = [[OrderedTimeRange allocWithZone:zone] init];
    range.day = [self.day copy];
    range.startHour = self.startHour;
    range.orderCount = self.orderCount;
    return range;
}

-(NSString *) description{
    return [NSString stringWithFormat:@"startTime:%@, hour:%d, orderCount:%d", self.day, self.startHour,self.orderCount];
}
@end
