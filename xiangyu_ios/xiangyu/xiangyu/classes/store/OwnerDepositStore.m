//
//  OwnerDepositStore.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/29.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "OwnerDepositStore.h"

@implementation OwnerDepositStore


+ (OwnerDepositStore *) sharedStore{
    static OwnerDepositStore *ownerDepositStore = nil;
    if(!ownerDepositStore){
        ownerDepositStore = [[super allocWithZone:nil] init];
    }
    
    return ownerDepositStore;
}


//提交委托出租
-(void) rentDelegate:(void (^)(NSError *err))completionBlock params:(NSMutableDictionary *)params{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:params forKey:@"data"];
    
    
    [requestFacade postForData:[NSString stringWithFormat:@"%@/owner/deposit",[AppStatus sharedInstance].apiUrl]
               completionBlock:^(id json, NSError *err) {
        
        if(json != nil){
            completionBlock(nil);
        }else if(err != nil){
            completionBlock(err);
        }
    } commonParams:dataParams];
    
    
}




@end
