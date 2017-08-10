//
//  ValidateCodeHandler.m
//  DrAssistant
//
//  Created by hi on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ValidateCodeHandler.h"

@implementation ValidateCodeHandler

+ (void)getValidateCodeWith:(NSString *)phone success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic addEntriesFromDictionary: [BaseEntity sign: @[[phone md532BitUpper]]]];
        [dic safeSetObject:phone forKey:@"account"];
    
        [[GRNetworkAgent sharedInstance] requestUrl:VALIDATECODEURL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id responeObect) {
            
            PostCaptchasResponse *enity = [PostCaptchasResponse entityOfDic:responeObect];
            
            BLOCK_SAFE_RUN(success, enity);
            
        } failure:^(GRBaseRequest *request, NSError *error) {
            
            BLOCK_SAFE_RUN(failure, error);
        } withTag:RequestTag_Default];
}



@end
