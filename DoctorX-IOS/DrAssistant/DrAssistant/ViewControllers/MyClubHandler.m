//
//  MyClubHandler.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyClubHandler.h"
#import "ClubEntityResponse.h"
@implementation MyClubHandler

+ (void)requestMyClubs:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    
    NSDictionary *dic =  [[MyClubEntity new] dictionaryOfEntity];
    [[GRNetworkAgent sharedInstance] requestUrl:MYCLUBURL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
       MyClubEntity *entity = [MyClubEntity entityOfDic: reponeObject];
        
        BLOCK_SAFE_RUN(success, entity);
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
         BLOCK_SAFE_RUN(fail, error);
    } withTag:0];
}

+ (void)requestZhuanJiaListWithClubID:(NSString *)clubID success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail
{
    if ([Utils isBlankString: clubID]) {
        return;
    }
    
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:clubID forKey:@"CLUB_ID"];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[clubID]]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:ZHUANJIALISTURL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        ZhuanJiaEntity *entity = [ZhuanJiaEntity entityOFDic: reponeObject];
        NSLog(@"ZhuanJiaEntity:%@",entity);
        BLOCK_SAFE_RUN(success, nil);
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        BLOCK_SAFE_RUN(fail, error);
    } withTag:0];
    
}
//description:用户加入俱乐部
//date:   2015-10-04
//author: taller
+(void)joinUserClub:(NSString *)clubID :(NSString *)userID :(NSString*)attention success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:clubID forKey:@"club_id"];
    [dic safeSetObject:userID forKey:@"account"];
    [dic safeSetObject:attention forKey:@"attention"];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[clubID]]];
    [[GRNetworkAgent sharedInstance] requestUrl:payAttentionToClubUrl param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        ClubEntityResponse *entity=[ClubEntityResponse entityOfDic: reponeObject];
        BLOCK_SAFE_RUN(success, entity);
    } failure:^(GRBaseRequest *request, NSError *error) {
        BLOCK_SAFE_RUN(fail, error);
    } withTag:0];

}
@end
