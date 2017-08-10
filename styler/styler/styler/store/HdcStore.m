//
//  HdcStore.m
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "Store.h"
#import "HdcStore.h"
#import "UserHdc.h"
#import "HdcCatalog.h"
#import "RedEnvelopeStore.h"
#import "HdcPaymentItem.h"
#import "OrganizationFilter.h"
#import "HdcInvitationReward.h"


@implementation HdcStore

+(void) searchHdc:(void (^)(Page *, NSError *))completionBlock query:(HdcQuery *)query{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *queryJson = [query toJSONString];
    NSString *url = [NSString stringWithFormat:@"/hairDressingCards/searcher?hdcQueryJson=%@", queryJson];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *jsonDictArray = [jsonDict objectForKey:@"items"];
            NSArray *hdcs = [HairDressingCard arrayOfModelsFromDictionaries:jsonDictArray];
            page.items = hdcs;
            completionBlock(page, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void) getHdc:(void(^)(HairDressingCard *card, NSError *error))completionBlock cardId:(int)cardId{
    HttpRequestFacade *requst = [HttpRequestFacade sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"/hairDressingCards/hairDressingCardId,%d", cardId];
    
    [requst get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            HairDressingCard *card = [[HairDressingCard alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(card, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void) checkUnpaymentAmountHdcs:(void (^)(NSError *err))completionBlock{
    
    NSArray *hdcStatus = [[NSArray alloc] initWithObjects:@"0", nil];
    
    AppStatus *as = [AppStatus sharedInstance];
    [HdcStore getUserHdcByUserId:^(Page *page, NSError *error) {
        if (error == nil) {
            BOOL checkResult = NO;
            if (page.totalCount > 0) {
                checkResult = YES;
                completionBlock(error);
            }
            
            if (as.hasUnpaymentHdc != checkResult) {
                as.hasUnpaymentHdc = checkResult;
                [AppStatus saveAppStatus];
                [as updateBadge];
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_has_unpayment_hdc object:nil];
            }
        }
    } userId:as.user.idStr.intValue pageNo:1 cardStatus:hdcStatus];
}

+(void) createHdcOrder:(void (^)(HdcOrder *, NSError *))completionBlock
                userId:(int)userId
    hairDressingCardId:(int)hairDressingCardId
        organizationId:(int)organizationId
              hdcCount:(int)hdcCount
         redEnvelopeId:(int)redEnvelopeId
             stylistId:(int)stylistId{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/hdcOrders/userId,%d", userId];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(hairDressingCardId) forKey:@"hairDressingCardId"];
    [params setValue:@(organizationId) forKey:@"organizationId"];
    [params setValue:@(hdcCount) forKey:@"hdcCount"];
    [params setValue:@(redEnvelopeId) forKey:@"redEnvelopeId"];
    [params setValue:@(stylistId) forKey:@"stylistId"];
    [request post:url completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = [json objectFromJSONString];
            HdcOrder *order = [[HdcOrder alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(order, nil);
        }else{
            completionBlock(nil, err);
        }
    } params:params];
}

+(void) updateUserHdcOrder:(void (^)(UserHdc *, NSError *))completionBlock
                userId:(int)userId
        hdcOrderItemId:(int)hdcOrderItemId
         redEnvelopeId:(int)redEnvelopeId{
    
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/hdcOrders/userId,%d?hdcOrderItemId=%d&redEnvelopeId=%d" , userId , hdcOrderItemId ,redEnvelopeId];

    [request put:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            UserHdc *userHdc = [[UserHdc alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(userHdc, nil);
        }else{
            completionBlock(nil, err);
        }
    }];
    
}

+(void) getUserHdcByUserId:(void (^)(Page *, NSError *))completionBlock userId:(int)userId pageNo:(int)pageNo cardStatus:(NSArray *)cardStatuses
{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/hdcOrderItems/userId,%d?pageNo=%d&pageSize=%d&cacheFlag=false&orderItemStatuses=%@", userId, pageNo,user_hdc_page_size, [cardStatuses componentsJoinedByString:@","]];
    NSLog(@"url ?????? %@" , url);
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *hdcs = [UserHdc arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"] ];
            page.items = hdcs;
            completionBlock(page, nil);
        }
        else if(json == nil){
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

+(void) getUserHdcByUserHdcNums:(void (^)(NSArray *, NSError *))completionBlock userHdcNums:(NSString *)userHdcNum
{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/hdcOrderItems/hdcNums,%@?cacheFlag=false", userHdcNum];
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSArray *jsonDictArray = [json objectFromJSONString];
            NSArray *hdcs = [UserHdc arrayOfModelsFromDictionaries:jsonDictArray];
           UserHdc *hdc = hdcs[0];
            if ([hdc hasUsedRedEnvelope]) {
                [RedEnvelopeStore getRedEnvelopesByIds:^(NSArray *redEnvelopes, NSError *error) {
                    for (RedEnvelope *redEnvelope in redEnvelopes) {
                        if ([hdc.hdcPaymentItems[0] redEnvelopeId] ==  redEnvelope.id) {
                            NSArray *hdcPaymentItems = hdc.hdcPaymentItems;
                            HdcPaymentItem *hdcPaymentItem = hdcPaymentItems[0];
                            hdcPaymentItem.redEnvelope = redEnvelope;
                        }
                    }
                } redEnvelopeIds:[NSArray arrayWithObject:[NSString stringWithFormat:@"%d" , [hdc getRedEnvelopeId]]]];
            }
            completionBlock(hdcs, nil);
        }
        else if(json == nil){
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

+(void) updateUserHdcStatus:(void (^)(NSError *err))completionBlock
                userHdcNums:(NSArray *)userHdcNums
                 hdcStatus:(int)hdcStatus{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *hdcNumsStr = [userHdcNums componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:@"/hdcOrderItems/hdcNums,%@/status?status=%d", hdcNumsStr, hdcStatus];
    [request put:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            completionBlock(nil);
        }else{
            StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
            NSLog(@"更新订单出错: 错误status:%d, 信息:%@" , [exception status], [exception message]);
            completionBlock(err);
        }
    }];
}


+(void) searcherHdcsByOrganizationIds:(void(^)(NSArray *hdcs , NSError *error))completionBlock
                      organizationIds:(NSArray *)organizationIds
                   organizationFilter:(OrganizationFilter *)organizationFilter{

    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *organizationIdsStr =  [organizationIds componentsJoinedByString:@","];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/hdcs/organizationIds,%@?hdcType=%d&mustRecommend=%@" ,[AppStatus sharedInstance].searcherUrl, organizationIdsStr , organizationFilter.selectedHdcTypeId,@"false"]];
//    NSLog(@">>>>>>>url >>>%@" ,url);
    [request doGet:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSArray *jsonDictArray = [json objectFromJSONString];
            NSArray *hdcs = [HairDressingCard arrayOfModelsFromDictionaries:jsonDictArray];
            completionBlock(hdcs, nil);
        }else{
            completionBlock(nil, err);
        }

    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void) getHdcTypeByBusinessCircleId:(void(^)(NSArray *hdcTypes, NSError *error))completionBlock
                   businessCirclesId:(int)businessCirclesId{
    
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/hdcTypes/searcher?businessCirclesId=%d" , businessCirclesId];
    
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSArray *jsonDictArray = [json objectFromJSONString];
            NSArray *hdcTypes = [HdcType arrayOfModelsFromDictionaries:jsonDictArray];
            completionBlock(hdcTypes, nil);
        }else{
            completionBlock(nil, err);
        }
    }refresh:YES useCacheIfNetworkFail:YES];
    
}

/**
 *  获取美发卡赠送对象
 */
+(void) getInvitationReward:(void (^)(HdcInvitationReward *hdcReward , NSError *))completionBlock hdcNum:(NSString *)hdcNum{
    
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userHdcs/hdcNum,%@/invitationReward" , hdcNum];
    
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            
            NSDictionary *jsonDict = [json objectFromJSONString];
            HdcInvitationReward *hdcReward = [[HdcInvitationReward alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(hdcReward , nil);
        }else{
            [SVProgressHUD dismiss];
            NSLog(@"获取美发卡赠送对象失败");
        }
    }refresh:YES useCacheIfNetworkFail:NO];

}



/**
 *  取消美发卡的赠送
 */
+(void) removeInvitationReward:(void(^)(NSError *error))completionBlock
                        hdcNum:(NSString *)hdcNum{

    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userHdcs/hdcNum,%@/invitationReward" , hdcNum];
    
    [request delete:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            completionBlock(nil);
        }else{
            NSLog(@"删除美发卡赠送对象失败");
        }
    }];

}


/**
 *  获取所有的美发卡类型
 */
+(void) getAllHdcTypes:(void(^)(NSArray *hdcCatalogs , NSError *error))completionBlock{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/hdcCatalogs"];
    
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            NSArray *jsonDictArray = [json objectFromJSONString];
            NSArray *hdcCatalogs = [HdcCatalog arrayOfModelsFromDictionaries:jsonDictArray];
            completionBlock(hdcCatalogs, nil);
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取美发卡类型失败" duration:1.0];
        }
    } refresh:YES useCacheIfNetworkFail:YES];
    
    
}



@end
