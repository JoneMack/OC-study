//
//  AddCaseEntity.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AddCaseEntity.h"

@implementation AddCaseEntity

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
    
    [requestDict addEntriesFromDictionary: [AddCaseEntity sign:nil]];
    
    return requestDict;
}

+ (AddCaseEntity *)entityOfDic:(NSDictionary *)dic
{
    AddCaseEntity *entity = [[AddCaseEntity alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    return entity;
}


@end
