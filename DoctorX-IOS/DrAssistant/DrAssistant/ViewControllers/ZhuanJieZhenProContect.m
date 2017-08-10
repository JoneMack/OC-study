//
//  ZhuanJieZhenProContect.m
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ZhuanJieZhenProContect.h"

@implementation ZhuanJieZhenProContect

- (NSMutableArray *)packageDataWithObject:(id)json
{
    self.modelArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *jsonDic = (NSDictionary *)json;
    
    NSArray *memberArray = [jsonDic objectForKey:@"data"];
    for (NSDictionary *dic in memberArray)
    {
        self.dataEntity = [[ZhuanJieZhenEntity alloc] init];

        self.dataEntity.IN_ORG = [dic objectForKey:@"IN_ORG"];
        self.dataEntity.RECEIVE_USER = [dic objectForKey:@"RECEIVE_USER"];
        self.dataEntity.SEND_USER = [dic objectForKey:@"SEND_USER"];
        self.dataEntity.RECEIVE_THUMB = [dic objectForKey:@"RECEIVE_THUMB"];
        self.dataEntity.ID = [dic objectForKey:@"ID"];
        self.dataEntity.SEX = [dic objectForKey:@"SEX"];
        self.dataEntity.PHONE = [dic objectForKey:@"PHONE"];
        self.dataEntity.MEDICAL_INTRODUCTION = [dic objectForKey:@"MEDICAL_INTRODUCTION"];
        self.dataEntity.OUT_ORG_ID = [dic objectForKey:@"OUT_ORG_ID"];
        self.dataEntity.OUT_ORG = [dic objectForKey:@"OUT_ORG"];
        self.dataEntity.IN_ORG_ID = [dic objectForKey:@"IN_ORG_ID"];
        self.dataEntity.RECEIVE_USER_ID = [dic objectForKey:@"RECEIVE_USER_ID"];
        self.dataEntity.RECEIVE_DEPT_ID = [dic objectForKey:@"RECEIVE_DEPT_ID"];
        self.dataEntity.SEND_USER_ID = [dic objectForKey:@"SEND_USER_ID"];
        self.dataEntity.SEND_DEPT_ID = [dic objectForKey:@"SEND_DEPT_ID"];
        self.dataEntity.SEND_THUMB = [dic objectForKey:@"SEND_THUMB"];
        self.dataEntity.STATUS = [dic objectForKey:@"STATUS"];
        self.dataEntity.type = [dic objectForKey:@"type"];
        
        [_modelArray addObject:self.dataEntity];
    }
    return _modelArray;

}
@end
