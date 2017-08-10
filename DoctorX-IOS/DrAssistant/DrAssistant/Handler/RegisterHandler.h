//
//  RegisterHandler.h
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "RegisterEntityRequest.h"
#import "ThirdRegisterEntityRequest.h"
@interface RegisterHandler : BaseHandler

+ (void)registerRequestWithRegisterInfo:(RegisterEntityRequest *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;
+ (void)ownServerRegisterInfo:(RegisterEntityRequest *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;
+ (void)thirdPlatformRegisterInfo:(ThirdRegisterEntityRequest *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;

+ (void)getUserInfoByUid:(NSString *)token success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;

@end
