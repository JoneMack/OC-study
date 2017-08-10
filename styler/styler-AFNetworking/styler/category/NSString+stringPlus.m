//
//  NSString+stringPlsu.m
//  styler
//
//  Created by aypc on 13-10-8.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "NSString+stringPlus.h"

@implementation NSString (stringPlus)
-(BOOL)isContainString:(NSString *)str
{
    for (int i = 0; i < (self.length - str.length); i++) {
        if ([[self substringWithRange:NSMakeRange(i, str.length)] isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

-(NSString *) urlEncode{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                         (CFStringRef)self, nil,
                                                                                (CFStringRef)@"!*'();&+$#[]/", kCFStringEncodingUTF8));
}
@end
