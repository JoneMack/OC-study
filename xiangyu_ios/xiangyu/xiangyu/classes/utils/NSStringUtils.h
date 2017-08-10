//
//  NSStringUtils.h
//  styler
//
//  Created by wangwanggy820 on 14-9-4.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtils : NSObject

+(BOOL) isBlank:(NSString *) str;
+(BOOL) isNotBlank:(NSString *) str;
+(BOOL) isSpecialBlank:(NSString *)str;
+(BOOL) ispecialNotBlank:(NSString *) str;
+ (NSString *)stringFromInt:(int)num;
+ (BOOL) isEmpty:(NSString *) str;


//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;


//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;



+(NSString *) string2JsonString:(NSMutableDictionary *) dict;


@end
