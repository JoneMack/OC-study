//
//  NSStringUtils.m
//  styler
//
//  Created by wangwanggy820 on 14-9-4.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "NSStringUtils.h"

@implementation NSStringUtils

+(BOOL) isBlank:(NSString *) str{
    if (str == nil || [str isEqualToString:@""] || [str isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}


+(BOOL) isNotBlank:(NSString *) str{
    return ![NSStringUtils isBlank:str];
}

@end
