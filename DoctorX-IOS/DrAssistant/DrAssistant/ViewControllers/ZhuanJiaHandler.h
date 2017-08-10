//
//  ZhuanJiaHandler.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "ZhuanJiaEntity.h"
#import "MyClubEntity.h"

@interface ZhuanJiaHandler : BaseHandler
+ (void)requestZhuanJiaListWithClubID:(MyClubEntity *)club success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
@end
