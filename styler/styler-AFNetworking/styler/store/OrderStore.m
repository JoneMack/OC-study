//
//  OrderStore.m
//  styler
//
//  Created by System Administrator on 13-6-11.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "OrderStore.h"
#import "OrderedTimeRange.h"
#import "OrderedHour.h"
#import "OrderedTime.h"

@implementation OrderStore


-(void) placeOrder:(void (^)(ServiceOrder *, NSError *))completionBlock orderTime:(NSDate *)orderTime stylistId:(int)stylistId workId:(int)workId serviceItemIds:(NSArray *)serviceItemIds specialEvent:(int)specialEvent address:(NSString *)address{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:@"/my/serviceOrders?"];
    if(workId > 0){
        [urlStr appendFormat:@"expertWorkId=%d&", workId];
    }
    
    for(int i = 0; i < serviceItemIds.count; i++){
        [urlStr appendFormat:@"organizationServiceItemId=%@&", serviceItemIds[i]];
    }
    
    AppStatus *as = [AppStatus sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(stylistId) forKey:@"expertId"];
    [params setObject:[NSString stringWithFormat:@"%.0f", [orderTime timeIntervalSince1970]*1000] forKey:@"scheduleTime"];
    [params setObject:[NSString stringWithFormat:@"%d", specialEvent] forKey:@"specialRemark"];
    if (address!=nil) {
        [params setObject:address forKey:@"address"];
    }
    [params setObject:[NSString stringWithFormat:@"%f,%f", as.lastLat, as.lastLng] forKey:@"poi"];
    [requestFacade post:urlStr completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            ServiceOrder *order = [[ServiceOrder alloc] initWithString:json error:nil];
            completionBlock(order, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}

-(void) submitOrder:(void (^)(ServiceOrder *order, NSError *err)) completionBlock
    newServiceOrder:(NewServiceOrder *)newServiceOrder{
    NSString *url = @"/serviceOrders";
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[newServiceOrder toJSONString] forKey:@"newOrderServiceTO"];
    [requestFacade post:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            ServiceOrder *order = [[ServiceOrder alloc] initWithString:json error:nil];
            completionBlock(order, nil);
        }else{
            completionBlock(nil, err);
        }
    } jsonString:[newServiceOrder toJSONString]];
}

-(void) getOrderedHours:(void (^)(NSArray *orderedHours, NSError *err))completionBlock
                   stylistId:(int)stylistId{
    NSString *urlStr = [NSString stringWithFormat:@"/stylists/%d/orderedHours", stylistId];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        NSArray *dictArray = [json objectFromJSONString];
        NSArray<OrderedHour> *orderedHours = (NSArray<OrderedHour>*)[OrderedHour arrayOfModelsFromDictionaries:dictArray];
        completionBlock(orderedHours, nil);
    } refresh:YES useCacheIfNetworkFail:NO];
}

-(void) getOrderedTime:(void (^)(NSArray *orderedTimes, NSError *err))completionBlock
             stylistId:(int)stylistId{
    NSString *urlStr = [NSString stringWithFormat:@"/stylists/%d/orderedTimes", stylistId];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        NSArray *dictArray = [json objectFromJSONString];
        NSArray<OrderedTime> *orderedTime = (NSArray<OrderedTime>*)[OrderedTime arrayOfModelsFromDictionaries:dictArray];
        completionBlock(orderedTime, nil);
    } refresh:YES useCacheIfNetworkFail:NO];
}

-(void) getMyOrders:(void (^)(Page *page, NSError *err))completionBlock{
    NSString *urlStr = [NSString stringWithFormat:@"/serviceOrders/searcher?userId=%@", [AppStatus sharedInstance].user.idStr];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *dict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:dict];
            
            NSArray *orderDictArray = [dict objectForKey:@"items"];
            NSMutableArray *orderArray = [[NSMutableArray alloc] init];
            for (NSDictionary *orderDict in orderDictArray) {
                NSError *err = nil;
                ServiceOrder *order = [[ServiceOrder alloc] initWithDictionary:orderDict error:&err];
                if (err != nil) {
                    NSLog(@"反序列化ServiceOrder错误:  %@", err);
                }
                [orderArray addObject:order];
            }
            page.items = orderArray;
            completionBlock(page, nil);
        }else{
            completionBlock(nil, err);
        }
        
    } refresh:YES useCacheIfNetworkFail:NO];
}

-(void)getMyOrders:(void (^)(Page *, NSError *))completionBlock pageNo:(int)pageNo pageSize:(int)pageSize{
    NSString *urlStr = [NSString stringWithFormat:@"/serviceOrders/searcher?userId=%@&pageNo=%d&pageSize=%d", [AppStatus sharedInstance].user.idStr, pageNo, pageSize];
//     NSLog(@">>>>>urlStr>>>>>>>>>>>%@",urlStr);
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *dict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:dict];
            
            NSArray *orderDictArray = [dict objectForKey:@"items"];
            NSMutableArray *orderArray = [[NSMutableArray alloc] init];
            for (NSDictionary *orderDict in orderDictArray) {
                NSError *err = nil;
                ServiceOrder *order = [[ServiceOrder alloc] initWithDictionary:orderDict error:&err];
                if (err != nil) {
                    NSLog(@"反序列化ServiceOrder错误:  %@", err);
                }
                [orderArray addObject:order];
            }
            page.items = orderArray;
            completionBlock(page, nil);
        }else{
            completionBlock(nil, err);
        }
        
    } refresh:YES useCacheIfNetworkFail:NO];
}

-(void) getMyOrder:(void (^)(ServiceOrder *order, NSError *err))completionBlock orderId:(int)orderId{
    NSString *urlStr = [NSString stringWithFormat:@"/serviceOrders/orderId,%d", orderId];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        ServiceOrder *order = [[ServiceOrder alloc] initWithString:json error:nil];
        completionBlock(order, nil);
    } refresh:YES useCacheIfNetworkFail:YES];
}

-(void) getOrderPrice:(void (^)(NSDictionary * dic, NSError *err))completionBlock stylistId:(int)stylistId andStylistWordId:(NSString *)stylistWorkId andServiceItem:(NSArray*)serviceItems
{
    NSString *urlStr = [NSString stringWithFormat:@"/my/orderPriceComputer?"];
    if (stylistWorkId != nil) {
        urlStr = [urlStr stringByAppendingFormat:@"expertWorkId=%@&expertId=%d",stylistWorkId, stylistId];
    }else
    {
        urlStr = [urlStr stringByAppendingFormat:@"expertId=%d", stylistId];
    }
    for (int i = 0; i < serviceItems.count; i++) {
        urlStr = [urlStr stringByAppendingFormat:@"&organizationServiceItemId=%@",[serviceItems objectAtIndex:i]];
    }
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
       
        NSDictionary *dict = [json objectFromJSONString];
        completionBlock(dict, nil);
    } refresh:YES useCacheIfNetworkFail:YES];
}

+ (OrderStore *) sharedStore{
    static OrderStore *orderStore = nil;
    if(!orderStore){
        orderStore = [[super allocWithZone:nil] init];
    }
    return orderStore;
}

+(id) allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

@end
