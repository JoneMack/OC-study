//
//  HdcStore.h
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//
#import "HdcQuery.h"
#import "Page.h"
#import "HairDressingCard.h"
#import "HdcOrder.h"
#import "HdcType.h"
@class OrganizationFilter;

@interface HdcStore : NSObject

+(void) searchHdc:(void(^)(Page *page, NSError *error))completionBlock
            query:(HdcQuery *)query;

+(void) getHdc:(void(^)(HairDressingCard *card, NSError *error))completionBlock
        cardId:(int)cardId;

+(void) checkUnpaymentAmountHdcs:(void(^)(NSError *error))completionBlock;

//创建美发卡订单，创建订单之后才能针对美发卡订单进行支付
+(void) createHdcOrder:(void(^)(HdcOrder *order, NSError *error))completionBlock
                userId:(int)userId
    hairDressingCardId:(int)hairDressingCardId
        organizationId:(int)organizationId
              hdcCount:(int)hdcCount
         redEnvelopeId:(int)redEnvelopeId
             stylistId:(int)stylistId;

+(void) updateUserHdcOrder:(void(^)(UserHdc *order, NSError *error))completionBlock
                userId:(int)userId
        hdcOrderItemId:(int)hdcOrderItemId
         redEnvelopeId:(int)redEnvelopeId;

+(void) getUserHdcByUserId:(void(^)(Page *page, NSError *error))completionBlock
            userId:(int)userId
            pageNo:(int)pageNo
        cardStatus:(NSArray *)cardStatuses;

+(void) getUserHdcByUserHdcNums:(void(^)(NSArray *userHdcs, NSError *error))completionBlock
                    userHdcNums:(NSString *)userHdcNum;
    
+(void) updateUserHdcStatus:(void(^)(NSError *error))completionBlock
                userHdcNums:(NSArray *)userHdcNums
                 hdcStatus:(int)hdcStatus;

+(void) searcherHdcsByOrganizationIds:(void(^)(NSArray *hdcs , NSError *error))completionBlock
                      organizationIds:(NSArray *)organizationIds
                   organizationFilter:(OrganizationFilter *)organizationFilter;

+(void) getHdcTypeByBusinessCircleId:(void(^)(NSArray *hdcTypes, NSError *error))completionBlock
                         businessCirclesId:(int)businessCirclesId;


@end
