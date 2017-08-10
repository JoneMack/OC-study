//
//  FindPasswordHanlder.h
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "FindPasswordEntity.h"

@interface FindPasswordHanlder : BaseHandler

+ (void)FindRequestWithFindPasswordInfo:(FindPasswordEntity *)registerInfo success:(RequestSuccessBlock)success fail:(RequestFailBlock)failure;

@end
