//
//  ResponeEntity.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/22.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ResponeEntity.h"

@implementation ResponeEntity
+ (ResponeEntity *)entityOfDic:(NSDictionary *)dic
{
    ResponeEntity *entity = [[ResponeEntity alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    entity.timestmp = [dic intValueForKey:@"timestmp"];
    entity.dataDic = [dic dictionaryForkey:@"data"];
    return entity;
}
@end
