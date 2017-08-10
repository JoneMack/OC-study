//
//  HouseStore.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/22.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseStore.h"

@implementation HouseStore


+ (HouseStore *) sharedStore{
    static HouseStore *houseStore = nil;
    if(!houseStore){
        houseStore = [[super allocWithZone:nil] init];
    }
    
    return houseStore;
}


-(void) getHouses:(void(^)(NSArray<House *> *houses, NSError *err))completionBlock params:(NSMutableDictionary *)params {

    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    
    NSString *url = [NSString stringWithFormat:@"/houseList"];
    [requestFacade get:url completionBlock:^(id json, NSError *err) {

        if(err == nil){
            NSDictionary *jsonDict = json;
            NSArray<House *> *houses = [House arrayOfModelsFromDictionaries:[jsonDict valueForKey:@"data"]];
            completionBlock( houses  , nil);
        
        }else{
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
    
}

-(void) getRecommendHouses:(void(^)(NSArray<House *> *houses, NSError *err))completionBlock
                   houseId:(NSString *)houseId
                    roomId:(NSString *)roomId
                  rentType:(NSString *)rentType
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:houseId forKey:@"houseId"];
    [params setValue:roomId forKey:@"roomId"];
    [params setValue:rentType forKey:@"rentType"];
    
    NSString *url = [NSString stringWithFormat:@"/recommendHouseList"];
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            NSArray<House *> *houses = [House arrayOfModelsFromDictionaries:[jsonDict valueForKey:@"data"]];
            completionBlock( houses  , nil);
            
        }else{
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];

}


-(void) getHouseInfo:(void(^)(HouseInfo *houseInfo, NSError *err))completionBlock
             houseId:(NSString *)houseId
              roomId:(NSString *)roomId
            rentType:(NSString *)rentType{

    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:houseId forKey:@"houseId"];
    [params setValue:roomId forKey:@"roomId"];
    [params setValue:rentType forKey:@"rentType"];
    
    NSString *url = [NSString stringWithFormat:@"/houseDetail"];
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *dic = json;
            NSDictionary *houseDetailDict = [dic valueForKey:@"data"];
            
            HouseInfo *houseInfo = [[HouseInfo alloc] initWithDictionary:houseDetailDict error:nil];
            completionBlock(houseInfo , nil);
        }else{
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
    
}

/**
 * 获取房租的租期
 */
-(void) getRentPeriod:(void(^)(NSDictionary *rentPeriod, NSError *err))completionBlock
              houseId:(NSString *)houseId
               roomId:(NSString *)roomId
             rentType:(NSString *)rentType
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:houseId forKey:@"houseId"];
    [params setValue:roomId forKey:@"roomId"];
    [params setValue:rentType forKey:@"rentType"];
    
    NSString *url = [NSString stringWithFormat:@"/tenant/getRentPeriod"];
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *dic = json;
            NSDictionary *rentPeriod = [dic valueForKey:@"data"];
            completionBlock(rentPeriod , nil);
        }else{
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
    
}

/**
 * 获取付款方式
 */
-(void) getPaymentPattern:(void(^)(NSArray *payTypes, NSError *err))completionBlock
                  houseId:(NSString *)houseId
                   roomId:(NSString *)roomId
                 rentType:(NSString *)rentType
             sfContractId:(NSString *)sfContractId{

    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:houseId forKey:@"houseId"];
    [params setValue:roomId forKey:@"roomId"];
    [params setValue:rentType forKey:@"rentType"];
    [params setValue:sfContractId forKey:@"sfContractId"];
    
    NSLog(@"获取付款方式:%@" , params);
    
    NSString *url = [NSString stringWithFormat:@"/tenant/getPaymentPattern"];
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"-------------------------======================>请求成功");
            NSDictionary *dic = json;
            NSArray *payTypes = [dic valueForKey:@"data"];
            completionBlock(payTypes , nil);
        }else{
            NSLog(@"-------------------------======================>请求失败");
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
    
}

-(void) postAppointment4House:(void(^)(NSError *err))completionBlock params:(NSMutableDictionary *)params{
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:params forKey:@"data"];
    
    NSString *url = [NSString stringWithFormat:@"%@/tenant/appointment" , [AppStatus sharedInstance].apiUrl];
    
    [requestFacade postForData:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            completionBlock(nil);
        }else{
            completionBlock(err);
        }
    } commonParams:dataParams];
}


