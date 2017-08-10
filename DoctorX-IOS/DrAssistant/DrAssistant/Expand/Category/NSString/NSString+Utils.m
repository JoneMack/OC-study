//
//  NSString+Utils.m
//  ESD
//
//  Created by ap2 on 15/6/30.
//  Copyright (c) 2015年 zac. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utils)

// md5 32位 加密 （小写）
- (NSString *)md532BitLower
{
    if (self == nil || ![self isKindOfClass:[NSString class]])
    {
        return nil;
    }
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    
    // CC_LONG强制转换 modify by hhx 2014.08.13
    CC_MD5( cStr, (CC_LONG)(strlen(cStr)), result );
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15]];
}

- (NSString*)md532BitUpper
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

//是否为纯数字
- (BOOL)isPureNumText
{
    NSString *newStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(newStr.length > 0)
    {
        return NO;
    }
    return YES;
}


//判断是否为整形：
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return[scan scanInteger:&val] && [scan isAtEnd];
}



@end
