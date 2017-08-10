//
//  ZhuanJiaEntity.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface ZhuanJiaEntity : BaseEntity

@property (nonatomic, strong) NSArray *zhuanJiaList;


@property (nonatomic, copy) NSString *SEX;
@property (nonatomic, copy) NSString *LOGIN_NAME;
@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *USER_TYPE;
@property (nonatomic, copy) NSString *LAST_UPDATE_DATE;
@property (nonatomic, copy) NSString *SPECIALITY;
@property (nonatomic, copy) NSString *major;
@property (nonatomic, copy) NSString *REAL_NAME;
@property (nonatomic, copy) NSString *POST;
@property (nonatomic, copy) NSString *MARRIAGE;
@property (nonatomic, copy) NSString *docDesc;
@property (nonatomic, copy) NSString *DEPT_ID;
@property (nonatomic, copy) NSString *visit_time;
@property (nonatomic, copy) NSString *CERT_STATUS;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *STATUS;
@property (nonatomic, copy) NSString *PHONE;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *ORG_ID;
@property (nonatomic, copy) NSString *WORK_UNIT_PHONE;
@property (nonatomic, copy) NSString *thumb;

+ (ZhuanJiaEntity *)entityOFDic:(NSDictionary *)dic;

@end