// 收藏房源
-(void) removeFavHouseInfo:(void(^)(NSError *err))completionBlock collectionIds:(NSMutableDictionary *)collectionIds
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:collectionIds forKey:@"data"];
    
    NSString *url = [NSString stringWithFormat:@"%@/my/delCollection",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade postForData:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"-------删除收藏------%@",json);
            completionBlock(nil);
        }else{
            completionBlock(err);
        }
    } commonParams:dataParams];
}
//进行中的约看
-(void) getUserUnfinishedOrderList:(void(^)(NSArray *userOrderDetails, NSError *err))completionBlock
                           pageNum:(NSString *)pageNum{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:pageNum forKey:@"pageNum"];
    [dataParams setObject:@"1000400020004" forKey:@"orderType"];
    
    NSString *url = [NSString stringWithFormat:@"%@/userOrders/userUnfinishedOrderList",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade post:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"-------进行中的约看------%@",json);
            NSDictionary *dic = json;
            NSDictionary *dataDict = [dic valueForKey:@"data"];
            NSArray *userOrderDetails = dataDict[@"list"];
            NSLog(@"-------进行中的约看userOrderDetails------%@",userOrderDetails);
            completionBlock(userOrderDetails,nil);
        }else{
            completionBlock(nil,err);
        }
    } jsonString:dataParams];
    
}

//已完成的约看
-(void) getUserfinishedOrderList:(void(^)(NSArray *userOrderDetails, NSError *err))completionBlock
                         pageNum:(NSString *)pageNum{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:pageNum forKey:@"pageNum"];
    [dataParams setObject:@"1000400020004" forKey:@"orderType"];
    
    NSString *url = [NSString stringWithFormat:@"%@/userOrders/userFinishedOrderList",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade post:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"-------已完成的约看------%@",json);
            NSDictionary *dic = json;
            NSDictionary *dataDict = [dic valueForKey:@"data"];
            NSArray *userOrderDetails = dataDict[@"list"];
            NSLog(@"-------已完成的约看userOrderDetails------%@",userOrderDetails);
            completionBlock(userOrderDetails,nil);
        }else{
            completionBlock(nil,err);
        }
    } jsonString:dataParams];
}

-(void) removeOrderHouseInfo:(void(^)(NSError *err))completionBlock ids:(NSString *)ids{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:ids forKey:@"ids"];
    
    NSString *url = [NSString stringWithFormat:@"%@/tenant/cancalAppointment",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade postForData:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"-------删除收藏------%@",json);
            completionBlock(nil);
        }else{
            completionBlock(err);
        }
    } commonParams:dataParams];
}


// 收藏房源
-(void) postFavHouseInfo:(void(^)(NSError *err))completionBlock param:(NSMutableDictionary *)params
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:params forKey:@"data"];
    
    NSString *url = [NSString stringWithFormat:@"%@/my/addCollection",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade postForData:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            completionBlock(nil);
        }else{
            completionBlock(err);
        }
    } commonParams:dataParams];
    
}





// 收藏房源
-(void) getFavHouseInfos:(void(^)(NSArray *houseInfos, NSError *err))completionBlock
                 pageNum:(NSString *)pageNum
                       x:(NSString *)x
                       y:(NSString *)y{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:pageNum forKey:@"pageNum"];
    [params setValue:x forKey:@"x"];
    [params setValue:y forKey:@"y"];
    NSString *url = [NSString stringWithFormat:@"/my/collectionList"];
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            NSLog(@">>>>>>收藏数据>>>>>>%@",jsonDict);
            NSArray *houses = [jsonDict valueForKey:@"data"];
            completionBlock( houses  , nil);
            
        }else{
            completionBlock(nil , err);
        }
    } params:params refresh:NO useCacheIfNetworkFail:NO];
    
}



// 保存租房合同
-(void) saveCfContractXS:(void(^)(NSMutableDictionary *result , NSError *err))completionBlock param:(NSMutableDictionary *)params{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:params forKey:@"data"];
    
    NSString *url = [NSString stringWithFormat:@"%@/tenant/saveCfContractXS",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade postForData:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            completionBlock(json , nil);
        }else{
            completionBlock(json , err);
        }
    } commonParams:dataParams];
    
}

// 获取临时合同
-(void) getPreviewCfContractXS:(void(^)(NSMutableDictionary *result , NSError *err))completionBlock
                    contractId:(NSString *)contractId
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:contractId forKey:@"contractId"];
    NSString *url = [NSString stringWithFormat:@"%@/print/contract/getPreviewCfContractXS?contractId=%@&token=%@",[AppStatus sharedInstance].apiUrl , contractId , [AppStatus sharedInstance].token];
    
    [requestFacade post:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"请求成功");
            NSLog(@">>> %@" , json);
        }else{
            NSLog(@"请求失败");
        }
    } commonParams:nil];
}


// 获取在线合同信息
-(void) getCfContractXS:(void(^)(CfContractXS *cfContractXS , NSError *err))completionBlock
             contractId:(NSString *)contractId
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:contractId forKey:@"contractId"];
    NSString *url = @"/tenant/getCfContractXS";
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            NSDictionary *houseDetailDict = [jsonDict valueForKey:@"data"];
            CfContractXS *cfContractXS = [[CfContractXS alloc] initWithDictionary:houseDetailDict error:nil];
            completionBlock( cfContractXS  , nil);
        }else{
            completionBlock(nil , err);
        }
    } params:params refresh:NO useCacheIfNetworkFail:NO];
}





@end
