//
//  LoginHandler.h
//  DrAssistant
//
//  Created by hi on 15/8/28.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "LoginEntity.h"
#import "ThirdLoginEntity.h"
@interface LoginHandler : BaseHandler

+ (void)loginRequestWithLoginInfo:(LoginEntity *)loginInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;
+ (void)getAllOrgs;
+ (void)getAllOrgsSuccess:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;



+ (void)thirdLoginRequestWithLoginInfo:(ThirdLoginEntity *)loginEntity success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;


@end
