//
//  PPerfectHandler.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/11.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "PPerfectEntity.h"

@implementation PPerfectEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userEntity = [UserContext new];
    }
    return self;
}

- (NSDictionary *)dictionaryOfEntity
{
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    
    [requestDict addEntriesFromDictionary:_userEntity.context];
    
    [requestDict addEntriesFromDictionary: [PPerfectEntity sign:nil]];
    
    return requestDict;
}

+ (PPerfectEntity *)entityOfDic:(NSDictionary *)dic
{
    PPerfectEntity *entity = [[PPerfectEntity alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    return entity;
}

@end
