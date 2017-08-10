//
//  CloseDate.m
//  styler
//
//  Created by System Administrator on 14-4-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "CloseDate.h"

@implementation CloseDate

-(BOOL)isInCloseDate:(NSDate *)date{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.start/1000];    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.end/1000];
    //NSLog(@"start: %@, end: %@, date:%@", startDate, endDate, date);
    //NSLog(@"%d, %d", [startDate compare:date], [endDate compare:date]);
    
    if ([startDate compare:date] == NSOrderedAscending
        && [endDate compare:date] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

@end
