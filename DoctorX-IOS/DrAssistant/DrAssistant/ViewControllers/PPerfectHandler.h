//
//  PPerfectHandler.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "PPerfectEntity.h"

@interface PPerfectHandler : BaseHandler

+ (void)pPerfectRequestWithLoginInfo:(PPerfectEntity *)loginInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;

@end
