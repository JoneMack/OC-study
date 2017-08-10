//
//  OwnerDepositStore.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/29.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OwnerDeposit.h"

@interface OwnerDepositStore : NSObject

+ (OwnerDepositStore *) sharedStore;



//提交委托出租
-(void) rentDelegate:(void (^)(NSError *err))completionBlock params:(NSMutableDictionary *)params;

@end
