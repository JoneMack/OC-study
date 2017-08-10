//
//  ChatDataHandler.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/31.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ChatDataHandler.h"

@implementation ChatDataHandler
+ (void)putAssistantServiceByAccountId:(NSString *)accountId sendId:(NSString *)sendId  acceptId:(NSString *)acceptId msgType:(NSString *)msgType msgContent:(NSString *)msgContent success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:accountId forKey:@"accountId"];
    [dic safeSetObject:sendId forKey:@"sendId"];
    [dic safeSetObject:acceptId forKey:@"acceptId"];
    [dic safeSetObject:msgType forKey:@"msgType"];
    [dic safeSetObject:msgContent forKey:@"msgContent"];
//    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    NSLog(@">>>>>>>>>>>dicdicdicdicdicdicdicdic>>>>>>>>>>>>>>%@",dic);
    [[GRNetworkAgent sharedInstance] requestUrl:Assistant_service_url param:dic baseUrl:test withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@">>>>>>>>>>>>>>是事实上事实上事实上事实上呢>>>>>>>>>>>%@",reponeObject);
        //BaseEntity *baseEntity = [BaseEntity objectWithKeyValues:reponeObject];
        //BLOCK_SAFE_RUN(success, baseEntity)
    } failure:^(GRBaseRequest *request, NSError *error) {
       // BLOCK_SAFE_RUN(fail, error)
    } withTag:RequestTag_Default];
}
@end
