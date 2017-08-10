//
//  RedEnvelope.m
//  styler
//
//  Created by System Administrator on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "RedEnvelope.h"

@implementation RedEnvelope

-(NSString *) getStatusTxt{
    switch (self.status) {
        case red_envelope_status_bind:
        case red_envelope_status_locked:
            return @"未使用";
        case red_envelope_status_used:
            return @"已使用";
        case red_envelope_status_expired:
            return @"已过期";
        default:
            break;
    }
    return @"";
}

-(NSString *) getTimeNoteTxt{

    NSString *timeTxt;
    NSDate *date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年M月d日";
    switch (self.status) {
        case red_envelope_status_bind:
        case red_envelope_status_locked:
            date = [[NSDate alloc]initWithTimeIntervalSince1970:[[self useConstraint] expiredTime].longLongValue/1000.0];
            timeTxt = [dateFormatter stringFromDate:date];
            return [NSString stringWithFormat:@"%@前可以使用", timeTxt];
        case red_envelope_status_used:
            date = [[NSDate alloc]initWithTimeIntervalSince1970:self.useTime.longLongValue/1000.0];
            timeTxt = [dateFormatter stringFromDate:date];
            return [NSString stringWithFormat:@"%@已经使用", timeTxt];
        case red_envelope_status_expired:
            date = [[NSDate alloc]initWithTimeIntervalSince1970:self.expiredTime.longLongValue/1000.0];
            timeTxt = [dateFormatter stringFromDate:date];
            return [NSString stringWithFormat:@"%@过期" , timeTxt];
        default:
            break;
    }
    
    return @"";
}

@end
