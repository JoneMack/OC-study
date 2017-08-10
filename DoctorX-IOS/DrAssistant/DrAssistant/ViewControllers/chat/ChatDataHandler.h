//
//  ChatDataHandler.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/31.
//  Copyright © 2015年 Doctor. All rights reserved.
//
#import "BaseHandler.h"
#import <Foundation/Foundation.h>

@interface ChatDataHandler : BaseHandler

+ (void)putAssistantServiceByAccountId:(NSString *)accountId sendId:(NSString *)sendId  acceptId:(NSString *)acceptId msgType:(NSString *)msgType msgContent:(NSString *)msgContent success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;


@end
