//
//  RewardObject.h
//  styler
//
//  Created by 冯聪智 on 14-9-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedEnvelope.h"

@protocol RewardObject
@end


@interface RewardObject : JSONModel

@property (nonatomic, assign) int rewardType;
@property (nonatomic, strong) RedEnvelope *reward;

@end


