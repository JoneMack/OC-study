//
//  FindPasswordHanlder.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "FindPasswordHanlder.h"
#import "GRNetworkAgent.h"
#import "FindPasswordEntity.h"

@implementation FindPasswordHanlder

+ (void)FindRequestWithFindPasswordInfo:(FindPasswordEntity *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    NSDictionary *paramDic = registerInfo.dictionaryOfEntity;
    
    [[GRNetworkAgent sharedInstance] requestUrl:FINDPWD_URL param:paramDic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        
        FindPasswordEntity *entity = [FindPasswordEntity entityOfDic:responeObect];
        
       BLOCK_SAFE_RUN(success, entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}

@end
