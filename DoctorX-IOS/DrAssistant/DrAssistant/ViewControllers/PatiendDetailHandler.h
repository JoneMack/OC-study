//
//  PatiendDetailHandler.h
//  DrAssistant_FBB
//
//  Created by Seiko on 15/9/30.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"

@interface PatiendDetailHandler : BaseHandler

+ (void)patiendDetailWithInfo:(NSString *)name type:(NSInteger)type success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;

@end
