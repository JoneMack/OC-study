//
//  UserAction.h
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareSceneType.h"

@protocol UserAction

@end

@interface UserAction : JSONModel

@property int id;
@property int userId;
@property int actionType;
@property (nonatomic , strong) NSDictionary<Optional> *actionParams;
@property int rewardStatus;

-(id) initWithActionType:(ShareSceneType *) shareSceneType;

-(NSString *) getJsonString;

@end
