//
//  PatiendDetailHandler.m
//  DrAssistant_FBB
//
//  Created by Seiko on 15/9/30.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "PatiendDetailHandler.h"

@implementation PatiendDetailHandler

+ (void)patiendDetailWithInfosuccess:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
//    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic safeSetObject:account forKey:@"account"];
//    [dic safeSetObject:@(type) forKey:@"type"];
//    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getGroups_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
//        GroupListEntity *entity = [GroupListEntity objectWithKeyValues: reponeObject];
//        BLOCK_SAFE_RUN(success, entity)
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error)
    } withTag:0];
}

@end
