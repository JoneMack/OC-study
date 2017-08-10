//
//  RegisterEntity.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "RegisterEntityRequest.h"

@implementation RegisterEntityRequest

- (NSDictionary *)dictionaryOfEntity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:self.account forKey:@"account"];
    [dic safeSetObject:[self.password md532BitUpper] forKey:@"password"];
    [dic safeSetObject:@(self.role) forKey:@"role"];
    
    NSString *token = [self.account md532BitUpper];
    [dic addEntriesFromDictionary: [BaseEntity sign: @[token]]];

    return dic;
}

@end
