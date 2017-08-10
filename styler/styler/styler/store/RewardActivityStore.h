//
//  RewardActivityStore.h
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardActivity.h"
#import "ShareSceneType.h"
#import "UserAction.h"
#import "RewardObject.h"

@interface RewardActivityStore : NSObject

+(void) getRewardActivity:(void(^)(RewardActivity *rewardActivity ,NSError *error))completionBlock
               actionType:(int)actionType
                startTime:(NSNumber *)startTime;

+(void) getUserAction:(void(^)(UserAction *userAction, NSError *error))completionBlock userActionId:(int)userActionId;

+(void) postUserAction:(void(^)(UserAction *userAction, NSError *error))completionBlock shareSceneType:(ShareSceneType *)shareSceneType;

+(void) getRewardObjectByActionId:(void(^)(RewardObject *rewardObject, NSError *error))completionBlock ActionId:(int)actionId;

+(void)postNewCustomer:(void (^)(NSError *))completionBlock mobileNo:(NSString *)mobileNo actionId:(int)actionId;
@end
