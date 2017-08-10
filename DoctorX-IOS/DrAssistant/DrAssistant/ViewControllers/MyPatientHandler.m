//
//  MyPatientHandler.m
//  DrAssistant
//
//  Created by ap2 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyPatientHandler.h"
#import "RegisterEntityResponse.h"
#import "ResponeEntity.h"
#import "HealthDetailDataEntity.h"
#import "HealthEntity.h"
@implementation MyPatientHandler

+ (void)getAllGroupWithType:(NSInteger)type success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic safeSetObject:@(type) forKey:@"type"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getGroups_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
       
        GroupListEntity *entity = [GroupListEntity objectWithKeyValues: reponeObject];
        
        BLOCK_SAFE_RUN(success, entity)
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error)
    } withTag:0];
}

+ (void)deleteFriendByAccount:(NSString *)account friendLoginName:(NSString *)friendLoginName success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic safeSetObject:friendLoginName forKey:@"friend"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:delete_user_friends_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",reponeObject);
        BaseEntity *baseEntity = [BaseEntity objectWithKeyValues:reponeObject];
        BLOCK_SAFE_RUN(success, baseEntity)
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error)
    } withTag:0];
}

+ (void)changeGroupByAccount:(NSString *)account friendLoginName:(NSString *)friendId groupId:(NSString *)groupId success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic safeSetObject:friendId forKey:@"friend"];
    [dic safeSetObject:groupId forKey:@"group"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    NSLog(@">>>>>>>>>>>dicdicdicdicdicdicdicdic>>>>>>>>>>>>>>%@",dic);
    [[GRNetworkAgent sharedInstance] requestUrl:change_user_friends_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",reponeObject);
        BaseEntity *baseEntity = [BaseEntity objectWithKeyValues:reponeObject];
        BLOCK_SAFE_RUN(success, baseEntity)
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        BLOCK_SAFE_RUN(fail, error)
    } withTag:0];
}

+ (void)checkWhetherJoinedClubWithType:(NSInteger)type success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic safeSetObject:@(type) forKey:@"type"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:check_whether_joined_club_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
    
        GroupListEntity *entity = [GroupListEntity objectWithKeyValues: reponeObject];
        NSLog(@">>>>>>>>>>>>>>>>>>是否有数据返回>>>>>>>>>>>%@",entity.data);
        BLOCK_SAFE_RUN(success, entity)
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error)
    } withTag:0];
}

+ (void)getClubDetailDataByDoctorId:(NSString *)doctorId success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:doctorId forKey:@"user_id"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:get_club_detail_data_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        GroupListEntity *entity = [GroupListEntity objectWithKeyValues: reponeObject];
//        BaseEntity *entity = [BaseEntity objectWithKeyValues:reponeObject];
        NSLog(@">>>>>>>>>>>>>>>>>>是否>>>>>>>>>>%@",entity);
        BLOCK_SAFE_RUN(success, entity)
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error)
    } withTag:0];
}

+ (void)getHealthDataByFriendId:(NSString *)friendId success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:friendId forKey:@"user_id"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:get_friend_health_data_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        HealthEntity *entity = [HealthEntity objectWithKeyValues: reponeObject];
        //        BaseEntity *entity = [BaseEntity objectWithKeyValues:reponeObject];
//        NSLog(@">>>>>>>>>>>>>>>>>>是否>>>>>>>>>>%@",entity);
        BLOCK_SAFE_RUN(success, entity)
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error)
    } withTag:0];

}


@end
