//
//  AddCaseHandler.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AddCaseHandler.h"

@implementation AddCaseHandler

+ (void)myCaseRequestWithLoginInfo:(AddCaseEntity *)addCaseInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    [[GRNetworkAgent sharedInstance] requestUrl:ADDCASE_URL param:[addCaseInfo dictionaryOfEntity] baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        AddCaseEntity *entity = [AddCaseEntity entityOfDic:reponeObject];
        BLOCK_SAFE_RUN(success,entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        BLOCK_SAFE_RUN(failure,error);
    } withTag:RequestTag_Default];
}
+ (void)myCaseRequestWithLoginInfo:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    [[GRNetworkAgent sharedInstance] requestUrl:ADDCASE_URL param:nil baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        AddCaseEntity *entity = [AddCaseEntity entityOfDic:reponeObject];
        BLOCK_SAFE_RUN(success,entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        BLOCK_SAFE_RUN(failure,error);
    } withTag:RequestTag_Default];
}

+ (void)myCaseUpLoadImageWithsuccess:(RequestSuccessBlock)success fail:(RequestFailBlock)failure
{
    NSString *path = @"/Users/zhu/Desktop/5{DTOR0$}B6)$5U0%GDUFDD.jpg";
    NSString *name = @"image";
    
    [[GRNetworkAgent sharedInstance] uploadFile:UPLOAD_IMAGE_URL baseUrl:BASEURL filePath:path fileName:name param:nil Success:^(GRBaseRequest *request, id reponeObject) {
        BLOCK_SAFE_RUN(success,nil);
    } failure:^(GRBaseRequest *request, NSError *error) {
        BLOCK_SAFE_RUN(failure,error);
    } withTag:RequestTag_Default];
}

@end
