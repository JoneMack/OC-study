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
    if (str == nil || [str isEqualToString:@""] || [str isEqual:[NSNull null]] || [str isKindOfClass:[NSNull class]] ) {
        return YES;
    }
    return NO;
}

+(BOOL) isSpecialBlank:(NSString *)str{
    if (str == nil || [str isEqual:[NSNull null]] || [str isKindOfClass:[NSNull class]] ) {
        return YES;
    }
    return NO;
}

+(BOOL) ispecialNotBlank:(NSString *) str{
    return ![NSStringUtils isSpecialBlank:str];
}

+(BOOL) isNotBlank:(NSString *) str{
    return ![NSStringUtils isBlank:str];
}

@end
