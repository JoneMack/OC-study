//
//  ExpertStore.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/6.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserExpertRelation.h"
#import "ExpertQuery.h"

@interface ExpertStore : NSObject

+(void) getExperts:(void (^)(NSArray *experts, NSError *err))completionBlock query:(ExpertQuery *)query;

+(void) getMyAttentionExperts:(void (^)(NSArray *experts, NSError *err))completionBlock;



@end
