//
//  MyClubHandler.h
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "MyClubEntity.h"
#import "ZhuanJiaEntity.h"

@interface MyClubHandler : BaseHandler

+ (void)requestMyClubs:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;

+ (void)requestZhuanJiaListWithClubID:(NSString *)clubID success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
+(void)joinUserClub:(NSString *)clubID :(NSString*)userID :(NSString*)attention success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
@end
