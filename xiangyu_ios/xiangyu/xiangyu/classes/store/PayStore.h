//
//  PayStore.h
//  xiangyu
//
//  Created by 冯聪智 on 16/8/9.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WxPay.h"
#import "AliPay.h"
#import "YiPay.h"


@interface PayStore : NSObject


+ (PayStore *) sharedStore;


-(void)payWxOrder:(void (^)(NSDictionary *weixinPayInfo ,NSError *err))completionBlock
        orderType:(NSString *)orderType
             type:(NSString *)type
       payChannel:(NSString *)payChannel
           openId:(NSString *)openId
        payAmount:(NSString *)payAmount
   payInfoDtoList:(NSMutableArray *)payInfoDtoList;

-(void)payAliOrder:(void (^)(AliPay *aliPay ,NSError *err))completionBlock
         orderType:(NSString *)orderType
              type:(NSString *)type
        payChannel:(NSString *)payChannel
         payAmount:(NSString *)payAmount
    payInfoDtoList:(NSMutableArray *)payInfoDtoList;

-(void)payYiOrder:(void (^)(YiPay *yiPay ,NSError *err))completionBlock
        orderType:(NSString *)orderType
             type:(NSString *)type
       payChannel:(NSString *)payChannel
           openId:(NSString *)openId
        payAmount:(NSString *)payAmount
   payInfoDtoList:(NSMutableArray *)payInfoDtoList;

@end
