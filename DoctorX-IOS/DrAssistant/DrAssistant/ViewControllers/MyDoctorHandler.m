//
//  MyDoctorHandler.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyDoctorHandler.h"
#import "MyDoctorEntity.h"

@implementation MyDoctorHandler

+ (void)requestDoctorList:(RequestSuccessBlock) success fail:(RequestFailBlock)fail
{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:@(YES) forKey:@"needFriend"];
    [dic safeSetObject:account forKey:@"account"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getMyDoctors_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        UserEntity *enitty = [UserEntity objectWithKeyValues: reponeObject];
        
        BLOCK_SAFE_RUN(success, enitty);
    } failure:^(GRBaseRequest *request, NSError *error) {
        BLOCK_SAFE_RUN(fail, error);
    } withTag:0];
}

@end
