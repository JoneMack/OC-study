//
//  RegisterEntityResponse.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "RegisterEntityResponse.h"

@interface RegisterEntityResponse ()

@end

@implementation RegisterEntityResponse

+ (RegisterEntityResponse *)entityOfDic:(NSDictionary *)dic
{
    RegisterEntityResponse *entity = [[RegisterEntityResponse alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    entity.timestmp = [dic intValueForKey:@"timestmp"];
    entity.dataDic = [dic dictionaryForkey:@"data"];
    return entity;
}

@end
