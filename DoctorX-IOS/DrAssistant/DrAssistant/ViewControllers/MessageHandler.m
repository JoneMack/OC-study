//
//  MessageHandler.m
//  DrAssistant
//
//  Created by hi on 15/9/9.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MessageHandler.h"

@implementation MessageHandler

+ (void)getAdsListReq:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    
}

//此处是post请求
+ (void) getUserInfoByUserAccount:(NSString *)account success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    [dic safeSetObject:account forKey:@"account"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getUserInfo_by_username_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
        ChatListUserEntity *enity = [ChatListUserEntity entityOfDic: responeObect];
        BLOCK_SAFE_RUN(success, enity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        BLOCK_SAFE_RUN(failure, error);
    } withTag:RequestTag_Default];
}


@end
