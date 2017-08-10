//
//  PayStore.m
//  xiangyu
//
//  Created by 冯聪智 on 16/8/9.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "PayStore.h"
#import "WxPay.h"
#import "AliPay.h"
#import "YiPay.h"

@implementation PayStore

+ (PayStore *) sharedStore{
    
    static PayStore *payStore = nil;
    if(!payStore){
        payStore = [[super allocWithZone:nil] init];
    }
    return payStore;
}


-(void)payWxOrder:(void (^)(NSDictionary *weixinPayInfo ,NSError *err))completionBlock
      orderType:(NSString *)orderType
           type:(NSString *)type
     payChannel:(NSString *)payChannel
         openId:(NSString *)openId
      payAmount:(NSString *)payAmount
 payInfoDtoList:(NSMutableArray *)payInfoDtoList{
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:orderType forKey:@"orderType"];
    [params setObject:type forKey:@"type"];
    [params setObject:payChannel forKey:@"payChannel"];
    [params setObject:openId forKey:@"openId"];
    [params setObject:payAmount forKey:@"payAmount"];
    [params setObject:payInfoDtoList forKey:@"payInfoDtoList"];
    
    [requestFacade postForDataWithoutDeviceType:[NSString stringWithFormat:@"%@/pay/payReq",[AppStatus sharedInstance].apiUrl]
               completionBlock:^(id json, NSError *err) {
                   
                if(json != nil){
                    
                    NSDictionary *jsonDict = json;
                    NSDictionary *wxDict = [jsonDict valueForKey:@"data"];
                    completionBlock(wxDict , nil);
                    
                }else if(err != nil){
                    completionBlock(nil , err);
                }
    } commonParams:params];
    


}

-(void)payAliOrder:(void (^)(AliPay *aliPay ,NSError *err))completionBlock
        orderType:(NSString *)orderType
             type:(NSString *)type
       payChannel:(NSString *)payChannel
        payAmount:(NSString *)payAmount
   payInfoDtoList:(NSMutableArray *)payInfoDtoList{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:orderType forKey:@"orderType"];
    [params setObject:type forKey:@"type"];
    [params setObject:payChannel forKey:@"payChannel"];
    [params setObject:payAmount forKey:@"payAmount"];
    [params setObject:payInfoDtoList forKey:@"payInfoDtoList"];
    
    NSLog(@"支付参数:%@" , params);
    
    
    [requestFacade postForDataWithoutDeviceType:[NSString stringWithFormat:@"%@/pay/payReq",[AppStatus sharedInstance].apiUrl] completionBlock:^(id json, NSError *err) {
        if(json != nil){
            NSLog(@">>>>>>>>请求支付返回：%@",json);
            
            NSDictionary *jsonDict = json;
            NSDictionary *circleDict = [jsonDict valueForKey:@"data"];
            AliPay *aliPay = [[AliPay alloc] initWithDictionary:circleDict error:nil];
            NSLog(@">>>>>>>>请求支付返回aliPay：%@",aliPay);
//            if([jsonDict valueForKey:@"success"] == 1){
                completionBlock( aliPay , nil);
//            }

        }else if(err != nil){
            completionBlock(nil , err);
        }
        
    } commonParams:params];

}

-(void)payYiOrder:(void (^)(YiPay *yiPay ,NSError *err))completionBlock
        orderType:(NSString *)orderType
             type:(NSString *)type
       payChannel:(NSString *)payChannel
           openId:(NSString *)openId
        payAmount:(NSString *)payAmount
   payInfoDtoList:(NSMutableArray *)payInfoDtoList{
    
}

@end
