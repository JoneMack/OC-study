//
//  NSDate+Format.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

@end
