//
//  ZhuanJiaHandler.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ZhuanJiaHandler.h"

@implementation ZhuanJiaHandler

+ (void)requestZhuanJiaListWithClubID:(MyClubEntity *)club success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    if ([Utils isBlankString: club.ID]) {
        return;
    }
    
    NSString *userID = [GlobalConst shareInstance].loginInfo.iD;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:club.ID forKey:@"CLUB_ID"];
    [dic safeSetObject:userID forKey:@"p_id"];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[club.ID]]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:ZHUANJIALISTURL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
       UserEntity *entity = [UserEntity objectWithKeyValues:reponeObject];
        BLOCK_SAFE_RUN(success, entity);
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error);
    } withTag:0];
    
}

@end
