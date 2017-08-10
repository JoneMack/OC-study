//
//  PayStore.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/11.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointOrder.h"

@interface PayStore : NSObject

+(void) genPrePay:(void (^)(NSDictionary *weixinPrePay , NSError *err))completionBlock
           userId:(NSString *)userId
          orderNo:(NSString *)orderNo
        payAmount:(NSString *)payAmount;


+(void) postNewOrder:(void (^)(PointOrder * , NSError *))commpletionBlock
              userId:(NSString *)userId
               point:(NSString *)point
           payAmount:(NSString *)payAmount;

+(void) getPaymentType:(void (^)(NSDictionary *paymentType , NSError *err))commpletionBlock;

@end
