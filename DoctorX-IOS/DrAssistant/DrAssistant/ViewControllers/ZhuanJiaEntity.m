//
//  ZhuanJiaEntity.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ZhuanJiaEntity.h"

@implementation ZhuanJiaEntity

+ (ZhuanJiaEntity *)entityOFDic:(NSDictionary *)dataDic
{
    ZhuanJiaEntity *zhuanjiaInfo = [[ZhuanJiaEntity alloc] init];
 
    zhuanjiaInfo.success = [dataDic safeObjectForKey:@"success"];
    zhuanjiaInfo.msg = [dataDic safeObjectForKey: @"msg"];
    NSArray *dataArr = [dataDic safeObjectForKey: @"data"];
    
    NSMutableArray *zhuanjias = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        
        ZhuanJiaEntity *entity = [[ZhuanJiaEntity alloc] init];
        entity.SEX = [dic stringValueForKey: @"SEX"];
        entity.LOGIN_NAME = [dic stringValueForKey: @"LOGIN_NAME"];
        entity.education = [dic stringValueForKey: @"education"];
        entity.USER_TYPE = [dic stringValueForKey: @"USER_TYPE"];
        entity.LAST_UPDATE_DATE = [dic stringValueForKey: @"LAST_UPDATE_DATE"];
        entity.SPECIALITY = [dic stringValueForKey: @"SPECIALITY"];
        entity.major = [dic stringValueForKey: @"major"];
        entity.REAL_NAME = [dic stringValueForKey: @"REAL_NAME"];
        entity.POST = [dic stringValueForKey: @"POST"];
        entity.MARRIAGE = [dic stringValueForKey: @"MARRIAGE"];
        entity.docDesc = [dic stringValueForKey: @"docDesc"];
        entity.DEPT_ID = [dic stringValueForKey: @"DEPT_ID"];
        entity.visit_time = [dic stringValueForKey: @"visit_time"];
        entity.CERT_STATUS = [dic stringValueForKey: @"CERT_STATUS"];
        entity.thumb = [dic stringValueForKey: @"thumb"];
        entity.ID = [dic stringValueForKey: @"ID"];
        entity.STATUS = [dic stringValueForKey: @"STATUS"];
        entity.PHONE = [dic stringValueForKey: @"PHONE"];
        entity.age = [dic stringValueForKey: @"age"];
        entity.ORG_ID = [dic stringValueForKey: @"ORG_ID"];
        entity.WORK_UNIT_PHONE = [dic stringValueForKey: @"WORK_UNIT_PHONE"];
        
        [zhuanjias safeAddObject: entity];
    }
    
    zhuanjiaInfo.zhuanJiaList = zhuanjias;
    
    
    return zhuanjiaInfo;
}

@end
