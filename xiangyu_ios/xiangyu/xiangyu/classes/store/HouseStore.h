//
//  HouseStore.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/22.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"
#import "HouseInfo.h"
#import "CfContractXS.h"

@interface HouseStore : NSObject


+ (HouseStore *) sharedStore;


-(void) getHouses:(void(^)(NSArray<House *> *houses, NSError *err))completionBlock params:(NSMutableDictionary *)params;

-(void) getRecommendHouses:(void(^)(NSArray<House *> *houses, NSError *err))completionBlock
              houseId:(NSString *)houseId
               roomId:(NSString *)roomId
             rentType:(NSString *)rentType;

-(void) getHouseInfo:(void(^)(HouseInfo *houseInfo, NSError *err))completionBlock
             houseId:(NSString *)houseId
              roomId:(NSString *)roomId
            rentType:(NSString *)rentType;


-(void) getRentPeriod:(void(^)(NSDictionary *rentPeriod, NSError *err))completionBlock
             houseId:(NSString *)houseId
              roomId:(NSString *)roomId
            rentType:(NSString *)rentType;

-(void) getPaymentPattern:(void(^)(NSArray *payTypes, NSError *err))completionBlock
                  houseId:(NSString *)houseId
                   roomId:(NSString *)roomId
                 rentType:(NSString *)rentType
             sfContractId:(NSString *)sfContractId;


-(void) postAppointment4House:(void(^)(NSError *err))completionBlock params:(NSMutableDictionary *)params;

// 收藏房源
-(void) postFavHouseInfo:(void(^)(NSError *err))completionBlock param:(NSMutableDictionary *)params;


// 删除房源
-(void) removeFavHouseInfo:(void(^)(NSError *err))completionBlock collectionIds:(NSMutableDictionary *)collectionIds;
//orderId
-(void) removeOrderHouseInfo:(void(^)(NSError *err))completionBlock ids:(NSString *)ids;


// 收藏房源
-(void) getFavHouseInfos:(void(^)(NSArray *houseInfos, NSError *err))completionBlock
                 pageNum:(NSString *)pageNum
                       x:(NSString *)x
                       y:(NSString *)y;

//进行中的约看
-(void) getUserUnfinishedOrderList:(void(^)(NSArray *userOrderDetails, NSError *err))completionBlock
                 pageNum:(NSString *)pageNum;
//已完成的约看
-(void) getUserfinishedOrderList:(void(^)(NSArray *userOrderDetails, NSError *err))completionBlock
                         pageNum:(NSString *)pageNum;
// 保存租房合同
-(void) saveCfContractXS:(void(^)(NSMutableDictionary *result , NSError *err))completionBlock param:(NSMutableDictionary *)params;

// 获取临时合同
-(void) getPreviewCfContractXS:(void(^)(NSMutableDictionary *result , NSError *err))completionBlock
                    contractId:(NSString *)contractId;

// 获取在线合同信息
-(void) getCfContractXS:(void(^)(CfContractXS *cfContractXS , NSError *err))completionBlock
             contractId:(NSString *)contractId;

@end
