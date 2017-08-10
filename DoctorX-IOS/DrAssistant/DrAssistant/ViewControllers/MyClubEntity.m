//
//  MyClubEntity.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyClubEntity.h"

@implementation MyClubEntity

- (NSDictionary *)dictionaryOfEntity
{
    NSString *userID = [GlobalConst shareInstance].loginInfo.iD;
    
//    token = [[NSString stringWithFormat:@"%@%zi%@", token, date, SecureKey] md532BitUpper];
//    
//    NSString *sign =[[NSString stringWithFormat:@"%@%@%@",token,@(date), SecureKey] md532BitUpper];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *sinDic = [MyClubEntity sign:nil];
    [dic addEntriesFromDictionary: sinDic];
   
     [dic safeSetObject:userID forKey:@"user"];
    
    return dic;
}

+ (MyClubEntity*)entityOfDic:(NSDictionary *)dataDic
{
    if ([dataDic isDictionary])
    {
        MyClubEntity *entity = [[MyClubEntity alloc] init];
        
        entity.success = [dataDic boolValueForKey: @"success"];
        entity.msg = [dataDic stringValueForKey: @"msg"];
        
       NSArray *dataArr = [dataDic arrayForkey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr)
        {
            MyClubEntity *club = [[MyClubEntity alloc] init];
            club.clubName = [dic stringValueForKey: @"CLUB_NAME"];
            club.CLUB_THUMB = [dic stringValueForKey: @"CLUB_THUMB"];
            club.ID = [dic stringValueForKey: @"ID"];
            club.INTRODUCTION = [dic stringValueForKey: @"INTRODUCTION"];
            club.NUMS = [dic integerForKey: @"NUMS"];
            club.isJoined = [dic boolValueForKey: @"isJoined"];
            club.SORT = [dic integerForKey: @"SORT"];
            [arr safeAddObject: club];
        }
        
        entity.clubList = arr;
        return entity;
    }
    
    return nil;
}

@end
