//
//  ClubResponseEntity.m
//  DrAssistant
//
//  Created by taller on 15/10/4.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ClubEntityResponse.h"

@implementation ClubEntityResponse

+ (ClubEntityResponse *)entityOfDic:(NSDictionary *)dic
{
    ClubEntityResponse *entity = [[ClubEntityResponse alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    return entity;
}
@end
