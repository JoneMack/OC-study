//
//  ValidateCodeHandler.h
//  DrAssistant
//
//  Created by hi on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "PostCaptchasResponse.h"

@interface ValidateCodeHandler : BaseHandler

+ (void)getValidateCodeWith:(NSString *)phone success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;

@end
