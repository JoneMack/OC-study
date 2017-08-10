//
//  LoginHandler.m
//  DrAssistant
//
//  Created by hi on 15/8/28.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "LoginHandler.h"
#import "GRNetworkAgent.h"
@implementation LoginHandler

+ (void)loginRequestWithLoginInfo:(LoginEntity *)loginEntity success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    [[GRNetworkAgent sharedInstance] requestUrl:LOGIN_URL param: [loginEntity dictionaryOfEntity] baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",responeObect);
        LoginEntity *entity = [LoginEntity entityOfDic:responeObect];
        if (success) {
        }
        BLOCK_SAFE_RUN(success, entity);
        
        //这地方暂时先注释了
        //[self getAllOrgs];
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}

+ (void)getAllOrgs
{
    [LoginHandler getAllOrgsSuccess:^(BaseEntity *object) {
        NSLog(@"....>>>>>>>>>>>>>>>>>>>获得数据：%@",object.msg);
    } fail:^(id object) {
        
    }];
}

+ (void)getAllOrgsSuccess:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    
    [[GRNetworkAgent sharedInstance] requestUrl:AllOrgs_URL param: [BaseEntity sign:nil] baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        
        
        //BLOCK_SAFE_RUN(success, nil);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
       // BLOCK_SAFE_RUN(fail, error);
    } withTag:RequestTag_Default];
}

+ (void)thirdLoginRequestWithLoginInfo:(ThirdLoginEntity *)loginEntity success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    [[GRNetworkAgent sharedInstance] requestUrl:LOGIN_URL param: [loginEntity dictionaryOfEntity] baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",responeObect);
        LoginEntity *entity = [LoginEntity entityOfDic:responeObect];
        if (success) {
        }
        BLOCK_SAFE_RUN(success, entity);
        //                 这地方暂时先注释了
        [self getAllOrgs];
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}


@end
