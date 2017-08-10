//
//  LoginEntity.h
//  DrAssistant
//
//  Created by hi on 15/8/28.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface LoginEntity : BaseEntity

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *DEPT_ID;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *LAST_UPDATE_DATE;
@property (nonatomic, copy) NSString *LOGIN_NAME;
@property (nonatomic, copy) NSString *MARRIAGE;
@property (nonatomic, copy) NSString *ORG_ID;
@property (nonatomic, copy) NSString *PHONE;
@property (nonatomic, copy) NSString *POST;
@property (nonatomic, copy) NSString *REAL_NAME;
@property (nonatomic, assign) SexType SEX;
@property (nonatomic, copy) NSString *SPECIALITY;
@property (nonatomic, assign) NSInteger STATUS;
@property (nonatomic, assign) USER_TYPE USER_TYPE;
@property (nonatomic, copy) NSString *WORK_UNIT_PHONE;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *docDesc;
@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *major;
@property (nonatomic, copy) NSString *visit_time;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *jid;
@property (nonatomic, copy) NSString *lastLoginTime;
@property (nonatomic, copy) NSString *resource;

+ (LoginEntity *)entityOfDic:(NSDictionary *)dic;
@end
