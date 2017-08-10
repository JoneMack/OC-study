//
//  RegisterHandler.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "RegisterHandler.h"
#import "PostCaptchasResponse.h"
#import "RegisterEntityRequest.h"
#import "RegisterEntityResponse.h"
#import "ThirdRegisterEntityRequest.h"
#import "GRNetworkAgent.h"

@implementation RegisterHandler

+ (void)registerRequestWithRegisterInfo:(RegisterEntityRequest *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:registerInfo.account
//                                                         password:EM_PSWD
//                                                   withCompletion:
//     ^(NSString *username, NSString *password, EMError *error) {
//         
//         if (!error) {
    
             [RegisterHandler ownServerRegisterInfo:registerInfo success:^(BaseEntity *object) {
                 
                 BLOCK_SAFE_RUN(success, object);
                 
             } fail:^(id object) {
                 
                 BLOCK_SAFE_RUN(failure, object);
             }];
//         }else{
//             switch (error.errorCode) {
//                
//                 case EMErrorServerDuplicatedAccount:
//                 case EMErrorNetworkNotConnected:
//                 case EMErrorServerTimeout:
//                 case EMErrorServerNotReachable:
//                 {
//                     BLOCK_SAFE_RUN(failure, error);
//                 }
//                     break;
//                 default:
//                     break;
//             }
//         }
//     } onQueue:nil];
}

+ (void)ownServerRegisterInfo:(RegisterEntityRequest *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    NSDictionary *paramDic = [registerInfo dictionaryOfEntity];
    [[GRNetworkAgent sharedInstance] requestUrl:REGISTER_URL param:paramDic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        
        RegisterEntityResponse *entity = [RegisterEntityResponse entityOfDic:responeObect];
        NSLog(@">>>>>>>>>>>>祖册数据>>>>>>>>>>>>%@",entity.dataDic);
        BLOCK_SAFE_RUN(success, entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}

+ (void)thirdPlatformRegisterInfo:(ThirdRegisterEntityRequest *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    NSDictionary *paramDic = [registerInfo dictionaryOfEntity];
    [[GRNetworkAgent sharedInstance] requestUrl:third_login_bind_url param:paramDic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        
        RegisterEntityResponse *entity = [RegisterEntityResponse entityOfDic:responeObect];
        
        BLOCK_SAFE_RUN(success, entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}

+ (void)getUserInfoByUid:(NSString *)token success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    [dic safeSetObject:token forKey:@"s_token"];
    [[GRNetworkAgent sharedInstance] requestUrl:check_account_by_token_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        
        RegisterEntityResponse *entity = [RegisterEntityResponse entityOfDic:responeObect];
        
        BLOCK_SAFE_RUN(success, entity);
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}




@end
