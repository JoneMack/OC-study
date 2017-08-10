//
//  MessageHandler.h
//  DrAssistant
//
//  Created by hi on 15/9/9.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "ChatListUserEntity.h"
@interface MessageHandler : BaseHandler

+ (void)getAdsListReq:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
+ (void) getUserInfoByUserAccount:(NSString *)account success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;
@end
