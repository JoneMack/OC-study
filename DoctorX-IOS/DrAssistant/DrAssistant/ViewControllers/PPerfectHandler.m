//
//  PPerfectHandler.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "PPerfectHandler.h"

@implementation PPerfectHandler

+ (void)pPerfectRequestWithLoginInfo:(PPerfectEntity *)userInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    [[GRNetworkAgent sharedInstance] requestUrl:UPDATE_USER_INFO_URL param: [userInfo dictionaryOfEntity] baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        
        PPerfectEntity *entity = [PPerfectEntity entityOfDic:responeObect];
        BLOCK_SAFE_RUN(success, entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}

@end
