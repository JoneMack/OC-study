//
//  WXPayProcessor.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/11.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXPayProcessor : NSObject <WXApiDelegate>


@property (nonatomic , copy) NSString *point;

+ (WXPayProcessor *) sharedInstance;

-(void) payPoint:(void (^)(NSError *err))completionBlock
          userId:(NSString *)userId
         orderNo:(NSString *)orderNo
       payAmount:(NSString *)payAmount;

@end
