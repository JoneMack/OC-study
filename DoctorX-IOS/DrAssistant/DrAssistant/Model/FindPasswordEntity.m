//
//  FindPasswordEntity.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "FindPasswordEntity.h"

@interface FindPasswordEntity ()
@property (nonatomic,assign,readwrite) NSInteger timestmp;
@property (nonatomic,strong,readwrite) NSDictionary *dataDic;
@end

@implementation FindPasswordEntity

- (NSDictionary *)dictionaryOfEntity
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:self.account forKey:@"account"];
    [dic safeSetObject:[self.password md532BitUpper] forKey:@"password"];
    
    NSString *token = [self.account md532BitUpper];
    [dic addEntriesFromDictionary: [BaseEntity sign: @[token]]];
    
    return dic;
}

+ (FindPasswordEntity *)entityOfDic:(NSDictionary *)dic
{
    FindPasswordEntity *entity = [[FindPasswordEntity alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    entity.timestmp = [dic intValueForKey:@"timestmp"];
    entity.dataDic = [dic dictionaryForkey:@"data"];
    return entity;
}

@end
