//
//  ChatListUserEntity.m
//  DrAssistant
//
//  Created by xubojoy on 15/9/29.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ChatListUserEntity.h"

@implementation ChatListUserEntity
- (NSDictionary *)dictionaryOfEntity
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:self.account forKey:@"account"];
    NSString *token = [self.account md532BitUpper];
    [dic addEntriesFromDictionary: [BaseEntity sign: @[token]]];
    
    return dic;
}

+ (ChatListUserEntity *)entityOfDic:(NSDictionary *)dic
{
    ChatListUserEntity *entity = [[ChatListUserEntity alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    entity.timestmp = [dic intValueForKey:@"timestmp"];
    entity.dataDic = [dic dictionaryForkey:@"data"];
    return entity;
}


@end
