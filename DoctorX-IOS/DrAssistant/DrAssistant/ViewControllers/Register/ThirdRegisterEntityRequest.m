//
//  ThirdRegisterEntityRequest.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/14.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ThirdRegisterEntityRequest.h"

@implementation ThirdRegisterEntityRequest
- (NSDictionary *)dictionaryOfEntity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:self.account forKey:@"account"];
    [dic safeSetObject:[self.password md532BitUpper] forKey:@"password"];
    [dic safeSetObject:@(self.role) forKey:@"role"];
    [dic safeSetObject:self.realName forKey:@"realName"];
    [dic safeSetObject:self.thumb forKey:@"thumb"];
    [dic safeSetObject:self.birthPlace forKey:@"birthPlace"];
    [dic safeSetObject:self.s_token forKey:@"s_token"];
    [dic safeSetObject:@(self.sex) forKey:@"sex"];
    [dic safeSetObject:self.location forKey:@"location"];
    [dic safeSetObject:self.education forKey:@"education"];
    NSString *token = [self.account md532BitUpper];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[token]]];
    
    return dic;
}

@end
