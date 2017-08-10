//
//  MyDoctorHandler.h
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "UserEntity.h"

@interface MyDoctorHandler : BaseHandler
+ (void)requestDoctorList:(RequestSuccessBlock) success fail:(RequestFailBlock)fail;
@end
