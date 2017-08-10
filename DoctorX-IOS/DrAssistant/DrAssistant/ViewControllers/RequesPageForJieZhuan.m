//
//  RequesPageForJieZhuan.m
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "RequesPageForJieZhuan.h"

@implementation RequesPageForJieZhuan

+ (void)startRequestWithStringWithDataArray:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock
{
    NSString *UserName = [GlobalConst shareInstance].loginInfo.iD;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic setObject:UserName forKey:@"username"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:GetTreatment param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        dataBlock(reponeObject);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
    
}

+ (void)saveZhuanJieZhenDataUpLoad:(NSDictionary *)dictionary withSuccess:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock
{
//    NSString *UserName = [GlobalConst shareInstance].loginInfo.iD;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:AddTreatment param:dictionary baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        dataBlock(reponeObject);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}

+ (void)searchHospital:(NSString *)hospitalName withSuccess:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic setObject:@"" forKey:@"hospital"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:SEARCHHOSPITAL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        dataBlock(reponeObject);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}

+ (void)searchDoctor:(NSString *)HospitalID withSuccess:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic setObject:HospitalID forKey:@"orgId"];
    [dic setObject:@"" forKey:@"doctor"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:SEARCHDOCTOR param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        dataBlock(reponeObject);
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}
@end
