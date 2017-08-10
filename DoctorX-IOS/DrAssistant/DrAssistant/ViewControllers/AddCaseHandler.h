//
//  AddCaseHandler.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "AddCaseEntity.h"

@interface AddCaseHandler : BaseHandler

+ (void)myCaseRequestWithAddCaseInfo:(AddCaseEntity *)addCaseInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;

+ (void)myCaseUpLoadImageWithsuccess:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;

@end
