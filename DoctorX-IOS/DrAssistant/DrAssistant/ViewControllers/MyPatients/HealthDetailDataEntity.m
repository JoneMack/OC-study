//
//  HealthDetailDataEntity.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/28.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "HealthDetailDataEntity.h"

@implementation HealthDetailDataEntity
+ (HealthDetailDataEntity *)entityOfDic:(NSDictionary *)dic
{
    HealthDetailDataEntity *entity = [[HealthDetailDataEntity alloc] init];
    entity.USER_ID = [dic stringValueForKey:@"USER_ID"];
   
    return entity;
}
@end
