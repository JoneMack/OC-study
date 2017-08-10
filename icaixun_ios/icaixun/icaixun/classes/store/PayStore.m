//
//  PayStore.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/11.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "PayStore.h"

@implementation PayStore

+(void) genPrePay:(void (^)(NSDictionary *weixinPrePay , NSError *err))completionBlock
           userId:(NSString *)userId
            orderNo:(NSString *)orderNo
        payAmount:(NSString *)payAmount
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:payAmount forKey:@"payAmount"];
    [params setObject:orderNo forKey:@"orderNo"];
    [params setObject:@"00000001" forKey:@"orderNum"];
    [params setObject:[AppStatus sharedInstance].user.name forKey:@"buyer"];
    [params setObject:@"财币充值" forKey:@"desc"];
    [params setObject:@"APP" forKey:@"tradeType"];
    [params setObject:userId forKey:@"userId"];

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].paymentUrl, @"/tenpay"]];
    [requestFacade doPost:url completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSLog(@"payment result:%@", json);
            NSDictionary *weixinPrePay = [json objectFromJSONString];
            completionBlock(weixinPrePay, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}


+(void) postNewOrder:(void (^)(PointOrder * , NSError *)) completionBlock userId:(NSString *)userId point:(NSString *)point payAmount:(NSString *)payAmount
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:point forKey:@"point"];
    [params setObject:payAmount forKey:@"amount"];
    
    NSString *url = [NSString stringWithFormat:@"/userPointItem/userId,%@/order" , userId];
    [requestFacade post:url completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSDictionary *dict = [json objectFromJSONString];
            PointOrder *pointOrder = [[PointOrder alloc] initWithDictionary:dict
                                                                      error:nil];
            completionBlock(pointOrder, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}

+(void) getPaymentType:(void (^)(NSDictionary *paymentType , NSError *err))commpletionBlock{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:@"/appInfo" completionBlock:^(NSString *json, NSError *err) {
        NSLog(@">>>>>>>>>>>>>>>>是否可以充值>>>>>>>>>>>%@",json);
        if (json != nil) {
            NSDictionary *dict = [json objectFromJSONString];
            commpletionBlock(dict, nil);
        }else{
            commpletionBlock(nil, err);
        }
        
    } refresh:YES useCacheIfNetworkFail:YES];
}


@end
