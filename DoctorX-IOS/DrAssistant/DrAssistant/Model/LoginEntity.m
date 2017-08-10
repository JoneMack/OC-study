//
//  LoginEntity.m
//  DrAssistant
//
//  Created by hi on 15/8/28.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "LoginEntity.h"

@implementation LoginEntity

- (NSDictionary *)dictionaryOfEntity
{
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    [requestDict safeSetObject:self.account forKey:@"account"];
    NSString *password = [self.password md532BitUpper];
    
    [requestDict safeSetObject:password forKey:@"password"];
    
    NSString *token = [self.password md532BitUpper];
    
   NSDictionary *sigDic = [LoginEntity sign:@[token]];
    
    [requestDict addEntriesFromDictionary: sigDic];
//    
//    [requestDict safeSetObject:token forKey:@"token"];
//    long date = [Utils timeStmp];
//    [requestDict safeSetObject:@(date) forKey:@"date"];
//    
//    NSString *sign =[[NSString stringWithFormat:@"%@%@%@",token,@(date), SecureKey] md532BitUpper];
//    
//    [requestDict safeSetObject:sign forKey:@"sign"];
    
    return requestDict;
}

+ (LoginEntity *)entityOfDic:(NSDictionary *)dic
{
    LoginEntity *entity = [[LoginEntity alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    entity.token = [dic stringValueForKey:@"token"];
    
    NSDictionary *dataDic = [dic dictionaryForkey:@"data"];
    
//    entity.DEPT_ID = [dataDic stringValueForKey: @"DEPT_ID"];
//    entity.ID =[dataDic stringValueForKey: @"ID"];
//    entity.LAST_UPDATE_DATE =[dataDic stringValueForKey: @"LAST_UPDATE_DATE"];
//    entity.LOGIN_NAME =[dataDic stringValueForKey: @"LOGIN_NAME"];
//    entity.MARRIAGE =[dataDic stringValueForKey: @"MARRIAGE"];
//    entity.ORG_ID =[dataDic stringValueForKey: @"ORG_ID"];
//    entity.PHONE =[dataDic stringValueForKey: @"PHONE"];
//    entity.POST =[dataDic stringValueForKey: @"POST"];
//    entity.REAL_NAME =[dataDic stringValueForKey: @"REAL_NAME"];
//    entity.SEX =[dataDic integerForKey: @"SEX"];
//    entity.SPECIALITY =[dataDic stringValueForKey: @"SPECIALITY"];
//    entity.STATUS =[dataDic integerForKey: @"STATUS"];
//    entity.USER_TYPE =[dataDic integerForKey: @"USER_TYPE"];
//    entity.WORK_UNIT_PHONE =[dataDic stringValueForKey: @"WORK_UNIT_PHONE"];
//    entity.age = [dataDic integerForKey: @"age"];
//    entity.docDesc = [dataDic stringValueForKey: @"docDesc"];
//    entity.education = [dataDic stringValueForKey: @"education"];
//    entity.major = [dataDic stringValueForKey: @"major"];
//    entity.visit_time = [dataDic stringValueForKey: @"visit_time"];
    UserContext *userEntity = [UserContext getUserContextWithDataDic:dataDic];
    
    [GlobalConst shareInstance].token = entity.token;
    [GlobalConst shareInstance].loginInfo = userEntity;
    
    return entity;
}

@end
