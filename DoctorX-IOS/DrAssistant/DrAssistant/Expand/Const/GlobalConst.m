//
//  GlobalConst.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "GlobalConst.h"

@implementation GlobalConst

+ (instancetype)shareInstance
{
    static GlobalConst *gConst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        gConst = [[GlobalConst alloc] init];
    });
    
    return gConst;
}

- (void)clearData
{
    [GlobalConst shareInstance].loginStatus = LoginStatus_OffLine;
}

+ (void)save:(id)object withKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([value isKindOfClass:[NSDate class]]) {
        return [(NSDate *)value stringWithFormat:@"yyyy-MM-dd"];
    }
    return value;
}

@end
