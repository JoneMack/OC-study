//
//  SearchHandler.m
//  DrAssistant
//
//  Created by ap2 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "SearchHandler.h"

@implementation SearchHandler

+ (void)searchUserWithAccount:(NSString *)name type:(NSInteger)type success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    if ([Utils isBlankString: name]) {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic safeSetObject:name forKey:@"account"];
    [dic safeSetObject:@(type) forKey:@"type"];

    [[GRNetworkAgent sharedInstance] requestUrl:searchUser_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        UserEntity *entity = [UserEntity objectWithKeyValues: reponeObject];
        
        BLOCK_SAFE_RUN(success, entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
         BLOCK_SAFE_RUN(fail, error);
    } withTag:0];
}

+ (void)searchUserWithYiYuanID:(NSString *)YiYuanID keShiID:(NSString *)keShiID  success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    if ([Utils isBlankString: YiYuanID] || [Utils isBlankString: keShiID]) {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic safeSetObject:YiYuanID forKey:@"orgId"];
    [dic safeSetObject:keShiID forKey:@"deptId"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getDoctorsByOrgIdAndDeptId_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        
        BLOCK_SAFE_RUN(success, nil);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error);
    } withTag:0];
}

+ (void)searchUserWithAccountByNmae:(NSString *)name success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    if ([Utils isBlankString: name]) {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic safeSetObject:name forKey:@"account"];
    [dic safeSetObject:@(1) forKey:@"type"];
    [[GRNetworkAgent sharedInstance] requestUrl:searchUser_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        UserEntity *entity = [UserEntity objectWithKeyValues: reponeObject];
        
        BLOCK_SAFE_RUN(success, entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error);
    } withTag:0];
}


@end
